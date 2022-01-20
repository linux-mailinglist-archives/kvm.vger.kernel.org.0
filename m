Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043B049534F
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 18:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbiATRby (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 12:31:54 -0500
Received: from ppsw-43.csi.cam.ac.uk ([131.111.8.143]:37742 "EHLO
        ppsw-43.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbiATRbx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 12:31:53 -0500
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: https://help.uis.cam.ac.uk/email-scanner-virus
Received: from hades.srcf.societies.cam.ac.uk ([131.111.179.67]:52870)
        by ppsw-43.csi.cam.ac.uk (ppsw.cam.ac.uk [131.111.8.139]:25)
        with esmtps (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        id 1nAbHT-000avl-p0 (Exim 4.95)
        (return-path <amc96@srcf.net>);
        Thu, 20 Jan 2022 17:31:27 +0000
Received: from [192.168.1.10] (host-92-12-61-86.as13285.net [92.12.61.86])
        (Authenticated sender: amc96)
        by hades.srcf.societies.cam.ac.uk (Postfix) with ESMTPSA id 77E1D1FC61;
        Thu, 20 Jan 2022 17:31:27 +0000 (GMT)
Message-ID: <81aebe8e-ff2a-6b56-fe50-b7917a3948ed@srcf.net>
Date:   Thu, 20 Jan 2022 17:31:27 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-GB
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Alexander Graf <graf@amazon.de>,
        Andrew Cooper <andrew.cooper3@citrix.com>
References: <20220120000624.655815-1-seanjc@google.com>
 <f3239ec0-9fb8-722a-00c5-11b18f19f047@srcf.net> <YemPeqpcFDjhGfRQ@google.com>
From:   Andrew Cooper <amc96@srcf.net>
Subject: Re: [PATCH] KVM: VMX: Set vmcs.PENDING_DBG.BS on #DB in STI/MOVSS
 blocking shadow
In-Reply-To: <YemPeqpcFDjhGfRQ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/01/2022 16:36, Sean Christopherson wrote:
> On Thu, Jan 20, 2022, Andrew Cooper wrote:
>> On 20/01/2022 00:06, Sean Christopherson wrote:
>>> MOVSS blocking can be initiated by userspace, but can be coincident with
>>> a #DB if and only if DR7.GD=1 (General Detect enabled) and a MOV DR is
>>> executed in the MOVSS shadow.  MOV DR #GPs at CPL>0, thus MOVSS blocking
>>> is problematic only for CPL0 (and only if the guest is crazy enough to
>>> access a DR in a MOVSS shadow).  All other sources of #DBs are either
>>> suppressed by MOVSS blocking (single-step, code fetch, data, and I/O),
>> It is more complicated than this and undocumented.  Single step is
>> discard in a shadow, while data breakpoints are deferred.
> But for the purposes of making the consitency check happy, whether they are
> deferred or dropped should be irrelevant, no?

From that point of view, yes.  The consistency check is specific to TS. 
I suppose I was mostly questioning the wording of the explanation.

>>> are mutually exclusive with MOVSS blocking (T-bit task switch),
>> Howso?  MovSS prevents external interrupts from triggering task
>> switches, but instruction sources still trigger in a shadow.
> T-bit #DBs are traps, and arrive after the task switch has completed.  The switch
> can be initiated in the shadow, but the #DB will be delivered after the instruction
> retires and so after MOVSS blocking goes away.  Or am I missing something?

Well - this is where the pipeline RTL is needed, in lieu of anything
better.  Trap-style #DBs are part of the current instruction, and
specifically ahead (in the instruction cycle) of the subsequent intchk.

There are implementations where NMI/INTR/etc won't be delivered at the
head of an exception generated in a shadow, which would suggest that
these implementations have the falling edge of the shadow after intchk
on the instruction boundary.  (Probably certainly what happens is that
intchk is responsible for clearing the shadow, but this is entirely
guesswork on my behalf.)

>> and splitlock which is new since I last thought about this problem.
> Eww.  Split Lock is trap-like, which begs the question of what happens if the
> MOV/POP SS splits a cache line when loading the source data.  I'm guess it's
> suppressed, a la data breakpoints, but that'd be a fun one to test.

They're both reads of their memory operand, so aren't eligible to be
locked accesses.

However, a devious kernel can misalign the GDT/LDT such that setting the
descriptor access bit does trigger a splitlock.  I suppose "kernel
doesn't misalign structures", or "kernel doesn't write a descriptor with
the access bit clear" are both valid mitigations.

>>> This bug was originally found by running tests[1] created for XSA-308[2].
>>> Note that Xen's userspace test emits ICEBP in the MOVSS shadow, which is
>>> presumably why the Xen bug was deemed to be an exploitable DOS from guest
>>> userspace.
>> As I recall, the original report to the security team was something
>> along the lines of "Steam has just updated game, and now when I start
>> it, the VM explodes".
> Lovely.  I wonder if the game added some form of anti-cheat?  I don't suppose you
> have disassembly from the report?  I'm super curious what on earth a game would
> do to trigger this.

Anti-cheat was my guess too, but no disassembly happened.

I was already aware of the STI issue, and had posted
https://lore.kernel.org/xen-devel/1528120755-17455-11-git-send-email-andrew.cooper3@citrix.com/
more than a year previously.  The security report showed ICEBP pending
in the INTR_INFO field, and extending the STI test case in light of this
was all of 30s of work to get a working repro.

~Andrew

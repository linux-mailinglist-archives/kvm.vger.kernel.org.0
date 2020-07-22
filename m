Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B992292A2
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 09:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgGVHzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 03:55:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:36452 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726153AbgGVHzv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jul 2020 03:55:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8D778AEDA;
        Wed, 22 Jul 2020 07:55:56 +0000 (UTC)
Date:   Wed, 22 Jul 2020 09:55:46 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Mike Stunes <mstunes@vmware.com>
Cc:     Joerg Roedel <joro@8bytes.org>, "x86@kernel.org" <x86@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "hpa@zytor.com" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH v4 51/75] x86/sev-es: Handle MMIO events
Message-ID: <20200722075546.GG6132@suse.de>
References: <20200714120917.11253-1-joro@8bytes.org>
 <20200714120917.11253-52-joro@8bytes.org>
 <40D5C698-1ED2-4CCE-9C1D-07620A021A6A@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <40D5C698-1ED2-4CCE-9C1D-07620A021A6A@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Mike,

On Tue, Jul 21, 2020 at 09:01:44PM +0000, Mike Stunes wrote:
> I’m running into an MMIO-related bug when I try testing this on our hypervisor.
> 
> During boot, probe_roms (arch/x86/kernel/probe_roms.c) uses
> romchecksum over the video ROM and extension ROM regions. In my test
> VM, the video ROM romchecksum starts at virtual address
> 0xffff8880000c0000 and has length 65536. But, at address
> 0xffff8880000c4000, we switch from being video-ROM-backed to being
> unbacked by anything.
> 
> With SEV-ES enabled, our platform handles reads and writes to unbacked
> memory by treating them as MMIO. So, the read from 0xffff8880000c4000
> causes a #VC, which is handled by do_early_exception.
> 
> In handling the #VC, vc_slow_virt_to_phys fails for that address. My
> understanding is that the #VC handler should then add an entry to the
> page tables and retry the faulting access. Somehow, that isn’t
> happening. From the hypervisor side, it looks like the guest is
> looping somehow. (I think the VCPU is mostly unhalted and making
> progress, but the guest never gets past that romchecksum.) The guest
> never actually makes an MMIO vmgexit for that address.

That sounds like your guest is in a page-fault loop, but I can't yet
explain why. Can you please find out the instruction which is causing
the #VC exception?

If a page-fault happens during #VC emulation it is forwared to the
page-fault handler, so this should work. But somehow this isn't
happening or the page-fault handler can't map the faulting address.


Regards,

	Joerg

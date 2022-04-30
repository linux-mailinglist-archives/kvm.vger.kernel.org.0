Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A942515EF3
	for <lists+kvm@lfdr.de>; Sat, 30 Apr 2022 18:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237559AbiD3QMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Apr 2022 12:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbiD3QM3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Apr 2022 12:12:29 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDD85E140;
        Sat, 30 Apr 2022 09:09:06 -0700 (PDT)
Received: from zn.tnic (p5de8eeb4.dip0.t-ipconnect.de [93.232.238.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DE3691EC0445;
        Sat, 30 Apr 2022 18:09:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1651334941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3O6m7gsP+Q15sV5A9sj6v9CSQ9u8JCS/o5mGbHIZ3EY=;
        b=C+/uh9ciNP7u3UTNMwVgALCRLpJA6vbWXsvn825GyZFBliE78epk76kGCChw3PpvEqGUvA
        W33lTP/7kOzELZSt2zaubZpzu/l7bnOSxk44QUPozTTPcdnqw5vkd845EnXhwQCUBixVb4
        KdGCNttpqX7qbiIuGdL16AVnCMpfue4=
Date:   Sat, 30 Apr 2022 18:08:57 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Balbir Singh <sblbir@amazon.com>,
        Kim Phillips <kim.phillips@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v3] x86/speculation, KVM: only IBPB for
 switch_mm_always_ibpb on vCPU load
Message-ID: <Ym1fGZIs6K7T6h3n@zn.tnic>
References: <YmwZYEGtJn3qs0j4@zn.tnic>
 <645E4ED5-F6EE-4F8F-A990-81F19ED82BFA@nutanix.com>
 <Ymw9UZDpXym2vXJs@zn.tnic>
 <YmxKqpWFvdUv+GwJ@google.com>
 <YmxRnwSUBIkOIjLA@zn.tnic>
 <Ymxf2Jnmz5y4CHFN@google.com>
 <YmxlHBsxcIy8uYaB@zn.tnic>
 <YmxzdAbzJkvjXSAU@google.com>
 <Ym0GcKhPZxkcMCYp@zn.tnic>
 <4E46337F-79CB-4ADA-B8C0-009E7500EDF8@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E46337F-79CB-4ADA-B8C0-009E7500EDF8@nutanix.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 30, 2022 at 02:50:35PM +0000, Jon Kohler wrote:
> This is 100% a fair ask, I appreciate the diligence, as we’ve all been there
> on the ‘other side’ of changes to complex areas and spend hours digging on
> git history, LKML threads, SDM/APM, and other sources trying to derive
> why the heck something is the way it is.

Yap, that's basically proving my point and why I want stuff to be
properly documented so that the question "why was it done this way" can
always be answered satisfactorily.

> AFAIK, the KVM IBPB is avoided when switching in between vCPUs
> belonging to the same vmcs/vmcb (i.e. the same guest), e.g. you could 
> have one VM highly oversubscribed to the host and you wouldn’t see
> either the KVM IBPB or the switch_mm IBPB. All good. 
> 
> Reference vmx_vcpu_load_vmcs() and svm_vcpu_load() and the 
> conditionals prior to the barrier.

So this is where something's still missing.

> However, the pain ramps up when you have a bunch of separate guests,
> especially with a small amount of vCPUs per guest, so the switching is more
> likely to be in between completely separate guests.

If the guests are completely separate, then it should fall into the
switch_mm() case.

Unless it has something to do with, as I looked at the SVM side of
things, the VMCBs:

	if (sd->current_vmcb != svm->vmcb) {

So it is not only different guests but also within the same guest and
when the VMCB of the vCPU is not the current one.

But then if VMCB of the vCPU is not the current, per-CPU VMCB, then that
CPU ran another guest so in order for that other guest to attack the
current guest, then its branch pred should be flushed.

But I'm likely missing a virt aspect here so I'd let Sean explain what
the rules are...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D955414555
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 11:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbhIVJkT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 05:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234418AbhIVJkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 05:40:10 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBE7C061574;
        Wed, 22 Sep 2021 02:38:19 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0efa00e1b20f6d5f00f371.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:fa00:e1b2:f6d:5f00:f371])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8A4101EC04E4;
        Wed, 22 Sep 2021 11:38:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1632303493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=nehvbtp+iVTeyyMzkseD676nsbARQC8Fz0zTVaQUD18=;
        b=Im+KSGCT0T1VMIm8WO9h8Oks9HOlxtRwhQ2VGhoavv9UnIJXkRFGzamH4+IXhhr91N63Ig
        T/5OuKTubgkJFniabg0xpI4tI1Ug9MzWuyRJWRm0jpakGBieOuo2UNPhUqYrVoqe6s8/OS
        5kRFMMx8KdGgGAVsjHy9KQLo2KiOfD4=
Date:   Wed, 22 Sep 2021 11:38:08 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ashish Kalra <ashish.kalra@amd.com>,
        Steve Rutherford <srutherford@google.com>, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, thomas.lendacky@amd.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        brijesh.singh@amd.com, dovmurik@linux.ibm.com, tobin@linux.ibm.com,
        jejb@linux.ibm.com, dgilbert@redhat.com
Subject: Re: [PATCH v6 1/5] x86/kvm: Add AMD SEV specific Hypercall3
Message-ID: <YUr5gCgNe7tT0U/+@zn.tnic>
References: <cover.1629726117.git.ashish.kalra@amd.com>
 <6fd25c749205dd0b1eb492c60d41b124760cc6ae.1629726117.git.ashish.kalra@amd.com>
 <CABayD+fnZ+Ho4qoUjB6YfWW+tFGUuftpsVBF3d=-kcU0-CEu0g@mail.gmail.com>
 <YUixqL+SRVaVNF07@google.com>
 <20210921095838.GA17357@ashkalra_ubuntu_server>
 <YUnjEU+1icuihmbR@google.com>
 <YUnxa2gy4DzEI2uY@zn.tnic>
 <YUoDJxfNZgNjY8zh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YUoDJxfNZgNjY8zh@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 21, 2021 at 04:07:03PM +0000, Sean Christopherson wrote:
> init_hypervisor_platform(), after x86_init.hyper.init_platform() so that the
> PV support can set the desired feature flags.  Since kvm_hypercall*() is only
> used by KVM guests, set_cpu_cap(c, X86_FEATURE_VMMCALL) can be moved out of
> early_init_amd/hygon() and into kvm_init_platform().

See below.

> Another option would be to refactor apply_alternatives() to allow
> the caller to provide a different feature check mechanism than
> boot_cpu_has(), which I think would let us drop X86_FEATURE_VMMCALL,
> X86_FEATURE_VMCALL, and X86_FEATURE_VMW_VMMCALL from cpufeatures. That
> might get more than a bit gross though.

Uuuf.

So here's what I'm seeing (line numbers given to show when stuff
happens):

start_kernel
|-> 953: setup_arch
    |-> 794: early_cpu_init
    |-> 936: init_hypervisor_platform
|
|-> 1134: check_bugs
	  |-> alternative_instructions

at line 794 setup_arch() calls early_cpu_init() which would end up
setting X86_FEATURE_VMMCALL on an AMD guest, based on CPUID information.

init_hypervisor_platform() happens after that.

The alternatives patching happens in check_bugs() at line 1134. Which
means, if one would consider moving the patching up, one would have
to audit all the code between line 953 and 1134, whether it does
set_cpu_cap() or some of the other helpers to set or clear bits in
boot_cpu_data which controls the patching.

So for that I have only one thing to say: can'o'worms. We tried to move
the memblock allocations placement in the boot process and generated at
least 4 regressions. I'm still testing the fix for the fix for the 4th
regression.

So moving stuff in the fragile boot process makes my hair stand up.

Refactoring apply_alternatives() to patch only for X86_FEATURE_VMMCALL
and then patch again, I dunno, this stuff is fragile and it might cause
some other similarly nasty fallout. And those are hard to debug because
one does not see immediately when boot_cpu_data features are missing and
functionality is behaving differently because of that.

So what's wrong with:

kvm_hypercall3:

	if (cpu_feature_enabled(X86_FEATURE_VMMCALL))
		return kvm_sev_hypercall3(...);

	/* rest of code */

?

Dunno we probably had that already in those old versions and maybe that
was shot down for another reason but it should get you what you want
without having to test the world and more for regressions possibly
happening from disturbing the house of cards called x86 boot order.

IMHO, I'd say.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

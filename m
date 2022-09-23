Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499C75E7899
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 12:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbiIWKpa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 06:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbiIWKp3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 06:45:29 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D820107DCA;
        Fri, 23 Sep 2022 03:45:27 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e795329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e795:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 173371EC0646;
        Fri, 23 Sep 2022 12:45:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1663929922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=YC6QKuFEYpH0XpfhpwGB1CuLNINrgRzZ5ir3xkeSvuM=;
        b=WkBB69seK3LQAmoCcgMvxc4T8LOtOQF+r50Tp3fx9YEEYQAlSVbgszUBjeoYyEGhxR6pW7
        qzpRRDWwvAgaP5PoumZxgODb+d+pIUPwLzU0wxIxtraqbGFSTbX4itR9eh7OAOJlatWm9l
        SrPmUepo8bZacWgektuZAyCYiB1bZQw=
Date:   Fri, 23 Sep 2022 12:45:17 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Juergen Gross <jgross@suse.com>, x86@kernel.org,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        ganb@vmware.com, sturlapati@vmware.com, bordoloih@vmware.com,
        ankitja@vmware.com, keerthanak@vmware.com, namit@vmware.com,
        srivatsab@vmware.com, kvm ML <kvm@vger.kernel.org>
Subject: Re: [PATCH] smp/hotplug, x86/vmware: Put offline vCPUs in halt
 instead of mwait
Message-ID: <Yy2OPR0b3pG2Ia+v@zn.tnic>
References: <165843627080.142207.12667479241667142176.stgit@csail.mit.edu>
 <Yy1attxrEMDmCFBa@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yy1attxrEMDmCFBa@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+ kvm ML and leaving the whole mail quoted in for them.

On Fri, Sep 23, 2022 at 09:05:26AM +0200, Peter Zijlstra wrote:
> On Thu, Jul 21, 2022 at 01:44:33PM -0700, Srivatsa S. Bhat wrote:
> > From: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> > 
> > VMware ESXi allows enabling a passthru mwait CPU-idle state in the
> > guest using the following VMX option:
> > 
> > monitor_control.mwait_in_guest = "TRUE"
> > 
> > This lets a vCPU in mwait to remain in guest context (instead of
> > yielding to the hypervisor via a VMEXIT), which helps speed up
> > wakeups from idle.
> > 
> > However, this runs into problems with CPU hotplug, because the Linux
> > CPU offline path prefers to put the vCPU-to-be-offlined in mwait
> > state, whenever mwait is available. As a result, since a vCPU in mwait
> > remains in guest context and does not yield to the hypervisor, an
> > offline vCPU *appears* to be 100% busy as viewed from ESXi, which
> > prevents the hypervisor from running other vCPUs or workloads on the
> > corresponding pCPU (particularly when vCPU - pCPU mappings are
> > statically defined by the user).
> 
> I would hope vCPU pinning is a mandatory thing when MWAIT passthrough it
> set?
> 
> > [ Note that such a vCPU is not
> > actually busy spinning though; it remains in mwait idle state in the
> > guest ].
> > 
> > Fix this by overriding the CPU offline play_dead() callback for VMware
> > hypervisor, by putting the CPU in halt state (which actually yields to
> > the hypervisor), even if mwait support is available.
> > 
> > Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> > ---
> 
> > +static void vmware_play_dead(void)
> > +{
> > +	play_dead_common();
> > +	tboot_shutdown(TB_SHUTDOWN_WFS);
> > +
> > +	/*
> > +	 * Put the vCPU going offline in halt instead of mwait (even
> > +	 * if mwait support is available), to make sure that the
> > +	 * offline vCPU yields to the hypervisor (which may not happen
> > +	 * with mwait, for example, if the guest's VMX is configured
> > +	 * to retain the vCPU in guest context upon mwait).
> > +	 */
> > +	hlt_play_dead();
> > +}
> >  #endif
> >  
> >  static __init int activate_jump_labels(void)
> > @@ -349,6 +365,7 @@ static void __init vmware_paravirt_ops_setup(void)
> >  #ifdef CONFIG_SMP
> >  		smp_ops.smp_prepare_boot_cpu =
> >  			vmware_smp_prepare_boot_cpu;
> > +		smp_ops.play_dead = vmware_play_dead;
> >  		if (cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
> >  					      "x86/vmware:online",
> >  					      vmware_cpu_online,
> 
> No real objection here; but would not something like the below fix the
> problem more generally? I'm thinking MWAIT passthrough for *any*
> hypervisor doesn't want play_dead to use it.
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index f24227bc3220..166cb3aaca8a 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1759,6 +1759,8 @@ static inline void mwait_play_dead(void)
>  		return;
>  	if (!this_cpu_has(X86_FEATURE_CLFLUSH))
>  		return;
> +	if (this_cpu_has(X86_FEATURE_HYPERVISOR))
> +		return;
>  	if (__this_cpu_read(cpu_info.cpuid_level) < CPUID_MWAIT_LEAF)
>  		return;

Yeah, it would be nice if we could get a consensus here from all
relevant HVs.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

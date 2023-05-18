Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 722527086FB
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 19:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjERRd2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 13:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjERRdY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 13:33:24 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8842210C3
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 10:33:18 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba83fed51adso4198967276.0
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 10:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684431198; x=1687023198;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8cEl1ydTMl5q3gHf+vzUZhqFLws3YlkU0676DjuVAEc=;
        b=BKULirzLQS6eZU2YCMK6cPgVX6t43Y+ZWllWKSO0hfYQazIpj8NW0eV6zU3q766It9
         w7vRgme9vwtezARoQpPcNqTT2qvuusR243H2BX2Bg11/cQa/6u+KVtjbTPkdgRZOiL0/
         E3AIukIhXubYQV+mzsndFfzl+ISjTU46r5MpvM6v1yKTs39dOaIsEo41jCrUm135Fdm/
         wlRVbMAWoMdExKceIndrby8bV5wvuT9esReEpiRU6NyllmKilS8evoCVWCl4YwANzrsw
         ozzsurn6tZv1LMXAr4nKnZqEFn8huB+EPpPz6S11Xaeftd23J/LSUb5qoP01URtDL6R7
         nROQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684431198; x=1687023198;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8cEl1ydTMl5q3gHf+vzUZhqFLws3YlkU0676DjuVAEc=;
        b=dUK0+AUcHIMiKo5nYPrRrWWGdgc7SaEGVfTNl5PUwCxLtiPbnmREq1vcnvVTKUaNGd
         BV+y0WYCqIfUM6KCDUv7I4XwZzsi3ylccnsycarhf20FJ9kIFBhEFwvbYnJrLVL88ri/
         +GfYQXc9Nyc8tMovL4Hnz++1FGZePvROwUgDEF1fmwfoKtfUfZt6TCxcbS0RFKDDhkdX
         oCxWh/Hyba2jBN2jr9t8H93Qx3HwmlZuARRbqSVJnBzPH3O37VLRkREaGd+vwoa2q3+q
         nhg6xdlVoCkvuSepw7E5Ps+w9lucmVS+2xPouyH5HH8RTbNmI46yvs2fpr/a6DBCjPGH
         tQMQ==
X-Gm-Message-State: AC+VfDyw14IWNE23dBe8ht2TOYaDWrPJQ+wjXoiSIQGLBLCpdyrYn/nV
        y1HPfwChnTnZ6qW02ZuTSdtMQiRJ6d0=
X-Google-Smtp-Source: ACHHUZ7u50I4GeLvpBu4BmPY+IQ2XQfNLPC3t5AVa7u1jfGcyoN/MDFaue/jz2abf1bhEEwfF8JCHoqMFBk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e785:0:b0:ba8:3e1a:3fd6 with SMTP id
 e127-20020a25e785000000b00ba83e1a3fd6mr1111536ybh.3.1684431197829; Thu, 18
 May 2023 10:33:17 -0700 (PDT)
Date:   Thu, 18 May 2023 10:33:15 -0700
In-Reply-To: <b472b58d-0469-8a55-985c-1d966ce66419@intel.com>
Mime-Version: 1.0
References: <20230506030435.80262-1-chao.gao@intel.com> <b472b58d-0469-8a55-985c-1d966ce66419@intel.com>
Message-ID: <ZGZhW/x5OWPmx1qD@google.com>
Subject: Re: [PATCH] KVM: x86: Track supported ARCH_CAPABILITIES in kvm_caps
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Jim

On Thu, May 18, 2023, Xiaoyao Li wrote:
> On 5/6/2023 11:04 AM, Chao Gao wrote:
> > to avoid computing the supported value at runtime every time.
> > 
> > No functional change intended.
> 
> the value of kvm_get_arch_capabilities() can be changed due to
> 
> 	if (l1tf_vmx_mitigation != VMENTER_L1D_FLUSH_NEVER)
> 		data |= ARCH_CAP_SKIP_VMENTRY_L1DFLUSH;
> 
> and l1tf_vmx_mitigation can be runtime changed by vmentry_l1d_flush module
> param.

Nice catch!

> We need a detailed analysis that in no real case can
> ARCH_CAP_SKIP_VMENTRY_L1DFLUSH bit change runtime.

No, the fact that it _can_ be modified by a writable module param is enough to
make this patch buggy.

I do like snapshotting and then updating the value, even though there's likely no
meaningful performance benefit, as that would provide a place to document that
the "supported" value is dynamic.  Though the fact that it's dynamic is arguably a bug
in its own right, e.g. if userspace isn't careful, a VM can have vCPUs with different
values for ARCH_CAPABILITIES.  But fixing that is probably a fool's errand.  So
I vote to snapshot the value and toggle the ARCH_CAP_SKIP_VMENTRY_L1DFLUSH bit
when l1tf_vmx_mitigation is modified.

On a somewhat related topic, what in the absolute #$#$ is going on with FB_CLEAR_DIS!?!?
I made the mistake of digging into why KVM doesn't advertise ARCH_CAP_FB_CLEAR_CTRL...

  1. I see *nothing* in commit 027bbb884be0 ("KVM: x86/speculation: Disable Fill
     buffer clear within guests") that justifies 1x RDMSR and 2x WRMSR on every
     entry+exit.

  2. I'm pretty sure conditioning mmio_stale_data_clear on kvm_arch_has_assigned_device()
     is a bug.  AIUI, the vulnerability applies to _any_ MMIO accesses.  Assigning
     a device is necessary to let the device DMA into the guest, but it's not
     necessary to let the guest access MMIO addresses, that's done purely via
     memslots.

  3. Irrespective of whether or not there is a performance benefit, toggling the
     MSR on every entry+exit is completely unnecessary if KVM won't do VERW before
     VM-Enter, i.e. if (!mds_user_clear && !mmio_stale_data_clear), then the
     toggling can be done in vmx_prepare_switch_to_{guest,host}().  This probably
     isn't worth pursuing though, as #4 below is more likely, especially since
     X86_BUG_MSBDS_ONLY is limited to Atom (and MIC, lol) CPUs.

  4. If the host will will _never_ do VERW, i.e. #3 + !X86_BUG_MSBDS_ONLY, then
     KVM just needs to context switch the MSR between guests since the value that's
     loaded while running in the host is irrelevant.  E.g. use a percpu cache to
     track the current value.

  5. MSR_IA32_MCU_OPT_CTRL is not modified by the host after a CPU is brought up,
     i.e. the host's desired value is effectively static post-boot, and barring
     a buggy configuration (running KVM as a guest), the boot CPU's value will be
     the same as every other CPU.

  6. Performance aside, KVM should not be speculating (ha!) on what the guest
     will and will not do, and should instead honor whatever behavior is presented
     to the guest.  If the guest CPU model indicates that VERW flushes buffers,
     then KVM damn well needs to let VERW flush buffers.

  7. Why on earth did Intel provide a knob that affects both the host and guest,
     since AFAICT the intent of the MSR is purely to suppress FB clearing for an
     unsuspecting (or misconfigured?) guest!?!?!

FWIW, this trainwreck is another reason why I'm not going to look at the proposed
"Intel IA32_SPEC_CTRL Virtualization" crud until external forces dictate that I
do so.  I have zero confidence that a paravirt interface defined by hardware
vendors to fiddle with mitigations will be sane, flexible, and extensible.

Anyways, can someone from Intel do some basic performance analysis to justify
doing RDMSR + WRMSRx2 on every transition?  Unless someone provides numbers that
show a clear, meaningful benefit to the aggressive toggling, I'm inclined to have
KVM do #4, e.g. end up with something like:

	/* L1D Flush includes CPU buffer clear to mitigate MDS */
	if (static_branch_unlikely(&vmx_l1d_should_flush)) {
		vmx_l1d_flush(vcpu);
	} else if (static_branch_unlikely(&mds_user_clear) ||
		   static_branch_unlikely(&mmio_stale_data_clear)) {
		mds_clear_cpu_buffers();
	} else if (static_branch_unlikely(&kvm_toggle_fb_clear) {
		bool enable_fb_clear = !!(vcpu->arch.arch_capabilities & ARCH_CAP_FB_CLEAR);

		if (this_cpu_read(kvm_fb_clear_enabled) != enable_fb_clear) {
			u64 mcu_opt_ctrl = host_mcu_opt_ctrl;

			if (enable_fb_clear)
				mcu_opt_ctrl &= ~FB_CLEAR_DIS;
			else
				mcu_opt_ctrl |= FB_CLEAR_DIS;
			native_wrmsrl(MSR_IA32_MCU_OPT_CTRL, mcu_opt_ctrl);
			this_cpu_write(kvm_fb_clear_enabled, enable_fb_clear);
		}
	}

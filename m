Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540456780A6
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 16:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjAWP5l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 10:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232974AbjAWP5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 10:57:37 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FA47EFB
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 07:57:33 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id u1-20020a17090a450100b0022936a63a21so15662662pjg.4
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 07:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J/DE+Jcu82PW705WKHlblHxakCDZFOpkEHSyJu/ilc4=;
        b=pwWvtEPlZNBpZ9Hh25elPnICzqLrBjwHF6ShwXYfpMLxdHcjk9gglt5Flf02z7wR/7
         YC2feLpuBvHP+Wy8yQAu0AZdvz+300t3U4hWXqMTSrrmM2K8Wpj3sPjEnpzO3j55HJWd
         tMVEBk9mfPKA095FCDP7RZx33i6U51vTH5boZMsT3tp1JlMp1JxwbKJxGocLZ0OEtsq7
         CQ44SPeqd1l5NpE08f1vSi+9zez+6C7UV9uW4DaZdbOD/aCcvB5Du4mjSB4TwkFQ6+be
         /MZYaL6UXcjtnqpk2xAeM6sg5XR1L5LJxCLXT3Ul5GG61sLzdX9l6LQurAAH3nBv9N7I
         pRgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J/DE+Jcu82PW705WKHlblHxakCDZFOpkEHSyJu/ilc4=;
        b=caPIpgSB18y9mIePCUpUmBKoOlrEcKAhQDhUz2Rc9Md+99U9VDor8mLO80/JU4iOfJ
         DS2Y3NFKezTYIpCiwaNh1xKowtfC+iikg7dzcnyiV3aWNtn4HqpdFrBrRW+lH2ZBb3cf
         WgxZkR8X/rj+Z8ynzuN6taVv7fa1OsAxByQ3fCVGDgeKPKCu0JZ9IlL/1aJwZhHuH+dr
         OcHXSHDxufqbX3asiO6VZ21gIw4PGqroFTn12OfygWULtvC/nxRbJ1OizynSkyLlZh1g
         FoD1mGtQj7ZQ6uUKHKuASEwAAOEZ9YKI/P+p5vrwyKfQBnCOGXzW9+RMrIlgMIVYkk4r
         w0GQ==
X-Gm-Message-State: AFqh2krVFTi49VZIvQWxC74u7j2y+TLpcxJ3q7EfggbBHk0wdFr6NJzY
        v6NqDLhYknK+PeVjLZWwnlsc+IVhHYRqBHj7810=
X-Google-Smtp-Source: AMrXdXscfcHkJ3hBd9qV0j2nFhGbusKSeLA4MfTO94zYE8CBROyfKNyxh4dT892GUq0GF6x6sjNTRw==
X-Received: by 2002:a17:902:c994:b0:189:6624:58c0 with SMTP id g20-20020a170902c99400b00189662458c0mr531100plc.3.1674489453233;
        Mon, 23 Jan 2023 07:57:33 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y7-20020a170902d64700b001960096d28asm3193091plh.27.2023.01.23.07.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 07:57:32 -0800 (PST)
Date:   Mon, 23 Jan 2023 15:57:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexandru Matei <alexandru.matei@uipath.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: Re: [PATCH v2] KVM: VMX: Fix crash due to uninitialized current_vmcs
Message-ID: <Y86uaYL2JOPxMzn/@google.com>
References: <20230123124641.4138-1-alexandru.matei@uipath.com>
 <87edrlcrk1.fsf@ovpn-194-126.brq.redhat.com>
 <e591f716-cc3b-a997-95a0-dc02c688c8ec@uipath.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e591f716-cc3b-a997-95a0-dc02c688c8ec@uipath.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 23, 2023, Alexandru Matei wrote:
> On 1/23/2023 3:24 PM, Vitaly Kuznetsov wrote:
> > Alexandru Matei <alexandru.matei@uipath.com> writes:
> > 
> >> KVM enables 'Enlightened VMCS' and 'Enlightened MSR Bitmap' when running as
> >> a nested hypervisor on top of Hyper-V. When MSR bitmap is updated,
> >> evmcs_touch_msr_bitmap function uses current_vmcs per-cpu variable to mark
> >> that the msr bitmap was changed.
> >>
> >> vmx_vcpu_create() modifies the msr bitmap via vmx_disable_intercept_for_msr
> >> -> vmx_msr_bitmap_l01_changed which in the end calls this function. The
> >> function checks for current_vmcs if it is null but the check is
> >> insufficient because current_vmcs is not initialized. Because of this, the
> >> code might incorrectly write to the structure pointed by current_vmcs value
> >> left by another task. Preemption is not disabled, the current task can be
> >> preempted and moved to another CPU while current_vmcs is accessed multiple
> >> times from evmcs_touch_msr_bitmap() which leads to crash.
> >>
> >> The manipulation of MSR bitmaps by callers happens only for vmcs01 so the
> >> solution is to use vmx->vmcs01.vmcs instead of current_vmcs.
> >>
> >> BUG: kernel NULL pointer dereference, address: 0000000000000338
> >> PGD 4e1775067 P4D 0
> >> Oops: 0002 [#1] PREEMPT SMP NOPTI
> >> ...
> >> RIP: 0010:vmx_msr_bitmap_l01_changed+0x39/0x50 [kvm_intel]
> >> ...
> >> Call Trace:
> >>  vmx_disable_intercept_for_msr+0x36/0x260 [kvm_intel]
> >>  vmx_vcpu_create+0xe6/0x540 [kvm_intel]
> >>  ? __vmalloc_node+0x4a/0x70
> >>  kvm_arch_vcpu_create+0x1d1/0x2e0 [kvm]
> >>  kvm_vm_ioctl_create_vcpu+0x178/0x430 [kvm]
> >>  ? __handle_mm_fault+0x3cb/0x750
> >>  kvm_vm_ioctl+0x53f/0x790 [kvm]
> >>  ? syscall_exit_work+0x11a/0x150
> >>  ? syscall_exit_to_user_mode+0x12/0x30
> >>  ? do_syscall_64+0x69/0x90
> >>  ? handle_mm_fault+0xc5/0x2a0
> >>  __x64_sys_ioctl+0x8a/0xc0
> >>  do_syscall_64+0x5c/0x90
> >>  ? exc_page_fault+0x62/0x150
> >>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >>
> >> Suggested-by: Sean Christopherson <seanjc@google.com>
> >> Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
> >> ---
> >> v2:
> >>   - pass (e)vmcs01 to evmcs_touch_msr_bitmap
> >>   - use loaded_vmcs * instead of vcpu_vmx * to avoid
> >>     including vmx.h which generates circular dependency
> >>
> >> v1: https://lore.kernel.org/kvm/20230118141348.828-1-alexandru.matei@uipath.com/
> >>
> >>  arch/x86/kvm/vmx/hyperv.h | 16 +++++++++++-----
> >>  arch/x86/kvm/vmx/vmx.c    |  2 +-
> >>  2 files changed, 12 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
> >> index 571e7929d14e..132e32e57d2d 100644
> >> --- a/arch/x86/kvm/vmx/hyperv.h
> >> +++ b/arch/x86/kvm/vmx/hyperv.h
> >> @@ -190,13 +190,19 @@ static inline u16 evmcs_read16(unsigned long field)
> >>  	return *(u16 *)((char *)current_evmcs + offset);
> >>  }
> >>  
> >> -static inline void evmcs_touch_msr_bitmap(void)
> >> +static inline void evmcs_touch_msr_bitmap(struct loaded_vmcs *vmcs01)
> > 
> > Personally, I would've followed Sean's suggestion and passed "struct
> > vcpu_vmx *vmx" as 'loaded_vmcs' here is a bit ambiguos....
> 
> I couldn't use vcpu_vmx *, it requires including vmx.h in hyperv.h 
> and it generates a circular depedency which leads to compile errors.
> 
> > 
> >>  {
> >> -	if (unlikely(!current_evmcs))
> >> +	/*
> >> +	 * Enlightened MSR Bitmap feature is enabled only for L1, i.e.
> >> +	 * always operates on (e)vmcs01
> >> +	 */
> >> +	struct hv_enlightened_vmcs* evmcs = (void*)vmcs01->vmcs;
> > 
> > (Nit: a space between "void" and "*")
> > 
> > .. or, alternatively, you can directly pass 
> > (struct hv_enlightened_vmcs *)vmx->vmcs01.vmcs as e.g. 'current_evmcs'
> > and avoid the conversion here.
> 
> OK, sounds good, I'll pass hv_enlightened_vmcs * directly.

Passing the eVMCS is silly, if we're going to bleed eVMCS details into vmx.c then
we should just commit and expose all details.  For this feature specifically, KVM
already handles the enabling in vmx.c / vmx_vcpu_create():

	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs) &&
	    (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)) {
		struct hv_enlightened_vmcs *evmcs = (void *)vmx->vmcs01.vmcs;

		evmcs->hv_enlightenments_control.msr_bitmap = 1;
	}

And if we handle this fully in vmx_msr_bitmap_l01_changed(), then there's no need
for a comment explaining that the feature is only enabled for vmcs01.

If we want to maintain better separate between VMX and Hyper-V code, then just make
the helper non-inline in hyperv.c, modifying MSR bitmaps will never be a hot path
for any sane guest.

I don't think I have a strong preference either way.  In a perfect world we'd keep
Hyper-V code separate, but practically speaking I think trying to move everything
into hyperv.c would result in far too many stubs and some weird function names.

Side topic, we should really have a wrapper for static_branch_unlikely(&enable_evmcs)
so that the static key can be defined iff CONFIG_HYPERV=y.  I'll send a patch.

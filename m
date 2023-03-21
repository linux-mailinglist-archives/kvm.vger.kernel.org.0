Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1758A6C38A6
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 18:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjCURw0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 13:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjCURwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 13:52:24 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4103C515FC
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 10:52:16 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id b8-20020aa78708000000b005eaa50faa35so8105709pfo.20
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 10:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679421136;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oc4FgCEri3S+Q/rLlGwR1PDWQHAY0iPbQD6V77WfqXI=;
        b=KK8os+s8Vk/xagM9igf2F6VD7beL5YkOexl/kpK1T6Xy78GupxHogOIqCIkVcuY382
         GjIzuBeWtPgYdtYOwXk/TsQ/7vqUxDqU6e+rr0lwMgcAnO3/lK+ULLNkNqQ3jPc7PdK6
         vh2wwwXqcBoVKL2QrHbP5msqhqHyIUgS6MTDkrcdZTzrXgAzfZ6LzHleV48J8JNQ/itv
         bosJz4igyMa1OpVceDGjZSIZ/p34sME0YBfvD/tQQQwgSi6axIZtKyN/uUIHmAAZGzIB
         mBavcPjXY68wHgJGA0uarBcwtulC0SI8RpwQNr/mGZM6x68mngMpGKoTo1EWhH+Teb+X
         C3Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679421136;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oc4FgCEri3S+Q/rLlGwR1PDWQHAY0iPbQD6V77WfqXI=;
        b=vHDtbjnmWtJswGxsMONADRzgmCCnjppKE2cHCDWTiw2t3ncAIC1cUcKNyFSpC0yvso
         AnGm/wx25XrQkowLOi1FoJJH13U+In7adCODQJT0lWZ6Zt6pBzOnt4sKWP35zskF6a6R
         S8Pi+591Ea7RdpdobVUWMocQXGsy2CjS3BLuVhi3dqgg+KiwDStSmPn83GpvHmV3HsWG
         JKphimNvvhspcoiUaKSUx67ZW1symXYOkmwngXSIE14PKjA3qewKAZdBCQC6cVKRIp5Q
         7iqCJmuGs0ySWYc/WWGqytKvDHQKjd2Y+c+ogeJgUPzLVVUiKLm3IVd5Xsi0B8WKr9Un
         n76w==
X-Gm-Message-State: AO0yUKWkii/SafLxdxBKAniuejMoRLsljppKL4D0+M6fPks83AoREh67
        mr42itqpmLsSEQWSXnjGwRcAzVgFlCU=
X-Google-Smtp-Source: AK7set/2BmqZEOOc+PywTXtMotI9ShLno9e2Em5LlhM8/j+VVlLg9kuotBlFzxBwGIuQQO4GbUhu13i144A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ef86:b0:1a1:e48b:98b8 with SMTP id
 iz6-20020a170902ef8600b001a1e48b98b8mr1001583plb.10.1679421135869; Tue, 21
 Mar 2023 10:52:15 -0700 (PDT)
Date:   Tue, 21 Mar 2023 10:52:14 -0700
In-Reply-To: <20230119141946.585610-2-yu.c.zhang@linux.intel.com>
Mime-Version: 1.0
References: <20230119141946.585610-1-yu.c.zhang@linux.intel.com> <20230119141946.585610-2-yu.c.zhang@linux.intel.com>
Message-ID: <ZBnuzoWuwAPoy0+N@google.com>
Subject: Re: [PATCH v2 2/2] KVM: nVMX: Add helpers to setup VMX control msr configs
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 19, 2023, Yu Zhang wrote:
> nested_vmx_setup_ctls_msrs() is used to set up the various VMX MSR
> controls for nested VMX. But it is a bit lengthy, just add helpers
> to setup the configuration of VMX MSRs.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 129 +++++++++++++++++++++++++-------------
>  1 file changed, 85 insertions(+), 44 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 81dfbffae575..98ed7631e810 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -6750,36 +6750,9 @@ static u64 nested_vmx_calc_vmcs_enum_msr(void)
>  	return (u64)max_idx << VMCS_FIELD_INDEX_SHIFT;
>  }
>  
> -/*
> - * nested_vmx_setup_ctls_msrs() sets up variables containing the values to be
> - * returned for the various VMX controls MSRs when nested VMX is enabled.
> - * The same values should also be used to verify that vmcs12 control fields are
> - * valid during nested entry from L1 to L2.
> - * Each of these control msrs has a low and high 32-bit half: A low bit is on
> - * if the corresponding bit in the (32-bit) control field *must* be on, and a
> - * bit in the high half is on if the corresponding bit in the control field
> - * may be on. See also vmx_control_verify().
> - */
> -void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
> +static inline void nested_vmx_setup_pinbased_ctls(struct vmcs_config *vmcs_conf,

No need for the "inline", this isn't performance sensitive code, and odds are very,
very good the compiler will inline the code anyways.

> @@ -6953,13 +6943,16 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
>  		VMX_MISC_ACTIVITY_HLT |
>  		VMX_MISC_ACTIVITY_WAIT_SIPI;
>  	msrs->misc_high = 0;
> +}
>  
> -	/*
> -	 * This MSR reports some information about VMX support. We
> -	 * should return information about the VMX we emulate for the
> -	 * guest, and the VMCS structure we give it - not about the
> -	 * VMX support of the underlying hardware.
> -	 */
> +/*
> + * VMX basic MSR reports some information about VMX support. We should
> + * return information about the VMX we emulate for the guest, and the
> + * VMCS structure we give it - not about the VMX support of the underlying
> + * hardware.
> + */
> +static inline void nested_vmx_setup_basic(struct nested_vmx_msrs *msrs)
> +{
>  	msrs->basic =
>  		VMCS12_REVISION |
>  		VMX_BASIC_TRUE_CTLS |
> @@ -6968,12 +6961,15 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
>  
>  	if (cpu_has_vmx_basic_inout())
>  		msrs->basic |= VMX_BASIC_INOUT;
> +}
>  
> -	/*
> -	 * These MSRs specify bits which the guest must keep fixed on
> -	 * while L1 is in VMXON mode (in L1's root mode, or running an L2).
> -	 * We picked the standard core2 setting.
> -	 */
> +/*
> + * cr0_fixed & cr4_fixed MSRs specify bits which the guest must keep fixed
> + * on while L1 is in VMXON mode (in L1's root mode, or running an L2).
> + * We picked the standard core2 setting.
> + */

This change is flawed, the comment is specific to the fixed0 MSRs, not to all
flavors of fixed MSRs and thus not to the function as a whole.  As much as I want
to clean up the comments, for this patch I think it's best to leave them alone.

No need to send a v2, I'll fixup when applying.

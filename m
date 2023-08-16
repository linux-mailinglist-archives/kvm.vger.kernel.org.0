Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5DF77EC36
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 23:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346658AbjHPVuP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 17:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346665AbjHPVtz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 17:49:55 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437E92716
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 14:49:54 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d630af4038fso8068493276.0
        for <kvm@vger.kernel.org>; Wed, 16 Aug 2023 14:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692222593; x=1692827393;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GvRFojY4ZPxhLxJxPJp9kdBhD+0BLzra773t2FQ2yTE=;
        b=wWcZFTT8vxfvGkzlVbDIOEF8n/eaS3Hra04YiDrWv6UlfylY0i2N4j5i/VEaHMKVH+
         /a7HfzeKcwecHhJKrmvuIwYhRhx7GCjWGNv08XiuTJxRRCUbViWcx+uojc9VfMp0ueVg
         16N2v9fH1E/H7ZsWBqVhERW7G0dGmO/8z5ffhXyqF0cOKPk+3q6FqDP2A3nf41D4FJxK
         ztGBQ1o7E8POXSoqi2OGGILguKT87JnuJejNlh0i7DJPHE+XfgDfeU9bSBnhiUi8ErQU
         BNf/fZv5NIacObcMfkY9MYA6o4qjVwuLWO6f6Lw6hWndKpn5feqqh1ZJyH58TwYpaOn6
         Rk4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692222593; x=1692827393;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GvRFojY4ZPxhLxJxPJp9kdBhD+0BLzra773t2FQ2yTE=;
        b=ENbW16Bwl390wKqaW0lTWS2I3Nu1uf+KWu/kJvR00oRc3O8J6pOSxaedYQ03X57hNt
         1vJ0Wc/FQ8RtW+lkuXo5Jw9udix/25cXCzY7KhLLMe/usHvSULnliTuuISCvP9ecDiOY
         b7YQdWE+bz1PTZodFAk+rAMk+EntIK/MW4rGvezjW8OaP/UNqM0kenKa1BiuZdEzqSjl
         CYw3ZF4rwCQ//3GznPIVC4LXc3MCc0yqPp1ge/fxyIGP48sKpeioCmONiSTNGOTEXEBj
         ITjHJn1rQMCO6yeVvVLBV+le//dCyy7fTPGqDgBU5Bm+9ndpCrwldNEYhnk7lcuX+TnB
         fJdg==
X-Gm-Message-State: AOJu0YwBXEP+shtANNDxt7q0b+ixBpzjJDBoBM+eNUCMWfct+LgCEbcA
        lqRJHHeJSNHBTIyI8tsnO0ieqCyw04I=
X-Google-Smtp-Source: AGHT+IFKPz1foqDJAhh6UiyGPAL2mjKbfE9CCla+q1Q/LHPV+6Wvp3iYQOs5ByE0HeluDfYDwIhhzs/PMck=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1609:b0:d07:7001:495b with SMTP id
 bw9-20020a056902160900b00d077001495bmr48522ybb.11.1692222593583; Wed, 16 Aug
 2023 14:49:53 -0700 (PDT)
Date:   Wed, 16 Aug 2023 14:49:52 -0700
In-Reply-To: <20230719144131.29052-9-binbin.wu@linux.intel.com>
Mime-Version: 1.0
References: <20230719144131.29052-1-binbin.wu@linux.intel.com> <20230719144131.29052-9-binbin.wu@linux.intel.com>
Message-ID: <ZN1EgJwQc33jLd6W@google.com>
Subject: Re: [PATCH v10 8/9] KVM: x86: Untag address for vmexit handlers when
 LAM applicable
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com,
        guang.zeng@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 19, 2023, Binbin Wu wrote:
> index abf6d42672cd..f18e610c4363 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8177,8 +8177,7 @@ static void vmx_vm_destroy(struct kvm *kvm)
>  	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
>  }
>  
> -static gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva,
> -			    unsigned int flags)
> +gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags)
>  {
>  	unsigned long cr3_bits;
>  	int lam_bit;
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 32384ba38499..6fb612355769 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -421,6 +421,8 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type);
>  u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
>  u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
>  
> +gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
> +

I think it makes sense to squash this with whatever patch first adds
vmx_get_untagged_addr().  It'll make that initial "virtual LAM_*" patch a fair
bit bigger, but overall I think the series/patches will be easier to review,
e.g. the rules for LAM_SUP will mostly be captured in a single patch.

One could even make an argument for squashing LAM_U* support with the LAM_SUP
patch, but my vote is to keep them separate.

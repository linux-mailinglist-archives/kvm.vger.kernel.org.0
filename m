Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707CC4BC131
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 21:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239469AbiBRUai (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 15:30:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbiBRUaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 15:30:35 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36AAD27B9AE
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 12:30:18 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id x11so8027133pll.10
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 12:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DNFcmS6uw3KxEPl6z8drDxT/aeyaze5jPFLIWBXfGcM=;
        b=e/q+3layfTT2uJlUk+dxnbcpwhXmtyyU+HZ7fgNM2pMwxbLeVqbPhgjsz8Q7Rpilo4
         C9MB8oZH41riL0mqdtF1NOI9TX1Ux1BIWMuX5qRny1SFLaM2ZzV852gmRs9e7WehdNT4
         FLohFX4cGeqD+e7GcMaJRWi0UkuY1qfvlwRxrpXwX1fjQSu5M8CY0BtDBfFCI28c4kV4
         9CYA1hOD2vMp5C3yAv9n6EguQO8ifhW04x3agzlolDXcFAkxIgr/lWABcXBHVfHF5ial
         VnCQXrr9/+wW4QaSyjnmzDq5gS9n0fvay12v2iQNkYdFo0Nc7fGOxXrEkvWZt1Ye2BXr
         Q8SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DNFcmS6uw3KxEPl6z8drDxT/aeyaze5jPFLIWBXfGcM=;
        b=KFQRqxZJVi39flmwMQUrjrcVv+777AU05SSEAS+MXyJgj017Kg5Kto9EOYE2Xwm1UE
         WDqKTvncazfWlTHSFKBfTiHlGwTe0RhmpkdXxzvDQvwpBFv+RpTAqZRjEfrN3C+1I1Gs
         5ARcWQAHFMtbSqPbx8VIi4ygNy1ZBFOEq4w3KD5D/B1DxShrs+coiiG8mA+NLVolkF+J
         UW/Y+DhOp9h1qiLoI4rKt3rOX/9Z1GVnHMWfoxo7PPjRdVyd1m1QDHHCa3TO5mYIm0lE
         otyVzkfUnKCvaOzvtrdPhSmDgyAxOuBp7Xm7AyZ78d1AzaGP02NYQEJQsFhKHbiHH9pT
         dAqw==
X-Gm-Message-State: AOAM533HYCIL854escwRgj8geP5lwfk5UHkLdc4T0oBBIiLlx15JrqTz
        2f1sKvPg4pXZEw4cGRjfGCAbEQ==
X-Google-Smtp-Source: ABdhPJzJwYzm0DJRv5DwCaljdu2YM/3NJe2ZwfPmisgbN4UYw7m5x7pVOHc516qpIrzlt3NMLljFEQ==
X-Received: by 2002:a17:90b:1bc4:b0:1b9:ae7c:7c67 with SMTP id oa4-20020a17090b1bc400b001b9ae7c7c67mr14311623pjb.168.1645216217527;
        Fri, 18 Feb 2022 12:30:17 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q4sm3927977pfj.113.2022.02.18.12.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 12:30:16 -0800 (PST)
Date:   Fri, 18 Feb 2022 20:30:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 14/18] KVM: x86/mmu: avoid indirect call for get_cr3
Message-ID: <YhAB1d1/nQbx6yvk@google.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-15-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217210340.312449-15-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 17, 2022, Paolo Bonzini wrote:
> Most of the time, calls to get_guest_pgd result in calling
> kvm_read_cr3 (the exception is only nested TDP).  Hardcode
> the default instead of using the get_cr3 function, avoiding
> a retpoline if they are enabled.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu.h             | 13 +++++++++++++
>  arch/x86/kvm/mmu/mmu.c         | 15 +++++----------
>  arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
>  arch/x86/kvm/x86.c             |  2 +-
>  4 files changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 1d0c1904d69a..1808d6814ddb 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -116,6 +116,19 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
>  					  vcpu->arch.mmu->shadow_root_level);
>  }
>  
> +static inline gpa_t __kvm_mmu_get_guest_pgd(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
> +{

I'd prefer to do what we do for page faults.  That approach avoids the need for a
comment to document NULL and avoids a conditional when RETPOLINE is not enabled.

Might be worth renaming get_cr3 => get_guest_cr3 though.

#ifdef CONFIG_RETPOLINE
	if (mmu->get_guest_pgd = get_guest_cr3)
		return kvm_read_cr3(vcpu);
#endif
	return mmu->get_guest_pgd(vcpu);


> +	if (!mmu->get_guest_pgd)
> +		return kvm_read_cr3(vcpu);
> +	else
> +		return mmu->get_guest_pgd(vcpu);
> +}
> +
> +static inline gpa_t kvm_mmu_get_guest_pgd(struct kvm_vcpu *vcpu)
> +{
> +	return __kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu);

I'd much prefer we don't provide an @vcpu-only variant and force the caller to
provide the mmu.

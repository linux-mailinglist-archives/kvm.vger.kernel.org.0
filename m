Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04E04CC34C
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 17:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235085AbiCCQ5q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 11:57:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiCCQ5o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 11:57:44 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940E419DEAC
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 08:56:58 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id o23so5013807pgk.13
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 08:56:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E0epGT0NyN75DMnyrgnvgf75tyJ75K4JPqaLbgb0ul8=;
        b=mqgoW9O8l6XRyzNT9pkEkJDgLRqeD3PIedns7h5AvY0YdUN+TYOr1nOVrUEqq3yfVf
         +SFgO5kMvjdVShDdb6IDxm6NYeo6pgsE7W5iOTMABofaoq3I5n3fmC5ajtDu7JDkMS1y
         eAwy8F8DKLGrASZPUM27H02cWnvhYeo80c669EE7IJbFsYzve9THp6HEkY+ZmvF7PG6J
         f7PYRJu1vuH0gRTmzRCdcMJmRsXhLn+5Vuit76F3rxYO46i2L91MTrIpyaEoJWrTaIF1
         gcjErt52PJeJrd12JZ4rBGxw5CRtRON9O9OkxgebKS9Stw8wNfSFP35YAMVcSZT4ZKyO
         Vrsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E0epGT0NyN75DMnyrgnvgf75tyJ75K4JPqaLbgb0ul8=;
        b=DcChM8yH4dvM7vSMH+KwQgJH4fEfQ+AxS4OeC0nodrJoTTkf1dY2J/ePFL6k/yC2Bi
         wV+mKMOMFgg3fKqfWsY+gScEhOCDzstOanAX/KFSOlvH+mm9chOECl+AfXgC8rV9Lapk
         UNChGPs0iSx+KQ1YaTimnqwfZsdBlina/b8kD/iwdpCug+tdrP3Y6/JVydo86mLWS5Yv
         fengFCOJj1YROT3u+tXbNxKuyCYwpav7iX6pA+bIyiGrHbrEKA2OYQNOCSU6ri6U8etW
         slObuPNHW42n3EQUA187XyRnIb0tkyBMILOzM26BPeaNlVw1dRmmyCdl50dZDWx1WUJU
         aAyw==
X-Gm-Message-State: AOAM532UbWykyNPkvhakw+qbupjY5N/V3Q8h3FJ/75jx5vw50XuK2lme
        8qa0IKTDPJ0pj2Pqn9eR1yOI5g==
X-Google-Smtp-Source: ABdhPJyzD5wtRnsX77E3+CshxjS9x8p4UfMWvuB6NjRfZbIyL92Mjkd54E5GHJkWgp4bcYXUKNh46A==
X-Received: by 2002:a63:ea53:0:b0:341:a28e:16b9 with SMTP id l19-20020a63ea53000000b00341a28e16b9mr30928837pgk.259.1646326617785;
        Thu, 03 Mar 2022 08:56:57 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g14-20020a65594e000000b003759850ef17sm2583102pgu.31.2022.03.03.08.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 08:56:57 -0800 (PST)
Date:   Thu, 3 Mar 2022 16:56:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: x86: mmu: trace kvm_mmu_set_spte after the new SPTE
 was set
Message-ID: <YiDzVRG0VA3LXLrC@google.com>
References: <20220302102457.588450-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220302102457.588450-1-mlevitsk@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022, Maxim Levitsky wrote:
> It makes more sense to print new SPTE value than the
> old value.
> 

  Fixes: d786c7783b01 ("KVM: MMU: inline set_spte in mmu_set_spte")

And arguably even Cc: stable@vger.kernel.org, though that's unnecessary if this
gets into 5.17, which it should.

Reviewed-by: Sean Christopherson <seanjc@google.com>

> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 94f077722b290..0e209f0b2e1d2 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2690,8 +2690,8 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
>  	if (*sptep == spte) {
>  		ret = RET_PF_SPURIOUS;
>  	} else {
> -		trace_kvm_mmu_set_spte(level, gfn, sptep);
>  		flush |= mmu_spte_update(sptep, spte);
> +		trace_kvm_mmu_set_spte(level, gfn, sptep);
>  	}
>  
>  	if (wrprot) {
> -- 
> 2.26.3> 

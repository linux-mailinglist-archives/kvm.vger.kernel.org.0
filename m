Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F43A6247A1
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 17:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbiKJQy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 11:54:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbiKJQyZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 11:54:25 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D5418B34
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 08:54:24 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id q1-20020a17090a750100b002139ec1e999so2073050pjk.1
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 08:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GHqQ+ifPyyH+ZRpAz+8Vn63wx+9QCN4RV/rN7j1mLd4=;
        b=MsNnIC49TneR2S8d2YQaAthhjkheZcZYGvqeOL3CGrtumuM0GMydnbjeyPpt+zqJT4
         a0qb3TfPH2hDIzfQJlRstWyorDex9BxGHlpjKfuxTnRkBbeE5Dz0tXmggzK9S3de7pWI
         FIWRXvDmgaCOGD9CfvPbyq+euxTtemx2i8alqAVpwH3C/mNWqTDxZLfKpgks3xNBIGz2
         FuN01Zh9mL+B1+ePuSDMJaj2PLUTL6+40/6S7mujLwHpPR5BMBGkZHLlOEskW7pNRkYC
         JqTKzez76eVI17sB4AGaRy+HDpNiWCRY2uFqRN2naIUq/QKp29XgxTBqQVZ8gEsMTNrv
         o3SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GHqQ+ifPyyH+ZRpAz+8Vn63wx+9QCN4RV/rN7j1mLd4=;
        b=ZDTJNntEnfpoLvf7zWuL0cxFbyFkjVaJL1g/oORSFw4ieTcL/XHJxEnYsiNN/qvJBw
         FFcddQ2AmGIMqW2azI8XlQnhNFirFvNJjqqDD/z/Tnjp7u5pzXYDu3HqYIfKhlWYbQgA
         Nch3n1av0r8//7lCh7DyMYFumyF3nH+kGuoK/vP0+/zSVGhvqkIkzQRasxnNCXQ/Ncce
         qBaCuoMOIg+ZPwsf9ZmGgxZxmqfFJiaML2Hv8cAvD4UxggvMXR+JGxkM7csHqboDuFAH
         y8THIDBu8eI9IFg3aaBI9XF4ZwC2SvAbxh4abvX48MfOu9IJJ9hgGf6anJOow+eWddB2
         PNJQ==
X-Gm-Message-State: ACrzQf3gG7uZ/KkugoM8dumyhP43D5mbI+6TkA0KD63zMRELDoZwX/Bu
        DN0TnO1bDmVPVmZtfonVOiRhEA==
X-Google-Smtp-Source: AMsMyM7Gjon1TAgMXyfnJCAD/JqeM6dxubIZGmQGn6GXSBI6FxpyqDVr1dxTgHn8k9i/0IX5fhsz5g==
X-Received: by 2002:a17:902:f252:b0:186:9efb:7203 with SMTP id j18-20020a170902f25200b001869efb7203mr64076647plc.12.1668099264125;
        Thu, 10 Nov 2022 08:54:24 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s10-20020a17090a764a00b0020ad26fa65dsm14455pjl.56.2022.11.10.08.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 08:54:23 -0800 (PST)
Date:   Thu, 10 Nov 2022 16:54:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [PATCH] KVM: x86/mmu: avoid accidentally go to shadow path for 0
 count tdp root
Message-ID: <Y20svCKydu/iS0TY@google.com>
References: <20221110034122.9892-1-yan.y.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110034122.9892-1-yan.y.zhao@intel.com>
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

On Thu, Nov 10, 2022, Yan Zhao wrote:
> kvm mmu uses "if (is_tdp_mmu(vcpu->arch.mmu))" to choose between tdp mmu
> and shadow path.
> If a root is a tdp mmu page while its root_count is 0, it's not valid to
> go to the shadow path.
> 
> So, return true and add a warn on zero root count.
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index c163f7cc23ca..58b4881654a9 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -74,6 +74,7 @@ static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
>  {
>  	struct kvm_mmu_page *sp;
>  	hpa_t hpa = mmu->root.hpa;
> +	bool is_tdp;
>  
>  	if (WARN_ON(!VALID_PAGE(hpa)))
>  		return false;
> @@ -84,7 +85,10 @@ static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
>  	 * pae_root page, not a shadow page.
>  	 */
>  	sp = to_shadow_page(hpa);
> -	return sp && is_tdp_mmu_page(sp) && sp->root_count;
> +	is_tdp = sp && is_tdp_mmu_page(sp);
> +	WARN_ON(is_tdp && !refcount_read(&sp->tdp_mmu_root_count));
> +
> +	return is_tdp;

I have a series/patch that drops this code entirely, I would rather just go that
route directly.

https://lore.kernel.org/all/20221012181702.3663607-9-seanjc@google.com

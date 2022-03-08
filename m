Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8484D219F
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 20:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349980AbiCHTg1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 14:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345935AbiCHTg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 14:36:27 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DA653B4F
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 11:35:30 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id w37so14186pga.7
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 11:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+eK2C3ly8Cl2iFzzFyVvGZbN05MoLU2NqJPmvYWFw8U=;
        b=DAMj+wWXR6cFkoP8arUXqWalFDnvVjRjnVrwZJP0laLI69rSm5u2H+ZFr9vE8o4IFC
         lm0iNJj+YMCTBoHIYp4Fp54clJzuPgST5mHtkqSeoOk4NI3p7Y7zzEhT/DtCz2XBIVIp
         AGB+sC8L1WqLwHAZgtGXRrV+7IjrCa2mnvwvm3P11I4C/ehEsew7urTCetp+LjEVc03N
         JF1kKQgyebCBj/q4KiVQHB5Q3Z+6TZvhY3O/HC3Hbsqfm284FJ5AM01QOjxSpUSjKWG8
         h3afhQQB5tE2mMqcIoyKPQ1FVrEMPnAlMemqD+rd6TU1YWwV8eimsRoJnrTohOR5x01z
         TnyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+eK2C3ly8Cl2iFzzFyVvGZbN05MoLU2NqJPmvYWFw8U=;
        b=vXjSAtExNh3hPbo8mlf9BH+w6uvisL4SI8lC2VQ62QTiFfMMTfIdBbkheBEqBjVwDH
         5kv3n/AAhY3rWjW+Sze0EYwQR3ZdxE67iKAWz8g+aIkBWjLs2STiYr5VYpuPZvyecZl9
         158+1MYPZxTbdEYwz2t06yVwvUqDfnWe8+g+T/pA+b6SmZkKDw/ANcS5CP3uwTLBYhTy
         8tI9TolfNajwpTXyYyvYGay4vvgJo0EwDOkncP9/I6P1+gkJRj3T6GFIvMoaxhzNaKGc
         xGsqAsBC8AzwJH72B7lNMOSHXqaJrjSSWDvve0kgl/hwocKbqSZwlYOg3rOASWevGfdm
         wVgw==
X-Gm-Message-State: AOAM531EqBMPcOa1wE6+7wUHjkHjK2oy50OFn1BkPxxAn23Tg0KuS8av
        T//MW2bN3uKyAfOh4lGs4oHYXXeOtE006w==
X-Google-Smtp-Source: ABdhPJwD1h6m87kUVxmACAN/f4+T45T+fL+brdtEm1R/0gODZIN67V3yMFpW8GkRg54Ox+QX/JqaQw==
X-Received: by 2002:aa7:9af0:0:b0:4f7:de1:2796 with SMTP id y16-20020aa79af0000000b004f70de12796mr9134788pfp.29.1646768129292;
        Tue, 08 Mar 2022 11:35:29 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x27-20020a056a00189b00b004f6ebda8fa5sm11876690pfh.175.2022.03.08.11.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 11:35:28 -0800 (PST)
Date:   Tue, 8 Mar 2022 19:35:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
Subject: Re: [PATCH v2 19/25] KVM: x86/mmu: simplify and/or inline
 computation of shadow MMU roles
Message-ID: <Yiev/V/KPd1IrLta@google.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-20-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221162243.683208-20-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 21, 2022, Paolo Bonzini wrote:
> @@ -4822,18 +4798,23 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
>  {
>  	struct kvm_mmu *context = &vcpu->arch.root_mmu;
>  	union kvm_mmu_paging_mode cpu_mode = kvm_calc_cpu_mode(vcpu, regs);
> -	union kvm_mmu_page_role root_role =
> -		kvm_calc_shadow_mmu_root_page_role(vcpu, cpu_mode);
> +	union kvm_mmu_page_role root_role;
>  
> -	shadow_mmu_init_context(vcpu, context, cpu_mode, root_role);
> -}
> +	root_role = cpu_mode.base;
> +	root_role.level = max_t(u32, root_role.level, PT32E_ROOT_LEVEL);

Heh, we have different definitions of "simpler".   Can we split the difference
and do?

	/* KVM uses PAE paging whenever the guest isn't using 64-bit paging. */
	if (!____is_efer_lma(regs))
		root_role.level = PT32E_ROOT_LEVEL;

> -static union kvm_mmu_page_role
> -kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
> -				   union kvm_mmu_paging_mode role)
> -{
> -	role.base.level = kvm_mmu_get_tdp_level(vcpu);
> -	return role.base;
> +	/*
> +	 * KVM forces EFER.NX=1 when TDP is disabled, reflect it in the MMU role.
> +	 * KVM uses NX when TDP is disabled to handle a variety of scenarios,
> +	 * notably for huge SPTEs if iTLB multi-hit mitigation is enabled and
> +	 * to generate correct permissions for CR0.WP=0/CR4.SMEP=1/EFER.NX=0.
> +	 * The iTLB multi-hit workaround can be toggled at any time, so assume
> +	 * NX can be used by any non-nested shadow MMU to avoid having to reset
> +	 * MMU contexts.
> +	 */
> +	root_role.efer_nx = true;
> +
> +	shadow_mmu_init_context(vcpu, context, cpu_mode, root_role);
>  }
>  
>  void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
> @@ -4846,7 +4827,10 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
>  		.efer = efer,
>  	};
>  	union kvm_mmu_paging_mode cpu_mode = kvm_calc_cpu_mode(vcpu, &regs);
> -	union kvm_mmu_page_role root_role = kvm_calc_shadow_npt_root_page_role(vcpu, cpu_mode);
> +	union kvm_mmu_page_role root_role;
> +
> +	root_role = cpu_mode.base;
> +	root_role.level = kvm_mmu_get_tdp_level(vcpu);

Regarding the WARN_ON_ONCE(root_role.direct) discussed for a different patch, how
about this for a WARN + comment?

	/* NPT requires CR0.PG=1, thus the MMU is guaranteed to be indirect. */
	WARN_ON_ONCE(root_role.direct);

>  	shadow_mmu_init_context(vcpu, context, cpu_mode, root_role);
>  	kvm_mmu_new_pgd(vcpu, nested_cr3);
> -- 
> 2.31.1
> 
> 

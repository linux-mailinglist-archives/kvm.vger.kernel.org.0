Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4464D20C5
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 19:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244002AbiCHS44 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 13:56:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236164AbiCHS4z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 13:56:55 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B8453E1B
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 10:55:58 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id a5so182655pfv.2
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 10:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y40f+LRCmG2arycVRHxOvpE+w/RZPs9orfaERHReGAg=;
        b=bcCUYI+9/valn64igaiGGIKkFleK2VVOpLQ/Ce62yPauw4vMRigqISiCiyTYqxAkHQ
         +oVGv80ZKvRJwlXg2Qb/+JDkRbq42rqCVi/G5e1TshasTHSKtI8YtwMb1fdI0A7tnzEV
         Lx/0sfSqS/3w3TPB9LX2h7rO3qGKXHQJcXR3QbLzlxKusX0A4VXIU3UMeIBvIEXVatRh
         gg3zEnioIFLtuYv3zudFcUO9XIX1q4qjWEuG2hKNcqxEVEbEO5hS3e9KgITt/QCE5l5l
         hqb5XNkxo6PmRpDSkYz0S8aJMm91uZo/+Ctxa1sVlBOy/w8/4Ja8C7xbWXGwhtctt50d
         n39A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y40f+LRCmG2arycVRHxOvpE+w/RZPs9orfaERHReGAg=;
        b=6bdjNinIr2zeKEeRPYfhFSjEia2wU/SLVVyAod6qtljQZIncxuzILb1D31sF93FdP+
         OahZOTxyAP8CiAOIRwpLUhRk8WSF2o6YAsNnp9V6Hnh9UlpEkUo2xzHHCa7EGw3nI0O3
         tFR3zoxr3eTjaxY6o0qIGbrjuZFQECn/HwUL8KLzggZ5d8l+zvXUoWn8+D4zBA9mZsz/
         c/BlgcRsC88hH31cxBxqLl25jV3BDQKWxe3MiOTu+a9UbY7ANEUDGQ8fpbDlb0LwLzos
         nEhogGemUm9m+0I00rCOd215o7yhHeI1MWVI6tOTT2V/pJkx47CdY0qFx45ML2eXOwjh
         u9yg==
X-Gm-Message-State: AOAM531CrBUnFolowDLAMKk+KgjknLCejpXMhicG1yCSxtsqzAVralHX
        hD9RWgh6oSQLQXkKQkqdPlme/w==
X-Google-Smtp-Source: ABdhPJwcEDBu6JX4mIGKlcpXlcrkdx2/792obZa79cvfvYy/QfjS4SaXi48cxFejeJgdTIyDxVMRiQ==
X-Received: by 2002:a63:698a:0:b0:36c:1d0a:2808 with SMTP id e132-20020a63698a000000b0036c1d0a2808mr15284498pgc.567.1646765757848;
        Tue, 08 Mar 2022 10:55:57 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q20-20020a056a00151400b004f3cd061d33sm21169799pfu.204.2022.03.08.10.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 10:55:57 -0800 (PST)
Date:   Tue, 8 Mar 2022 18:55:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
Subject: Re: [PATCH v2 08/25] KVM: x86/mmu: split cpu_mode from mmu_role
Message-ID: <YiemuYKEFjqFvDlL@google.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-9-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221162243.683208-9-pbonzini@redhat.com>
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

On Mon, Feb 21, 2022, Paolo Bonzini wrote:
> @@ -4800,13 +4836,15 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
>  }
>  
>  static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
> -				    const struct kvm_mmu_role_regs *regs,
> -				    union kvm_mmu_role new_role)
> +				    union kvm_mmu_role cpu_mode,

Can you give all helpers this treatment (rename "role" => "cpu_mode")?  I got
tripped up a few times reading patches because the ones where it wasn't necessary,
i.e. where there's only a single kvm_mmu_role paramenter, were left as-is.

I think kvm_calc_shadow_npt_root_page_role() and kvm_calc_shadow_mmu_root_page_role()
are the only offenders.

> +				    union kvm_mmu_role mmu_role)
>  {
> -	if (new_role.as_u64 == context->mmu_role.as_u64)
> +	if (cpu_mode.as_u64 == context->cpu_mode.as_u64 &&
> +	    mmu_role.as_u64 == context->mmu_role.as_u64)
>  		return;
>  
> -	context->mmu_role.as_u64 = new_role.as_u64;
> +	context->cpu_mode.as_u64 = cpu_mode.as_u64;
> +	context->mmu_role.as_u64 = mmu_role.as_u64;
>  
>  	if (!is_cr0_pg(context))
>  		nonpaging_init_context(context);

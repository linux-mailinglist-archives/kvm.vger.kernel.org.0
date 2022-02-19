Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35CDC4BC345
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 01:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240343AbiBSAXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 19:23:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234622AbiBSAXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 19:23:13 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3D06E34B
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 16:22:55 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id d16so9184321pgd.9
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 16:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PKozzWeotfW0H/XChUhKVfvoVAWx3v86SwCGH78y65k=;
        b=YJr7T4GPIwDLm8MhhOOQayyse45vPIFv4uPo7XIm+miZ9JCsK1JdIoXK3rAPZLB5X4
         A5CrKN2EGzd1cx5YPsdVhNoBP2nvJvTS/4QmYgq19BFsLKn3YLZYB9LJ8xgqA/uchgUP
         ipCYRjqs/l0CY3IVqWzqCQtTcQeA0rNGszozpIa2Zx6netouSyuIUZq28gdMEIF9VStY
         JKN6n7q0vweWxZEDIlaG78NXQVOwViN+B2oSQp+FSwOTjG11PB1XxaW1DqIS6HFxZ69S
         qc5rB61GQSn1mjkgAWZJ8+Bx6Bjc+qVnwuCDcLglHfqIMXvEWaayvbu8KmVN9SES6FNm
         H2KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PKozzWeotfW0H/XChUhKVfvoVAWx3v86SwCGH78y65k=;
        b=V9YJgD1pzWVOmJG4GJaQ9wO0bnsjDlhWBc3vPd9aJ4CVG8qFgbgNG8ufmI7dCsWnCX
         o4wfAt0+I12iexTHqmUkYlQ8Khzq4sHv83da7OkwB85+E1XXkOV16ONIdryQCQIOpxid
         4TYhf7rKIVyykb5lHJChQG5dfKk3UAU8wa3JKpucsmyH9mbhwfq+1R8yyGG/SOjgOkCM
         NgzfGm8QysqIsfVzx8F+5TTeD9DmrhOYJBy74Ywqz7WYpL2UhgdNNC7I7cHhpniu1pT0
         b456mh3SRBEAB2DV0A5cZoBUeCJsTScMjywjsrOqz1S+bqAPm9q/OhyNMx0x/RoMx0Ba
         FXqQ==
X-Gm-Message-State: AOAM533OiiCfRSX9xAPqt2Hs26QtEs6otqnwfhjj6QmS10cXK34x+6d0
        T7Pr7j89VKs0cYXrZYoeXY1u0Q==
X-Google-Smtp-Source: ABdhPJyam7kTYq5rTQAMSu2ALEE50Ee8PLPQAi1b3BzbfQybJRbIYqYjX74rsUr8nmhHftAfrz1Whw==
X-Received: by 2002:a05:6a00:2391:b0:4a8:d88:9cd with SMTP id f17-20020a056a00239100b004a80d8809cdmr9879701pfc.11.1645230175301;
        Fri, 18 Feb 2022 16:22:55 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i17sm12004965pgv.8.2022.02.18.16.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 16:22:54 -0800 (PST)
Date:   Sat, 19 Feb 2022 00:22:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 13/18] KVM: x86: reset and reinitialize the MMU in
 __set_sregs_common
Message-ID: <YhA4WkeqPxbA3IEJ@google.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
 <20220217210340.312449-14-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217210340.312449-14-pbonzini@redhat.com>
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
> Do a full unload of the MMU in KVM_SET_SREGS and KVM_SEST_REGS2, in
> preparation for not doing so in kvm_mmu_reset_context.  There is no
> need to delay the reset until after the return, so do it directly in
> the __set_sregs_common function and remove the mmu_reset_needed output
> parameter.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

> +	kvm_init_mmu(vcpu);
>  	if (update_pdptrs) {
>  		idx = srcu_read_lock(&vcpu->kvm->srcu);
> -		if (is_pae_paging(vcpu)) {
> +		if (is_pae_paging(vcpu))
>  			load_pdptrs(vcpu, kvm_read_cr3(vcpu));
> -			*mmu_reset_needed = 1;

Eww (not your code, just this whole pile).  It might be worth calling out in the
changelog that calling kvm_init_mmu() before load_pdptrs() will (subtly) _not_
impact the functionality of load_pdptrs().  If the MMU is nested, kvm_init_mmu()
will modify vcpu->arch.nested_mmu, whereas kvm_translate_gpa() will walk
vcpu->arch.guest_mmu.  And if the MMU is not nested, kvm_translate_gpa() will not
consuming vcpu->arch.mmu other than to check if it's == &guest_mmu.

> -		}
>  		srcu_read_unlock(&vcpu->kvm->srcu, idx);
>  	}
>  

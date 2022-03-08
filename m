Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28364D21E9
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 20:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349998AbiCHTt1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 14:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349721AbiCHTtZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 14:49:25 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E842B39BBD
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 11:48:28 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id q11so28317pln.11
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 11:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4fyfnxj92k5W9rcKN1dJwICOBJKughLQrnvCk7UQagQ=;
        b=Cxpew77bEL6PrGKAI6JSibIWnNHYAAuwav23jRL4Du8wLegKGlUwDfTSeV0ZT0wwg3
         KV4wz2azpR9tupf/1B4UOwNb+hsvbMhWOjpWUIktiXhypAAGAFKiEFPomvy48kgV4sfs
         /PaCk9ttAd1buxNYKAguc5onYFZuklHIoY4Mxe3SIcZN/BaHiSSC7JeemtshtgQJxpVE
         PcaUc1Wyms6fDjFhje3QNL0O9D62SgaTraCk/grIkkOFmA/h/NbRjqQ4Uq5j5JpQHHls
         D0JVfMbNhBSRRTwDs9b/5qYZSzcta1y3IlRU4rPYQQimFgDbUhassg2abiRcsE2MQbc8
         TE1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4fyfnxj92k5W9rcKN1dJwICOBJKughLQrnvCk7UQagQ=;
        b=7LU5jsrVKCdv9su6kGA6gKir/33w6yvklQHd4vNOFWIF3A9c9kHGUEyommwwP+JrvU
         0pfjZoXsjaQkbc+RBkX7UArd3sbtUu/3cn/CHnPvpGszUj2LVPjGDt2yFqBS3Se1WxWA
         ajY7VpCO/kKCo6+6z8NONE1lOsC5KMzeebxtTcMgXY+w9mjhxFJMElNh4qNFBqCDcZvB
         s5CtAFVRVxw8cuMQdOM22wNciTWsgXl9GnAIsJMlN7TGp5ZCwutM3DjX+JIEPCQzDXf4
         EGdiiIPR7CCxXrxPsp045sldshlaSzjJ7jcL9bKKDCnZL5z0ZxsXfrqmj4uYUoOdTCgT
         hoQw==
X-Gm-Message-State: AOAM5323/9HvN0VBatHYnEmriH8vOrVktl1BiJHLbVBbL7EqTK7VSu7I
        4niSr1Vmy6PdsWs48n+2C11G9Q==
X-Google-Smtp-Source: ABdhPJwUIm6VOlVKu5rtCXgksk7sRQfJvaYEQ+1/a90qbq+A0jEgprS5omGyN+F7ZQmkI2kSJLrORg==
X-Received: by 2002:a17:90a:a78d:b0:1bc:d11c:ad40 with SMTP id f13-20020a17090aa78d00b001bcd11cad40mr6381715pjq.246.1646768908344;
        Tue, 08 Mar 2022 11:48:28 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l11-20020a17090a660b00b001bf576cd2fasm3677893pjj.37.2022.03.08.11.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 11:48:27 -0800 (PST)
Date:   Tue, 8 Mar 2022 19:48:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
Subject: Re: [PATCH v2 21/25] KVM: x86/mmu: replace shadow_root_level with
 root_role.level
Message-ID: <YiezCBsD7Mj8hLEn@google.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-22-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221162243.683208-22-pbonzini@redhat.com>
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
> root_role.level is always the same value as shadow_level:
> 
> - it's kvm_mmu_get_tdp_level(vcpu) when going through init_kvm_tdp_mmu
> 
> - it's the level argument when going through kvm_init_shadow_ept_mmu
> 
> - it's assigned directly from new_role.base.level when going
>   through shadow_mmu_init_context
> 
> Remove the duplication and get the level directly from the role.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 -
>  arch/x86/kvm/mmu.h              |  2 +-
>  arch/x86/kvm/mmu/mmu.c          | 33 ++++++++++++++-------------------
>  arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
>  arch/x86/kvm/svm/svm.c          |  2 +-
>  arch/x86/kvm/vmx/vmx.c          |  2 +-
>  6 files changed, 18 insertions(+), 24 deletions(-)

Yay!  That's a lot less churn than I expected.

Reviewed-by: Sean Christopherson <seanjc@google.com>

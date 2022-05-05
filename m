Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0975951CBBA
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 23:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbiEEWCi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 18:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357821AbiEEWCh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 18:02:37 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97895C743
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 14:58:56 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id gj17-20020a17090b109100b001d8b390f77bso9179517pjb.1
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 14:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eAKJ/icQ2pJarmVikk6ugi8Bvpa8Rc3R9Y/ObEeqjH8=;
        b=M3ZzJgDT9ekyNJ96FH0MMSzeB14ns1BDlk016eZT1S0ep/cD4p1f1RTvih2cYmfuI6
         vFHrqU+9vIndYuNNK3AH4Dgm7kuFxZWZJkhyzMR4YOGjxZkYm1Z0EMXaLClIa8P7IVwL
         QtyC+BFeYTLUFomnyGMTCsLedrWhZCqZ/iU5JEbvABbUYTbxAczSe3AxtOSaTXAdovrL
         gXSYBjiw/rhbl7qw1z1JlCdnFZNzo1cOnflppFA0mTKn0HVdVUWqg4ori73GbSGNuRUY
         Q0QxlbRs+rt1HWOWCDy8/jExhZUX/p+D3mWU5Dz1V6JSaLpCcsd9QEMbSyHxxECeDk4v
         uA6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eAKJ/icQ2pJarmVikk6ugi8Bvpa8Rc3R9Y/ObEeqjH8=;
        b=s4pBDUv63xYhNHN3Qs5C1XE6dO3vHMEwjQYTVa7ocd4e/rSsYeLD/A+uJ/bwyAvAfY
         xjXZpwc4IYRjv3idMPL2PqusnAtDQglKiY9Dx4OFocnHVOYM7Tm59vFo9fGxP6meadAE
         ZIu/Fa/VAughEvFm9MOLPA/gEGOGlYpJUGl/JMO3uVnYWDcKrYio+n7O05rsxkFtnP4X
         pQ99USfqFE3MVAQtGqSrh6osw9lbuWQgreQ16mNoyHNU2TTHqaVAGXHqsLWJAQ50tXsD
         C2Uqn6Oe3KfX5p57LwSYYth/bdjNy9JKAOopIFWtM9YAxC5hIq+A635v3foiS1cQc3e4
         yDTQ==
X-Gm-Message-State: AOAM531XahEIBLz7y+6O53y+5fE3qe3VaIfGHSniVu9cDsLvweeUvXOu
        58JIQTCYsHI4t5gWuIN0WVne4Q==
X-Google-Smtp-Source: ABdhPJy4viwkpqIW9TUUZ8Fu3CuE6qIgT5lnM973mXUD1A/F1HkwRsjvVk5v2hTKHhjIcHpWlHRYYQ==
X-Received: by 2002:a17:902:cf05:b0:156:8445:ce0f with SMTP id i5-20020a170902cf0500b001568445ce0fmr178549plg.99.1651787936011;
        Thu, 05 May 2022 14:58:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a3-20020a170902900300b0015e8d4eb1e7sm128177plp.49.2022.05.05.14.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 14:58:55 -0700 (PDT)
Date:   Thu, 5 May 2022 21:58:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v4 04/20] KVM: x86/mmu: Decompose kvm_mmu_get_page() into
 separate functions
Message-ID: <YnRInPVAd7BEBpk6@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-5-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-5-dmatlack@google.com>
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

On Fri, Apr 22, 2022, David Matlack wrote:
> Decompose kvm_mmu_get_page() into separate helper functions to increase
> readability and prepare for allocating shadow pages without a vcpu
> pointer.
> 
> Specifically, pull the guts of kvm_mmu_get_page() into 2 helper
> functions:
> 
> kvm_mmu_find_shadow_page() -
>   Walks the page hash checking for any existing mmu pages that match the
>   given gfn and role.
> 
> kvm_mmu_alloc_shadow_page()
>   Allocates and initializes an entirely new kvm_mmu_page. This currently
>   requries a vcpu pointer for allocation and looking up the memslot but
>   that will be removed in a future commit.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Nice!

Reviewed-by: Sean Christopherson <seanjc@google.com>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5303451CBF9
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 00:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386254AbiEEWSs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 18:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386246AbiEEWSq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 18:18:46 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316165EDDE
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 15:15:06 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id cx11-20020a17090afd8b00b001d9fe5965b3so9191099pjb.3
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 15:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rhmYFBuuuGy1RxOFm4pAb+0D/79gx/RMlr5Dc55L7tE=;
        b=Hevs7iSy4zrNQh8iUyApFus8Hf9y6uwirVrl404PJBhu4YCBeMs/nvv/PiBjRl+b9i
         goS/roI0Sv6/OsNtAcxoeKDrrvT4LL4FxzU1MF23u9/kotSU7iUbeJiTEl0dKhoec8HI
         1g1ivpEqMwBvd+hGNePXFx1rDNZF7KcydiJOp+m2RS7cIFUDaycqErgr2PVPG0U7fSOq
         skKBUtXQrXg71hEIZsbWE+vb7R0oG9f9JAsO7Z/Ov/52rUXtfu3vbd3dtaquznZRy3aW
         rlOJ3uaUYC5GnvEOnDiOi70MiKyrjhRYDxUdUJG6fAoZ/btOiY9IbYZK0vT+0sp5ol/T
         UEOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rhmYFBuuuGy1RxOFm4pAb+0D/79gx/RMlr5Dc55L7tE=;
        b=I1WucTXwBmFBO1gVVck8m+1a4YJ2bhDHJq0T+0dN6gktGP0s53EvytzEHasdLgFZE5
         YWyGiEtRNW9gLt3glovSxCY+uCmRO2xULFglfNM+8YzA2xfDHNP8uTscsq3rNvprbFC2
         fAOoiy21S3s2LAQZ43iil5NYa+mRb5kSrd+2emFNcNUC+37jVsH52bDUay5Z3Y7QbrwZ
         nmNybUd+njqkG7CGDKuhmWElvIRNiH8fN9CWFekCJlFiiS1sTKTiH9Pi7ajoCp0GWGMn
         U7pqJejPcHc0+KBdKqtVupnKA0nE2l9KXmqMGGHq3Zqslogke0O2dhQZpLpaG7jsCrpJ
         LEaw==
X-Gm-Message-State: AOAM533TxoJbgHlF1jptvbSKSHHcI/+J8Ryp1Rcp6sUXqLPbC2Qd99t2
        rGDRbl9aaVUUPeGTTBvYJXi6XQWBmzwFKg==
X-Google-Smtp-Source: ABdhPJzsuSElxGPQgHtlbw0iGopvkRi5CXOoenk4IleklHGbnOGmfb8DaUwsp1YoXq+iTVmqk8ldWg==
X-Received: by 2002:a17:902:9005:b0:158:e46e:688c with SMTP id a5-20020a170902900500b00158e46e688cmr222968plp.173.1651788905567;
        Thu, 05 May 2022 15:15:05 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n23-20020a17090a929700b001d7f3bb11d7sm5793137pjo.53.2022.05.05.15.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 15:15:05 -0700 (PDT)
Date:   Thu, 5 May 2022 22:15:01 +0000
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
Subject: Re: [PATCH v4 06/20] KVM: x86/mmu: Rename shadow MMU functions that
 deal with shadow pages
Message-ID: <YnRMZZi6vskW9p60@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-7-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-7-dmatlack@google.com>
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

On Fri, Apr 22, 2022, David Matlack wrote:
> Rename 2 functions:
> 
>   kvm_mmu_get_page() -> kvm_mmu_get_shadow_page()
>   kvm_mmu_free_page() -> kvm_mmu_free_shadow_page()
> 
> This change makes it clear that these functions deal with shadow pages
> rather than struct pages. It also aligns these functions with the naming
> scheme for kvm_mmu_find_shadow_page() and kvm_mmu_alloc_shadow_page().
> 
> Prefer "shadow_page" over the shorter "sp" since these are core
> functions and the line lengths aren't terrible.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

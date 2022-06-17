Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A4354F9C4
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 17:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382639AbiFQPCA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 11:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382201AbiFQPB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 11:01:58 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4A141611
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 08:01:57 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id b12-20020a17090a6acc00b001ec2b181c98so3221771pjm.4
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 08:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=67qC+hjpQQ8/u9lImvfqVDPKc0MC50T6OyuazzxQTOs=;
        b=rcfjRAXxIPRtebzytFQ4rdSLQPqdVJUVxjkJrOP2+ko477yKr0ij30QC5VTxQvmOZ1
         bFDDGtEpXpALWRNA0AKUnQh24Ko2VZIH+URIKsdIq0cycBHC6uFgxJU9+xElyqc8enXi
         h8CN/B/Frtq3zfIeRuxjL024ZWbiEDZgVBKOOL1LsuCCvGmmVR08SIqY8f6S6o4Xlo5T
         bCUAM0Ri8COUC7loHrkQgZQk6SBAQ+fUUa+AdDjmblGImt7BZanv1Pn5xBfUFA8ISN2H
         g2VrKo7DWnK0HLqxyahPVDdaz0lu7ZBRlpMfVPvpgyT87bUFm74HAYxaB2zDe5kuSQVV
         DaWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=67qC+hjpQQ8/u9lImvfqVDPKc0MC50T6OyuazzxQTOs=;
        b=SzEWmowemtogy6GcCAZzpiCAApljeBifLB5KQ28jQJHioQg1dYgwYAklGQqIIIv/R/
         p0h51DuW6b4SK+CK9gcRKLfZq3fQ78bOuUaTpwxqgMgDwnj6+dB5KSm6MLxm7l6VuR7V
         njdqOom1XYV+/8QXEhTPfBGA4Ttgm3/bJEF5B2cXuDsTbDrVjFbB5P/jok8qB+sMOUU6
         9Fbq93S8nSclxFTIJV7c+vl+MkzAFAQO4pdJihD8tETIuiSjAKiBWOyP9tt6u2+24pX7
         NRvBFT/SPo1H9IEYWNBS9cWtpxt4AIxUbChBfJgXg8RUIsVhSfytJFycejnFnuRbHqLn
         EKBg==
X-Gm-Message-State: AJIora+lnyUtKvIQhy4Bbx24JmtVMoWc6409yN50kQLLqPzJNb0R4wWe
        rzNHWmmIFJHqlIzBtL8rHp9vGA==
X-Google-Smtp-Source: AGRyM1uFEQsMzgu/EpRCLWD/tpRg2MiJuqY9ezxKkezmOL1sxRiLi0E4PmGYF22syg3VejhQ2hPZIA==
X-Received: by 2002:a17:90b:1e4e:b0:1e3:47e4:92b6 with SMTP id pi14-20020a17090b1e4e00b001e347e492b6mr21981003pjb.47.1655478117043;
        Fri, 17 Jun 2022 08:01:57 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id s17-20020a17090a5d1100b001e0d4169365sm5724411pji.17.2022.06.17.08.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 08:01:56 -0700 (PDT)
Date:   Fri, 17 Jun 2022 15:01:52 +0000
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
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [PATCH v6 10/22] KVM: x86/mmu: Pass memory caches to allocate
 SPs separately
Message-ID: <YqyXYJsoZGgp7l62@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-11-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516232138.1783324-11-dmatlack@google.com>
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

On Mon, May 16, 2022, David Matlack wrote:
> Refactor kvm_mmu_alloc_shadow_page() to receive the caches from which it
> will allocate the various pieces of memory for shadow pages as a
> parameter, rather than deriving them from the vcpu pointer. This will be
> useful in a future commit where shadow pages are allocated during VM
> ioctls for eager page splitting, and thus will use a different set of
> caches.
> 
> Preemptively pull the caches out all the way to
> kvm_mmu_get_shadow_page() since eager page splitting will not be calling

Uber nit, "eager hugepage splitting" to provide a mental cue/reminder for why
those pages are direct.

> kvm_mmu_alloc_shadow_page() directly.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

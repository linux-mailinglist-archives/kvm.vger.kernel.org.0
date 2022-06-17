Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D229454FBBA
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 18:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382738AbiFQQ4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 12:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382080AbiFQQ4Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 12:56:16 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FB0394
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 09:56:16 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y196so4646551pfb.6
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 09:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EArAgQNHoiHIS8I/ZApL03IuPB6zV8pnr3Tul9Qb4MA=;
        b=b05d1gKW6mYhXbruL2fyLtjmEA1GqVi1lTwTxPVkPVLuTfSdqq5m9T6gsUerOispOz
         GncQw5oSnE33n7yZ9QdMGjb2zBcmU5qp4sqQGYqEyrArd+dm12PIp9tNBw+pY11Bpsho
         VRmYa4FU94LtWTzGBUd/U1q4SvyhZ4VWiiGsORsiaolgKg34GXKRfBNZjiHHFnVq+zBr
         L3v4eiOGcP5LMru62F+f9fycIx+VXfh9t3Rp2HTfrLLgH8WmDRzgqspCo0KZMRTHS1h3
         QxZOOOz58CWG8UNyOazZDWZOUViiQPoOF7HnyBzDtgvtWAIeo8EufclXiIelAwlueBNS
         17fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EArAgQNHoiHIS8I/ZApL03IuPB6zV8pnr3Tul9Qb4MA=;
        b=RN1K2wYjq2EG3HMyB43E8YiBAUzsaVIUK7yRvncoCN1vrzoP596llbMQErA0JB3/o+
         yUE5pDP+Wsgom4hJwXq4ILAfkKMUFgOp6yaIza1dJOn0hLhDOibJs2gqpLSgt6ojjEM5
         25Zb64zXtV5ufcdr3fjEGqjjLM+1OionauznXfSMqE94zJtcxAuxC2o0JKu0S2pRNSqh
         yqcxwiXbYFjmS+UYheMw1tieUaVxTwHFhBIv4DKIdrkRLRGhByhEFomO8jkicXoLercv
         QR6WpOutG/Mo40OdpOHSbXvBk1BJvwNnoNwCH4IrTP488qOiLkoIcyAZVCt++w6FJ2Rg
         hndA==
X-Gm-Message-State: AJIora/ngvzYyH6oj/J8ujj/oTHv2wSdiy/5btWmZ7DYXwW/YT9U+UZD
        WHW884VHq70NauFgQkYkOmhrqg==
X-Google-Smtp-Source: AGRyM1szxMq8pcE45URHtBmbN5333qjIc6FM+zGUcOUachog0Av+tjeuGo1MIwJ5XrnGY8xO/l76lg==
X-Received: by 2002:a63:89c1:0:b0:3fc:6001:e871 with SMTP id v184-20020a6389c1000000b003fc6001e871mr10020666pgd.14.1655484975342;
        Fri, 17 Jun 2022 09:56:15 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id b14-20020a17090a8c8e00b001eab4b8383csm5776963pjo.5.2022.06.17.09.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 09:56:14 -0700 (PDT)
Date:   Fri, 17 Jun 2022 16:56:11 +0000
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
Subject: Re: [PATCH v6 18/22] KVM: x86/mmu: Extend
 make_huge_page_split_spte() for the shadow MMU
Message-ID: <YqyyK5C1PaByJur2@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-19-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516232138.1783324-19-dmatlack@google.com>
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
> Currently make_huge_page_split_spte() assumes execute permissions can be
> granted to any 4K SPTE when splitting huge pages. This is true for the
> TDP MMU but is not necessarily true for the shadow MMU, since KVM may be
> shadowing a non-executable huge page.
> 
> To fix this, pass in the role of the child shadow page where the huge
> page will be split and derive the execution permission from that.  This
> is correct because huge pages are always split with direct shadow page
> and thus the shadow page role contains the correct access permissions.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

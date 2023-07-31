Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2457876A373
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 23:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbjGaVzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 17:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbjGaVzR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 17:55:17 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E66D1B6
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 14:55:16 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-55c475c6da6so2984987a12.2
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 14:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690840516; x=1691445316;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mxm0zlWAhsdwPNs5iJKIB42nBu2Sipk2tDe8KMVu/ek=;
        b=ytmpshOAB12qGqTyFlWk5nuibqbjszjzG8HlzRak1nXLBRIW7mqhUOB3pdnUEqnw9p
         ULxnWPLZRD2mRlVyB/5q0bX5aw1YvfLLdUMnRf4zI7SyNr0EH4R4tqZ2ZiseNI/YvKYQ
         OZ7Y8CSXug8EnjUACyUdgtTfIF4qmkOQgAhYTbRl3Yf5EpZjTT6Y30q2mELLLrGNzfAI
         TWHiUWWZhxH6y1Ge+v/UQbVXBXj23ItOQKCwVAD9/GNOUpV5F9QWb/vBOmkWUJSZ5ia8
         2yt2+GgEWjOZeaHfuSn3YEhuGE3VZrD7PEIEAsa/FVk3PFxtUHAMyfY0BGbbF9GkdiQc
         vKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690840516; x=1691445316;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mxm0zlWAhsdwPNs5iJKIB42nBu2Sipk2tDe8KMVu/ek=;
        b=lDss5B6WXX7spjPnn+hAtss7eVi9KZT3TIwWya7mYvyMHTtR+lVS5YYbl5fcjRQQrF
         Zl0DykVuoJwpSr2J4drOnzkiWbJ0Pnx5aoj/K+tP+RYPEh/ClC7CgQvRKuj1/wGMWSdS
         1II7vRKDFURtapM7xKIf8im1xRMnTZkcSDp7p5t3x/V355qUvy2rihv8Ou4mq0MlYmt3
         hxxuMkA0BHrJemtmcSBD7g3ShErdxKrsmatVeTscGHMuUebXExHLaLfQRoYV87GepOXE
         S76JHkOk/o3BGZoBGinmuXXpioc/QFLNbr1cnvBL1HyLHo/+5NGKutcn45DbliMzM9Bk
         U2eA==
X-Gm-Message-State: ABy/qLbBh2jPyok9ViTJ50AWHb0NbdUH9TcrHsUfK7+c82r/zVjZM4rh
        0mSaMOPIdyuIg501BMPFUrUoPovkshI=
X-Google-Smtp-Source: APBJJlHx/oZJ65GqvDqk2V7Za+tbO1+mKQOFTUapwiCiODu7Ma2pbwshPhgFtt7G52AjT0XsLIyUCa+03cU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2309:b0:1b3:bfa6:d064 with SMTP id
 d9-20020a170903230900b001b3bfa6d064mr49693plh.1.1690840515767; Mon, 31 Jul
 2023 14:55:15 -0700 (PDT)
Date:   Mon, 31 Jul 2023 14:55:14 -0700
In-Reply-To: <20230722022251.3446223-5-rananta@google.com>
Mime-Version: 1.0
References: <20230722022251.3446223-1-rananta@google.com> <20230722022251.3446223-5-rananta@google.com>
Message-ID: <ZMgtwp/YCZciRvdr@google.com>
Subject: Re: [PATCH v7 04/12] KVM: Allow range-based TLB invalidation from
 common code
From:   Sean Christopherson <seanjc@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 22, 2023, Raghavendra Rao Ananta wrote:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ec169f5c7dce..eb88d25f9896 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -278,16 +278,15 @@ static inline bool kvm_available_flush_remote_tlbs_range(void)
>  	return kvm_x86_ops.flush_remote_tlbs_range;
>  }
>  
> -void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
> -				 gfn_t nr_pages)
> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)

Please keep "nr_pages", I have a very strong preference for that over just "pages"
as the "nr_" makes it super obvious that it's a single number, as opposed to an
array of pages or something.

And it doesn't truly matter, but IMO the gfn_t type is more appropriate since
the gfn and the number of pages need to have the same type.

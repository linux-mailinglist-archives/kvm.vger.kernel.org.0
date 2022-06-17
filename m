Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABBF154FC53
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 19:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbiFQRl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 13:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbiFQRl6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 13:41:58 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8577F3F30C
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 10:41:57 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id g8so4456197plt.8
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 10:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/I2MpXcjw3AyYEvY6nT3sj6eeTPFPpb8SnX52+vnNhI=;
        b=SrVIGN592I55tVcbNN6o+NeIvQUZsEvz/Cd/zBTooQP5MUHDNsHnEIe/HEIvL02MeS
         +Vyb3GJ6hErVeRvGS4HKJZ8esknwX53f3/JYrKgK6qbHVwKjP6g5DTzaSfNSoSuWQSUE
         0OpWVK9BS9qSSbcucEV6DeKwOo8YJIoV+RGeD2gyNROhhDqiT5D4ALRgYjWzdtBz4f1z
         KKgXsB4qjmX8Ii5d4QgiGZj9HhJ2UScgx+TKViXz+8p4mWC2jvzXsTcDbiDYFKdUxp2Y
         T0ok5qmZxXkaKD6iNmhtGJtvy5CJM+LV5fEouuWd7p08FI5WsuMwnP7LbyGa5BVLe0Zk
         V/1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/I2MpXcjw3AyYEvY6nT3sj6eeTPFPpb8SnX52+vnNhI=;
        b=DnVT2CnbJUFXvg+bxtF+nJrqv+7e77iA2AjhBZtFb9cr3+c3kL/ARsbzL1tKBxg6XG
         pi89UNb3GUwi+3uSa4S0vHszbTt2BO488ZESFIiVsmjEXmWXyeM+vVRa+J4R7/n7Oi06
         3DtT/AZl0TJW+/kP27UxAoGHZMogejMOH1si2f7ic1qpIqF5rNl5W+Z8DbVp6LDIcXtc
         ddG69BZAjCU0v1FwaB+9YKCd5zKY5FaEsP2ZjTkOjV/wZdJCOUQMuCN1vwQVxLJE6S95
         IjECz2Dbsqk82RBzZ2sGGKeVSm8oF7ucKrMrm3IWqPvP+RDTIJIblziDo7KPTGowBHPX
         qgaQ==
X-Gm-Message-State: AJIora/vxwPO+/KTF4S6ZNg6rN6nFYhrbl6kvQCeweGoAm0VHGKNS8VY
        reyKYbl8ZV+32X7joCCREZiCNw==
X-Google-Smtp-Source: AGRyM1t9uTrYoSS1GO4s/tyedBnGd6ejt1GvCWW+u/gAjLzqhH4WzpxK/5q7wKeu3TQmWYILwdJAhA==
X-Received: by 2002:a17:903:1105:b0:168:9cac:a0a5 with SMTP id n5-20020a170903110500b001689caca0a5mr10965048plh.59.1655487716808;
        Fri, 17 Jun 2022 10:41:56 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id jj21-20020a170903049500b001616e19537esm3817546plb.213.2022.06.17.10.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 10:41:56 -0700 (PDT)
Date:   Fri, 17 Jun 2022 17:41:52 +0000
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
Subject: Re: [PATCH v6 21/22] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
Message-ID: <Yqy84GkGAdE1BzI6@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-22-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516232138.1783324-22-dmatlack@google.com>
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
> -int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> +static int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)

I still find it somewhat kludgy to have callers provide an capacity.  It's not
terrible while there's only a single call site, but if a use case comes along
for using an oversized cache with multiple call sites, it'll be gross.

Tweaking my idea of a "custom" wrapper, what about adding an "oversized" wrapper?
That yields clear, firm rules on when to use each helper, guards against calling
the "standard" flavor with an impossible @min, and addresses Mingwei's concern
that a misguided user could specify a nonsensically small capacity.

The only quirk is that kvm_mmu_topup_memory_cache_oversized() has a fixed min,
but IMO that's an acceptable tradeoff, and it's a non-issue until another user
pops up.

static int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc,
					int capacity, int min)
{
	gfp_t gfp = GFP_KERNEL_ACCOUNT;
	void *obj;

	if (mc->nobjs >= min)
		return 0;

	if (unlikely(!mc->objects)) {
		capacity = max(min, KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE);

		mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
		if (!mc->objects)
			return -ENOMEM;

		mc->capacity = capacity;
	}

	/* It is illegal to request a different capacity across topups. */
	if (WARN_ON_ONCE(mc->capacity != capacity))
		return -EIO;

	while (mc->nobjs < mc->capacity) {
		obj = mmu_memory_cache_alloc_obj(mc, gfp);
		if (!obj)
			return mc->nobjs >= min ? 0 : -ENOMEM;
		mc->objects[mc->nobjs++] = obj;
	}
	return 0;
}

int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
{
	const int capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;

	if (WARN_ON_ONCE(min > capacity))
		min = capacity;

	return __kvm_mmu_topup_memory_cache(mc, capacity, min);
}

/* Oversized caches have a fixed size, i.e. min == capacity == size. */
int kvm_mmu_topup_memory_cache_oversized(struct kvm_mmu_memory_cache *mc, int size)
{
	if (WARN_ON_ONCE(size < KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE)
		size = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;

	return __kvm_mmu_topup_memory_cache(mc, size, size);
}

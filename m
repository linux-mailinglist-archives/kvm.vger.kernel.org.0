Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9CD57A0D4
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 16:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239123AbiGSOL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 10:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239050AbiGSOLC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 10:11:02 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA56B491F3
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 06:30:22 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id j1so17140215wrs.4
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 06:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aeU9cgOyyIosd32FJcgD+fpFlGUSWOLfdLntVffrwYI=;
        b=hux2JLvdiv0cwO+vggf9NbJXBqDg2Ko8RqWrIxcttc9Hg0kU7gZtV0HtaGsYzMJN5r
         2xw+PCxakX3m3q/UPEjcRkRQGRkSeFJ2fEGDqyoqsTV9ixkD9v22Id1hMmzBNtUiDsV3
         Kop16VLrqGjXK9trmzw+2iuf+R8SFC6k5cm5xvtgAuXyR91yLdQxFt2Hks/xD4SMcbkv
         RpHxN4o4uYg7HOFYDEMnt50EWgUaPHUff6hQbVOVbFrvUGHzC8sDXcIeXO3S3TfcfB5Z
         L1h4cAf1nwg7RFdkmLR5r6js+oMs8hZj+72cbkaDTBShuQV8VpQ63RwhZpWHg6bc1V60
         GlHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aeU9cgOyyIosd32FJcgD+fpFlGUSWOLfdLntVffrwYI=;
        b=LqOvA85BR0KR89bs++rY5bu4+xyWwr5XKyGpGlIPFjJdTRysW4IHw4gNNsad85Lfmm
         OqPFyK29/r7v3v0IN9LpDS0kV3UU87Fex2rR5bw+wf/ertj07NOsIDHJ7EEuQWEt0hAO
         R6vfL3RyM7yqYYpfF+9l40+6mnLNDDSJgHNnm5ehFFcxK6V+RnxahxWNr9cWeUqWFVwO
         ZN+dGQaRMDSjX6yTTHYCij7sTxKooopq7BlOqzEy2IIMv8RZmiRr3qpHhpJbGngJfkgH
         r0hnIubCtvnaRjX26zXWkOHrIhhqS3uedHvLW0KMv9NornmuOfh+bmqlEhWynDNcL7t7
         v0PA==
X-Gm-Message-State: AJIora8d++GhYVr6qTcQEXOQv0wqqet48lYgj+mHo6JUPoMr8EYNtY5o
        cs6PkcAvjGOOYxeeHuPaSFKAqg==
X-Google-Smtp-Source: AGRyM1vzvLKgd/6l5pxRFRCv0etdl5tPYv3bpkSlMQO5Lp/Wf3UVXLnmW9wvqkKhdX+dMbee37E47A==
X-Received: by 2002:a05:6000:1541:b0:21d:b298:96be with SMTP id 1-20020a056000154100b0021db29896bemr26549092wry.206.1658237421084;
        Tue, 19 Jul 2022 06:30:21 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com. [35.187.36.109])
        by smtp.gmail.com with ESMTPSA id b14-20020a5d40ce000000b0021a56cda047sm13475885wrq.60.2022.07.19.06.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:30:20 -0700 (PDT)
Date:   Tue, 19 Jul 2022 14:30:16 +0100
From:   Vincent Donnefort <vdonnefort@google.com>
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 14/24] KVM: arm64: Add pcpu fixmap infrastructure at
 EL2
Message-ID: <Ytax6L2BUt5ON1Dp@google.com>
References: <20220630135747.26983-1-will@kernel.org>
 <20220630135747.26983-15-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630135747.26983-15-will@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>  static struct hyp_pool host_s2_pool;
> diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> index d3a3b47181de..17d689483ec4 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> @@ -14,6 +14,7 @@
>  #include <nvhe/early_alloc.h>
>  #include <nvhe/gfp.h>
>  #include <nvhe/memory.h>
> +#include <nvhe/mem_protect.h>
>  #include <nvhe/mm.h>
>  #include <nvhe/spinlock.h>
>  
> @@ -24,6 +25,7 @@ struct memblock_region hyp_memory[HYP_MEMBLOCK_REGIONS];
>  unsigned int hyp_memblock_nr;
>  
>  static u64 __io_map_base;
> +static DEFINE_PER_CPU(void *, hyp_fixmap_base);
>  
>  static int __pkvm_create_mappings(unsigned long start, unsigned long size,
>  				  unsigned long phys, enum kvm_pgtable_prot prot)
> @@ -212,6 +214,76 @@ int hyp_map_vectors(void)
>  	return 0;
>  }
>  
> +void *hyp_fixmap_map(phys_addr_t phys)
> +{
> +	void *addr = *this_cpu_ptr(&hyp_fixmap_base);
> +	int ret = kvm_pgtable_hyp_map(&pkvm_pgtable, (u64)addr, PAGE_SIZE,
> +				      phys, PAGE_HYP);
> +	return ret ? NULL : addr;
> +}
> +
> +int hyp_fixmap_unmap(void)
> +{
> +	void *addr = *this_cpu_ptr(&hyp_fixmap_base);
> +	int ret = kvm_pgtable_hyp_unmap(&pkvm_pgtable, (u64)addr, PAGE_SIZE);
> +
> +	return (ret != PAGE_SIZE) ? -EINVAL : 0;
> +}
> +

I probably missed something but as the pagetable pages for this mapping are
pined, it seems impossible (currently) for this call to fail. Maybe a WARN_ON
would be more appropriate, especially the callers in the subsequent patches do
not seem to check for this function return value?

[...]

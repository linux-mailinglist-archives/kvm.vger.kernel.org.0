Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51CC852CA90
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 05:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbiESDx3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 23:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbiESDx2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 23:53:28 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94519FF7
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 20:53:26 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id e3so4531886ios.6
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 20:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lufChGhIEUsgvEbinQ26kGFNXQ3rJPqXruGsydqK3Q8=;
        b=Ob5OHP1Cm2BDG5B8+mM1i3xAUIbpuTw6iH99FzXl3AB/gzmbRYt/8l9QgFDBFYjVF3
         WyMOmZBvcKILAabVoUX3CboQXeIeoyKQkRct8SDIa3lN9r9P3NGsUSraMrUAt3CiPGcO
         vutDZnp22fCSi4fzqIsjEWHnmT4d/E6FCBn+ZzpwYMOUAjZJVJw2aWtLp8FF3GgvIpSc
         4AZdVi/YVyCcEHLwcpnByKFo43lg3o9KEXvIY7QlZb9I69jl/Gvswdh6UBOgTeEyuruC
         Fr8+m+lxuU8T8NXvg3Jeda/7q1JZl89/yvknXaK4WlTI/HPlLtCLH+Q40EG8NBC/IqxN
         zwUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lufChGhIEUsgvEbinQ26kGFNXQ3rJPqXruGsydqK3Q8=;
        b=Xatm3uuUs283mA6LLqajmY+ze2nfa+PsHPtoVeSJPElwlA6Iu9jBakirfNNetezUph
         S+cf4ecW1NxM5eG0li6tALvSHEdhcJR2nrnKee5c6TANoq3YvgJGJiuMgEEPdgfg9x00
         CBA1+LZjdwzcC7odtXYeKe3Wp+DykR+zVDouo72am553d5ySBa5lB0SPb9jf3nXE3BOe
         SUx77Vtbr4h29Thjsmoq+0S1VCE6i3f3a91p0V0xCpF3oiKDUqEaAOpVEb7e2SoqEpRn
         KUneMXFvV/zRIlhKaSjl55JbMz/85cZm6vP6AyS+h1IAE7sK8FVOtqm3TkRz/oblwHvs
         l3Jw==
X-Gm-Message-State: AOAM530ABhFxQSgqb4huTjQyYe/PjqZS+Pk8q2hsr1c95G6YAKMJpHmA
        KfNiiP5Lw6350Xdmxp3yVLSmaO3MuEkq8A==
X-Google-Smtp-Source: ABdhPJzHLuxQCrtYiefUcYjxdJJ2hDfZlHcdb0YN4AADKy0DKzgV1vNQp99haKIsXadjm4ZpAEcfhQ==
X-Received: by 2002:a05:6602:2e8c:b0:64d:633a:4148 with SMTP id m12-20020a0566022e8c00b0064d633a4148mr1432951iow.12.1652932405951;
        Wed, 18 May 2022 20:53:25 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id p7-20020a92c107000000b002cde6e35309sm993845ile.83.2022.05.18.20.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 20:53:25 -0700 (PDT)
Date:   Thu, 19 May 2022 03:53:21 +0000
From:   Oliver Upton <oupton@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v3 03/13] KVM: selftests: Add
 vm_alloc_page_table_in_memslot library function
Message-ID: <YoW/MXYqP/O7JyX6@google.com>
References: <20220408004120.1969099-1-ricarkol@google.com>
 <20220408004120.1969099-4-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220408004120.1969099-4-ricarkol@google.com>
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

On Thu, Apr 07, 2022 at 05:41:10PM -0700, Ricardo Koller wrote:
> Add a library function to allocate a page-table physical page in a
> particular memslot.  The default behavior is to create new page-table
> pages in memslot 0.
> 
> Reviewed-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util_base.h | 1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c          | 8 +++++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 4ed6aa049a91..3a69b35e37cc 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -306,6 +306,7 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
>  vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
>  			      vm_paddr_t paddr_min, uint32_t memslot);
>  vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
> +vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot);
>  
>  /*
>   * Create a VM with reasonable defaults
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index d8cf851ab119..e18f1c93e4b4 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2386,9 +2386,15 @@ vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
>  /* Arbitrary minimum physical address used for virtual translation tables. */
>  #define KVM_GUEST_PAGE_TABLE_MIN_PADDR 0x180000
>  
> +vm_paddr_t vm_alloc_page_table_in_memslot(struct kvm_vm *vm, uint32_t pt_memslot)
> +{
> +	return vm_phy_page_alloc(vm, KVM_GUEST_PAGE_TABLE_MIN_PADDR,

Test code needs to plop the memslot with some space above
PAGE_TABLE_MIN_PADDR then, right?

Reviewed-by: Oliver Upton <oupton@google.com>

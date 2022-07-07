Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D91956AD39
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 23:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236617AbiGGVIp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 17:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236525AbiGGVIm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 17:08:42 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEEBA192BA
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 14:08:41 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id o18so19513628pgu.9
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 14:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z0i/FsEtEYZWQoqmAH7Voc71S2cgw06FoAKusiT8OZ4=;
        b=WoU0PSQ0Wj5Vhi5VAdOixoxhmqcmoNDkx6vHqBySeC9zqf2nqsQfssDemp0HQ+Ov1B
         x/J5MxoGXzLdJH5GEyRAbOhWT68fOGc+6rHAXDByBx1OVQfP46gGjK+Mi+BzW6aTzy1J
         zCmFPJ2SlEc+diWQW3EPCjFu0t4IWIGEdVT9pGCnFTtf0M7aL/JzkavojLQOy4s/UgNF
         NGApv5Q7B2F5jgchJKAeNIaqUXEoBZLJR5OdL0c5HU9ZNIBlR45kMkufdSbiFomJXlCl
         /ZAg/DkWLMF98iVndrnP9vxLYNAXMsIgTDVMZU2Ziwpk1aIQXpLAs3/2s4PDhY8kMxbt
         LAVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z0i/FsEtEYZWQoqmAH7Voc71S2cgw06FoAKusiT8OZ4=;
        b=BLpAEf8iZVnH5SnfwFwi1JgW3IrMIM/L+IePp5Qi5vmvsd6N/3I5BcqKIARmNYV2QK
         beN1zz9j0UTMi+yrDa9mnGQeXWKmNohyfxupy+hXglMfOoWNFrwHUkms4fvRatsDAEjq
         byc0hYeD9mgg1I0l8OF5/2doc6LxUc3z5slJDBkXtZZPawbn6tLez1YtB0v/hG3Ec9q8
         VvF6JjuVZYX2kbyKdyjBylhtemmCg3KUTrDU5N55ItbWU0QEIXqNRWU/jxZ19vN0LtVw
         N4XiNLMfFHPei8TdodpH+hw1YwW7dvIni/TFuqg7hPEQbuizFeYdmwgqB4GXwf5gxXCr
         Q71g==
X-Gm-Message-State: AJIora+URH6hjIm2SgCUKx20dSGC01gGfnwukBhFQldJXBNFfYA/t7KC
        vp6shzzAwAPx5Ds+exyQmeSHEw==
X-Google-Smtp-Source: AGRyM1vgBjc1RVmgOpFR/T4l7q4gAYOsF/Sy+FYulOKydzkkokjqIlGLn0bz30DcFIQoLNe6uAKcaA==
X-Received: by 2002:a05:6a00:13a5:b0:525:1da8:4af4 with SMTP id t37-20020a056a0013a500b005251da84af4mr55191739pfg.43.1657228121170;
        Thu, 07 Jul 2022 14:08:41 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id m17-20020a170902db1100b0016a275623c1sm20721984plx.219.2022.07.07.14.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 14:08:40 -0700 (PDT)
Date:   Thu, 7 Jul 2022 21:08:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Upton <oupton@google.com>, Huang@google.com,
        Shaoqin <shaoqin.huang@intel.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v6 2/4] KVM: mmu: add a helper to account memory used by
 KVM MMU.
Message-ID: <YsdLVBtl16mx3+Ot@google.com>
References: <20220628220938.3657876-1-yosryahmed@google.com>
 <20220628220938.3657876-3-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628220938.3657876-3-yosryahmed@google.com>
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

On Tue, Jun 28, 2022, Yosry Ahmed wrote:
> Add a helper to account pages used by KVM for page tables in memory
> secondary pagetable stats. This function will be used by subsequent
> patches in different archs.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>  include/linux/kvm_host.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 3b40f8d68fbb1..032821d77e920 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2241,6 +2241,16 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
>  }
>  #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
>  
> +/*
> + * If more than one page is being (un)accounted, @virt must be the address of
> + * the first page of a block of pages what were allocated together (i.e
> + * accounted together).

Sorry for the belated thoughts...

If you spin a v7, can you add a note to call out that mod_lruvec_page_state() is
itself thread-safe?  Caught my eye because the TDP MMU usage happens while holding
mmu_lock for read.

> + */
> +static inline void kvm_account_pgtable_pages(void *virt, int nr)
> +{
> +	mod_lruvec_page_state(virt_to_page(virt), NR_SECONDARY_PAGETABLE, nr);
> +}
> +
>  /*
>   * This defines how many reserved entries we want to keep before we
>   * kick the vcpu to the userspace to avoid dirty ring full.  This
> -- 
> 2.37.0.rc0.161.g10f37bed90-goog
> 

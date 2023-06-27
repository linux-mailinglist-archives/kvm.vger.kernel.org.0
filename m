Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1E1E740052
	for <lists+kvm@lfdr.de>; Tue, 27 Jun 2023 18:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbjF0QIb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jun 2023 12:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbjF0QI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jun 2023 12:08:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99EA2D5E
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 09:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687882067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hJDOCrbidQ6SQFQe4MgEFJjZ7UTNPrXFah4ZUMjVF/Y=;
        b=cHLQzf/baVLa3PFs+uOt0nvslid1TI9PIM04ed6bePP+ILxYbUc9cVcA8dIkE9LXhwjzN+
        96zsrYb9XYoix3wmlIuds3wzBcfHwgvMCLpH0+t+LRj1OYDPYNSC/AhtvBGt8bEvvKNi+s
        c9g5mnGYrrWVwJOwKKHh16e5N4D4cgs=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-392-3PRPUSqLMmuhx8-EN_t_dg-1; Tue, 27 Jun 2023 12:07:46 -0400
X-MC-Unique: 3PRPUSqLMmuhx8-EN_t_dg-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-74faf5008bbso79689985a.0
        for <kvm@vger.kernel.org>; Tue, 27 Jun 2023 09:07:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687882066; x=1690474066;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hJDOCrbidQ6SQFQe4MgEFJjZ7UTNPrXFah4ZUMjVF/Y=;
        b=N+0X3xDkq0xpmOc0+Cjvze9IO1QMhiDoXLFhESAfw13a/B3MsoO/ITsYNcrbwp0djF
         qmPJ0SJpl7LvDV/72QroHkOrAMt4nzEiLi2CtGdnw+goFsvY+KOTwww7LM2AlD1Cgt/K
         3DPPqsNqHfBFNtl6ONa1Pc9K02wa6xRWzsaQR99Em6rPSV+MmTJWjLy5ge8apv5BNfOX
         bgI9d8QSIMJPAA5tNWGh6mjLETZakoVIk7uJByArgfZ8/sVU2pYmaFGRxnc91iok0yBh
         QYbCPV43Q3JVDnfp+VgTJIyX1PpuuO/Lid1mRQExtMxH4dCFBQhY4URgWdrBP5W/it4A
         nKpw==
X-Gm-Message-State: AC+VfDweuUEmhyTB5O2XLtM8Wdhu1zk41DzIBa/G4/lRNAW6kfOPy8HJ
        rIF2k1VOb8vW3NnbfjmUcpoX6My327N3oqxxz3u8u1/oiF4JgAXXd2kJsbyDHCjC8ZB7mInKs5G
        GdmE2cvXLMZ4e
X-Received: by 2002:a05:620a:4007:b0:765:7b61:46fc with SMTP id h7-20020a05620a400700b007657b6146fcmr12614177qko.7.1687882066188;
        Tue, 27 Jun 2023 09:07:46 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7UY1eApNq4tXkhQSQVDzyCNrRRXMA0KLJ6oWun1WyljocOJD3jbWnq1iikbRngPAZ/IFjT9Q==
X-Received: by 2002:a05:620a:4007:b0:765:7b61:46fc with SMTP id h7-20020a05620a400700b007657b6146fcmr12614153qko.7.1687882065917;
        Tue, 27 Jun 2023 09:07:45 -0700 (PDT)
Received: from x1n (cpe5c7695f3aee0-cm5c7695f3aede.cpe.net.cable.rogers.com. [99.254.144.39])
        by smtp.gmail.com with ESMTPSA id m21-20020a05620a13b500b0075ecdc937ffsm1342302qki.41.2023.06.27.09.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 09:07:45 -0700 (PDT)
Date:   Tue, 27 Jun 2023 12:07:43 -0400
From:   Peter Xu <peterx@redhat.com>
To:     "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
        loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
        linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Hugh Dickins <hughd@google.com>,
        Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH v6 03/33] pgtable: Create struct ptdesc
Message-ID: <ZJsJT9dLtxaKlxVb@x1n>
References: <20230627031431.29653-1-vishal.moola@gmail.com>
 <20230627031431.29653-4-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230627031431.29653-4-vishal.moola@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 26, 2023 at 08:14:01PM -0700, Vishal Moola (Oracle) wrote:
> Currently, page table information is stored within struct page. As part
> of simplifying struct page, create struct ptdesc for page table
> information.
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
> ---
>  include/linux/pgtable.h | 68 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 68 insertions(+)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 5063b482e34f..d46cb709ce08 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -987,6 +987,74 @@ static inline void ptep_modify_prot_commit(struct vm_area_struct *vma,
>  #endif /* __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION */
>  #endif /* CONFIG_MMU */
>  
> +
> +/**
> + * struct ptdesc -    Memory descriptor for page tables.
> + * @__page_flags:     Same as page flags. Unused for page tables.
> + * @pt_rcu_head:      For freeing page table pages.
> + * @pt_list:          List of used page tables. Used for s390 and x86.
> + * @_pt_pad_1:        Padding that aliases with page's compound head.
> + * @pmd_huge_pte:     Protected by ptdesc->ptl, used for THPs.
> + * @_pt_s390_gaddr:   Aliases with page's mapping. Used for s390 gmap only.

Should some arch-specific bits (and a few others) always under some
#ifdefs, so it shouldn't appear on other archs?

> + * @pt_mm:            Used for x86 pgds.
> + * @pt_frag_refcount: For fragmented page table tracking. Powerpc and s390 only.
> + * @ptl:              Lock for the page table.
> + * @__page_type:      Same as page->page_type. Unused for page tables.
> + * @_refcount:        Same as page refcount. Used for s390 page tables.
> + * @pt_memcg_data:    Memcg data. Tracked for page tables here.
> + *
> + * This struct overlays struct page for now. Do not modify without a good
> + * understanding of the issues.
> + */
> +struct ptdesc {
> +	unsigned long __page_flags;
> +
> +	union {
> +		struct rcu_head pt_rcu_head;
> +		struct list_head pt_list;
> +		struct {
> +			unsigned long _pt_pad_1;
> +			pgtable_t pmd_huge_pte;
> +		};
> +	};
> +	unsigned long _pt_s390_gaddr;
> +
> +	union {
> +		struct mm_struct *pt_mm;
> +		atomic_t pt_frag_refcount;
> +	};
> +
> +	union {
> +		unsigned long _pt_pad_2;
> +#if ALLOC_SPLIT_PTLOCKS
> +		spinlock_t *ptl;
> +#else
> +		spinlock_t ptl;
> +#endif
> +	};
> +	unsigned int __page_type;
> +	atomic_t _refcount;
> +#ifdef CONFIG_MEMCG
> +	unsigned long pt_memcg_data;
> +#endif
> +};

-- 
Peter Xu


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495EE6E687E
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 17:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjDRPp7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 11:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbjDRPp6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 11:45:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96859EFE
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 08:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681832708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=27YuiGTc/1Ayk3pIwHwifC0cK9cQSm41NYDsP6qMI7E=;
        b=XS1Tc/bHEi38qr7Gc25pbbTUMs2Bz3kxEqvIejB42R/jsgi8w1gzA8fDviVb6RLpAIf/Dp
        6AadyyoR5boJQTtYE+YrtEXiJE1RWbwKqQfw9AjM/vnLcdE/qbmdRRN012QrvqubqgpxRx
        blupIuO76m0AAGCTDelh93Gq3PDVGSc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-ciE6PbkTMAGD62oN3XA0xw-1; Tue, 18 Apr 2023 11:45:07 -0400
X-MC-Unique: ciE6PbkTMAGD62oN3XA0xw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f0b0c85c4fso42470625e9.0
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 08:45:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681832706; x=1684424706;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=27YuiGTc/1Ayk3pIwHwifC0cK9cQSm41NYDsP6qMI7E=;
        b=hDJL3w+teW8FKHPrrTDMzcyu1dxLtjMgH2B480qY7mwJyAD8e0XTNge0LoG9RIsYvj
         Viwv3nDFX/8zDEx4IJrvuH/mUuR2cD7j76MwOhwTLGwWivbi21zVHGmzJ/TN6uThOLee
         t3KFjOBSvEPueTq8GYsZdNexQ5uK6oWq7ELKgucGU/w2wmf6nZdmrL0E/goBtjxOL69v
         +b4CO2RbpmG5bZKK684/2byqUitJufdRnEiWwLvUykNFP7IOnez987r4dz6G+h2xftXw
         yL208wnXsAq7SftqpHWa8aNkRFIdoSoJdXU1P6Gw5hlfCmfbnDN1nVQrQPDw3sBC4Br8
         wCJg==
X-Gm-Message-State: AAQBX9ePGNbXJLjrG5CLQ6Yw9ne8mwunSM+djNQzePyYlfaGGunosnPK
        TtxyyAk5pVH5lZ8zlZVyk6QPxodyOepUaoHRbMRNxmQNBuO6OffMGF30jK4isGkC5d8K6sj2S0Y
        iUJrfCFA24sbC
X-Received: by 2002:a5d:6dcc:0:b0:2ef:b8ae:8791 with SMTP id d12-20020a5d6dcc000000b002efb8ae8791mr2341919wrz.10.1681832706618;
        Tue, 18 Apr 2023 08:45:06 -0700 (PDT)
X-Google-Smtp-Source: AKy350boD2pgyaTgtT87B/OGZT/ZiXFytTcP4U4+Qx8x/yMODSTgYDG7+n20ySQtuSYJgFc2NPKTdg==
X-Received: by 2002:a5d:6dcc:0:b0:2ef:b8ae:8791 with SMTP id d12-20020a5d6dcc000000b002efb8ae8791mr2341904wrz.10.1681832706235;
        Tue, 18 Apr 2023 08:45:06 -0700 (PDT)
Received: from ?IPV6:2003:cb:c715:3f00:7545:deb6:f2f4:27ef? (p200300cbc7153f007545deb6f2f427ef.dip0.t-ipconnect.de. [2003:cb:c715:3f00:7545:deb6:f2f4:27ef])
        by smtp.gmail.com with ESMTPSA id z10-20020a5d654a000000b002daeb108304sm13380984wrv.33.2023.04.18.08.45.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 08:45:05 -0700 (PDT)
Message-ID: <da600570-51c7-8088-b46b-7524c9e66e5d@redhat.com>
Date:   Tue, 18 Apr 2023 17:45:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 01/33] s390: Use _pt_s390_gaddr for gmap address tracking
Content-Language: en-US
To:     "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>
Cc:     linux-mm@kvack.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
        linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
        linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
        linux-openrisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-um@lists.infradead.org, xen-devel@lists.xenproject.org,
        kvm@vger.kernel.org
References: <20230417205048.15870-1-vishal.moola@gmail.com>
 <20230417205048.15870-2-vishal.moola@gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230417205048.15870-2-vishal.moola@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17.04.23 22:50, Vishal Moola (Oracle) wrote:
> s390 uses page->index to keep track of page tables for the guest address
> space. In an attempt to consolidate the usage of page fields in s390,
> replace _pt_pad_2 with _pt_s390_gaddr to replace page->index in gmap.
> 
> This will help with the splitting of struct ptdesc from struct page, as
> well as allow s390 to use _pt_frag_refcount for fragmented page table
> tracking.
> 
> Since page->_pt_s390_gaddr aliases with mapping, ensure its set to NULL
> before freeing the pages as well.
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---

[...]

> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 3fc9e680f174..2616d64c0e8c 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -144,7 +144,7 @@ struct page {
>   		struct {	/* Page table pages */
>   			unsigned long _pt_pad_1;	/* compound_head */
>   			pgtable_t pmd_huge_pte; /* protected by page->ptl */
> -			unsigned long _pt_pad_2;	/* mapping */
> +			unsigned long _pt_s390_gaddr;	/* mapping */
>   			union {
>   				struct mm_struct *pt_mm; /* x86 pgds only */
>   				atomic_t pt_frag_refcount; /* powerpc */

The confusing part is, that these gmap page tables are not ordinary 
process page tables that we would ordinarily place into this section 
here. That's why they are also not allocated/freed using the typical 
page table constructor/destructor ...

-- 
Thanks,

David / dhildenb


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D887623B45
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 06:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbiKJFbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 00:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiKJFbS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 00:31:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920BA11823
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 21:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668058222;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z+3st8TO3e855V6+DIflFvHBaMFaHjDgFwlaiI9v3DE=;
        b=JmWrCJGFNMJSLcCge5ioSrAxTqTEYNIwM2CEcQ7wSUWhqyOhr8/xPH2+Jo+jitM1F4ZSK7
        a+Ak+sQXY2ASZo1ipCUcFZlvC3KG9G+2CXFTV7rjhYyLRARg7AkRaqnsKypvTYCuYwa8sB
        mQqkX4NWRZnxCtPv1n54RMzPVyff0uo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-218-LmeqcBKxNzm9rStiBQzh0Q-1; Thu, 10 Nov 2022 00:30:17 -0500
X-MC-Unique: LmeqcBKxNzm9rStiBQzh0Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 730EA802804;
        Thu, 10 Nov 2022 05:30:16 +0000 (UTC)
Received: from [10.64.54.49] (vpn2-54-49.bne.redhat.com [10.64.54.49])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 512032166B29;
        Thu, 10 Nov 2022 05:30:11 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v5 04/14] KVM: arm64: Don't pass kvm_pgtable through
 kvm_pgtable_walk_data
To:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>, kvmarm@lists.linux.dev
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
 <20221107215644.1895162-5-oliver.upton@linux.dev>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <acce8160-a559-648f-ea9f-995843b9a3fb@redhat.com>
Date:   Thu, 10 Nov 2022 13:30:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20221107215644.1895162-5-oliver.upton@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On 11/8/22 5:56 AM, Oliver Upton wrote:
> In order to tear down page tables from outside the context of
> kvm_pgtable (such as an RCU callback), stop passing a pointer through
> kvm_pgtable_walk_data.
> 
> No functional change intended.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>   arch/arm64/kvm/hyp/pgtable.c | 18 +++++-------------
>   1 file changed, 5 insertions(+), 13 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index db25e81a9890..93989b750a26 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -50,7 +50,6 @@
>   #define KVM_MAX_OWNER_ID		1
>   
>   struct kvm_pgtable_walk_data {
> -	struct kvm_pgtable		*pgt;
>   	struct kvm_pgtable_walker	*walker;
>   
>   	u64				addr;

Ok. Here is the answer why data->pgt->mm_ops isn't reachable in the walker
and visitor, and @mm_ops needs to be passed down.

> @@ -88,7 +87,7 @@ static u32 kvm_pgtable_idx(struct kvm_pgtable_walk_data *data, u32 level)
>   	return (data->addr >> shift) & mask;
>   }
>   
> -static u32 __kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
> +static u32 kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
>   {
>   	u64 shift = kvm_granule_shift(pgt->start_level - 1); /* May underflow */
>   	u64 mask = BIT(pgt->ia_bits) - 1;
> @@ -96,11 +95,6 @@ static u32 __kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
>   	return (addr & mask) >> shift;
>   }
>   
> -static u32 kvm_pgd_page_idx(struct kvm_pgtable_walk_data *data)
> -{
> -	return __kvm_pgd_page_idx(data->pgt, data->addr);
> -}
> -
>   static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
>   {
>   	struct kvm_pgtable pgt = {
> @@ -108,7 +102,7 @@ static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
>   		.start_level	= start_level,
>   	};
>   
> -	return __kvm_pgd_page_idx(&pgt, -1ULL) + 1;
> +	return kvm_pgd_page_idx(&pgt, -1ULL) + 1;
>   }
>   
>   static bool kvm_pte_table(kvm_pte_t pte, u32 level)
> @@ -255,11 +249,10 @@ static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
>   	return ret;
>   }
>   
> -static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
> +static int _kvm_pgtable_walk(struct kvm_pgtable *pgt, struct kvm_pgtable_walk_data *data)
>   {
>   	u32 idx;
>   	int ret = 0;
> -	struct kvm_pgtable *pgt = data->pgt;
>   	u64 limit = BIT(pgt->ia_bits);
>   
>   	if (data->addr > limit || data->end > limit)
> @@ -268,7 +261,7 @@ static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
>   	if (!pgt->pgd)
>   		return -EINVAL;
>   
> -	for (idx = kvm_pgd_page_idx(data); data->addr < data->end; ++idx) {
> +	for (idx = kvm_pgd_page_idx(pgt, data->addr); data->addr < data->end; ++idx) {
>   		kvm_pte_t *ptep = &pgt->pgd[idx * PTRS_PER_PTE];
>   
>   		ret = __kvm_pgtable_walk(data, pgt->mm_ops, ptep, pgt->start_level);
> @@ -283,13 +276,12 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
>   		     struct kvm_pgtable_walker *walker)
>   {
>   	struct kvm_pgtable_walk_data walk_data = {
> -		.pgt	= pgt,
>   		.addr	= ALIGN_DOWN(addr, PAGE_SIZE),
>   		.end	= PAGE_ALIGN(walk_data.addr + size),
>   		.walker	= walker,
>   	};
>   
> -	return _kvm_pgtable_walk(&walk_data);
> +	return _kvm_pgtable_walk(pgt, &walk_data);
>   }
>   
>   struct leaf_walk_data {
> 

Thanks,
Gavin


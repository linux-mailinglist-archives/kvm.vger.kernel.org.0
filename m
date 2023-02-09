Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A741B69005A
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 07:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjBIGaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 01:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjBIGaQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 01:30:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6372B1BC7
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 22:29:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675924168;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QlYX3NFGK/iEEZ/mvkWFWopRA7ZdWOPwg+O9hZr+ePo=;
        b=euLjz796L8+RYeEz0oZOHTqxsthAT/a9XDU9jmiPtjOHnrO3aWawelt5e2txSuxzj+NkVQ
        v58MkqDffdYw1Xe/55Dw5zdrv442oonw21kozazJdyXGuAuxlJdM+9lfusQVH/fEUA/nlQ
        Bx4Il7jEcJYnqz5iODmE/zYX99BoVpo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-6wXm-My-OvWF79NSibuOKA-1; Thu, 09 Feb 2023 01:29:25 -0500
X-MC-Unique: 6wXm-My-OvWF79NSibuOKA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB6243C025C2;
        Thu,  9 Feb 2023 06:29:24 +0000 (UTC)
Received: from [10.64.54.63] (vpn2-54-63.bne.redhat.com [10.64.54.63])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6925A492B00;
        Thu,  9 Feb 2023 06:29:18 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v2 11/12] KVM: arm64: Split huge pages during
 KVM_CLEAR_DIRTY_LOG
To:     Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oupton@google.com, yuzenghui@huawei.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com
References: <20230206165851.3106338-1-ricarkol@google.com>
 <20230206165851.3106338-12-ricarkol@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <5be91738-093c-a416-6b04-4503d3689333@redhat.com>
Date:   Thu, 9 Feb 2023 17:29:15 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20230206165851.3106338-12-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 2/7/23 3:58 AM, Ricardo Koller wrote:
> This is the arm64 counterpart of commit cb00a70bd4b7 ("KVM: x86/mmu:
> Split huge pages mapped by the TDP MMU during KVM_CLEAR_DIRTY_LOG"),
> which has the benefit of splitting the cost of splitting a memslot
> across multiple ioctls.
> 
> Split huge pages on the range specified using KVM_CLEAR_DIRTY_LOG.
> And do not split when enabling dirty logging if
> KVM_DIRTY_LOG_INITIALLY_SET is set.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>   arch/arm64/kvm/mmu.c | 15 ++++++++++++---
>   1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index f6fb2bdaab71..da2fbd04fb01 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1084,8 +1084,8 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
>    * @mask:	The mask of pages at offset 'gfn_offset' in this memory
>    *		slot to enable dirty logging on
>    *
> - * Writes protect selected pages to enable dirty logging for them. Caller must
> - * acquire kvm->mmu_lock.
> + * Splits selected pages to PAGE_SIZE and then writes protect them to enable
> + * dirty logging for them. Caller must acquire kvm->mmu_lock.
>    */
>   void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>   		struct kvm_memory_slot *slot,
> @@ -1098,6 +1098,13 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>   	lockdep_assert_held_write(&kvm->mmu_lock);
>   
>   	stage2_wp_range(&kvm->arch.mmu, start, end);
> +
> +	/*
> +	 * If initially-all-set mode is not set, then huge-pages were already
> +	 * split when enabling dirty logging: no need to do it again.
> +	 */
> +	if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> +		kvm_mmu_split_huge_pages(kvm, start, end);
>   }
>   
>   static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
> @@ -1884,7 +1891,9 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>   		 * this when deleting, moving, disabling dirty logging, or
>   		 * creating the memslot (a nop). Doing it for deletes makes
>   		 * sure we don't leak memory, and there's no need to keep the
> -		 * cache around for any of the other cases.
> +		 * cache around for any of the other cases. Keeping the cache
> +		 * is useful for succesive KVM_CLEAR_DIRTY_LOG calls, which is
> +		 * not handled in this function.
>   		 */
>   		kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
>   	}
> 

s/succesive/successive

Thanks,
Gavin


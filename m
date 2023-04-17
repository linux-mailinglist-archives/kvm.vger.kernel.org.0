Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78BFA6E4090
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 09:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbjDQHTn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 03:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjDQHTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 03:19:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DD34203
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 00:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681715928;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sYjR0xSbqdDLVGFhfaRMyfQHo9XMoXo9cPWRMiIiH+g=;
        b=d3hpLmFLwy90Upf3syZxB2FcWfQam4r5Edjwimxt0EO+OCENiOcNU/tkYcUjXraFQVlywE
        AVGjbXenrU4uvbwlfnBby77EJpYEjVGAhNuYgDBdVk7XuTxVk82zMq5aNNUQ6TFco2SRcp
        w5EmeAYHebrbKnckBOvTJmJ/cxcuRXQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-358-kwTEnIq2OM-jTP5XKovxbA-1; Mon, 17 Apr 2023 03:18:46 -0400
X-MC-Unique: kwTEnIq2OM-jTP5XKovxbA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C27CA85A5A3;
        Mon, 17 Apr 2023 07:18:45 +0000 (UTC)
Received: from [10.72.13.187] (ovpn-13-187.pek2.redhat.com [10.72.13.187])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CD8F240C94A9;
        Mon, 17 Apr 2023 07:18:35 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 11/12] KVM: arm64: Split huge pages during
 KVM_CLEAR_DIRTY_LOG
To:     Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oupton@google.com, yuzenghui@huawei.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com
References: <20230409063000.3559991-1-ricarkol@google.com>
 <20230409063000.3559991-13-ricarkol@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <a739a2bb-81bd-4e21-1b05-2fb740a86d91@redhat.com>
Date:   Mon, 17 Apr 2023 15:18:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20230409063000.3559991-13-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/9/23 2:29 PM, Ricardo Koller wrote:
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
>   arch/arm64/kvm/mmu.c | 15 +++++++++++++--
>   1 file changed, 13 insertions(+), 2 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 16fa24f761152..50488daab0f4d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1094,8 +1094,8 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
>    * @mask:	The mask of pages at offset 'gfn_offset' in this memory
>    *		slot to enable dirty logging on
>    *
> - * Writes protect selected pages to enable dirty logging for them. Caller must
> - * acquire kvm->mmu_lock.
> + * Writes protect selected pages to enable dirty logging, and then
> + * splits them to PAGE_SIZE. Caller must acquire kvm->mmu_lock.
>    */
>   void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>   		struct kvm_memory_slot *slot,
> @@ -1108,6 +1108,17 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>   	lockdep_assert_held_write(&kvm->mmu_lock);
>   
>   	stage2_wp_range(&kvm->arch.mmu, start, end);
> +
> +	/*
> +	 * Eager-splitting is done when manual-protect is set.  We
> +	 * also check for initially-all-set because we can avoid
> +	 * eager-splitting if initially-all-set is false.
> +	 * Initially-all-set equal false implies that huge-pages were
> +	 * already split when enabling dirty logging: no need to do it
> +	 * again.
> +	 */
> +	if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> +		kvm_mmu_split_huge_pages(kvm, start, end);
>   }
>  >   static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
> 


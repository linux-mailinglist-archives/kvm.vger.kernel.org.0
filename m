Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C89AC6E4079
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 09:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjDQHPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 03:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbjDQHPb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 03:15:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBE240D5
        for <kvm@vger.kernel.org>; Mon, 17 Apr 2023 00:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681715680;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oALqO+MtMuAPPjucUiyMejzYltE+mSOPqbTNv6gHdxs=;
        b=S0S7J0feTev2tNYe2hzNsTMqjCCa+OACJ47UwAAWrhf4/2xQGx34LAZtAt3jAHiogZuwWp
        zNLwxIOLgDPsyNZLdnX6imMMPt/dE9+lEd0s5xdEi5xTEe5W+mwcr0PHpjGv1pLsT3Cdob
        d5hm8D3s34YqPEz8Wet6fRLBRlambz0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-NFpjcpF6PsuwOlfBCmPYFA-1; Mon, 17 Apr 2023 03:14:34 -0400
X-MC-Unique: NFpjcpF6PsuwOlfBCmPYFA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90A9D3C025C2;
        Mon, 17 Apr 2023 07:14:33 +0000 (UTC)
Received: from [10.72.13.187] (ovpn-13-187.pek2.redhat.com [10.72.13.187])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 82650492B0C;
        Mon, 17 Apr 2023 07:14:23 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 10/12] KVM: arm64: Open-code
 kvm_mmu_write_protect_pt_masked()
To:     Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oupton@google.com, yuzenghui@huawei.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com
References: <20230409063000.3559991-1-ricarkol@google.com>
 <20230409063000.3559991-12-ricarkol@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <14bc090d-e385-cad0-4794-edb6c6c99b76@redhat.com>
Date:   Mon, 17 Apr 2023 15:14:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20230409063000.3559991-12-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
> Move the functionality of kvm_mmu_write_protect_pt_masked() into its
> caller, kvm_arch_mmu_enable_log_dirty_pt_masked().  This will be used
> in a subsequent commit in order to share some of the code in
> kvm_arch_mmu_enable_log_dirty_pt_masked().
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>   arch/arm64/kvm/mmu.c | 42 +++++++++++++++---------------------------
>   1 file changed, 15 insertions(+), 27 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index aaefabd8de89d..16fa24f761152 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1058,28 +1058,6 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
>   	kvm_flush_remote_tlbs(kvm);
>   }
>   
> -/**
> - * kvm_mmu_write_protect_pt_masked() - write protect dirty pages
> - * @kvm:	The KVM pointer
> - * @slot:	The memory slot associated with mask
> - * @gfn_offset:	The gfn offset in memory slot
> - * @mask:	The mask of dirty pages at offset 'gfn_offset' in this memory
> - *		slot to be write protected
> - *
> - * Walks bits set in mask write protects the associated pte's. Caller must
> - * acquire kvm_mmu_lock.
> - */
> -static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
> -		struct kvm_memory_slot *slot,
> -		gfn_t gfn_offset, unsigned long mask)
> -{
> -	phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
> -	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
> -	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
> -
> -	stage2_wp_range(&kvm->arch.mmu, start, end);
> -}
> -
>   /**
>    * kvm_mmu_split_memory_region() - split the stage 2 blocks into PAGE_SIZE
>    *				   pages for memory slot
> @@ -1109,17 +1087,27 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
>   }
>   
>   /*
> - * kvm_arch_mmu_enable_log_dirty_pt_masked - enable dirty logging for selected
> - * dirty pages.
> + * kvm_arch_mmu_enable_log_dirty_pt_masked() - enable dirty logging for selected pages.
> + * @kvm:	The KVM pointer
> + * @slot:	The memory slot associated with mask
> + * @gfn_offset:	The gfn offset in memory slot
> + * @mask:	The mask of pages at offset 'gfn_offset' in this memory
> + *		slot to enable dirty logging on
>    *
> - * It calls kvm_mmu_write_protect_pt_masked to write protect selected pages to
> - * enable dirty logging for them.
> + * Writes protect selected pages to enable dirty logging for them. Caller must
> + * acquire kvm->mmu_lock.
>    */
>   void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>   		struct kvm_memory_slot *slot,
>   		gfn_t gfn_offset, unsigned long mask)
>   {
> -	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
> +	phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
> +	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
> +	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
> +
> +	lockdep_assert_held_write(&kvm->mmu_lock);
> +
> +	stage2_wp_range(&kvm->arch.mmu, start, end);
>   }
>   
>   static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
> 


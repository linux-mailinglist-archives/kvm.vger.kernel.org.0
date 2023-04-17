Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2766E4003
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 08:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjDQGnw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 02:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjDQGns (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 02:43:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C091997
        for <kvm@vger.kernel.org>; Sun, 16 Apr 2023 23:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681713781;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MJcuDAKu+euVeV318qUGLioPveqj8/ZetW/OAfgdbMI=;
        b=TS1yLsrbgCbUCNIvHNyqZMIPgn3K03SiGJLxc2DPoEZHO36VL8FO0LUKtj6+2LKHEzagq5
        ReQv4eVHjC6Sy/93hHJHQHX09H/lIm3QaUuaK4m9PISOwKEA9q9FEscC4mZifBGyxJ678b
        JuVlx97pWIsIF8yC9MBQT2TyAMJVUYo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-73--CGkRktcNae6ef4tEEi0iQ-1; Mon, 17 Apr 2023 02:42:56 -0400
X-MC-Unique: -CGkRktcNae6ef4tEEi0iQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7627538173C0;
        Mon, 17 Apr 2023 06:42:55 +0000 (UTC)
Received: from [10.72.13.187] (ovpn-13-187.pek2.redhat.com [10.72.13.187])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0685040C20FA;
        Mon, 17 Apr 2023 06:42:44 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 05/12] KVM: arm64: Refactor
 kvm_arch_commit_memory_region()
To:     Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
        maz@kernel.org, oupton@google.com, yuzenghui@huawei.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, ricarkol@gmail.com,
        Shaoqin Huang <shahuang@redhat.com>
References: <20230409063000.3559991-1-ricarkol@google.com>
 <20230409063000.3559991-7-ricarkol@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <00649a3b-5b7d-ae12-8fc2-39b83a72009d@redhat.com>
Date:   Mon, 17 Apr 2023 14:42:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20230409063000.3559991-7-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
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
> Refactor kvm_arch_commit_memory_region() as a preparation for a future
> commit to look cleaner and more understandable. Also, it looks more
> like its x86 counterpart (in kvm_mmu_slot_apply_flags()).
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/kvm/mmu.c | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index efdaab3f154de..37d7d2aa472ab 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1761,20 +1761,27 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>   				   const struct kvm_memory_slot *new,
>   				   enum kvm_mr_change change)
>   {
> +	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
> +
>   	/*
>   	 * At this point memslot has been committed and there is an
>   	 * allocated dirty_bitmap[], dirty pages will be tracked while the
>   	 * memory slot is write protected.
>   	 */
> -	if (change != KVM_MR_DELETE && new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
> +	if (log_dirty_pages) {
> +
> +		if (change == KVM_MR_DELETE)
> +			return;
> +
>   		/*
>   		 * If we're with initial-all-set, we don't need to write
>   		 * protect any pages because they're all reported as dirty.
>   		 * Huge pages and normal pages will be write protect gradually.
>   		 */
> -		if (!kvm_dirty_log_manual_protect_and_init_set(kvm)) {
> -			kvm_mmu_wp_memory_region(kvm, new->id);
> -		}
> +		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> +			return;
> +
> +		kvm_mmu_wp_memory_region(kvm, new->id);
>   	}
>   }
>   
> 


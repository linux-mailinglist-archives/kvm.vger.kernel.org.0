Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8736E4015
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 08:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbjDQGsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 02:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjDQGsM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 02:48:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E43DF
        for <kvm@vger.kernel.org>; Sun, 16 Apr 2023 23:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681714049;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yb8sYUTBHqW3BeI7uRcLpfueBje5vgbjx2JAtxvYMwM=;
        b=dRniYVq0Lff7sNoo7L0mAowWuhifUHubiuvqmRkIgi2rnLGAZhMw5dsjGQxLWCixXr2KRJ
        VGjf4zvN883bo5mzytclvbi8y/hhRCtSahe9JI0r/S+nLRKnP9nXj1YqA7axxCjahFAZap
        serj5MzapXfo+d4FyHhjgrh1xXFeR9E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-nn-wLpgEO5-2pqGKqi859g-1; Mon, 17 Apr 2023 02:47:25 -0400
X-MC-Unique: nn-wLpgEO5-2pqGKqi859g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2914857A9F;
        Mon, 17 Apr 2023 06:47:24 +0000 (UTC)
Received: from [10.72.13.187] (ovpn-13-187.pek2.redhat.com [10.72.13.187])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CF172027063;
        Mon, 17 Apr 2023 06:47:13 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 07/12] KVM: arm64: Export kvm_are_all_memslots_empty()
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
 <20230409063000.3559991-9-ricarkol@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <666b8b4d-5c88-32b6-b907-31ed47fe6311@redhat.com>
Date:   Mon, 17 Apr 2023 14:47:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20230409063000.3559991-9-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
> Export kvm_are_all_memslots_empty(). This will be used by a future
> commit when checking before setting a capability.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   include/linux/kvm_host.h | 2 ++
>   virt/kvm/kvm_main.c      | 2 +-
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 

With the following nits addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 8ada23756b0ec..c6fa634f236d9 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -990,6 +990,8 @@ static inline bool kvm_memslots_empty(struct kvm_memslots *slots)
>   	return RB_EMPTY_ROOT(&slots->gfn_tree);
>   }
>   
> +bool kvm_are_all_memslots_empty(struct kvm *kvm);
> +
>   #define kvm_for_each_memslot(memslot, bkt, slots)			      \
>   	hash_for_each(slots->id_hash, bkt, memslot, id_node[slots->node_idx]) \
>   		if (WARN_ON_ONCE(!memslot->npages)) {			      \
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d255964ec331e..897b000787beb 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4596,7 +4596,7 @@ int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   	return -EINVAL;
>   }
>   
> -static bool kvm_are_all_memslots_empty(struct kvm *kvm)
> +bool kvm_are_all_memslots_empty(struct kvm *kvm)
>   {
>   	int i;
>   
> 

We may need EXPORT_SYMBOL_GPL() to export it, to be consistent with the
exported APIs. KVM may be standalone module on architectures other than
ARM64.

Thanks,
Gavin


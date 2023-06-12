Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED39A72B53F
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 04:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbjFLCAY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Jun 2023 22:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232972AbjFLCAV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Jun 2023 22:00:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC991B8
        for <kvm@vger.kernel.org>; Sun, 11 Jun 2023 18:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686535174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y05pr+votN47QvIShcS+kviUeyaUDFFJfeTqyxPwFpM=;
        b=UMP+sFEWBFsJ6t6gU42liN2Ug11qbxF3c8OY0MjCIF+jEOHIGAlMDCiWvxyR/20WYT1iks
        cZitRuaJe9ITHwCK94qFNzJdziPZMmyEGpcdE5ilIND2iXuansSF88078fS4njQCG9i8hV
        2FgtyjKKAaAO/h9lw8z/tPWn3RF9DF8=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-296-C1WHyORJN46NZDSsstg52g-1; Sun, 11 Jun 2023 21:59:27 -0400
X-MC-Unique: C1WHyORJN46NZDSsstg52g-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-51b5133ad4dso657860a12.0
        for <kvm@vger.kernel.org>; Sun, 11 Jun 2023 18:59:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686535166; x=1689127166;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y05pr+votN47QvIShcS+kviUeyaUDFFJfeTqyxPwFpM=;
        b=Kd7uUZnM4Kk/dIFN1PeozCVqYeCfjyOzCMVRtZBsQYZFzdNfYhJyt4F8JrM0jdb97Q
         ux6eoIztFZrOIkAwh+/vDOmihZQnZvelul7iGjvFXRj1gbbe69hrlrdt9OUdbSDautUS
         aP90zo0AGXO/hJkdcvuiydzCVVWr2+xH0iUMCB33xKQ01+CnbpWZfLOLhZNcKT79McMI
         OEWD3hfAMGXUnhvSBGfyc4oxd3vT/dttpiLAXImUTX2stLvKO/a/Jl/TfzQM7wuoqCzl
         1E0lTJMwXSNzF56MwsGmq+q24aLeFS7YJ9FSujkqwIi759DrhAHOBK7/Tmx0boL0x/Px
         TIrw==
X-Gm-Message-State: AC+VfDzIz3gkUV234Yh6FCDqc5PCSzyM8pxwNQR4WWFR7cVD02wAoy21
        lpH9nQUg3S7mUJv91y8oAP/BbwxgMkEO+OvpfCQB9KZmMlYrI2OmAZTF1teAh83lsKQQidvoPus
        VaLt9m6yrd0u3
X-Received: by 2002:a17:902:f682:b0:1b3:d4bb:3515 with SMTP id l2-20020a170902f68200b001b3d4bb3515mr806622plg.0.1686535166159;
        Sun, 11 Jun 2023 18:59:26 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5wPwlyQ4MLs702LYE6rbIR57V967YGWGq5GUPUOx/3xf7DxXBcnC7QWtnpq1K1li7nppB8Wg==
X-Received: by 2002:a17:902:f682:b0:1b3:d4bb:3515 with SMTP id l2-20020a170902f68200b001b3d4bb3515mr806611plg.0.1686535165829;
        Sun, 11 Jun 2023 18:59:25 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id n18-20020a170902d2d200b001aad4be4503sm6942445plc.2.2023.06.11.18.59.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jun 2023 18:59:25 -0700 (PDT)
Message-ID: <2f92e6d1-c191-1d36-7488-e1bae9ce1d40@redhat.com>
Date:   Mon, 12 Jun 2023 09:59:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2] KVM: Avoid illegal stage2 mapping on invalid memory
 slot
Content-Language: en-US
To:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        oliver.upton@linux.dev, aarcange@redhat.com, peterx@redhat.com,
        david@redhat.com, hshuai@redhat.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com
References: <20230609100420.521351-1-gshan@redhat.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230609100420.521351-1-gshan@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/9/23 18:04, Gavin Shan wrote:
> We run into guest hang in edk2 firmware when KSM is kept as running on
> the host. The edk2 firmware is waiting for status 0x80 from QEMU's pflash
> device (TYPE_PFLASH_CFI01) during the operation of sector erasing or
> buffered write. The status is returned by reading the memory region of
> the pflash device and the read request should have been forwarded to QEMU
> and emulated by it. Unfortunately, the read request is covered by an
> illegal stage2 mapping when the guest hang issue occurs. The read request
> is completed with QEMU bypassed and wrong status is fetched. The edk2
> firmware runs into an infinite loop with the wrong status.
> 
> The illegal stage2 mapping is populated due to same page sharing by KSM
> at (C) even the associated memory slot has been marked as invalid at (B)
> when the memory slot is requested to be deleted. It's notable that the
> active and inactive memory slots can't be swapped when we're in the middle
> of kvm_mmu_notifier_change_pte() because kvm->mn_active_invalidate_count
> is elevated, and kvm_swap_active_memslots() will busy loop until it reaches
> to zero again. Besides, the swapping from the active to the inactive memory
> slots is also avoided by holding &kvm->srcu in __kvm_handle_hva_range(),
> corresponding to synchronize_srcu_expedited() in kvm_swap_active_memslots().
> 
>    CPU-A                    CPU-B
>    -----                    -----
>                             ioctl(kvm_fd, KVM_SET_USER_MEMORY_REGION)
>                             kvm_vm_ioctl_set_memory_region
>                             kvm_set_memory_region
>                             __kvm_set_memory_region
>                             kvm_set_memslot(kvm, old, NULL, KVM_MR_DELETE)
>                               kvm_invalidate_memslot
>                                 kvm_copy_memslot
>                                 kvm_replace_memslot
>                                 kvm_swap_active_memslots        (A)
>                                 kvm_arch_flush_shadow_memslot   (B)
>    same page sharing by KSM
>    kvm_mmu_notifier_invalidate_range_start
>          :
>    kvm_mmu_notifier_change_pte
>      kvm_handle_hva_range
>      __kvm_handle_hva_range       (C)
>          :
>    kvm_mmu_notifier_invalidate_range_end
> 
> Fix the issue by skipping the invalid memory slot at (C) to avoid the
> illegal stage2 mapping so that the read request for the pflash's status
> is forwarded to QEMU and emulated by it. In this way, the correct pflash's
> status can be returned from QEMU to break the infinite loop in the edk2
> firmware.
> 
> Cc: stable@vger.kernel.org # v5.13+
> Fixes: 3039bcc74498 ("KVM: Move x86's MMU notifier memslot walkers to generic code")
> Reported-by: Shuai Hu <hshuai@redhat.com>
> Reported-by: Zhenyu Zhang <zhenyzha@redhat.com>
> Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
> v2: Improved changelog suggested by Marc
> ---
>   virt/kvm/kvm_main.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 479802a892d4..7f81a3a209b6 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -598,6 +598,9 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
>   			unsigned long hva_start, hva_end;
>   
>   			slot = container_of(node, struct kvm_memory_slot, hva_node[slots->node_idx]);
> +			if (slot->flags & KVM_MEMSLOT_INVALID)
> +				continue;
> +
>   			hva_start = max(range->start, slot->userspace_addr);
>   			hva_end = min(range->end, slot->userspace_addr +
>   						  (slot->npages << PAGE_SHIFT));

-- 
Shaoqin


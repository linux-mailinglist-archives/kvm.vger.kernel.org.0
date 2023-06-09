Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15FA872A1C9
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 20:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjFISE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 14:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbjFISEy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 14:04:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF3330F0
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 11:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686333848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zAp0pJ+sm+Y3KQgNoeZPqvSvGD8UdvXtUGa2VdIgLpc=;
        b=OlbADHdO4ewL1B6efDFI9p9PCSYesJtHT+rsmAVArkjZY7EggugKYgWpPPuzPGyYFwu7N2
        3yPm/mgYLQwboUwO1aw2dS/YXWqZaHdLrcwJikEKzSdy/WuLCSwAX3zH6v9jBNSw+21Dpd
        ljHFQ11+/zQR8Gu78S2E2/4TaVx1QOs=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-351-ZTWVaEMQOQOB8HBcLO2Q6Q-1; Fri, 09 Jun 2023 14:04:04 -0400
X-MC-Unique: ZTWVaEMQOQOB8HBcLO2Q6Q-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-75eb82ada06so45520685a.1
        for <kvm@vger.kernel.org>; Fri, 09 Jun 2023 11:04:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686333843; x=1688925843;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zAp0pJ+sm+Y3KQgNoeZPqvSvGD8UdvXtUGa2VdIgLpc=;
        b=b04hjNLHLvUzBbXBZfNo3Z42OBxNgMdYDTp8wO9C3FIycXho0l5/kVuVltcIcQr3ru
         NoO6zWOHgQErVFqnb4xRWLC/bCpU/IV9mVovscfREkHSwQ09HCLs+9tYhG/Okv4eGb86
         YjXCSKJsTMndN33sFJe6FM3okfro6obtVw1zVz9LoTMCnl8n1yrOtf1E6EeCNztXhFlh
         Uv8DWiD1h+XrQNSm5XzgpJm2fBD4vUzgSG7kGZj2kZ0WGj2RZeS5o45XIo87d2d46NP/
         r/iX5kLqEOyKK3Q7qbPGr2J+KqEMblPHNoT1zzN8iv42/DlfDZCrd1Z/0KPt3Zfk8i9J
         2Ukw==
X-Gm-Message-State: AC+VfDy4smU+G/0OZ+DrC3Xc9ahgB4Bh1oGa1HNAemr8ZlSZXpWBKGC2
        yAbduY73qQFKV+nSqLrwhbBlOr3MzPootg9vogHdyB6+SQERA9UIEvZN4EBODfnzwxoyizicdfo
        pXvzxJ6xgA19D
X-Received: by 2002:a05:620a:2541:b0:75b:23a1:69e2 with SMTP id s1-20020a05620a254100b0075b23a169e2mr2352398qko.2.1686333843403;
        Fri, 09 Jun 2023 11:04:03 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4RtNMoxDtjGYkQZW5n83BGYz2gukU3kZCJd9ZjCOGjHFFrwfCXZgSNY8VDEKzXausmue5/Hg==
X-Received: by 2002:a05:620a:2541:b0:75b:23a1:69e2 with SMTP id s1-20020a05620a254100b0075b23a169e2mr2352373qko.2.1686333843126;
        Fri, 09 Jun 2023 11:04:03 -0700 (PDT)
Received: from x1n (cpe5c7695f3aee0-cm5c7695f3aede.cpe.net.cable.rogers.com. [99.254.144.39])
        by smtp.gmail.com with ESMTPSA id o12-20020a05620a15cc00b0075b17afcc1esm1177922qkm.115.2023.06.09.11.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 11:04:02 -0700 (PDT)
Date:   Fri, 9 Jun 2023 14:04:00 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        seanjc@google.com, oliver.upton@linux.dev, aarcange@redhat.com,
        david@redhat.com, hshuai@redhat.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com
Subject: Re: [PATCH v2] KVM: Avoid illegal stage2 mapping on invalid memory
 slot
Message-ID: <ZINpkOCYoDBQYhdq@x1n>
References: <20230609100420.521351-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230609100420.521351-1-gshan@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 09, 2023 at 08:04:20PM +1000, Gavin Shan wrote:
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
>   CPU-A                    CPU-B
>   -----                    -----
>                            ioctl(kvm_fd, KVM_SET_USER_MEMORY_REGION)
>                            kvm_vm_ioctl_set_memory_region
>                            kvm_set_memory_region
>                            __kvm_set_memory_region
>                            kvm_set_memslot(kvm, old, NULL, KVM_MR_DELETE)
>                              kvm_invalidate_memslot
>                                kvm_copy_memslot
>                                kvm_replace_memslot
>                                kvm_swap_active_memslots        (A)
>                                kvm_arch_flush_shadow_memslot   (B)
>   same page sharing by KSM
>   kvm_mmu_notifier_invalidate_range_start
>         :
>   kvm_mmu_notifier_change_pte
>     kvm_handle_hva_range
>     __kvm_handle_hva_range       (C)
>         :
>   kvm_mmu_notifier_invalidate_range_end
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

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


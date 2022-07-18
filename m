Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5CAF5781AB
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 14:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234759AbiGRMJS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 08:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234746AbiGRMJP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 08:09:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E33F124942
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 05:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658146116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/PFkIF1rv5Mk0FbpMT60my0l/eja9lFVjvdGHcn5kQ8=;
        b=cQuvmA+qXJwmOQE6Xr4rAa95239qQ3aw7YXcC69e/1RNECUp5dCuodWXJ5D4uEO43AC8JO
        BkHLhaqW8sR7+iM7ddSOZU4o8exZJW1Z8YUIgHGAqqUsK+bBpgF53nmO6Lq0SERrCSInE9
        v276rBn0/pxlAPyJsraqMmgnA3LGGfE=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-aLXc6orJO7WbqpF5s378RA-1; Mon, 18 Jul 2022 08:08:34 -0400
X-MC-Unique: aLXc6orJO7WbqpF5s378RA-1
Received: by mail-qt1-f200.google.com with SMTP id f1-20020ac84641000000b0031ecb35e4d1so8202108qto.2
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 05:08:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=/PFkIF1rv5Mk0FbpMT60my0l/eja9lFVjvdGHcn5kQ8=;
        b=3b6eW3N8Ht3K3JTpvIHsBCVPHKanV1yvDLSurQOC+DeMfKF7Iagm49sY+CZoQ8QUVs
         Lko8TNIbh4e4MU6S1ULFCTp53vA1TalfDHs3T8bNGBwYIrA2aL5nf3Yy52J+KDiA+dQJ
         F3Do1EOQnk/ianD9wtb1e37rNJWTE0lQMdKlB8eFiuhxfXLObJxjw8Xo2u9vsaTTCzA4
         1OXsTFDvQCWIy++DXvjybgWG7A1QiMkdk2glvUDSj8qn6WvtcyoFrxucOXtzcIEJImhz
         5wMq5Y0t0HJrv3B9WGcUUYLMD6cFCVx18qBRHfReF+dm6zOdR+ly8Q2hGDVpYpqPfJUp
         IbVw==
X-Gm-Message-State: AJIora/wLN2a9LkH5gcRvPNi93y2hgSM0nFo443U3Hs+EbkCKEnlp/FL
        mlOVNx1nBsKwijTtBEDEYivnr1SBFVKlwftKhHIdCYMXIgCAJnADVAQyBW1qydqamVcclj5Njeb
        +COxRPNZ6Y53X
X-Received: by 2002:a05:622a:2c3:b0:31e:e18f:4fbd with SMTP id a3-20020a05622a02c300b0031ee18f4fbdmr9050225qtx.641.1658146114013;
        Mon, 18 Jul 2022 05:08:34 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1su8dRQ7s0ThRlX1b0CRIpLOLJF0ftkeoO+vtjdp15l7xx7q5k7yd9VY9hpp94n4CuWmxAtPA==
X-Received: by 2002:a05:622a:2c3:b0:31e:e18f:4fbd with SMTP id a3-20020a05622a02c300b0031ee18f4fbdmr9050195qtx.641.1658146113644;
        Mon, 18 Jul 2022 05:08:33 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id n7-20020a05620a294700b006b5bc40a220sm11875602qkp.51.2022.07.18.05.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 05:08:33 -0700 (PDT)
Message-ID: <580a46b4623309474bb3207ea994eb9b5a3603a7.camel@redhat.com>
Subject: Re: [PATCH 3/4] KVM: x86/mmu: Add shadow mask for effective host
 MTRR memtype
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 18 Jul 2022 15:08:30 +0300
In-Reply-To: <20220715230016.3762909-4-seanjc@google.com>
References: <20220715230016.3762909-1-seanjc@google.com>
         <20220715230016.3762909-4-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-07-15 at 23:00 +0000, Sean Christopherson wrote:
> Add shadow_memtype_mask to capture that EPT needs a non-zero memtype mask
> instead of relying on TDP being enabled, as NPT doesn't need a non-zero
> mask.  This is a glorified nop as kvm_x86_ops.get_mt_mask() returns zero
> for NPT anyways.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/spte.c | 21 ++++++++++++++++++---
>  arch/x86/kvm/mmu/spte.h |  1 +
>  2 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index fb1f17504138..7314d27d57a4 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -33,6 +33,7 @@ u64 __read_mostly shadow_mmio_value;
>  u64 __read_mostly shadow_mmio_mask;
>  u64 __read_mostly shadow_mmio_access_mask;
>  u64 __read_mostly shadow_present_mask;
> +u64 __read_mostly shadow_memtype_mask;
>  u64 __read_mostly shadow_me_value;
>  u64 __read_mostly shadow_me_mask;
>  u64 __read_mostly shadow_acc_track_mask;
> @@ -161,10 +162,10 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  
>         if (level > PG_LEVEL_4K)
>                 spte |= PT_PAGE_SIZE_MASK;
> -       if (tdp_enabled)
> +
> +       if (shadow_memtype_mask)
>                 spte |= static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
> -                       kvm_is_mmio_pfn(pfn));
> -
> +                                                        kvm_is_mmio_pfn(pfn));
>         if (host_writable)
>                 spte |= shadow_host_writable_mask;
>         else
> @@ -391,6 +392,13 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
>         shadow_nx_mask          = 0ull;
>         shadow_x_mask           = VMX_EPT_EXECUTABLE_MASK;
>         shadow_present_mask     = has_exec_only ? 0ull : VMX_EPT_READABLE_MASK;
> +       /*
> +        * EPT overrides the host MTRRs, and so KVM must program the desired
> +        * memtype directly into the SPTEs.  Note, this mask is just the mask
> +        * of all bits that factor into the memtype, the actual memtype must be
> +        * dynamically calculated, e.g. to ensure host MMIO is mapped UC.
> +        */
> +       shadow_memtype_mask     = VMX_EPT_MT_MASK | VMX_EPT_IPAT_BIT;
>         shadow_acc_track_mask   = VMX_EPT_RWX_MASK;
>         shadow_host_writable_mask = EPT_SPTE_HOST_WRITABLE;
>         shadow_mmu_writable_mask  = EPT_SPTE_MMU_WRITABLE;
> @@ -441,6 +449,13 @@ void kvm_mmu_reset_all_pte_masks(void)
>         shadow_nx_mask          = PT64_NX_MASK;
>         shadow_x_mask           = 0;
>         shadow_present_mask     = PT_PRESENT_MASK;
> +
> +       /*
> +        * For shadow paging and NPT, KVM uses PAT entry '0' to encode WB
> +        * memtype in the SPTEs, i.e. relies on host MTRRs to provide the
> +        * correct memtype (WB is the "weakest" memtype).
> +        */
> +       shadow_memtype_mask     = 0;
>         shadow_acc_track_mask   = 0;
>         shadow_me_mask          = 0;
>         shadow_me_value         = 0;
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index ba3dccb202bc..cabe3fbb4f39 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -147,6 +147,7 @@ extern u64 __read_mostly shadow_mmio_value;
>  extern u64 __read_mostly shadow_mmio_mask;
>  extern u64 __read_mostly shadow_mmio_access_mask;
>  extern u64 __read_mostly shadow_present_mask;
> +extern u64 __read_mostly shadow_memtype_mask;
>  extern u64 __read_mostly shadow_me_value;
>  extern u64 __read_mostly shadow_me_mask;
>  


So if I understand correctly:


VMX:

- host MTRRs are ignored.

- all *host* mmio ranges (can only be VFIO's pci BARs), are mapped UC in EPT,
 but guest can override this with its PAT to WC)


- all regular memory is mapped WB + guest PAT ignored unless there is noncoherent dma,
 (an older Intel's IOMMU? I think current Intel's IOMMLU are coherent?)


- In case of noncoherent dma guest MTRRs and PAT are respected.



SVM:

- host MTRRs are respected, and can enforce UC on *host* mmio areas.


- WB is always used in NPT, *always*, however NPT doesn't have the 'IPAT'
 bit, so the guest is free to overrride it for its its MMIO areas to any memory type as it wishes,
 using its own PAT, and we do allow the guest to change IA32_PAT to any value it wishes to.

 (e.g VFIO's PCI bars, memory which a VFIO devices needs to access, etc)

 (This reminds me that PAT is somewhat broken in regard to nesting, we ignore L2's PAT)


With all this said, it makes sense.


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


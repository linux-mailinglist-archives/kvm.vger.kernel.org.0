Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F60B5781A5
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 14:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234716AbiGRMIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 08:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234708AbiGRMIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 08:08:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DEFFD2409B
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 05:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658146101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=krSpkigEkANftfmisITHLdv9RXWL+ZzBEaxDBKikm30=;
        b=PIIJRQ3igpqF7oLTZAaOlGXRtJ3K4tXAFKvheOHhV1PvFeAZc4EQY1JOJUWviFlLW5uD2J
        TWRW3FpYG7D6vsauFT11+cmALCUJy3S3n2lRdG31bEs7i/85PuepwrkE11jw6YrdOqxtor
        gslnbsOkusKWv+GpcBJrAvhHtly/Nvo=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-gmdP_9aqOGWyk7cDSfnQrQ-1; Mon, 18 Jul 2022 08:08:20 -0400
X-MC-Unique: gmdP_9aqOGWyk7cDSfnQrQ-1
Received: by mail-qk1-f197.google.com with SMTP id w22-20020a05620a425600b006b5f48556cbso804994qko.17
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 05:08:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=krSpkigEkANftfmisITHLdv9RXWL+ZzBEaxDBKikm30=;
        b=JdFHb9JPQhBIlZvizh8GvTbG7Uy0CeAyYW/1veDUUZLy3dvwzVxYFTg18pxGRI7nWt
         imLKyG98cNTpDxJanN/DB7WWFvm2Zos8v/5WqMbE8FMLiZYSHpxkicLFnDCNtA4gFTWv
         MtHaQ8xP6Ufo0ySF60O+RL00fxkW6Ij/huZBPzxzbwSm4Sn/AEOTsi/Rn2cTnNWUfquh
         Wpw8OGSYDidVDaTbAKSVCDfItNWQzfr+12osUZYuVCWK8h5otDm4gYw6QG0C4OZzcPwW
         fz7M9A3ORTufrFC2SkRvzjlQ6nVNc70mPQM7AMlBHIn9NX20PumFxyu20Vqb9lBfhRJo
         oHGQ==
X-Gm-Message-State: AJIora8X4GexfqvB3aDJzV0bF1jzqB1DY08VX8c+tCWoYdk63GPGYF4O
        oVygY5HyMTpKGEdbZifQRJ7Y1z6x1jiO472c1F3h5nn1hLOC0aF3l0V7Y5+SyVTaYaA40FC9/gh
        NuDNk4uecPH6Y
X-Received: by 2002:a05:620a:2402:b0:6af:19d6:7445 with SMTP id d2-20020a05620a240200b006af19d67445mr16923164qkn.450.1658146099072;
        Mon, 18 Jul 2022 05:08:19 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uUBOKmb7F9eGk91ZPnmTx/rWBSUBHqWeuqoXYFAdjo1+aV05won6XaTI69GQn86EucYoRr7w==
X-Received: by 2002:a05:620a:2402:b0:6af:19d6:7445 with SMTP id d2-20020a05620a240200b006af19d67445mr16923121qkn.450.1658146098793;
        Mon, 18 Jul 2022 05:08:18 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id k11-20020ac8140b000000b0031e9d9635d4sm8898065qtj.23.2022.07.18.05.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 05:08:18 -0700 (PDT)
Message-ID: <f76cbfeca245fcd5e5d69cb91af9a0a1d6aaf1d0.camel@redhat.com>
Subject: Re: [PATCH 4/4] KVM: x86/mmu: Restrict mapping level based on guest
 MTRR iff they're used
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 18 Jul 2022 15:08:15 +0300
In-Reply-To: <20220715230016.3762909-5-seanjc@google.com>
References: <20220715230016.3762909-1-seanjc@google.com>
         <20220715230016.3762909-5-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-07-15 at 23:00 +0000, Sean Christopherson wrote:
> Restrict the mapping level for SPTEs based on the guest MTRRs if and only
> if KVM may actually use the guest MTRRs to compute the "real" memtype.
> For all forms of paging, guest MTRRs are purely virtual in the sense that
> they are completely ignored by hardware, i.e. they affect the memtype
> only if software manually consumes them.  The only scenario where KVM
> consumes the guest MTRRs is when shadow_memtype_mask is non-zero and the
> guest has non-coherent DMA, in all other cases KVM simply leaves the PAT
> field in SPTEs as '0' to encode WB memtype.
> 
> Note, KVM may still ultimately ignore guest MTRRs, e.g. if the backing
> pfn is host MMIO, but false positives are ok as they only cause a slight
> performance blip (unless the guest is doing weird things with its MTRRs,
> which is extremely unlikely).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 52664c3caaab..82f38af06f5c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4295,14 +4295,26 @@ EXPORT_SYMBOL_GPL(kvm_handle_page_fault);
>  
>  int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
> -       while (fault->max_level > PG_LEVEL_4K) {
> -               int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
> -               gfn_t base = (fault->addr >> PAGE_SHIFT) & ~(page_num - 1);
> +       /*
> +        * If the guest's MTRRs may be used to compute the "real" memtype,
> +        * restrict the mapping level to ensure KVM uses a consistent memtype
> +        * across the entire mapping.  If the host MTRRs are ignored by TDP
> +        * (shadow_memtype_mask is non-zero), and the VM has non-coherent DMA
> +        * (DMA doesn't snoop CPU caches), KVM's ABI is to honor the memtype
> +        * from the guest's MTRRs so that guest accesses to memory that is
> +        * DMA'd aren't cached against the guest's wishes.
> +        *
> +        * Note, KVM may still ultimately ignore guest MTRRs for certain PFNs,
> +        * e.g. KVM will force UC memtype for host MMIO.
> +        */
> +       if (shadow_memtype_mask && kvm_arch_has_noncoherent_dma(vcpu->kvm)) {
> +               for ( ; fault->max_level > PG_LEVEL_4K; --fault->max_level) {
> +                       int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
> +                       gfn_t base = (fault->addr >> PAGE_SHIFT) & ~(page_num - 1);
>  
> -               if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
> -                       break;
> -
> -               --fault->max_level;
> +                       if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
> +                               break;
> +               }
>         }
>  
>         return direct_page_fault(vcpu, fault);


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


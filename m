Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A8A4D8803
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 16:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238293AbiCNP0F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 11:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234226AbiCNP0E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 11:26:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D254644E
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 08:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647271493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xOJcx0cmLDQK1gGjHMb+p67BMvylagIHDxUOd/Ur3nU=;
        b=CtxGmOd1i9mhCqEWdNqM+VG1cAObMVLRecpEMVEsSt+SJFCmeHZrRZbHE90NsIsrdT2lcX
        UhbZqEJfVCNWZon0E8Igmnwpg+Y16JigLgCE8Wi3zyr0cadpx4Zsi5mvWGlcTkp5BeZqyn
        jDgPQxWlqTPRUvPFPmHILMKHLDovyAY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-3-O3BfoxQoNPypqHfMVfZVuA-1; Mon, 14 Mar 2022 11:24:52 -0400
X-MC-Unique: O3BfoxQoNPypqHfMVfZVuA-1
Received: by mail-wr1-f72.google.com with SMTP id j44-20020adf912f000000b00203a5a55817so829256wrj.13
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 08:24:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xOJcx0cmLDQK1gGjHMb+p67BMvylagIHDxUOd/Ur3nU=;
        b=JUqt2DPr40KKB3dvw8/xTz/aif+muU1Atm9ilwtuW2yQVIYTt41FKUgqNSf47V+YzD
         sjorz5cztpq6ERTY9uYh9PghvWZ1jI7kDBNe6g3ZClpyQG2P9jk7I/hbsff5FpuOEttZ
         2mN3fgC2SjjMZWDmtjVWBCQZBnnuAI6MqE+q8bkcUV+BGqDuelwUhkoV4UFgYhYbbJ54
         MLVu2BbxG59S4jeHmEGELtJH9+Q8lvgndVGvvoojPPGDr8gxIJJ6/NXOpMf/vVc5IFps
         OC7ABLJtp2FNQBPB8XggAxW8SlfbvCrnzIhFzPxT6F3lfXr8n899bsH7xIkTd2s58cyu
         Wz7w==
X-Gm-Message-State: AOAM5309Mn6Djm+yjCoq9NwNW3OZKE5kwSFQDCgIOgC4kjwyA3IjnYrN
        OOxozklehUSPyq+xAy1Ikb+RoYxmf5fC53o2WBr6BvqqOya4JcDjjK8XYNu29iIxyztd0tQGTmS
        HFnLPVMHNcx9U
X-Received: by 2002:a5d:5850:0:b0:1fc:a7d7:e33b with SMTP id i16-20020a5d5850000000b001fca7d7e33bmr16569430wrf.157.1647271491016;
        Mon, 14 Mar 2022 08:24:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyepgEI9wbW8AcLZafdUt5uVHDnPcukrfvttKQVcKQzMTVgYp8UJK8zfzUC/C9d5e0S72EjVA==
X-Received: by 2002:a5d:5850:0:b0:1fc:a7d7:e33b with SMTP id i16-20020a5d5850000000b001fca7d7e33bmr16569415wrf.157.1647271490804;
        Mon, 14 Mar 2022 08:24:50 -0700 (PDT)
Received: from redhat.com ([2.55.155.245])
        by smtp.gmail.com with ESMTPSA id n2-20020a056000170200b001f1e16f3c53sm13658963wrc.51.2022.03.14.08.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 08:24:50 -0700 (PDT)
Date:   Mon, 14 Mar 2022 11:24:45 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     qemu-devel@nongnu.org, Peter Xu <peterx@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Claudio Fontana <cfontana@suse.de>,
        Igor Mammedov <imammedo@redhat.com>,
        Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>
Subject: Re: [PATCH 2/4] intel_iommu: Support IR-only mode without DMA
 translation
Message-ID: <20220314112001-mutt-send-email-mst@kernel.org>
References: <20220314142544.150555-1-dwmw2@infradead.org>
 <20220314142544.150555-2-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314142544.150555-2-dwmw2@infradead.org>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 14, 2022 at 02:25:42PM +0000, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> By setting none of the SAGAW bits we can indicate to a guest that DMA
> translation isn't supported. Tested by booting Windows 10, as well as
> Linux guests with the fix at https://git.kernel.org/torvalds/c/c40aaaac10
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Acked-by: Jason Wang <jasowang@redhat.com>

this is borderline like a feature, but ...

> ---
>  hw/i386/intel_iommu.c         | 14 ++++++++++----
>  include/hw/i386/intel_iommu.h |  1 +
>  2 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
> index 32471a44cb..948c653e74 100644
> --- a/hw/i386/intel_iommu.c
> +++ b/hw/i386/intel_iommu.c
> @@ -2214,7 +2214,7 @@ static void vtd_handle_gcmd_write(IntelIOMMUState *s)
>      uint32_t changed = status ^ val;
>  
>      trace_vtd_reg_write_gcmd(status, val);
> -    if (changed & VTD_GCMD_TE) {
> +    if ((changed & VTD_GCMD_TE) && s->dma_translation) {
>          /* Translation enable/disable */
>          vtd_handle_gcmd_te(s, val & VTD_GCMD_TE);
>      }
> @@ -3122,6 +3122,7 @@ static Property vtd_properties[] = {
>      DEFINE_PROP_BOOL("x-scalable-mode", IntelIOMMUState, scalable_mode, FALSE),
>      DEFINE_PROP_BOOL("snoop-control", IntelIOMMUState, snoop_control, false),
>      DEFINE_PROP_BOOL("dma-drain", IntelIOMMUState, dma_drain, true),
> +    DEFINE_PROP_BOOL("dma-translation", IntelIOMMUState, dma_translation, true),
>      DEFINE_PROP_END_OF_LIST(),
>  };
>  
> @@ -3627,12 +3628,17 @@ static void vtd_init(IntelIOMMUState *s)
>      s->next_frcd_reg = 0;
>      s->cap = VTD_CAP_FRO | VTD_CAP_NFR | VTD_CAP_ND |
>               VTD_CAP_MAMV | VTD_CAP_PSI | VTD_CAP_SLLPS |
> -             VTD_CAP_SAGAW_39bit | VTD_CAP_MGAW(s->aw_bits);
> +             VTD_CAP_MGAW(s->aw_bits);
>      if (s->dma_drain) {
>          s->cap |= VTD_CAP_DRAIN;
>      }
> -    if (s->aw_bits == VTD_HOST_AW_48BIT) {
> -        s->cap |= VTD_CAP_SAGAW_48bit;
> +    if (s->dma_translation) {
> +            if (s->aw_bits >= VTD_HOST_AW_39BIT) {
> +                    s->cap |= VTD_CAP_SAGAW_39bit;
> +            }
> +            if (s->aw_bits >= VTD_HOST_AW_48BIT) {
> +                    s->cap |= VTD_CAP_SAGAW_48bit;
> +            }
>      }
>      s->ecap = VTD_ECAP_QI | VTD_ECAP_IRO;
>


... this looks like you are actually fixing aw_bits < VTD_HOST_AW_39BIT,
right? So maybe this patch is ok like this since it also fixes a
bug. Pls add this to commit log though.

  
> diff --git a/include/hw/i386/intel_iommu.h b/include/hw/i386/intel_iommu.h
> index 3b5ac869db..d898be85ce 100644
> --- a/include/hw/i386/intel_iommu.h
> +++ b/include/hw/i386/intel_iommu.h
> @@ -267,6 +267,7 @@ struct IntelIOMMUState {
>      bool buggy_eim;                 /* Force buggy EIM unless eim=off */
>      uint8_t aw_bits;                /* Host/IOVA address width (in bits) */
>      bool dma_drain;                 /* Whether DMA r/w draining enabled */
> +    bool dma_translation;           /* Whether DMA translation supported */
>  
>      /*
>       * Protects IOMMU states in general.  Currently it protects the
> -- 
> 2.33.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D069644FD4
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 00:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiLFXxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 18:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiLFXxc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 18:53:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDF1B77
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 15:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670370757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TXbtDSGsZGDrvKu45o0aZOsv+EbJPni8ns+Ws0e0uf0=;
        b=R5Hkccjd6BNJ13NF11js76GEQcjdTOV86Px1z//vqTEW3mnmdeAizZ/XAa5Jz6hHOpUhDr
        bMT9Fq/gK3R1Dp+MJxIYua40bMtSMvfeGVQUlP43GNdl6XZYENmfT1LtwWy10hlsowJwTL
        uZH8CMKTzpAEHMENVt5/mEmlNcgxHH8=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-656-9kFTREMLM2eB-XVfrBeKCw-1; Tue, 06 Dec 2022 18:52:35 -0500
X-MC-Unique: 9kFTREMLM2eB-XVfrBeKCw-1
Received: by mail-il1-f200.google.com with SMTP id i11-20020a056e02152b00b00303642498daso5312784ilu.5
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 15:52:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TXbtDSGsZGDrvKu45o0aZOsv+EbJPni8ns+Ws0e0uf0=;
        b=E1Oc9I6MCrlxvkHHTjQgcf4Rpp1rj09md5NvwMB6nw0LXdeocgRZh+H/6DB8bbU5dN
         5VoZZMerN41uibLfLdyjc2wGZ4Zl6wr5YjkWw9AEcl+zzC4V36EzUlqZviDjDsNrS08g
         TGoZwv2Tp7G4TC7SAXJPMf2/YpdBbefHUx9ArNYV7tswQYeoqT/EnCx6G2vD04xEnlQD
         9RyK2JEHi3HHxzr7NIiEElXa20v9k/T+CrbNzZyp4K5J4eel/XZW+LYmzt60cD7oPbOg
         xjd7v5KHjHRuxJUwiNfceGkCAOf2+I5pJS7EjDtD54srgeFds7WNFUucSasFAZ4L7uVs
         fD6w==
X-Gm-Message-State: ANoB5pm8t88ZKx4qijdntN+cv6KZAtJ5IwZHKjNo32ijKDEz2MDQkZqA
        6xhxlc0ARx1bPWoqM3YXgNI+gFnCEUlLWuS60nWCPhKrW/YzCN/RgjZugl4QcludvC+KW1q524v
        R8nFf9PabBAgc
X-Received: by 2002:a92:d744:0:b0:2ff:dea9:1544 with SMTP id e4-20020a92d744000000b002ffdea91544mr40736004ilq.4.1670370754423;
        Tue, 06 Dec 2022 15:52:34 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6GdSMZYeQmKhErDV80S4q6b0W5E2KWhBm3KahLaB7NjjUmpwzCU0dFjPlbyII36fxLNkXzyg==
X-Received: by 2002:a92:d744:0:b0:2ff:dea9:1544 with SMTP id e4-20020a92d744000000b002ffdea91544mr40735995ilq.4.1670370754182;
        Tue, 06 Dec 2022 15:52:34 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x11-20020a02340b000000b00389eb7a0766sm7283438jae.23.2022.12.06.15.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 15:52:33 -0800 (PST)
Date:   Tue, 6 Dec 2022 16:52:32 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V1 1/8] vfio: delete interfaces to update vaddr
Message-ID: <20221206165232.2a822e52.alex.williamson@redhat.com>
In-Reply-To: <1670363753-249738-2-git-send-email-steven.sistare@oracle.com>
References: <1670363753-249738-1-git-send-email-steven.sistare@oracle.com>
        <1670363753-249738-2-git-send-email-steven.sistare@oracle.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  6 Dec 2022 13:55:46 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index d7d8e09..5c5cc7e 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
...
> @@ -1265,18 +1256,12 @@ struct vfio_bitmap {
>   *
>   * If flags & VFIO_DMA_UNMAP_FLAG_ALL, unmap all addresses.  iova and size
>   * must be 0.  This cannot be combined with the get-dirty-bitmap flag.
> - *
> - * If flags & VFIO_DMA_UNMAP_FLAG_VADDR, do not unmap, but invalidate host
> - * virtual addresses in the iova range.  Tasks that attempt to translate an
> - * iova's vaddr will block.  DMA to already-mapped pages continues.  This
> - * cannot be combined with the get-dirty-bitmap flag.
>   */
>  struct vfio_iommu_type1_dma_unmap {
>  	__u32	argsz;
>  	__u32	flags;
>  #define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
>  #define VFIO_DMA_UNMAP_FLAG_ALL		     (1 << 1)
> -#define VFIO_DMA_UNMAP_FLAG_VADDR	     (1 << 2)


This flag should probably be marked reserved.

Should we consider this separately for v6.2?

For the remainder, the long term plan is to move to iommufd, so any new
feature of type1 would need equivalent support in iommufd.  Thanks,

Alex


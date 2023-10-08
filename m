Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A38D77BCC1C
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 06:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344368AbjJHEh6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 00:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344307AbjJHEh5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 00:37:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52D4B9
        for <kvm@vger.kernel.org>; Sat,  7 Oct 2023 21:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696739834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dvtyRRz+nwNRt7FvkUoa8BCNkTJILEam9tMkM/HCha0=;
        b=BNp+d5EqNYpP2bZAE9k8JgQFg9k2NPo392NQY4GPdPgXbcnHr6Wgd5F1d3V8kZkTWazBE/
        Yw72ho08HFq6EA5W4GUZ6sFhPwwct7ZDi999e8FSWPl7BuGSfYt9yJPcXlONiWOkrd6TzQ
        57SKfb0Sajkw7nCAwbBpGRClDNDz7i8=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-iix0WzX2M-iED_qDZR7udw-1; Sun, 08 Oct 2023 00:37:13 -0400
X-MC-Unique: iix0WzX2M-iED_qDZR7udw-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-50433961a36so3017110e87.3
        for <kvm@vger.kernel.org>; Sat, 07 Oct 2023 21:37:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696739832; x=1697344632;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dvtyRRz+nwNRt7FvkUoa8BCNkTJILEam9tMkM/HCha0=;
        b=T1RHEPKFhorq5X3UAImcs7DdU39AA2aY5PyAjXF7tnGtpDUahkIHvMr2r+W7kUTsl4
         Lyxbb2YrW2NxMlKYCw6k+Gvepj4K8g9kLZJtJhBP8V8edg0Q5LR6SF6ly8nbtYyaVTPm
         wXJHD890auR8g0dAlT6NEGjzbX4yaU//elKxjYMek+zqtRtKDuYNzoRpAhIss+vAUqpL
         XdBrj2qoU/UIIghoTRXttDTdzwv2hOCncYOGMm9KC5qlP9dVf3JL3OznFYUwab5Hap+S
         KOofk633B8uiEOCesS7nkl6aJWNVOyuZt19P1OxcgxwV9rlzdYYpmRZKxOrtYunPm1e6
         EYbQ==
X-Gm-Message-State: AOJu0Yw2cQu3jeuNDEHmoqq6lr2BsRL8XTI3onxBcCJmQl974XAv7TWI
        qe7MOSw3f/rTwe7vygCmGuuAP9zp66R7cHD2duRk7PGTevAFcz/VnCT68ms83zXaxYkUQHX2aMQ
        03Og3XoZVpPt0ZS7mQ8uHpLgyinhY
X-Received: by 2002:ac2:4c9b:0:b0:500:9a15:9054 with SMTP id d27-20020ac24c9b000000b005009a159054mr8820044lfl.20.1696739831934;
        Sat, 07 Oct 2023 21:37:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbwdFniTDysoOdy55vJ9mvDY2iLbB22GYbgOhSxJ2xBXcK3O2G6gfgJld3IG0br8gYtQV4XFjb14Blx0X7c18=
X-Received: by 2002:ac2:4c9b:0:b0:500:9a15:9054 with SMTP id
 d27-20020ac24c9b000000b005009a159054mr8820036lfl.20.1696739831548; Sat, 07
 Oct 2023 21:37:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230926050021.717-1-liming.wu@jaguarmicro.com>
In-Reply-To: <20230926050021.717-1-liming.wu@jaguarmicro.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Sun, 8 Oct 2023 12:37:00 +0800
Message-ID: <CACGkMEtF7hZ8kGYi8rF68SzZqdYJ6i1SeuVU2hiBTY-FLapSBw@mail.gmail.com>
Subject: Re: [PATCH 1/2] tools/virtio: Add dma sync api for virtio test
To:     liming.wu@jaguarmicro.com
Cc:     "Michael S . Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, 398776277@qq.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023 at 1:00=E2=80=AFPM <liming.wu@jaguarmicro.com> wrote:
>
> From: Liming Wu <liming.wu@jaguarmicro.com>
>
> Fixes: 8bd2f71054bd ("virtio_ring: introduce dma sync api for virtqueue")
> also add dma sync api for virtio test.
>
> Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  tools/virtio/linux/dma-mapping.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/tools/virtio/linux/dma-mapping.h b/tools/virtio/linux/dma-ma=
pping.h
> index 834a90bd3270..822ecaa8e4df 100644
> --- a/tools/virtio/linux/dma-mapping.h
> +++ b/tools/virtio/linux/dma-mapping.h
> @@ -24,11 +24,23 @@ enum dma_data_direction {
>  #define dma_map_page(d, p, o, s, dir) (page_to_phys(p) + (o))
>
>  #define dma_map_single(d, p, s, dir) (virt_to_phys(p))
> +#define dma_map_single_attrs(d, p, s, dir, a) (virt_to_phys(p))
>  #define dma_mapping_error(...) (0)
>
>  #define dma_unmap_single(d, a, s, r) do { (void)(d); (void)(a); (void)(s=
); (void)(r); } while (0)
>  #define dma_unmap_page(d, a, s, r) do { (void)(d); (void)(a); (void)(s);=
 (void)(r); } while (0)
>
> +#define sg_dma_address(sg) (0)
> +#define dma_need_sync(v, a) (0)
> +#define dma_unmap_single_attrs(d, a, s, r, t) do { \
> +       (void)(d); (void)(a); (void)(s); (void)(r); (void)(t); \
> +} while (0)
> +#define dma_sync_single_range_for_cpu(d, a, o, s, r) do { \
> +       (void)(d); (void)(a); (void)(o); (void)(s); (void)(r); \
> +} while (0)
> +#define dma_sync_single_range_for_device(d, a, o, s, r) do { \
> +       (void)(d); (void)(a); (void)(o); (void)(s); (void)(r); \
> +} while (0)
>  #define dma_max_mapping_size(...) SIZE_MAX
>
>  #endif
> --
> 2.34.1
>


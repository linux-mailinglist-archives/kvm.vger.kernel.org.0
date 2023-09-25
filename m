Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195497ACE21
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 04:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbjIYCbZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Sep 2023 22:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231682AbjIYCbW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Sep 2023 22:31:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A139EEE
        for <kvm@vger.kernel.org>; Sun, 24 Sep 2023 19:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695609033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=My4fcruqhbNbk3ZnNE5dRaCSndf75smmnZbl/BLKBNQ=;
        b=XMn0cEVWdi0LekSwZ9XuY5OG38iK+TFc32A6uc6MKPIjEnMMhJdS1jOwkoSCc9VyAhLMmH
        hLat9DY5hY+SUEKbpIhorDfVFERCqCfvQ1k7v/34a6eECAYvjVGEgfMALqY18iAIFHB/p+
        ANCyMf5bokQzTGEnoSX2lF0nKz90Bqo=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-FlAP8DELM9ajwPg7oTx7YQ-1; Sun, 24 Sep 2023 22:30:32 -0400
X-MC-Unique: FlAP8DELM9ajwPg7oTx7YQ-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2c136b9d66aso59274931fa.3
        for <kvm@vger.kernel.org>; Sun, 24 Sep 2023 19:30:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695609031; x=1696213831;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=My4fcruqhbNbk3ZnNE5dRaCSndf75smmnZbl/BLKBNQ=;
        b=YiN13wv36GzDenk+TjAT97Bk/6If8rzcKLq6JuW5TDIAm31kHKbpjFRhmiTJGNmsTE
         dgwQ5F1ntDZNiAEIrw6kgAbBEHVOZKj5FHgpaZwRKdlXtigxhsx7u9wkSsQBiilfvR6Z
         MBqv0XFRLQx1rxZjjl0U9jpGJZ64xUJR+vE5UISuA35gnEU3VZq9IkJv94IkOXlB5E2R
         GAGYRBq0ReRduewLOl0oXjJ/T71Q4mn67EiQ5FWzgtp2PhExH0E6Pnokmpn8NP0j1vIe
         xqWw7H2L5EEwo0yuCtxjwBC6c9+AvaVXubC8jvI7D5Hp/9MAGl0IBzy5DEwVsZqmscXt
         Un0g==
X-Gm-Message-State: AOJu0YzF9XIc3AP6kdZSRnR42pCmWEQGd3xWtNHhsmnsA8ZkerUgEXNd
        qCbeZk3PnQicpad9ZmVs9pWiHviM+ulhDkt2vWfAzxJ6kUlTiCDmoWbO+CjzzfqVL7v59hWliEh
        5k9wDLs/TxdOayI1HATCr6f/YeqIO
X-Received: by 2002:a05:6512:29a:b0:503:303:9e2d with SMTP id j26-20020a056512029a00b0050303039e2dmr4172035lfp.5.1695609031038;
        Sun, 24 Sep 2023 19:30:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCXmp/aDdUak815OsqpgvdcBHOa0dtFaMwCsIbT9r2DT0517VZ0CRgMv9lcx79VNCWB0J1wHJjd25DWw8PP7A=
X-Received: by 2002:a05:6512:29a:b0:503:303:9e2d with SMTP id
 j26-20020a056512029a00b0050303039e2dmr4172025lfp.5.1695609030705; Sun, 24 Sep
 2023 19:30:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230921125348-mutt-send-email-mst@kernel.org>
 <20230921170709.GS13733@nvidia.com> <20230921131035-mutt-send-email-mst@kernel.org>
 <20230921174450.GT13733@nvidia.com> <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com> <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com> <20230921155834-mutt-send-email-mst@kernel.org>
 <CACGkMEvD+cTyRtax7_7TBNECQcGPcsziK+jCBgZcLJuETbyjYw@mail.gmail.com>
 <20230922122246.GN13733@nvidia.com> <PH0PR12MB548127753F25C45B7EFF203DDCFFA@PH0PR12MB5481.namprd12.prod.outlook.com>
In-Reply-To: <PH0PR12MB548127753F25C45B7EFF203DDCFFA@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 25 Sep 2023 10:30:19 +0800
Message-ID: <CACGkMEuX5HJVBOw9E+skr=K=QzH3oyHK8gk-r0hAvi6Wm7OA7Q@mail.gmail.com>
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
To:     Parav Pandit <parav@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 8:25=E2=80=AFPM Parav Pandit <parav@nvidia.com> wro=
te:
>
>
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Friday, September 22, 2023 5:53 PM
>
>
> > > And what's more, using MMIO BAR0 then it can work for legacy.
> >
> > Oh? How? Our team didn't think so.
>
> It does not. It was already discussed.
> The device reset in legacy is not synchronous.

How do you know this?

> The drivers do not wait for reset to complete; it was written for the sw =
backend.

Do you see there's a flush after reset in the legacy driver?

static void vp_reset(struct virtio_device *vdev)
{
        struct virtio_pci_device *vp_dev =3D to_vp_device(vdev);
        /* 0 status means a reset. */
        vp_legacy_set_status(&vp_dev->ldev, 0);
        /* Flush out the status write, and flush in device writes,
         * including MSi-X interrupts, if any. */
        vp_legacy_get_status(&vp_dev->ldev);
        /* Flush pending VQ/configuration callbacks. */
        vp_synchronize_vectors(vdev);
}

Thanks



> Hence MMIO BAR0 is not the best option in real implementations.
>


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156C87BF320
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 08:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442220AbjJJGdI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 02:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442233AbjJJGdG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 02:33:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35589E
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 23:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696919541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K9kT46zzJ4Pv/uNaGDbttTONHdzkYaHl6vJNLUy+dGg=;
        b=KExHqOCCJVG19Zf4/ya+ysDHTFeoeTArn8R3y4B4134LNTd7Xdxf5QR3WJOrhEPyq3quMH
        3gMqmJEq1qTV3U41SBOj9vqMR71AUuq0GSc88mt0afjtN12jnxe9QLmQotUTjVPsQkXrkC
        MDFFmuYsHWhFc+Jo+mJgnFCJMugWano=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-417-C6OWJEUFOUisJ_Eg256CPg-1; Tue, 10 Oct 2023 02:32:14 -0400
X-MC-Unique: C6OWJEUFOUisJ_Eg256CPg-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5043c463bf9so4912013e87.0
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 23:32:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696919533; x=1697524333;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K9kT46zzJ4Pv/uNaGDbttTONHdzkYaHl6vJNLUy+dGg=;
        b=nBA/2p7TQ2in51vhMyQIxhPy4Tbq2LE2WRACLWaJxxwkPC+KncTzwxxBdyw3E7MPPz
         Zfkgy7uNV4NeO2eaAlJMtIis9/HcQ7fm8uYRVknjpVO09PnYbFjud2jk4dIjlumWb45A
         NxXYat1V44zV/VLl8xtQKfmTotFCm9fCsR5Y5WJkwrUDpiuFY4HW8EwonN1B0B1rK6J+
         496AYLXdzCLHC4cGkvpj+46pGZ1CHUecUaiB8SL00X9h42FjsUDiTM1MuH38kSoZOE7a
         bWuIk8x6KY8w4le4wh49lvHWco5Di2ZjJ15427djom5TxIw6YsWptoVDPbamZt+l+WMK
         wNkg==
X-Gm-Message-State: AOJu0YznSjVoMSRHxsZth+qWKM9+Ajxjk8Zkg3ZxRYm6g9/HCuLmIZZl
        TTbgOq73gqk7jxvdqi376J6AWDEVlFjsCA/JAz5ldvaFEp2wQE3sBwORjOSm41zWBbfKKvlzDbv
        8Y33eQ2ijUDPrICrMltdI0jy1QCa6
X-Received: by 2002:a05:6512:2392:b0:4f9:54f0:b6db with SMTP id c18-20020a056512239200b004f954f0b6dbmr18049566lfv.13.1696919533198;
        Mon, 09 Oct 2023 23:32:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMuNalqFHbo9fbkOLQicOz6Sn3F911SHVPCJzCScea/EKBEn2jF2zne4YSBmcfHq0eewz0GZHEAMKr2KCyjms=
X-Received: by 2002:a05:6512:2392:b0:4f9:54f0:b6db with SMTP id
 c18-20020a056512239200b004f954f0b6dbmr18049550lfv.13.1696919532918; Mon, 09
 Oct 2023 23:32:12 -0700 (PDT)
MIME-Version: 1.0
References: <20231009112401.1060447-1-dtatulea@nvidia.com> <20231009112401.1060447-15-dtatulea@nvidia.com>
In-Reply-To: <20231009112401.1060447-15-dtatulea@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 10 Oct 2023 14:32:02 +0800
Message-ID: <CACGkMEtmwW_GdHqY-9+pioOZU79nJHc_bWn-iStahDNg7r=06A@mail.gmail.com>
Subject: Re: [PATCH vhost v3 14/16] vdpa/mlx5: Enable hw support for vq
 descriptor mapping
To:     Dragos Tatulea <dtatulea@nvidia.com>
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Eugenio Perez Martin <eperezma@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
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

On Mon, Oct 9, 2023 at 7:25=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com>=
 wrote:
>
> Vq descriptor mappings are supported in hardware by filling in an
> additional mkey which contains the descriptor mappings to the hw vq.
>
> A previous patch in this series added support for hw mkey (mr) creation
> for ASID 1.
>
> This patch fills in both the vq data and vq descriptor mkeys based on
> group ASID mapping.
>
> The feature is signaled to the vdpa core through the presence of the
> .get_vq_desc_group op.
>
> Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


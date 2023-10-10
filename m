Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A76F7BF326
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 08:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442286AbjJJGdr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 02:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442284AbjJJGdn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 02:33:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F794A7
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 23:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696919575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HVu0GN3UMuC1J5U/X30RP90Co4BnseMhqCL4ftuMT78=;
        b=g1WnGEoEsG94LQsXnFWDydN0/zKTXpoccIKOfeRm7pwG4trMwhYOn5EQNT5E5ejobOXZkn
        qPxNye0hC7Bz8CDn5TlR75HXiy7tiyjl0QG8dQAjTfhASwv6igS0ivPrW7LhR6P95mkXgj
        9nJhyuq/ChZFpjC343xWf1U5YZmFk8M=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-213-wE0jh0tUN-OjOKg5NgCXnQ-1; Tue, 10 Oct 2023 02:32:53 -0400
X-MC-Unique: wE0jh0tUN-OjOKg5NgCXnQ-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-50428596a79so4261657e87.0
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 23:32:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696919572; x=1697524372;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HVu0GN3UMuC1J5U/X30RP90Co4BnseMhqCL4ftuMT78=;
        b=UWSBHnTm7796eVmMWX1wxcXzFbM2jRmVyy/88FSVRwztOiwYvQkB7LHp4JFeWRnlUx
         JuezGBAEFUEplgHBqNUjn60pcZ8vRjMHOZu3CQ/l3+bvgpT57qI0AJFjD5q+cKyCT5U4
         iKZHnXo/DDC2TR9rQqdMva9ux8075u7XqZ1aNsSWGaPHQw6D/+Na93dSq1qcUU7gQpYd
         o9i3+ebVziVVKViI7Vg0nxY/YxAgDT2c8gJlt+Ex8gguaG78tSqjJofZvlI0/OTx7LkP
         vAWk1f4hRIHbaYIKA22R5JNiKA/PDwkP28lCQ3Xt8aRqG7PxaAfY2M7cbFdFwgzg5T0G
         mRQQ==
X-Gm-Message-State: AOJu0YysMAIIyRo97Mp2SOCmOTipoU0eQPvddvCE/4cC1ZeNMSksgFw7
        HRTUJbaVMThWIRjsaQmAV96PGFBwLCwuDErxmUcx8qlXJ0F4z35EGltuPvr1vM1yDIC4gxHon7V
        FfP22dHmLhyQ/CkXE/sBNXxXwM+KH
X-Received: by 2002:a05:6512:314a:b0:4ff:62a4:7aaf with SMTP id s10-20020a056512314a00b004ff62a47aafmr11127840lfi.2.1696919572307;
        Mon, 09 Oct 2023 23:32:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtMFsi49pUcXNrsqLVVSMxqRi3/wpikBnKYjqg8bB3txkiYAAARR8apYbcnWGISxwA+jW/drDYstJJ6tJP3Rw=
X-Received: by 2002:a05:6512:314a:b0:4ff:62a4:7aaf with SMTP id
 s10-20020a056512314a00b004ff62a47aafmr11127828lfi.2.1696919571953; Mon, 09
 Oct 2023 23:32:51 -0700 (PDT)
MIME-Version: 1.0
References: <20231009112401.1060447-1-dtatulea@nvidia.com> <20231009112401.1060447-16-dtatulea@nvidia.com>
In-Reply-To: <20231009112401.1060447-16-dtatulea@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 10 Oct 2023 14:32:41 +0800
Message-ID: <CACGkMEveT2-iXsjvyAo9ucZgegEmw4Zs2cVvuTrH4yFfGxd0PQ@mail.gmail.com>
Subject: Re: [PATCH vhost v3 15/16] vdpa/mlx5: Make iotlb helper functions
 more generic
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
> They will be used in a follow-up patch.
>
> For dup_iotlb, avoid the src =3D=3D dst case. This is an error.
>
> Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


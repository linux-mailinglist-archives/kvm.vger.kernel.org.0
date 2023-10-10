Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8FC07BF319
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 08:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442156AbjJJGb4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 02:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442233AbjJJGbz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 02:31:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82440D3
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 23:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696919461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i8kjDRjOJKKJXRR5u7v3wOkH6EfelrGYi06F0LmbMIM=;
        b=O8sgwGueXg0SpggL/pgS+fo270CC21gTSRJ+0xZEuKP4HA72Eypi6RLpCUACFOoSVzL30E
        uhilYJWXvwZWR4SfbiZr35jT5ohrFZujCahcXQMbeav9OVBQiWBt27MjCPvQ7m4HnPxAN5
        Yb2qGZV6UO5DA6feS4Hsmyx4ygL2/nc=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-H4WMpa3JPRiLqyyI3uPWdA-1; Tue, 10 Oct 2023 02:30:50 -0400
X-MC-Unique: H4WMpa3JPRiLqyyI3uPWdA-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5043eb2c436so4611714e87.3
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 23:30:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696919449; x=1697524249;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i8kjDRjOJKKJXRR5u7v3wOkH6EfelrGYi06F0LmbMIM=;
        b=i/fnWkllRDSsEiT68UEt4jCsyAw10Mi025lA9LzfF9Yu4m3pqe8b7DgYtNzwy+h52z
         eG4vJBGuX8onLhYPvAg/S2NMITvpPoDqTSmyNtL/EUSSZIv0meRrQrhNQAAKTdJ3XvfC
         qsLAvgEoE6c+SOhPJNWCTK2qMQPnWtD08ij1cx7vqISJHKXzDejy0XOM2bfwtrFaPwNp
         Ccj7pgRBD3lmflyBPieGpCVM9iNrAVjZJilAquMMWX5PgDJ5cw7452Na9WI8zNkAj90b
         MRJZbp0lhwjo4kaO1jyk06O3/6pwp9OU6XhZckLrFYkj6HnFqap9AJoMkshDgdsa/vs7
         y3RA==
X-Gm-Message-State: AOJu0YyoaxyooIrdlo8vuNoj7XYoJ7uWHc/Q7XsuYL5VeZ6t2dlVrfZf
        0CYxul/wqhk/68lOtq6mTCNIUp4f27SPJYkZMvqBRu5aHWKebILeZeP00a0u1c9D1Lis7JWhDKd
        JgZz8D+fIltQBZZ9MJ98V274zWePR
X-Received: by 2002:ac2:5f89:0:b0:4fb:89e2:fc27 with SMTP id r9-20020ac25f89000000b004fb89e2fc27mr12885003lfe.54.1696919449091;
        Mon, 09 Oct 2023 23:30:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHmDA/vg0tl4u4YUxBy8HtRi4GakgkYvYLlL5YgdSd3QDLzEy3RLtMK2lk5R1+3JDmVtS3GeTuqJDtI9tK9sac=
X-Received: by 2002:ac2:5f89:0:b0:4fb:89e2:fc27 with SMTP id
 r9-20020ac25f89000000b004fb89e2fc27mr12884990lfe.54.1696919448905; Mon, 09
 Oct 2023 23:30:48 -0700 (PDT)
MIME-Version: 1.0
References: <20231009112401.1060447-1-dtatulea@nvidia.com> <20231009112401.1060447-14-dtatulea@nvidia.com>
In-Reply-To: <20231009112401.1060447-14-dtatulea@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 10 Oct 2023 14:30:38 +0800
Message-ID: <CACGkMEupdNSyE-cNCwePjobn8V3rSMi=TV0imfTAUBbAyaeKjQ@mail.gmail.com>
Subject: Re: [PATCH vhost v3 13/16] vdpa/mlx5: Introduce mr for vq descriptor
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
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 9, 2023 at 7:25=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com>=
 wrote:
>
> Introduce the vq descriptor group and mr per ASID. Until now
> .set_map on ASID 1 was only updating the cvq iotlb. From now on it also
> creates a mkey for it. The current patch doesn't use it but follow-up
> patches will add hardware support for mapping the vq descriptors.
>
> Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> ---

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A86B37BF328
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 08:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442296AbjJJGeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 02:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442285AbjJJGeP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 02:34:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F3EB0
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 23:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696919609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L/WWvP4QrvqQqSlBOZhfRHFJcoPieF7wXeR0DebzApE=;
        b=CSSG9fYvrrcfDqlDSH0qF6qYktvSa4blBdZ2qMn7QzGVZGawBWKDy98ZWZEcmmFmJQDGmi
        2TVLOcUQsOWweC3w/JbnW/0vFMJ2STLuLERYHVHLbNMh5/0VKxMreoNuGzR33GwSrrqiA7
        QLCFqpkSTNIQnvu4auR/D3qALixTTfE=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-207-XtjP0Io5MmCPRt2g8zVTFA-1; Tue, 10 Oct 2023 02:33:27 -0400
X-MC-Unique: XtjP0Io5MmCPRt2g8zVTFA-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-50433ca6d81so4876973e87.3
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 23:33:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696919606; x=1697524406;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L/WWvP4QrvqQqSlBOZhfRHFJcoPieF7wXeR0DebzApE=;
        b=H0WZqZMseNWHPt8708FgAdZt3s9MPmI8Wl6ec7pruq+1Tw4Iy31Ca+N6YXuSqdjkH8
         gMFIT/Pou56RCW5GbBM7C5a7mfKGf5//mGUFWi7HyLcQO4/ENFbap0SyuCefE8RLC98J
         yV/vkIOBlMbg/DqUsmBM08gB+GLmNapjuU6xUBG9DRpqGz/lbEPt4jCiANpIkdFiuCgv
         FGKcXi3jWEoIlrqQlsCS4FZvr4RPZjLiVJQOd8MwjH/VL1GjPqq3h+bvyl6MnNbNVNIR
         Kf6zttxiJmv7e5nfakClq5TD4Q3W9oJ6Zh4dARGJ5/Y+RB+p7YbiTBU911eXVxjleRBX
         nbtA==
X-Gm-Message-State: AOJu0Yylk1cnHLojyqlgXnIGlIfvTNHRRMLckw1QjNE5FhSC2SsXQs2x
        fikswg0qkQSofSSzq5CAhhh/ApL2JG8R0uXsPzFudI0MhKaYuzUENBRjwRE+OncZPE0JSIBCrvT
        BxNRyusR1oCJGvjVT/inSP/HuC+XE
X-Received: by 2002:ac2:4f09:0:b0:500:b553:c09e with SMTP id k9-20020ac24f09000000b00500b553c09emr18089917lfr.32.1696919605989;
        Mon, 09 Oct 2023 23:33:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGfDwrS8UnprtgX0H66/N9LaZXIPIn1izgf0p9kGHS1+OexDm2JvipAbhcvFs0hN9t/aq0yQfXWido0W9mnmrw=
X-Received: by 2002:ac2:4f09:0:b0:500:b553:c09e with SMTP id
 k9-20020ac24f09000000b00500b553c09emr18089905lfr.32.1696919605637; Mon, 09
 Oct 2023 23:33:25 -0700 (PDT)
MIME-Version: 1.0
References: <20231009112401.1060447-1-dtatulea@nvidia.com> <20231009112401.1060447-17-dtatulea@nvidia.com>
In-Reply-To: <20231009112401.1060447-17-dtatulea@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 10 Oct 2023 14:33:14 +0800
Message-ID: <CACGkMEuffeRaJh9P4Mo-PnXk06mFWKDbCcR_0Eogx3FBU-KW-A@mail.gmail.com>
Subject: Re: [PATCH vhost v3 16/16] vdpa/mlx5: Update cvq iotlb mapping on
 ASID change
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
> For the following sequence:
> - cvq group is in ASID 0
> - .set_map(1, cvq_iotlb)
> - .set_group_asid(cvq_group, 1)
>
> ... the cvq mapping from ASID 0 will be used. This is not always correct
> behaviour.
>
> This patch adds support for the above mentioned flow by saving the iotlb
> on each .set_map and updating the cvq iotlb with it on a cvq group change=
.
>
> Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> ---

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


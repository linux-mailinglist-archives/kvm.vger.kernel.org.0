Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E487BF313
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 08:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442295AbjJJGa7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 02:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442340AbjJJGax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 02:30:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDE9A3
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 23:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696919402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gkyhygrn0LjKBs+Gy+HOQR/ROK9i9+TCjbjoKrbTIPI=;
        b=Fv/+1kMIc6OwI1a9QpbPa8eFL1Db4c9p/JfOiYHnbrqeqjzZT6R1B9eU5W9cw1nD90l6Q4
        dG4e3Zt8gn1TjeewT649P1ftfdyH1qi1tsYvqJ57wKcTDviVUnIA/njCaJtTGNUg9OPM9f
        TTIl9DV/DCenQulGhwHsAWNDN41vTcs=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-seQYaigsNzazunq2gi8beA-1; Tue, 10 Oct 2023 02:30:01 -0400
X-MC-Unique: seQYaigsNzazunq2gi8beA-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-503343a850aso4486990e87.3
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 23:30:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696919400; x=1697524200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gkyhygrn0LjKBs+Gy+HOQR/ROK9i9+TCjbjoKrbTIPI=;
        b=FsEGRpkc7F8MB5+PPA9w/2oELjMh3nuATL93FNVpvi7XtfYJPzcqUu5qd5YfnedN8X
         51qd5GhdYNDx1rIM4vpA8JcDpzqI9s8kLrZ6vYqDxm4YZ/joyTWLqXJIFXyGfyYzVU6o
         B8lKUIVCDhg52PccJDFfE8eKuu9HUs1gSbuWofLPB+4Lef+kux6aojpItIowjODBSeo0
         bEgyeGYSXhjKTLKBYxnHtd+Wnq5JN+2X90DwrFS0IK9K82lZ8FTqvL9CR8uxwH3EfTI3
         kvtLu3qBpAi5ckcERpgOF72pfBWcKYtxLztAoWJW/8+P2qKsalXbrus4JgGHcu6e+CA2
         6/VA==
X-Gm-Message-State: AOJu0YyFWmkxvcyysix933o616qVESUyaLL6hJ1thmiIo67yWnV88w/f
        /YIt+n1xF2Js52Pff+Hr/RZOp34Tk+TWg+6iE8cRehzxBY/wu0tsyIKald5JWfaiqJ3IKofvZBi
        BAdK4JQJP1gNVHRMKAvPwze2C6aEa
X-Received: by 2002:a05:6512:3444:b0:504:7cc6:1ad7 with SMTP id j4-20020a056512344400b005047cc61ad7mr14922271lfr.1.1696919399898;
        Mon, 09 Oct 2023 23:29:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFhwDe3FDKZFhiwrOl5KVXL4P0qXDeJGMy+/g0KGSF4lR/hfI+JvoID/birDGa8k73PyhD9Jc/VWYdZ2/MiwBc=
X-Received: by 2002:a05:6512:3444:b0:504:7cc6:1ad7 with SMTP id
 j4-20020a056512344400b005047cc61ad7mr14922251lfr.1.1696919399537; Mon, 09 Oct
 2023 23:29:59 -0700 (PDT)
MIME-Version: 1.0
References: <20231009112401.1060447-1-dtatulea@nvidia.com> <20231009112401.1060447-13-dtatulea@nvidia.com>
In-Reply-To: <20231009112401.1060447-13-dtatulea@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 10 Oct 2023 14:29:48 +0800
Message-ID: <CACGkMEseT3P6s6XC4+=7LMrBtP_uG5q6oXDjTtkX_N8u2D0SVQ@mail.gmail.com>
Subject: Re: [PATCH vhost v3 12/16] vdpa/mlx5: Improve mr update flow
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
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 9, 2023 at 7:25=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com>=
 wrote:
>
> The current flow for updating an mr works directly on mvdev->mr which
> makes it cumbersome to handle multiple new mr structs.
>
> This patch makes the flow more straightforward by having
> mlx5_vdpa_create_mr return a new mr which will update the old mr (if
> any). The old mr will be deleted and unlinked from mvdev.
>
> This change paves the way for adding mrs for different ASIDs.
>
> The initialized bool is no longer needed as mr is now a pointer in the
> mlx5_vdpa_dev struct which will be NULL when not initialized.
>
> Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> ---

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


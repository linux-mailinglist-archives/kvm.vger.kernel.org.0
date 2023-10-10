Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB5C7BF2F4
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 08:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442217AbjJJG06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 02:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442156AbjJJG04 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 02:26:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A2597
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 23:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696919169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZXgJjAltwNNXgE6CpFrMVez2TIFFxTWTGd+YncZ0BYc=;
        b=ecNRZ8R6iyfKD4qhUtqknGJhf+55GYgJoVcgxqfbO5BPp0wLSFLZX5QVxGsCVGOajEdGmM
        I9Ne6hvJ6GVK0sP8slcyeciGGSy0nS3T8omdG8i0RZakC4hB1/KCjr+quK7NOze9tlAiOh
        a1NjK5QxyxGjL+fUaQSgsjRrLd1tlcQ=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-4eu6OcHuMfC-v3c5NynZxA-1; Tue, 10 Oct 2023 02:26:07 -0400
X-MC-Unique: 4eu6OcHuMfC-v3c5NynZxA-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5041a779c75so4600133e87.2
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 23:26:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696919165; x=1697523965;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZXgJjAltwNNXgE6CpFrMVez2TIFFxTWTGd+YncZ0BYc=;
        b=tlvM3XX7Il3z4suzutS1dhe+dsnnq45knHpIzoQ0PWL7KPRyqcnvPhWXdByqTHLxtv
         hCCpf2io/16ktNvXa2lm36y38cwlXZPMjo+3X33IRSaAPCkZU+B8VK/wUxhP4rm7r5m6
         oEQjQK1yc+W5Hq0TCGueznQ+xEmBqrzCRqSxflheATiAKPykzo7SqV9gDYD+wur33t+7
         1s0esKud52mKVVYBSh+EfhP7ZCkag4W5Tm7QxnDsfN5Z2OtvgfSiFV4CagyPUSNmMYcc
         JcYZVSYLAQT8O2llQFYfhf56eclnQt5gomXCFQu/Zon1kAglHK2Lgqxj/svfX6t1a8eX
         hyTw==
X-Gm-Message-State: AOJu0YyNL3+fotNF1Qsu0pRvpXez8kcdaKfSQuho/tUNBOhA0DVmU9Ov
        TXppVL8Lx3VCrmfHF4blV/fQM5KqiT9BOBNcbV6tZi9OMTsq/Mxj4PqzZWt5cffVWDfbTE20Wkw
        339XwhuIhjrynmzQz4UpZheiXYR7/
X-Received: by 2002:ac2:5e2c:0:b0:500:9524:f733 with SMTP id o12-20020ac25e2c000000b005009524f733mr11638591lfg.20.1696919165639;
        Mon, 09 Oct 2023 23:26:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTRfSc/Dwktp9YhC8aXUxGnki2o7zlWGkxqIyChOD0GhfDblxBz/lw7GvevY0oxSJY788QjGmeYKUsCUmt5sc=
X-Received: by 2002:ac2:5e2c:0:b0:500:9524:f733 with SMTP id
 o12-20020ac25e2c000000b005009524f733mr11638574lfg.20.1696919165315; Mon, 09
 Oct 2023 23:26:05 -0700 (PDT)
MIME-Version: 1.0
References: <20231009112401.1060447-1-dtatulea@nvidia.com> <20231009112401.1060447-12-dtatulea@nvidia.com>
In-Reply-To: <20231009112401.1060447-12-dtatulea@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 10 Oct 2023 14:25:54 +0800
Message-ID: <CACGkMEt6gQCBJNZzc-tia6YkY7z7-zF4Qc2njixVaCZMfohvpw@mail.gmail.com>
Subject: Re: [PATCH vhost v3 11/16] vdpa/mlx5: Move mr mutex out of mr struct
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
> The mutex is named like it is supposed to protect only the mkey but in
> reality it is a global lock for all mr resources.
>
> Shift the mutex to it's rightful location (struct mlx5_vdpa_dev) and
> give it a more appropriate name.
>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


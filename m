Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F427BF2EE
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 08:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442241AbjJJGZZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 02:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442222AbjJJGZY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 02:25:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBFF9E
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 23:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696919082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1AqkLrzrIXxwvm4PGZ1aUIreaVgNNNZ9t0/4h1i7AZY=;
        b=gyuIJh7Ynsm+LC47NQjSeA0YubCjOivp53HQwvWofwTP4aOdUOLPMohBfYAIpg0bwi7zK+
        Z/VK5RGuf8z6wdneFtWaRUkNooJqtiNUXmva1Q2l9W4F/9pS5PK9haNScIIUJ2dHX8ZOJ8
        d9e1V6lkh/bF+PPGmPG/UxfoHij8TDc=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-AS0Gnl3qOGaMjKAQYta_mg-1; Tue, 10 Oct 2023 02:24:41 -0400
X-MC-Unique: AS0Gnl3qOGaMjKAQYta_mg-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5041a72d2edso4679833e87.1
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 23:24:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696919080; x=1697523880;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1AqkLrzrIXxwvm4PGZ1aUIreaVgNNNZ9t0/4h1i7AZY=;
        b=To3npGK+/KGVVAgiUkV6oi8QAxeGbYW7Wh9SAryZ+itEjq5HFu52AY2djmBA1l3XUS
         eRTOIndzTrv6wnVfu4etb55hpsjnClTAWDZWazjCBO/CbKIIFvrlbmkqeK+NMJrA4PDK
         9OOczDnQVYPcnzflUr+JgplpkED2C6QVdQUH4E0IGkQFjmqS1yUnz9EhbPp++bXhqGcM
         CznCNDhpgFAS/9tZtNLzFGJRjzMRmDmOlLsUKHH6CtPg/tcuDYHhvKt4jPZK+daWgJOg
         a7Ff1JPupzLVbF7WFloIAPhG4Jcsped3X81f0ck91vY3/JbcMmXEhQ4sto/AxHXaDi5T
         lTjQ==
X-Gm-Message-State: AOJu0YwhMScu8NqDLwD8o7jgROjPx2a5kYJZbfaisrQiYWwBIPBZYirV
        F9U0Y4jAbj7MznH0PpknE2PTI62TEsqrieMgnnZyeJNRYtP4Jb3y88/+l9T8Wo0tFhifM4wUNQD
        4aO3HDdM7Wi4JRFVcZx+mYY5beUzy
X-Received: by 2002:a19:f015:0:b0:500:d970:6541 with SMTP id p21-20020a19f015000000b00500d9706541mr13782370lfc.39.1696919079960;
        Mon, 09 Oct 2023 23:24:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE7xUE6pgdBc/7IGhtXyNcrZjmsd0aJhTSJHQ75/95fWLdH7kgG7RJO/mGmbpq6jQLfRM7uFrYPEqqarKGGcNc=
X-Received: by 2002:a19:f015:0:b0:500:d970:6541 with SMTP id
 p21-20020a19f015000000b00500d9706541mr13782360lfc.39.1696919079631; Mon, 09
 Oct 2023 23:24:39 -0700 (PDT)
MIME-Version: 1.0
References: <20231009112401.1060447-1-dtatulea@nvidia.com> <20231009112401.1060447-11-dtatulea@nvidia.com>
In-Reply-To: <20231009112401.1060447-11-dtatulea@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 10 Oct 2023 14:24:28 +0800
Message-ID: <CACGkMEuMnx0s6t-8FhT67Bd3-RYnZkFWUE+SfY2VByy0GbynAA@mail.gmail.com>
Subject: Re: [PATCH vhost v3 10/16] vdpa/mlx5: Allow creation/deletion of any
 given mr struct
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
> This patch adapts the mr creation/deletion code to be able to work with
> any given mr struct pointer. All the APIs are adapted to take an extra
> parameter for the mr.
>
> mlx5_vdpa_create/delete_mr doesn't need a ASID parameter anymore. The
> check is done in the caller instead (mlx5_set_map).
>
> This change is needed for a followup patch which will introduce an
> additional mr for the vq descriptor data.
>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


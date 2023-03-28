Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 891FF6CB939
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 10:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbjC1IVD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 04:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbjC1IU7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 04:20:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC673C3B
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 01:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679991612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q3X0O+/TM7LVotJgrmc2xoQ/T0kA0UQLhsWOW/x515A=;
        b=RzcuhHor46+fs9wiO9GR7qynLKoFSYx6Gf33Y5qrck2xPn5bhkBPwLouM6p4DxViUEGEi2
        EHXmm9K2/hAv8nQVr8JdbDcsofJiarvibfgdjasHMQ5FpLuo2O5n6ZsuVp7EkQhf6Alcql
        t3wUp1ki5vjaNlEUxE1Ln7kW9WjsdJM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-5PtWr-hHPrmLubb81TNB4g-1; Tue, 28 Mar 2023 04:20:11 -0400
X-MC-Unique: 5PtWr-hHPrmLubb81TNB4g-1
Received: by mail-qt1-f199.google.com with SMTP id v10-20020a05622a130a00b003e4ee70e001so1720103qtk.6
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 01:20:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679991611;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q3X0O+/TM7LVotJgrmc2xoQ/T0kA0UQLhsWOW/x515A=;
        b=1t4l0B3GFF0nBZsw0S/aT4lHui0fMPzc9NsOSq9bk1TPsh6O2bNefQbkQ0gWaapT6+
         YWNRaX5SybDe3pU7WubbeP+vr3H6W7YpXAJeSlwHCclRGGhNyHdSWLgK6plqBbYVGDZh
         yU64oNNXYsJdAR1HgQI8GUlntxEGNZ/kt5W/znUIuWhxlfID2lSEGD/wvfXyWe85J9g7
         D2CxdXvM1Ife2Yf1z9MI/lwKe0sxjZArO602TgrDGGb2O4VJ4Ml4nAAMp7lm8nqdIV13
         n9Aj1L/g9nJ5YQEd5c4+pFXx9NE6DV6aXuZF94wT+9sWT3Tod5lI+576OWnREvnQrFpk
         k2yw==
X-Gm-Message-State: AAQBX9fZglqNdJgKHaaRum8gtwjODVOANq0Khelju9mXAwwxyHSsjA36
        /X49z6iiG9swCcFVUQIq5IXa6wIqQYl0k/eKe4h5NsLFfR4Mhpk8D0h6aEYFrp3TTFJZxS9Ofrm
        joIq4+SFmGs61
X-Received: by 2002:a05:622a:118a:b0:3e4:dcb4:162 with SMTP id m10-20020a05622a118a00b003e4dcb40162mr17628916qtk.4.1679991610933;
        Tue, 28 Mar 2023 01:20:10 -0700 (PDT)
X-Google-Smtp-Source: AKy350bNpzeZ7gjbtIL2Ka8dMo1Bzn5V8O4UfVAoHsG5EFh/3BhzXlyah+r/S5EZ4D3ccfOazp/h+A==
X-Received: by 2002:a05:622a:118a:b0:3e4:dcb4:162 with SMTP id m10-20020a05622a118a00b003e4dcb40162mr17628888qtk.4.1679991610700;
        Tue, 28 Mar 2023 01:20:10 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id 4-20020a05620a048400b007468bf8362esm11708565qkr.66.2023.03.28.01.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 01:20:09 -0700 (PDT)
Date:   Tue, 28 Mar 2023 10:20:01 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v4 1/3] vsock: support sockmap
Message-ID: <6eyspnma2esx4nzi2kszxkbuvh3xjb2g4nuhvng6tkvtp3whn6@hpyehyt6imdn>
References: <20230327-vsock-sockmap-v4-0-c62b7cd92a85@bytedance.com>
 <20230327-vsock-sockmap-v4-1-c62b7cd92a85@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230327-vsock-sockmap-v4-1-c62b7cd92a85@bytedance.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 07:11:51PM +0000, Bobby Eshleman wrote:
>This patch adds sockmap support for vsock sockets. It is intended to be
>usable by all transports, but only the virtio and loopback transports
>are implemented.
>
>SOCK_STREAM, SOCK_DGRAM, and SOCK_SEQPACKET are all supported.
>
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>Acked-by: Michael S. Tsirkin <mst@redhat.com>
>---
> drivers/vhost/vsock.c                   |   1 +
> include/linux/virtio_vsock.h            |   1 +
> include/net/af_vsock.h                  |  17 ++++
> net/vmw_vsock/Makefile                  |   1 +
> net/vmw_vsock/af_vsock.c                |  64 ++++++++++--
> net/vmw_vsock/virtio_transport.c        |   2 +
> net/vmw_vsock/virtio_transport_common.c |  25 +++++
> net/vmw_vsock/vsock_bpf.c               | 174 ++++++++++++++++++++++++++++++++
> net/vmw_vsock/vsock_loopback.c          |   2 +
> 9 files changed, 281 insertions(+), 6 deletions(-)

LGTM!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano


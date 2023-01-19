Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10E446735F3
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 11:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjASKps (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 05:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbjASKp1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 05:45:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35D623134
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 02:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674125070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A+rsSgztQ7EWmwAvYLqBC5Ld6bcZTyulRlKIF/tHgxw=;
        b=RZut+H/Cn1RJskBme2l5ESMEJ92FVRb9UvOUWuIz5s9B8PueNwAQXP6EobVW1txnhujpms
        bKcAY8YTPSNqocD4jb995KihBc1pLTcMEtQXURL8JMVBC760AyugY+FSa8bT7AUfMp6CZP
        yESnqGBOBmi4fhlmvqHZ8PRygolYFAM=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-517-iQLxF0y4Pbe8U_xYzyZwaQ-1; Thu, 19 Jan 2023 05:44:29 -0500
X-MC-Unique: iQLxF0y4Pbe8U_xYzyZwaQ-1
Received: by mail-qv1-f71.google.com with SMTP id x6-20020a0cc506000000b005349c8b39d6so798167qvi.2
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 02:44:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A+rsSgztQ7EWmwAvYLqBC5Ld6bcZTyulRlKIF/tHgxw=;
        b=WI99Q3D8NFYzd012QyoGauL9kk26f+I4zg8qlSAk3zrV5p7F9xqiCvZGDWkt6kTNKR
         bngTtGHbhDahIUA2/x8Zo9K11hosCRdiVTuoRhZ6ZTEOvaDo6yeJ4GYiwybgdfTw4i4X
         OXL7FoDdnrdRMwKTBIg+6KhENxTDl79GyJ1FIrvZgstzvM8Ob4Fu7wAabpdZkYoV7L49
         cp9MeYtfb3LG2N8aHPvEXyRYuEI+YfWMj8t8zoqgLQasi2+oeknzx5+10ESaHnV6WFvr
         obnKHE3N2iG3oHmN9idX13ZsJqpp6KSVVJQf++ww7CbN5UgwwWbUhJ/CFzErGNLSG378
         8qag==
X-Gm-Message-State: AFqh2kpcJJc9gWJOk83VGyh5bBk2Z3rzTndSq6jsna1sB984yutu1mik
        vGa3vNkuzCYvG98CIG0AzKQsBm3lMnY7X9as/ZCehMB5t27Axg98klCN4Tc+caKtjKHxVuKZNII
        eW2vWygWdiX0U
X-Received: by 2002:ac8:7744:0:b0:3b6:8d60:5592 with SMTP id g4-20020ac87744000000b003b68d605592mr3210973qtu.31.1674125068978;
        Thu, 19 Jan 2023 02:44:28 -0800 (PST)
X-Google-Smtp-Source: AMrXdXt56lwLvt+Kskuqb+X5HjTgsyzo+boetrR2WDxNvxNZ9GSgS9LJR4o6YNIEF845qyhok47Yug==
X-Received: by 2002:ac8:7744:0:b0:3b6:8d60:5592 with SMTP id g4-20020ac87744000000b003b68d605592mr3210954qtu.31.1674125068722;
        Thu, 19 Jan 2023 02:44:28 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-245.retail.telecomitalia.it. [82.57.51.245])
        by smtp.gmail.com with ESMTPSA id u12-20020a05622a198c00b003ade7d4ad7asm15109712qtc.10.2023.01.19.02.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 02:44:28 -0800 (PST)
Date:   Thu, 19 Jan 2023 11:44:20 +0100
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
        linux-kselftest@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH RFC 2/3] selftests/bpf: add vsock to vmtest.sh
Message-ID: <20230119104420.jxooiua5fchw55qa@sgarzare-redhat>
References: <20230118-support-vsock-sockmap-connectible-v1-0-d47e6294827b@bytedance.com>
 <20230118-support-vsock-sockmap-connectible-v1-2-d47e6294827b@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230118-support-vsock-sockmap-connectible-v1-2-d47e6294827b@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 18, 2023 at 12:27:40PM -0800, Bobby Eshleman wrote:
>Add the ability to use vsock in the vmtest.sh script and
>the test kernel config.
>
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>---
> tools/testing/selftests/bpf/config.x86_64 | 4 ++++
> tools/testing/selftests/bpf/vmtest.sh     | 1 +
> 2 files changed, 5 insertions(+)
>
>diff --git a/tools/testing/selftests/bpf/config.x86_64 b/tools/testing/selftests/bpf/config.x86_64
>index dd97d61d325ca..db5e6b9a91711 100644
>--- a/tools/testing/selftests/bpf/config.x86_64
>+++ b/tools/testing/selftests/bpf/config.x86_64
>@@ -234,7 +234,11 @@ CONFIG_VIRTIO_BLK=y
> CONFIG_VIRTIO_CONSOLE=y
> CONFIG_VIRTIO_NET=y
> CONFIG_VIRTIO_PCI=y
>+CONFIG_VIRTIO_VSOCKETS=y
>+CONFIG_VIRTIO_VSOCKETS_COMMON=y
> CONFIG_VLAN_8021Q=y
>+CONFIG_VSOCKETS=y
>+CONFIG_VSOCKETS_LOOPBACK=y
> CONFIG_X86_ACPI_CPUFREQ=y
> CONFIG_X86_CPUID=y
> CONFIG_X86_MSR=y
>diff --git a/tools/testing/selftests/bpf/vmtest.sh b/tools/testing/selftests/bpf/vmtest.sh
>index 316a56d680f25..aad27ffd4ec68 100755
>--- a/tools/testing/selftests/bpf/vmtest.sh
>+++ b/tools/testing/selftests/bpf/vmtest.sh
>@@ -250,6 +250,7 @@ EOF
> 		-enable-kvm \
> 		-m 4G \
> 		-drive file="${rootfs_img}",format=raw,index=1,media=disk,if=virtio,cache=none \
>+		-device vhost-vsock-pci,guest-cid=1234 \

I'm not sure if this will work with qemu-system-s390x and 
qemu-system-aarch64.

Maybe the "virt" machine of qemu-system-aarch64 supports PCI, but IIRC 
s390x doesn't support it and we should use the vhost-vsock-ccw device.

In addition, we are changing only config.x86_64, so maybe we should add 
the vhost-vsock-pci device only for x86_64 (maybe in the QEMU_FLAGS or a 
new VSOCK_DEV variable), and run the tests only for that architecture.

Thanks,
Stefano

> 		-kernel "${kernel_bzimage}" \
> 		-append "root=/dev/vda rw console=${QEMU_CONSOLE}"
> }
>
>-- 
>2.30.2
>


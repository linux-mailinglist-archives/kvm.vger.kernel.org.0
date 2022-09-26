Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01ED95EA93A
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 16:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234402AbiIZOzF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 10:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234095AbiIZOyi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 10:54:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1E274B9C
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 06:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664198517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i7qiiLpBZNt2KOcykqgJFQ/WQh3oxgQ6inHkaKhb85Y=;
        b=Sib5IscLwkCJpCzcQaahJfuUkB+6APQqt7D9cK3QqMhKpRvl9R0sd2E7Vr32vnF54Y6Mqs
        NRsh1h0qhngx7v85HvPJvlk78oWntcR9BUlf5JofTuS6g/6SPwhMztaV/z4rB94eNtXErY
        w+xF1y9lcBIFY9wTR68yon9xlbaS+Yw=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-1-kEi2d18OOByS0MT1g4O5-Q-1; Mon, 26 Sep 2022 09:21:56 -0400
X-MC-Unique: kEi2d18OOByS0MT1g4O5-Q-1
Received: by mail-qv1-f72.google.com with SMTP id k10-20020ad4450a000000b004aa116eebe8so3774934qvu.5
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 06:21:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=i7qiiLpBZNt2KOcykqgJFQ/WQh3oxgQ6inHkaKhb85Y=;
        b=ifqlhSSyvap7qd+N4EpPSo6qdSA2RlBnF9EdVqQib7g7Cntss+zzb+CNdy5YGpIwQ+
         +AzTwawHeV2GJbjE79kvhvGZJR/2NgCmGORt9PNsld4Q+MhT1FybI4FlbnD219VRULSz
         Sb2XK70UuknCE7C8jOmK2s4ef2yJ29M4aSbmkvwMIxLs0tLmSWdPXHIT4FgmRyIjk1TM
         IjA1h8niM5hK69Om/gYAIAzim3GnlRUNsL8ANxqFVE1uyMiXFbluo5X/DSm9p2PmV9fz
         3np9dLMKRsro425P1OGEjcZbxi5EU9z81IJgFocYfFyvqZC+hX6tlxnQZWfmNgMjmEqO
         cuow==
X-Gm-Message-State: ACrzQf1Aj4LV1ro27CgqoUo1DyPhBheHyilNVrMDeCd95OwMOnW9sNX8
        fVxUulH/s50vuEw/PNsDm5VPGbc0mfucG/1HvbiMCM0VbTWlgZQMH/f18h3JWn8eTcdsxIoY8a0
        FMrs4XWrG8dyz
X-Received: by 2002:a05:620a:424c:b0:6be:78d5:ec73 with SMTP id w12-20020a05620a424c00b006be78d5ec73mr13912688qko.579.1664198516081;
        Mon, 26 Sep 2022 06:21:56 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7NrkIGne8y/GZLW9JHXe3yOUbh+JzzdSUUNw9PrzRz4UIl+C1M5V42BCPhQxA5Z5E+K1+G3w==
X-Received: by 2002:a05:620a:424c:b0:6be:78d5:ec73 with SMTP id w12-20020a05620a424c00b006be78d5ec73mr13912666qko.579.1664198515834;
        Mon, 26 Sep 2022 06:21:55 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-222.retail.telecomitalia.it. [79.46.200.222])
        by smtp.gmail.com with ESMTPSA id t14-20020a05620a450e00b006cbcdc6efedsm11986040qkp.41.2022.09.26.06.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 06:21:55 -0700 (PDT)
Date:   Mon, 26 Sep 2022 15:21:45 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@gmail.com>
Cc:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH 2/6] vsock: return errors other than -ENOMEM to socket
Message-ID: <20220926132145.utv2rzswhejhxrvb@sgarzare-redhat>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <d81818b868216c774613dd03641fcfe63cc55a45.1660362668.git.bobby.eshleman@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d81818b868216c774613dd03641fcfe63cc55a45.1660362668.git.bobby.eshleman@bytedance.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 15, 2022 at 10:56:05AM -0700, Bobby Eshleman wrote:
>This commit allows vsock implementations to return errors
>to the socket layer other than -ENOMEM. One immediate effect
>of this is that upon the sk_sndbuf threshold being reached -EAGAIN
>will be returned and userspace may throttle appropriately.
>
>Resultingly, a known issue with uperf is resolved[1].
>
>Additionally, to preserve legacy behavior for non-virtio
>implementations, hyperv/vmci force errors to be -ENOMEM so that behavior
>is unchanged.
>
>[1]: https://gitlab.com/vsock/vsock/-/issues/1
>
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>---
> include/linux/virtio_vsock.h            | 3 +++
> net/vmw_vsock/af_vsock.c                | 3 ++-
> net/vmw_vsock/hyperv_transport.c        | 2 +-
> net/vmw_vsock/virtio_transport_common.c | 3 ---
> net/vmw_vsock/vmci_transport.c          | 9 ++++++++-
> 5 files changed, 14 insertions(+), 6 deletions(-)
>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index 17ed01466875..9a37eddbb87a 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -8,6 +8,9 @@
> #include <net/sock.h>
> #include <net/af_vsock.h>
>
>+/* Threshold for detecting small packets to copy */
>+#define GOOD_COPY_LEN  128
>+

This change seems unrelated.

Please move it in the patch where you need this.
Maybe it's better to add a prefix if we move it in an header file (e.g.  
VIRTIO_VSOCK_...).

Thanks,
Stefano

> enum virtio_vsock_metadata_flags {
> 	VIRTIO_VSOCK_METADATA_FLAGS_REPLY		= BIT(0),
> 	VIRTIO_VSOCK_METADATA_FLAGS_TAP_DELIVERED	= BIT(1),
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index e348b2d09eac..1893f8aafa48 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1844,8 +1844,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
> 			written = transport->stream_enqueue(vsk,
> 					msg, len - total_written);
> 		}
>+
> 		if (written < 0) {
>-			err = -ENOMEM;
>+			err = written;
> 			goto out_err;
> 		}
>
>diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
>index fd98229e3db3..e99aea571f6f 100644
>--- a/net/vmw_vsock/hyperv_transport.c
>+++ b/net/vmw_vsock/hyperv_transport.c
>@@ -687,7 +687,7 @@ static ssize_t hvs_stream_enqueue(struct vsock_sock *vsk, struct msghdr *msg,
> 	if (bytes_written)
> 		ret = bytes_written;
> 	kfree(send_buf);
>-	return ret;
>+	return ret < 0 ? -ENOMEM : ret;
> }
>
> static s64 hvs_stream_has_data(struct vsock_sock *vsk)
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 920578597bb9..d5780599fe93 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -23,9 +23,6 @@
> /* How long to wait for graceful shutdown of a connection */
> #define VSOCK_CLOSE_TIMEOUT (8 * HZ)
>
>-/* Threshold for detecting small packets to copy */
>-#define GOOD_COPY_LEN  128
>-
> static const struct virtio_transport *
> virtio_transport_get_ops(struct vsock_sock *vsk)
> {
>diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
>index b14f0ed7427b..c927a90dc859 100644
>--- a/net/vmw_vsock/vmci_transport.c
>+++ b/net/vmw_vsock/vmci_transport.c
>@@ -1838,7 +1838,14 @@ static ssize_t vmci_transport_stream_enqueue(
> 	struct msghdr *msg,
> 	size_t len)
> {
>-	return vmci_qpair_enquev(vmci_trans(vsk)->qpair, msg, len, 0);
>+	int err;
>+
>+	err = vmci_qpair_enquev(vmci_trans(vsk)->qpair, msg, len, 0);
>+
>+	if (err < 0)
>+		err = -ENOMEM;
>+
>+	return err;
> }
>
> static s64 vmci_transport_stream_has_data(struct vsock_sock *vsk)
>-- 
>2.35.1
>


Return-Path: <kvm+bounces-58880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B3D3BA48EC
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 18:10:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C03B385E3F
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 16:10:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 901B923D297;
	Fri, 26 Sep 2025 16:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gtaFTZqg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D3E238D5A
	for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 16:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758903016; cv=none; b=JDp4n0t1T9Q1mj3A9wJ3eT5fSD0o6rvwEykvIHCv/J9WzaHXbo9OD3CkE/WmfPysyo+6tf8xEOtAw1NC0BKe5b5jM80Vels1ht4BcMBQ+bLQXu5EDNTT2Mb/Pvw/nB8t37OT0ab8ZhiqT3VtbjWN55AMwB6rSfn9t+C4gzqEOdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758903016; c=relaxed/simple;
	bh=IbqNZnQ6qBOiYNkLFSV9f/t+U4wjpwCDpH/C2sL850Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JswRxeqZNQJmfnuVuYLGkPVzp6+rXjb+VL6uJOXdh2PYefik0y6Fu8vDFZ0I8Ha9doee30oMfH6tH5spAttffgx61QnEgG6NhadBW4PwFOwrRSu4KsgwmnjSYrJYoWClZXxLc8FHE46xLDJbpi471DVu0nrftlTOlbhWVxjpN48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gtaFTZqg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758903013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Sc05YyUFs8eev4smgakT4g9mLlt8ucAW7NryFeJuHk=;
	b=gtaFTZqgbls9FgQUZbDy20ea8TUS2u8nDrLk4z43qan+nXcVAEMNO/5fBAdZKjzy/wcoWg
	r0eGdy4DaF8sO26w3qzUVKCRiF2pOGSev2pOCTkDaJZaUM3OmoDHZx3yoXoAhEAPA40A7a
	c7pEobZpLzJVgookvOMXl6gTPV27pCc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-134-espsg52IPV6LnSc4UpBSRg-1; Fri, 26 Sep 2025 12:10:11 -0400
X-MC-Unique: espsg52IPV6LnSc4UpBSRg-1
X-Mimecast-MFC-AGG-ID: espsg52IPV6LnSc4UpBSRg_1758903008
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45de27bf706so13367885e9.0
        for <kvm@vger.kernel.org>; Fri, 26 Sep 2025 09:10:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758903007; x=1759507807;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Sc05YyUFs8eev4smgakT4g9mLlt8ucAW7NryFeJuHk=;
        b=tJiuGOh6mqPyJG7ea2A1bTlHCRytw1IeUHOyQeCPpR9hH3MxXVtPH9jPOy5IfIUS3L
         iS8OBGo2ZiPda8S+Pw04QP6bYq8ATjNabFHpO7tIrwPB/TQ76IZVb1cKhIfxKhkAiGHB
         vQsgPNGUirqs3Gil8n8RMGC2M98yhdC6ok3eMCIk2/TymXkYAFbyca4eZ4xUB8AeuYp4
         a7lDOXvp75//08/geZqi3dJpNzk/Ru2/j1DG6zzn5Et2Bb5vhbwTEA5U+7NO7fgwESkn
         57vQHV39PfkeMGwrQu5TAgW1xJH7g/HeGxGk2KTDkQIb+7qx0gXzqW6Dtxr8AaNeViYR
         0v7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXHxBSKRXph3ejBudy5EvYm9lH/3qHXepOycgS47BazDan7N5sVoEikjFn0O9n8UcoakbI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIniPWdxdByx7UzeKYfqyG1zT4nL6olaP47WERXpbUgIEKlwIf
	l22zdQX0KBqWy+cnXkNA+URUDJs5SMSC657Psh0ylCwn1zXeBu4RELcKMH624HyN625NBp6hSnJ
	gl+VuxueDY0UYT6UVtqXLTPoElWmlAotybOJFoULxn2HAx5VhBUHPdA==
X-Gm-Gg: ASbGncvbRBIz5WalePi150FLdT5V5fTM0+NaxpNPm/mjseErdWNjB2weG8XiqAHzoYB
	1yhePWA9wqcK25EOQd4pvvmsb8gpQ9r0nmZ/PLGfim8r5iWnSY5GKCiKdZpYsJMqqXCBFa+KMTx
	b5thW1rM3iakVRJCKI6cZRRY8c/7IRHW0U+L0yt/q+GZ8VV+vNuu4cfjRwIo06MInTWrqBvQZrr
	dAYewYlQYGHz0bTvepDiFZiGAu7lu4W5dMvq598Vj6iNiUR9lc/gO6CGLTGfO/uUic6R2pVY6tq
	1B7JCk+HklPvK1Ox/md8YDse1ilUlw/AbkVr3KX4
X-Received: by 2002:a05:6000:2c05:b0:3fb:6f9d:2704 with SMTP id ffacd0b85a97d-40e46ad02e6mr7131279f8f.28.1758903007489;
        Fri, 26 Sep 2025 09:10:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFViVdCy79A3oTvkyW7XNCB5TCgJypl+aC6OQKJjOod/Xo/GpsRVtayfxUD8jMTLP47LqpK2g==
X-Received: by 2002:a05:6000:2c05:b0:3fb:6f9d:2704 with SMTP id ffacd0b85a97d-40e46ad02e6mr7131237f8f.28.1758903006949;
        Fri, 26 Sep 2025 09:10:06 -0700 (PDT)
Received: from sgarzare-redhat ([5.77.94.69])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb72fb6b7sm8192690f8f.2.2025.09.26.09.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 09:10:06 -0700 (PDT)
Date: Fri, 26 Sep 2025 18:09:51 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, berrange@redhat.com, Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v6 1/9] vsock: a per-net vsock NS mode state
Message-ID: <iqkgyjncszycflptyrmnwfn7bvrkjt5poig5pnlwbjf3rvdka4@ermxt6v6nvqs>
References: <20250916-vsock-vmtest-v6-0-064d2eb0c89d@meta.com>
 <20250916-vsock-vmtest-v6-1-064d2eb0c89d@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250916-vsock-vmtest-v6-1-064d2eb0c89d@meta.com>

On Tue, Sep 16, 2025 at 04:43:45PM -0700, Bobby Eshleman wrote:
>From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>Add the per-net vsock NS mode state. This only adds the structure for
>holding the mode and some of the functions for setting/getting and
>checking the mode, but does not integrate the functionality yet.
>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>
>---
>Changes in v6:
>- add orig_net_mode to store mode at creation time which will be used to
>  avoid breakage when namespace changes mode during socket/VM lifespan
>
>Changes in v5:
>- use /proc/sys/net/vsock/ns_mode instead of /proc/net/vsock_ns_mode
>- change from net->vsock.ns_mode to net->vsock.mode
>- change vsock_net_set_mode() to vsock_net_write_mode()
>- vsock_net_write_mode() returns bool for write success to avoid
>  need to use vsock_net_mode_can_set()
>- remove vsock_net_mode_can_set()
>---
> MAINTAINERS                 |  1 +
> include/net/af_vsock.h      | 55 +++++++++++++++++++++++++++++++++++++++++++++
> include/net/net_namespace.h |  4 ++++
> include/net/netns/vsock.h   | 20 +++++++++++++++++
> 4 files changed, 80 insertions(+)
>
>diff --git a/MAINTAINERS b/MAINTAINERS
>index 47bc35743f22..bc53c67e0926 100644
>--- a/MAINTAINERS
>+++ b/MAINTAINERS
>@@ -26634,6 +26634,7 @@ L:	netdev@vger.kernel.org
> S:	Maintained
> F:	drivers/vhost/vsock.c
> F:	include/linux/virtio_vsock.h
>+F:	include/net/netns/vsock.h
> F:	include/uapi/linux/virtio_vsock.h
> F:	net/vmw_vsock/virtio_transport.c
> F:	net/vmw_vsock/virtio_transport_common.c
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index d40e978126e3..2857e97699de 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -10,6 +10,7 @@
>
> #include <linux/kernel.h>
> #include <linux/workqueue.h>
>+#include <net/netns/vsock.h>
> #include <net/sock.h>
> #include <uapi/linux/vm_sockets.h>
>
>@@ -65,6 +66,7 @@ struct vsock_sock {
> 	u32 peer_shutdown;
> 	bool sent_request;
> 	bool ignore_connecting_rst;
>+	enum vsock_net_mode orig_net_mode;

Why `orig_` prefix?

Maybe I need to review all the series, but it's a bit confusing for now.
I guess it's related to the new behaviour to not change the mode of 
already created sockets (which I like), but IMHO this variable prefix is 
confusing.It seems we will have another field with the "actual_" mode, 
but if it's immutable, I'd avoid that prefix.

>
> 	/* Protected by lock_sock(sk) */
> 	u64 buffer_size;
>@@ -256,4 +258,57 @@ static inline bool vsock_msgzerocopy_allow(const struct vsock_transport *t)
> {
> 	return t->msgzerocopy_allow && t->msgzerocopy_allow();
> }
>+
>+static inline enum vsock_net_mode vsock_net_mode(struct net *net)
>+{
>+	enum vsock_net_mode ret;
>+
>+	spin_lock_bh(&net->vsock.lock);
>+	ret = net->vsock.mode;
>+	spin_unlock_bh(&net->vsock.lock);
>+	return ret;
>+}
>+
>+static inline bool vsock_net_write_mode(struct net *net, u8 mode)
>+{
>+	bool ret;
>+
>+	spin_lock_bh(&net->vsock.lock);
>+
>+	if (net->vsock.written) {
>+		ret = false;
>+		goto skip;
>+	}
>+
>+	net->vsock.mode = mode;
>+	net->vsock.written = true;
>+	ret = true;
>+
>+skip:
>+	spin_unlock_bh(&net->vsock.lock);
>+	return ret;
>+}
>+
>+/* Return true if vsock_sock passes the mode rules for a given net and
>+ * orig_net_mode. Otherwise, return false.
>+ *
>+ * net is the current net namespace of the object being checked. orig_net_mode
>+ * is the mode of net when the object was created.

`orig_net_mode` is also explained in the next paragraph, should we 
remove from here?

>+ *
>+ * orig_net_mode is the mode of arg 'net' at the time of creation for the
>+ * object being checked. For example, if searching for a vsock_sock then
>+ * orig_net_mode is arg net's mode at the time the vsock_sock was created.
>+ *
>+ * Read more about modes in the comment header of net/vmw_vsock/af_vsock.c.
>+ */
>+static inline bool vsock_net_check_mode(struct vsock_sock *vsk, struct net *net,
>+					enum vsock_net_mode orig_net_mode)
>+{
>+	struct net *vsk_net = sock_net(sk_vsock(vsk));
>+
>+	if (net_eq(vsk_net, net))
>+		return true;
>+
>+	return orig_net_mode == VSOCK_NET_MODE_GLOBAL && vsk->orig_net_mode == VSOCK_NET_MODE_GLOBAL;

nit: I'd rewrite in this way, just because it seems easy to read to me, 
but again not strong opinion, this is fine:

	return orig_net_mode == VSOCK_NET_MODE_GLOBAL &&
	       orig_net_mode == vsk->orig_net_mode;

>+}
> #endif /* __AF_VSOCK_H__ */
>diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
>index 025a7574b275..005c0da4fb62 100644
>--- a/include/net/net_namespace.h
>+++ b/include/net/net_namespace.h
>@@ -37,6 +37,7 @@
> #include <net/netns/smc.h>
> #include <net/netns/bpf.h>
> #include <net/netns/mctp.h>
>+#include <net/netns/vsock.h>
> #include <net/net_trackers.h>
> #include <linux/ns_common.h>
> #include <linux/idr.h>
>@@ -196,6 +197,9 @@ struct net {
> 	/* Move to a better place when the config guard is removed. */
> 	struct mutex		rtnl_mutex;
> #endif
>+#if IS_ENABLED(CONFIG_VSOCKETS)
>+	struct netns_vsock	vsock;
>+#endif
> } __randomize_layout;
>
> #include <linux/seq_file_net.h>
>diff --git a/include/net/netns/vsock.h b/include/net/netns/vsock.h
>new file mode 100644
>index 000000000000..d4593c0b8dc4
>--- /dev/null
>+++ b/include/net/netns/vsock.h
>@@ -0,0 +1,20 @@
>+/* SPDX-License-Identifier: GPL-2.0 */
>+#ifndef __NET_NET_NAMESPACE_VSOCK_H
>+#define __NET_NET_NAMESPACE_VSOCK_H
>+
>+#include <linux/types.h>
>+
>+enum vsock_net_mode {
>+	VSOCK_NET_MODE_GLOBAL,
>+	VSOCK_NET_MODE_LOCAL,
>+};
>+
>+struct netns_vsock {
>+	struct ctl_table_header *vsock_hdr;

sysctl_header, or sysctl_hdr, or sysctl_ctl ?
I'd remove `vsock_` prefix and make more clear its used for sysctl.

>+	spinlock_t lock;
>+
>+	/* protected by lock */
>+	enum vsock_net_mode mode;
>+	bool written;

I would call this `mode_set` or `mode_locked`, I mean with `mode_` 
prefix to make sure we don't need to rename it when we will add new 
fields in the future.

Thanks
Stefano

>+};
>+#endif /* __NET_NET_NAMESPACE_VSOCK_H */
>
>-- 
>2.47.3
>



Return-Path: <kvm+bounces-17616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCE1E8C8861
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 16:48:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F00351C24E44
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 14:48:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 238E473184;
	Fri, 17 May 2024 14:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ixvJ17XS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB05971757;
	Fri, 17 May 2024 14:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715957196; cv=none; b=oU/EF1EfBsZNuvMpDat4g7S1NjGEUeOvDDNbxIQ8OwSDFzQWRSIP7Efmiudab9YzAb+Zcwh8Zm/6EhvLPwwPoaPP6AD1DNGk2Tu7UvJqjBKU5InZA4ilZ2Y3vrWNNUEdjc80BeGjR+yO8yfIdgzKzBsMKHh+bZGBcQX0wmB0Nj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715957196; c=relaxed/simple;
	bh=WnxVwjgYGJtcoPZ87tCxtUxpJqNACgXajD6ezrDCG4I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Eh3ia+mZJJTMNG3+hHLTKvpUQbdfPyuufT5X0vyZSrdtkQjEuGa01fAG55onTh7SmBzRk+1zoWzrt6Za8+HO+w/uoUXGSpx8Yg59A9EQWSkUgBJQNpmvj/XQHgtvcKIklmda87vKGsI3dFPV10eRUrvyqtap3ZMx2YIw4dcEjjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ixvJ17XS; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1eb0e08bfd2so11077705ad.1;
        Fri, 17 May 2024 07:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715957194; x=1716561994; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1E5gdZlICe3lq/gDwWvHR3o2K94KvkxWORr8jEuKK78=;
        b=ixvJ17XSuqQ4El0fKozGFftyw1b7Us6lI6k8Diupf+u7bUCx+/f5FBGwgMvgoRVqCK
         e0itaRRP0i6NZHZG6vsR6ERILlUJw+viW9FTlJtFVgSVlR3L6EBwJ4ZwI/xcsOg6r1f5
         uZZScjg8UA9/AZBftVl+vE1GlQ00feJ2oBv0DwW3Fj6gvKgq553iVFZ6Pa9bQl7IpmBL
         1oinH+cNgYADno6g0WHJ5ChpT0+55e5iczPoU8FgnIzgBwZWiShKFoHIWtwjf7L0KqeL
         WII3+2Vn6nS6WrIB+vHl4mo9jgVuCK8nYiQVaboNmuMoRa3jE0oXHTYEXrBpFz0yAdqv
         IDgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715957194; x=1716561994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1E5gdZlICe3lq/gDwWvHR3o2K94KvkxWORr8jEuKK78=;
        b=bi6plwDmXjOfb9Ln8IQ0k6K5JMvK2/GwhtAgbCJ2+6Ctgqd7+ujEYbADe6PiwAb9AQ
         a656Zr025mOsS0l0HuMrgaoDOiFCERtsZZkGRL8v/+GQg2cIcAyaap120go0cKy4snzb
         2GIlfKiul+2wTYUJqHiru4dF7uakOv+DxnibqV3ktFcJtgnyarqCp8hN2J6lZGABwjoY
         SgLfQJmKnc+WNoRJkK2gjwVYKZfUeA8iMc55YprPC94B8P331ixEh/3GNWyLKuHacMvo
         qbegto55MzRHaG8F3PecNuxM4qMfoptGClo09oTytPY4f+eEjBBee50ywiVBTpzdILBa
         qWyw==
X-Forwarded-Encrypted: i=1; AJvYcCVWlGEET3N/PVtFvgbZkf419Rx5jPekR9UZfypb2acyK7vPQP9FArPcKNYWnacMvBKg72NuzP9pQMu3wvRRodmmTR3H6kt24vv0vZXM6Rvqvx7obHBX+2zQeJY7KdJWcMJpRHRGVkYCMYowSg2s4+ue9it3pfMGQfWS
X-Gm-Message-State: AOJu0YwYnnCt/AtyxXgQ6TYn2cwLHS2/vsdUodCexQKlR5Aq23TL9qBo
	9+GDGKE3OX4Mp49Fi3P/6ZovNL3iU0RkTP57DqNk1f62VLM9tVL5lMd+Jc9zuZo29szv
X-Google-Smtp-Source: AGHT+IGlrB2ABZOfxviKuEq2qAGBP9HT0HFRenQskQ3kOdrAUJQmjATvt0uOz+tRWRqVGbrjhLcsCA==
X-Received: by 2002:a17:902:e889:b0:1f0:9938:d260 with SMTP id d9443c01a7336-1f09938d438mr74524725ad.50.1715957194441;
        Fri, 17 May 2024 07:46:34 -0700 (PDT)
Received: from devant.hz.ali.com ([47.89.83.81])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0c160a1esm158504985ad.279.2024.05.17.07.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 May 2024 07:46:34 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: stefanha@redhat.com,
	sgarzare@redhat.com
Cc: mst@redhat.com,
	davem@davemloft.net,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: [RFC PATCH 5/5] vsock: Add an ioctl request to get all CIDs
Date: Fri, 17 May 2024 22:46:07 +0800
Message-Id: <20240517144607.2595798-6-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240517144607.2595798-1-niuxuewei.nxw@antgroup.com>
References: <20240517144607.2595798-1-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The new request is called `IOCTL_VM_SOCKETS_GET_LOCAL_CIDS`. And the old
one, `IOCTL_VM_SOCKETS_GET_LOCAL_CID` is retained.

For the transport that supports multi-devices:

* `IOCTL_VM_SOCKETS_GET_LOCAL_CID` returns "-1";
* `IOCTL_VM_SOCKETS_GET_LOCAL_CIDS` returns a vector of CIDS. The usage is
shown as following.

```
struct vsock_local_cids local_cids;
if ((ret = ioctl(fd, IOCTL_VM_SOCKETS_GET_LOCAL_CIDS, &local_cids))) {
    perror("failed to get cids");
    exit(1);
}
for (i = 0; i<local_cids.nr; i++) {
    if (i == (local_cids.nr - 1))
        printf("%u", local_cids.data[i]);
    else
        printf("%u,", local_cids.data[i]);
}
```

Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
---
 include/net/af_vsock.h          |  7 +++++++
 include/uapi/linux/vm_sockets.h |  8 ++++++++
 net/vmw_vsock/af_vsock.c        | 19 +++++++++++++++++++
 3 files changed, 34 insertions(+)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 25f7dc3d602d..2febc816e388 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -264,4 +264,11 @@ static inline bool vsock_msgzerocopy_allow(const struct vsock_transport *t)
 {
 	return t->msgzerocopy_allow && t->msgzerocopy_allow();
 }
+
+/**** IOCTL ****/
+/* Type of return value of IOCTL_VM_SOCKETS_GET_LOCAL_CIDS. */
+struct vsock_local_cids {
+	int nr;
+	unsigned int data[MAX_VSOCK_NUM];
+};
 #endif /* __AF_VSOCK_H__ */
diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
index 36ca5023293a..01f73fb7af5a 100644
--- a/include/uapi/linux/vm_sockets.h
+++ b/include/uapi/linux/vm_sockets.h
@@ -195,8 +195,16 @@ struct sockaddr_vm {
 
 #define MAX_VSOCK_NUM 16
 
+/* Return actual context id if the transport not support vsock
+ * multi-devices. Otherwise, return `-1U`.
+ */
+
 #define IOCTL_VM_SOCKETS_GET_LOCAL_CID		_IO(7, 0xb9)
 
+/* Only available in transports that support multiple devices. */
+
+#define IOCTL_VM_SOCKETS_GET_LOCAL_CIDS     _IOR(7, 0xba, struct vsock_local_cids)
+
 /* MSG_ZEROCOPY notifications are encoded in the standard error format,
  * sock_extended_err. See Documentation/networking/msg_zerocopy.rst in
  * kernel source tree for more details.
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 3b34be802bf2..2ea2ff52f15b 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -2454,6 +2454,7 @@ static long vsock_dev_do_ioctl(struct file *filp,
 	u32 __user *p = ptr;
 	u32 cid = VMADDR_CID_ANY;
 	int retval = 0;
+	struct vsock_local_cids local_cids;
 
 	switch (cmd) {
 	case IOCTL_VM_SOCKETS_GET_LOCAL_CID:
@@ -2469,6 +2470,24 @@ static long vsock_dev_do_ioctl(struct file *filp,
 			retval = -EFAULT;
 		break;
 
+	case IOCTL_VM_SOCKETS_GET_LOCAL_CIDS:
+		if (!transport_g2h || !transport_g2h->get_local_cids)
+			goto fault;
+
+		rcu_read_lock();
+		local_cids.nr = transport_g2h->get_local_cids(local_cids.data);
+		rcu_read_unlock();
+
+		if (local_cids.nr < 0 ||
+		    copy_to_user(p, &local_cids, sizeof(local_cids)))
+			goto fault;
+
+		break;
+
+fault:
+		retval = -EFAULT;
+		break;
+
 	default:
 		retval = -ENOIOCTLCMD;
 	}
-- 
2.34.1



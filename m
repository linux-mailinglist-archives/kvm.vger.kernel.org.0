Return-Path: <kvm+bounces-62848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id C9A9BC50CB1
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 07:57:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 74AD1342E88
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 06:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4D362F5A22;
	Wed, 12 Nov 2025 06:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bXjGsGAD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEC02E336E
	for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 06:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762930543; cv=none; b=QlSWOtpEgg3ZrreBtrlkPRIeHwHcw6nrJox6KxHkI0PR1tK9yx2UcXwkGka9CGhY71K/qTXuaPmAZDWbev1R5bLBOLnk+ylWDTJBsgaWw1KEYnuP26vafZm1FUA75CwRI2tlW3mGGkT+yuxyNrg12UkyzKe+TX658cApfYwHXu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762930543; c=relaxed/simple;
	bh=5emprepJCkrosJM8h3ONRAh/VBEaqfFdtQYY3rXLh2g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=E0JXvd4AgkJ6cQMBoTpAml1i4j+fgwKbzkDfmVPWL1gUVSG9TjM3U6T8pxYP9+tU3FW95prhX/MQr3C+3LfyYj0ajfBaQmnpWQED2yAyoqdciM2tWC0/u3DR/5ihjuQfGM9W88Z27AW1AVnM1pSJ9KZzSVQA3gs6LiT8evq4HVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bXjGsGAD; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-ba599137cf7so460076a12.0
        for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 22:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762930538; x=1763535338; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kfQ2Nx6CoFxjU6rBT4tiqTH+6eTbyO5fnFEERoP0vpM=;
        b=bXjGsGADzGCoIedw0cuDsmzCkFavQcBN8SX4Dez5eX+1Hy9nY4dUhBD0opyzTBrhNr
         LRjRpQtCYYbgOP0MTe7t6rvEmFKQiZu5Hczn/4zo4pz2mfQZrXYUQj1k0CifMEksP4vf
         kQofAyVIjfoUKJOyRsQTxAWWOzT3P9IzNPFT4YcEVWgB94eZdEhutn/jBTJj73D/Vzm5
         Tcp15aXGZkMwjkD4ItS1AcdB4Nwprkak+BV0oegH53/A5pUvFG0R/b5YOde/TnvdIpDv
         0uOD5NKRLUfbtbuatI6ZvtjXxbQjtvspHLtuto9r/OTYLToknfbHiNwpsbgKqBSFo9pg
         3jUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762930538; x=1763535338;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kfQ2Nx6CoFxjU6rBT4tiqTH+6eTbyO5fnFEERoP0vpM=;
        b=XI+QDRPulnsuWSe2TKw0xpl5pZXmOIbY4E26a/fKa4ffA8aUdiyEz6ZK4aw6+a3crm
         djcgXYtTBEE1E9eyU1IMc0/48oHvrifp2JKnenMJxeMNfAccRUd1Sm6Bnzkc9HZKfTj5
         diGC3s6QbP9ixQhVvhYRqt9qxOC532qSE4Go2+2Nr9u+P+9IB75R/hy9hrWMgKDGVM55
         98kQ7zoQcPE3Adv/jBGfuQ/oyYxe1lbd86DyoXabwjcbrkxSIFNHr5Tp8Xt6Xdg/g+cf
         zXYbs2cZFGqTZnaYLYVW7AhX+0xzFHYy+lxz/hi95DIfTZHjYYp0mTLLJvMgx+5tABTF
         NkPQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6f/qauzfVrUNqnmSi+dVXrkryXDFe1dNhSfGqlmixmLDJ3erUFV486gMKMf3FYL2HBN0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyW2cbUqdBSF7mhFOAhnmd0l64g3Y5uoNvTcwm+JQioOOdt1hW9
	8pZjdF3iymU+YviFbWQxhZIqxofld8TtoWGTpPQZS/QFv8u6+Vvt05jo
X-Gm-Gg: ASbGncvxRY6OwnucpNLA13mtMUJJl7wqo/tySCoK9lrSzDDA4aODeHSBLRHLB7XJvAd
	isYBmX1sSb9Qmk6voSlaCQRUMLtWbiXgtBfm4UcqDgYPuGQbrmtMCdS0BhY9q5nh7D7j9LcIGpm
	3qZyBIE6trZodpSkTRiki3rEzUaEMOjxF6aw8Ud20HMbzGF+20SGoiVPtVkb77XdQ7zfeRmwV+J
	nUbh3jcbUnKyTo1FpY7qscBNm+y/0w3Ak+ch/LCpT3s30uyGe80G6P74pJUkqkT8MqsHQND9Q0C
	cZNGfsMvcE0kvP+HcxS3DbGzts9W+FNIYHdgFoQeqC9eJeulolV6WW8TbKHlwTb77f6O/XXWWEe
	3UQfAlIOxQHUZ1abYjMzCay0Usw474nUzxRtXUJv4Vt+aKQzxRxZvdMHF+ajFV1iW3NfIWc5L
X-Google-Smtp-Source: AGHT+IF7DfsEqGvimsF/vV7xkPY5hQFPw6KbtZBzdnrAV5tW65XpvT8z84/9DJylmvZPMXLFyKNPwg==
X-Received: by 2002:a17:903:19e3:b0:295:21ac:352b with SMTP id d9443c01a7336-2984ed92f72mr26986205ad.15.1762930538514;
        Tue, 11 Nov 2025 22:55:38 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:2::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2984dce55dcsm18719235ad.97.2025.11.11.22.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 22:55:38 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Tue, 11 Nov 2025 22:54:46 -0800
Subject: [PATCH net-next v9 04/14] vsock/virtio: pack struct
 virtio_vsock_skb_cb
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251111-vsock-vmtest-v9-4-852787a37bed@meta.com>
References: <20251111-vsock-vmtest-v9-0-852787a37bed@meta.com>
In-Reply-To: <20251111-vsock-vmtest-v9-0-852787a37bed@meta.com>
To: Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
 Vishnu Dasa <vishnu.dasa@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: virtualization@lists.linux.dev, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 Sargun Dhillon <sargun@sargun.me>, berrange@redhat.com, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.14.3

From: Bobby Eshleman <bobbyeshleman@meta.com>

Reduce holes in struct virtio_vsock_skb_cb. As this struct continues to
grow, we want to keep it trimmed down so it doesn't exceed the size of
skb->cb (currently 48 bytes). Eliminating the 2 byte hole provides an
additional two bytes for new fields at the end of the structure. It does
not shrink the total size, however.

Future work could include combining fields like reply and tap_delivered
into a single bitfield, but currently doing so will not make the total
struct size smaller (although, would extend the tail-end padding area by
one byte).

Before this patch:

struct virtio_vsock_skb_cb {
	bool                       reply;                /*     0     1 */
	bool                       tap_delivered;        /*     1     1 */

	/* XXX 2 bytes hole, try to pack */

	u32                        offset;               /*     4     4 */

	/* size: 8, cachelines: 1, members: 3 */
	/* sum members: 6, holes: 1, sum holes: 2 */
	/* last cacheline: 8 bytes */
};
;

After this patch:

struct virtio_vsock_skb_cb {
	u32                        offset;               /*     0     4 */
	bool                       reply;                /*     4     1 */
	bool                       tap_delivered;        /*     5     1 */

	/* size: 8, cachelines: 1, members: 3 */
	/* padding: 2 */
	/* last cacheline: 8 bytes */
};

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 include/linux/virtio_vsock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 5ed6136a4ed4..18deb3c8dab3 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -10,9 +10,9 @@
 #define VIRTIO_VSOCK_SKB_HEADROOM (sizeof(struct virtio_vsock_hdr))
 
 struct virtio_vsock_skb_cb {
+	u32 offset;
 	bool reply;
 	bool tap_delivered;
-	u32 offset;
 };
 
 #define VIRTIO_VSOCK_SKB_CB(skb) ((struct virtio_vsock_skb_cb *)((skb)->cb))

-- 
2.47.3



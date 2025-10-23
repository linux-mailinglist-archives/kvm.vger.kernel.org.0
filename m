Return-Path: <kvm+bounces-60904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 34232C02F47
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 20:29:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C11A719A6EED
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 18:29:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 185E934EEFB;
	Thu, 23 Oct 2025 18:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZluPI/AT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B56234BA51
	for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 18:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761244091; cv=none; b=IOjExFAhw26jJ9r2h3qn+epfQl0hqypwDtl8dawcBUjTwEIU86PiZOetFglVKWVR0AK49/uM696Yt8qiy0Sx83Otd0B7WLOM7tnK4DswPqdNBhRpuLB1jRK3VDyuVZSAdrWB+W60phGMqhIVNIP2EEVSJfXwWGmfJR4/CbeE0L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761244091; c=relaxed/simple;
	bh=5ZnZPrVDfdO+Z9/UM3e8BCikhyLuP+zNDA80rKqdbMY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QPQdRzgem093J4DLKbXxllpFqS0fi1GEMoCuk6L0IV66DncIEzRBIaz5IA/Gxqms1cAzyL3Z3dM1sn+8pQ8sTJC1ttT4nbfHi+62UJIdvA3+SoRKBF3X0GBE6c4/Xx5k0TCzPLCRnJjvZIW1fPjmp7Cf7hN/WFC0xsTVWEnlYWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZluPI/AT; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b55517e74e3so1115204a12.2
        for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 11:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761244086; x=1761848886; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j0IJv9dMDzYNAhk3DeojEckJoVGEYAGQr1mrX7CZmVI=;
        b=ZluPI/ATyLxWxTZnYtnR1Q+2uqTB8mTBDQVYynXfkdJqsa6A9Txt9/KjUi4mCfhZ/Y
         6XLP/aLF5CVY9ezJucDQCws4m1PpC0+ulGf2zweCjxbvf6bfEKR1MiMTRXJQ0wPXrTTx
         leva9rnWFR43CoZ2ATmAEOtOJrCAkQQ+pfX59nKs1bNb4NWM52FTWeXJLq/gLHHr+wFS
         5whdVdBitUm2RU7sV+qHkbRjyemuJ+TfwBgvHIITwc7W7uIkYNSSmWLUjjTPoQHSguef
         +1s1PKqKYefGRIu/7tV2+Gd61SpbNP06SvCt5aOZgzKxwzM4ARH1o65DylVHpdAR7/tY
         cbhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761244086; x=1761848886;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j0IJv9dMDzYNAhk3DeojEckJoVGEYAGQr1mrX7CZmVI=;
        b=MptjVsAtx0xzQYR9AyPF6SRshaQpNFTaExEjuc0Nt8StTNSvqKsWoL9eKDk6I5mEGC
         MGLEE0EV2NRGPFJthe7wKTcvZLmjg+mYe8MU6603M86fGSwg65V4YVvolDA4KVV0otp6
         TXMBorH7RmaJKEBjdg76J5Ih6rdHoeqkOfFRFFqVGQF0Cfj57mcv1s+YPp1WT1wkL7Bx
         GVbRRMIx3Xt6RuPpIOmqKjN7e0WK/MUY/7FKmjaSYQ6QbHbj+NjJ38Qoc7CZEuqpEl6l
         AsbDpeuEXWPOyjQiA5C5o4WgI5rWkUkf6IA7dGCOHzXcqewbc8V7pfzJVvCgEsJN8ejx
         UqBA==
X-Forwarded-Encrypted: i=1; AJvYcCXv7J/GWIQKM9wGqVVb6Q0CGUcsDiyd2u+I+oc3mjnRxILtwRk+iyQL9rhwkgSXs9q9JNo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaLZY2hWjnicTtw1cwjFWQ13/ouu0l+Q6BorovJzhVOOuowQW5
	aRFcd29KVD3T1dFbbxdHu6v9VxXEZHSd3X8VYvEXdlPHFAKHeX2KqcN8
X-Gm-Gg: ASbGnctJTUbcmCK5pBtTI4S6py2iwKPxomH3qSU0g94AwZ9d1BmVeUBy2lj96C+vgqx
	bRZcwu5+3giZ6g11dVhRoFuM65zeQVVQvhPZwcuyT3pU88Kq1NwKl3T/M4ZtiSsAuihqw1luCfi
	unh3N8CxA63ryym/4stcNd41ymQwhsXJljo6sOFQBs9h2jymXDohobMV+dkRJ2dBF/ElsYhb5Oe
	PS1/yEOMsK6rjI86CxwR+VQ/pKvJbxidIl2PDBM53KpQalfmx0AumZJ8fi74bGrxCjESRnOxG7Z
	cTYyOttDJlJMJ8Vz1/EvZyj0oy1AkLuBg7fld7+uzgaYYfD32tv90eU8CeIcP0feoaVyUiamARQ
	GfaUF82+i8P1neBJWfHG0Tlc49l/9UlzKBhat8hPVZfbNF175QxOcqlNwq3b7+ITN/fig0l4PBP
	rSUJ1t7lbGRXgERoE1rYQ=
X-Google-Smtp-Source: AGHT+IHuF0nGiLuYIY7bEPnV/kWChQOzz0OHyllyc5LZQHhWV90GhBaf/if/KbPVYud5pvRswtc0Ww==
X-Received: by 2002:a17:902:ebc6:b0:290:9a74:a8ad with SMTP id d9443c01a7336-290cba41dc7mr337313795ad.53.1761244085636;
        Thu, 23 Oct 2025 11:28:05 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:42::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2946de152e7sm30294645ad.29.2025.10.23.11.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 11:28:05 -0700 (PDT)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Thu, 23 Oct 2025 11:27:41 -0700
Subject: [PATCH net-next v8 02/14] vsock/virtio: pack struct
 virtio_vsock_skb_cb
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-vsock-vmtest-v8-2-dea984d02bb0@meta.com>
References: <20251023-vsock-vmtest-v8-0-dea984d02bb0@meta.com>
In-Reply-To: <20251023-vsock-vmtest-v8-0-dea984d02bb0@meta.com>
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
 kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, berrange@redhat.com, 
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

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 include/linux/virtio_vsock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 0c67543a45c8..87cf4dcac78a 100644
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



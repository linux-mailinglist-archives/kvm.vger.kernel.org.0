Return-Path: <kvm+bounces-40890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3426A5EC52
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 08:06:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 359323BB001
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 07:05:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4AA7200BB8;
	Thu, 13 Mar 2025 07:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="ECdzwPAG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728CB200B99
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 07:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741849306; cv=none; b=bM99u5r4DxGVE4bt9PMTtvYalI6uKGwb4ulGAgfGhRYZLSYXu1ZzyiM6LWONPtqr35vdiDIyunsZqtBYRZWW6n8ERkpjlOZatj0BkBaH8LrdRySiOvn88hdLUqe2bJygeWR5GOLUe7l4XeA+OluaY4srX0u7bYOYkGM5cFSrTzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741849306; c=relaxed/simple;
	bh=uj6BiB0IqVm8+xs3f9Zn6aCjK6f7zlPp0hv2djTMvTQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=CFvb9TwyRgy8p5c0GJjwu4DIlUqoBqSu+yz5SrX9Mp95qtGWfxknONEJGz7rFGFGj0ft039piVFt6V2wwUGtrUuW1Ou+d/nxbJWeo2dFfg2LlgrgJlAU1Gy4WcL/+Wjxoy9GhZUYwUJe4puOqfKzNp/UHXdjlOfccCKHcct7/OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=ECdzwPAG; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2235189adaeso12411185ad.0
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 00:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741849303; x=1742454103; darn=vger.kernel.org;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CFouu/EN4lEKQm+2Nyv7q163Sd7hDT7Qc+wcMAoVrxU=;
        b=ECdzwPAGAoCSWTXNIPQAxfcp5P5SO/fvBwY8wBAZUecHrDq/oB25D5UMWszSldfTLP
         p5QDz7GxzNr20zvrqcBBLrPOhOkButkAn7HNPGKGn72o66/xWBn69cIc8OwYKzii2YHF
         UTHRdX1A7gEmF0OytmdVJrL9JF5JwU9BzZgP2kXboWM7r1e4HjB68MGU41+fgxzmdpBd
         qSs08DI12hK+QOphesK44Ut/fK55/lQt0/u3Lyr2X3iiy60Wb7Oh5Qehrr+3n0mE/EtG
         +zdg17kGP3uJaj9moQmRyyLwDMfU7aniXslS0xnqhH4oLBRi7FOKo4xuA1+QLLWqO7uf
         X1Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741849303; x=1742454103;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CFouu/EN4lEKQm+2Nyv7q163Sd7hDT7Qc+wcMAoVrxU=;
        b=dX3t2qXJQFeMwAlyAeN1Xh/vRdPCI+x6Y6pUXI8dTfJcWq6UU9ChiCMEpERXBoTK0P
         Rt44MDbBOnzTqB0DBGvR41W2TwQWJeq0+xUXjBGIk31zrSO8hbhfD5zxv2ExDUtoNQqs
         OHcFJJAWn6T+7NGkLlLOGApVqq3+xOw6VVUL8XoAw8HF42JADzXfTyTaA/lnAvnwagBJ
         lnVdPdAsb6Rac8KlNB7rgbFF2xr+Wa8rBogCaJn9eotRc8EhWs6nMa0sFzIJ4dERYzTR
         uTVRykm5axUhEJlVo+9RI8sYuqZUMUI2UpuFS9DrHGXdy6V4dmRbLTic9kzD/XB3gHEi
         4Fng==
X-Forwarded-Encrypted: i=1; AJvYcCXxLRhaqUTAv7UBTye0gcpt/kT9zyl1EPScy3baubMfCuv4wTfCmbQ60hBhOWz/mtBX+Bg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0L8jWPB4zpTVrWfDrgs0f951nt/fCnNaELrH1Tp1YKXzce5PH
	gB5qyFVHaJNQjGD3L4pTv1MZUIkHyZIP835hmjPKCt84SufBrdqoqOkjPYvDZyo=
X-Gm-Gg: ASbGncvQLvqbRGpLxtKBk2QhFp7UjNeALFkUHsn3dWAE9TvysTYFDNkDVM7Z9QERW/l
	bhpo+qV4KRFBM0nUeEOHTdbq926sTTVJC3WHbK0VWLNCI0SjMIGfC17cuqvnUwp7fxoDEvotvse
	G3ds2bc5Dw9k4z21/cVadPkGTq2Fs/4VhnJJi4wbEEs6KkuzGQwAFj4ZZVUGuE1kAcYR7Yyev65
	YboKRdmvWrAuBMCO75UJ+9aq+Y1Tvc54bLAZ5stMUIgeqeoRQ2x4E8RR2FzTow1sAH6/iKSf+3K
	zdBPMr9Qva0iFwbi7HHLgKmThGaVa2s4Dm000E5AYbU5Xa5Y
X-Google-Smtp-Source: AGHT+IF41bM6O52nxyqfLS5xcbnmD0BRXYmKkq1aTZiZh+PP5DLgrJ3Gf/DAzNS+0zNbGzXZ+/OHfQ==
X-Received: by 2002:a17:903:189:b0:221:8568:c00f with SMTP id d9443c01a7336-225c64097abmr19829395ad.0.1741849302826;
        Thu, 13 Mar 2025 00:01:42 -0700 (PDT)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-225c6bbe84esm6495685ad.176.2025.03.13.00.01.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Mar 2025 00:01:42 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 13 Mar 2025 16:01:06 +0900
Subject: [PATCH net-next v10 03/10] tun: Allow steering eBPF program to
 fall back
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250313-rss-v10-3-3185d73a9af0@daynix.com>
References: <20250313-rss-v10-0-3185d73a9af0@daynix.com>
In-Reply-To: <20250313-rss-v10-0-3185d73a9af0@daynix.com>
To: Jonathan Corbet <corbet@lwn.net>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 Jason Wang <jasowang@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Shuah Khan <shuah@kernel.org>, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 netdev@vger.kernel.org, kvm@vger.kernel.org, 
 virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org, 
 Yuri Benditovich <yuri.benditovich@daynix.com>, 
 Andrew Melnychenko <andrew@daynix.com>, 
 Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com, 
 Lei Yang <leiyang@redhat.com>, Simon Horman <horms@kernel.org>, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.15-dev-edae6

This clarifies a steering eBPF program takes precedence over the other
steering algorithms.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 Documentation/networking/tuntap.rst |  7 +++++++
 drivers/net/tun.c                   | 28 +++++++++++++++++-----------
 include/uapi/linux/if_tun.h         |  9 +++++++++
 3 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/Documentation/networking/tuntap.rst b/Documentation/networking/tuntap.rst
index 4d7087f727be..86b4ae8caa8a 100644
--- a/Documentation/networking/tuntap.rst
+++ b/Documentation/networking/tuntap.rst
@@ -206,6 +206,13 @@ enable is true we enable it, otherwise we disable it::
       return ioctl(fd, TUNSETQUEUE, (void *)&ifr);
   }
 
+3.4 Reference
+-------------
+
+``linux/if_tun.h`` defines the interface described below:
+
+.. kernel-doc:: include/uapi/linux/if_tun.h
+
 Universal TUN/TAP device driver Frequently Asked Question
 =========================================================
 
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index d8f4d3e996a7..9133ab9ed3f5 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -476,21 +476,29 @@ static u16 tun_automq_select_queue(struct tun_struct *tun, struct sk_buff *skb)
 	return txq;
 }
 
-static u16 tun_ebpf_select_queue(struct tun_struct *tun, struct sk_buff *skb)
+static bool tun_ebpf_select_queue(struct tun_struct *tun, struct sk_buff *skb,
+				  u16 *ret)
 {
 	struct tun_prog *prog;
 	u32 numqueues;
-	u16 ret = 0;
+	u32 prog_ret;
+
+	prog = rcu_dereference(tun->steering_prog);
+	if (!prog)
+		return false;
 
 	numqueues = READ_ONCE(tun->numqueues);
-	if (!numqueues)
-		return 0;
+	if (!numqueues) {
+		*ret = 0;
+		return true;
+	}
 
-	prog = rcu_dereference(tun->steering_prog);
-	if (prog)
-		ret = bpf_prog_run_clear_cb(prog->prog, skb);
+	prog_ret = bpf_prog_run_clear_cb(prog->prog, skb);
+	if (prog_ret == TUN_STEERINGEBPF_FALLBACK)
+		return false;
 
-	return ret % numqueues;
+	*ret = (u16)prog_ret % numqueues;
+	return true;
 }
 
 static u16 tun_select_queue(struct net_device *dev, struct sk_buff *skb,
@@ -500,9 +508,7 @@ static u16 tun_select_queue(struct net_device *dev, struct sk_buff *skb,
 	u16 ret;
 
 	rcu_read_lock();
-	if (rcu_dereference(tun->steering_prog))
-		ret = tun_ebpf_select_queue(tun, skb);
-	else
+	if (!tun_ebpf_select_queue(tun, skb, &ret))
 		ret = tun_automq_select_queue(tun, skb);
 	rcu_read_unlock();
 
diff --git a/include/uapi/linux/if_tun.h b/include/uapi/linux/if_tun.h
index 287cdc81c939..980de74724fc 100644
--- a/include/uapi/linux/if_tun.h
+++ b/include/uapi/linux/if_tun.h
@@ -115,4 +115,13 @@ struct tun_filter {
 	__u8   addr[][ETH_ALEN];
 };
 
+/**
+ * define TUN_STEERINGEBPF_FALLBACK - A steering eBPF return value to fall back
+ *
+ * A steering eBPF program may return this value to fall back to the steering
+ * algorithm that should have been used if the program was not set. This allows
+ * selectively overriding the steering decision.
+ */
+#define TUN_STEERINGEBPF_FALLBACK -1
+
 #endif /* _UAPI__IF_TUN_H */

-- 
2.48.1



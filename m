Return-Path: <kvm+bounces-35621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57E87A134C1
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 09:09:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D52913A670C
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 08:09:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28EFD1D63CF;
	Thu, 16 Jan 2025 08:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="IOwbooti"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF41519D8A7
	for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 08:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737014922; cv=none; b=sSf1XlU1PdReMSUw5pwLTKhl+1VpvDcvhDMGlXEcjIb8la4MEzM6cftXAyoXtBSm/OI92JjNhy6zD5iDmDP/W1eis1GM4PlqkwQgap9+Y+ewcvSsZ+tMP5xOG+uF0eVUozygOi3g6bGMTiT7vt1jh0+qX+M1s6Em76BXdRndcKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737014922; c=relaxed/simple;
	bh=LD3j4cF3ZMXrF9quJO23QS+8dlMHJLISNsvcy2RQu8g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To; b=ICTfzigSYQUh2DdC9m4tMRHzB8+Cnu7t1RvetWsvr0xgd9HL+x90EhRB6cwh85GoK6bzPxLkP2O4h70TtHQl1K12TxILqOCPRvwiCHmOs1RL0k34QlvoOaT/bS+GViNIuDVq/l382y4nKe+nsqQVNrxPjpUerNbXdxQ7pzMBDS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=IOwbooti; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2164b1f05caso10319615ad.3
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 00:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1737014919; x=1737619719; darn=vger.kernel.org;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eZHCcie3Jz8m8hktWKIHhBfL5Qmb7ZIYIU8qeIL3Flw=;
        b=IOwbootiAoYwW850VVPT8aY1OF8iTAuErzhJvJiWgJ1gOBI9Mpx8HIkEMKXrzh9pAT
         JoMXrRDa1rBbh9r6ejFMALjb5DCYHm0tiglYbb+R7trdij78vAV5eMxYFpvlNGBqpKhZ
         GVYhcqWMh//44RcnhxwfP2pOOuw1HEYhkzs+UccOgSg4kAUal+cGPkkstt9YiT8Q+Rfh
         kr9EbYLw7dIn8/Km7N3Fmz5Fxqy/RR5N15JFVNGVePGeHoTOClkTfdLaSDb3EKegyTbg
         IOuoWkLujizbUPMhc1hw8lcbQEZieqsj8lDGzUhTXi899A9qkbfz0oGfTu1S4XE48m91
         Mhww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737014919; x=1737619719;
        h=to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eZHCcie3Jz8m8hktWKIHhBfL5Qmb7ZIYIU8qeIL3Flw=;
        b=I7gLfb3ADI7MLGC3HbEeHDvBrHnbnUwpDeQAurkwADHb+ec54Sx+vsUL8Hqp0lCPlh
         NI0SDB5fsyQQu6DZjpNlX2CIsgIH+iq0cD140qvOWZju+bl4fWlykXnvCm9n8KpkHD0P
         OVV+mJHeDpFDj5pETXWfARKlWobrffY4ndNq8GNs10pKTdVxVmOW7y9VSX8cuuOamgiV
         f7Q6+aCGiBRfwq13vayOTSUtlvVVAoFveuVEys80s88FD8a2X0u8TV4u+z9kwtqM5Tjr
         rLmnWwlaP/3e10H9+mva3WEM07tGrWorIL9V0/j/soiOw1ZNELOi1nFV2lO60aO0OR1V
         19tQ==
X-Forwarded-Encrypted: i=1; AJvYcCU58v5T11ePiEd08jEHi82dFXYwX1HJfN1OnaJ7+9pa8DC5Dc65q6A5MQkBnDZWcf+QNKY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7zfV9081voVExcxKkwRdZJncxZM9oS0LQAw0lqNS1X7aINCue
	nebhP7uGc8oyKAv5jrcw7Zi9MZGOqwxnOnU3HQdSbNzgj3JqHNr9n39mqO+gPsw=
X-Gm-Gg: ASbGnctPVyKBH1PfYmspEYVxfqWCStrtgTLGBIayZoznW706ZkeUOnFqfDrCc3R0h74
	qA1FzmA13629RgdGgYk/uOa1h+QrUL6g0Z9tKtfUvei33lO5CnVIc/hqOp3TIBKl6p+35iaP6dW
	Z/TQASXfclCCjPgDml1iqh11qIE/vnMU/PAYiknruJ+zhC7gj11CiCKUbyZ2AxArLws1wyw2zuP
	cCKvLIPcR41BQDO8AKQhuS7TuoBBCQsf3N4RHHJish+ET3GWaPbtjtgLTQ=
X-Google-Smtp-Source: AGHT+IFh9yQIztGDTXss6u8AScgSJUBFClQpr2gqvX+d26toeWNI7G8UL+nQyJLfVgkmE7FH1vRIjQ==
X-Received: by 2002:a17:903:94d:b0:216:2af7:a2a3 with SMTP id d9443c01a7336-21a83fe48f2mr535916575ad.53.1737014919344;
        Thu, 16 Jan 2025 00:08:39 -0800 (PST)
Received: from localhost ([157.82.203.37])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-21a9f256b4csm93035125ad.215.2025.01.16.00.08.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 00:08:39 -0800 (PST)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 16 Jan 2025 17:08:04 +0900
Subject: [PATCH net v3 1/9] tun: Refactor CONFIG_TUN_VNET_CROSS_LE
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250116-tun-v3-1-c6b2871e97f7@daynix.com>
References: <20250116-tun-v3-0-c6b2871e97f7@daynix.com>
In-Reply-To: <20250116-tun-v3-0-c6b2871e97f7@daynix.com>
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
 devel@daynix.com, Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14-dev-fd6e3

Check IS_ENABLED(CONFIG_TUN_VNET_CROSS_LE) to save some lines and make
future changes easier.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 drivers/net/tun.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index e816aaba8e5f..452fc5104260 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -298,10 +298,10 @@ static bool tun_napi_frags_enabled(const struct tun_file *tfile)
 	return tfile->napi_frags_enabled;
 }
 
-#ifdef CONFIG_TUN_VNET_CROSS_LE
 static inline bool tun_legacy_is_little_endian(struct tun_struct *tun)
 {
-	return tun->flags & TUN_VNET_BE ? false :
+	return !(IS_ENABLED(CONFIG_TUN_VNET_CROSS_LE) &&
+		 (tun->flags & TUN_VNET_BE)) &&
 		virtio_legacy_is_little_endian();
 }
 
@@ -309,6 +309,9 @@ static long tun_get_vnet_be(struct tun_struct *tun, int __user *argp)
 {
 	int be = !!(tun->flags & TUN_VNET_BE);
 
+	if (!IS_ENABLED(CONFIG_TUN_VNET_CROSS_LE))
+		return -EINVAL;
+
 	if (put_user(be, argp))
 		return -EFAULT;
 
@@ -319,6 +322,9 @@ static long tun_set_vnet_be(struct tun_struct *tun, int __user *argp)
 {
 	int be;
 
+	if (!IS_ENABLED(CONFIG_TUN_VNET_CROSS_LE))
+		return -EINVAL;
+
 	if (get_user(be, argp))
 		return -EFAULT;
 
@@ -329,22 +335,6 @@ static long tun_set_vnet_be(struct tun_struct *tun, int __user *argp)
 
 	return 0;
 }
-#else
-static inline bool tun_legacy_is_little_endian(struct tun_struct *tun)
-{
-	return virtio_legacy_is_little_endian();
-}
-
-static long tun_get_vnet_be(struct tun_struct *tun, int __user *argp)
-{
-	return -EINVAL;
-}
-
-static long tun_set_vnet_be(struct tun_struct *tun, int __user *argp)
-{
-	return -EINVAL;
-}
-#endif /* CONFIG_TUN_VNET_CROSS_LE */
 
 static inline bool tun_is_little_endian(struct tun_struct *tun)
 {

-- 
2.47.1



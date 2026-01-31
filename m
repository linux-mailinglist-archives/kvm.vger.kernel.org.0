Return-Path: <kvm+bounces-69761-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GBPbCEJifWkkRwIAu9opvQ
	(envelope-from <kvm+bounces-69761-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 03:00:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A21AC02B8
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 03:00:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DEB3B30210E3
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 02:00:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28B15318EE6;
	Sat, 31 Jan 2026 02:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FtlSPQ14"
X-Original-To: kvm@vger.kernel.org
Received: from mail-dl1-f66.google.com (mail-dl1-f66.google.com [74.125.82.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C312279DAD
	for <kvm@vger.kernel.org>; Sat, 31 Jan 2026 02:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769824818; cv=none; b=j2A2L7ecBd+Yc/kuoH4XV4kobLZTySGOtKI6MW3R7yjk0JErOjilEsS9TFQvltfxv9K70+lqw2nEmzbAwSR17hKkV5Tf5fJ307MnXt+LaEeVe6Quaby5HMXIebBz7PT7hN8i/LqXaxkhaH6U/ykvLGhU1XSCcgHJmhLeocPdA6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769824818; c=relaxed/simple;
	bh=PcnC0cIs8o2+raeXclFwxf19lLyZNzo2rmeBKNtVlbI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DB0QgMpnSEuZHPskU8zKnTqgyVZyEO4ZcR+EzGENGPOUQjyr3fgTjQRa1Cj/4jS4cA0T74obm+lq7ZlFG4ZSy6UIGvuqWEXXtmnWwsTfrijjvfeyofysT6ourhA8Vxv95b9kB4nsbDUjd7Oxs+OFj3neAJvgQ9BrM9AfVGFwqQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FtlSPQ14; arc=none smtp.client-ip=74.125.82.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dl1-f66.google.com with SMTP id a92af1059eb24-12336c0a8b6so3889691c88.1
        for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 18:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769824816; x=1770429616; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=A7Pln/lrrLR4dH8KvvW/wU7k2y3WN7F5GccQPSyOhNE=;
        b=FtlSPQ14+gmpdpFepbVKeFzG5jsWxoHbXI3KwwuaYb664sAwaiC1QCGnLt0c53zsdM
         8pyPmILGBdaG5YS4KMKrIBwE1ycEEeK1wDtMmU+FC/fCQgDrY6fFsNHoazKmN0lR2VDj
         7XRby6ms294U8w+2wYb4XkBr2CCUy56GeWO6T+n4Juc6cQgG+VIJu4zZz1w7PmmoTFPQ
         hqhSOVhZc2QqKoKiM8vBxlCGn06XiQqsRerDYSSuThfuv0XmXXcOe4pK/dBnOF6A10lz
         xKLP65okUjkPWsn2jEHJOcA0yj6dwHrdKaMJ63GoZQX75wV3Lg/UvQRyeTG6a/ygzxvV
         7D6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769824816; x=1770429616;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A7Pln/lrrLR4dH8KvvW/wU7k2y3WN7F5GccQPSyOhNE=;
        b=CFnMdskjhVVq4nmaWRLqQBw9XdWbnjweArttnc36SnvG9sP99RjDjExcSG0Fm99Dpp
         k9p1+ZX52O8osRYYRsQBOEQKb7DK6op5cP/R7WI+aWpw05pAUJO66J8k4MrBtN+KmBfV
         YCp1pZIYex7NlG52jMBb6G4EL9APgz8P+HefGMIL14u6lsQvFi7KOMVsVNjVaKFhwZ7+
         ebEw0C+/wRPAXqMT1eRgLIKqtnN/aBzD9gKSrCnZUkdHAgmey95sgTa8nBmoAgOXP5kS
         OzQi3rdjVyJxXDSHK/NWZTu2CTBOqa5fVsTM0IkbipSymBH9vUlq9iB5R8fX9T/obKX9
         Eyzw==
X-Gm-Message-State: AOJu0Yyr9Wr7DTvHoY7hMIT+7m52RA93VrS6Y8hE2YuN6buasFQeq9SJ
	dMomHAZ7Eb3p/0qzbUr9zcp9/WEiYXK7LoMvlurJsqW3rvt43atAurvFcDwxQZb9
X-Gm-Gg: AZuq6aLdtJTWn5B9BUYNAMamxuxMXjyxdZO8bswTs4dAWoRDHNEHm8yiNh6Fv9Lksut
	akkctr1RP04WWoB9LiCv4/8z7AlafqbKiqkeyb+/bybn4q0Xms13rLjoIPsRAPS3ZnllmDT+Iad
	DZVmPEXRXpjSpIu4qbt0vmHb6RI3vOidNdViyuAHTYMIoH5MOtTvBr2yNhydrnRHB8KCkQslhiE
	S9BJ5MhZLSmEcX7emvut/kRZXDx5bvVSPwInyJWzOAtwXg3/S24nDUKrXwGKxfmTyBs46PX6Kub
	wpJIN+jGw05PtpgpO5U0Gw8OKIsvh8J1KhfLSjbxplebMblgohQh13/n0IpaqV79gklcZvIXhKa
	vpfvR7q8PMCSfrLUudL11WFZhrcGjT30k2eTUCn9lMk5tjvSgtImawowdWSd+7T4pOlS6E09t8k
	BFU/F+Q/l7ZY1cubqn204rLONfCD6xr9jPBnvudcfimd5LWZFgNSAUk5moawZPgKb4CO9moaXZk
	NhBmMZ4RtMWBAwfvbdx0WxUBGwKntKduM9f1rP8vxncp79OzYqkHGD6q6NQ73+BH6d5TiStiFHC
	cIIXU5jt8+3ca1w=
X-Received: by 2002:a05:7022:e13:b0:11b:c4ee:66b with SMTP id a92af1059eb24-125c10092c8mr2442262c88.37.1769824816261;
        Fri, 30 Jan 2026 18:00:16 -0800 (PST)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a1abe57csm15945242eec.22.2026.01.30.18.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 18:00:16 -0800 (PST)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: kvm@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
Subject: [PATCH] vhost: remove unnecessary module_init/exit functions
Date: Fri, 30 Jan 2026 18:00:09 -0800
Message-ID: <20260131020010.45647-1-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[gmail.com,redhat.com];
	TAGGED_FROM(0.00)[bounces-69761-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[enelsonmoore@gmail.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9A21AC02B8
X-Rspamd-Action: no action

The vhost driver has unnecessary empty module_init and
module_exit functions. Remove them. Note that if a module_init function
exists, a module_exit function must also exist; otherwise, the module
cannot be unloaded.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
 drivers/vhost/vhost.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index bccdc9eab267..d0e2b9638ecc 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -3326,18 +3326,6 @@ void vhost_set_backend_features(struct vhost_dev *dev, u64 features)
 }
 EXPORT_SYMBOL_GPL(vhost_set_backend_features);
 
-static int __init vhost_init(void)
-{
-	return 0;
-}
-
-static void __exit vhost_exit(void)
-{
-}
-
-module_init(vhost_init);
-module_exit(vhost_exit);
-
 MODULE_VERSION("0.0.1");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Michael S. Tsirkin");
-- 
2.43.0



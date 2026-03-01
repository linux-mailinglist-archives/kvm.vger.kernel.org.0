Return-Path: <kvm+bounces-72319-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id x4XdE438o2krTwUAu9opvQ
	(envelope-from <kvm+bounces-72319-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 09:45:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B1DE51CEE3F
	for <lists+kvm@lfdr.de>; Sun, 01 Mar 2026 09:45:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D0417304179A
	for <lists+kvm@lfdr.de>; Sun,  1 Mar 2026 08:37:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FE14335564;
	Sun,  1 Mar 2026 08:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QA+iCvNl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB0C33374F
	for <kvm@vger.kernel.org>; Sun,  1 Mar 2026 08:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772354206; cv=none; b=S2QKkyuh9o4B7meCauL+rKkpZU19DHvhMzjilCIrGVxl+qoeMJzGzTaQF7/WOUM0ah979qml04MYKFuNx0Eh3d4RZypSYNUqnjlLVo7KISsASF4f9FCSVwCCqWX+LaAN5Ca7a638Z58uNiHlRWtHDI+EKh6hhCKVZLTDTbq2PkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772354206; c=relaxed/simple;
	bh=2JEqUjPCmOPhLW0+NpsR7KgG/zG0nQevkRUZFK/LX5w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fh/zkQH/+yW3Z+QcfCed5n2e80+5nZcUuqLu4J0pm/Xb7214Ev32T6gOMwWbYkf79lEkMtu8asiYdqH6sh9Dpdw1yklrVPp2q0aKpD1Wrz/aKIfvPZjtsJZo0ixQi6O2PFJEKVWjH2kWNAybF7f3KA7YXlHGOIazYGrWV9eMjhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QA+iCvNl; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3597c40a838so304333a91.1
        for <kvm@vger.kernel.org>; Sun, 01 Mar 2026 00:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772354205; x=1772959005; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WrlNKEOMaeq04+2BcaqNmbBtuVSrRRKkFaIhN+u7TNs=;
        b=QA+iCvNlBMtohRA6uMzfy9WjBlHFq9cieXJX/lds0GiosBAgLIgVDZpnKTo0qfOtXQ
         nSO/JOItzJimE7SXJ9ibeDx7jhvmolAYFUyPdSw9Cd31/JSiXdaTGXDFbUsq8iELRG1U
         7FWdAE0lOiRkuXL1WrMZBEvsZi1aCbFzKwntax7Kl3zgj+HlciqjV+FlbHGm2972VATt
         S8uiG9Szf97AjSyXzQ4e4Og1R8kCPYu4zt/RrJJPZdWalcdKJIKj67wsuTXjhM3HL9Pp
         oOq/DBVrFYAIGF0PCtwWeB7FlWielEoY+K9vmk5nkf3xJAO8TuQFylmpye6AilxyuA6Z
         rLFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772354205; x=1772959005;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WrlNKEOMaeq04+2BcaqNmbBtuVSrRRKkFaIhN+u7TNs=;
        b=ELRitBXee16FfAF/UjkK0mkSJNI81vfDF+lMxOSn1RvI8r/votC9YZHajVwhWvRLrz
         xfKeQJ5LPnD7em1umn5+E2ysUvJuA6BVgeV1/v5j/Ryug0OttptN/0NgLNGKfW6s4h+v
         Ed5S2w205LyhinNZsiVRqTljuBi0ycVru0artcDzLMN32tazxicleL+e6UiA/zpadLdk
         HZgNNNHjRct7js/JKpQM79PfgkHIHHoq67P5sE8mga9j9zoo5L1/LJQaf7Iwqw2po4GB
         fjNh3u16xj+x+h9t4TL4sI2CiETG6ZZrlIsmLA1xKgtHrEzQa3/zDtkCnEMdz1R0GNAY
         Zfpw==
X-Forwarded-Encrypted: i=1; AJvYcCVaH9DzsiuGhhLSd66Y7naAvUAI9eoEIZLmSSVJSY1fI8Md+h78ekIHQbxqxK533WFTdBc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwI57NjrFMG3i+k5wqZM4sWdl1ZxsezuNx/gPFK+4JWQEl4D34k
	K+K7ijatRIkawtryQDsM2O4FUdS6W3w7bk1t/UWdUlJZZ7LvhOO0MJZ/
X-Gm-Gg: ATEYQzwW+CVyJXNohMxm9aMIvp0+IKqi4HFvh5GgzwVfjKJ6NPdSgTSbqYapycJWvM3
	qWervXf2rLT9U+ZT/JZ7pR8iuOEXMIvKPzB2qWoVrBHfdkzowQF+l0uQJIQ0iIKKzLlVB0aMdDl
	/GcF29Eyvd4L8KwGzCGc94NY6kwLauWstPeNBc2VqgqH4Bx946X3hHux/+bOft+Hj4YWO8MDvl4
	ZKWDE+XM1qiYvBKukivWqXCoIqAnsj63vnGELh4eR0pUEfd7Fg2apQiaEwdHB7/wwcL6QmcN0Po
	Dp9fnT7+h03BmYbAhzhV6P/XLst6rVDAa8Sr2lNe6i0yOzQXabpdD2h/2J/OVfX4A5L54GjLZrc
	VUPRphPxHDlKK3dXPlQ2alyqajIQHDSe/3Rt8duGcfEeivqech/evjvU/Fc/dfkgHCIb8B8jznh
	5yqLiPjgQXPcmWl0yPsUYnq+7v6Ko=
X-Received: by 2002:a17:90b:544b:b0:354:bd08:480c with SMTP id 98e67ed59e1d1-35965d029fcmr7491393a91.30.1772354204874;
        Sun, 01 Mar 2026 00:36:44 -0800 (PST)
Received: from linux-dev.. ([104.28.153.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35912ff8a92sm6385615a91.6.2026.03.01.00.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2026 00:36:43 -0800 (PST)
From: Afkari Zergaw <afkarizergaw12@gmail.com>
To: pbonzini@redhat.com,
	corbet@lwn.net
Cc: skhan@linuxfoundation.org,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Afkari Zergaw <afkarizergaw12@gmail.com>
Subject: [PATCH] Signed-off-by: Afkari Zergaw <afkarizergaw12@gmail.com>
Date: Sun,  1 Mar 2026 08:36:12 +0000
Message-ID: <20260301083612.11661-1-afkarizergaw12@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [4.34 / 15.00];
	RECEIVED_BLOCKLISTDE(3.00)[104.28.153.21:received];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	MAILLIST(-0.15)[generic];
	BAD_REP_POLICIES(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[linuxfoundation.org,vger.kernel.org,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72319-lists,kvm=lfdr.de];
	R_DKIM_ALLOW(0.00)[gmail.com:s=20230601];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	GREYLIST(0.00)[pass,body];
	DMARC_POLICY_ALLOW(0.00)[gmail.com,none];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[afkarizergaw12@gmail.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	NEURAL_HAM(-0.00)[-0.846];
	TAGGED_RCPT(0.00)[kvm];
	ARC_ALLOW(0.00)[subspace.kernel.org:s=arc-20240116:i=1];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	R_SPF_ALLOW(0.00)[+ip6:2600:3c04:e001:36c::/64];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B1DE51CEE3F
X-Rspamd-Action: no action

firewire: net: fix FIXME comment punctuation

Add a missing colon after the FIXME tag in the comment to follow
the standard kernel comment style.

Signed-off-by: Afkari Zergaw <afkarizergaw12@gmail.com>
---
 drivers/firewire/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index f1a2bee39bf1..70ceab772208 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -121,7 +121,7 @@ struct fwnet_partial_datagram {
 	struct list_head pd_link;
 	struct list_head fi_list;
 	struct sk_buff *skb;
-	/* FIXME Why not use skb->data? */
+	/* FIXME: Why not use skb->data? */
 	char *pbuf;
 	u16 datagram_label;
 	u16 ether_type;
-- 
2.43.0



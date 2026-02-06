Return-Path: <kvm+bounces-70420-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OCl4IQxuhWnqBQQAu9opvQ
	(envelope-from <kvm+bounces-70420-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 05:29:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 31984FA120
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 05:29:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E3B2B3030242
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 04:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 405BB34A790;
	Fri,  6 Feb 2026 04:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="g6uqXwiU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5568834A3AC
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 04:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770351730; cv=none; b=ksPvIfaddbeyIkpZEmX84EpPBxVzj/5krL9gY+Yuw64Y3xsifBHg88eJMrYd1DIMQgA9bUwPrw36yEtazJ2gWTareX5tPPVAMydu6ZFSiIO6h62fRDf8kBVqwMZ7uLAAA0qcur/FzoHaqVokEdR7+ayfMHKobSeO5T0Eig9gkq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770351730; c=relaxed/simple;
	bh=schF0neiKMjMwIQD1wUQTkUvB/Oukq1jkfltC5LPFeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTY8fTFv9pXDztzow/1nNorpaM9IsHAIQgNDlUxl3QArr2FExkx/4MKJLcDUroKMkTHcFUCoOLt8b5wH2OnNOFhXIOKHIAhegeyu23vmd/pRi1PfIMzPk5ngDD1UZwMPcm6OgF2q49o/HEQKfjUAGL4ia5sQPjq+1tr2lFgptBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=g6uqXwiU; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-82318702afbso228609b3a.1
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 20:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770351730; x=1770956530; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P+C4usfFJxntIkaYUwqttNHLWY0mMsZx1f8GtcALX8k=;
        b=g6uqXwiU/Q8I9G0ourom5gG8aEH2bGQyhG32PuOeFwxV44iQAjhxU4i2XNWJKCBLgL
         5GE7ZpRBd+yi8T41v/ekyoDqTC1XWYH58h9OcqJtr7Bcci7n5txm3NOE2rxM7yzam5gR
         zHJa783EYVBNB7Lcb3eeWBjFjdxuPg2v42yr2KFLCpFGDeBHHSpnbNtFauLhNhUEh4ty
         Zxq7Yncv881Uxx2KjFPGGfW9HOZgv8QsJs2KaPEXXCkGoc6R//Bu61LarA1bQhZ5igIG
         TLAo8P6jGEJ67gb6Jln52VHHmdWjk1U8j8KNptXiz8TAJvJyoB/17w6PwBMgUHLS/8ih
         3/0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770351730; x=1770956530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P+C4usfFJxntIkaYUwqttNHLWY0mMsZx1f8GtcALX8k=;
        b=Kwyh4O6zQyZyoeCNVnxb6/TCCcn5Yp0QQdbsQuTHk3l0d497gAZmb6fwD7LvMSIufI
         JXSBkFlO4nP2vjcYxC68GnFdhKlieZSgoKrwH78xAN7eZaQw9slGwcMOnJ+jfvxBYdhr
         sKEloajQETV7GB0Sk+1lY/dvEaD+bMr5z6MEVvvPOojrfeQaltONpej9f0N/VBGNSisH
         9p2Y1hIh+WNQ7oFZD6oUQFYpCNr2sjP2TMKlEWy5AhREPAFN7vuZVt78seWr02keDf4t
         KODpMebfvDOBZdxlbfhQa5S8uIR5s2lfbnzsrlBNv7ZK+FG0qy9Aq571OIhLdfLeIp4W
         fTRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcELlt0p4IuBJnzNdmkDtDcGMhll3IVJLURuvseeoMZ0xX5WU6b1pBe7ry0Y62QWJwk3I=@vger.kernel.org
X-Gm-Message-State: AOJu0YzP7JHlsbBHZ/S5CZ91pVCeGTZIMPQ3VvmrqubSCpSmeA+a1hoF
	tsi5StR7W0bBQos+yWT4asksID3fj8+IClex2448r14jEKFZwez3XbRdicnIY5KFlL8=
X-Gm-Gg: AZuq6aKK3S7EA/dybPlnVp9tuxw6wPBExN6AUz9sik2GT8GO8AtB84vYn+ZxQPzlo3J
	d50VDZA35YzFR0lHyi5B9yx+sir0gtra5oe3zmPZCAJIanxU0zb8WMd5TynkyRDAXT5bzw8UFMn
	QH44JvqgVu1gt7X07Gv+uSBrk9+/N+8Y/sLP259IgAgBeTNN2Dk+4VVHf5yi+4Zm+S8tmRcwyls
	61b/jvoldMLfA9RGoJK0YTZIeYufFh8k18GmozMdKzBlYvONFjYlwbmvQ+6z6zVJOXZ3WuZfsl2
	JeiKpKs5Aiadeqi9o88AojVxu3IkMDMwvyW+vkmQs5ZiURgIgb8Z5qSK1vbPrgMuufjJFSFtWgV
	Rp4l2KXK6lJ1/hcpCt6sl1me8KOEzZdz0fO4wajdcU+GUr6+As7mQ3SgHyKEWwWVnUw7MAInhdB
	WZXQUV2IzrFzRIsVJ7r78I2n7Ra9gLoUg4aw7JtasmOMStraE4DqSQdEL+Rx59DKDA
X-Received: by 2002:a05:6a00:17a7:b0:81f:4963:4967 with SMTP id d2e1a72fcca58-82441773190mr1309967b3a.57.1770351729674;
        Thu, 05 Feb 2026 20:22:09 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8244168fdf5sm926914b3a.17.2026.02.05.20.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 20:22:09 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: anjo@rev.ng,
	Richard Henderson <richard.henderson@linaro.org>,
	Jim MacArthur <jim.macarthur@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 11/12] target/arm/tcg/translate.h: replace target_ulong with vaddr
Date: Thu,  5 Feb 2026 20:21:49 -0800
Message-ID: <20260206042150.912578-12-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
References: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70420-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,linaro.org:email,linaro.org:dkim,linaro.org:mid]
X-Rspamd-Queue-Id: 31984FA120
X-Rspamd-Action: no action

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/translate.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/target/arm/tcg/translate.h b/target/arm/tcg/translate.h
index 027769271c9..2c8358dd7fa 100644
--- a/target/arm/tcg/translate.h
+++ b/target/arm/tcg/translate.h
@@ -18,7 +18,7 @@
  */
 typedef struct DisasLabel {
     TCGLabel *label;
-    target_ulong pc_save;
+    vaddr pc_save;
 } DisasLabel;
 
 /*
@@ -42,7 +42,7 @@ typedef struct DisasContext {
     DisasDelayException *delay_excp_list;
 
     /* The address of the current instruction being translated. */
-    target_ulong pc_curr;
+    vaddr pc_curr;
     /*
      * For CF_PCREL, the full value of cpu_pc is not known
      * (although the page offset is known).  For convenience, the
@@ -56,8 +56,8 @@ typedef struct DisasContext {
      * pc_save contains -1 to indicate that relative updates are no
      * longer possible.
      */
-    target_ulong pc_save;
-    target_ulong page_start;
+    vaddr pc_save;
+    vaddr page_start;
     uint32_t insn;
     /* Nonzero if this instruction has been conditionally skipped.  */
     int condjmp;
-- 
2.47.3



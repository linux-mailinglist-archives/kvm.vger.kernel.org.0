Return-Path: <kvm+bounces-71322-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4NQfEmeLlmm+hAIAu9opvQ
	(envelope-from <kvm+bounces-71322-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:02:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BEEAC15BF27
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:02:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B691E3014105
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 04:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEBDA2874E1;
	Thu, 19 Feb 2026 04:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lutYbw24"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80681284662
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 04:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771473744; cv=none; b=jZVZ1yhrO7XuN6WpXQa6z/WU4ZfrP954YE6asYuzz6C5jvSRzKvsi6zm89LraFrvZbPV+lv1JVGcIbB7AXnNx7AfUudyq3e6tDnIMXY+XWS42vUdcQpm76LOP7PHrmVmbNaJWkV5GCw1dx1GciXp1peUfCI8VVA2gO7cCCMdccw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771473744; c=relaxed/simple;
	bh=schF0neiKMjMwIQD1wUQTkUvB/Oukq1jkfltC5LPFeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiuhAj4i5ZfMbEZxq9ddvvymQPts/dWIBll/yYbF8HRa76POhOdnft+L8UcwtixMpTHnMELA72NQe5n1wiy7qYHJasqALJJfu6R4cS0cvgj4GzfFUaRnbNtRlTfwlVr8j6EMLD6s7c5ovLRa1Ej7AXL+PkHs36GqcdN9UtuhycA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lutYbw24; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ad22a5e245so3450685ad.2
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 20:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771473741; x=1772078541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P+C4usfFJxntIkaYUwqttNHLWY0mMsZx1f8GtcALX8k=;
        b=lutYbw24N3nQxk5Z1HYiYb2Z7KCjXzjnpfivd7uM9nKagzJrQm15iCSfK7O6k+j1yz
         mbX09QkeZwHOkmQKMulpvVK5b/8LEPs9GRP67QNOrOa4sK1sJw53Il+QezNFpzfWtpi0
         JSL68aW31ZNTaeE63hcgBshhM2ULgX1r6KIZTCOoV8TDdWJqIh5WMfW/SiCt0oRh9jxc
         QZjBNDfP1QxnGRS0M6jYkak1hmXB9+rtb1AyyX19sT9Bm49C/Xn7yA/g0cGHc+GxYAsV
         uk6Qm3zglPKlA9n6gCx1lDOe9rEKQrGFvHhL2Pcg621gRQlwGAxrHSbp0KnRLB+aGjJA
         cLCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771473741; x=1772078541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P+C4usfFJxntIkaYUwqttNHLWY0mMsZx1f8GtcALX8k=;
        b=Ru6QMMpKCVlipIOMat3tpMMCVarlmEoVaKgvDYzzplEIdg3/QhxHEfy+fTt0phcHZB
         mzrVY2VJxfC2CFZXueiw5x/pbcD8Z3hbuf+iAWZer3zOqSjMQM79Nf0V3//YxOKDaA2G
         DW7J/vgJ+XkfSjEBJkOZDJXsSUc8dw1WbH5W5vaC4sYXf/p6h2yVIXjaOlqB92M6XRY0
         EUWvgPu0xhildm8CPHg3vYW8d+fIW7G4nQRxSt9gbbbXACiWBXQHpjcgLGD/bSSjaqzj
         Q86KuUi3sFNx0Y9hNoVdWKeHLFkVGlIwpK1w0BErh3KO9eqw8i2cXEA8NxemskhcBId8
         zdtg==
X-Forwarded-Encrypted: i=1; AJvYcCWOqjGTu+j8UUGIFgTLStmGhEoJz4TtNuAdS8KCgx0YORH4jRUVCpAz4FLx2clVAAb6vhM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFb/b0WnypZKJ6nIEELLGdWd8uB1zNk55HEDGL97XyBC35QgWR
	gGvFi4xd5dzZkQvmiYpEREbVzczmfmzPxAwzpCbCLC7xu2jx294GH7y7rR8UXALifmI=
X-Gm-Gg: AZuq6aIh2Ds+3pR85y89qmwN2Vckx03A6e30+g75vhiZxIfkUkH9MLrkdGz6/o+6EnR
	36/fD9jLUCfEgDInE8pgcIwx+EL2LJCha4aZUJulp30aHOJNwTAvKUlmsJzeqUjdbSkE0DkTPtc
	V2qH0AY2c/2Pot4dlELoMJbDbUbcEH2TCMqHTC/B9npVhWX3/MIL68wnnVCGTxkTfiMskz1njDd
	SrU97t9dodnc+6W26NEsRKXlMnx5T9OzsenZS7pJvNKkSeEFElSRSg6Lm/0YPzuqtgNgCHNxwHq
	YIyfMNgr1bgw1uh57QnrFcyqT5WUfwJ/mEspi7IO9Ws1FMgARiWPABO6vBofrT/g65ubvXFdBd5
	eHaJgdbDl6PJdfMRZfZajPdWjytwrr/d91/XB6p29F6mCNaol8az1sMH6poZLG2ck2Iq/E5uGCX
	WUjoB52ueHlMdVGBb7r3ckaxT2Koz+RuJEQwSp5maJFmiI9OYHmxIe6f4wGdAVs1yVGksHjIoUv
	zmT
X-Received: by 2002:a17:902:f687:b0:295:99f0:6c66 with SMTP id d9443c01a7336-2ad50f63477mr40064175ad.36.1771473740760;
        Wed, 18 Feb 2026 20:02:20 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a73200asm147636225ad.36.2026.02.18.20.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 20:02:20 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Jim MacArthur <jim.macarthur@linaro.org>
Subject: [PATCH v4 12/14] target/arm/tcg/translate.h: replace target_ulong with vaddr
Date: Wed, 18 Feb 2026 20:01:48 -0800
Message-ID: <20260219040150.2098396-13-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260219040150.2098396-1-pierrick.bouvier@linaro.org>
References: <20260219040150.2098396-1-pierrick.bouvier@linaro.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71322-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BEEAC15BF27
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



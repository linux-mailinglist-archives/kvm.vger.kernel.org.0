Return-Path: <kvm+bounces-70793-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cCq3HBiSi2n/WAAAu9opvQ
	(envelope-from <kvm+bounces-70793-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:16:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 273D911EF1F
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:16:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 60491301950C
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 20:16:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BA203385B9;
	Tue, 10 Feb 2026 20:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="y6upSj47"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F26E3382E5
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 20:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770754555; cv=none; b=OniyX8VfGEdQVc9ygjXMr0+OR08mWEvMrn+hUlKtxBstEOq3VPrezFHMWu5pvDo16I2v88VoH0zxKj47Vl0tnr4Ea1K5whLDCVoUkGAmx6rKneMwAul4tIi2y4myUsEMXKTHIjeZ0HF94D2nJMlKQXtsY6u+iW8NxB2IXYdoBrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770754555; c=relaxed/simple;
	bh=schF0neiKMjMwIQD1wUQTkUvB/Oukq1jkfltC5LPFeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEHkbrK84m46xjvROoKEhNcywh6rczus4BoZBxdM/N1LicKaVbz8KlguEVSrNnc6vomUHI4TF4VAQqLezXIQgnv4SoWDzq0A0diMPTzJdMYyqXpcxytLqBJ4Ehg7RHo7mDxuwnlTw0o5AnGaVs6yvUqxY2gAWPiusCwhFPQmsBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=y6upSj47; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a7a23f5915so40654125ad.2
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 12:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770754554; x=1771359354; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P+C4usfFJxntIkaYUwqttNHLWY0mMsZx1f8GtcALX8k=;
        b=y6upSj47OEbVav0hc++JYvdgpALpKnzsZdJ2/KnNFT2rfUiDR/jgKs1eIEYFfWNe5t
         tY7Prx+TxlGtGR8TwHcVQqAyZ2bOc1O+i6g0giG5GUKH/RLhvPwtKRNNBD1H5k13n/vY
         i+GSMZ3IfSeUvKaQOXg0bo1U/o98Nk8mK7bbLNLle8fnSgSty/Vp7DtkRiaTDh8rg5ly
         x32z8lIk2F5AeefrgNrQkLjuHB/zXL8s6rU5yazdRkXcuGkrlcwq13uHj5IFH57dRaDe
         2cJLjxDXt0lLmgy+acSGKHrMPmHzyBQY3n8uKTUi/EUMRWIXaEum0m/SuBHcNOcFQfoO
         1MQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770754554; x=1771359354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P+C4usfFJxntIkaYUwqttNHLWY0mMsZx1f8GtcALX8k=;
        b=ss3sZoegORbQNsxezOangbHBubysDKGRCwpWYfMr1ljX+lKhZo6rBnEJ7ATNrckCUk
         X0yGTqCh2SFhIfaaGFJEgBLub0x2t8GxvuGpimxfGy5saU4Yml7FDtPNE8bAGz62L8kV
         NV8ApI3WZgxMqnJfPofewPVqXCwj6L9vh3So7MtTilokBn36DERlK6XkCABdoW0gB6pX
         KokG0g2ABu51V3pmUyfE0ecow6gGwCTk6xYoua1ScjJEGFfUX2aXBIVpfuEmVo29yVdW
         8eFoyJYhc8SQQr1AXHPczP4/lidkjwb0N7vh3YQMXou4QNTlPjTbg7sM6uSXng1SnLRq
         l6dg==
X-Forwarded-Encrypted: i=1; AJvYcCWwVR66UewK29FiLuer5Hf0XW5W915FU5cy232MxKeN+Xm0ClwiScE3zVUysICOEQnfNNw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6epiJNLMdxASCkaIY8f4WrMOy64uk8B9MnQ3jHU0PADQS/KFm
	8BLam7P0jWgre/x6jy9SEWrbAED0ml5RhRvsjLMFupIJoDu1k3TFX0aMQaHwDieqRu8=
X-Gm-Gg: AZuq6aJazxqs2PROn6y16WxLKuU7vilTyb+MmtgIHXdNKbd+pK7M+NkJ8KZnoa64t7t
	Ikkcv0GMcuEIUuLD3sFwf2mvXDIZVpKhZp7lMCK83bvZxlrdC+Cd0I33uS3n3GYi7dnTxN+RiCX
	tw05JVQ+QLbV5jUpCMAc2XglUfuswkR5U4U9lN/qqmRl78yU3nxFUS9bavXJbVDpa0mHsmIc2+N
	3PbMPQAciPudB1+cViuoXajUQZ5p+7ijR4GizWHvlQwSoffqigNF5nyWgIqm7SQCtjJFV15cbBQ
	7TB0L7hpVYLTAOrsX1BAjXZLIxWT17XeRCzgUp2SiLJHDsE14G+52a8Gaj5cWjeeBHz47nurYkU
	1GJt9s27ta9xu+5Iisq4csNiSuzImS9DA8II60xmq0OD+Jg8EdrFUt6aWHU0Ix/qO4sf06vux78
	1GJdGAqu2bN+o37ekK7mpyyZH89PL0qf3vcvSiLnMm4sWsvh2hycy+jREfmQupJ+w7ybCWJkBRY
	DIL
X-Received: by 2002:a17:902:e810:b0:2aa:d630:cd5d with SMTP id d9443c01a7336-2aad630cde5mr114918085ad.44.1770754553610;
        Tue, 10 Feb 2026 12:15:53 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ab0b392cb5sm38523225ad.70.2026.02.10.12.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 12:15:53 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: anjo@rev.ng,
	Jim MacArthur <jim.macarthur@linaro.org>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 10/12] target/arm/tcg/translate.h: replace target_ulong with vaddr
Date: Tue, 10 Feb 2026 12:15:38 -0800
Message-ID: <20260210201540.1405424-11-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260210201540.1405424-1-pierrick.bouvier@linaro.org>
References: <20260210201540.1405424-1-pierrick.bouvier@linaro.org>
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
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70793-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	DKIM_TRACE(0.00)[linaro.org:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:mid,linaro.org:dkim,linaro.org:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 273D911EF1F
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



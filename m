Return-Path: <kvm+bounces-70417-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0AUXGMRuhWnqBQQAu9opvQ
	(envelope-from <kvm+bounces-70417-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 05:32:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C78FFA19D
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 05:32:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A9B69300F1CC
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 04:25:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACE88348880;
	Fri,  6 Feb 2026 04:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="s0ZItjmh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA6C346FB3
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 04:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770351727; cv=none; b=Hn+iyRF1Ib0K4DChzkza/hUZ4mN8csfGftTKr4e9GmHcnW5aDGenDCxk8J/nONHufscr2RruaMduDzVkRrUj+cOuErm0WOFmrvdm8HGRedIXo5FON2HdUXjXki7RrAjlr70As96UuPDSqk6TyIAmPI4v6u2LsuMwtyF7gDpFDl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770351727; c=relaxed/simple;
	bh=nBptZoPntruFUIAC7aATnnyrRPgemigf0wpx7LFAXLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kZSemBEBcwpqc+7slA/4cmqGTkKMfwVJEJkwN76zPY8YwtepE/YZx4fK1Ib+Y6EO6aKcJg8IqfISHIwCupuwtgYhWCC6oU7O85bJiZpTgHeaxEH6LoGW0rZFBDFY6ddcRzlx7AwtetR9ntu+UfP0R9Y1tzqI3zFXJW1Vn+wgSvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=s0ZItjmh; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-82310b74496so854859b3a.3
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 20:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770351727; x=1770956527; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kwB8GQ+jVdd4zLoHgSYFEXrmt93cdA0BGjD0ZGggFvo=;
        b=s0ZItjmhfo697HyjUZ2xm3IF65rxuQQIOJ1RYWyvF+TQxGPx5//03Dl5LHAfSFMF7x
         JYBv3AYGjxv79zOLmXWwMIN+NedtD08G5S0jL6IDX23x1ngUK7hXHWgJya3SIUJyJHaU
         fFqUunNLNol7xd3EO3mVmZD78Jie0TIOVz4ze5odPV1Mqk2qMjiZ4grsi8FsuseHPVuC
         YppP4m2f37EjD2NPIYLPduaHLdMYcm91rtpojQYczfbhQRDVyF3G7ycBaQZAnVg1PrgA
         c/kby8ndVVExajxSDtIBva+pw17sJQDnA9Z/hbiIgO2eZPoM0h2lsspJuBRhbyLjmU0X
         Xsmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770351727; x=1770956527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kwB8GQ+jVdd4zLoHgSYFEXrmt93cdA0BGjD0ZGggFvo=;
        b=ZMnVudMrqXG6Wr0sNNwdjJ5JG2c4HwaSoNGivOeLwvSV/pU5HClzGXizAVhiQtntGd
         gBjK7qRHsq8JPl8HILDmxBAV1obCWsgnQ4VAL48lMJ0dfafVl3gU/zvDBOiFA5H9rUYC
         revMd4Bx6n+70Wk+RfudVZFsHsmz+EEIXBW8u5NF35tf/9xr4xHkMXn46VF/ypsM6tQw
         mNJjwts9cTzWhRGJFgLH2qE6bSAmFLNU8c5VkHjBE82J5fhpvah+z+EQq7xPMgTj3aaK
         F+kr6g3c0HlC361MvtknbzPq2U1eI3Qrm+quoWYppXX17j3iNFGk7JFEpSBO5mWEHshr
         fx8Q==
X-Forwarded-Encrypted: i=1; AJvYcCXJGTrk8RIVih677MXDtWC8RPQtmfyWXB9fwBMtnOlWGSQNnr2MZ4ueJV9mBtGbgTA0CvA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpDC8rIsghy7wfWaJNdFxz2DmOLP6ud9Hw4B1MJ9ZZzM/2Xbf0
	D70Qgi0l6tbWFVy1wc3Qvf9qQZAW39bBTty7tKhwRmfukt6Z2aL/TIZsifkro3lRthpM3mn8WJL
	GSf/a
X-Gm-Gg: AZuq6aJN/MgDgLcrcEsaUq9gMUvLjVxmETRyGGerzJ2HLvgijrs44g9fCs7fF7qzCMi
	NVHfj5bwwTd64fzWA7CbcyGC/VzwpKTBHflb8r8R01hX4LOKxNPKoI/vndLMtWFgx5IL9ktm9b1
	l4e7pKPqXaqD6Of2oDh0WtEns/PYvTpFztMvoNfFCujLv6TDosDnz3FV48bSRqzy8YHzi8mUtVW
	lpYtQXT7NY24SaMSGsvRexEfjjPclD/VrKcDhS7bA6UCYUiprMH/MG2qsMNVpxu/pF0VD8UrlhB
	Oop87vs2XYhETbq6NhfkuoL3rxpt9RuXgWcMVMknYY7r/eOLXA7Ef1mYyPHt1Q8L6VIzCfcfB9O
	MFwEdqMaf+gNqAqCtwrOLihQyq4Ewy1Y4DMzlPr3ne897lRvUQXUAV3kso7Hy09JelLBc3iZbgd
	QRn71gRVoW9mnGECz/xvfchhhdbpyVNGkQlN+5Q96+BwbKQ/MopZOwFQiS5bMulU5/
X-Received: by 2002:a05:6a00:94e3:b0:81f:4dc7:d31 with SMTP id d2e1a72fcca58-824416f5a0cmr1291419b3a.33.1770351727061;
        Thu, 05 Feb 2026 20:22:07 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8244168fdf5sm926914b3a.17.2026.02.05.20.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 20:22:06 -0800 (PST)
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
Subject: [PATCH v2 08/12] target/arm/tcg/psci.c: make compilation unit common
Date: Thu,  5 Feb 2026 20:21:46 -0800
Message-ID: <20260206042150.912578-9-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
References: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70417-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:email,linaro.org:dkim,linaro.org:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8C78FFA19D
X-Rspamd-Action: no action

Now that helper.h does not contain TARGET_AARCH64 identifier, we can
move forward with this file.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/psci.c      | 2 +-
 target/arm/tcg/meson.build | 5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/target/arm/tcg/psci.c b/target/arm/tcg/psci.c
index bca6058e41a..56754bde951 100644
--- a/target/arm/tcg/psci.c
+++ b/target/arm/tcg/psci.c
@@ -68,7 +68,7 @@ void arm_handle_psci_call(ARMCPU *cpu)
     CPUARMState *env = &cpu->env;
     uint64_t param[4];
     uint64_t context_id, mpidr;
-    target_ulong entry;
+    uint64_t entry;
     int32_t ret = 0;
     int i;
 
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index 41cf9bad4f1..12f126c02cd 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -49,10 +49,6 @@ arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
   'sve_helper.c',
 ))
 
-arm_system_ss.add(files(
-  'psci.c',
-))
-
 arm_system_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('cpu-v7m.c'))
 arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files('cpu-v7m.c'))
 
@@ -64,6 +60,7 @@ arm_common_system_ss.add(files(
   'cpregs-at.c',
   'hflags.c',
   'neon_helper.c',
+  'psci.c',
   'tlb_helper.c',
   'tlb-insns.c',
   'vfp_helper.c',
-- 
2.47.3



Return-Path: <kvm+bounces-11562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79EAC8784E0
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 17:19:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FBCF282FA8
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 16:19:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 824AB1756E;
	Mon, 11 Mar 2024 16:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hu3x2ARb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B0F4AEEB;
	Mon, 11 Mar 2024 16:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710173862; cv=none; b=sfN6d8wy0n2xiLoLjddo8QQCfsxt4cvEUzQFtwv+/fqHBqaJhsNZtfxvWwUxUUP9PNiYh6LgPFu81H4HO24G8fsViIwsI/amttNuryKp/9dC0YY4Lb0aGYSJndUIjdb3QWjfy1/UtkXIysT/sNkyW56GdV5WzokgvND1APAVFpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710173862; c=relaxed/simple;
	bh=jc/74af7NZP+cpnNw9Qk/swCgD9N+vE+d+7fUoVN8BQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FC10n4G1PunPTd2CDY2S0Rb+HS8N8y894uAZ3iUcQrxqUJi+xBRR7D6bm59z5mfJyJFyuKGIRsVFowVRWTcObBx+oBjFqQea3r1xCr8pUIut9TSYrlmBieHN/TcT0Yt6IL7LamH4tvuwMLlLe/8ngEtvT8PKSLJ4i7Gz5mcoKu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hu3x2ARb; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-41329b6286bso6405965e9.0;
        Mon, 11 Mar 2024 09:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710173857; x=1710778657; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5lx7gS4QP7mPyluL8Zu2ZDhyswvsRIpNUouI6tZofm4=;
        b=hu3x2ARbKuFk0x8qS0yhYQLDagcNnaR9uC2JiOONiZZGTXe1PiXPt27/PdwYKhjb55
         ogq6GExPiOqx9fjo+jtQQHsiw0ldXBjGYt4Q6WEvqJ1iSrzYjqcwMJTtaihT2oSCQswi
         6E7BxJzl1l5VfCRn9T+xagPzRRZpXLtmOOh59FLIpkSqTASaEgaiQ8Gw8EY4nqYW4HLt
         S4vJsDOQBMQUZdyTWR+P+0CqyWihHhvYYISjHvSUteG3ZSVFIm9JyM2VZWzEHPzzxE/k
         VzKklJLCMlwrWfTrvI9Hrz5bv0z+ReGJGaAi+Lfj0nehGheIbhy8AGNzeDfgXR6UiPZK
         35Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710173857; x=1710778657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5lx7gS4QP7mPyluL8Zu2ZDhyswvsRIpNUouI6tZofm4=;
        b=aKdydyQR7I6cdaUmZy6DaPrtw/xHO+EVWKIc7gYf+kT+F4mi10W5cJpYT/EJjzVoLg
         pke9vT3O+UxzND/u5jjBYP79rhh7gtellbAClJr28HbnV1tfWsGe7x8hUlobMXfk/ka/
         CsLaV2LvfB5uNsA45DuE8FVHJwQtaGowRSZIcGBYcVyL05E6O3ifh78lzZXN6R09EoeN
         DGTEljoLFXUm92BIyA5ammWNdVG1Ff2uLUE0I2uIMF02psdvt391eULEcTuiH7Bz+dDU
         gPdO9g2YyHSMslYku5jlby0NrdpVOiqST/gWFhOE6a9NXdUikUDDvsGZgIUl0bvl9hal
         jVxQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4D22VGkaJrztZzfJJW5Yj8KDvcWKV2LrYbAEN0HbvyYERkj/IvdVkzfTOGmDSh5gIBbyh7XTE+Uhm35BFveU04fiW6BdE/zsjZz4hu9D/gf68tbQGLm6hO3/9dziM/XC+bxvaXkcTEKLi9xIRm0w9cViZJDjiZRlp
X-Gm-Message-State: AOJu0YxcfQ9Ot6PQUG7PauIIiL1Gnnij2WqH4wlLjef50hSxoBtkurhH
	OauGbhTdURkA65cXXCNaogz3bRzsdUhWkYKmMuWenxajj32Yv3PU
X-Google-Smtp-Source: AGHT+IGnYShk1v+ZpEc4xRU9N5TjXvx2xTfMB9p+pJwWcXHMA9n5F9S6x1ihlL1DyRVWu7ib73UDKg==
X-Received: by 2002:a05:600c:358c:b0:413:18e7:2388 with SMTP id p12-20020a05600c358c00b0041318e72388mr4922789wmq.27.1710173856688;
        Mon, 11 Mar 2024 09:17:36 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab47:8200:c3b9:43af:f8e1:76f9])
        by smtp.gmail.com with ESMTPSA id ba14-20020a0560001c0e00b0033e96fe9479sm2823815wrb.89.2024.03.11.09.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 09:17:36 -0700 (PDT)
From: Vasant Karasulli <vsntk18@gmail.com>
To: x86@kernel.org
Cc: joro@8bytes.org,
	cfir@google.com,
	dan.j.williams@intel.com,
	dave.hansen@linux.intel.com,
	ebiederm@xmission.com,
	erdemaktas@google.com,
	hpa@zytor.com,
	jgross@suse.com,
	jslaby@suse.cz,
	keescook@chromium.org,
	kexec@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	luto@kernel.org,
	martin.b.radev@gmail.com,
	mhiramat@kernel.org,
	mstunes@vmware.com,
	nivedita@alum.mit.edu,
	peterz@infradead.org,
	rientjes@google.com,
	seanjc@google.com,
	stable@vger.kernel.org,
	thomas.lendacky@amd.com,
	virtualization@lists.linux-foundation.org,
	Joerg Roedel <jroedel@suse.de>,
	Vasant Karasulli <vkarasulli@suse.de>
Subject: [PATCH v4 3/9] x86/sev: Set GHCB data structure version
Date: Mon, 11 Mar 2024 17:17:21 +0100
Message-Id: <20240311161727.14916-4-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240311161727.14916-1-vsntk18@gmail.com>
References: <20240311161727.14916-1-vsntk18@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joerg Roedel <jroedel@suse.de>

It turned out that the GHCB->protocol field does not declare the
version of the guest-hypervisor communication protocol, but rather the
version of the GHCB data structure. Reflect that in the define used to
set the protocol field.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 arch/x86/include/asm/sev.h   | 3 +++
 arch/x86/kernel/sev-shared.c | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 5b4a1ce3d368..c48db0bfb707 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -20,6 +20,9 @@
 #define GHCB_PROTOCOL_MAX	2ULL
 #define GHCB_DEFAULT_USAGE	0ULL

+/* Version of the GHCB data structure */
+#define GHCB_VERSION		1
+
 #define	VMGEXIT()			{ asm volatile("rep; vmmcall\n\r"); }

 enum es_result {
diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index c02a087c7945..6adae48c501f 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -257,7 +257,7 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
 					  u64 exit_info_2)
 {
 	/* Fill in protocol and format specifiers */
-	ghcb->protocol_version = ghcb_version;
+	ghcb->protocol_version = GHCB_VERSION;
 	ghcb->ghcb_usage       = GHCB_DEFAULT_USAGE;

 	ghcb_set_sw_exit_code(ghcb, exit_code);
--
2.34.1



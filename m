Return-Path: <kvm+bounces-13854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C055489B8B3
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 09:42:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECF4B1C222AC
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 07:42:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 951E63AC10;
	Mon,  8 Apr 2024 07:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QlI7Q1BI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F415383A5;
	Mon,  8 Apr 2024 07:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712562070; cv=none; b=Ko5ORpDE63mcfB0InVcprIkcRk2WhFT7WPayBE4kIXrzLz01MEqBkN9pXMdMlqxCVnReTZdKvlDYsKznCfF172QnBK/EcsdVxqZJScQstq+HGVFgcj1EtTVay8aik51aTGnGz//0m1f+cSc8FKE3FvLMaVdbMHXQ5NzOABB/DSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712562070; c=relaxed/simple;
	bh=PA9tlwrHq9EaQDOrpwGW0uMmK8o23cX/zpKO//Uv5ZE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nJiDiYh+rPmmJy591/xNX25rPAcSIBNXJV2qavLHhMC4Q4STJXI+CqVH3n0peS9po0E2h9NTbeEFgcy9RN9yA8otJhfN6NtDNm0fnB088bpz/vQGXD380mBH4MVadY2uR6qGy8tsBewXGLT3F5UxK+osVVDEIMPDVX0M9b9OuGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QlI7Q1BI; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-343c2f5b50fso2725553f8f.2;
        Mon, 08 Apr 2024 00:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712562067; x=1713166867; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1lm8IoXJe0WYSRwtdxW3X+Cv5dkEchtxnhEW0S0YWJc=;
        b=QlI7Q1BIf1U+ErIUHxOVfihBU8oiUDA8gUoKVpYGa+pou3sMhBJTiqaaLlxZP9M3Qc
         g2XaNj3ooWS4a//o5uWxlWPwqSYK1N4xS2N2WMzGpajdrq5rDR/epFuqshYH7lgtfyM5
         H3s5eD6azlXX8dQHpf5OJ6J24/LdiwSMFOYKQDn2Z0l2Yvw1bwKZP/H7tPlONpx5vSMP
         h07BcxLpuaaRF0xCIUcO9k099h6EbAADh1kf6A6GvGo5XDO3/ihPz+s/iYcOk7iM1WTs
         9mc1b1kPkA5Qh3ZmeqUuyZ6Ody0pejhIPQXMRWme0KFfs1OaaePh1wqgnCt5G/V7wxZ5
         2R5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712562067; x=1713166867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1lm8IoXJe0WYSRwtdxW3X+Cv5dkEchtxnhEW0S0YWJc=;
        b=o0ti6oCsaDFDqT0KSRvCRkpk0tXTwzw+QFQzhbt5u/90oIbddKPL3qtCNgfL78xTbP
         3LYt+1WVv3AdOrdCk+2JFULFC1aiYNtumlVnAp8lgJwEvo5YL9PPSRP2qfaHaNmB9S6q
         AY82hpRnQ4wROW7eF+LM75fOomKvu5AtDfJOafQQnB5VA4vX2zF5pvhWQG5SBdO+/3PN
         0U8lT2uCi3ZEKwzKElX7/pk54+hEkMidf18WBhmvRFS4XXkFPNZ/zJgeRqoS3oRB0bzB
         iDVg0TBWclO2INkHDV7asm7fU8Ahd+fMg24Lx6HYvJmdQ3ORcUxpg/TLo95i9yN5YRVV
         fBEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjIXm9bjBsiOmAhlo5S+tmnGRTtdgY3zrd7XOLlYnkDbSR0BwLFP4FTBBpnp906wGYAg2IEVFSvtIKqCyNGYJXLbWfWdWL2HE0SwJeZ1agnSoUvVohPLd/VEteJoHjzDiDJl3zkIsWAqEEukf7n46EGzAByihCP7q5
X-Gm-Message-State: AOJu0Yy/CNsuRMw8iXWFjDOJmArFMG5VOiBqafEINNg9pBpcbW058Lo+
	HAvDPwP8FNor2ptjdUGQ+RMLjMFkHOA+NoSte3lwdGGaORYKP/4/
X-Google-Smtp-Source: AGHT+IHsw0MqJncrkEsTav8GeBQKVLnnHHhYYl9/Fi+5JZD1076agLCl079JWImEZPXFh0LSDyynKw==
X-Received: by 2002:adf:e44c:0:b0:343:d06e:51cc with SMTP id t12-20020adfe44c000000b00343d06e51ccmr5136276wrm.66.1712562067341;
        Mon, 08 Apr 2024 00:41:07 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab70:9c00:7f0b:c18e:56a6:4f2])
        by smtp.gmail.com with ESMTPSA id j3-20020adfff83000000b00341e2146b53sm8271413wrr.106.2024.04.08.00.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 00:41:06 -0700 (PDT)
From: vsntk18@gmail.com
To: x86@kernel.org
Cc: cfir@google.com,
	dan.j.williams@intel.com,
	dave.hansen@linux.intel.com,
	ebiederm@xmission.com,
	erdemaktas@google.com,
	hpa@zytor.com,
	jgross@suse.com,
	jroedel@suse.de,
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
	vkarasulli@suse.de,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	Borislav.Petkov@amd.com,
	Dhaval.Giani@amd.com
Subject: [PATCH v5 03/10] x86/sev: Set GHCB data structure version
Date: Mon,  8 Apr 2024 09:40:42 +0200
Message-Id: <20240408074049.7049-4-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240408074049.7049-1-vsntk18@gmail.com>
References: <20240408074049.7049-1-vsntk18@gmail.com>
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
index 07e125f32528..829650bdd455 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -19,6 +19,9 @@
 #define GHCB_PROTOCOL_MAX	2ULL
 #define GHCB_DEFAULT_USAGE	0ULL
 
+/* Version of the GHCB data structure */
+#define GHCB_VERSION		1
+
 #define	VMGEXIT()			{ asm volatile("rep; vmmcall\n\r"); }
 
 struct boot_params;
diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index ba51005ddde2..fb62e1582703 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -264,7 +264,7 @@ static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
 					  u64 exit_info_2)
 {
 	/* Fill in protocol and format specifiers */
-	ghcb->protocol_version = ghcb_version;
+	ghcb->protocol_version = GHCB_VERSION;
 	ghcb->ghcb_usage       = GHCB_DEFAULT_USAGE;
 
 	ghcb_set_sw_exit_code(ghcb, exit_code);
-- 
2.34.1



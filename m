Return-Path: <kvm+bounces-19167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 58CDB901F32
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 12:22:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C8BA71F21B24
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 10:22:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82BE87F7C6;
	Mon, 10 Jun 2024 10:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FTD8GdfB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7417D09D;
	Mon, 10 Jun 2024 10:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718014890; cv=none; b=Sr1rve+gISVuXoPTluvmlfNlduy7m3SjA2xo3vimT4GlV2cSGkBHVZb57z0jTLkUW2YOvnFN4Mhgof+K1qvujV2RkGyt9RuWBVStOqVqNNW/QAyVJip+MRAPBLWBrL7CPtz9hiwzkOxD8QhUa/jVvdjVlqNi5UqJa9tvkJp+vmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718014890; c=relaxed/simple;
	bh=sEdqF1TavEfxZMRrq6GYTKhkej+k4AMnxHaUkC+Lmk4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hMR0FDcKhHeE3xhneKradARRxRmAhC4GzAkyJCKs9yxZzzqvPa4T7cx5NWJftT3UfY42lwjhvNBdgY2vUAw9OJCamytzAwg65WvefEW7LXVQT5UEFgb5iAK0wg2uWiQYlGDANgigJj8OUUCQC291W36u0G10WNAs9Y4ZY70aBj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FTD8GdfB; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a6e349c0f2bso339365066b.2;
        Mon, 10 Jun 2024 03:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718014887; x=1718619687; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GCL4Vo5CEvbB78AJfWlszJwJfM4IkhVBnCtECteN90M=;
        b=FTD8GdfBNvd6ZFL0s+Mxg76Z2ybG042xjQjuS5mqs128JNWf11+Ck7forQWxcNxoFl
         g0m+F6IlUr74e7g+woLu2s7rTS6cOx6yp0B6Y6OWkTydi7DiGLqVYoevZtgAYI3+Fkjr
         haJp455SwnV44nH9bplY8YsBJoN+LG23tT7pvlnxTTldmMaq3eg7KmqsdC4SZ0Yk4FBh
         Wyz4CBOZC/YxhZJR4VPYqXX/C7vJRxsJeB/hOW41CNSEusgs9nz5smAXFKMXLbN9qPmF
         R5ZZEU+9EnHss/CjIVe6n/RyK2Y4YtnWssqVUmBflH76QYYBI3DytfR5qln0tULBwsFP
         VWWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718014887; x=1718619687;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GCL4Vo5CEvbB78AJfWlszJwJfM4IkhVBnCtECteN90M=;
        b=aomjonS3BXYAk/Ff7zmr1g1IFq476h4rpwN9ZRiXMtaJuL+dpWiEq9JX0Abmu9DQeB
         nh8ACqtz7SnoLp7EkOtm7dRZWRZ5uqtHKgwfzdthnXV7HabzPBqiAs7EjR7VA5SVSg2B
         NDkqRsJ+jTEW7tUHeuXzsgNs+zcQhAO+Tqv4islyEQrKsJMvXZH5/mL7QAXmQCahJ0mm
         ot9jUO4PQZak1xVarsqzpoZuaOUra1Az0r/6ujNvb6ianMQEyrv+NX9vufx1ZF5BNtVP
         9/NnRmHhSTDMDoow6BaF7nB5oTIRW861nd25AmGwsvC0cI/Qv2ncHwwQTHVgOv814gAt
         +43A==
X-Forwarded-Encrypted: i=1; AJvYcCXZXRu1xvqHvIzoFh68HkPL4T9chjESkk752D9BknelNmRIClJtGi8hY6JaJFpZ+3MkwZ8XS45t8RgAEYb29+ChgBLtlJWoCqXIZFwhJcF4Qefzrvmlzp61eKTVYJO/02nFB+n5OQk2ngwuYsRutfwUiLsiQhDzNxXG
X-Gm-Message-State: AOJu0YxPzdZJMxs4m5dRgbApvPZw6xQwmbSICI0eMN47sVPKVlWzch2A
	MaFT24LxDGLso8FrS9hp1M5Df8NKUcDOF/R6ZT3AFRsg/MHG/1wE3H6O+txF6u8=
X-Google-Smtp-Source: AGHT+IEU4Gid3qf0r8Bb4VtO+jH0s35ne9U0e+dRyHVRPwaSrjMvMMb+EUFXtRe7Fz4xmoBBOgq/kQ==
X-Received: by 2002:a17:906:150c:b0:a6f:eb8:801a with SMTP id a640c23a62f3a-a6f0eb884afmr308071366b.56.1718014887288;
        Mon, 10 Jun 2024 03:21:27 -0700 (PDT)
Received: from vasant-suse.fritz.box ([2001:9e8:ab68:af00:6f43:17ee:43bd:e0a9])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f0d7b35d5sm290887766b.192.2024.06.10.03.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jun 2024 03:21:26 -0700 (PDT)
From: vsntk18@gmail.com
To: vsntk18@gmail.com
Cc: x86@kernel.org,
	Borislav.Petkov@amd.com,
	Dhaval.Giani@amd.com,
	ashish.kalra@amd.com,
	cfir@google.com,
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
	michael.roth@amd.com,
	mstunes@vmware.com,
	nivedita@alum.mit.edu,
	peterz@infradead.org,
	rientjes@google.com,
	seanjc@google.com,
	stable@vger.kernel.org,
	thomas.lendacky@amd.com,
	virtualization@lists.linux-foundation.org,
	vkarasulli@suse.de
Subject: [PATCH v6 02/10] x86/sev: Save and print negotiated GHCB protocol version
Date: Mon, 10 Jun 2024 12:21:05 +0200
Message-Id: <20240610102113.20969-3-vsntk18@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240610102113.20969-1-vsntk18@gmail.com>
References: <20240610102113.20969-1-vsntk18@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joerg Roedel <jroedel@suse.de>

Save the results of the GHCB protocol negotiation into a data structure
and print information about versions supported and used to the kernel
log.

This is useful for debugging kexec issues in SEV-ES guests down the
road to quickly spot whether kexec is supported on the given host.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 arch/x86/kernel/sev-shared.c | 33 +++++++++++++++++++++++++++++++--
 arch/x86/kernel/sev.c        |  8 ++++++++
 2 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index b4f8fa0f722c..f5717eddf75b 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -23,6 +23,23 @@
 #define sev_printk_rtl(fmt, ...)
 #endif
 
+/*
+ * struct ghcb_info - Used to return GHCB protocol
+ *				   negotiation details.
+ *
+ * @hv_proto_min:	Minimum GHCB protocol version supported by Hypervisor
+ * @hv_proto_max:	Maximum GHCB protocol version supported by Hypervisor
+ * @vm_proto:		Protocol version the VM (this kernel) will use
+ */
+struct ghcb_info {
+	unsigned int hv_proto_min;
+	unsigned int hv_proto_max;
+	unsigned int vm_proto;
+};
+
+/* Negotiated GHCB protocol version */
+static struct ghcb_info ghcb_info __ro_after_init;
+
 /* I/O parameters for CPUID-related helpers */
 struct cpuid_leaf {
 	u32 fn;
@@ -159,12 +176,24 @@ static bool sev_es_negotiate_protocol(void)
 	if (GHCB_MSR_INFO(val) != GHCB_MSR_SEV_INFO_RESP)
 		return false;
 
-	if (GHCB_MSR_PROTO_MAX(val) < GHCB_PROTOCOL_MIN ||
-	    GHCB_MSR_PROTO_MIN(val) > GHCB_PROTOCOL_MAX)
+	/* Sanity check untrusted input */
+	if (GHCB_MSR_PROTO_MIN(val) > GHCB_MSR_PROTO_MAX(val))
 		return false;
 
+	/* Use maximum supported protocol version */
 	ghcb_version = min_t(size_t, GHCB_MSR_PROTO_MAX(val), GHCB_PROTOCOL_MAX);
 
+	/*
+	 * Hypervisor does not support any protocol version required for this
+	 * kernel.
+	 */
+	if (ghcb_version < GHCB_MSR_PROTO_MIN(val))
+		return false;
+
+	ghcb_info.hv_proto_min = GHCB_MSR_PROTO_MIN(val);
+	ghcb_info.hv_proto_max = GHCB_MSR_PROTO_MAX(val);
+	ghcb_info.vm_proto     = ghcb_version;
+
 	return true;
 }
 
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 3342ed58e168..f0d87549b1e1 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1399,6 +1399,14 @@ void __init sev_es_init_vc_handling(void)
 
 	/* Secondary CPUs use the runtime #VC handler */
 	initial_vc_handler = (unsigned long)kernel_exc_vmm_communication;
+
+	/*
+	 * Print information about supported and negotiated GHCB protocol
+	 * versions.
+	 */
+	pr_info("Hypervisor GHCB protocol version support: min=%u max=%u\n",
+		ghcb_info.hv_proto_min, ghcb_info.hv_proto_max);
+	pr_info("Using GHCB protocol version %u\n", ghcb_info.vm_proto);
 }
 
 static void __init vc_early_forward_exception(struct es_em_ctxt *ctxt)
-- 
2.34.1



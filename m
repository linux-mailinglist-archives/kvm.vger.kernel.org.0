Return-Path: <kvm+bounces-13853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4029C89B8AC
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 09:42:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 63C071C220F6
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 07:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B727A38F99;
	Mon,  8 Apr 2024 07:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cxsw0L7J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DB92C861;
	Mon,  8 Apr 2024 07:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712562068; cv=none; b=O8KX5xoFlLtfhH3wX/wrHmjYtVvca5Olm1SSM6vKSRulakThHJWXrr0OjbpNEUWqkZs9P+a9C7YikUSNrJQYF17/x4y3nGzCN4kXRGmjB4q3mFMF2o3qmCusUF89djacdTOTSB8HgDRLHGajjp+yK/Ic2jXONhbhJGU9tlJ0BDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712562068; c=relaxed/simple;
	bh=U3via5+ZoR4Ic6ASsrA6NJhP2Y5mxiSHxXsiW+DpVzk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pta4FBLyYEQ2apcVKf2n/mdGqjv+oAoRW3OvBk7jcC/rl81Vj1viUd5bsv8P1VYYWrsxgKZBSDDBXHyyakRArwluU61+s9zzFb56s+dWKVmvUdObaR1ttybn/8yjbyqrwX3lGA+u2gzhGFOkEh4/pu7XCX4B9W65RFE7Sb/gUF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cxsw0L7J; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-516d536f6f2so2697523e87.2;
        Mon, 08 Apr 2024 00:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712562065; x=1713166865; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZqnE+JA2AKP6TMVqtzdhtB8i3JdyW6VDhV209Iwbv/8=;
        b=Cxsw0L7Jl6QOBtUwePhPvSeVTIzgGUr8JzE6rgUEPy1yONHUhAaEhwcX2s2J/OGIHA
         /CBH54UOTjAsbAhhrc8uNwFSfJHbGSx3p4MN8T1wVtSfA6gHTRmQNLeO6pnwMssRvbuY
         Ji27EQxqlsz6lTzDkWTCXec7qBqIsf426/dNJnlRLqAhIOaywzVe5TCoCi/D0QmmtcxS
         kHqwX0vNDnpwR+eYSuQY2viZXRu046HmTqHYNKTnXfbNpXm7VVUUBEVKGt2BPsrQmF2m
         SnPsEMamYOuEQkeGwieZ02ctoAP9iuRwFN/VA+PCuSbuiqMkWuiuhGL1TodZcXy3dOCJ
         oHvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712562065; x=1713166865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZqnE+JA2AKP6TMVqtzdhtB8i3JdyW6VDhV209Iwbv/8=;
        b=NndgS14ttW+2gAnhXJpDSYDff11mZXfMGAWN3cPN0dWR/sAhGiff9d6ejN3/SLig2P
         jmKKV2x6lS2NWLS1b6eYF8MlnQDGQQWh1Oc6tUrNM2rmQtu8xoLl2bHInHo3bMXowYVQ
         HFhgydlmfth5xVA9cmJC/Kwb98NcuD2RGwjTWfdigkYmgCXbdDPiz7B2fn3nUTFrlSny
         G7LIgalzQddTpnyOYbz8/j4gpyARSNv2g6g7pr1yJjRdEAQIDDZ3cXYGNAn81Fe7c11M
         enfuIR1MBsNK0vZJcjM0YvkHiqBizgYuPmhLvMbqBu7o7jZVzVMU9BAcU4XYsOYgIuGH
         3XSw==
X-Forwarded-Encrypted: i=1; AJvYcCVj8saLTt19BMFie0wszY3YYH8E35+Gxgu18Xl8YrE7O0h4LEkqi/WCEfJ91Kol3is8WnROVlsMTDIw/+Qw6tw/JzKwVnnRComnOq8tb/VgsawCAEfwZ8Pmxkvp0px1KS084NPZYByEZ268Z8kqi4LIdBx6XNfdvqCl
X-Gm-Message-State: AOJu0Yxc/NtwmS7LPjQ9MRJkMd+KhZjo8OE3BRYNYriM0zpDDEczgEbV
	5e7pgpoID4nSmCCXCPFk0mVqrJ/qJmt6jEmVjfvnjsF9UAw/q+sd
X-Google-Smtp-Source: AGHT+IH2pJfyzX54b/TYrms4jG+/yAMqvvcGc6GwZPjgH3mJKkcZm/KCxWXEZlTYThTHzthqKdB71Q==
X-Received: by 2002:ac2:4db2:0:b0:515:d31f:ce2b with SMTP id h18-20020ac24db2000000b00515d31fce2bmr5757819lfe.15.1712562065111;
        Mon, 08 Apr 2024 00:41:05 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab70:9c00:7f0b:c18e:56a6:4f2])
        by smtp.gmail.com with ESMTPSA id j3-20020adfff83000000b00341e2146b53sm8271413wrr.106.2024.04.08.00.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 00:41:04 -0700 (PDT)
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
Subject: [PATCH v5 02/10] x86/sev: Save and print negotiated GHCB protocol version
Date: Mon,  8 Apr 2024 09:40:41 +0200
Message-Id: <20240408074049.7049-3-vsntk18@gmail.com>
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
index 8b04958da5e7..ba51005ddde2 100644
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
index 7e1e63cc48e6..098f590f7bec 100644
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



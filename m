Return-Path: <kvm+bounces-19172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 992A8901F46
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 12:24:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39E6E2810D3
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 10:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A38784FC4;
	Mon, 10 Jun 2024 10:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I5gSjAzL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B6F8286B;
	Mon, 10 Jun 2024 10:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718014903; cv=none; b=nQuhsATdFOfPMvhd7IDvLWhEIUO68DWbJDLL5qo9kWD82tjTDlzaRLAE1348mbdwPDvy9k3EvsQqtBhbuhrfOMSsp2ahlWa4nZL9nALe7AxNfnz2+DnRDDelChXSLF7bnXkd0xuOJVXkxSq+994hrA0lfjXFO5SmURc0akWhX6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718014903; c=relaxed/simple;
	bh=n/Kr224Se4bnUgaKv7FxbMglodNlFAhVuU9INti7pAw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nls+rx2oMkacrsRyWYUFOFow8Mcev7+KFnH3izpDRiLtqUE3mHueOfsP+/GzWQn83qxi/GSp+L3djXGSeLE4jgt/Keo72oc8AK6Y8kLsC9+boqcD4aQbhPPNZdWBkLFeEAHqBgX2I8BpgCgC1UeXuaXHon3PUoBCLPKdTS96M1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I5gSjAzL; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-57c681dd692so2528125a12.3;
        Mon, 10 Jun 2024 03:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718014900; x=1718619700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1h9f1jusJiCVXI0HUFRIPuyM0FJ2eMb2RD0DEq0ZSug=;
        b=I5gSjAzLEYlKsOjv4sO46wYE9oVFIsQ8/WMZVUjtuV3xZ7Z+FL9inMYMbw5/uhhuUb
         STbS06fmjsvLZ8KUGOqmKxx5VIjX4Hh+EvCVeHphBptAnj/oiwCVbAs0cdIo00TPlQsf
         8evTTQsSgA8NYyYpwm0KCuxDA4eWLteL7nurpZU2k/MPUfhAM3taHxPgfiNiIQQT4Qqp
         skLQVAKkoIDRQpVagkb/sUynE8lUdxqyynsyoKihnNV40fxPYJ4r3OAfnT9w7LPrwOnh
         hl4lWJEaB1xdX2jrUX6d0MGD8HKiynCaZyP76/ppsjjsRC2LX2I/1GfCM32Cu3R5uhZq
         /7cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718014900; x=1718619700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1h9f1jusJiCVXI0HUFRIPuyM0FJ2eMb2RD0DEq0ZSug=;
        b=lGJ+7YcNZafvcgQ1LjSv5w7Y3hemdK/2pin1MCfgv1HZu36EM1nDdzjpEQwi/wqCgS
         s2RISMucPDTJYTLpNL7kaPvu90RhudOSsmt+b43OlLZzoaTlFZGGyQ/XDFXCNV7rtLrZ
         RnoxWWJyCtFoC6a8EoTO2t7/wxUh9WY5YD/zLejmZUeJyVlBxHLe9ID+AUI8KZJx4v/B
         /jVZEICsmh9iBe830iqZU4YrSUVlXwORPirpXNX45fZYIhJyYSEgz0BPr7E6pX1J9oMK
         W4oG10nO+0kbGJD56pY0apGG7lJuoJ+5l+WQPXIUazXfl3T1fJNi4mYyIOR7RL/A/Z2k
         0SEg==
X-Forwarded-Encrypted: i=1; AJvYcCVfjW9Wv6/iGTQCpNNPolH3wRPUOGx6wGBEeyyH7cp7s50rY7TKvAUCMpzMAgUenxUCrDqDnk0WbIc/lvNY2W7tAwYuCOLXqGx2MYvO4GMsZbPRIrXmSUQS34V3L8rEy4ovzkNvu5Vv+hQzS1YjlAxje9vv1lGX5AAL
X-Gm-Message-State: AOJu0YzxI9EafbmotQ4QR+Y6X46IMPyIzYT+u6wOz4lwFulsIFTY8hKc
	Bvl+D4h5ygos1r6lyiuyk244O7iTBW1GgimVXcWdXtYu64mn86Hm
X-Google-Smtp-Source: AGHT+IFJiw9+hjS8AaCE8xUhReVnHEw0PrrFH9cPzv9TZmB9phDv2ggpsMiBf14CXAFGLO+4Z9OVRQ==
X-Received: by 2002:a17:906:fe07:b0:a6d:b66f:7b21 with SMTP id a640c23a62f3a-a6db66f7e7emr709355566b.54.1718014899942;
        Mon, 10 Jun 2024 03:21:39 -0700 (PDT)
Received: from vasant-suse.fritz.box ([2001:9e8:ab68:af00:6f43:17ee:43bd:e0a9])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f0d7b35d5sm290887766b.192.2024.06.10.03.21.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jun 2024 03:21:39 -0700 (PDT)
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
Subject: [PATCH v6 08/10] x86/sev: Handle CLFLUSH MMIO events
Date: Mon, 10 Jun 2024 12:21:11 +0200
Message-Id: <20240610102113.20969-9-vsntk18@gmail.com>
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

Handle CLFLUSH instruction to MMIO memory in the #VC handler. The
instruction is ignored by the handler, as the Hypervisor is
responsible for cache management of emulated MMIO memory.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
---
 arch/x86/include/asm/insn-eval.h | 1 +
 arch/x86/kernel/sev-shared.c     | 3 +++
 arch/x86/lib/insn-eval-shared.c  | 7 +++++++
 3 files changed, 11 insertions(+)

diff --git a/arch/x86/include/asm/insn-eval.h b/arch/x86/include/asm/insn-eval.h
index 54368a43abf6..3bcea641913a 100644
--- a/arch/x86/include/asm/insn-eval.h
+++ b/arch/x86/include/asm/insn-eval.h
@@ -40,6 +40,7 @@ enum insn_mmio_type {
 	INSN_MMIO_READ_ZERO_EXTEND,
 	INSN_MMIO_READ_SIGN_EXTEND,
 	INSN_MMIO_MOVS,
+	INSN_MMIO_IGNORE,
 };
 
 enum insn_mmio_type insn_decode_mmio(struct insn *insn, int *bytes);
diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index 1b25a6cacec7..2a963ad84f10 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -1171,6 +1171,9 @@ static enum es_result vc_handle_mmio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	if (mmio == INSN_MMIO_DECODE_FAILED)
 		return ES_DECODE_FAILED;
 
+	if (mmio == INSN_MMIO_IGNORE)
+		return ES_OK;
+
 	if (mmio != INSN_MMIO_WRITE_IMM && mmio != INSN_MMIO_MOVS) {
 		reg_data = insn_get_modrm_reg_ptr(insn, ctxt->regs);
 		if (!reg_data)
diff --git a/arch/x86/lib/insn-eval-shared.c b/arch/x86/lib/insn-eval-shared.c
index 02acdc2921ff..27fd347d84ae 100644
--- a/arch/x86/lib/insn-eval-shared.c
+++ b/arch/x86/lib/insn-eval-shared.c
@@ -906,6 +906,13 @@ enum insn_mmio_type insn_decode_mmio(struct insn *insn, int *bytes)
 				*bytes = 2;
 			type = INSN_MMIO_READ_SIGN_EXTEND;
 			break;
+		case 0xae: /* CLFLUSH */
+			/*
+			 * Ignore CLFLUSHes - those go to emulated MMIO anyway and the
+			 * hypervisor is responsible for cache management.
+			 */
+			type = INSN_MMIO_IGNORE;
+			break;
 		}
 		break;
 	}
-- 
2.34.1



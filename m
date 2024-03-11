Return-Path: <kvm+bounces-11566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E7FB8784F3
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 17:21:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2EABAB21D7D
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 16:21:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AE0C5732C;
	Mon, 11 Mar 2024 16:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="esvgywBO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064935645B;
	Mon, 11 Mar 2024 16:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710173868; cv=none; b=qBq04eqpat+9e3PXrRLwbiDTlzs9gjR8zJPl9CqQYApAcSOFmum39v6/ZRqVNPwzgk4G5bI7gjG3LsyZ9iynVLU15NkiO/TMsxbWaqd6iryzTqelW24erAYrmc14i/I5BJ2ZV+bBTjeqJ5zc5UAwJ6dVjrlbaNqlolH6OAOPb/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710173868; c=relaxed/simple;
	bh=llvDKlG/ax7CEpz4qGsKLKsgPZfmj8Qxs/13kcLEhp8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BINuQrqMD7E4MR1WN0gLDmQliKl9U99jr4BpkcrHx5duFHvsnpBXeou1a5qg26ymn2FMx35Ny95e3ACCcHMXBJhfBYwif/fP2d+LOtPGeYlgutR/lfACf4BNRhaVcL0fvpHQOpk6xq0PgcWMB5R0faDOvsrI+fD9HG02dN8Igoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=esvgywBO; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-33e94c12cfaso1139612f8f.3;
        Mon, 11 Mar 2024 09:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710173864; x=1710778664; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VD+5e2rjcMTAqm1lLiHG9HKUMBAWFA80T0od8hhMD6s=;
        b=esvgywBOx2oMmig/NNnHp7E2oywXT47ExM3+CWTjTTfuhu4T23trVLgggTm2dzp3im
         nHiy90h4RQX2kFibBn3vLdcg16kWEpjQi2VQZUT9gGTS8ACeUiaS6UXwl9/Ryqi4UIyN
         b7B/o0BNjT/vNL8OtAX4U+zdtDvLMDVlGQLQeAWBd41mQWSWjQ1acEskXnyjVZqLwR5s
         v1mxhcNzajDbtwt1VS/kzj4wFGCgNnF4xikSAqy1DtS3RNQqLWW616rEQ33JDOtI7icC
         yJCqv23lz9RkDG/+CSBAxVFQNuyCmiRjx7ygt68Tl7U+N0Y30BvJR1jgKQRSSyRNLZS8
         UqzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710173864; x=1710778664;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VD+5e2rjcMTAqm1lLiHG9HKUMBAWFA80T0od8hhMD6s=;
        b=whjVVf762YGfF1l20NWpgkesvEULp/yiILPfyJmh6t8iwLpn+BmXOXiLS3lskcoBDT
         AaJOZpu8kdZ+oKMW6lyo0FxgVIGZ33dffdO3FkbPxuiVsEaZVR3kxN1DRQ/6ZBvz+jgj
         SwehG6jgeFQMM15jcfkFulkXbHfg2THvDYdM1tTOgJMfonb7+NdQEEDRAjmk2PyoTgv9
         t+l64J5+NNKbWYssQ9QyiEQH07Ns9SIKHHCImDSyOhzPltvpB+Nv8gcSWghs2Zkynuae
         Fo5/61tCAG0MLwT9J5QPUkcafNIBkSZQbOI0TCV6n17RTrx9Yf7CIzYMEiWwppnkD5CF
         a3nw==
X-Forwarded-Encrypted: i=1; AJvYcCVRKLU8YZpzVvKYeWebIRttkV02cqfPYlUcyqL3FYeoRd6ZAGI3MxMXYOjIDUAyeWTncTSdoJm0z1YaMeOWC88lx+AyRnHZZyJK77XH5TAIltTreVpDRM6n0ZC4hAOu45UYHIV5OtNwIWL0JBlit8iQzKA0/K50pzCR
X-Gm-Message-State: AOJu0Yz+tYE0ZCC30wJy2spsaHhN/dQZ1Btok+gw9vTU0p7n66La2xp/
	VdzmLql3fBfT7iJEyLt+JyxcLJ4zcu9VUaTyvfp6Z4TFNRvg1Lyk
X-Google-Smtp-Source: AGHT+IHYTDHzYrXzvp4OecC7PPYjSNE0zn/Q41wyIcFJBRWeQZQzaCiAotWHf7DRRVcFdGjRxY3S1Q==
X-Received: by 2002:a05:6000:cd2:b0:33e:82b9:5cc7 with SMTP id dq18-20020a0560000cd200b0033e82b95cc7mr603908wrb.6.1710173864253;
        Mon, 11 Mar 2024 09:17:44 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab47:8200:c3b9:43af:f8e1:76f9])
        by smtp.gmail.com with ESMTPSA id ba14-20020a0560001c0e00b0033e96fe9479sm2823815wrb.89.2024.03.11.09.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 09:17:43 -0700 (PDT)
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
Subject: [PATCH v4 8/9] x86/sev: Handle CLFLUSH MMIO events
Date: Mon, 11 Mar 2024 17:17:26 +0100
Message-Id: <20240311161727.14916-9-vsntk18@gmail.com>
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
index e9a959c1c11d..ac0704055d58 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -1164,6 +1164,9 @@ static enum es_result vc_handle_mmio(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	if (mmio == INSN_MMIO_DECODE_FAILED)
 		return ES_DECODE_FAILED;

+	if (mmio == INSN_MMIO_IGNORE)
+		return ES_OK;
+
 	if (mmio != INSN_MMIO_WRITE_IMM && mmio != INSN_MMIO_MOVS) {
 		reg_data = insn_get_modrm_reg_ptr(insn, ctxt->regs);
 		if (!reg_data)
diff --git a/arch/x86/lib/insn-eval-shared.c b/arch/x86/lib/insn-eval-shared.c
index efc9755573db..3d71a947e562 100644
--- a/arch/x86/lib/insn-eval-shared.c
+++ b/arch/x86/lib/insn-eval-shared.c
@@ -897,6 +897,13 @@ enum insn_mmio_type insn_decode_mmio(struct insn *insn, int *bytes)
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



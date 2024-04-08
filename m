Return-Path: <kvm+bounces-13858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED00B89B8C7
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 09:43:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29F2A1C220E4
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 07:43:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 449664A9BF;
	Mon,  8 Apr 2024 07:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f9/BqaWp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA919482DB;
	Mon,  8 Apr 2024 07:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712562081; cv=none; b=BLwNC4b5y4KZrwwRv6UmzS4oAHO2uL+26svHq7vGu/+HnCHGNgPlzJRNQZb5Rdge4c5Yl05rGcNaz4WgRuM9oV2038cVQW31GeViSINurn5Fe5/Ce6C28rOl2bhujMGagaP8gP/76mz/5WhVHubUbhGkaU9GyXefLUWPart30go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712562081; c=relaxed/simple;
	bh=HH1sJn4b3V30rPMVBuHlYzoyuDIoo8e0e1oZipDtD1M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O63kiKKuAa9nLQ9TCfthOhokR0MfW9H5i8F12ttJ7ySRvZRzf0qXaPr6tkmFXjWhINy4NqMZ5cvgOxjes2Za3kKocn9oBrZtjtAWn5gumcUu6YHEG0/5zHJ6FVKP8RFgE6/25BIG8b8iG56EpDdaZ8gLJN7PJ0sc6Fmmonm4JUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f9/BqaWp; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-516d4d80d00so3050278e87.0;
        Mon, 08 Apr 2024 00:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712562078; x=1713166878; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AJPEklCzoS2DFb7f9ZXxyBC3nyK2AChPfFAIeZ8KZAI=;
        b=f9/BqaWpnL9FZAK2QZzdNA6mMlpfZkQ5i7yk7OpIl16ca+yfdPJy9zrT8ezz8GE00+
         c15kBVYY5ZZA6YDB+0h+2ySAAgoKp8DiGN3zkUvfzEEGoAE5LWKeO4E6sP7ZwmQ1tgHh
         Wwxva+rpFrQBKb9RlhO/KJytYF/0u93+heFK3x80+5nUwr72rgJ/zlcwoS07GYMgt9wh
         HeWMzIBebR7MpHjCc8oUXWcV41Z0aYPsbWEkfYWxKUdUZF8r8MG4kEzBInr3mnu3VsQV
         IO76EDFq3ghbzrDv8ltt8WG0SACEwKCV2rBO/XqQ3eoR9SWUCOH0V+MqIHvEzWiSfmkg
         54Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712562078; x=1713166878;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AJPEklCzoS2DFb7f9ZXxyBC3nyK2AChPfFAIeZ8KZAI=;
        b=MmD9Ss9e+KMliucR5xLGiR7CUOcRD1vXirfW5/YHukzNO75aPiBXMe+j+I6IzK4BTk
         PvZzpE3FFHPju+DCUPh18C2825NopoVjvZV6a0/6boTRt7z8yLkOGtpqY5Qzm9Cy1tcZ
         WHdc1FywAAjTYCUmIPsZvffQzJUVAGBObmwrZtxovKIyZLUjQkAeBTNLqUcQyW4MNeCl
         IVqhnRdUz0sBYyNUgZgKE0Nt0Co29VsNrQswQK8StFz6AkOyFhq0+N+guI3oH+8H2o29
         u3323nql8Gf7TleXCSXR4YMYwmlF/TKdSBoJv/IjP5Z5N9Kv+hqUOU/cC92ylVftYExe
         YvCw==
X-Forwarded-Encrypted: i=1; AJvYcCXN62ss7ymvZtuXkUYmLhUQO5GiON7gKASpEF5iO0/y9nesu7wVntFOFXTmeHQXyXFmv09tG9s1d36AWzUNy36anzKALhNzF7VkqFQ3I8PUiaDQzELGfDYM4LuH7FnD8mWYU6PRSJDKwpaTKgQzOa4dvrF6RNOY149i
X-Gm-Message-State: AOJu0YzzpUhhyR6FNs5aIGtxexYYKfBiXKTquXAImyK/wlIjUMO0JWbz
	lGujMEiak3Z08lmy9I8o1tW2LHzwcByvOf4959ZhqWr0OFvlTfrQ
X-Google-Smtp-Source: AGHT+IHpElUIChuykMsasXSoM3TJVl6Wfcb1bXJa6Q9tVjHiJv6DKDaFlFEqFX6ZTMlgVGGqgWRrag==
X-Received: by 2002:a05:6512:3618:b0:513:d5ea:1d21 with SMTP id f24-20020a056512361800b00513d5ea1d21mr5855791lfs.69.1712562077693;
        Mon, 08 Apr 2024 00:41:17 -0700 (PDT)
Received: from vasant-suse.suse.cz ([2001:9e8:ab70:9c00:7f0b:c18e:56a6:4f2])
        by smtp.gmail.com with ESMTPSA id j3-20020adfff83000000b00341e2146b53sm8271413wrr.106.2024.04.08.00.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 00:41:16 -0700 (PDT)
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
Subject: [PATCH v5 08/10] x86/sev: Handle CLFLUSH MMIO events
Date: Mon,  8 Apr 2024 09:40:47 +0200
Message-Id: <20240408074049.7049-9-vsntk18@gmail.com>
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
index d769f80d0264..1bffc2205480 100644
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



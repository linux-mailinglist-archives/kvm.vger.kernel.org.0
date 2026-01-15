Return-Path: <kvm+bounces-68210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 82268D26A46
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:42:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 352133051C7E
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 17:35:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 644803C1986;
	Thu, 15 Jan 2026 17:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jRksQjjq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363A93C00B1
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 17:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498475; cv=none; b=qcP4S22IfMQfYYC+UtDOf+Wj9MyLrI636vTkvSFTS6OA6o5nTsia4wM2p47r9iq7EwVcHtLlSwoqnNmI/tsfd4Q2zhPadj4V0UKgC6rSDG5O55ifx+KpulBEhtQlj7HDcHPQ5HFxPbSOLRCLrHlK/Y19Uv3SvMWsODrKBFumH24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498475; c=relaxed/simple;
	bh=Uj7+GtEca/81U0p64u8SxgUsO2V8tN4E5VdNnTgF0A4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GZby5ZWnP0WjVwA+vqVvEikRxYqBjUgEtLE0W6tgdEvRmpQ0rHyh7R8onP0Xx1sBf6IvCYTaMOa3x2uXXyFRfgDNQdO3fMEWVmrz4RnAwk17tJKy9iJB7OpZ/DzdrDCLb0dd6Wr2jYxDFw8YC8MAovgd1+LGJ4fyGG51e32QURw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jRksQjjq; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b471737e673so1624004a12.1
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 09:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768498473; x=1769103273; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wKAO8ODuqhBXZiFnU/FSWUMu1T9OYdfYIUbas+YiKfU=;
        b=jRksQjjqhTpHrGSItSI92119HBb2j+RKbSRAEcSc7gyGBNHQmXnBRoOPmRQhwnAzmf
         8+zg70Q7Y5OojGo/0JzsEuH5SPI7VQXXVQ09e8FdmnKxquf7sQghK7g2jWl0qNw7qDFM
         1JyCz2/UNL2UJlzoHU8Hw3Cb7KAexNwAe6w2IhZ6jcAvl4hVTlgQetSpYTE2HLp9G0z5
         SAi0F0eGQAvxsbl2GATNpeDUU1WABPDtN22CkUorvGygyLxpH6PjW3hT80cBWy8acVy8
         kqsI+3L9rDcjbGSpTeq5QLoygct99e18KYbIZfScnxNjRJ3XU62c2xZJ7por3kydnsf1
         TIGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768498473; x=1769103273;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wKAO8ODuqhBXZiFnU/FSWUMu1T9OYdfYIUbas+YiKfU=;
        b=fKFSo5uuVATMdSS4TWe9GkmcUOZkIxKEVSBGpvnkPacrdrHKA40sXIfaAwrhM23A4Z
         ONiykhD9G+8Cy2mPkX3hw4XSWPD+GsN+KXyvyTwR2IgWqd7oPpUc97ahR8E3A2I7z+Le
         X4H+drxSbYOf8y3+SCMKGJ1/+if49JkU1ZHdrxYPy3LbKfeUcbLEKD3nBXVNYqKPP8Dw
         767Vf7jZX4Cj93u+q2xbJ6I1/wASfqtpHcqYq12r+Y2Jt2SPa70236bVTRtVKUssfKek
         MXATnNne+GB4P/vC8R3xPfSAVBbKErjbyAkBScAigEhV1gFsLrkxB498aKjsP04rl5je
         Yqxg==
X-Gm-Message-State: AOJu0YyWtxnh5IGgyaIPyjAsm/k3JTSQPnS2zCJWf4MTOzwz69kWaCcE
	x08grwxAGxpliEhyTLmzDVZvQdREgC5zxdWnLZs3POAHJFkXwZkCezbHpFKwJmZl5PojvIub4vs
	tuPcuKQ==
X-Received: from pgjz17.prod.google.com ([2002:a63:e551:0:b0:b6b:90a5:d43])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:1796:b0:38d:f661:992c
 with SMTP id adf61e73a8af0-38dfe63cd19mr488958637.35.1768498473537; Thu, 15
 Jan 2026 09:34:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 15 Jan 2026 09:34:25 -0800
In-Reply-To: <20260115173427.716021-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260115173427.716021-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260115173427.716021-3-seanjc@google.com>
Subject: [PATCH v4 2/4] KVM: VMX: Add a wrapper around ROL16() to get a vmcs12
 from a field encoding
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Chao Gao <chao.gao@intel.com>, Xin Li <xin@zytor.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Add a wrapper macro, ENC_TO_VMCS12_IDX(), to get a vmcs12 index given a
field encoding in anticipation of adding a macro to get from a vmcs12 index
back to the field encoding.  And because open coding ROL16(n, 6) everywhere
is gross.

No functional change intended.

Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/hyperv_evmcs.c | 2 +-
 arch/x86/kvm/vmx/hyperv_evmcs.h | 2 +-
 arch/x86/kvm/vmx/vmcs.h         | 1 +
 arch/x86/kvm/vmx/vmcs12.c       | 4 ++--
 arch/x86/kvm/vmx/vmcs12.h       | 2 +-
 5 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/hyperv_evmcs.c b/arch/x86/kvm/vmx/hyperv_evmcs.c
index 904bfcd1519b..cc728c9a3de5 100644
--- a/arch/x86/kvm/vmx/hyperv_evmcs.c
+++ b/arch/x86/kvm/vmx/hyperv_evmcs.c
@@ -7,7 +7,7 @@
 #include "hyperv_evmcs.h"
 
 #define EVMCS1_OFFSET(x) offsetof(struct hv_enlightened_vmcs, x)
-#define EVMCS1_FIELD(number, name, clean_field)[ROL16(number, 6)] = \
+#define EVMCS1_FIELD(number, name, clean_field)[ENC_TO_VMCS12_IDX(number)] = \
 		{EVMCS1_OFFSET(name), clean_field}
 
 const struct evmcs_field vmcs_field_to_evmcs_1[] = {
diff --git a/arch/x86/kvm/vmx/hyperv_evmcs.h b/arch/x86/kvm/vmx/hyperv_evmcs.h
index 6536290f4274..fc7c4e7bd1bf 100644
--- a/arch/x86/kvm/vmx/hyperv_evmcs.h
+++ b/arch/x86/kvm/vmx/hyperv_evmcs.h
@@ -130,7 +130,7 @@ static __always_inline int evmcs_field_offset(unsigned long field,
 					      u16 *clean_field)
 {
 	const struct evmcs_field *evmcs_field;
-	unsigned int index = ROL16(field, 6);
+	unsigned int index = ENC_TO_VMCS12_IDX(field);
 
 	if (unlikely(index >= nr_evmcs_1_fields))
 		return -ENOENT;
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index b25625314658..9aa204c87661 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -12,6 +12,7 @@
 #include "capabilities.h"
 
 #define ROL16(val, n) ((u16)(((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))))
+#define ENC_TO_VMCS12_IDX(enc) ROL16(enc, 6)
 
 struct vmcs_hdr {
 	u32 revision_id:31;
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 4233b5ca9461..c2ac9e1a50b3 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -4,10 +4,10 @@
 #include "vmcs12.h"
 
 #define VMCS12_OFFSET(x) offsetof(struct vmcs12, x)
-#define FIELD(number, name)	[ROL16(number, 6)] = VMCS12_OFFSET(name)
+#define FIELD(number, name)	[ENC_TO_VMCS12_IDX(number)] = VMCS12_OFFSET(name)
 #define FIELD64(number, name)						\
 	FIELD(number, name),						\
-	[ROL16(number##_HIGH, 6)] = VMCS12_OFFSET(name) + sizeof(u32)
+	[ENC_TO_VMCS12_IDX(number##_HIGH)] = VMCS12_OFFSET(name) + sizeof(u32)
 
 const unsigned short vmcs12_field_offsets[] = {
 	FIELD(VIRTUAL_PROCESSOR_ID, virtual_processor_id),
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 4ad6b16525b9..7a5fdd9b27ba 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -385,7 +385,7 @@ static inline short get_vmcs12_field_offset(unsigned long field)
 	if (field >> 15)
 		return -ENOENT;
 
-	index = ROL16(field, 6);
+	index = ENC_TO_VMCS12_IDX(field);
 	if (index >= nr_vmcs12_fields)
 		return -ENOENT;
 
-- 
2.52.0.457.g6b5491de43-goog



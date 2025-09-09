Return-Path: <kvm+bounces-57142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 44F06B5071C
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 22:30:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AB283A483C
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 20:30:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A356136C071;
	Tue,  9 Sep 2025 20:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UgTRwrzG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F013680B6
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 20:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757449727; cv=none; b=jNmYhYSrouLRRFkstQLa/D52ajN+wP+sC5nslJlSmwaoQQZzlB7vB+S4HZpKgmbpskVKqaN+HzVTKv+1RiWG2z7GdM2VZfmd3wlbtoW8IunnGnpU+L7Cd9krDqG0bXNFjJ7MmZGhwoESLXAvC62Hv4alO0uzYNOzP5EwqHO7m8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757449727; c=relaxed/simple;
	bh=l1p+ajwaVGWFswKTwWM0EkrL8pc+SEJVITkZ4XN4ybI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kyzaM7U2ETyTXMnpWqQctvTkXKcbY4eC4RLUoTX4Krd82r+jW0wWsqLfI0he/6Vfz8ZoIQJURmUtXeyn2Gc43V6pX+JXfaSHubv6297mWtv7GIYn+CdwcaJXC4Ng8d4aiNec5qwsKnwP8xWAlf8s8HbNjLswgIvIHgZBHHbFoJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UgTRwrzG; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7723aca1cbcso5714020b3a.2
        for <kvm@vger.kernel.org>; Tue, 09 Sep 2025 13:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757449725; x=1758054525; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TVVFhn/odeLoh98SYAt/1c5wREWCW1GdBR24cmSPAxM=;
        b=UgTRwrzGbzYZdVTNztHQsx564NlIwwqYEm9xFoEH+tpVgsEyaKKSdwBYvX8jOV5mTY
         nXXCNMbHP2kxNt0p3PKPpPD+QzcqbqjL3d7UhavP8COua5rfpysQ1zI9UMTUQOHK5mK4
         Rg4mc/f21k/h/pcL4qdfbDVGDWsZgZyXGcEq6k0zW206fP+3iCHy9og6g7przEc8URB9
         1UyLaq77PuDaqxDxx1sLecAObLS7j+lXAK5rrnANc5Ep2Ki2GjXscOTW67uat+IAkD0J
         DFWJLBSkNGbQeKXrEEIty0lSdFBhpaHSXy35gF4tYVGLbHvks8+J0qKjk59MZbguiCTX
         vaGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757449725; x=1758054525;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TVVFhn/odeLoh98SYAt/1c5wREWCW1GdBR24cmSPAxM=;
        b=KAZCIsT2lPP86d9xKlaOVznfcRxu+Bu1GReKLm9+neWm94bOCn2UhgGV9QMj1lmEnj
         AzsefoTi+NPY7xwuGrWQdt/oyBVsXWHjojBT1iPP+Mpq7mIwZ7dDfhiPgxcJ2yB1eeLl
         8FypFriq+vgwV5xsZskXHYXgphll2Gab0ydJkh1jOycO2tVEH6M1fNaD+B9pQ5EX1QFn
         cdM2L+Lo+BT5IkM40BxBqwGT/2imdPQoy+/vRS738psX5EmkBJPvyj1hLo4AjxTxfrCy
         4RX4NUR86RLg12qwTUEwdnoTi5u2gkvJwiWA5CKxLmuHKaGCoRms7oHoNrkNjTuhcT94
         BzkA==
X-Gm-Message-State: AOJu0YwzupNRcjITz/AcTw56TiEPWgMDX7cUBIyWC89xlUsY9GJXos0V
	a0moeHCvZ1yK8JvxG0HvFiJX6vM+qwmMj+RoJIsvmvh7x1tsM9HqeEy81gbTFHfj11TPCLOorkI
	FES2/9g==
X-Google-Smtp-Source: AGHT+IH8uNMlu5Y0TjLA9EVWSsLg10Gx/gLxUasJpNUgiCjgYV16KpeaSDIBsZoEG0G6FLCAc+Hh4TDudAk=
X-Received: from pjl8.prod.google.com ([2002:a17:90b:2f88:b0:327:e697:7bdf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2583:b0:250:c76d:1cd8
 with SMTP id adf61e73a8af0-2533f8c9498mr19873101637.20.1757449725604; Tue, 09
 Sep 2025 13:28:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Sep 2025 13:28:35 -0700
In-Reply-To: <20250909202835.333554-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250909202835.333554-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909202835.333554-5-seanjc@google.com>
Subject: [PATCH 4/4] KVM: selftests: Add support for DIV and IDIV in the
 fastops test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Extend the fastops test coverage to DIV and IDIV, specifically to provide
coverage for #DE (divide error) exceptions, as #DE is the only exception
that can occur in KVM's fastops path, i.e. that requires exception fixup.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/x86/fastops_test.c  | 38 +++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/fastops_test.c b/tools/testing/selftests/kvm/x86/fastops_test.c
index 26a381c8303a..8926cfe0e209 100644
--- a/tools/testing/selftests/kvm/x86/fastops_test.c
+++ b/tools/testing/selftests/kvm/x86/fastops_test.c
@@ -92,6 +92,42 @@
 			ex_flags, insn, shift, (uint64_t)input, flags);			\
 })
 
+#define guest_execute_fastop_div(__KVM_ASM_SAFE, insn, __a, __d, __rm, __flags)		\
+({											\
+	uint64_t ign_error_code;							\
+	uint8_t vector;									\
+											\
+	__asm__ __volatile__(fastop(__KVM_ASM_SAFE(insn " %[denom]"))			\
+			     : "+a"(__a), "+d"(__d), flags_constraint(__flags),		\
+			       KVM_ASM_SAFE_OUTPUTS(vector, ign_error_code)		\
+			     : [denom]"rm"(__rm), bt_constraint(__rm)			\
+			     : "cc", "memory", KVM_ASM_SAFE_CLOBBERS);			\
+	vector;										\
+})
+
+#define guest_test_fastop_div(insn, type_t, __val1, __val2)				\
+({											\
+	type_t _a = __val1, _d = __val1, rm = __val2;					\
+	type_t a = _a, d = _d, ex_a = _a, ex_d = _d;					\
+	uint64_t flags, ex_flags;							\
+	uint8_t v, ex_v;								\
+											\
+	ex_v = guest_execute_fastop_div(KVM_ASM_SAFE, insn, ex_a, ex_d, rm, ex_flags);	\
+	v = guest_execute_fastop_div(KVM_ASM_SAFE_FEP, insn, a, d, rm, flags);		\
+											\
+	GUEST_ASSERT_EQ(v, ex_v);							\
+	__GUEST_ASSERT(v == ex_v,							\
+		       "Wanted vector 0x%x for '%s 0x%lx:0x%lx/0x%lx', got 0x%x",	\
+		       ex_v, insn, (uint64_t)_a, (uint64_t)_d, (uint64_t)rm, v);	\
+	__GUEST_ASSERT(a == ex_a && d == ex_d,						\
+		       "Wanted 0x%lx:0x%lx for '%s 0x%lx:0x%lx/0x%lx', got 0x%lx:0x%lx",\
+		       (uint64_t)ex_a, (uint64_t)ex_d, insn, (uint64_t)_a,		\
+		       (uint64_t)_d, (uint64_t)rm, (uint64_t)a, (uint64_t)d);		\
+	__GUEST_ASSERT(v || ex_v || (flags == ex_flags),				\
+			"Wanted flags 0x%lx for '%s  0x%lx:0x%lx/0x%lx', got 0x%lx",	\
+			ex_flags, insn, (uint64_t)_a, (uint64_t)_d, (uint64_t)rm, flags);\
+})
+
 static const uint64_t vals[] = {
 	0,
 	1,
@@ -141,6 +177,8 @@ if (sizeof(type_t) != 1) {							\
 			guest_test_fastop_cl("sar" suffix, type_t, vals[i], vals[j]);	\
 			guest_test_fastop_cl("shl" suffix, type_t, vals[i], vals[j]);	\
 			guest_test_fastop_cl("shr" suffix, type_t, vals[i], vals[j]);	\
+											\
+			guest_test_fastop_div("div" suffix, type_t, vals[i], vals[j]);	\
 		}									\
 	}										\
 } while (0)
-- 
2.51.0.384.g4c02a37b29-goog



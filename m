Return-Path: <kvm+bounces-2820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC68B7FE39D
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 23:49:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8CBA8B21286
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 22:49:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0416047A7E;
	Wed, 29 Nov 2023 22:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZENs0hs/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDE2D71
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 14:49:27 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5cd6a86a898so4891677b3.3
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 14:49:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701298167; x=1701902967; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bWMFxsne+gpl88lI6YduYGZQRPXK3Vk37mspokD2wHM=;
        b=ZENs0hs/af+xss6arfJvEJ5iNBhj5w5Tw0B5WLQ/ahBMHb7/kuDwrbb0l37y2gFMQ2
         IXHxvxwaTrC1GK+fm+Jwt5Iv8pBDepdDA4/JG3ymZVpq697ntXmm0ZM8fZRgYSUC7Cmt
         2CDbgAbsWRn2OFGktvMbrYV5jTQntahQ9cxHBg2wlDXxitdY0CCYZNiva8W98jWCXOxp
         FI8fjQ7klVKVPO9loK1bmfPzhRPTJ42nlgzkwWLSkxlSyOXXY+vEp+YzxfXzQOW0yCRX
         7Nt6NNsoG2FOwi3IK9rvHDmOiuKBnDDw1F/NmEYVSoD7MwpA/aj0sv7yLs3OikJqPrui
         CtzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701298167; x=1701902967;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bWMFxsne+gpl88lI6YduYGZQRPXK3Vk37mspokD2wHM=;
        b=p28oHkl81W5Q+VOWfo25tSJjrX8Qxti/ZCt88BO+IJRtBOsNalM7oRAwpYMkuMdKaJ
         WpcDG6AHAlUHc0+35XG0XaV7lrAyUDTuepikBFH2U/vM/aQSXjjAdlwx1F+Z7fN8qVQ6
         UiA6TGFwnnibdubtLf0Ow6K2ZyvGaCf/xMJEdtKMJu1+JcCUzLM8xvfl5fo6r+4RZAzl
         sDZkId4Ea3kON9zWvjU+63wWPNmcJRLRBZRhs2HWif5YsiUPZ081qmil/kjqKAxe0+Du
         6Yk/cLv2vcWna1sQCa2rpM6h+BfLazlbUdyr2AoXPHokk1u576/5M9PEa3Y6pKmwpPV3
         puTg==
X-Gm-Message-State: AOJu0YwyLxEBrSXHW3qLnesK/KZiIoGdQWwcUvxbR85+hcCjLQ6lRjYZ
	8GeH8ZHkQcyYVpoGbRvJ3R/5Vw2ju7M=
X-Google-Smtp-Source: AGHT+IFfWN+UtOLGwzsyM0bGshSYC31E3NK9PtvRfmfe+lo2abmXbvWxKKN8xpuOIW7WpNfpdw1ylMe6zJM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:be15:0:b0:5d0:a744:719a with SMTP id
 i21-20020a81be15000000b005d0a744719amr342961ywn.2.1701298167236; Wed, 29 Nov
 2023 14:49:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 29 Nov 2023 14:49:16 -0800
In-Reply-To: <20231129224916.532431-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231129224916.532431-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc1.413.gea7ed67945-goog
Message-ID: <20231129224916.532431-5-seanjc@google.com>
Subject: [PATCH v2 4/4] KVM: selftests: Annotate guest ucall, printf, and
 assert helpers with __printf()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Annotate guest printf helpers with __printf() so that the compiler will
warn about incorrect formatting at compile time (see git log for how easy
it is to screw up with the formatting).

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/test_util.h    | 2 +-
 tools/testing/selftests/kvm/include/ucall_common.h | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index a0c7dd3a5b30..71a41fa924b7 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -191,7 +191,7 @@ static inline uint32_t atoi_non_negative(const char *name, const char *num_str)
 }
 
 int guest_vsnprintf(char *buf, int n, const char *fmt, va_list args);
-int guest_snprintf(char *buf, int n, const char *fmt, ...);
+__printf(3, 4) int guest_snprintf(char *buf, int n, const char *fmt, ...);
 
 char *strdup_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2), nonnull(1)));
 
diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
index 0fb472a5a058..d9d6581b8d4f 100644
--- a/tools/testing/selftests/kvm/include/ucall_common.h
+++ b/tools/testing/selftests/kvm/include/ucall_common.h
@@ -34,9 +34,10 @@ void ucall_arch_do_ucall(vm_vaddr_t uc);
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu);
 
 void ucall(uint64_t cmd, int nargs, ...);
-void ucall_fmt(uint64_t cmd, const char *fmt, ...);
-void ucall_assert(uint64_t cmd, const char *exp, const char *file,
-		  unsigned int line, const char *fmt, ...);
+__printf(2, 3) void ucall_fmt(uint64_t cmd, const char *fmt, ...);
+__printf(5, 6) void ucall_assert(uint64_t cmd, const char *exp,
+				 const char *file, unsigned int line,
+				 const char *fmt, ...);
 uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
 void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
 int ucall_nr_pages_required(uint64_t page_size);
-- 
2.43.0.rc1.413.gea7ed67945-goog



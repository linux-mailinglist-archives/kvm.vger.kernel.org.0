Return-Path: <kvm+bounces-41135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A2DA2A624CB
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 03:41:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9993421984
	for <lists+kvm@lfdr.de>; Sat, 15 Mar 2025 02:41:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4CF2189916;
	Sat, 15 Mar 2025 02:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AZ+ZzfDx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760B6176AC5
	for <kvm@vger.kernel.org>; Sat, 15 Mar 2025 02:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742006466; cv=none; b=P8REw5tJW/jL7rY1d7TUzFATHBNOmwkAjArDUdUGUj2DOGgZy8//iOzwazSzAzmp4ymtL+T5ooBY9+JfnR+d5BExkVdxlQh/cGgVzBAqKxzCU3s2Ax8OqZcqvwxT3wdexo5pJXQrQOWPA3dT7yy/AYM4iRzbB6RQLsNb9Xr89W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742006466; c=relaxed/simple;
	bh=gvsLlj9bc8Y/r9hbCjuUIcoMB8ZWIq1plW/QuzquFqc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=dK5wo324OIBduGVYEO0CASjqs2iFaeBFdT+N2b/rJXvbV2QuHQaGjNL+bTR6wN0A6orCbpDFy7ibn7mpjbdoTzou9Ei0Bbe/Ajbz/QSlsZ2YkjYTCvtttSojkIQJQAaXsnM1JT9IGaecogstcVgP/kBZHuGVILhxsz7RgD2DV7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AZ+ZzfDx; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2254bdd4982so45240405ad.1
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 19:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742006465; x=1742611265; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QiP10EQ5oII7sHIYrQJinL/4J0tbjHxSuA2R3IlRhwA=;
        b=AZ+ZzfDx+SjcarfNXzmZTGIuSjpcJPxjvoKZgSv8cmgUGSpyT6EOk5O3uSgOAB0gE7
         r6QIs84oxttGbcjE4xw/fk3x8X9mQq+pn4BOcahL0fyOvmPAFOkNptM3ZIE6fgWakhn+
         PX1Ncfo/XLT0TZB0aLJHZA7CZKmTatKji7Oe5wVUftGiROqNtEvnlNebD5roEHRF9dps
         rvd7kImis4hhcY/dKYDtBqmK5GQW1hhYptRiFRsDTjibyGDji4DsDFrOKNfq0GQb6G1V
         J2ot5m46/111rjU4cAeNesEe5Dho+jTT4FzG+1zYrsu9re4ghuZw3463WZ3ZXZxSLt1x
         N/xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742006465; x=1742611265;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QiP10EQ5oII7sHIYrQJinL/4J0tbjHxSuA2R3IlRhwA=;
        b=G88pxI1GABTNV+gCu7sBK4BMIA1dXa43/JRShfP0l0hQr+e6Cv4Bd44IPSOv2j4pAf
         2nuLrpPC+4H6xwnBXEvnqZz3MHNtUz6RFNV7Hy1cenmerchba6swR94CdLOsWHwbDQ8S
         v9sSoCNDKE0ZvqFo6nFR+u4bdCbFK4XzryZwoR/Ar1DwrXtgTXZ/RHZhrYv7QCT1MrhA
         j/O8C5m1FqTnWvJbQ6cAzI4rr4Qu43uKayHnriqB38XTpCdst+ui7HANhnjKnSORqhuR
         HQ+s9gNwxmwLPnm4++DRpd+5FetnCBX+kx8wrJ9tGebMIUzxTqfzi2hLk+DZFAOH8+2t
         O+Gw==
X-Gm-Message-State: AOJu0YwMlUryMYDjpU6cOqdBOjkv7Zyhf4PdX1pgyJc83MqMCaF8Qe/g
	20YnidYMtY2JCq1MzzR3rSOi5php/MM5V7G+Tw75OgKZgweo2qaXErVjXdYR3e7hBFY27lx+lAZ
	S2Q==
X-Google-Smtp-Source: AGHT+IEMI0xUsGGPOON5xErQpH0hhzK7pxW1UAww271VxpwLNReHuRNE5EZwjkA9vyJADWk8JYlj/7Hjo2E=
X-Received: from pjbok3.prod.google.com ([2002:a17:90b:1d43:b0:2fb:fac8:f45b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:da85:b0:224:910:23f0
 with SMTP id d9443c01a7336-225e0b11989mr57074235ad.49.1742006464811; Fri, 14
 Mar 2025 19:41:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 14 Mar 2025 19:41:02 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250315024102.2361628-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Explicitly zero-initialize on-stack CPUID unions
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Explicitly zero/empty-initialize the unions used for PMU related CPUID
entries, instead of manually zeroing all fields (hopefully), or in the
case of 0x80000022, relying on the compiler to clobber the uninitialized
bitfields.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 5e4d4934c0d3..571c906ffcbf 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1427,8 +1427,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		}
 		break;
 	case 0xa: { /* Architectural Performance Monitoring */
-		union cpuid10_eax eax;
-		union cpuid10_edx edx;
+		union cpuid10_eax eax = { };
+		union cpuid10_edx edx = { };
 
 		if (!enable_pmu || !static_cpu_has(X86_FEATURE_ARCH_PERFMON)) {
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
@@ -1444,8 +1444,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 
 		if (kvm_pmu_cap.version)
 			edx.split.anythread_deprecated = 1;
-		edx.split.reserved1 = 0;
-		edx.split.reserved2 = 0;
 
 		entry->eax = eax.full;
 		entry->ebx = kvm_pmu_cap.events_mask;
@@ -1763,7 +1761,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		break;
 	/* AMD Extended Performance Monitoring and Debug */
 	case 0x80000022: {
-		union cpuid_0x80000022_ebx ebx;
+		union cpuid_0x80000022_ebx ebx = { };
 
 		entry->ecx = entry->edx = 0;
 		if (!enable_pmu || !kvm_cpu_cap_has(X86_FEATURE_PERFMON_V2)) {

base-commit: c9ea48bb6ee6b28bbc956c1e8af98044618fed5e
-- 
2.49.0.rc1.451.g8f38331e32-goog



Return-Path: <kvm+bounces-47560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BA65CAC20DE
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 12:22:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22681188A81D
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 10:22:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 307B722ACEE;
	Fri, 23 May 2025 10:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="yGDeLiDD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EE3226CFD
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 10:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747995678; cv=none; b=pqK3hOIPRYc6xXZDYJ/CN/jacwGArqX5LCcMYiSsNf61bFWzVIvC7iNn2U53NYoKGlGiacPHQYOH0pkgB2vcTR/5uZ5JBx8uDptY8aqmvUWqHCgNhGZEQ7f2Nnuw2rqkNKcoWQbFspzi60R3uhh8ehdW6D+K9yiIRORKCw6lfvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747995678; c=relaxed/simple;
	bh=wAx2RrhJgfovv+Ew3KxgsAkzj9v4q4meKm9RpW51ts8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mE9uxfvC31zM6hzKXE6VTBC0dej+0NdHGSbrfhjzS9+HHJSSmIUz79I6kxOq9eN1LjVHqvrOctWgbtUhmeo1r95In+IVEGDGnkkGgkB0kG/NTxv56Ko9f0ToOsyEHjpHwkX/kSzspPgthikdguf8+IOdFqZCuKe5qgOM4V8CX0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=yGDeLiDD; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7424ccbef4eso8606313b3a.2
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 03:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747995676; x=1748600476; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z13A9Xmh4hlNXDYVsXBjasLvO/5IjxZE5WiJJRlkS1s=;
        b=yGDeLiDDa6wSk1pwwlvkBwE1mZn96F1FIgH4aeYKq8ltXXvdr4RqhaE0zSSmv7DymT
         MV5Pls8HPxvbw7+VhlcX+yohkFW1BJ+7tl368LneIfWCNNpsSp9v++G1sIzP3xnFnsym
         jJ62jIAedWEn9nLclQHqSyVJN/OHm+ahHdsjFh6keODCA8BWGUZTi/UteeoDbMrsLREf
         pJQIoQCgQjw0YNScLMMNfxur8+dDqrueUcK/MSDbR5Vny6MKcTvRXbAA7xB79ztloACm
         e8GwNWcpJqZNYTKGbqUQlq2q7LpVr8QIPBF2QTwknT/u527CTovzOtxRmLvJwC4CL4iP
         ylQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747995676; x=1748600476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z13A9Xmh4hlNXDYVsXBjasLvO/5IjxZE5WiJJRlkS1s=;
        b=xByMcr2QKmMth0FSny0AsUuSQWlEP5FP0kAbmH+Dd1g9TV+xV6JB1K03ctn1Nrnx3u
         BmJHoPhmcRid4Fm92HrMiePJUJXHBUvX8Yf/WrQe17yWb5nzdjal01CJPljILfYlRyCx
         H6aQ3DOTfXQCWLgOx9b1Dd0Q56XmSIt/mYcdrytNTEjl866IZvVLG+byb1GyUHOXAbp8
         oARXKPQQYPhf68ophSAv9lKcO3L28o4WQY34DheOMKJ2m4YcyX8ON+3NBbDwqBY3XvWG
         pBvIyZCn+fUJ8ht1AdSQvNoKi9a5yak2IwSgJfI2faIjDulisIngEG0B7C6qYU3Hjn9f
         G6sQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2naiZBm4aw6wwN1IjMHbwqn3LfKZFs8Fs3rzAjE7nb6aKY3nDNr+ZnM2BYZpl4U3Zg18=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsuN94Sd1dddkIMOLWPrBSs4ezuU+Y2RaWeE23xQp/vL6d41BC
	6o/p1ekLGA7kLQV24z6ZBkb272L/GLrLmfUmO8CYGN+zainPLEOSVAbJcQtO1FQnD68=
X-Gm-Gg: ASbGnctmxU9qpWL2XzMzZVrc1B3QDBFdxYVMXqmPgH/Ocyy1AtQ9ghuaPkN971okXAQ
	uqjh3qokWilyIsfSUwqEOW7N3SwZ53yq7CfaucRiv8HEP+78bk3vKC18zzVjKPG6+66SV2msz/m
	od4/VVYz1YpgMeH2hn+JC+ZW6aPxvgbuFCWPeM4F/1LnYkmee9A2GwkvoMV4JB1vZxMngDvS5OC
	YfZjNez5tdbjkZOzrgdJKjf2UHG1yOfZJe89typYWcvuxIOw8983JL4k8JV0Chd836i8tq/+Xlh
	ZchC3Z9IzLVMWs4dqDOpYYJP3BQ5yY9AjC0gSAOhRkBjDFH2iQLCkrqWVXb1cYg=
X-Google-Smtp-Source: AGHT+IHF69bbGfugVW1hk34muZ1UxkEhf/sMPEJ/BrKkaYgUPpqT3QpHbdDEt9j8Gh0ePOgA3f704g==
X-Received: by 2002:a05:6a00:98d:b0:736:34a2:8a23 with SMTP id d2e1a72fcca58-745ed8f5d5bmr3378167b3a.15.1747995676226;
        Fri, 23 May 2025 03:21:16 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a9829ce8sm12466688b3a.118.2025.05.23.03.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 03:21:15 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Deepak Gupta <debug@rivosinc.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v8 03/14] riscv: sbi: add new SBI error mappings
Date: Fri, 23 May 2025 12:19:20 +0200
Message-ID: <20250523101932.1594077-4-cleger@rivosinc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250523101932.1594077-1-cleger@rivosinc.com>
References: <20250523101932.1594077-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A few new errors have been added with SBI V3.0, maps them as close as
possible to errno values.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/sbi.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index bb077d0c912f..0938f2a8d01b 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -536,11 +536,21 @@ static inline int sbi_err_map_linux_errno(int err)
 	case SBI_SUCCESS:
 		return 0;
 	case SBI_ERR_DENIED:
+	case SBI_ERR_DENIED_LOCKED:
 		return -EPERM;
 	case SBI_ERR_INVALID_PARAM:
+	case SBI_ERR_INVALID_STATE:
 		return -EINVAL;
+	case SBI_ERR_BAD_RANGE:
+		return -ERANGE;
 	case SBI_ERR_INVALID_ADDRESS:
 		return -EFAULT;
+	case SBI_ERR_NO_SHMEM:
+		return -ENOMEM;
+	case SBI_ERR_TIMEOUT:
+		return -ETIMEDOUT;
+	case SBI_ERR_IO:
+		return -EIO;
 	case SBI_ERR_NOT_SUPPORTED:
 	case SBI_ERR_FAILURE:
 	default:
-- 
2.49.0



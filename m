Return-Path: <kvm+bounces-58125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EF8B9B883A6
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 09:41:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4239160F41
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 07:41:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCF5C2F60AD;
	Fri, 19 Sep 2025 07:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="e6xEdJut"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1592F5315
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 07:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758267525; cv=none; b=Y4spNhzd6ZuImYSKHQAbNDtnmSC5c8hvry7Y22L010mXcgp3JZ0qQK9/i2I4vhfxLgEIvhv2j0iMVWbX6NKX2CmyFePOeMXOzQyI3fyQRdThmgBQ+EEBbrpCJhU4uQxHBMlVxr+CTeM9TwGSwJkEo3O1/GOHbFkJCwKYzXYx/34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758267525; c=relaxed/simple;
	bh=B02ziWQmo5WsV+VWudXschLhIhlEAVaMv4vSaAYkoAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cneryy5nhBc0xToMppavmdkxu3ytII5hsxYcs8Ib46PQbQOGqMUUnOzQPKVILEvMCUHt8pyaFgB1MqBf3y+OPVClqrurP7kJcARaeOhFNsmztMb0OlGszfhzpT722aWoRDiWVW5aJDxVbTIz0L9Vy8NJsGDuO8Lo79Kr5UWZGKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=e6xEdJut; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-77dedf198d4so1381074b3a.0
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 00:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758267522; x=1758872322; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nvb+N79+1rz+7OJYvNB/1WfSxRwqST+oSw7w/swSoZg=;
        b=e6xEdJutovv8vBWj0Z1OT1M/IjgwrYJQZaoDRwF4mExF/p3dQ1m30MsX1DK3o1Fip6
         Xj3d2436SVMVXkMkpsQag16ghFVSs7Y4CAxmi1KDRxEz5g769CJR3qhU09cUhVNOU23O
         cgbjf7E7dTGVIAGFm2EdYD8UMG+XI0CkT18iLrUdX4gH1Oy5cXi17keS1bij4eVUOGYH
         T72oAo0/FseOHnapMIAcJXEnkEQBoUyq2+gLxYvWVQda2rZK6fzoiCbaFDqDZl1hvCPl
         Ei1Qw6jhdxBCvYWtPTY5rSftB+bNWl9OukGZUiEKEBskQH570v/+bTdAAf8W3wn0l/yo
         DwLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758267522; x=1758872322;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nvb+N79+1rz+7OJYvNB/1WfSxRwqST+oSw7w/swSoZg=;
        b=TWD+Qv4b1AgI9Z1ZPGbkkeHcBFKEX/H7T4RocGpT32GiwOES6lEOGG+Ugaz/RkNSYT
         RWoLhtBusoVKoykznMQOoG2BV+R+HzUlBtBmOpiRF7YUCUXtwfHhgFp1KrHoU+F6vGOh
         YbCRei6CvIQRnUuh96nD8VqvjNBLqHgTbHffn4OiCKOSgzqVv0aBL1UOXFUVRYPHI2qs
         oi/GJt7huh2JxEzmEW4U0qKYw1shZAsPjLRbOgtoBbswuM+ejNQein+L72xzEHo6Oskb
         7CIBRa/rYDVbDhD7fkX3RpSsk8N/dcQ152FQvtPvoM/q13fEdW83bBnp9W+9fmVwXYvR
         4RCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyQlD4Gw3xQR7IA3ojWQDbjHNnQuyZ0qPvNGJyc4L1OOQcVsBu+XrIpWMws8hxRzNfyNU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSARXa94v/8iJJ0kJweDVQQogc0rlFpEYcBDH7mCcxgbPWKE1r
	NfeviAISTLnKer7wUmjPO8OB58S+zuTcuQdQPeME1ewOklvWBMIFuoxBOp7ArzBhpzM=
X-Gm-Gg: ASbGnctnRllCndeAL2/OaVFPXF6YMhVTPzqelzol6JzVUFZV3ZiHPMC98a6xSQeiOUm
	lf7wRs7ckiAn2+AQnsTSoWGgLvsmb3Vjq1OirQA6I8VYebf2Kn2B+/MvJRrSPzCpSujxU6TmNrr
	1EMvJu6sIVhhJBuBbuAlc+307Hech3yt4YyBdaWH7y+hUqks7zXYWGAefPxYNLbKqPak0qW6Og/
	XCwpblDimSOQwBacwPkLZmeuvNWRPZJ2DyjMw/9e+1SSp/2KGLXeMf7MnUsfo4i2XXFKmrE97TR
	7miYHlysRkwE3wCDvmtj6+f90yDlZB/McSIN1TVBrCaN78nvjNwDNcXUnZA2MEcCyNj9q68ojMs
	azoyPnI1jtmhx+K5dFI4BEgIybGMMI+64eEBLfDjl+bXKX9bh0BdEwzqu5wu9Mf4Y/wwceH2bzN
	2iu4dinxS8SiCvUTXsayJER9sX307lz++RS5wRhF1JXQ==
X-Google-Smtp-Source: AGHT+IG/JWbqV8e1pPBSIjwkXI4z09a5l0oBx141z64CDaoUW0Ejq4ZhQwv8kxbRs5Suvs4P3rGR7g==
X-Received: by 2002:a05:6a20:549d:b0:250:b053:53c5 with SMTP id adf61e73a8af0-2927405e4c0mr3586688637.51.1758267521877;
        Fri, 19 Sep 2025 00:38:41 -0700 (PDT)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.57])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b550fd7ebc7sm2679096a12.19.2025.09.19.00.38.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 19 Sep 2025 00:38:41 -0700 (PDT)
From: Xu Lu <luxu.kernel@bytedance.com>
To: corbet@lwn.net,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	will@kernel.org,
	peterz@infradead.org,
	boqun.feng@gmail.com,
	mark.rutland@arm.com,
	parri.andrea@gmail.com,
	ajones@ventanamicro.com,
	brs@rivosinc.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	pbonzini@redhat.com,
	shuah@kernel.org
Cc: devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	apw@canonical.com,
	joe@perches.com,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	Xu Lu <luxu.kernel@bytedance.com>
Subject: [PATCH v3 7/8] RISC-V: KVM: Allow Zalasr extensions for Guest/VM
Date: Fri, 19 Sep 2025 15:37:13 +0800
Message-ID: <20250919073714.83063-8-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250919073714.83063-1-luxu.kernel@bytedance.com>
References: <20250919073714.83063-1-luxu.kernel@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend the KVM ISA extension ONE_REG interface to allow KVM user space
to detect and enable Zalasr extensions for Guest/VM.

Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
---
 arch/riscv/include/uapi/asm/kvm.h | 1 +
 arch/riscv/kvm/vcpu_onereg.c      | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index ef27d4289da11..4fbc32ef888fa 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -185,6 +185,7 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZICCRSE,
 	KVM_RISCV_ISA_EXT_ZAAMO,
 	KVM_RISCV_ISA_EXT_ZALRSC,
+	KVM_RISCV_ISA_EXT_ZALASR,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index cce6a38ea54f2..6ae5f9859f25b 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -50,6 +50,7 @@ static const unsigned long kvm_isa_ext_arr[] = {
 	KVM_ISA_EXT_ARR(ZAAMO),
 	KVM_ISA_EXT_ARR(ZABHA),
 	KVM_ISA_EXT_ARR(ZACAS),
+	KVM_ISA_EXT_ARR(ZALASR),
 	KVM_ISA_EXT_ARR(ZALRSC),
 	KVM_ISA_EXT_ARR(ZAWRS),
 	KVM_ISA_EXT_ARR(ZBA),
@@ -184,6 +185,7 @@ static bool kvm_riscv_vcpu_isa_disable_allowed(unsigned long ext)
 	case KVM_RISCV_ISA_EXT_ZAAMO:
 	case KVM_RISCV_ISA_EXT_ZABHA:
 	case KVM_RISCV_ISA_EXT_ZACAS:
+	case KVM_RISCV_ISA_EXT_ZALASR:
 	case KVM_RISCV_ISA_EXT_ZALRSC:
 	case KVM_RISCV_ISA_EXT_ZAWRS:
 	case KVM_RISCV_ISA_EXT_ZBA:
-- 
2.20.1



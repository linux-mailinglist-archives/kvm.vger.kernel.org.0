Return-Path: <kvm+bounces-38340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F915A37D64
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 09:46:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52D713B10CF
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 08:46:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5E191A9B4F;
	Mon, 17 Feb 2025 08:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="mRc8ITRU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621BD1A3145
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 08:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739781914; cv=none; b=f9c6EN+izNSstncN8GNDgjUQSJlrozpXlsjHBLcaHmYUHtHfUx/XVVeUgwTfhBpa8LzmNcWkIw1AWh2hovtfC4U6IaSCMZ2RTPKwU6G7GP6SR+Fg7hazbm0y/xpASogBDEkeENJwUBenfLH353mqMYYXustAZy5abNjVoOebx9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739781914; c=relaxed/simple;
	bh=X2YvBk0sQWUhmaaDDWvnziv02HZWlNRSqMxaaAdvPBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwSgK+uczhf7aa0WfzUweWx/hJnYgJ/z+qf3j31tghRzx1VPOer9eqMMsjEu3cxaW8C7HvuORhTlfL0Cac+kK90ncxAjfPAqw2Er5CRXVZO2UnofvDKOlWk5QxfukPbbgltdRXycL7qv/R8HRu16/db/V6OrVF4sgG0VScozM6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=mRc8ITRU; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43948021a45so42291075e9.1
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 00:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1739781911; x=1740386711; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JiPZGt3cqKuKVygJ0gOXQMkedPlfCXA7o5CUpSUfKvM=;
        b=mRc8ITRU8dzxN4YKqZeOQll5vZ3CKnJm3ZR44ApEIoqTODHmdPMgD+lkb+agsdxzqn
         EdHlWbMPym3AaMf3OWuK2eX7HuDUK6fXIgK5baOfGeAbLZLlv7Eoq9WT7bIKVOpw1YGG
         BsjL+1GXKXFReZnFkSXr+D5QfCkYyEOi8TwNAioLJ1RCBE7h7JZycLh7+Nc+kfNP09kh
         VyUkeQBXtJ4AItRekxMvRblq/b7kRwhXA+LMmF3pejVdnsLGhJKs6No9e3AJqFqEA4Jl
         jrAbOBelFsXau8c7BqETgh1NW2+BzYF7gqFo2ia3N1y4erYLz794uWjdiP+ucG4yjjJg
         wAgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739781911; x=1740386711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JiPZGt3cqKuKVygJ0gOXQMkedPlfCXA7o5CUpSUfKvM=;
        b=uOa2++oHQ8MqvFjA2+GShqE+Ix5cTMthTOrtSxc2O6X5/6/kvEMSGjFP7LLn0ULdnu
         Jk931Iwqoy2AB3VL0+iXXo00RzeOU9A6DTqrti3k+X1bvOwkG0dKcvDm5XW7sY/nIQ4k
         G+jAPA32PebQ1AdDSf+T3c5rsOP0I+jSCN6z+/HzwDsr5wNPWB8AiH+NUe1kHymcro2n
         UdBzUTRLRTr2eTgR53aKvliCWPkqRQWzdNp9CwPn9qEWiH6Wg+9XY7qzhB49KStf+h5i
         KFZ1EpWj0As7Dl/D7tUTklHutmKqqDVQFul3QXkrTwap4MbgIvvPSRWfeAthu8tBRgHy
         +yZA==
X-Gm-Message-State: AOJu0Yx+YiQjDqhYJEpP2wrnsBEgIvMFFh3p4mSHXDmDNBu+E6hO/6nE
	Zk3sXmgfH0yEcxmXACYrTfCNbHrEssdBBjZpZuqFMQ2XVIkbp3ac4cR9v9LjxtnJXLJqdu9GeGT
	B
X-Gm-Gg: ASbGncvOXqem+pqAybmFHaskbhaX27IlaBOlZ5D+Hx1yynbB0fxMPNwd6QcH1E5Rg5O
	wxGSaCc1iEN3Rvx9ACXlcfM+ELQHoieNoxP2c7VsH8WehF9nKBOLkffgtKZ2BGQq6AZ8A0xJ5gx
	dueNyeFwWuVWBkHodOqqNhALN+rFftDUejGl94iVeZzNuhZIXccO0fImQ0uLnoPao01Ll7KQSSk
	FVQ/2VoufertOgRgg3hWSOdicU+6vVvTCr4K755D1g+Niz5c3a1Njh65jarStBV16YdJdwWx+GS
	alE=
X-Google-Smtp-Source: AGHT+IE+AUAR1iy2Ln8DmzcEm5nnGqOi/Plq/QkgSq3ISWZGeoiGgqYDSZCBPokxQUbiUvFLMTErfQ==
X-Received: by 2002:a05:600c:1c24:b0:439:6304:e28a with SMTP id 5b1f17b1804b1-4396e5b56e7mr95001465e9.0.1739781910716;
        Mon, 17 Feb 2025 00:45:10 -0800 (PST)
Received: from localhost ([2a02:8308:a00c:e200::766e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-439858741e9sm14517775e9.1.2025.02.17.00.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2025 00:45:10 -0800 (PST)
From: Andrew Jones <ajones@ventanamicro.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: anup@brainfault.org,
	atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	cleger@rivosinc.com
Subject: [PATCH 2/5] riscv: KVM: Fix hart suspend_type use
Date: Mon, 17 Feb 2025 09:45:09 +0100
Message-ID: <20250217084506.18763-9-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250217084506.18763-7-ajones@ventanamicro.com>
References: <20250217084506.18763-7-ajones@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The spec says suspend_type is 32 bits wide and "In case the data is
defined as 32bit wide, higher privilege software must ensure that it
only uses 32 bit data." Mask off upper bits of suspend_type before
using it.

Fixes: 763c8bed8c05 ("RISC-V: KVM: Implement SBI HSM suspend call")
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_sbi_hsm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
index 13a35eb77e8e..3070bb31745d 100644
--- a/arch/riscv/kvm/vcpu_sbi_hsm.c
+++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
@@ -9,6 +9,7 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/kvm_host.h>
+#include <linux/wordpart.h>
 #include <asm/sbi.h>
 #include <asm/kvm_vcpu_sbi.h>
 
@@ -109,7 +110,7 @@ static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		}
 		return 0;
 	case SBI_EXT_HSM_HART_SUSPEND:
-		switch (cp->a0) {
+		switch (lower_32_bits(cp->a0)) {
 		case SBI_HSM_SUSPEND_RET_DEFAULT:
 			kvm_riscv_vcpu_wfi(vcpu);
 			break;
-- 
2.48.1



Return-Path: <kvm+bounces-52285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C6047B03B3D
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 11:46:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29B85164654
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 09:46:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEFF523505E;
	Mon, 14 Jul 2025 09:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="EPweWqJ7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4AE19AD48
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 09:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752486367; cv=none; b=TYywYY8UVArN99+txWWnm7hVbHnRukcaCqwKwgc3dcUqUpk8/Dq7sLRojB/834gAKNmuycxr7A48IIXMpiwK+Cwr1fDLqCy7TE+QXForbZ7MC9wCUv/xdPdzfjnrQHUl5WA/8QUhgXtvFqFuFF8X9Pe8ORNzgH5Znr+VL+MgHIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752486367; c=relaxed/simple;
	bh=nSDiWwcKhqBcSjyKV3EIuCxjblg1mWRaJe5gw9GZdDQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ixkbQt7aW6qg16PKYNszlWa2WN24PDdFsaixAsVLxVpir29RjvQPewL6F3KmEg7x04aK3LCmYsWOoAFrCm6PpZzhYZgoXikiM5rpvHwxbeTdOY16VHGB35Qbkwenpa85THOGgJQPVdwqE8kN2a54w3UDWoglsoBuio6cMxvzecM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=EPweWqJ7; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7490cb9a892so2403129b3a.0
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 02:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1752486364; x=1753091164; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0dnf5JriQVpHQM4YNtZJFgadu2tM3f9E9KiPFuztXa0=;
        b=EPweWqJ7HGg20kQdGVRKB9YV8O/2pre0jfr1xrOznkxR8hzx86XPJ8Dx2JJVvIPsCc
         p1WuWswI9AwmsYV7XcVyiE9A967cY2F0CYgBa/q4Rwex+6HhMPXf8bH2GZyePZTKPMQy
         ZjRwDhHv5F1bLW0nKHyW+zDoTjYzcyTlVnsM2Qjw1JYPyuL8S67N//kveGksavFSJ62c
         ld6Z/Az/NlQSUhaFCRyJTbpl1FDACPiOxKPOTLQ/PbkoBEQsDeL5aULTi2NbBhXPeET4
         NGBOKpeRkdbnG63LUqMYNk1bpDFUehwNLz1YwBB1r5Mz3UooC3w7I7yl3eKf9KQJs0WU
         9DwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752486364; x=1753091164;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0dnf5JriQVpHQM4YNtZJFgadu2tM3f9E9KiPFuztXa0=;
        b=RJpHn8CHJmdIhdNFYHA7iSjyBth/yaLN1KcDbBRwnExHBPTf5G1nh/OBmaEfzCNgW1
         oSCsil/rS6NH97DQ+Qn7BEzyssBFcpmrC0zHGFLIRsZcJ9Oz540nHcheB14TKHD78FIM
         Ibyln5UdYuNNE7QL48seABppX3czcbnD9tcALm92AbRE6amjMYgHIzhJuK3OkX7EWkcC
         6zYa8PI3ZVyMjOXHPo9ZCZXJ8C4eyCxJOKaaLXkQS/ALSRLFeHxGLcoC0zwS6NTenCxa
         ZzLcYvaAKfZCdEJRYIzBmkdxKawSQLr2NsP6+PFlZawhhpdt7lGVUAKOi6GcOeI8kKrv
         Bvgw==
X-Gm-Message-State: AOJu0YxKTamr1TTPaR2mqh5XEnTqL7mVgS6J0R9jEWhkpaPE8x0QaH7F
	odJt6hh9OtDtk/kb60NtAWUmbCOvRFIfKNlHnG8/GYn45hOlIZd0W4FiV8g7W09JQvw=
X-Gm-Gg: ASbGnctqnXTizpfMVjvRvZfnUJXbk5JPU3zYPzfYfSS6zcsTBh9Oph+bG/fBxUC7chd
	NUvSXvvV0oTYMXNRi4s31SaUCG4nUxMf4Ao/hhHLrgDhG9vUHXLlCK+34yuhXJ5kGNsW48zlMTT
	6aKFVpCnCm9rlhj5r2fy+qVgxTsSUxg8np1dRM+g8M7D/na6PbH2+smE+vly9VVbvaSC6jmGHJe
	cVy2u6YkShwG14YYmcDWaCN4XtaIoQItD7k5PpQSAxGbGs9nZRfxmLbFvksHILndp/VEPLqT7xy
	lGidmRihIvsAkGu2A5ShmVALloxTJMl6QdnCei/7o1+B7VsnyWmMLcdGXdN7kUJUAmP+xbV/DMT
	+IsoWzZq7cVz+ICrM0e1pgvdnn4up8AV/zW0vDuTNzD89hpVq4d0m3tffUmcdPpLIOweCyxhVAb
	l3MnPdwwtaqg==
X-Google-Smtp-Source: AGHT+IFF990cxBBIj5rcns4ua/Z9mSLbBzTWgWQcSkoafAxgEV/F4FcvyqoXGxjBchTkM6/hWtRe9Q==
X-Received: by 2002:a05:6a00:1992:b0:747:accb:773c with SMTP id d2e1a72fcca58-74ee2c509e7mr17413857b3a.13.1752486364023;
        Mon, 14 Jul 2025 02:46:04 -0700 (PDT)
Received: from J9GPGXL7NT.bytedance.net ([61.213.176.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74eb9dd73b7sm10201283b3a.1.2025.07.14.02.45.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 14 Jul 2025 02:46:03 -0700 (PDT)
From: Xu Lu <luxu.kernel@bytedance.com>
To: rkrcmar@ventanamicro.com,
	cleger@rivosinc.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr
Cc: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Xu Lu <luxu.kernel@bytedance.com>
Subject: [PATCH v4] RISC-V: KVM: Delegate illegal instruction fault to VS mode
Date: Mon, 14 Jul 2025 17:45:54 +0800
Message-Id: <20250714094554.89151-1-luxu.kernel@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Delegate illegal instruction fault to VS mode by default to avoid such
exceptions being trapped to HS and redirected back to VS.

The delegation of illegal instruction fault is particularly important
to guest applications that use vector instructions frequently. In such
cases, an illegal instruction fault will be raised when guest user thread
uses vector instruction the first time and then guest kernel will enable
user thread to execute following vector instructions.

The fw pmu event counter remains undeleted so that guest can still query
illegal instruction events via sbi call. Guest will only see zero count
on illegal instruction faults and know 'firmware' has delegated it.

Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
---
 arch/riscv/include/asm/kvm_host.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 85cfebc32e4cf..3f6b9270f366a 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -44,6 +44,7 @@
 #define KVM_REQ_STEAL_UPDATE		KVM_ARCH_REQ(6)
 
 #define KVM_HEDELEG_DEFAULT		(BIT(EXC_INST_MISALIGNED) | \
+					 BIT(EXC_INST_ILLEGAL)     | \
 					 BIT(EXC_BREAKPOINT)      | \
 					 BIT(EXC_SYSCALL)         | \
 					 BIT(EXC_INST_PAGE_FAULT) | \
-- 
2.20.1



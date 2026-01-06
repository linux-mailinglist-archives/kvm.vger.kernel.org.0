Return-Path: <kvm+bounces-67144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EA463CF95C7
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 17:31:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DF90030454BC
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 16:29:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBD5223C503;
	Tue,  6 Jan 2026 16:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codethink.co.uk header.i=@codethink.co.uk header.b="EsE7d8+u"
X-Original-To: kvm@vger.kernel.org
Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F4D237713;
	Tue,  6 Jan 2026 16:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.40.203.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767716945; cv=none; b=gG16yETtkIqOHVvcAO1oLnff1Cg1V7xfqsfKfaUIuz2X0oFCpuYtP48J9msdIemd8kc09/SNQeyDqpZTtKHtiT1Y5v8oQRRFYiPeMhsC/oiju6LM3L4UBFzlNOKyvw9R6j6ctEauA1oHIFi43JqYpuPdOuWZ8iKlDWV0Q0oWZhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767716945; c=relaxed/simple;
	bh=HlTNhbbiS4dPP705F1qx5kyTeAvYfqot9cB8QTvI9T0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ogkHkEvHHVwdJr++hca+lQka8cd8jz28EbDUxbBtlC27qOsfodJAwZSQTBbnydiNitV6EQ0++BCNKtSH9Y/gJ7RJhwIIWaC395ymK60I4hZDEaCy51Pr3/HXHsS3xvvOWflexsfUouS8vaBSkIfCUK1ZOvLpjFPukX7WVSXjLGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codethink.co.uk; spf=pass smtp.mailfrom=codethink.com; dkim=pass (2048-bit key) header.d=codethink.co.uk header.i=@codethink.co.uk header.b=EsE7d8+u; arc=none smtp.client-ip=188.40.203.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=codethink.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codethink.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=codethink.co.uk; s=imap4-20230908; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:In-Reply-To:
	References; bh=bHuQwcVIp2YluoKe19/5U8yVgDYCi8fRyTDunT6mMgY=; b=EsE7d8+u2g5jLh
	QeXVu02ODZlF7sT12J7GdLWPxDn1EMzCAUnNr20O9sawsua4vVzYca0iGBnOwzj9bDMAt6mKFtXbX
	OMRNL4a7dIjLP/Qib4xy66oZ+G4BOnl8JeLq2+zjKD0IXMVhu9AX4wcMi/LlLP3kSOq7P+C4j6frD
	6JaKkyXEj8vl37YLiAY+o4/JEHbeQLO5u5wDY/RZ5QJ1pRQguWMGdc23jB10hnBl/MkSFjpYz8aE/
	gdN+J7FLtmB65cCLp+u40ZC6T1R+1NmFlL01SQRxJ2RHYcb6C7y6nCjMulBVpFDkqExBpl4n5EE2C
	5jkhcv0kzHvUoJDPbcaQ==;
Received: from [63.135.74.212] (helo=rainbowdash)
	by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1vd9vP-008Lo9-5M; Tue, 06 Jan 2026 16:28:51 +0000
Received: from ben by rainbowdash with local (Exim 4.99.1)
	(envelope-from <ben@rainbowdash>)
	id 1vd9vO-000000005x1-1lgE;
	Tue, 06 Jan 2026 16:28:50 +0000
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org
Cc: kvm@vger.kernel.org,
	palmer@dabbelt.com,
	pjw@kernel.org,
	anup@brainfault.org,
	atish.patra@linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH] RISC-V: KVM: fix __le64 type assignments
Date: Tue,  6 Jan 2026 16:28:48 +0000
Message-Id: <20260106162848.22866-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.37.2.352.g3c44437643
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: srv_ts003@codethink.com

The two swaps from le32/le64 in arch/riscv/include/asm/kvm_nacl.h
are generating a number of type assingment warnings in sparse, so
fix by using __force and assuming the code is correct.

Fixes a number of:

arch/riscv/kvm/vcpu.c:371:21: warning: cast to restricted __le64
arch/riscv/kvm/vcpu.c:374:16: warning: cast to restricted __le64
arch/riscv/kvm/vcpu.c:586:17: warning: incorrect type in assignment (different base types)
arch/riscv/kvm/vcpu.c:586:17:    expected unsigned long
arch/riscv/kvm/vcpu.c:586:17:    got restricted __le64 [usertype]

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 arch/riscv/include/asm/kvm_nacl.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_nacl.h b/arch/riscv/include/asm/kvm_nacl.h
index 4124d5e06a0f..2483738029cb 100644
--- a/arch/riscv/include/asm/kvm_nacl.h
+++ b/arch/riscv/include/asm/kvm_nacl.h
@@ -58,11 +58,11 @@ void kvm_riscv_nacl_exit(void);
 int kvm_riscv_nacl_init(void);
 
 #ifdef CONFIG_32BIT
-#define lelong_to_cpu(__x)	le32_to_cpu(__x)
-#define cpu_to_lelong(__x)	cpu_to_le32(__x)
+#define lelong_to_cpu(__x)	le32_to_cpu((__force __le32)__x)
+#define cpu_to_lelong(__x)	(__force unsigned long)cpu_to_le32(__x)
 #else
-#define lelong_to_cpu(__x)	le64_to_cpu(__x)
-#define cpu_to_lelong(__x)	cpu_to_le64(__x)
+#define lelong_to_cpu(__x)	le64_to_cpu((__force __le64)__x)
+#define cpu_to_lelong(__x)	(__force unsigned long)cpu_to_le64(__x)
 #endif
 
 #define nacl_shmem()							\
-- 
2.37.2.352.g3c44437643



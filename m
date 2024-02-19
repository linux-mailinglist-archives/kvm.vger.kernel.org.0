Return-Path: <kvm+bounces-9053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DA0F1859F82
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 10:20:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6A7D7B21075
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 09:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 319FA24A08;
	Mon, 19 Feb 2024 09:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a1m0F4hi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5651022F03;
	Mon, 19 Feb 2024 09:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708334424; cv=none; b=iWF8fyt0Sp19AYLOLh+z+XSdWMVEw5gRzwRLuN9A5Uw+uoJKts9UmlJOLippKOf+EKkDgJzZJHgpArAiUSXvxx+jsrWOURrUxvd54fzBokH+Ch/nQvwDAX7x8DKOv3547h8ZDfCtD0sol9hZv3rkLRTq6TRoLpOIgnCdX83hQtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708334424; c=relaxed/simple;
	bh=KX/oVgZNALTsrMNLjBJoW2oz/1yIUZB9MBfcJb7mNbQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=urccuAhBJ6sRMPLdL1eg4WetZtczP20t7WnH6QiSsTCvm6mVkwFOChBlFZEaaLZIK6KEa3PIk7xPBOkFYVN0zMahIivwbgjY+A85Iq6pwHh56oc3IT8s6Xk1wVzRtR60m6yd/O0wgtxJ0UUjpzOorfS9LJW/8FYwwxw6pqx8/Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a1m0F4hi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A69C43390;
	Mon, 19 Feb 2024 09:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708334424;
	bh=KX/oVgZNALTsrMNLjBJoW2oz/1yIUZB9MBfcJb7mNbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a1m0F4hiVbx60dhNCFW8c2yNdImKotiMvh6LmS9qtwB936taQ68HNw8O97prLYBiQ
	 uhcKz2iLT67C+vAsLRIeV31JLgMK3FHNGzvTMrzZ7hb8YsbAWaW0sMArdv4QT/BKXE
	 79LMyUX/BZnrPrEH0rDznlWEGq38MA+VPs/IDOjwwGGUYt4EpV2Rw7KdopX+dNlYkw
	 ku3JDoa9Y1vZ80u5YbEev7d4k8JfJAExN6Eaqef/H6Xvak+3oHx3Gu+TdMLs0LXk2N
	 PJ6iBt8n9lkCXW1EuDibUMcOlnwD0HQIoGgYbo3CMoFJsT9BbB2eMSrb2Pbqd4lMnl
	 6Zihn4Hi53CIQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rbzoz-004WBZ-Jb;
	Mon, 19 Feb 2024 09:20:21 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 01/13] KVM: arm64: Harden __ctxt_sys_reg() against out-of-range values
Date: Mon, 19 Feb 2024 09:20:02 +0000
Message-Id: <20240219092014.783809-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240219092014.783809-1-maz@kernel.org>
References: <20240219092014.783809-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The unsuspecting kernel tinkerer can be easily confused into
writing something that looks like this:

	ikey.lo = __vcpu_sys_reg(vcpu, SYS_APIAKEYLO_EL1);

which seems vaguely sensible, until you realise that the second
parameter is the encoding of a sysreg, and not the index into
the vcpu sysreg file... Debugging what happens in this case is
an interesting exercise in head<->wall interactions.

As they often say: "Any resemblance to actual persons, living
or dead, or actual events is purely coincidental".

In order to save people's time, add some compile-time hardening
that will at least weed out the "stupidly out of range" values.
This will *not* catch anything that isn't a compile-time constant.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 181fef12e8e8..a5ec4c7d3966 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -895,7 +895,7 @@ struct kvm_vcpu_arch {
  * Don't bother with VNCR-based accesses in the nVHE code, it has no
  * business dealing with NV.
  */
-static inline u64 *__ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
+static inline u64 *___ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
 {
 #if !defined (__KVM_NVHE_HYPERVISOR__)
 	if (unlikely(cpus_have_final_cap(ARM64_HAS_NESTED_VIRT) &&
@@ -905,6 +905,13 @@ static inline u64 *__ctxt_sys_reg(const struct kvm_cpu_context *ctxt, int r)
 	return (u64 *)&ctxt->sys_regs[r];
 }
 
+#define __ctxt_sys_reg(c,r)						\
+	({								\
+	    	BUILD_BUG_ON(__builtin_constant_p(r) &&			\
+			     (r) >= NR_SYS_REGS);			\
+		___ctxt_sys_reg(c, r);					\
+	})
+
 #define ctxt_sys_reg(c,r)	(*__ctxt_sys_reg(c,r))
 
 u64 kvm_vcpu_sanitise_vncr_reg(const struct kvm_vcpu *, enum vcpu_sysreg);
-- 
2.39.2



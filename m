Return-Path: <kvm+bounces-69078-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oM8fNHXtdmmPYwEAu9opvQ
	(envelope-from <kvm+bounces-69078-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 05:28:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7506E83E30
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 05:28:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B66EE3001FF2
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 04:28:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3DD930AAD4;
	Mon, 26 Jan 2026 04:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KqAJbh/C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B432645BE3
	for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 04:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769401715; cv=none; b=hx6DdS02FKA+AdkRM/E/p9pLeOU2ojSNPy/v3aoc4Es0iaPPPD/F4ZD0oAbJjhvIsS6bp9aFVK6i/0712vSHDq2pxFZclYNlM9gTE39gKQbBeqFv7ZXqNMagHkDMCEjJ6Uk+tIG+oj554GYk/9ArN86NheL88Usnszijaqt5sUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769401715; c=relaxed/simple;
	bh=1ZuFSCe+vFp0NZyXZ4PYxlkMiIh1KbiSsJdFrdxW20Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=W5LrsdWfPtyTADSMqIN1UuJd7vh9xYpyQhGf772AUMcTwln/q9ZUusDhkrw8a4WWxPSozo2IOUr7GMJ3VmXbUyh+XxoDpD/vNt3iKEdhuy0AtE2zXWnFUtaL5NyDw2MhsRHx4ZMpmXY1nJdlljegd0DeaOS8BOlTnGxbfKVj19E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KqAJbh/C; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-bd1ce1b35e7so2743006a12.0
        for <kvm@vger.kernel.org>; Sun, 25 Jan 2026 20:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769401713; x=1770006513; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qg7RETk35e6sk9JFD6Qoe6w7+6Mkk77ZA6XdJje9Z98=;
        b=KqAJbh/CZr7hhtf8BfHWnK9/+d4wP4UGruBo0/Z0UGyR14ZtfffiKsC28E+dzQ0Apj
         QsKqO/3HMwSnr2lepFGLrHsso1JbXsnxuVnc4u08t0fqAkUxSCEz9PZs3y3PTcV3LNar
         thEcJUK4oy9f2CmRB0uy/uknO3t4QzUpw6whEa7K0LNiHwzVkuZssdlT9KWiAsCPQjDD
         RjYJwDzwagEipjY7fbVEkMozOe5C/fqRhSli8IjGTuM9Q+hsVl1+G+ptiB+uXYxs8Gpx
         ui3HOi+NgGrC0zgz80kE15ksyVxv+UbquxRwejQ5fOF9bQPfjI9tpJncf6E1ga1+v0sn
         uEZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769401713; x=1770006513;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qg7RETk35e6sk9JFD6Qoe6w7+6Mkk77ZA6XdJje9Z98=;
        b=KjTQs6vT3HTkRvpERBPNbpFinNLZcitXtwJ793mTPpzCuJxz5iuNurIm9LUybT+DrF
         c8oYxxoPEOj9WrBfDhYj8rsgwXNUKGTaELe7kFu+ICb6Nk+1nb/a7A8c8k8bNbE52/Aq
         hmjMvMCG7YFan1lzhdI55pzl+fjfZ9adtsStZO4CYobCR+6Hoe/2yUyEtl9izQaSDMAi
         lKC3QYfvcUi5JfDaCWJTOq+yRdxHNlJX4whZJNHiQU9IHZ20k9CU/tqJiuHFimIV6Rj7
         J2fTafueAOsqGZZS+tp7lU1WjO6mT7AArQDBjxMseLPFtXZAh6nTfOdd90jt1WsvDO/C
         9BDg==
X-Forwarded-Encrypted: i=1; AJvYcCVhXP/fWRdCswN1m6lDKjVSbEoLfIwSK0ETrj3hk7nMaRFpG4F3lk2OljzM39gUMz3UX08=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzmqhbGmHW5FvEyzlNYlDTRxpXyWdKOJMdyVGPcpRUHUu27uj7
	yASRjtnjHGccbKs97PcCsoqc5T1ZLG9HrIPONwb6bzpQle1GyHlqPmqc
X-Gm-Gg: AZuq6aJtCh4p/d1pV7l1aCZLXDCIu7Fuvs+HUgLzNBmLEVXDjaYmWe76JTA1St43pI4
	GW47gvyzhlUVlvLMEbg0z5UT0Tmvkkpj63E0N3DU6w20DiuQiJloYEhhthyRNmlFzYi+MaxouMT
	nwVRcIZ6/PUjXwRiLcS3OqT8fkopXar+wTaGm+3Gd8+M65Sfkj17dPzXRty9ZQGa2cRaNzHlGPN
	cRdLZgKeL/PSL09yPLGyiARuF3v/4742M2d9ekIfM55nrraWEM2ClyWOt8xic1SYHUZjddvZxaf
	90xObMXYBOEt8YDiO8vWB41fBkMIhBhllkvHfWbqNYL+Gur84xQUxHOurp6sLcjizYzvU+VMRBG
	FRJ0UyGIo5o2P0LLRGYt9zRPsx4JON6M6ObgBajtxx35aibkRGHkeiw1/sdrgTXQ73ktwkkTre9
	vYtOASDBxfzb2zqvqd4iCe36I5PSGA96QI3yjVcinUIr6Jws8fSAk=
X-Received: by 2002:a17:90a:d603:b0:352:bd7c:ddbd with SMTP id 98e67ed59e1d1-353c4167e28mr2753120a91.23.1769401712998;
        Sun, 25 Jan 2026 20:28:32 -0800 (PST)
Received: from fric.. ([210.73.43.101])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35335215eb5sm10523533a91.5.2026.01.25.20.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jan 2026 20:28:32 -0800 (PST)
From: Jiakai Xu <jiakaipeanut@gmail.com>
X-Google-Original-From: Jiakai Xu <xujiakai2025@iscas.ac.cn>
To: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Atish Patra <atish.patra@linux.dev>,
	Anup Patel <anup@brainfault.org>,
	Jiakai Xu <xujiakai2025@iscas.ac.cn>,
	Jiakai Xu <jiakaiPeanut@gmail.com>
Subject: [PATCH v3] RISC-V: KVM: Validate SBI STA shmem alignment in kvm_sbi_ext_sta_set_reg()
Date: Mon, 26 Jan 2026 04:28:25 +0000
Message-Id: <20260126042825.2810142-1-xujiakai2025@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69078-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[ghiti.fr,eecs.berkeley.edu,dabbelt.com,kernel.org,linux.dev,brainfault.org,iscas.ac.cn,gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jiakaipeanut@gmail.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,iscas.ac.cn:mid,iscas.ac.cn:email]
X-Rspamd-Queue-Id: 7506E83E30
X-Rspamd-Action: no action

The RISC-V SBI Steal-Time Accounting (STA) extension requires the shared
memory physical address to be 64-byte aligned, and the shared memory size
to be at least 64 bytes.

KVM exposes the SBI STA shared memory configuration to userspace via
KVM_SET_ONE_REG. However, the current implementation of
kvm_sbi_ext_sta_set_reg() does not validate the alignment of the configured
shared memory address. As a result, userspace can install a misaligned
shared memory address that violates the SBI specification.

Such an invalid configuration may later reach runtime code paths that
assume a valid and properly aligned shared memory region. In particular,
KVM_RUN can trigger the following WARN_ON in
kvm_riscv_vcpu_record_steal_time():

  WARNING: arch/riscv/kvm/vcpu_sbi_sta.c:49 at
  kvm_riscv_vcpu_record_steal_time

WARN_ON paths are not expected to be reachable during normal runtime
execution, and may result in a kernel panic when panic_on_warn is enabled.

Fix this by validating the shared memory alignment at the
KVM_SET_ONE_REG boundary and rejecting misaligned configurations with
-EINVAL. The validation is performed on a temporary computed address and
only committed to vcpu->arch.sta.shmem once it is known to be valid, 
similar to the existing logic in kvm_sbi_sta_steal_time_set_shmem() and
kvm_sbi_ext_sta_handler().

With this change, invalid userspace state is rejected early and cannot
reach runtime code paths that rely on the SBI specification invariants.

A reproducer triggering the WARN_ON and the complete kernel log are
available at: https://github.com/j1akai/temp/tree/main/20260124

Fixes: f61ce890b1f074 ("RISC-V: KVM: Add support for SBI STA registers")
Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
---
V2 -> V3: Added parentheses to function name in subject.
V1 -> V2: Added Fixes tag.

 arch/riscv/kvm/vcpu_sbi_sta.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_sbi_sta.c b/arch/riscv/kvm/vcpu_sbi_sta.c
index afa0545c3bcfc..7dfe671c42eaa 100644
--- a/arch/riscv/kvm/vcpu_sbi_sta.c
+++ b/arch/riscv/kvm/vcpu_sbi_sta.c
@@ -186,23 +186,25 @@ static int kvm_sbi_ext_sta_set_reg(struct kvm_vcpu *vcpu, unsigned long reg_num,
 		return -EINVAL;
 	value = *(const unsigned long *)reg_val;
 
+	gpa_t new_shmem = vcpu->arch.sta.shmem;
+
 	switch (reg_num) {
 	case KVM_REG_RISCV_SBI_STA_REG(shmem_lo):
 		if (IS_ENABLED(CONFIG_32BIT)) {
 			gpa_t hi = upper_32_bits(vcpu->arch.sta.shmem);
 
-			vcpu->arch.sta.shmem = value;
-			vcpu->arch.sta.shmem |= hi << 32;
+			new_shmem = value;
+			new_shmem |= hi << 32;
 		} else {
-			vcpu->arch.sta.shmem = value;
+			new_shmem = value;
 		}
 		break;
 	case KVM_REG_RISCV_SBI_STA_REG(shmem_hi):
 		if (IS_ENABLED(CONFIG_32BIT)) {
 			gpa_t lo = lower_32_bits(vcpu->arch.sta.shmem);
 
-			vcpu->arch.sta.shmem = ((gpa_t)value << 32);
-			vcpu->arch.sta.shmem |= lo;
+			new_shmem = ((gpa_t)value << 32);
+			new_shmem |= lo;
 		} else if (value != 0) {
 			return -EINVAL;
 		}
@@ -210,7 +212,10 @@ static int kvm_sbi_ext_sta_set_reg(struct kvm_vcpu *vcpu, unsigned long reg_num,
 	default:
 		return -ENOENT;
 	}
+	if (new_shmem && !IS_ALIGNED(new_shmem, 64))
+		return -EINVAL;
 
+	vcpu->arch.sta.shmem = new_shmem;
 	return 0;
 }
 
-- 
2.34.1



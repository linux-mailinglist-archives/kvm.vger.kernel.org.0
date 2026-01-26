Return-Path: <kvm+bounces-69076-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KB60MvnrdmldYwEAu9opvQ
	(envelope-from <kvm+bounces-69076-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 05:22:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 777EE83DA4
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 05:22:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 561FB30010CD
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 04:22:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF18A30B535;
	Mon, 26 Jan 2026 04:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hyuh4+2O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907A529A33E
	for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 04:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769401334; cv=none; b=WGlT/V3e11wLZrYs8zXNNsBPvB0PsfucrJGUwrHeU58Os1KeOd5saWgswnhK58Q3d9HMHxcnaFVT1LSkov56zB1izwbmiW8IYgbkir7mJTLUuz43drDk9H3pHcudGl5y/bxrJhKTXgYmNYCghwhGI9qev6sSOyyM871+OqM4Vgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769401334; c=relaxed/simple;
	bh=b7vzXhNZ344WsXhALdtWAycQWLse+ilx7mZmjlgIEdk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DwgRdHn2CwVB+zeYn2ecTbNTOhwFt7Goc0jm1NyrOpKPHmJbJUOOPVCcDE7Bfic+ugnqF60tgIZ3i69GsFlvCz0iAwIcCAOwFbYNyPt+cUW240HGQbfNckEgC/BDnIZV8Dp8KJ/K8DXOFTe/bv1zy2lfvh1qxjf6amPbMWscOxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hyuh4+2O; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-29f2676bb21so42114265ad.0
        for <kvm@vger.kernel.org>; Sun, 25 Jan 2026 20:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769401331; x=1770006131; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MXMmWr4x1kiDa10LjI5HvINcv2KnVZhp4gqQTuAdZ/M=;
        b=Hyuh4+2OpQMCcpedrWvGd2RbMOLMO6d+k5FhuIzFIpg6xFJekS1fkjLp2qawH+Tzgb
         jFnb/CCftSf/flBZOuTYTTrXDg6unW0UqQdGPOPL4gx4QVy687DDEkkM+H4/++byGEZh
         DieIAsnfdVfq8L2qBD27nWIWZZ07Gfqs9qBXevhLuKJ1saqiCpwGz9nWV07h8tHfZvWG
         DK5h/q0t0j41lSfeOWDVpKUqZhHHQ0cW7Jpce+o4kHFRpj6iznUq0ErBo7a91vw0heuZ
         bI4Mga2SHrOP6HpZHHSSFGNP6RGj1OrFiCqh7QmNicHjvDjQHhyHrQquvt9yoyzH5NZI
         U9cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769401331; x=1770006131;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MXMmWr4x1kiDa10LjI5HvINcv2KnVZhp4gqQTuAdZ/M=;
        b=PmAMDWjL7oOX5gEC583mtnuL3nrldNQQJOe1d+A5zPIv2UQg+x65nbsBLFKwUOzzDH
         fch69w+0yNnviwUMkJ2Ec2PXX8eEu0aPMYUjTInYBRuPhLsJkD0bZfv5G6Ik8J/TS1wS
         CSRf0j5fRrLSXJgznkCQwc++XuJFwCbBmjdu2rdzaeI/0XUMnmDoLg1zOtuX3GkozIsX
         D+JzBcpVHJAPs2a4SPIIGHu5f6YUoOw9THJO0eDdgZa13p6SgIXk0QJbE1VXLvhBZ/YC
         u1dI6vdLBXBjtJMEBBBgGgok5l2DcRPMPuqUD96kO0peOdP5hlE7K3G54VGklahHqvD1
         aa+w==
X-Forwarded-Encrypted: i=1; AJvYcCV24lY/w/HtBsOI994WCdOVz3emAr/Nnqu0kAxElS82Y6y9Fpso/RrMRrE+SAmvGV5mzDM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7lPWf4S48DbsdEIM2K7zsgT/c8jOm9s82HbKR2xd9OXNEcLlo
	cevZLiZY5utplOKPBbb7I+pduAOD9vRWNQ4v4slYEgP7usfu8LP0v75o
X-Gm-Gg: AZuq6aJ3J2tFqvQXsUWuqacINZxkip47nWg61iWA93CFW7iIG22IVMM9Fsbi2+W6t8k
	2/TbFK9d3z4XxpW+tO83eJqODN9VC6U6JmICYB0y5vIRnsxZlgaxoUTZf49/RPTQNiJpIBVq+mV
	kL6jujStm3axWaGeLXIJbq8de2ncoKy8Qv2EtBgjnNolhtT9ar/8t1Y1eLkBoq8r7sJVZP7/0S8
	298Iu6Je4i8W4wpS4RdvpBmEBtd2Srx2aDL4tuniA3+XTMDPYBQKPl497LCGox7V+M+cg6oYoRj
	qSsmuboIWPr3cvtt2DxrimI4fB0LrhYA1veq4o9wpODsUB3XRYqFOhFb6/yBXqqgIAmxMTGNMRt
	AwRD+3XCDTVbh4pK3HSK/yEs2WNPyFidNQwJEgbXi8aYPy92XtWssrjpyrojRqLeUGPoZLfz+oz
	/9xjpdQySpYnQYlImhL/wd/v6BZrpIG1X82pxqlqBX
X-Received: by 2002:a17:902:c949:b0:298:616a:ba93 with SMTP id d9443c01a7336-2a84523fa9fmr27665945ad.9.1769401330672;
        Sun, 25 Jan 2026 20:22:10 -0800 (PST)
Received: from fric.. ([210.73.43.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802fdd0c9sm78875965ad.95.2026.01.25.20.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jan 2026 20:22:10 -0800 (PST)
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
Subject: [PATCH v2] RISC-V: KVM: Validate SBI STA shmem alignment in kvm_sbi_ext_sta_set_reg
Date: Mon, 26 Jan 2026 04:22:01 +0000
Message-Id: <20260126042201.2804148-1-xujiakai2025@iscas.ac.cn>
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
	TAGGED_FROM(0.00)[bounces-69076-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 777EE83DA4
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



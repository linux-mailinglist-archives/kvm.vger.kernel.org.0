Return-Path: <kvm+bounces-12688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9503B88BEFA
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 11:11:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C58CC1C3D512
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 10:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C696CDB6;
	Tue, 26 Mar 2024 10:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="napLaSpR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1E16F061
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 10:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711447862; cv=none; b=iQXWCKzeeut1lU9/AgOVCzHArvIhgL1k5iWXk08g7WzMb6BtTvi6YBMp/+7E95rMLaRVEqArJ46UmUkSmMDjY0KMWR3cKkLp3RT+U7vHu5a/7aNoOe1pNyZBUZd7YJVA9Hpj7HCsK8W+r2aF6QTXIoiejaaMMHpV5rfdAuGlNGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711447862; c=relaxed/simple;
	bh=luF0DePhOxP9hOcT/xfXxKnxXQoPebGiYwffl+rfHkI=;
	h=From:To:Cc:Subject:Date:Message-Id; b=JsYU8YbSnOUZ7EeyNdue0MQGuIMl2WtTkVDR4Ch1DjABywejQyezFFjAl2Yf5C/eWCtTBywEGQxIeZYsqQddScot0PfuWnHLDf6XOjyttrMVpBgVLKulNasMbgOrmH1p19SrcMShPc122E+jK7WAmxWXENrRCgUtB+W+V2+IExM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=napLaSpR; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1e0878b76f3so27408395ad.0
        for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 03:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1711447860; x=1712052660; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IiNYGBSxUvNgdPnHEJE/xU3metbwCHzJuKT0A3W7MYI=;
        b=napLaSpR4hUxSSrL5css7LToxJ7dJ9Ld/wYk1saMy7j2g2mJ+1JPH/+8oY+YHHhFO1
         rCepsIh3Cpbw9Ar8cDlhbo8Dgkj8Cb24t6lLgcLGQ6QszFELu4s2lHeRy7RtK0iFx5eQ
         NzBVHbH8skQlYyV749zEdIwznvdarL0yMDSzflBGlr4yfgMdjf+D+MFU2O1sgpHGKcOu
         5h+gm6MsMm/VZQ5VxoE7beJGRSv2VqgUaV7JOEPeDbJQQ9LTKk8xmZka3VVqE6SGg63p
         x5KzlK0aaumwAoBaSsCr+vaInki7q9hOD3Q75mJXGyuOtrdidTMfiR+ywDzC0tW5o5s7
         03Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711447860; x=1712052660;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IiNYGBSxUvNgdPnHEJE/xU3metbwCHzJuKT0A3W7MYI=;
        b=Q0Azka6+TAol84fBQ0+sf6pDUu9hfszo6hCAP1peGTLV+gcTAkILuuJ/e3AdiRdzYg
         /e1Hmlcagmjq2cejBXJZnN3/mTjQ7Yg5M1hcUTRKvXerZaZVMgnf8EO/1MwBdJ9WP2/o
         tu2M/dsm2qk8z2360zD/EQ/C3iFj1ExbF8KO9QpxEGDwCSJBE4AX64DWCqSGW2MTT3vQ
         faky91F8g1fsXK5kCrbkU/fTXpFyw+d9ZHfbrBS/SHuY8ih3C22Gt0dGoVD1yMwywtad
         zcZ8+NFpo6dHeohP6R7k8762vtCX7iJ4DE11r4qYotqX3oVqW4Xl7vuU9oWBSCo1I5/D
         5ndQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYWvGsAbzMa3YxqwJOrbHu28XJNx0hLGInAhFN7+o8ASg7u45xiXZ72t6ALvyyfP7e+XixYBL6+c9Fywp4wPQwvm1r
X-Gm-Message-State: AOJu0YxLGOjwKRQeUQD0gJXA6FkwTYKdu9JKetACsECKzfppzHavcITe
	YXrHCFsmbd8EluMm2EcQoL5XF5VRZLlo3gmmKN8hAbwLHkDXWN4v8jb+LgP+4TuJlBFrwgbTzSx
	U
X-Google-Smtp-Source: AGHT+IEqMrxzRfAQyyX5BWY+o9kj4fYO6R0c9EdEEs+a7j40uL9Tbsf27ODXSAN5Mbodl3JqSYvUug==
X-Received: by 2002:a17:902:e842:b0:1e0:188c:ad4f with SMTP id t2-20020a170902e84200b001e0188cad4fmr1519731plg.26.1711447859767;
        Tue, 26 Mar 2024 03:10:59 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id c7-20020a170903234700b001e0e2b848dbsm1633240plh.83.2024.03.26.03.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 03:10:59 -0700 (PDT)
From: Yong-Xuan Wang <yongxuan.wang@sifive.com>
To: linux-riscv@lists.infradead.org,
	kvm-riscv@lists.infradead.org
Cc: greentime.hu@sifive.com,
	vincent.chen@sifive.com,
	Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] RISC-V: KVM: Avoid lock inversion in SBI_EXT_HSM_HART_START
Date: Tue, 26 Mar 2024 18:10:52 +0800
Message-Id: <20240326101054.13088-1-yongxuan.wang@sifive.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Documentation/virt/kvm/locking.rst advises that kvm->lock should be
acquired outside vcpu->mutex and kvm->srcu. However, when KVM/RISC-V
handling SBI_EXT_HSM_HART_START, the lock ordering is vcpu->mutex,
kvm->srcu then kvm->lock.

Although the lockdep checking no longer complains about this after commit
f0f44752f5f6 ("rcu: Annotate SRCU's update-side lockdep dependencies"),
it's necessary to replace kvm->lock with a new dedicated lock to ensure
only one hart can execute the SBI_EXT_HSM_HART_START call for the target
hart simultaneously.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
---
 arch/riscv/include/asm/kvm_host.h | 1 +
 arch/riscv/kvm/vcpu.c             | 1 +
 arch/riscv/kvm/vcpu_sbi_hsm.c     | 5 ++---
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 484d04a92fa6..537099413344 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -254,6 +254,7 @@ struct kvm_vcpu_arch {
 
 	/* VCPU power-off state */
 	bool power_off;
+	struct mutex hsm_start_lock;
 
 	/* Don't run the VCPU (blocked) */
 	bool pause;
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index b5ca9f2e98ac..4d89b5b5afbf 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -119,6 +119,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	spin_lock_init(&vcpu->arch.hfence_lock);
 
 	/* Setup reset state of shadow SSTATUS and HSTATUS CSRs */
+	mutex_init(&vcpu->arch.hsm_start_lock);
 	cntx = &vcpu->arch.guest_reset_context;
 	cntx->sstatus = SR_SPP | SR_SPIE;
 	cntx->hstatus = 0;
diff --git a/arch/riscv/kvm/vcpu_sbi_hsm.c b/arch/riscv/kvm/vcpu_sbi_hsm.c
index 7dca0e9381d9..b528f6e880ae 100644
--- a/arch/riscv/kvm/vcpu_sbi_hsm.c
+++ b/arch/riscv/kvm/vcpu_sbi_hsm.c
@@ -71,14 +71,13 @@ static int kvm_sbi_ext_hsm_handler(struct kvm_vcpu *vcpu, struct kvm_run *run,
 {
 	int ret = 0;
 	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
-	struct kvm *kvm = vcpu->kvm;
 	unsigned long funcid = cp->a6;
 
 	switch (funcid) {
 	case SBI_EXT_HSM_HART_START:
-		mutex_lock(&kvm->lock);
+		mutex_lock(&vcpu->arch.hsm_start_lock);
 		ret = kvm_sbi_hsm_vcpu_start(vcpu);
-		mutex_unlock(&kvm->lock);
+		mutex_unlock(&vcpu->arch.hsm_start_lock);
 		break;
 	case SBI_EXT_HSM_HART_STOP:
 		ret = kvm_sbi_hsm_vcpu_stop(vcpu);
-- 
2.17.1



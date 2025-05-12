Return-Path: <kvm+bounces-46194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BFFEAB41AF
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:10:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFA52862565
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:07:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 122D3298CB4;
	Mon, 12 May 2025 18:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V8F4QJe5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECEA298CA2
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073070; cv=none; b=F0EfY48eIhB5//mxSCEFtWth2gEbOrfB6fY8mBfmZ2GuPamfrrnlYWd/UTWLEL74ZC93VzcgQ22o59HhS16z9EYIG2GuTQxVNpePGU8t6o6TZ/ey5wuMXcfw+RzYDC7WjK4V+quwD02YlU3MFVwxWQjbtOTFB9WezLSyf+M71xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073070; c=relaxed/simple;
	bh=01AxGl5y9sewo+AjNmG3P95dBC2IXR63aHqvqvehehg=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=gidgaWQ366NX3J4cVX+Krp67bovnMN3zNhfT9YtIXcYJMQd6SNq9UlQ3b/JqSmJn9AOAu3FvrLccrVMaHobSA+fFQa0Zn8jlNpDum8aRe6umCoTuW3e1hxyHfUFtouS6K/yrvB8d0w12OiuWgeqot6uPElPAYXkXXEKtyTvR3pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V8F4QJe5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747073067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Jzez9beQL600E+agH2Z2p3TWupq3wuiKJM0KPUz5arQ=;
	b=V8F4QJe59ykqnfEiGTgloV1W9QpVYkAT/gji7ZkLvAX2NY75areriaiDqrIhWjNFsHxZwf
	vDnMi/8BIThAivEUenzm3yPMjMxK4Ccd4Hx8ZJ3PxF0FQU+tZWp5+tD5GtlUXewRCu3TkL
	YPhVZPcPqRE2mTvNB/HUcZC3YZG73qU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-617-Mc8z2qJpM0WcOmyyGPFIow-1; Mon,
 12 May 2025 14:04:25 -0400
X-MC-Unique: Mc8z2qJpM0WcOmyyGPFIow-1
X-Mimecast-MFC-AGG-ID: Mc8z2qJpM0WcOmyyGPFIow_1747073061
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7837C1800263;
	Mon, 12 May 2025 18:04:17 +0000 (UTC)
Received: from intellaptop.lan (unknown [10.22.80.5])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B909630002D4;
	Mon, 12 May 2025 18:04:08 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jing Zhang <jingzhangos@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sebastian Ott <sebott@redhat.com>,
	Shusen Li <lishusen2@huawei.com>,
	Waiman Long <longman@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Bjorn Helgaas <bhelgaas@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Anup Patel <anup@brainfault.org>,
	Will Deacon <will@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexander Potapenko <glider@google.com>,
	kvmarm@lists.linux.dev,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Atish Patra <atishp@atishpatra.org>,
	Joey Gouly <joey.gouly@arm.com>,
	x86@kernel.org,
	Marc Zyngier <maz@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	linux-riscv@lists.infradead.org,
	Randy Dunlap <rdunlap@infradead.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	kvm-riscv@lists.infradead.org,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH v5 0/6] KVM: lockdep improvements
Date: Mon, 12 May 2025 14:04:01 -0400
Message-ID: <20250512180407.659015-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

This is	a continuation of my 'extract lock_all_vcpus/unlock_all_vcpus'=0D
patch series.=0D
=0D
Implement the suggestion of using lockdep's "nest_lock" feature=0D
when locking all KVM vCPUs by adding mutex_trylock_nest_lock() and=0D
mutex_lock_killable_nest_lock() and use these functions	in the=0D
implementation of the=0D
kvm_trylock_all_vcpus()/kvm_lock_all_vcpus()/kvm_unlock_all_vcpus().=0D
=0D
Those changes allow removal of a custom workaround that was needed to=0D
silence the lockdep warning in the SEV code and also stop lockdep from=0D
complaining in case of ARM and RISC-V code which doesn't include the above=
=0D
mentioned workaround.=0D
=0D
Finally, it's worth noting that this patch series removes a fair=0D
amount of duplicate code by implementing the logic in one place.=0D
=0D
V5: addressed review feedback.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (6):=0D
  locking/mutex: implement mutex_trylock_nested=0D
  locking/mutex: implement mutex_lock_killable_nest_lock=0D
  KVM: add kvm_lock_all_vcpus and kvm_trylock_all_vcpus=0D
  x86: KVM: SVM: use kvm_lock_all_vcpus instead of a custom=0D
    implementation=0D
  KVM: arm64: use kvm_trylock_all_vcpus when locking all vCPUs=0D
  RISC-V: KVM: use kvm_trylock_all_vcpus when locking all vCPUs=0D
=0D
 arch/arm64/include/asm/kvm_host.h     |  3 --=0D
 arch/arm64/kvm/arch_timer.c           |  4 +-=0D
 arch/arm64/kvm/arm.c                  | 43 ----------------=0D
 arch/arm64/kvm/vgic/vgic-init.c       |  4 +-=0D
 arch/arm64/kvm/vgic/vgic-its.c        |  8 +--=0D
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 12 ++---=0D
 arch/riscv/kvm/aia_device.c           | 34 +------------=0D
 arch/x86/kvm/svm/sev.c                | 72 ++-------------------------=0D
 include/linux/kvm_host.h              |  4 ++=0D
 include/linux/mutex.h                 | 32 ++++++++++--=0D
 kernel/locking/mutex.c                | 21 +++++---=0D
 virt/kvm/kvm_main.c                   | 59 ++++++++++++++++++++++=0D
 12 files changed, 126 insertions(+), 170 deletions(-)=0D
=0D
-- =0D
2.46.0=0D
=0D



Return-Path: <kvm+bounces-42975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F351A81A99
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 03:42:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64F5F463FCE
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 01:42:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 326AF18E02A;
	Wed,  9 Apr 2025 01:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="inceCzIt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7E974BE1
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 01:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744162922; cv=none; b=E2EZBuMOiSMIs/BBKCOjUhirgW16zeIKHkuG7qnz89ZwXp5qqJVobGq5SzICTxe0f4ADdbRXg0tTM+Bw5BsKyZYXACKYMQlNxOhiLPcPu+q/IQQfgy7vlXIyODzGFoVR2LUmbp+Vb4V61NQkRGGh95DXjYiJdVD1cG5L04VyplM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744162922; c=relaxed/simple;
	bh=M6+JHTMLirdHgfsu4jILyYY17aKoZ08gBQKxLSPjs1I=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=NEDJckaB85BxhjA0CG8jmA15qqxwMw9/1Dn9oOkOHOM6lXmZ53mBTex0CXmRphjBpKhPXkHyk0wxHxjIRtD0Gwfls8ZJqtczqHGWMetgEwl/a5GR4jS3vM4CF+b3Tp5hUds9iDbV7Ya9bDxUaelXiYldIztZVoUVOy5hBXl70HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=inceCzIt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744162918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=aQ15qGlUaptB7o2KXAcGTjz0KUPJ/e9c4/mMMMjkWT0=;
	b=inceCzItkDG1zzOacl0paGZsNx7yTX7SuXZxbXCbKQO6jpZPoJWpd0GJGyfoXk4j04J9nd
	JfQm5MYHPKuR2nxLsANvce48rWlNWGcN9R/Hpp1bw74IoBlvmpX6UJc+q+StTArcxfBf3Q
	akfMHjSWqVYGKGp7IRYX4jCTxTC4K34=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-22-BxhD3ttkMn6I5gCM8qizgw-1; Tue,
 08 Apr 2025 21:41:55 -0400
X-MC-Unique: BxhD3ttkMn6I5gCM8qizgw-1
X-Mimecast-MFC-AGG-ID: BxhD3ttkMn6I5gCM8qizgw_1744162908
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 67A651800259;
	Wed,  9 Apr 2025 01:41:45 +0000 (UTC)
Received: from starship.lan (unknown [10.22.65.191])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 22646180175B;
	Wed,  9 Apr 2025 01:41:37 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvm-riscv@lists.infradead.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jing Zhang <jingzhangos@google.com>,
	Waiman Long <longman@redhat.com>,
	x86@kernel.org,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Albert Ou <aou@eecs.berkeley.edu>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Zenghui Yu <yuzenghui@huawei.com>,
	Borislav Petkov <bp@alien8.de>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Sebastian Ott <sebott@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Will Deacon <will@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	linux-riscv@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sean Christopherson <seanjc@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v2 0/4] KVM: extract lock_all_vcpus/unlock_all_vcpus
Date: Tue,  8 Apr 2025 21:41:32 -0400
Message-Id: <20250409014136.2816971-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Implement Paolo's suggestion of reusing=0D
sev_lock/unlock_vcpus_for_migration in arm and riscv code=0D
for the purpose of taking vcpu->mutex of all vcpus of a VM.=0D
=0D
Because sev_lock/unlock_vcpus_for_migration already have a workaround=0D
for lockdep max lock depth, this fixes the lockdep warnings on arm=0D
which were the inspiration for this refactoring.=0D
=0D
This patch series was only compile tested on all 3 architectures.=0D
=0D
V2: added trylock option to kvm_lock_all_vcpus to be better compatible=0D
with the orginal code.=0D
=0D
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (4):=0D
  locking/mutex: implement mutex_trylock_nested=0D
  KVM: x86: move sev_lock/unlock_vcpus_for_migration to kvm_main.c=0D
  KVM: arm64: switch to using kvm_lock/unlock_all_vcpus=0D
  RISC-V: KVM: switch to kvm_lock/unlock_all_vcpus=0D
=0D
 arch/arm64/include/asm/kvm_host.h     |  3 --=0D
 arch/arm64/kvm/arch_timer.c           |  4 +-=0D
 arch/arm64/kvm/arm.c                  | 43 ----------------=0D
 arch/arm64/kvm/vgic/vgic-init.c       |  4 +-=0D
 arch/arm64/kvm/vgic/vgic-its.c        |  8 +--=0D
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 12 ++---=0D
 arch/riscv/kvm/aia_device.c           | 34 +------------=0D
 arch/x86/kvm/svm/sev.c                | 65 ++----------------------=0D
 include/linux/kvm_host.h              |  6 +++=0D
 include/linux/mutex.h                 |  8 +++=0D
 kernel/locking/mutex.c                | 14 ++++--=0D
 virt/kvm/kvm_main.c                   | 71 +++++++++++++++++++++++++++=0D
 12 files changed, 116 insertions(+), 156 deletions(-)=0D
=0D
-- =0D
2.26.3=0D
=0D



Return-Path: <kvm+bounces-44988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DB811AA5582
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 22:30:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63DB11BC38CC
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 20:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0B9E2C10B9;
	Wed, 30 Apr 2025 20:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YcQugx6d"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506DC2983E9
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 20:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746045035; cv=none; b=oKvXHl+DGEkd0IZupABLwuq96TRbT0tWzGcsjbyVtG0vsoHqYXQjTw3eXDns5ZsDSZiZkiiLoADax6hRxwnIPZb0zs3iLiKbf9mdWrZx7Md0Yaj9tM6XbKPLMIPoR0l/3xI296lrGnIQMPC9X7cU9ZyWLE0YNbVkmXANkvzNfGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746045035; c=relaxed/simple;
	bh=mBDuifCHGf6VVWiI7N31U7EbOQkXaTnDCxx3mS1TW9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=k+KQc+qGdIaxAiQr+Y6mjPQP9pxYf3bMm4EwSC8pSdpBA2yM4HqalUAUgRkC1rn6utalcl1mXu7d9Lnibeb5pk4H7yHayIbsOycWegOSd/sY6b1IMUIfSjy3AmTlPGoh19Ib+y0C7d8FS4oExl4+R/xtIRAndrY0h7ZE9VBa4nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YcQugx6d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746045032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=aQUxr5K3/pNESmWjaoZBUh7F903MIT8w03jcc9M9AYg=;
	b=YcQugx6drzaR3o1wHOT0drbJryb+5WJc+alcd3HAKpGfULDFJXVdvvuVlWo+Knoi30eU1q
	5Di4TIGhM2TD45vNAk9GuAkQy6K8/KqUV4hGAm2TRLKPxZtDV2TWFW9zBrWNAPvwpQW5Jv
	0CuJeS91Xh68anuJ3v1a+pol5woX5pU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-177-TqW5oqXPPQS0_3qrbhafRw-1; Wed,
 30 Apr 2025 16:30:27 -0400
X-MC-Unique: TqW5oqXPPQS0_3qrbhafRw-1
X-Mimecast-MFC-AGG-ID: TqW5oqXPPQS0_3qrbhafRw_1746045022
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 72CF7180098F;
	Wed, 30 Apr 2025 20:30:21 +0000 (UTC)
Received: from intellaptop.lan (unknown [10.22.80.5])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 99F381800871;
	Wed, 30 Apr 2025 20:30:14 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-riscv@lists.infradead.org,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Waiman Long <longman@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Borislav Petkov <bp@alien8.de>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Alexander Potapenko <glider@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Andre Przywara <andre.przywara@arm.com>,
	x86@kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	kvm-riscv@lists.infradead.org,
	Atish Patra <atishp@atishpatra.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jing Zhang <jingzhangos@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Sebastian Ott <sebott@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Shusen Li <lishusen2@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marc Zyngier <maz@kernel.org>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v4 0/5] KVM: lockdep improvements
Date: Wed, 30 Apr 2025 16:30:08 -0400
Message-ID: <20250430203013.366479-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

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
Best regards,=0D
	Maxim Levitsky=0D
=0D
Maxim Levitsky (5):=0D
  locking/mutex: implement mutex_trylock_nested=0D
  arm64: KVM: use mutex_trylock_nest_lock when locking all vCPUs=0D
  RISC-V: KVM: switch to kvm_trylock/unlock_all_vcpus=0D
  locking/mutex: implement mutex_lock_killable_nest_lock=0D
  x86: KVM: SEV: implement kvm_lock_all_vcpus and use it=0D
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



Return-Path: <kvm+bounces-21810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A3F59346EF
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 05:50:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C83B11F23B95
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 03:50:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC2A83A267;
	Thu, 18 Jul 2024 03:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RzfUe/8a"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5393A38F91
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 03:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721274643; cv=none; b=QgygSMD+ah2GM/ybZ5gft1Aq8ZIa4LvppU/Xv25durJnouKq9NmNLTT2M/ufPGfGmSXSG+P977xuORXxYsH/ebNdyIeExc0Xphh0Cdgv67bv88qjGh4wx7lFeGvdoQAJ1nvGNiU2Znxsz/Oxp4ppPZSUbdJi8o2OxdTAsS+RDfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721274643; c=relaxed/simple;
	bh=P6yB9EpZsyoAAoRLV8vlCMKDG8Qa8YQ45P/ue+yOrpA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mJ33fIo9v7byPnqpjMYXiyUdbWDHv+5lLUfpRx+NDa5vSpcqGHeCQa34P4BnQ07KX8Pho6/2VP7qfTEMJHjeb+iv09M9pRrx8geL57m0+nkSIoMv9L88+L7/yBtlXrfBGcxyOQJ9eY/0oQXa7uW8myrp8rT34Lot4JXt9i9j42I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RzfUe/8a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721274640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zVC0wKpixnksmjEBWbkhiAzUfHLOXvMbsmYSZRNBrZI=;
	b=RzfUe/8aUSnHDWzt7waGxrZGedBRFA891aD2CpJ8d+fv5y0cvLTkTbtvlcliKtyPHXDo6D
	Ad+97XTcMiMW0vAMBxq1XSI0zik+csVI6GiOY0HeIWJI8Ykf3uqL8XZVvHi3TlmJF+6Th/
	iDVfFpGcmZPlCXb9XAH90HaSOh8X6UA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-580-WUCtBLVEPuaHNIZVi30tjw-1; Wed,
 17 Jul 2024 23:50:36 -0400
X-MC-Unique: WUCtBLVEPuaHNIZVi30tjw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBEFE1955D4D;
	Thu, 18 Jul 2024 03:50:32 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 08E061955D42;
	Thu, 18 Jul 2024 03:50:28 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev,
	Mark Brown <broonie@kernel.org>
Cc: Eric Auger <eauger@redhat.com>,
	Sebastian Ott <sebott@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v4 0/3] Allow userspace to change ID_AA64PFR1_EL1
Date: Wed, 17 Jul 2024 23:50:13 -0400
Message-Id: <20240718035017.434996-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Hi guys,

This is another try to allow userspace to change ID_AA64PFR1_EL1, and we want to
give userspace the ability to control the visible feature set for a VM, which
could be used by userspace in such a way to transparently migrate VMs.

The patch series have three part:

The first patch disable those fields which KVM doesn't know how to handle, so
KVM will only expose value 0 of those fields to the guest.

The second patch allow userspace to change ID_AA64PFR1_EL1, it allow as much as
possible fields to be writable, except some special fields which is still not
writable.

The third patch adds the kselftest to test if userspace can change the
ID_AA64PFR1_EL1.

Besides, I also noticed there is another patch [1] which try to make the
ID_AA64PFR1_EL1 writable. This patch [1] is try to enable GCS on baremental, and
add GCS support for the guest. What I understand is if we have GCS support on
baremental, it will be clear to how to handle them in KVM. And same for other
fields like NMI, THE, DF2, MTEX..

I'm still not confident about the correctness of this patch series, but I've try
my best to understand each of the fields. And follow Marc's comments to tweak
this patch series.

The question confuse me a lot is that should we allow those fields (NMI, GCS,
THE, DF2, MTEX..) which KVM doesn't know how to handle writable? Baremental
doesn't know about them, and the ftr_id_aa64pfr1[] doesn't know about them. I
follow the comment "I should handle all 15 fields", so I allow them writable
because they're disabled in the register read accessor, and their value will
alwyas be 0, the userspace can write to it but only value 0.

If I did anything wrong, please point me out. Thanks a lot.

[1] [PATCH v9 13/39] KVM: arm64: Manage GCS registers for guests
    https://lore.kernel.org/all/20240625-arm64-gcs-v9-13-0f634469b8f0@kernel.org/

Changelog:
----------
v3 -> v4:
  * Add a new patch to disable some feature which KVM doesn't know how to
    handle in the register accessor.
  * Handle all the fields in the register.
  * Fixes a small cnt issue in kselftest.

v2 -> v3:
  * Give more description about why only part of the fields can be writable.
  * Updated the writable mask by referring the latest ARM spec.

v1 -> v2:
  * Tackling the full register instead of single field.
  * Changing the patch title and commit message.

RFCv1 -> v1:
  * Fix the compilation error.
  * Delete the machine specific information and make the description more
    generable.

RFCv1: https://lore.kernel.org/all/20240612023553.127813-1-shahuang@redhat.com/
v1: https://lore.kernel.org/all/20240617075131.1006173-1-shahuang@redhat.com/
v2: https://lore.kernel.org/all/20240618063808.1040085-1-shahuang@redhat.com/
v3: https://lore.kernel.org/all/20240628060454.1936886-2-shahuang@redhat.com/

Shaoqin Huang (3):
  KVM: arm64: Disable fields that KVM doesn't know how to handle in
    ID_AA64PFR1_EL1
  KVM: arm64: Allow userspace to change ID_AA64PFR1_EL1
  KVM: selftests: aarch64: Add writable test for ID_AA64PFR1_EL1

 arch/arm64/kvm/sys_regs.c                     | 13 ++++++++++-
 .../selftests/kvm/aarch64/set_id_regs.c       | 23 ++++++++++++++++---
 2 files changed, 32 insertions(+), 4 deletions(-)

-- 
2.40.1



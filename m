Return-Path: <kvm+bounces-64089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A88AC78264
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 10:27:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 506DB34539C
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 09:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D50FA34253C;
	Fri, 21 Nov 2025 09:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ozJXLhj6"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0D6340279;
	Fri, 21 Nov 2025 09:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763717029; cv=none; b=MlNcyH3d15fhknnXTL1wC67ZLjzRB6QH9SK3QCQLlCqAsofc2mJ3L2HuI3YZ1s3+/iIZ0LdfGRl98f/Ydaobf5ta6yBlsEefneEYeL6S68Z3oQoD1gL0cKSK+s1BgRDiQG2SzHlMvwKOkJgvIbOCgYPzSvIVSb59X9INRPyIHn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763717029; c=relaxed/simple;
	bh=LjrNVB/VDqUyL8RfflBobn4bMQWyFHvx8GB+ANFej34=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UFFub/TnOxfI3oT10svtk08qw/lsn4iG7R2xHmWxBXwbuoYYYp/okn19mEhdtXkTklGZc+OP7hJyxANNl5F9zXTj87W8WNuEkqdwW6xBSdhtaAtz/YjLozDDQiOj0+ozYELa7jFX9O00/+TBaK3U3Npl26nOWMHKkKkXvRsXLvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ozJXLhj6; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2FNmGdRA6WNkSW3gQDN3+WluFUlUMpgBNvvjHe+ozws=;
	b=ozJXLhj6qKROoOq+Bbf5eCE0ySKbEVe0eFVDWD/2NDiAYI7utwPDBHlEEAzurSA2GkdIXdVXT
	zKejclK2pnorcdLX5muQcRwK9J4d/+pnoQfVEP6sPTiIopiImF0IP81WLWpiUwUujyavJZPrWwU
	mTG2AV+Dhxw8dUbY0bLSFqk=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4dCV912sbxz1prkV;
	Fri, 21 Nov 2025 17:21:57 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 369DA180BCF;
	Fri, 21 Nov 2025 17:23:43 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 21 Nov
 2025 17:23:42 +0800
From: Tian Zheng <zhengtian10@huawei.com>
To: <maz@kernel.org>, <oliver.upton@linux.dev>, <catalin.marinas@arm.com>,
	<corbet@lwn.net>, <pbonzini@redhat.com>, <will@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <zhengtian10@huawei.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <yezhenyu2@huawei.com>,
	<xiexiangyou@huawei.com>, <zhengchuan@huawei.com>, <linuxarm@huawei.com>,
	<joey.gouly@arm.com>, <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<suzuki.poulose@arm.com>
Subject: [PATCH v2 0/5] Support the FEAT_HDBSS introduced in Armv9.5
Date: Fri, 21 Nov 2025 17:23:37 +0800
Message-ID: <20251121092342.3393318-1-zhengtian10@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr100010.china.huawei.com (7.202.195.125)

This series of patches add support to the Hardware Dirty state tracking
Structure(HDBSS) feature, which is introduced by the ARM architecture
in the DDI0601(ID121123) version.

The HDBSS feature is an extension to the architecture that enhances
tracking translation table descriptors' dirty state, identified as
FEAT_HDBSS. The goal of this feature is to reduce the cost of surveying
for dirtied granules, with minimal effect on recording when a granule
has been dirtied.

The purpose of this feature is to make the execution overhead of live
migration lower to both the guest and the host, compared to existing
approaches (write-protect or search stage 2 tables).

After these patches, users(such as qemu) can use the
KVM_CAP_ARM_HW_DIRTY_STATE_TRACK ioctl to enable or disable the HDBSS
feature before and after the live migration.

This feature is similar to Intel's Page Modification Logging (PML),
offering hardware-assisted dirty tracking to reduce live migration
overhead. With PML support expanding beyond Intel, HDBSS introduces a
comparable mechanism for ARM.

eillon (4):
  arm64/sysreg: Add HDBSS related register information
  KVM: arm64: Support set the DBM attr during memory abort
  KVM: arm64: Add support for FEAT_HDBSS
  KVM: arm64: Enable HDBSS support and handle HDBSSF events

Tian Zheng (1):
  KVM: arm64: Document HDBSS ioctl

 Documentation/virt/kvm/api.rst       |  15 ++++
 arch/arm64/Kconfig                   |  14 ++++
 arch/arm64/include/asm/cpucaps.h     |   2 +
 arch/arm64/include/asm/cpufeature.h  |   5 ++
 arch/arm64/include/asm/esr.h         |   2 +
 arch/arm64/include/asm/kvm_arm.h     |   1 +
 arch/arm64/include/asm/kvm_host.h    |  14 ++++
 arch/arm64/include/asm/kvm_mmu.h     |  17 +++++
 arch/arm64/include/asm/kvm_pgtable.h |   4 +
 arch/arm64/include/asm/sysreg.h      |  12 +++
 arch/arm64/kernel/cpufeature.c       |   9 +++
 arch/arm64/kvm/arm.c                 | 107 +++++++++++++++++++++++++++
 arch/arm64/kvm/handle_exit.c         |  45 +++++++++++
 arch/arm64/kvm/hyp/pgtable.c         |   6 ++
 arch/arm64/kvm/hyp/vhe/switch.c      |   1 +
 arch/arm64/kvm/mmu.c                 |  10 +++
 arch/arm64/kvm/reset.c               |   3 +
 arch/arm64/tools/cpucaps             |   1 +
 arch/arm64/tools/sysreg              |  28 +++++++
 include/linux/kvm_host.h             |   1 +
 include/uapi/linux/kvm.h             |   1 +
 tools/include/uapi/linux/kvm.h       |   1 +
 22 files changed, 299 insertions(+)

--
2.33.0



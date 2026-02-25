Return-Path: <kvm+bounces-71773-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +B1wBnR1nmnCVQQAu9opvQ
	(envelope-from <kvm+bounces-71773-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:07:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B00D819179B
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:07:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2A49530F499F
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:04:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 664532C11ED;
	Wed, 25 Feb 2026 04:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="d3Fo55HY"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D1D2C325C;
	Wed, 25 Feb 2026 04:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771992274; cv=none; b=ZDRCi3rcR3AEF35QGqyeWgszIl9QHpaJ5hKidQlxHUmVNJyuuqK+l8iVIRB32esVSB6STz6BCbMUUsmqc3UetRFp3mWwKTS6CZO0LpscdIbkhcBYW6U/EhrsFBLSgjTybmcsRMndWe52X5yOtyyhjq7qCHs9CSwArkwJzKnyJx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771992274; c=relaxed/simple;
	bh=8drHhp+j0jOSlF5jJ/gXFf1BCySUhfoTV4QwNuq35RE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aEWY+I0YFaLCM4fI4/hN3O+v+ktihxj3Qk24sMb1EdA0+fV1NNUBrwzuA2bpIVZhT79ipx4LoEbVlpEGMNs1UIORDO2X17RFblH34Ipb0crh3TYbYQFuQ2o+zphl+9wf5e6q5Vp6pW5M3RA27JxypKUwoROprOj9H6PwuDhSW+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=d3Fo55HY; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=KFA0LtrJmju9DoOCjjWqc6FESXlRgEEAoBovtEGD878=;
	b=d3Fo55HYLZ5YNgsnlNFs+x7lvG6j5XhcIcLkMkciwSwEfmpBAmMpRbx0/K+fYxQtv6kHmqHpg
	Ob73DcFvqR6IbGxdE6UMa7sb/GG1ZOB9aRhJt9xCwl4P3nOz3/81/6YAua1iVC//n13Tw1efNma
	H465TfzKJCm719y2F/p8jgQ=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4fLLSm6860z1cyQ3;
	Wed, 25 Feb 2026 11:59:36 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 50D004048B;
	Wed, 25 Feb 2026 12:04:23 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 25 Feb
 2026 12:04:22 +0800
From: Tian Zheng <zhengtian10@huawei.com>
To: <maz@kernel.org>, <oupton@kernel.org>, <catalin.marinas@arm.com>,
	<corbet@lwn.net>, <pbonzini@redhat.com>, <will@kernel.org>,
	<zhengtian10@huawei.com>
CC: <yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>,
	<liuyonglong@huawei.com>, <Jonathan.Cameron@huawei.com>,
	<yezhenyu2@huawei.com>, <linuxarm@huawei.com>, <joey.gouly@arm.com>,
	<kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <skhan@linuxfoundation.org>,
	<suzuki.poulose@arm.com>, <leo.bras@arm.com>
Subject: [PATCH v3 0/5] Support the FEAT_HDBSS introduced in Armv9.5
Date: Wed, 25 Feb 2026 12:04:16 +0800
Message-ID: <20260225040421.2683931-1-zhengtian10@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100010.china.huawei.com (7.202.195.125)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[huawei.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[huawei.com:s=dkim];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71773-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zhengtian10@huawei.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[huawei.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[22];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,huawei.com:mid,huawei.com:dkim]
X-Rspamd-Queue-Id: B00D819179B
X-Rspamd-Action: no action

This series of patches add support to the Hardware Dirty state tracking
Structure(HDBSS) feature, which is introduced by the ARM architecture
in the DDI0601(ID121123) version.

The HDBSS feature is an extension to the architecture that enhances
tracking translation table descriptors' dirty state, identified as
FEAT_HDBSS. This feature utilizes hardware assistance to achieve dirty
page tracking, aiming to significantly reduce the overhead of scanning
for dirty pages.

The purpose of this feature is to make the execution overhead of live
migration lower to both the guest and the host, compared to existing
approaches (write-protect or search stage 2 tables).

After these patches, users(such as qemu) can use the
KVM_CAP_ARM_HW_DIRTY_STATE_TRACK ioctl to enable or disable the HDBSS
feature before and after the live migration.

v2:
https://lore.kernel.org/linux-arm-kernel/20251121092342.3393318-1-zhengtian10@huawei.com/

v2->v3 changes:
- Remove the ARM64_HDBSS configuration option and ensure this feature
is only enabled in VHE mode.
- Move HDBSS-related variables to the arch-independent portion of the
kvm structure.
- Remove error messages during HDBSS enable/disable operations
- Change HDBSS buffer flushing from handle_exit to vcpu_put,
check_vcpu_requests, and kvm_handle_guest_abort.
- Add fault handling for HDBSS including buffer full, external abort,
and general protection fault (GPF).
- Add support for a 4KB HDBSS buffer size, mapped to the value 0b0000.
- Add a second argument to the ioctl to turn HDBSS on or off.

Tian Zheng (1):
  KVM: arm64: Document HDBSS ioctl

eillon (4):
  arm64/sysreg: Add HDBSS related register information
  KVM: arm64: Add support to set the DBM attr during memory abort
  KVM: arm64: Add support for FEAT_HDBSS
  KVM: arm64: Enable HDBSS support and handle HDBSSF events

 Documentation/virt/kvm/api.rst       |  16 +++++
 arch/arm64/include/asm/cpufeature.h  |   5 ++
 arch/arm64/include/asm/esr.h         |   7 ++
 arch/arm64/include/asm/kvm_host.h    |  17 +++++
 arch/arm64/include/asm/kvm_mmu.h     |   1 +
 arch/arm64/include/asm/kvm_pgtable.h |   4 ++
 arch/arm64/include/asm/sysreg.h      |  11 +++
 arch/arm64/kernel/cpufeature.c       |  12 ++++
 arch/arm64/kvm/arm.c                 | 102 +++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         |   6 ++
 arch/arm64/kvm/hyp/vhe/switch.c      |  19 +++++
 arch/arm64/kvm/mmu.c                 |  70 ++++++++++++++++++
 arch/arm64/kvm/reset.c               |   3 +
 arch/arm64/tools/cpucaps             |   1 +
 arch/arm64/tools/sysreg              |  29 ++++++++
 include/uapi/linux/kvm.h             |   1 +
 tools/include/uapi/linux/kvm.h       |   1 +
 17 files changed, 305 insertions(+)

--
2.33.0



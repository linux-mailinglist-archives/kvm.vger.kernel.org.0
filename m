Return-Path: <kvm+bounces-68965-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8P2tHa+Fc2krxAAAu9opvQ
	(envelope-from <kvm+bounces-68965-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 15:29:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id DE095770FC
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 15:29:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1770A300A5B0
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 14:28:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3347B32ABFE;
	Fri, 23 Jan 2026 14:28:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D017B328243
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 14:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769178492; cv=none; b=LHVNN9+b+ROjDbJx+ZL+sTBVdHeiS5jbMqUamx5YQqg/kzK6kNXrUPwPyPHC1miuG580K37HIKcjIqzUlYqsrx2B8EBrMu3eJzez1KdNufQPJtI3QMV3KHrisHchWNfg2edqhT91umbIOr8X6gcmm61frTiWfCvJiI9P1RL1rLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769178492; c=relaxed/simple;
	bh=7exSPU/9YuSl/Ghj8YV45sMiot1CADmGgiuc1SLjWMw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uFbNAG5VXNB1TtuYYCc8IbM3biHFWzEeWYLgltGLCzn9ZYLW6fp5tg1AAsP8QhFXZeJ29cd95kIfwjDURlUUNszKWfXBlmdQ9Kwh29GsaHzbziRu+TM2lwB+FCRuZHlbNjVSCwKYpdA//fHo77cWWQ1SrM42vEUmvmPjWQ92Ko8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 84A461476;
	Fri, 23 Jan 2026 06:28:03 -0800 (PST)
Received: from e134369.cambridge.arm.com (e134369.arm.com [10.1.34.161])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B7AC3F740;
	Fri, 23 Jan 2026 06:28:08 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Julien Thierry <julien.thierry.kdev@gmail.com>,
	Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH kvmtool v5 0/7] arm64: Nested virtualization support
Date: Fri, 23 Jan 2026 14:27:22 +0000
Message-ID: <20260123142729.604737-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.64 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com,kernel.org];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68965-lists,kvm=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andre.przywara@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,arm.com:mid]
X-Rspamd-Queue-Id: DE095770FC
X-Rspamd-Action: no action

This is v5 of the nested virt support series, fixing a corner case when
some maintenance IRQ setup fails. Also there is now a warning if --e2h0
is specified without --nested. Many thanks to Sascha for the review!
========================================================

Thanks to the imperturbable efforts from Marc, arm64 support for nested
virtualization has now reached the mainline kernel, which means the
respective kvmtool support should now be ready as well.

Patch 1 updates the kernel headers, to get the new EL2 capability, and
the VGIC device control to setup the maintenance IRQ.
Patch 2 introduces the new "--nested" command line option, to let the
VCPUs start in EL2. To allow KVM guests running in such a guest, we also
need VGIC support, which patch 3 allows by setting the maintenance IRQ.
Patch 4 to 6 are picked from Marc's repo, and allow to set the arch
timer offset, enable non-VHE guests (at the cost of losing recursive
nested virtualisation), and also advertise the virtual EL2 timer IRQ.

Tested on the FVP (with some good deal of patience), and some commercial
(non-fruity) hardware, down to a guest's guest's guest.

Cheers,
Andre

Changelog v4 ... v5:
- bump kernel headers to v6.19-rc6
- print a warning if --e2h0 is given without --nested
- fail if the maintenance IRQ setting attribute is not supported

Changelog v3 ... v4:
- pass kvm pointer to gic__generate_fdt_nodes()
- use macros for PPI offset and DT type identifier
- properly calculate DT interrupt flags value
- add patch 7 to fix virtio endianess issues
- CAPITALISE verbs in commit message

Changelog v2 ... v3:
- adjust^Wreplace commit messages for E2H0 and counter-offset patch
- check for KVM_CAP_ARM_EL2_E2H0 when --e2h0 is requested
- update kernel headers to v6.16 release

Changelog v1 ... 2:
- add three patches from Marc:
  - add --e2h0 command line option
  - add --counter-offset command line option
  - advertise all five arch timer interrupts in DT

Andre Przywara (3):
  Sync kernel UAPI headers with v6.19-rc6
  arm64: Initial nested virt support
  arm64: nested: Add support for setting maintenance IRQ

Marc Zyngier (4):
  arm64: Add counter offset control
  arm64: Add FEAT_E2H0 support
  arm64: Generate HYP timer interrupt specifiers
  arm64: Handle virtio endianness reset when running nested

 arm64/arm-cpu.c                     |   6 +-
 arm64/fdt.c                         |   5 +-
 arm64/gic.c                         |  29 ++++++-
 arm64/include/asm/kvm.h             |  25 ++++--
 arm64/include/kvm/gic.h             |   2 +-
 arm64/include/kvm/kvm-config-arch.h |  11 ++-
 arm64/include/kvm/kvm-cpu-arch.h    |   5 +-
 arm64/include/kvm/timer.h           |   2 +-
 arm64/kvm-cpu.c                     |  64 ++++++++++++---
 arm64/kvm.c                         |  19 +++++
 arm64/timer.c                       |  29 +++----
 include/linux/kvm.h                 |  47 +++++++++++
 include/linux/virtio_ids.h          |   1 +
 include/linux/virtio_net.h          |  49 +++++++++++-
 include/linux/virtio_pci.h          |   3 +-
 powerpc/include/asm/kvm.h           |  13 ----
 riscv/include/asm/kvm.h             |  29 ++++++-
 x86/include/asm/kvm.h               | 116 ++++++++++++++++++++++++++++
 18 files changed, 394 insertions(+), 61 deletions(-)

-- 
2.43.0



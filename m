Return-Path: <kvm+bounces-70838-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eI+rGl6AjGl9pwAAu9opvQ
	(envelope-from <kvm+bounces-70838-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 14:13:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D83B5124AA4
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 14:13:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 314CC3018747
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 13:13:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 542B52C11D0;
	Wed, 11 Feb 2026 13:12:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96C6B2E414
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 13:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770815577; cv=none; b=OuZoG71zSpFTfiAHzbJ9rQLhmXMfhmpHNIoX9L0WVfyNUuEYvseLf138Ms2jg2T3BeHbc6BlfsR+v9Al/TmfPfhJzS6tsj43ZaeKB6rNuy5WoYc8j46bY7PXTMV9BQxkRdAsT7njbJEbXHMl/uzC8IW4Boqdw/G+mxjtt/2tIOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770815577; c=relaxed/simple;
	bh=GwiFwREw0rCSXyWzYPDQPu4tkpjkebTbj9CPdLLG5AM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AZ6fdCBAwWPsPRcwhlK75yFlhKoF+cCSZsRVa3YNncH/XsznHDh3rTXZ0lmsUtkMbLMxxyP/wJEt6Qfpm4mD5N1NC2kaTOmJuKbH39g2K2E1TuCmRSl7vUmuI90brMMzpOwgloCx89oryNoVwAz6HoKnYKu1D1QaDFv2Bf+p+ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2718339;
	Wed, 11 Feb 2026 05:12:49 -0800 (PST)
Received: from orionap.fritz.box (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6CF583F63F;
	Wed, 11 Feb 2026 05:12:54 -0800 (PST)
From: Andre Przywara <andre.przywara@arm.com>
To: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Marc Zyngier <maz@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH kvmtool v6 0/6] arm64: Nested virtualization support
Date: Wed, 11 Feb 2026 13:12:43 +0000
Message-ID: <20260211131249.399019-1-andre.przywara@arm.com>
X-Mailer: git-send-email 2.47.3
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
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[kernel.org,gmail.com];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70838-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andre.przywara@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[7];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid]
X-Rspamd-Queue-Id: D83B5124AA4
X-Rspamd-Action: no action

This is v6 of the nested virt support series, fixing an endianess bug
in the maintenance IRQ DT code, and rebasing.
Changelog below.
========================================================

Thanks to the imperturbable efforts from Marc, arm64 support for nested
virtualization has now reached the mainline kernel, which means the
respective kvmtool support should now be ready as well.

Patch 1 introduces the new "--nested" command line option, to let the
VCPUs start in EL2. To allow KVM guests running in such a guest, we also
need VGIC support, which patch 2 allows by setting the maintenance IRQ.
Patch 3 to 6 are picked from Marc's repo, and allow to set the arch
timer offset, enable non-VHE guests (at the cost of losing recursive
nested virtualisation), and also advertise the virtual EL2 timer IRQ.

Tested on the FVP (with some good deal of patience) and QEMU.

Cheers,
Andre

Changelog v5 ... v6:
- rebase / drop header update patch (already merged)
- fix endianness bug in DT maintenance IRQ description

Changelog v4 ... v5:
- bump kernel headers to v6.19-rc6
- print a warning if --e2h0 is given without --nested
- fail if the maintenance IRQ setting attribute is not supported
- add tags

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

Andre Przywara (2):
  arm64: Initial nested virt support
  arm64: nested: Add support for setting maintenance IRQ

Marc Zyngier (4):
  arm64: Add counter offset control
  arm64: Add FEAT_E2H0 support
  arm64: Generate HYP timer interrupt specifiers
  arm64: Handle virtio endianness reset when running nested

 arm64/arm-cpu.c                     |  6 +--
 arm64/fdt.c                         |  5 ++-
 arm64/gic.c                         | 29 ++++++++++++-
 arm64/include/kvm/gic.h             |  2 +-
 arm64/include/kvm/kvm-config-arch.h | 11 ++++-
 arm64/include/kvm/kvm-cpu-arch.h    |  5 ++-
 arm64/include/kvm/timer.h           |  2 +-
 arm64/kvm-cpu.c                     | 64 ++++++++++++++++++++++++-----
 arm64/kvm.c                         | 20 +++++++++
 arm64/timer.c                       | 29 ++++++-------
 10 files changed, 133 insertions(+), 40 deletions(-)

-- 
2.47.3


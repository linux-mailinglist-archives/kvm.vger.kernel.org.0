Return-Path: <kvm+bounces-20003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 377EA90F54F
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 19:41:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D42DD1F22F29
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 17:40:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D18A15623B;
	Wed, 19 Jun 2024 17:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iKjIRTgG"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B171411D7
	for <kvm@vger.kernel.org>; Wed, 19 Jun 2024 17:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718818852; cv=none; b=IN+RIzWV1rrrp15ODmFUiGAkyFtLDYrwgpto2etYpQwfx9mbNt04YwyvNMrwZyOq85nGrKqkh74RZPhoVg1qjPvOPDIyHRw6NGZN6DU8iCZU0CXjtf6U+emPwTeenvyqepsVqT2nNy7KVEi+zWC35QZsqpsRR0pQCGD5rWURBHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718818852; c=relaxed/simple;
	bh=6ZpQQhOBVU+C76jBiSGWWOfkxXfgx/HvuP/83NJOZXU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ds+nJiAjt69llbg1IB/ThQmkuLRjdXB7MDuDu7u5MRM1i5BmsS39Na2Az87zOqJsgEZQN//c57AQ2xZiLgrNccKe1qKXXj5NcgQgj3V9fYV4u/ttvwmp6D38OiocnMCJ+/TSpDFvg9/tQ2rS1W9dhKmBnW6hortckcslb/jE0dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iKjIRTgG; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718818847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Us4fqCI5z6GkVlgltQOu7uUui4bViYbesL5BeljsKdk=;
	b=iKjIRTgGVE82arVtDJ3yPBYpvXzDju3MbDNvWFF5dstkkoAOQPzasJLZ4WWicIRPa7Ykt3
	9og8Ec2cQajrdW4eEgzwyyLdx9qWEAQsQqJWhhwEgjOfjFKvrFvZdLU/uSkYKP22dFKxZO
	9FO2ZXL/LzMEXjS+jEUDYy1EFCP5xoM=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: sebott@redhat.com
X-Envelope-To: shahuang@redhat.com
X-Envelope-To: eric.auger@redhat.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Sebastian Ott <sebott@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v5 00/10] KVM: arm64: Allow userspace to modify CTR_EL0
Date: Wed, 19 Jun 2024 17:40:26 +0000
Message-ID: <20240619174036.483943-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

As I'd mentioned on the list, here is my rework of Sebastian's CTR_EL0
series. Changes this time around:

 - Drop the cross-validation of the guest's CTR_EL0 with CLIDR_EL1 and
   the CCSIDR_EL1 hierarchy, instead independently checking these
   registers against the system's CTR_EL0 value.

 - Rework the idregs debugfs interface to print all VM scoped feature ID
   registers, which now includes CTR_EL0.

 - Only reset the VM scoped value of CTR_EL0 once for a VM

 - Make feature ID register accesses go through read / write helpers,
   with the intention of abstracting the layout of the registers +
   adding sanity checks to writers.

What I didn't do after all is come up with a better generic way to store
ID registers at the VM scope, but the hope is that the accessors will
make that trivial to change in the future.

Oliver Upton (5):
  KVM: arm64: Get sys_reg encoding from descriptor in
    idregs_debug_show()
  KVM: arm64: Make idregs debugfs iterator search sysreg table directly
  KVM: arm64: Use read-only helper for reading VM ID registers
  KVM: arm64: Add helper for writing ID regs
  KVM: arm64: nv: Use accessors for modifying ID registers

Sebastian Ott (5):
  KVM: arm64: unify code to prepare traps
  KVM: arm64: Treat CTR_EL0 as a VM feature ID register
  KVM: arm64: show writable masks for feature registers
  KVM: arm64: rename functions for invariant sys regs
  KVM: selftests: arm64: Test writes to CTR_EL0

 arch/arm64/include/asm/kvm_emulate.h          |  40 +--
 arch/arm64/include/asm/kvm_host.h             |  26 +-
 arch/arm64/kvm/arm.c                          |   2 +-
 arch/arm64/kvm/nested.c                       | 256 +++++++++---------
 arch/arm64/kvm/pmu-emul.c                     |   2 +-
 arch/arm64/kvm/sys_regs.c                     | 140 ++++++----
 .../selftests/kvm/aarch64/set_id_regs.c       |  16 ++
 7 files changed, 262 insertions(+), 220 deletions(-)


base-commit: 1613e604df0cd359cf2a7fbd9be7a0bcfacfabd0
-- 
2.45.2.627.g7a2c4fd464-goog



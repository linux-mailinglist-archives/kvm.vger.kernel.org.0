Return-Path: <kvm+bounces-11999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BEE2687EDE1
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 17:48:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74BAA1F22CFF
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 16:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9097A56447;
	Mon, 18 Mar 2024 16:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eLDnx06l"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DBF2C6B7;
	Mon, 18 Mar 2024 16:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710780432; cv=none; b=LR/FPDQouCwEJTjACCSoDgQAMgasn4ha2bFSAGAthKsHIjpXMqPzhdH8aOlUaPYcuKyCj28XS6VUUh3dIwfpuNTUlXmV5fFE7AbLRWfb6Ql2Px9XHPsKdCOBZk3Pcz9FMwrnIbMke39yOyZeLWcQXDaH03O5zT4tOGp85qXv8c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710780432; c=relaxed/simple;
	bh=b0h1VbEHFh9qD1o7D7bZULRZA5Hxn9NGATbuk1naP50=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B/rM5H822taZQ/ZirrPD44VYfrG2alnxjQ82ySQlEcmxmTe97o7GGTA/+cb39wO+P/GlTqNwXTLEwHzDKUP2e6tn7Nj3yTrj5b/Sq1/sfBOM2K7imXv1Ao+VHrJ8ANbVSEhDIE/e4nATiBDD3I4Clbk92Fk3sOchYLf84ivfJeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eLDnx06l; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=PepfWuDb0qWcSY62ic0M/q/leQ8EAPZZpQYANiCR9/0=; b=eLDnx06lB1n0d9bn85UZrkkWTI
	hE3cwCH64vBWVmVAyRNCovdc7I04JyPFUnR+MMxag37V6dpdmF02pjb1JzAulwnek4W1vfUQnJVZU
	lq6arc45Z3h/rVIxLnfp7GwgAHE73Uzc7YScPvMI9hTiQh/nSoQsjFn0cyKV86XzlRgO6i2d750VN
	S6znG4zO08OV+32EV1CNXFl16h/mn/Ttz2/2pVrRNUVThXNlcJ14AtSvKyzRnmJKkHlz454dfswdB
	EBiCgdPegSNpUlq2u/fYp3TK2zVpc4zFB1+8UJzBsUBXUli6ab8pWKsabG40DS7M0SQczFoy4D3xW
	Axl4yGkQ==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmG8Z-0000000CjyA-1kHI;
	Mon, 18 Mar 2024 16:46:59 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmG8W-00000004F1A-0SES;
	Mon, 18 Mar 2024 16:46:56 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <len.brown@intel.com>,
	Pavel Machek <pavel@ucw.cz>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Mostafa Saleh <smostafa@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-pm@vger.kernel.org
Subject: [RFC PATCH v2 0/4] arm64: Add PSCI v1.3 SYSTEM_OFF2 support for hibernation
Date: Mon, 18 Mar 2024 16:14:22 +0000
Message-ID: <20240318164646.1010092-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

The PSCI v1.3 spec (https://developer.arm.com/documentation/den0022, 
currently in Alpha state, hence 'RFC') adds support for a SYSTEM_OFF2 
function enabling a HIBERNATE_OFF state which is analogous to ACPI S4. 
This will allow hosting environments to determine that a guest is 
hibernated rather than just powered off, and ensure that they preserve 
the virtual environment appropriately to allow the guest to resume 
safely (or bump the hardware_signature in the FACS to trigger a clean 
reboot instead).

This adds support for it to KVM, exactly the same way as the existing 
support for SYSTEM_RESET2 as added in commits d43583b890e7 ("KVM: arm64: 
Expose PSCI SYSTEM_RESET2 call to the guest") and 34739fd95fab ("KVM: 
arm64: Indicate SYSTEM_RESET2 in kvm_run::system_event flags field").

Back then, KVM was unconditionally bumped to expose PSCI v1.1. This 
means that a kernel upgrade causes guest visible behaviour changes 
without any explicit opt-in from the VMM, which is... unconventional. In 
some cases, a PSCI update isn't just about new optional calls; PSCI v1.2 
for example adds a new permitted error return from the existing CPU_ON 
function.

There *is* a way for a VMM to opt *out* of newer PSCI versions... by 
setting a per-vCPU "special" register that actually ends up setting the 
PSCI version KVM-wide. Quite why this isn't just a simple KVM_CAP, I 
have no idea. There *is* a KVM_CAP_ARM_PSCI_0_2 but that's just for 0.1 
vs. 0.2+, not the specific v0.2+ version that's exposed.

Since the SYSTEM_OFF2 call is optional and discoverable through the 
PSCI_FEATURES call, I'm electing not to touch the PSCI versioning 
awfulness at all. Like the existing SYSTEM_RESET2, there's a KVM_CAP to 
enable it explicitly (as it's an optional call even in v1.3), and like 
the existing SYSTEM_RESET2 it doesn't depend on the advertised PSCI 
version.

For the guest side, add a new SYS_OFF_MODE_POWER_OFF handler with higher 
priority than the EFI one, but which *only* triggers when there's a 
hibernation in progress. There are other ways to do this (see the commit
message for more details) but this seemed like the simplest.

Version 2 of the patch series splits out the psci.h definitions into a 
separate commit (a dependency for both the guest and KVM side), and adds 
definitions for the other new functions added in v1.3. It also moves the 
pKVM psci-relay support to a separate commit; although in arch/arm64/kvm 
that's actually about the *guest* side of SYSTEM_OFF2 (i.e. using it
from the host kernel, relayed through nVHE).

David Woodhouse (4):
      firmware/psci: Add definitions for PSCI v1.3 specification (ALPHA)
      KVM: arm64: Add PSCI SYSTEM_OFF2 function for hibernation
      KVM: arm64: nvhe: Pass through PSCI v1.3 SYSTEM_OFF2 call
      arm64: Use SYSTEM_OFF2 PSCI call to power off for hibernate

 Documentation/virt/kvm/api.rst       | 11 +++++++++++
 arch/arm64/include/asm/kvm_host.h    |  2 ++
 arch/arm64/include/uapi/asm/kvm.h    |  6 ++++++
 arch/arm64/kvm/arm.c                 |  5 +++++
 arch/arm64/kvm/hyp/nvhe/psci-relay.c |  2 ++
 arch/arm64/kvm/psci.c                | 37 ++++++++++++++++++++++++++++++++++++
 drivers/firmware/psci/psci.c         | 35 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h             |  1 +
 include/uapi/linux/psci.h            | 20 +++++++++++++++++++
 kernel/power/hibernate.c             |  5 ++++-
 10 files changed, 123 insertions(+), 1 deletion(-)



Return-Path: <kvm+bounces-12134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AFD987FE54
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 14:13:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0C3B1F239E2
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 13:13:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2245823C9;
	Tue, 19 Mar 2024 13:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Fk31kwtY"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBDF81728;
	Tue, 19 Mar 2024 13:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710853815; cv=none; b=l1+U0krv5NfrT8rv70tqnPFD1cd07XuUQi5Yv7jINdgjY3HosR4eADmkuX57buupnxf3yjf5fUbPMHLWCNsvIMdL0jcD2Ge6lHyKMzRakOP/epEVu3G/2mJZkJR8qORCGglJzYj3XV1QnK2J8Eg4rbrNZp2ygk0KZIQ2j8edkYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710853815; c=relaxed/simple;
	bh=/2gz5oE7X2HoTza/fnScy8bF/yxdMo8k73vGexhITbo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Bgz2wjiDzWEbJXOinp5HLs1O0StKVO9SawrajmzPeHjOYdsLNHCXa9QqqbUXSoLwexDSLSV2oXWTRpiEk4yP+sGZpk0DGx3P72wGLtHWk6MhPKKZHmzKendJcxE3hc+7rZZV9NifWiCMzW7kooZtkYoEP4IJEZbjmvphBGsCNyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Fk31kwtY; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=NRFhPNgO2KTc9pPyC3K2O36/9jEWFqud2QKSFyqGdjk=; b=Fk31kwtY0xiAnzFHmq5RbsfnPl
	sZjE/0LXazWJZFkqELo5wcmgHGdb4PJmx9n+LLppmtb/ES00rt4HI/4IxKNJkQd+s2TwtwFnV0Z6J
	wv86rcQLi2x6XkqLa32lg0qL5ipFtT/vYobvqVL631TNU1wSAExw6wFY/fuhbiRdlZYLjjDnSg9j1
	HF2E2D+Q9rJvZIOUB8ShvIZObfyqGm9fqZg3UrxqXpE7XvV5PfABKe8zarvbnedYrEE7cIZsbGKEu
	tbMTaxomdjYUxr4nzPQ955Ih2NBewXNFGnSD3u5YOYiDFHj1npk5PilLKgUxb+8mfl8QqFQA6OoDu
	Gup9ef0Q==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmZE9-00000001zLS-11MH;
	Tue, 19 Mar 2024 13:10:01 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmZE8-00000004PMn-3PUg;
	Tue, 19 Mar 2024 13:10:00 +0000
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
Subject: [RFC PATCH v3 0/5] Add PSCI v1.3 SYSTEM_OFF2 support for hibernation
Date: Tue, 19 Mar 2024 12:59:01 +0000
Message-ID: <20240319130957.1050637-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


The PSCI v1.3 spec (https://developer.arm.com/documentation/den0022,
currently in Alpha state, hence 'RFC') adds support for a SYSTEM_OFF2
function enabling a HIBERNATE_OFF state which is analogous to ACPI S4.
This will allow hosting environments to determine that a guest is
hibernated rather than just powered off, and ensure that they preserve
the virtual environment appropriately to allow the guest to resume
safely (or bump the hardware_signature in the FACS to trigger a clean
reboot instead).

This updates KVM to support advertising PSCI v1.3, and unconditionally
enables the SYSTEM_OFF2 support when PSCI v1.3 is enabled. For now,
KVM defaults to PSCI v1.2 unless explicitly requested.

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

Version 3 dropped the KVM_CAP which allowed userspace to explicitly opt
in to the new feature like with SYSTEM_SUSPEND, and makes it depend only
on PSCI v1.3 being exposed to the guest.

David Woodhouse (5):
      firmware/psci: Add definitions for PSCI v1.3 specification (ALPHA)
      KVM: arm64: Add support for PSCI v1.2 and v1.3
      KVM: arm64: Add PSCI v1.3 SYSTEM_OFF2 function for hibernation
      KVM: arm64: nvhe: Pass through PSCI v1.3 SYSTEM_OFF2 call
      arm64: Use SYSTEM_OFF2 PSCI call to power off for hibernate

 Documentation/virt/kvm/api.rst       | 11 +++++++++
 arch/arm64/include/uapi/asm/kvm.h    |  6 +++++
 arch/arm64/kvm/hyp/nvhe/psci-relay.c |  2 ++
 arch/arm64/kvm/hypercalls.c          |  2 ++
 arch/arm64/kvm/psci.c                | 43 +++++++++++++++++++++++++++++++++++-
 drivers/firmware/psci/psci.c         | 35 +++++++++++++++++++++++++++++
 include/kvm/arm_psci.h               |  4 +++-
 include/uapi/linux/psci.h            | 20 +++++++++++++++++
 kernel/power/hibernate.c             |  5 ++++-
 9 files changed, 125 insertions(+), 3 deletions(-)



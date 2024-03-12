Return-Path: <kvm+bounces-11666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B63DD879584
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 15:00:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E85021C21C3F
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 14:00:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF09A7B3C4;
	Tue, 12 Mar 2024 14:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OkBA9tac"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC2F79B96;
	Tue, 12 Mar 2024 14:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710252012; cv=none; b=CG+OA/gCOk9Y4Lrgb41g6fFo6RW/MUHeyixZnx57h5mLWNo6Lnvpf6LpttZ7o2ZMrPanYGE5C3dGi7Gah8IyMokjDYTz/LgERlFoc3ZGYwejg7a8E5ruXmu6hgGznn4hcp/EIjSbARxEQqmCHhUYyVEfDrJcTCWTXKUOxhzw+AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710252012; c=relaxed/simple;
	bh=3HWKckNpAQ8AY3aLQCp6UBNnYrtUMUkbdHYWXQt4TtY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EXKnbQkZdfDQa5Q+QosiooOvkBHHsaXk4gHObh88EjcaL63XAh+nf05iOrg82xJvumblJP+NexwHErHeRncRTOd4gCV4LzMRWhzQjO/YItMlwEpAnr5t2AaeHtLVBqL7/70nykPPmAm4+Ius6JID23wJLeW6xlZ251g8aiO+GT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OkBA9tac; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=jQe08bY6cMcC0sBvnFpiFQcBV697YeZ0n6MJqTOrObA=; b=OkBA9tacW41yqQUpfP1Hzcplt8
	xtAww7kN00Sx5K7o7fgoszyFLXs+91r6SQIcCn/Jv7GQY566BTvYHRHPtNF2MhyqQwf3NwcdyXnof
	1kiFoNaj9RN1c8qgyvTRK0GfX1iOqV7ATqTE1fcfzWHm4XpEVQW3OgYVZs1sDw4eEr5hj5JY5ePht
	Ag8x2K6WMsl29tDBbHuPrqFnyqhcmv7vIHk74dqsDUPYbiBvQifpSoh098LUkq+al5F5TLrJTjdk9
	mA81FeGfnVhdKHCOfllPPrMnySBa6SwGeF1e+mDU4w+TbV12/54iDj1Vncdv5ZiSJ9HlIvmEGeo2a
	hyB9wd0A==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rk2fh-00000009V5K-3oqy;
	Tue, 12 Mar 2024 14:00:02 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rk2fg-000000033N2-2oJe;
	Tue, 12 Mar 2024 14:00:00 +0000
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
Subject: [RFC PATCH 0/2] Add PSCI v1.3 SYSTEM_OFF2 support for hibernation
Date: Tue, 12 Mar 2024 13:51:27 +0000
Message-ID: <20240312135958.727765-1-dwmw2@infradead.org>
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

The upcoming PSCI v1.3 specification adds support for a SYSTEM_OFF2 
function which is analogous to ACPI S4 state. This will allow hosting 
environments to determine that a guest is hibernated rather than just 
powered off, and ensure that they preserve the virtual environment 
appropriately to allow the guest to resume safely (or bump the 
hardware_signature in the FACS to trigger a clean reboot instead).

This adds support for it to KVM, and to the guest hibernate code.

Strictly, we should perhaps also allow the guest to detect PSCI v1.3, 
but when v1.1 was added in commit 512865d83fd9 it was done 
unconditionally, which seems wrong. Shouldn't we have a way for 
userspace to control what gets exposed, rather than silently changing 
the guest behaviour with newer host kernels? Should I add a 
KVM_CAP_ARM_PSCI_VERSION?

For the guest side, this adds a new SYS_OFF_MODE_POWER_OFF with higher 
priority than the EFI one, but which *only* triggers when there's a 
hibernation in progress. That seemed like the simplest option, but see 
the commit message for alternative possilities. I told Rafael I'd post a 
straw man for bikeshedding, and here it is.

 Documentation/virt/kvm/api.rst       | 11 +++++++++++
 arch/arm64/include/asm/kvm_host.h    |  2 ++
 arch/arm64/include/uapi/asm/kvm.h    |  6 ++++++
 arch/arm64/kvm/arm.c                 |  5 +++++
 arch/arm64/kvm/hyp/nvhe/psci-relay.c |  2 ++
 arch/arm64/kvm/psci.c                | 37 ++++++++++++++++++++++++++++++++++++
 drivers/firmware/psci/psci.c         | 35 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h             |  1 +
 include/uapi/linux/psci.h            |  5 +++++
 kernel/power/hibernate.c             |  5 ++++-
 10 files changed, 108 insertions(+), 1 deletion(-)



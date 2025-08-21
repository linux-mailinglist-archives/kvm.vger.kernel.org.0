Return-Path: <kvm+bounces-55331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A1B26B301E9
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 20:23:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB49E5682FD
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 18:23:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2B8E341662;
	Thu, 21 Aug 2025 18:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yc94L7MJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64F525B30E;
	Thu, 21 Aug 2025 18:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755800571; cv=none; b=LJuF+s23y5Do2KFaZ7BxwDqgHGFIRT7nSaCuMnllfhN9liSEqLuTnSmMtW3t1MZU6BgLahewl+fmJNlTTfXci5tiEHhEnQj03EW8SAX9jfUJThS5meCR58hgnRiIO/4/qw1TwqF2CGV8rTIdIyjjAUvbU0WnbVr5SyZq77Vq6f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755800571; c=relaxed/simple;
	bh=MiUMbTMKy+7OE3M7ZVTtOwZO7dUXuh47Y4D8o99tXM0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fwfFkJPqMnNb2LL8+7dekVPQ5uTFECuc1pucK3X7RhW/QcD5/y1FaDfwkaucMDJwlQJXAB7WG0wEc2ns1uKIjW64YSyVmOG47RGocLRManEt/t+jG6vtAaWWYhhrSiamcvDxbUQ+IqRwKTKxq1vLVhhd5BuCB8H9YxZkMJpP4O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yc94L7MJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D234C4CEEB;
	Thu, 21 Aug 2025 18:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755800570;
	bh=MiUMbTMKy+7OE3M7ZVTtOwZO7dUXuh47Y4D8o99tXM0=;
	h=From:To:Cc:Subject:Date:From;
	b=Yc94L7MJhBqXPGA0uO4jNc+WK9U7EpSffhcfiEpFWigyXB0pnTUg/x17b+RQgmSxy
	 Vbdgm7E3/sDZS539+cJhiMZGHt201Rvc04tkNQTbFnczbwGFkSqMjJ9bycZHmkTi9S
	 BHk4DsfJxLN59zHCQbexZvSmr4izh6zcNwbnixzDvhO74dT3k/RPyk43ClAvLmI23l
	 23BUwpsu6ORcrOs9apzuRnzBo5T24WZka/PyKEX2QHMJ3vQevC8TGn3tnQH7LbM0gS
	 rNvXTZg0i2hoLk5XYMGKCq4xFKD8pM0MjcfGSNLKJ0gphE5sJeTV0k1LUOdjyLsrEf
	 wAI4LLWXCXTKg==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH v4 0/7] KVM: SVM: Add support for 4k vCPUs with x2AVIC
Date: Thu, 21 Aug 2025 23:48:31 +0530
Message-ID: <cover.1755797611.git.naveen@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v4 of the series posted here:
http://lkml.kernel.org/r/cover.1740036492.git.naveen@kernel.org

This series has been significantly re-worked based on the feedback 
received on v3, as well as to accommodate upstream changes to SVM and 
AVIC code. I have not picked up Vasant's and Pankaj's review tags for 
that purpose. Kindly review again.


- Naveen


Naveen N Rao (AMD) (7):
  KVM: SVM: Limit AVIC physical max index based on configured
    max_vcpu_ids
  KVM: SVM: Add a helper to look up the max physical ID for AVIC
  KVM: SVM: Replace hard-coded value 0x1FF with the corresponding macro
  KVM: SVM: Expand AVIC_PHYSICAL_MAX_INDEX_MASK to be a 12-bit field
  KVM: SVM: Move AVIC Physical ID table allocation to vcpu_precreate()
  x86/cpufeatures: Add X86_FEATURE_X2AVIC_EXT
  KVM: SVM: Add AVIC support for 4k vCPUs in x2AVIC mode

 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/include/asm/svm.h         |  5 +-
 arch/x86/kvm/svm/svm.h             |  1 +
 arch/x86/kernel/cpu/scattered.c    |  1 +
 arch/x86/kvm/svm/avic.c            | 76 ++++++++++++++++++++++++------
 arch/x86/kvm/svm/svm.c             |  9 ++++
 6 files changed, 78 insertions(+), 15 deletions(-)


base-commit: 91b392ada892a2e8b1c621b9493c50f6fb49880f
-- 
2.50.1



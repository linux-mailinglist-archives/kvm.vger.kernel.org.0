Return-Path: <kvm+bounces-29850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EC7D59B3189
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 14:20:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A45461F226AB
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 13:20:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 267B71DC06D;
	Mon, 28 Oct 2024 13:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nJ8DurAq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C6F38396;
	Mon, 28 Oct 2024 13:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730121630; cv=none; b=RSOHpQ+aB9Jyff6m22op3f6H987/cStzQyTg7UKtfjtJWKFlx4MPbXmK7jhBx1K6uiaYHXKlyfBbNbKZp/Am/oVziwU7GZf5W/6Jb0EkokNYqzVI1EkMJHPz9OQ0VpLDXVvwc9F9fKtElscurG0h34STErJiea1cn7ja/1m1NrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730121630; c=relaxed/simple;
	bh=8CIvnMB24vJGzN721kUQN9Rk9oVnLvV00Z0lshsSQDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BUj9quxQ3ccJmrsaQh0nL3X3+TSq7Ghw3MyANSEZ/NmZAdKOAr5wi/Of9jW5YjDvXhlCr8rXnzYH22IuKikSSpZoKHrrYRrZzBPmoNtNmCxTjglOPypkt5yflCzNKryaC2SQJNtBMXrCNycQk3DiJHaS+PW2Z7G+B3Y/3l1Aibc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nJ8DurAq; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730121628; x=1761657628;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8CIvnMB24vJGzN721kUQN9Rk9oVnLvV00Z0lshsSQDQ=;
  b=nJ8DurAqT02PO42Oto/yrqaQICctNOp6k2GV/QeZcohHRXOAGh33Nv/Q
   yUx2wRoDHgE2LowX2O/NHWXaF66Fy3XNMV80TtqVFFBzNn6l1qhfKGpmk
   bUf5hiOiP3rLmiR5YvpUo8EJpYks/wGQC+w+xo4BMeBEJXPip2iULVTDE
   CJeWcWOWfdc+e0LWx63UxkoYa5KCmPZbxvmnrUt0CTLAt4Wcj6XpKJLtj
   jOdUhUYNA8ZtJHWZJ+XKSO9YDRoEhpvUTECAdUOZ036Cm0wRk3sQCNwd3
   oive+ED6BuYKw3jMVedF+DjHnCfO4rKE9VXKk0mQCCK2/SsjoKUXitCi7
   A==;
X-CSE-ConnectionGUID: cTRCuuFpSdeVJ+ge8rqOdw==
X-CSE-MsgGUID: emZ0rkWeTd2pb77rNiZidQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11238"; a="29820958"
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="29820958"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 06:20:27 -0700
X-CSE-ConnectionGUID: cBj/10LMRCSvX4Z6i7Flng==
X-CSE-MsgGUID: Aaeh0z1hSvq0UaOXJEKZ3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="86397207"
Received: from gargmani-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.169])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 06:20:25 -0700
From: Kai Huang <kai.huang@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com
Cc: isaku.yamahata@intel.com,
	reinette.chatre@intel.com,
	binbin.wu@linux.intel.com,
	xiaoyao.li@intel.com,
	yan.y.zhao@intel.com,
	adrian.hunter@intel.com,
	tony.lindgren@intel.com,
	kristen@linux.intel.com,
	linux-kernel@vger.kernel.org,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH 0/3] KVM: VMX: Initialize TDX when loading KVM module
Date: Tue, 29 Oct 2024 02:20:13 +1300
Message-ID: <cover.1730120881.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Paolo/Sean,

This series contains patches to initialize TDX when loading KVM module.
This series is based on the discussion with Sean on the v19 patchset
[*], hoping it has addressed most (if not all) comments.

This series has been in our internal TDX tree for long time and has been
in kvm-coco-queue for some time thus it has been tested.

The main purpose for sending out is to have a review but this series can
also be applied to kvm/queue cleanly.

Thanks for your time!

[*]: https://lore.kernel.org/kvm/f028d43abeadaa3134297d28fb99f283445c0333.1708933498.git.isaku.yamahata@intel.com/

Kai Huang (3):
  KVM: VMX: Refactor VMX module init/exit functions
  KVM: Export hardware virtualization enabling/disabling functions
  KVM: VMX: Initialize TDX during KVM module load

 arch/x86/kvm/Makefile    |   1 +
 arch/x86/kvm/vmx/main.c  |  38 +++++++++++++
 arch/x86/kvm/vmx/tdx.c   | 115 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h   |  12 ++++
 arch/x86/kvm/vmx/vmx.c   |  23 +-------
 arch/x86/kvm/vmx/vmx.h   |   3 +
 include/linux/kvm_host.h |   8 +++
 virt/kvm/kvm_main.c      |  18 ++----
 8 files changed, 183 insertions(+), 35 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/tdx.c
 create mode 100644 arch/x86/kvm/vmx/tdx.h


base-commit: 5cb1659f412041e4780f2e8ee49b2e03728a2ba6
-- 
2.46.2



Return-Path: <kvm+bounces-51875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73120AFDF54
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 07:39:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D218B7A5AC5
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEBDC26B951;
	Wed,  9 Jul 2025 05:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jMeFQCW1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9553926B096;
	Wed,  9 Jul 2025 05:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752039512; cv=none; b=GA57GIJ2ARfOxuoPkRwGZELAvar4Z2++P1jW3dUWoDj5pOtQGvw4Q5UCD14pIKaKq8WSw8HI4H49FXsNkyBhxDTOlJOfbdT8IxLoMcGayX8IVvpmuF8gazNVWTuK8av77zshDOxTMayR6H/uwRElzkKKvc05aBxLtNDubYDmoFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752039512; c=relaxed/simple;
	bh=4eNBVbknwWq5sSZQkbozRPgZioes5rLSoghonDbVUY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gy6/ybZdLqk2od/lDjMppKRITEcnpMQ1jRFwB/XHIpwuu56IBUgNnpeuID6XE9xJ+SFHZS/CWICRJS8PF0BcWZaBtX3d/XTYTAbQpPZpuGl2dTTDWGActYs2l/Q6mEEdFR1CnBg8LlMvHt65kKIpKuFjhoD9gewPHvfgCYk6m7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jMeFQCW1; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752039510; x=1783575510;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4eNBVbknwWq5sSZQkbozRPgZioes5rLSoghonDbVUY4=;
  b=jMeFQCW1o/fbS0JUIn46za9WedAa6xKYRbe86MZ/f0qVSxWam6JbHQft
   r1+KDal4SdpUteHPw2KJgVF22c4ozYR0I4vn6fXmvh6KF+cbKICc9c1m8
   jN95LimrbRj/VWZ/45YsushTbSmlQSrtK5j84YNgt7e2qmPCSKARdMLMe
   KQQhK4Zi96eZnitozLXh+tR6ErCUYN0BioQrUJ2OsoRriLzzxFuyqDdTe
   LrGZ4BQIVz7ZWi+VlAUoEtw/ntYnqp6Hhx5/wD+OYhnKGESkcpBLaz/kT
   n1dIVsrEWK/WUKfHtpJ03/VkOBu0eChNCvJbEzUvAROV18HavWEhXxbSs
   Q==;
X-CSE-ConnectionGUID: B69CnWIfQIyjvdg9WOvHgw==
X-CSE-MsgGUID: atgcr748QS6n7h5Bbsg6NA==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="64871173"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="64871173"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 22:38:29 -0700
X-CSE-ConnectionGUID: 9jIbjs/zRlup+ZHj0eSlOQ==
X-CSE-MsgGUID: 0OVPJv3OQTuyTsk3plNNaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="155799374"
Received: from tjmaciei-mobl5.ger.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.221.68])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 22:38:26 -0700
From: Kai Huang <kai.huang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	thomas.lendacky@amd.com,
	nikunj@amd.com,
	bp@alien8.de,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: x86: Reject KVM_SET_TSC_KHZ VM ioctl when vCPU has been created
Date: Wed,  9 Jul 2025 17:38:00 +1200
Message-ID: <1eaa9ba08d383a7db785491a9bdf667e780a76cc.1752038726.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <cover.1752038725.git.kai.huang@intel.com>
References: <cover.1752038725.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reject the KVM_SET_TSC_KHZ VM ioctl when there's vCPU has already been
created.

The VM scope KVM_SET_TSC_KHZ ioctl is used to set up the default TSC
frequency that all subsequent created vCPUs use.  It is only intended to
be called before any vCPU is created.  Allowing it to be called after
that only results in confusion but nothing good.

Note this is an ABI change.  But currently in Qemu (the de facto
userspace VMM) only TDX uses this VM ioctl, and it is only called once
before creating any vCPU, therefore the risk of breaking userspace is
pretty low.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/x86.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 699ca5e74bba..e5e55d549468 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7194,6 +7194,10 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		u32 user_tsc_khz;
 
 		r = -EINVAL;
+
+		if (kvm->created_vcpus)
+			goto out;
+
 		user_tsc_khz = (u32)arg;
 
 		if (kvm_caps.has_tsc_control &&
-- 
2.50.0



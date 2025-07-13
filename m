Return-Path: <kvm+bounces-52255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3132EB03348
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 00:21:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 608A0177463
	for <lists+kvm@lfdr.de>; Sun, 13 Jul 2025 22:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3484200BAE;
	Sun, 13 Jul 2025 22:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m3zeSa7c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1121FBE8A;
	Sun, 13 Jul 2025 22:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752445240; cv=none; b=K6grWBhShF+bar/+GXD3AIlQ45gyWRmQ+ch99Ks8WIB7PRDY17xpemDo+UHyigYU3kNISIkQ/wKXm/DnNeAzVG5Bh6kpzg8Yw9U1X1T5hBwkcEqXsL3LxGGzcMmiQoPLXrD5qi/FWOL+HWSu/iYb1VdJLymM2F8GwVuH21+fxv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752445240; c=relaxed/simple;
	bh=7hpsAL4qmfbba/iVBinYIHn//Gv9UHE9xVzc4KyCfcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPPob3wjCmw0x7iVZqAapelrhrZIEpNuBdiV7JRFgD4U+udsI+z6xwJHFME2MbQmDCqGjWZo8iCXGCOFJxrQBZyPMKsEPDyo7PWsjuSYX7GMh99Ri0OFmUwekM0wDSyy+a6wBXCgDkuK8wQmf+9RW+xMnC1szYLUmipF1hJQ/GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m3zeSa7c; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752445239; x=1783981239;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7hpsAL4qmfbba/iVBinYIHn//Gv9UHE9xVzc4KyCfcw=;
  b=m3zeSa7cmrWSv8dtyRCLemAyKkfOXWqg2PNSk/5wIms/kVlTVwqVIidQ
   TiJjroh2TnVDMmPPFKzyCH35/972Wvzzb5GrnhCoDXXgFMPVIT4SQPYxe
   k82zs5sVn4hrkdNJLa2v2Pg0YSgbXAyw032HL3NNSZOREjv5MjMquKNjj
   kkIBoU0U0rS5j64f2SIjcnLn/5FJI0PKd5aiIuErajuuTtGuhw9FTBNXG
   whAOExoOWCDhojYaoHkmHK7j911bu4Dzaj59ueqeBcrjC8ECSltFR+PFO
   pbEPM26JLmn8vBqCQKwdEFeCZTwETh3d9lq6JmsJ4757fVZeWYQznOTsE
   A==;
X-CSE-ConnectionGUID: U+E5/0XiRxy6EmFWm0Z8qw==
X-CSE-MsgGUID: UtyhDKNYQneWF1VuisISTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="80077245"
X-IronPort-AV: E=Sophos;i="6.16,309,1744095600"; 
   d="scan'208";a="80077245"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2025 15:20:38 -0700
X-CSE-ConnectionGUID: d3kZlVwcROm6VnHEIiYTcA==
X-CSE-MsgGUID: +Yn9X7bjSHGdNicWV/WJ0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,309,1744095600"; 
   d="scan'208";a="156891924"
Received: from gpacheco-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.7])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2025 15:20:35 -0700
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
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] KVM: x86: Reject KVM_SET_TSC_KHZ VM ioctl when vCPUs have been created
Date: Mon, 14 Jul 2025 10:20:19 +1200
Message-ID: <135a35223ce8d01cea06b6cef30bfe494ec85827.1752444335.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <cover.1752444335.git.kai.huang@intel.com>
References: <cover.1752444335.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reject the KVM_SET_TSC_KHZ VM ioctl when vCPUs have been created and
update the documentation to reflect it.

The VM scope KVM_SET_TSC_KHZ ioctl is used to set up the default TSC
frequency that all subsequently created vCPUs can use.  It is only
intended to be called before any vCPU is created.  Allowing it to be
called after that only results in confusion but nothing good.

Note this is an ABI change.  But currently in Qemu (the de facto
userspace VMM) only TDX uses this VM ioctl, and it is only called once
before creating any vCPU, therefore the risk of breaking userspace is
pretty low.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 arch/x86/kvm/x86.c             | 9 ++++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 43ed57e048a8..e343430ccb01 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -2006,7 +2006,7 @@ frequency is KHz.
 
 If the KVM_CAP_VM_TSC_CONTROL capability is advertised, this can also
 be used as a vm ioctl to set the initial tsc frequency of subsequently
-created vCPUs.
+created vCPUs. The vm ioctl must be called before any vCPU is created.
 
 4.56 KVM_GET_TSC_KHZ
 --------------------
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2806f7104295..4051c0cacb92 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7199,9 +7199,12 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		if (user_tsc_khz == 0)
 			user_tsc_khz = tsc_khz;
 
-		WRITE_ONCE(kvm->arch.default_tsc_khz, user_tsc_khz);
-		r = 0;
-
+		mutex_lock(&kvm->lock);
+		if (!kvm->created_vcpus) {
+			WRITE_ONCE(kvm->arch.default_tsc_khz, user_tsc_khz);
+			r = 0;
+		}
+		mutex_unlock(&kvm->lock);
 		goto out;
 	}
 	case KVM_GET_TSC_KHZ: {
-- 
2.50.0



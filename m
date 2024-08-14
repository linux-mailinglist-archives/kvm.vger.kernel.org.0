Return-Path: <kvm+bounces-24109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F218951605
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 10:03:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 417061C20CDF
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 08:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 802281411F9;
	Wed, 14 Aug 2024 08:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ML6dKqlg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C25C140397
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 08:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723622563; cv=none; b=iJM4JcQ7lYXP+i+gR9jnBb8m6LcEJn+4hyG0U3IioA02TYh85zSJy8mtsjc89hCkj6SN8EdhZfDsWgTMuxytQItPXWchBwp5Avuvg6FtPuBhBmO4SEqn0/WcgZse2d64SQWxnMTws5tI1wxllC2WewHRzpUO3jgLNtJrTZshHk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723622563; c=relaxed/simple;
	bh=Y3Zdg2gkuvf92qw6n0gEjAnA5h7Gl2EFlz23K8pA8v4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QS3QP2v/YIejyYfMThwPvFZK7oahYB+higaaGfZ6QYRK6Xd0mBZiMQ4khMmdl64pFcLjNW3DmTSzMFhGyeViJi76ZQpq6g8HgapoEEWBeu8o1nqC+mh6YgZ9UClHEY+jxmA9mnfyt0NsvOMIiHrynAGtz18jyxovpREqa9rm+KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ML6dKqlg; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723622562; x=1755158562;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y3Zdg2gkuvf92qw6n0gEjAnA5h7Gl2EFlz23K8pA8v4=;
  b=ML6dKqlgAnwtJo011D8+iOLQBEGuuOOzjkg+fUn04KQMqxejMdH/F9AE
   3WskCeHkpj9/e9s1q3Z0o7ENe/+UykdKLaBU/TeqPLtWNPHbiQTBR2C9G
   rc1GN7QFgp8X4Ldrh+1a0Q1fMuTKsPaTjmJUw2oVRby/F54RbFu5JOQjt
   uEY2gBEHVpXwPIXg4uTa0vMg0/mAI16OTYtohRkBkajW8VsauubFq/8Uf
   q+CZqyBEMi02vDY0gDvNizriWo/OQWdkpJNxYO7+oXQlyauokmqBv7j+L
   ZcmnoZG0jjua6PsWjmQsye3n7+w5HJZHfIAftPRlgdsMCywnAAwQaZMWr
   w==;
X-CSE-ConnectionGUID: lHRnZs4aRf+eATgxcPMcKA==
X-CSE-MsgGUID: wZyd8JrnTmeCOe1nJuPAbQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11163"; a="25584492"
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="25584492"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 01:02:41 -0700
X-CSE-ConnectionGUID: sbz+iBpqTWSIEzia/8Shwg==
X-CSE-MsgGUID: X6d4oiFnSamnUzsFLavRKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,288,1716274800"; 
   d="scan'208";a="59048958"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa010.fm.intel.com with ESMTP; 14 Aug 2024 01:02:40 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com
Subject: [PATCH 6/9] i386/cpu: Set topology info in 0x80000008.ECX only for AMD CPUs
Date: Wed, 14 Aug 2024 03:54:28 -0400
Message-Id: <20240814075431.339209-7-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240814075431.339209-1-xiaoyao.li@intel.com>
References: <20240814075431.339209-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The whole ECX of CPUID 0x80000008 is reserved for Intel.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 5bee84333089..7a4835289760 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6944,7 +6944,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
              *eax |= (cpu->guest_phys_bits << 16);
         }
         *ebx = env->features[FEAT_8000_0008_EBX];
-        if (threads_per_pkg > 1) {
+        if (threads_per_pkg > 1 && IS_AMD_CPU(env)) {
             /*
              * Bits 15:12 is "The number of bits in the initial
              * Core::X86::Apic::ApicId[ApicId] value that indicate
-- 
2.34.1



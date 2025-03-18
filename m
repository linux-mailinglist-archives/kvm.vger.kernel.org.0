Return-Path: <kvm+bounces-41391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12846A677E6
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 16:32:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39F9D17D736
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 15:32:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C651A20CCDB;
	Tue, 18 Mar 2025 15:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dPh6CQMq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EBA20DD66;
	Tue, 18 Mar 2025 15:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742311861; cv=none; b=fthXmZJdU51+u672X18Gu38kECiRj6KZJ7G2Uivn5RDLWDTGHGYhVyKVvXlxSDNef3ZyPbdLJXXMZFh08NZ0yCs7QPpMpfhHC/7akeAnUyA+2j2cNp48FdVArpk1p3JekrmD5uYPVB/Yyv+uSbFC4t2EFVA9PcAkwS6P+Yf+bsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742311861; c=relaxed/simple;
	bh=5T+vyTdGLw+gTxi+8RWL2+dXmbPwVZ4yey4u8CiXLKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d36cChCsX4XgOcvjYFdt3fJ5aH0NMXMkFvCK5xNmDWyKpdz6QlB3XykHLYTmEp/a2TW5Wgb6yOm2EoCKn0F+Kmn6y4XVKk9X03uwyrkxubpBl//AQV+KS7KEg2KFCP3R2piArY98A16G1gg5XgnCrRQmTdh4MjaUDVIbWzpf6yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dPh6CQMq; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742311860; x=1773847860;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5T+vyTdGLw+gTxi+8RWL2+dXmbPwVZ4yey4u8CiXLKg=;
  b=dPh6CQMqwB1/vggJmxMBrelgNA0ELK3MDATqylaEALIMovKgZW93qZZj
   5lGj2kstnwVIL5lEBvkbxA6WgZshBaG3JvYFsEyiSeyEc22JFNnvVNFXX
   8G2abCZIvGKveKaAZS9nK58SvGemER8zY/eNMopKnDcyiCnudkCgl3Gyq
   01heZGaHZmLdClK8FKx1ZXUj6EUeEVLEZP3JxIgLNAbCG5MWM/COGetfQ
   65USIZatGab2JwL8kcsGY4+f4vIB9HGGJnixJzhJcAg1HRksXqVMZ0nZJ
   5Q/dMu12ueM43iyFMTGfRM/XOZixSp6J8k/uR3aXbtsSbD07CFGyh9dIX
   g==;
X-CSE-ConnectionGUID: N5AbTAaBQpmVxF44OllNKw==
X-CSE-MsgGUID: 3Pq7yrdqQyOpq/Ba3Mwb6w==
X-IronPort-AV: E=McAfee;i="6700,10204,11377"; a="46224237"
X-IronPort-AV: E=Sophos;i="6.14,257,1736841600"; 
   d="scan'208";a="46224237"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 08:30:59 -0700
X-CSE-ConnectionGUID: pGzlSG4LS3WTVFdL3mm9CQ==
X-CSE-MsgGUID: WBmMwIAQTgGa1aTMdtcSNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,257,1736841600"; 
   d="scan'208";a="122121895"
Received: from spr.sh.intel.com ([10.239.53.19])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2025 08:30:55 -0700
From: Chao Gao <chao.gao@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	tglx@linutronix.de,
	dave.hansen@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	john.allen@amd.com,
	bp@alien8.de,
	chang.seok.bae@intel.com,
	xin3.li@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Uros Bizjak <ubizjak@gmail.com>,
	Eric Biggers <ebiggers@google.com>,
	Stanislav Spassov <stanspas@amazon.de>
Subject: [PATCH v4 5/8] x86/fpu: Initialize guest FPU permissions from guest defaults
Date: Tue, 18 Mar 2025 23:31:55 +0800
Message-ID: <20250318153316.1970147-6-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20250318153316.1970147-1-chao.gao@intel.com>
References: <20250318153316.1970147-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, fpu->guest_perm is copied from fpu->perm, which is derived from
fpu_kernel_cfg.default_features.

Initialize guest FPU permissions from guest defaults instead of host
defaults. This ensures that any changes to guest_default_{features,size}
are automatically reflected in guest permissions, which in turn guarantees
that fpstate_realloc() allocates a correctly sized XSAVE buffer for guest
FPUs.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kernel/fpu/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 0b695c23bbfb..52df97a8a61b 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -542,8 +542,10 @@ void fpstate_reset(struct fpu *fpu)
 	fpu->perm.__state_perm		= fpu_kernel_cfg.default_features;
 	fpu->perm.__state_size		= fpu_kernel_cfg.default_size;
 	fpu->perm.__user_state_size	= fpu_user_cfg.default_size;
-	/* Same defaults for guests */
-	fpu->guest_perm = fpu->perm;
+
+	fpu->guest_perm.__state_perm	= fpu_kernel_cfg.guest_default_features;
+	fpu->guest_perm.__state_size	= fpu_kernel_cfg.guest_default_size;
+	fpu->guest_perm.__user_state_size = fpu_user_cfg.guest_default_size;
 }
 
 static inline void fpu_inherit_perms(struct fpu *dst_fpu)
-- 
2.46.1



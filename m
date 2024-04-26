Return-Path: <kvm+bounces-16040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 611378B348F
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 11:53:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 937801C2110D
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 09:53:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE56713F01A;
	Fri, 26 Apr 2024 09:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CKWP5U10"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE493142625
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 09:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714125210; cv=none; b=N2a2ZejPe2pGuta3Idd0IR6/WacIogylTbeC00lRfGwzF+/lCJhcTsMApgsI9I9iK1GeS47uNxT9gLGRgAOoLwKYu/IkP3B9klCtJPY/pJpP+kCcsEGf0lYxe7jmD1Ml1W034a5+6z0b2LDmuHxnT9LhaaMzAa/7eEdjP9+cTxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714125210; c=relaxed/simple;
	bh=dbHgXYEF7kX6u5b8GXlmzpie+e+fbcRgQqzu6sj3a4E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pXELvZ3IGra/2yc8zVPRDlmUzQs6UVKqHUZID/xlrnN3JTQUqEepJxcQBsZD/JMF4kIydscAibdRlGF4o6/bmn66LniRZ13uB7cntlYna+Q6D+XM3r5f7uq1j3cLpwyS/Orfv1Q4iuVbzkxj3NJkU+utk5l8Jf3VF5eqMOo8oAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CKWP5U10; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714125209; x=1745661209;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dbHgXYEF7kX6u5b8GXlmzpie+e+fbcRgQqzu6sj3a4E=;
  b=CKWP5U10V8bInzdemabY8QtI4mvFTVGh3hW+7xMnmELxbypAAQ/cK5eG
   i/trgiP7r+Su4QNQLsFx7yIns+/tzkP9Oip6HVSE/lTJvKSKQeal9Qlxq
   y3l4wisZ7ukckI5w7i7Hi/2k7Ne2mQSF8drFexRMdHf2XsHHCBlwg56O1
   lPxG5RzVbLwvIRSONv9sGreoGg4sEOWoTDM7EyaelgYTg6mKggH+sTdwL
   QFpmGonK/rOsDcSEUmGaX9XUh4LQNlWOr+SdjkMWGxbbH0xSwtnzzol9b
   I3H7E1SMhts63+xht0MgSQ9+w4jOJi48LZCb5Z8cY405TvXTRZM8eZSjL
   g==;
X-CSE-ConnectionGUID: kijT8rNASbOMy6TQxx+5sA==
X-CSE-MsgGUID: TGRDCj2QR5qlhfRSEqrpsA==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="9707434"
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="9707434"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 02:53:29 -0700
X-CSE-ConnectionGUID: OE7Qb+3LS+qyruCuMTnl2g==
X-CSE-MsgGUID: xduA+Z6jRnO7PC9XvELYhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="25412339"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa008.fm.intel.com with ESMTP; 26 Apr 2024 02:53:26 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH 5/6] target/i386/kvm: Drop workaround for KVM_X86_DISABLE_EXITS_HTL typo
Date: Fri, 26 Apr 2024 18:07:15 +0800
Message-Id: <20240426100716.2111688-7-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240426100716.2111688-1-zhao1.liu@intel.com>
References: <20240426100716.2111688-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The KVM_X86_DISABLE_EXITS_HTL typo has been fixed in commit
77d361b13c19 ("linux-headers: Update to kernel mainline commit
b357bf602").

Drop the related workaround.

Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/kvm.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index ee0767e8f501..b3ce7da37947 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2692,10 +2692,6 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
 
     if (enable_cpu_pm) {
         int disable_exits = kvm_check_extension(s, KVM_CAP_X86_DISABLE_EXITS);
-/* Work around for kernel header with a typo. TODO: fix header and drop. */
-#if defined(KVM_X86_DISABLE_EXITS_HTL) && !defined(KVM_X86_DISABLE_EXITS_HLT)
-#define KVM_X86_DISABLE_EXITS_HLT KVM_X86_DISABLE_EXITS_HTL
-#endif
         if (disable_exits) {
             disable_exits &= (KVM_X86_DISABLE_EXITS_MWAIT |
                               KVM_X86_DISABLE_EXITS_HLT |
-- 
2.34.1



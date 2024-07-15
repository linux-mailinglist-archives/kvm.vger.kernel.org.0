Return-Path: <kvm+bounces-21617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 492A1930D3E
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 06:34:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 090E22812A5
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 04:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0165C1836C1;
	Mon, 15 Jul 2024 04:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VvOJq7rR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AA013A863
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 04:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721018075; cv=none; b=X/AooiPV5l59tNcFwMzDSALMLg85l8tIM8GVBjyrIlYVSyyHvMwP1jko0SqWymSjhUfxCHIQOw4mFbMYwdQ+0tt0TxQu0fe8fx9vythqTVNV4dYeS51ddsoMYZz3haqKbZAOpMc7SbohXhI/Sxwvf0XrGComnfD18z+0+t0R03Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721018075; c=relaxed/simple;
	bh=B5vJZl3GqGpi4ZMN7bXhTOBiKFTJgl07sNS3UgXe2sI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Nqcd01yZ+XYP8IxjAgiexWtXzKQjbxzVSQjTPkMDRJjs5dkvTtRh33PeLtiH0O/+QhQ6oI6zMaCQuZPKJg/mai4rT0CEjkDCWD+zMRSW10dt2mtYYlJbj+NH+I1daPIz8NFfXeCtSkXJD8BfGokyWwDE7+ZftaRAJEX96u01b1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VvOJq7rR; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721018074; x=1752554074;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B5vJZl3GqGpi4ZMN7bXhTOBiKFTJgl07sNS3UgXe2sI=;
  b=VvOJq7rR5o3eNq3b8J5DtOkmW48mogo2XGjGgQT3HVr806/0DYd81dFr
   kZpVezGBmS5EHM+VIGX2KtUFRQyRQRL854RAfXkYxhKiSbKHhY8HhNQQf
   396S+5Js3M+KtD1P97XurgSq8IAmYKDZoslixs4Nys/MrO9S/7AilgBBr
   F82eTf3Jx2U3MaAhDKrxTJsW51hYagi2wIHKLf2q+25zzeyFRB/JliP/S
   qeDUTUbT3j/iOEuDsBvsgP3q+kMA6NNGil8067kMzbWaP6fkihncz5tkk
   eYMo226f5wDtUroHgWiHQnOWhg7Awk7f6pQ8OWHwNiNC78/TUgwJgJ2o8
   g==;
X-CSE-ConnectionGUID: T21gafr7Qt6v31gLCphTbA==
X-CSE-MsgGUID: wgSi/0cuQ6qk0MNAloWfmA==
X-IronPort-AV: E=McAfee;i="6700,10204,11133"; a="35809843"
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="35809843"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2024 21:34:34 -0700
X-CSE-ConnectionGUID: DAhLR5M+Q0abt/CaMlwelw==
X-CSE-MsgGUID: AWjyEK+EQ8GMdR/vy4ioEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,209,1716274800"; 
   d="scan'208";a="54043088"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 14 Jul 2024 21:34:30 -0700
From: Zhao Liu <zhao1.liu@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Zide Chen <zide.chen@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v3 5/8] target/i386/kvm: Drop workaround for KVM_X86_DISABLE_EXITS_HTL typo
Date: Mon, 15 Jul 2024 12:49:52 +0800
Message-Id: <20240715044955.3954304-6-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240715044955.3954304-1-zhao1.liu@intel.com>
References: <20240715044955.3954304-1-zhao1.liu@intel.com>
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
index 64e54beac7b3..4aae4ffc9ccd 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2728,10 +2728,6 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
 
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



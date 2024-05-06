Return-Path: <kvm+bounces-16695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 21A358BC9B1
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 10:39:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 77A04B21D3B
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 08:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CBCC14038A;
	Mon,  6 May 2024 08:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kUpewMy5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98941428E9
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 08:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714984682; cv=none; b=cEZAEM+mcVMwGSiKjBjoyz4bM1qBuRShSEQThO/8RUhdxgj85yf7H0piE2zNKdL+TUtd2AAAecA+hmkB0r2HhwVsKXyk4N+Kgjs27TWtHnKlw9m/h864EZl5QdkkMfbXbjXguIy7lo0WvZgHlNvU5UN8A4JhYSqBkWpCSplrOc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714984682; c=relaxed/simple;
	bh=dbHgXYEF7kX6u5b8GXlmzpie+e+fbcRgQqzu6sj3a4E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IzXkn/lFYvBL8d5+ymrawJ7CRi71A8lHZNSqmfJo5QO/U37XCFxNCBynCA7C2qQnAEwaJ/gGosOm0DHb9R1I1Va9New60NLWBWciGCQh5mGEcUpScKA+wZq1NlT2ssddDBAZFBzCUtA7KZBSmghfamX5ewuv7wH/XhBnPTXsLdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kUpewMy5; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714984681; x=1746520681;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dbHgXYEF7kX6u5b8GXlmzpie+e+fbcRgQqzu6sj3a4E=;
  b=kUpewMy58bZqNuKcbbXq4cfOFMVPegl9Rk8GXw2v5h7Gjp0zSmBbe2J6
   2nND4Isi7UwfT831cORAJpPA0outGRSawzylKYxmuOcRyCQ3es9rjUALv
   Fv+VIyDDknJkbGTCL5quezPkIt//eSBGrNHQsKNpdJz5BdRP7ak3fvt3T
   uW/ZzsUdzWMIc8COsfv5bPyNPs9WgTWVALwoN1IioHcMwSv3iBgrbZkW7
   GfaiIbS4AzRpv9N/pkGQnLxGTa+Piygbj7aHNL5RCsfe4YW82wtCtjdWN
   6Stmh11aJkDQhmO/L8rOdjHuu9HzhB3yKgUKrZ3CKba+IbWUecPuSWXts
   A==;
X-CSE-ConnectionGUID: VHdLw+7eQ16tcpUETjeP1A==
X-CSE-MsgGUID: +Kc4xCy0SxuEGvzFNXIUjg==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="14533366"
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="14533366"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 01:38:01 -0700
X-CSE-ConnectionGUID: YepjWWxrTXSyU6H3+bb+6Q==
X-CSE-MsgGUID: G+D7BZJbQXGU71FcdhrWyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="28186747"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.36])
  by fmviesa010.fm.intel.com with ESMTP; 06 May 2024 01:37:58 -0700
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
Subject: [PATCH v2 5/6] target/i386/kvm: Drop workaround for KVM_X86_DISABLE_EXITS_HTL typo
Date: Mon,  6 May 2024 16:51:52 +0800
Message-Id: <20240506085153.2834841-6-zhao1.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240506085153.2834841-1-zhao1.liu@intel.com>
References: <20240506085153.2834841-1-zhao1.liu@intel.com>
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



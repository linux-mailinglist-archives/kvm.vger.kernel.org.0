Return-Path: <kvm+bounces-56668-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A9384B41578
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 08:49:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 47DEF7A609B
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 06:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 320762DE6FC;
	Wed,  3 Sep 2025 06:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fl7zXJaM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A1D2DE1E3;
	Wed,  3 Sep 2025 06:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756882063; cv=none; b=KVht5eezNmJrQvSO15ll8LnjbEjs1Tit6zhTcaRB+rUuMzn7zy5nUcBfIIJLz1+2Bq0OCMsVZ8rrZ7D2WMdtZV91O2VhaB1wxtH3+vXQG+Jr2QIqvCgV117+2TuHpNS1QBrwEaFfFzVi9DZ028kZ25hi+RQMBBxTFNVXWseQnYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756882063; c=relaxed/simple;
	bh=wHLvEGEjfsXeVsBn+aRGI7VBJk4E3CE8D19/SY1RQcM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OtVqDQE2s7DkbttJcUUPwXmQ03+aVYJ6jiRasYpW9eT5zRbOle+KiEE8X2rbUhODXGhc5azJfsS6yqUmsXIw9/xJqLXUWtySFem/CfuLay9OYdrXOF8WZDxZbkq2mbXSPan9AWDQSMqzW5DjHEeIMbiBkWbosoU3s3PGGm/AbBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fl7zXJaM; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756882062; x=1788418062;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wHLvEGEjfsXeVsBn+aRGI7VBJk4E3CE8D19/SY1RQcM=;
  b=fl7zXJaMrYGWWbxOzGNUK824jafxQH3t8RYLAbniXbDR8iLGe6vddA3B
   OSpcXI1cXeiu32XcMzuwYUpNFJGbwBfiNOMnNTf8VJk44vK2q/HjXa+Bq
   nOX9RtAEQYTZTLM5P9OZPjJLX8FsTAmFD7/iOjuRhbsdEXr+NPXEK4mK0
   ytvGP+UqQH5vHdpZB5JLC2fzG+RiOy79Tx3qIDzAcpiVti4m0XJtRa5Hf
   /FBAdTwJapGn2n0Ld1vdY5hfDK85zQVKenMoVUu9IiM2hCYSvVD7q2DTZ
   9pbQB7rdCIb52ohfpNQXZgsAgH++k1N4HJOGQyryofbOKDxe8WQECKdUS
   A==;
X-CSE-ConnectionGUID: GdSCfy53QduXhI3G45Gw7Q==
X-CSE-MsgGUID: 3wyQmkNoSsSaeZ2WVDjGZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="63003806"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="63003806"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 23:47:41 -0700
X-CSE-ConnectionGUID: 7fkrRwcHRJqg9lkGn1+R1A==
X-CSE-MsgGUID: JxeZYSXdRNeBPHUBxMjSug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="171656607"
Received: from spr.sh.intel.com ([10.112.230.239])
  by orviesa008.jf.intel.com with ESMTP; 02 Sep 2025 23:47:38 -0700
From: Dapeng Mi <dapeng1.mi@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jim Mattson <jmattson@google.com>,
	Mingwei Zhang <mizhang@google.com>,
	Zide Chen <zide.chen@intel.com>,
	Das Sandipan <Sandipan.Das@amd.com>,
	Shukla Manali <Manali.Shukla@amd.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	dongsheng <dongsheng.x.zhang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Yi Lai <yi1.lai@intel.com>
Subject: [kvm-unit-tests patch v3 6/8] x86/pmu: Expand "llc references" upper limit for broader compatibility
Date: Wed,  3 Sep 2025 14:45:59 +0800
Message-Id: <20250903064601.32131-7-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250903064601.32131-1-dapeng1.mi@linux.intel.com>
References: <20250903064601.32131-1-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: dongsheng <dongsheng.x.zhang@intel.com>

Increase the upper limit of the "llc references" test to accommodate
results observed on additional Intel CPU models, including CWF and
SRF.
These CPUs exhibited higher reference counts that previously caused
the test to fail.

Signed-off-by: dongsheng <dongsheng.x.zhang@intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Yi Lai <yi1.lai@intel.com>
---
 x86/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 6bf6eee3..49d25f68 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -116,7 +116,7 @@ struct pmu_event {
 	{"core cycles", 0x003c, 1*N, 50*N},
 	{"instructions", 0x00c0, 10*N, 10.2*N},
 	{"ref cycles", 0x013c, 1*N, 30*N},
-	{"llc references", 0x4f2e, 1, 2*N},
+	{"llc references", 0x4f2e, 1, 2.5*N},
 	{"llc misses", 0x412e, 1, 1*N},
 	{"branches", 0x00c4, 1*N, 1.1*N},
 	{"branch misses", 0x00c5, 1, 0.1*N},
-- 
2.34.1



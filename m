Return-Path: <kvm+bounces-9634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2845866C46
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:31:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CA152837ED
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:31:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD3B54EB34;
	Mon, 26 Feb 2024 08:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V2gLD7oE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6971B38397;
	Mon, 26 Feb 2024 08:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936064; cv=none; b=pF5J3HEbuQPP9h7Z1CVwgogwrkdjufFplX5oDUtJPirTYnki3/iwu8F5X+Ug9mq2drsFoEL0HH3VlDwNUmLUWwF85/PsqD7Tv2KgyVmN3KJc9SEbu8qw/SPyHrrqKPztaU57QosBZpU+QVfHJno96ZpTfs69J85lTehxhJQp+Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936064; c=relaxed/simple;
	bh=Fyink57/ejQGrZ8tQRVicXDKz0HYEbCM9W9KphhTHVI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r+DAekreflbmQuWO8yoyLk1OGY6bXHq6LZU+FLepVVTXet2AuGjK7AzJFkiXUJw/dq2pbukz43+6HHRPHFynT24qUNoIYMOJsZmT+nXLuyxa26e9MqNYwEnBrV16UhHkjkMr07KNsVjS3oA0nycPVouZLLKEZ6ZtiuHfWmZu7lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V2gLD7oE; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936062; x=1740472062;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fyink57/ejQGrZ8tQRVicXDKz0HYEbCM9W9KphhTHVI=;
  b=V2gLD7oE5oysIguiRSLUZOD6qMydjEB0hYWDSop+WMEMQdy66UUyj3Og
   Ddvy+dJpwOQfb1TPxHWE9G+HL+SJPqsvlvD5eFYnvJnNCFIPtALV663wF
   6+pgklIv5Cbu6/TEo1e6OLGIT2rGzyr5yu6OZYwE/cU5V5Pwkjre8tpoC
   u1BmttzhJkmVGgP7524WF1N0LN4n2qtaZdDX39VLgZfd0OwKzZKnxI3zP
   crLkVGhKhHysOYXYjriP37u8j8KW6aAzy/GsVMXkVb0GTAL3YnZLZmwhu
   TSl7E/CYjvN8lrYWjVT8QGKOwrzZYH+J4U4IM8c+DTzxoxKBCDF9OOQay
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="28631466"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="28631466"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6474321"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:40 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v19 010/130] KVM: x86: Pass is_private to gmem hook of gmem_max_level
Date: Mon, 26 Feb 2024 00:25:12 -0800
Message-Id: <8108cc2b8ff01ec22de68f0d0758ef0671db43fc.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX wants to know the faulting address is shared or private so that the max
level is limited by Secure-EPT or not.  Because fault->gfn doesn't include
shared bit, gfn doesn't tell if the faulting address is shared or not.
Pass is_private for TDX case.

TDX logic will be if (!is_private) return 0; else return PG_LEVEL_4K.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/mmu/mmu.c          | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d15f5b4b1656..57ce89fc2740 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1797,7 +1797,8 @@ struct kvm_x86_ops {
 
 	gva_t (*get_untagged_addr)(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
 
-	int (*gmem_max_level)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, u8 *max_level);
+	int (*gmem_max_level)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn,
+			      bool is_private, u8 *max_level);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1e5e12d2707d..22db1a9f528a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4324,7 +4324,8 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 
 	max_level = kvm_max_level_for_order(max_order);
 	r = static_call(kvm_x86_gmem_max_level)(vcpu->kvm, fault->pfn,
-						fault->gfn, &max_level);
+						fault->gfn, fault->is_private,
+						&max_level);
 	if (r) {
 		kvm_release_pfn_clean(fault->pfn);
 		return r;
-- 
2.25.1



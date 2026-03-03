Return-Path: <kvm+bounces-72493-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id APiZLJ9SpmkbOAAAu9opvQ
	(envelope-from <kvm+bounces-72493-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 04:16:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F7A21E8661
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 04:16:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 81CF930172FD
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 03:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0672837DE8C;
	Tue,  3 Mar 2026 03:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fRO6uEQ+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E528D37CD28;
	Tue,  3 Mar 2026 03:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772507804; cv=none; b=fAjRLUmizNeh+73XydM9STNnXpTd7zjFjLzk+MGmsUcquAe5uGiLNrdPpcb4A2VrN9GqiXFWBhvzWJfJNnzbxVxCTxOobTnrzdi3RtJ8JlOwMYBpysleC87UHBy943h9V3GtTzlCk/iENsZ0/m44ld0hW4+ljAOW5nIVezlN084=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772507804; c=relaxed/simple;
	bh=r3QdDH65r1GQj5+EBgeArSdGhwCr5iFvBwbMRkaQrNc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iIloI0DhUVm/rPcYMXJ+VTeCPoZAGwgtvhymFYhYRb1ynoarw96YAgfO47bxZr7GXesGfhf2OOmbLKw3cgL58921OznVhehQu7MeLaZFPJuGWPby0gbxgd8gx+Rj5K5vWgPQVKbVdA9OgZuipC7yznyWNCF9cbm06oSteKWM4dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fRO6uEQ+; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772507801; x=1804043801;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=r3QdDH65r1GQj5+EBgeArSdGhwCr5iFvBwbMRkaQrNc=;
  b=fRO6uEQ+z8jy7RhiMplE/9/8Gg0Hr1KXRBY1ywwZw9P6a4y/42bV5vQ2
   3L7oiKfhE6xS0B2xfpE+7YAvszjGAYBUkhxYQI5lUJMY5jNcd4y9RIX9m
   J269Igm57lmkG73azTKDbTtzpH5xoIrk/+B1bQeMJPcdCMXqxGyz8V/8t
   IFz0/hcZU4AssTUx9m169lCiY0Vg00NbsvHDkbfGlMNJqD2Pj8kMyJmgM
   g8HrdApVumyojhBUFMlkPB4WSCkCQ9tP7l3H1Uw81BHkOJiWbmMh7sKUU
   7mOnHLa4HmVzsPxXaZFZ5hJWX+LeEPCWQ/e3jq27ssoj8MP60DjHOaA5H
   A==;
X-CSE-ConnectionGUID: oWRaddB7Q9yWHOrK6OceYA==
X-CSE-MsgGUID: S0BImQtZR2iMitwj8iGzIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="83869703"
X-IronPort-AV: E=Sophos;i="6.21,321,1763452800"; 
   d="scan'208";a="83869703"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 19:16:41 -0800
X-CSE-ConnectionGUID: gSw34/KVR4yJg/zNpNggdA==
X-CSE-MsgGUID: LX51ja+MQ7eeGao1wAXEEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,321,1763452800"; 
   d="scan'208";a="216988893"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.22])
  by orviesa006.jf.intel.com with ESMTP; 02 Mar 2026 19:16:38 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	binbin.wu@linux.intel.com,
	Tony Lindgren <tony.lindgren@linux.intel.com>,
	xiaoyao.li@intel.com
Subject: [PATCH v4 0/4] x86/tdx: Clean up the definitions of TDX TD ATTRIBUTES
Date: Tue,  3 Mar 2026 11:03:31 +0800
Message-ID: <20260303030335.766779-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5F7A21E8661
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72493-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xiaoyao.li@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

The main purpose of this series was to remove redundant macros between
core TDX and KVM, along with a typo fix. They were implemented as patch 1
and patch 2.

During the review of v1 and v2, there was encouragement to refine the
names of the macros related to TD attributes to clarify their scope.
Thus patch 3 and patch 4 are added.

Note, Binbin suggested to rename tdx_attributes[] to tdx_td_attributes[]
during v3 review. However, this v4 doesn't do it but leaves it for future
cleanup to avoid making it more complicated because it also looks like
it needs to rename "Attributes" to "TD Attributes" in tdx_dump_attributes(),
which has user visibility change.

Changes in v4:
 - Collect Reviewed-by and Acked-by tags;
 - rebase to v7.0-rc1;

v3: https://lore.kernel.org/kvm/20250715091312.563773-1-xiaoyao.li@intel.com/
Changes in v3:
 - use the changelog provided by Rick for patch 1;
 - collect Reviewed-by on patch 4;
 - Add patch 3;

v2: https://lore.kernel.org/all/20250711132620.262334-1-xiaoyao.li@intel.com/
Changes in v2:
 - collect Reviewed-by;
 - Explains the impact of the change in patch 1 changelog;
 - Add patch 3.

v1: https://lore.kernel.org/all/20250708080314.43081-1-xiaoyao.li@intel.com/

Xiaoyao Li (4):
  x86/tdx: Fix the typo in TDX_ATTR_MIGRTABLE
  KVM: TDX: Remove redundant definitions of TDX_TD_ATTR_*
  x86/tdx: Rename TDX_ATTR_* to TDX_TD_ATTR_*
  KVM: TDX: Rename KVM_SUPPORTED_TD_ATTRS to KVM_SUPPORTED_TDX_TD_ATTRS

 arch/x86/coco/tdx/debug.c         | 26 ++++++++--------
 arch/x86/coco/tdx/tdx.c           |  8 ++---
 arch/x86/include/asm/shared/tdx.h | 50 +++++++++++++++----------------
 arch/x86/kvm/vmx/tdx.c            |  4 +--
 arch/x86/kvm/vmx/tdx_arch.h       |  6 ----
 5 files changed, 44 insertions(+), 50 deletions(-)


base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
-- 
2.43.0



Return-Path: <kvm+bounces-51744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB6EAAFC519
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 10:11:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B28B3B734A
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 08:10:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C126B29CB4B;
	Tue,  8 Jul 2025 08:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O3xOroDH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E1110A1F;
	Tue,  8 Jul 2025 08:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751962270; cv=none; b=Pf7BCyZncKXtavN8BGIzkZH9xRiZ7v/uLwuGxaMjQA9diUEoC7/vrYREHQkKm5q0o26zSZYH5zdluSI0trCVqCtmKfUTzLjze+IVM5icH9X8a/3o4+lWwjI67QxdVZbfLfvrYNmq5QJTpswb/LhDOTBQwZMj2H92x/EC4Gz/C9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751962270; c=relaxed/simple;
	bh=fZoP5zMj3j/v9KP+VNVxGNKnEy+y31RjORQyvc7IUsI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ce3lULR9WJ6nosuRoxeO59nSrn7kYOS81mk2JSp4KivWgjH2yIs5u+hILFQdvH7pyVyxIEJ7Bx3NCIbPYa4+gRAosgqkWjR/FUdjXtibb2Tqv44iaNWPBU6W8LF0qP9l1YNFHeAgYMioO49Y4N1Jbk+phN7ihP/dtT/b9+Htt7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O3xOroDH; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751962268; x=1783498268;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fZoP5zMj3j/v9KP+VNVxGNKnEy+y31RjORQyvc7IUsI=;
  b=O3xOroDH75/habTPQ/MujzmduxwYGvEzhSi1pu0v5/Pe3YhOS+3nWll3
   Eitxo0zdjZm7oCVdelXkbXGhmRDVu0ZPM03OTgx5tvDBoMqZpZae1UbRm
   ERm9d5VDkFHmYxAmBOXVsk86L0VOWRzJwsjs4hQy3tDet1dJdwt4qkeHS
   2OtgWtIv848aba2fEoZ+CgaA3xQfB+NKuLho1fXhTPBZnUdsa0W2MVKa4
   LMxLKZAzdRHr7QOfdESw+1dbxu72Tq0K3LS5L4aOaa21HNWRfHlZHIkkb
   nyhlqZ0VLD44BcWfE+D8LLZNQzE/4km4y7hVVyB1KypUNzN58EFFsCVsw
   A==;
X-CSE-ConnectionGUID: CLb7KMLXRwiPn+la5pIa0Q==
X-CSE-MsgGUID: /IsV/wJJQoCbFvoJsDTi0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="65543209"
X-IronPort-AV: E=Sophos;i="6.16,296,1744095600"; 
   d="scan'208";a="65543209"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 01:11:07 -0700
X-CSE-ConnectionGUID: bjbSTcpkTH+sfJsGSftv3Q==
X-CSE-MsgGUID: UBDC8q1RSiKsAvdOyDoKaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,296,1744095600"; 
   d="scan'208";a="161076584"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 Jul 2025 01:11:02 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	rick.p.edgecombe@intel.com,
	Kai Huang <kai.huang@intel.com>,
	binbin.wu@linux.intel.com,
	yan.y.zhao@intel.com,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	adrian.hunter@intel.com,
	tony.lindgren@intel.com
Subject: [PATCH 0/2] TDX: Clean up the definitions of TDX ATTRIBUTES
Date: Tue,  8 Jul 2025 16:03:12 +0800
Message-ID: <20250708080314.43081-1-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's a simple series. Patch 1 fixes the typo and Patch 2 removes the
redundant definitions of TD ATTRIBUTES bits.

Although some duplications were identified during the community review
of TDX KVM base support[1][2], a few slipped through unnoticed due to
the simultaneous evolution of the TD guest part.

[1] https://lore.kernel.org/all/e5387c7c-9df8-4e39-bbe9-23e8bb09e527@intel.com/
[2] https://lore.kernel.org/all/25bf543723a176bf910f27ede288f3d20f20aed1.camel@intel.com/

Xiaoyao Li (2):
  x86/tdx: Fix the typo of TDX_ATTR_MIGRTABLE
  KVM: TDX: Remove redundant definitions of TDX_TD_ATTR_*

 arch/x86/coco/tdx/debug.c         | 2 +-
 arch/x86/include/asm/shared/tdx.h | 4 ++--
 arch/x86/kvm/vmx/tdx.c            | 4 ++--
 arch/x86/kvm/vmx/tdx_arch.h       | 6 ------
 4 files changed, 5 insertions(+), 11 deletions(-)


base-commit: e4775f57ad51a5a7f1646ac058a3d00c8eec1e98
-- 
2.43.0



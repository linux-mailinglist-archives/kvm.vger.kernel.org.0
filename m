Return-Path: <kvm+bounces-17396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 93EFD8C5E81
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 03:00:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 502FF282524
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 01:00:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05FF0B674;
	Wed, 15 May 2024 01:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c2Il3iH8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6824663B8;
	Wed, 15 May 2024 01:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715734805; cv=none; b=YUNHGD8og+tcEnKzKXC09vufLMdR2N8SQOOTWjUmISSkZBhjU21Y9n5ybHCjtdZY/VkyOAyZnBXfpbuStXIGnPMgFWWeVQTx4wwdJpvHYOVMUlfPCyOmesIVrI2aHX3oHAY1nDC3f8ukD/EjM+QrAYG4bWf6dZCqULwviocGFws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715734805; c=relaxed/simple;
	bh=NOIn7RE8N6eSPebGTNu70aoSxUhtM1LX0A/8k2eeXGI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XssR43L1yukfVvFGUNwzjTaSEAD+yaxx5cBR52AegL1q1jsTtT+s5h21LVa6mdaRf/jiMF01Hp0YxuFOyrXeUgsb5xHWYKMmdEGBLfBKJsCigBomQhQy7t3P1IM0S8t504HgmjiGpF6EHRjpoisoEaBEbpygqBN4HYrZvf5njc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c2Il3iH8; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715734804; x=1747270804;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NOIn7RE8N6eSPebGTNu70aoSxUhtM1LX0A/8k2eeXGI=;
  b=c2Il3iH8pSSw6ST5m/y95THhP2I/mhb++tMxqyGDoE3f9sEFjzc14w0D
   N2axObumd2Cv2AKfeqFNdqQiCAogUfoo0rOHi2jeapr2zzNVfFsRgZU1H
   lgWZD6rSI1JcELrn0/Y9KQFbd3n6HJ4ftYv3hS1KZqrtYOIsXtPAfr3zB
   2v32FJKeuaL6wvL8K1I4nYcOV9d2wBEKvDKqjl7JQhN8myBQsYz1DRllc
   ary9qf4fD6zu5LnNbagQBMby0T2quuL+A1fDvVOKl1+zxRC1xqyAZolIh
   nSou3neZvJUIaQ3VPq+FSH+HbBbEx5g7vlNZjwOtzbf3l/61niH4YsDbi
   A==;
X-CSE-ConnectionGUID: 2yVU9zoXTOyvi/TqDbC+pA==
X-CSE-MsgGUID: YgB9XT5GRC6W2OGcQppilw==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="11613923"
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="11613923"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:02 -0700
X-CSE-ConnectionGUID: oX4pbqPATUi5iDkIAyxSTA==
X-CSE-MsgGUID: 9m3mAfm4TRGlrKTvwfq0YQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="30942704"
Received: from oyildiz-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.51.34])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:01 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com,
	erdemaktas@google.com,
	sagis@google.com,
	yan.y.zhao@intel.com,
	dmatlack@google.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 01/16] KVM: x86: Add a VM type define for TDX
Date: Tue, 14 May 2024 17:59:37 -0700
Message-Id: <20240515005952.3410568-2-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a VM type define for TDX.

Future changes will need to lay the ground work for TDX support by
making some behavior conditional on the VM being a TDX guest.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU Part 1:
 - New patch, split from main series
---
 arch/x86/include/uapi/asm/kvm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 988b5204d636..4dea0cfeee51 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -922,5 +922,6 @@ struct kvm_hyperv_eventfd {
 #define KVM_X86_SEV_VM		2
 #define KVM_X86_SEV_ES_VM	3
 #define KVM_X86_SNP_VM		4
+#define KVM_X86_TDX_VM		5
 
 #endif /* _ASM_X86_KVM_H */
-- 
2.34.1



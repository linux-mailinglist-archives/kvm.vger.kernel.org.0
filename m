Return-Path: <kvm+bounces-67920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A528D175FC
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 09:49:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4B6C63074E61
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 08:46:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68227345CCD;
	Tue, 13 Jan 2026 08:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LpGj/YXD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527A426738C;
	Tue, 13 Jan 2026 08:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768293999; cv=none; b=jzZkv/wn9P5YQyRawF82oq5WgRkvJG4tBxqjWQhiCpTnL6bemUDcoDtqysQ/G3bUrGw0byqh+TIT+l33lylYljsYQqcJQUcDP4mMr7BCVnUGv7zHLWzzp0vQk3FsnySpMT7ulaAU8GWeBbP8+3bGBjgyRIy/3FtLXHDzhjSWNwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768293999; c=relaxed/simple;
	bh=0dyHRoslbwc+3jDiriSU9uhZpwf3O6TWqB/utHvGqG0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j0uYQP97C0/sqx2Rnm39dTi1uDd+rrxUtjQU6DWKxJg/vYqLcW4Z0uCF/sO5FwO5LFWGR0MfndlVFaTyqlhstxmDoCvzrzQ0xLtewooNtejEDypfXPc6qJA0BcjBhoyQNgoL3Zn71VB5mAvDGnNjdQn1iE33Ogu3R1/nOLPAx8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LpGj/YXD; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768293998; x=1799829998;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0dyHRoslbwc+3jDiriSU9uhZpwf3O6TWqB/utHvGqG0=;
  b=LpGj/YXDkbe1NJU2KR9pP9u0N32XyMAMWgI8UoZrU8QnORIwvm8Ikb77
   ZP4SAQlw0xR/0ZAw+sMj5XEKXIZvv2IhIiIrq+KWGCTYwCA+96xJI66EW
   6ZQPa3JV913Ys0igwJILeCHmrI9FWGQs8wEhjmklk0KRfB6iaPAZ0afhC
   w3TvAGobhW/reIYDsyjjj3I9eLRW+Hpv6txRIyGg8u2fueLuZkmspMaro
   0iyNBfOTwpatz+iuwkZBxJuIgunYhaHJNBfp/CgUMoPohDLkvihTASpFc
   v6IQ6FXTHfGsUSNITxEAsFvN7cqN8Y7qnuNr405Rad6TPh8HsSBxyT+2E
   A==;
X-CSE-ConnectionGUID: VSAlw0RgRhydfVyuGaA+ZA==
X-CSE-MsgGUID: ATMLrmtkRT6xnH2bdTyagg==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="69627395"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="69627395"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 00:46:38 -0800
X-CSE-ConnectionGUID: vTLydQ6WTVi1gYiOh0LLyA==
X-CSE-MsgGUID: mbR+trVHTmyNs2iikma/PA==
X-ExtLoop1: 1
Received: from litbin-desktop.sh.intel.com ([10.239.159.60])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 00:46:36 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH] KVM: VMX: Remove declaration of nested_mark_vmcs12_pages_dirty()
Date: Tue, 13 Jan 2026 16:47:48 +0800
Message-ID: <20260113084748.1714633-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the declaration of nested_mark_vmcs12_pages_dirty() from the
header file since it has been moved and renamed to
nested_vmx_mark_all_vmcs12_pages_dirty(), which is a static function.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 arch/x86/kvm/vmx/nested.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 983484d42ebf..b844c5d59025 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -51,7 +51,6 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata);
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 			u32 vmx_instruction_info, bool wr, int len, gva_t *ret);
-void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu);
 bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
 				 int size);
 

base-commit: f62b64b970570c92fe22503b0cdc65be7ce7fc7c
-- 
2.46.0



Return-Path: <kvm+bounces-6684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6410E837875
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:19:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04C601F22A25
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:19:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C1FD80051;
	Mon, 22 Jan 2024 23:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZLpk6URk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C467F7E782;
	Mon, 22 Jan 2024 23:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967773; cv=none; b=aKhjqHtxVMPVZwePH3TBOajgsJsKI6EdXqVJ6LZE9R9eI+56mcpH7rKTFk9Lz7JUhbAl4oYE5ZqFGOqULFrJc39R4e+TGC+iQWswI7hjptnSfL5vyw/KmAIoE+U5RguZF+OoREpqFCX/eu2MmpD3HUH9pEFnJwtgR6bUOmgc7ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967773; c=relaxed/simple;
	bh=b4HChfS3CX9Tl5Kt2Ghy8PbdVyNqBLVx0mpCgM8SJc0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nRU3O/oBX/hgNE6e6hoKUT0M8wv4lrVhQvIzmg5CkMy5DHKMTsgxZpYr9d1rbW/3HloFZ1gFbJtIQG05kMcB+Ti9Kpn8PmWxnT4tAjR8wMvJAuDOOURHWqSsYdSkunF7yAoyebfa/cxiP0Am+8G7OwsKtE2zQS/cfCYjkTF6HaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZLpk6URk; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967770; x=1737503770;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b4HChfS3CX9Tl5Kt2Ghy8PbdVyNqBLVx0mpCgM8SJc0=;
  b=ZLpk6URk9lVRrpt9ubH0HngVuyMHnPCTwZ3TX8boQt7rABAX5efrtN2F
   fEoEVKa+45tYRjzANhKnNz9wBSL8lqscZ7BDOgdTuSt0YUKfE8fYFlQbx
   YawNBbifUy4ro8IkfpxiPb1kiubNWceOumdKmJ1nJtHf1UA/F095+ll9z
   awnLbrPLBpEH9a0sGPFBhpBVyMBt0qXFMHNRG2IJg+Fh/NhiwanYVQaFD
   e7KbGZy8JrCJn/d+CtFyeZ81DwqqHdTWis7gafFevF2eDbKEITTgUgnV4
   XhUlkDf2XgxZOcEXHQkHe8twiQFTTN3WN5qcDsnbzkJE5BRZVJXgLLE5J
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="400217921"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="400217921"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27818014"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:56 -0800
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
Subject: [PATCH v18 109/121] KVM: TDX: Add a method to ignore dirty logging
Date: Mon, 22 Jan 2024 15:54:25 -0800
Message-Id: <d843f2cb62a2ffa2631dce9afa47e53707424551.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Currently TDX KVM doesn't support tracking dirty pages (yet).  Implement a
method to ignore it.  Because the flag for kvm memory slot to enable dirty
logging isn't accepted for TDX, warn on the method is called for TDX.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 420c68330e61..c9f72c383eee 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -847,6 +847,14 @@ static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	return vmx_get_mt_mask(vcpu, gfn, is_mmio);
 }
 
+static void vt_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
+{
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
+	vmx_update_cpu_dirty_logging(vcpu);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -990,7 +998,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.sched_in = vt_sched_in,
 
 	.cpu_dirty_log_size = PML_ENTITY_NUM,
-	.update_cpu_dirty_logging = vmx_update_cpu_dirty_logging,
+	.update_cpu_dirty_logging = vt_update_cpu_dirty_logging,
 
 	.nested_ops = &vmx_nested_ops,
 
-- 
2.25.1



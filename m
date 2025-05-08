Return-Path: <kvm+bounces-45939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3289DAAFE9D
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:12:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C70B3A9198
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:11:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13BBC286D45;
	Thu,  8 May 2025 15:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VCLC/oK0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DEF27A92F
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716808; cv=none; b=UhHX6SI3+kiQbAdu+RCyuLW6Y6rSmvaUeWeI37PhQqgc4LFuoF7DVRMAdzqrCZXgeavF6CiYlr9jw9IubDtopInvmksQnIoy1kAXMsqnAqcOPFxa16xiBLqrmu2goAppF0Su2JsZWZRwf71eLdZl52O1Mh82mI3tZVHM6fv8PL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716808; c=relaxed/simple;
	bh=ANYHc2F1rV315VbmA8qkwGAXXum/vQMDQQnsCx+uzaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BnnnF8C5QkWQmWCK2WhAYdvwAasT2xHqqAmMFVM0T1+53AmDkwQUVYcEEs2y75Wh7O/h/ukKrBZyLOvddrKAw0yEppq0tswrB43DPIGtvFWHzLmonHB1Us+xgqtbZzNsUlxEMn4mZmFZBekuq0eWWSnsQFjpSmQ8lDI0FmIIyy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VCLC/oK0; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716807; x=1778252807;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ANYHc2F1rV315VbmA8qkwGAXXum/vQMDQQnsCx+uzaA=;
  b=VCLC/oK0b7T4eU1AQUJE4i0Fn+njjZ48/YRLBDanR+HP3B+5PAdJekCE
   tMPnzgFzglLrjQuccr3ZvHwg8hPJqMh3aMtI/+ossgNyZQcaUeIti1ZKf
   3TZzCLR5Ob7uP8GfJjCvTDasvFnBEc+bTnMZ9Mi6gsn3eSZP2MGBNF9w3
   XpJPO92I1x5u7iT1/tuC/4XdHmqGU2QrmaNkNUzHjofluPP9NySv+C+hN
   rENozipRToTjJHT5a4YpfHjkZNofI1inpnJ7tjmx26/dZqWEWx/zDWha+
   i2KJE6xBH6usUrkXgtFr7MC+xf0WL98og8MnsrnwEvif5dNXVXyT/LvZb
   A==;
X-CSE-ConnectionGUID: UXV7r50wSu+1+Dz3/ylAjQ==
X-CSE-MsgGUID: xI4S5jtpTamedW2TLxofdA==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888320"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888320"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:06:46 -0700
X-CSE-ConnectionGUID: 10OenehSRx+yyHhzSSyrgQ==
X-CSE-MsgGUID: ErDYjUtpRRKtU+ic0SIzmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440241"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:06:43 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 36/55] i386/tdx: Disable SMM for TDX VMs
Date: Thu,  8 May 2025 10:59:42 -0400
Message-ID: <20250508150002.689633-37-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

TDX doesn't support SMM and VMM cannot emulate SMM for TDX VMs because
VMM cannot manipulate TDX VM's memory.

Disable SMM for TDX VMs and error out if user requests to enable SMM.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/kvm/tdx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index db5a78429cb5..744c5cde3636 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -374,11 +374,20 @@ static Notifier tdx_machine_done_notify = {
 
 static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
+    MachineState *ms = MACHINE(qdev_get_machine());
+    X86MachineState *x86ms = X86_MACHINE(ms);
     TdxGuest *tdx = TDX_GUEST(cgs);
     int r = 0;
 
     kvm_mark_guest_state_protected();
 
+    if (x86ms->smm == ON_OFF_AUTO_AUTO) {
+        x86ms->smm = ON_OFF_AUTO_OFF;
+    } else if (x86ms->smm == ON_OFF_AUTO_ON) {
+        error_setg(errp, "TDX VM doesn't support SMM");
+        return -EINVAL;
+    }
+
     if (!tdx_caps) {
         r = get_tdx_capabilities(errp);
         if (r) {
-- 
2.43.0



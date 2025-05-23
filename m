Return-Path: <kvm+bounces-47546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1F27AC2046
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:56:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58BAE3B202A
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:56:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B6A823CEF8;
	Fri, 23 May 2025 09:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VltBvpx5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FBC2367B8;
	Fri, 23 May 2025 09:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747994033; cv=none; b=nHstEi5aBueMERF4WDNstl7G+ESww8AvudbVtyclH1nY7LvsVwNwL9zQA47i9MPrZDgt47R9kIfTc9N2I/YhP4xwisTzvXhKb3aW03n8wIxnLdRUfmSQJ2la9u/jfI0guAujHHg9lO0iOhXhN7c2dJZByylGNpz0lp8H3HMECXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747994033; c=relaxed/simple;
	bh=TsI9HxQ2Gz6GuimkwqYvAK3v4dW3I+m/53VcN46/PpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQspgpnr53GPYH7BqTqVMO6Gryz9nRpPOUZt70ys8wm0Kis3nRB5KRKBZT2Mtgg4LOeBR+Oaap91a0J/NNWjBgQJqhftUK5sv40s4xvSJZ+ahrUfVNqpknmNpdRD33DNbjCNSaZ4PWy8MINZo/inQmFiSEw8G4e+AoG4wv6rSFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VltBvpx5; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747994032; x=1779530032;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TsI9HxQ2Gz6GuimkwqYvAK3v4dW3I+m/53VcN46/PpA=;
  b=VltBvpx5doJ7MwBZd6fpvvl/XqhwJSyR7WS3CqXzOt5bxLzaj7vsbVTe
   ZLNFKETaIaQCEtru+BygeRSFRa8MakzpGgIwRNb1/Cozpe66xZ6y2RlTP
   PuiJ7AvQCAp/m5sgtNgel+lMQQJa61kTDIIRYNZvxe5qwtOSBIGvNzU+5
   AZ9fsbRgoddtRDYHv84TODAZgTdHvtJYudxoya5rSJ4Fr7l4vQRuxT33e
   O0glqNpMUqnENhjEilV5dWE2i6oI5LHTv6U7S9q6qmg8x9HmHkw0ZIA/H
   tDuY037Ns7NKD9iIOBQ3CKtWeXdN75HZjo1AjtX1cjezs+WMfc9y5QMPO
   w==;
X-CSE-ConnectionGUID: xVHOTc67TbyeCXQdy4XG1A==
X-CSE-MsgGUID: tNp3URM4RmKKs43LSBG8NA==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="75444189"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="75444189"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:51 -0700
X-CSE-ConnectionGUID: 4G5ctHf6RjuhrRGHbSR6Nw==
X-CSE-MsgGUID: NBdC9/7BTGS+2BkR2PyaCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="164315072"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:50 -0700
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	x86@kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	eddie.dong@intel.com,
	kirill.shutemov@intel.com,
	dave.hansen@intel.com,
	dan.j.williams@intel.com,
	kai.huang@intel.com,
	isaku.yamahata@intel.com,
	elena.reshetova@intel.com,
	rick.p.edgecombe@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 11/20] x86/virt/seamldr: Abort updates if errors occurred midway
Date: Fri, 23 May 2025 02:52:34 -0700
Message-ID: <20250523095322.88774-12-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250523095322.88774-1-chao.gao@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The update process is divided into multiple stages, each of which may
encounter failures. However, the current state machine for updates proceeds
to the next stage regardless of errors.

Continuing updates when errors occur midway is pointless.

Implement a mechanism that transitions directly to the final stage,
effectively aborting the update and skipping all remaining stages when an
error is detected.

This is in preparation for adding the first stage that may fail.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
 arch/x86/virt/vmx/tdx/seamldr.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index 01dc2b0bc4a5..9d0d37a92bfd 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -247,6 +247,7 @@ enum tdp_state {
 static struct {
 	enum tdp_state state;
 	atomic_t thread_ack;
+	atomic_t failed;
 } tdp_data;
 
 static void set_state(enum tdp_state state)
@@ -261,8 +262,16 @@ static void set_state(enum tdp_state state)
 /* Last one to ack a state moves to the next state. */
 static void ack_state(void)
 {
-	if (atomic_dec_and_test(&tdp_data.thread_ack))
-		set_state(tdp_data.state + 1);
+	if (atomic_dec_and_test(&tdp_data.thread_ack)) {
+		/*
+		 * If an error occurred, abort the update by skipping to
+		 * the final state
+		 */
+		if (atomic_read(&tdp_data.failed))
+			set_state(TDP_DONE);
+		else
+			set_state(tdp_data.state + 1);
+	}
 }
 
 /*
@@ -285,6 +294,9 @@ static int do_seamldr_install_module(void *params)
 			default:
 				break;
 			}
+
+			if (ret)
+				atomic_inc(&tdp_data.failed);
 			ack_state();
 		} else {
 			touch_nmi_watchdog();
@@ -314,6 +326,7 @@ static int seamldr_install_module(const u8 *data, u32 size)
 	if (IS_ERR(params))
 		return PTR_ERR(params);
 
+	atomic_set(&tdp_data.failed, 0);
 	set_state(TDP_START + 1);
 	return stop_machine(do_seamldr_install_module, params, cpu_online_mask);
 }
-- 
2.47.1



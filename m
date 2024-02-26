Return-Path: <kvm+bounces-9716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2DAE866D57
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:58:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D524282FAB
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F5B07C6C8;
	Mon, 26 Feb 2024 08:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=intel.com header.i=@intel.com header.b="U3pgJNqI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A287E7AE52;
	Mon, 26 Feb 2024 08:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936133; cv=none; b=goPw+waxVSiY2AgP5WvkL/t1rFcXTUjbSMKIxK2On6Tujx4XGbjNjz0aOgwaDC8+Cn1cjtHWH8lwCq8SnFZL9hGVLq2xPQpGgxR8fAxEXqyR7tTAhAOOiKGUw0hgbYw55gJV9yDHTpGp9M6QdDW3XdRLUtHyr8cY2UZAc767z0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936133; c=relaxed/simple;
	bh=8srNeTZplG2ftxUe7RfzcGruSkR0LpbTdRnxJyIOPTQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n+5VFxFW+REiQ/tN9nESidefxIfI9rs6WSIv+tfQ4Mx/gnnIUk71qt5jJqDzOlUGTY3F5YVrBmD8NBpKaoqgRW4vUzXTFyCwz2DNwINa3BNrZcrAY7c40YL/LhJ35qQAAg3MUhEwqRD9gRqnfcu1kirLZtR4shbuXBYOkHG09x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U3pgJNqI; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936132; x=1740472132;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8srNeTZplG2ftxUe7RfzcGruSkR0LpbTdRnxJyIOPTQ=;
  b=U3pgJNqI7q9mouSD+psZBjkzyPrmAktiNCS83+XBGchTJbZ3rlO4qfi0
   wYcA32wNj2O5nyDBUPk6JmjxbhYqM6thgzKdHN3xWsxgj8hBk/ek077sA
   PR7GYXZMhHAFMNjiQtd2DEH0sgeRAfBcWPs9dy+IwTGXvw4maG8wHOFe0
   HKoFHStkRL9pmNQeOLG/kktUbdhZj9cZK0fa46u5Sz2c8VTTNaSzMbg5z
   Ge7Q5hZ2fYKWCsSDHbkBbpsTQJTBQ1WWt1V4kThtwc8ao57daK+glbhwB
   UvRJy1gEf+4jYCQqLv75dRr80C5XYJQh0W0lx+ToFki6JLOkTr2plbx99
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3069567"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3069567"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="11272653"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:51 -0800
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
Subject: [PATCH v19 093/130] KVM: TDX: Implements vcpu request_immediate_exit
Date: Mon, 26 Feb 2024 00:26:35 -0800
Message-Id: <3fd2824a8f77412476b58155776e88dfe84a8c73.1708933498.git.isaku.yamahata@intel.com>
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

Now we are able to inject interrupts into TDX vcpu, it's ready to block TDX
vcpu.  Wire up kvm x86 methods for blocking/unblocking vcpu for TDX.  To
unblock on pending events, request immediate exit methods is also needed.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/main.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index f2c9d6358f9e..ee6c04959d4c 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -372,6 +372,16 @@ static void vt_enable_irq_window(struct kvm_vcpu *vcpu)
 	vmx_enable_irq_window(vcpu);
 }
 
+static void vt_request_immediate_exit(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		__kvm_request_immediate_exit(vcpu);
+		return;
+	}
+
+	vmx_request_immediate_exit(vcpu);
+}
+
 static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	if (is_td_vcpu(vcpu))
@@ -549,7 +559,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
 
-	.request_immediate_exit = vmx_request_immediate_exit,
+	.request_immediate_exit = vt_request_immediate_exit,
 
 	.sched_in = vt_sched_in,
 
-- 
2.25.1



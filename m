Return-Path: <kvm+bounces-16683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A29C8BC88E
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 09:49:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B97962809E2
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:49:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CC85140389;
	Mon,  6 May 2024 07:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N4lm6PsX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F2942ABE;
	Mon,  6 May 2024 07:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714981742; cv=none; b=MHjqz+1d8Bz3PwRmXoeSgguDxH9qFkr3aa8l5l61k1siufvHWsSe/+Vhl71CzhPvxO0+h9gDhXw/7BNYoComZQXVbQimWXlY7CG/WGwDSogPPiRZV8adN9xZ8rDmYvwSCPpFxqz/FuV+K6WObQilaMiPduZivIvu9suB30PT4oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714981742; c=relaxed/simple;
	bh=OWCqVsjgfLNQN6XDNs/tB8tkUMXSZcy5HJhfHw0iAsw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fugM/i/SQw21osdaqXNheVa+Rz77CAe0zy0SqiiWVxaO7Kgj6YWCg3zp7srFiFwC4UUC8MIFm7KumpvpVjkmHNCu+Bmb5TfSsVMZTZPXgeH1MlycdFMmCVWJqEEZ5Heye74SxJYHoyszGfDuxa9h/kQ4SARJ4XMwTL+u7qmgYgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N4lm6PsX; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714981740; x=1746517740;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OWCqVsjgfLNQN6XDNs/tB8tkUMXSZcy5HJhfHw0iAsw=;
  b=N4lm6PsX8IWO4hEnKTLJR3lemUDWJmeu8nhESozKEW2uT0wysM1yOJsS
   c/LdO0Od11BMSZDJ4RwA/NlD261LYL55OBFQXSKj5hLw8u5BORNoY3rQI
   hH1/lIyhvjdcOjZDhqjPw28vKtEZ6IEjXOypGn86ECwEYZqFOm4ypfEnm
   2tl+822+lpK4CgkbBHLto3y6OEfRnaH2k1Cwqy+xz0VrhwMlU+5OARrx4
   iQlH9pc4R7bepL3K+EBC2WxuRl1Qwa0nF3IGuRKOFCMjdszqIA2pGhsua
   MmWRcZM1mKozH7U72SZmp1WXZj8MMPnap7GpnJpRkaH9TEy4N3X82kdet
   w==;
X-CSE-ConnectionGUID: 4cwa4OnARymaR/t89ZnNYQ==
X-CSE-MsgGUID: k45d4y2OSUGxSaibQdWDjA==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="14521183"
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="14521183"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 00:49:00 -0700
X-CSE-ConnectionGUID: IqlXt6B0ReGFum9OufbOdg==
X-CSE-MsgGUID: TOlTN3aNTpag/I7/R9d2yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="28194981"
Received: from unknown (HELO litbin-desktop.sh.intel.com) ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 00:48:58 -0700
From: Binbin Wu <binbin.wu@linux.intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com
Subject: [PATCH] KVM: VMX: Remove unused declaration of vmx_request_immediate_exit()
Date: Mon,  6 May 2024 15:50:25 +0800
Message-Id: <20240506075025.2251131-1-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After commit 0ec3d6d1f169 "KVM: x86: Fully defer to vendor code to decide
how to force immediate exit", vmx_request_immediate_exit() was removed.
Commit 5f18c642ff7e "KVM: VMX: Move out vmx_x86_ops to 'main.c' to dispatch
VMX and TDX" added its declaration by accident.  Remove it.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 arch/x86/kvm/vmx/x86_ops.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 502704596c83..dfab2c2941ad 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -111,7 +111,6 @@ u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
 u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
 void vmx_write_tsc_offset(struct kvm_vcpu *vcpu);
 void vmx_write_tsc_multiplier(struct kvm_vcpu *vcpu);
-void vmx_request_immediate_exit(struct kvm_vcpu *vcpu);
 void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu);
 void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_X86_64

base-commit: d91a9cc16417b8247213a0144a1f0fd61dc855dd
-- 
2.25.1



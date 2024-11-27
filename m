Return-Path: <kvm+bounces-32578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E22C49DAC66
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 18:27:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8800281FE4
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 17:27:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E06B920102E;
	Wed, 27 Nov 2024 17:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="WGcRtgGn"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1BC201015;
	Wed, 27 Nov 2024 17:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732728439; cv=none; b=C9y7ptXB45qHgcsllwD1iLdQ1KdzKyLZeT3TW0foUwCDlCKnpjkbktVHzcSpPFrv6KgeB9GqkSmHFviu97eUkbzgJ5TexubdzlqrEkFch9oSy5mlxeM+inhNbJ8+8gHwRS/Hxxv0QODBXmF2rJltqGZ/Zr9VLbe4YZIbcdIL15c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732728439; c=relaxed/simple;
	bh=nJBntq5uO6X48ySks1M3TZ3OxhXfIp8sEhnATvW7FYU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F/VC4lNZ2fTlCiK9tx6DcVnopCSqV4/5yNtsqNUCD7r5T5THcrXM0JqmyU0zLnQM9UhltaL55Zr1OQoneDgJk6YR2xVbJBP/pk8i0v7V0vaOCpkNrGGdxN/CMNOjXRAkA4sZrnD2rOrd2uiAVO/ieFkA6RQJy9Vpm42M8wYqRRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=WGcRtgGn; arc=none smtp.client-ip=52.119.213.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1732728437; x=1764264437;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bOmd4E3lsFVdBvT0oW0OPxVe248CAFYzDYI42KC0ZKg=;
  b=WGcRtgGn5S3pAXNqlyuzQCIpova0uet8Jd+6PgNKTc5y6KSnk/yBj+Fb
   xYRz4y2NLvb0gKuLxYjD7I+pnL8/FwnJ5XSC2YzQizC8nCRO/sptoU8jr
   Xjpbz5jwyYLP1KNoI2MIttw3/kR99yx+zdFYNtDYJeF2xouLcn1ceQ5ER
   0=;
X-IronPort-AV: E=Sophos;i="6.12,189,1728950400"; 
   d="scan'208";a="250657947"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.124.125.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 17:27:14 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.10.100:62956]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.11.83:2525] with esmtp (Farcaster)
 id 6824311c-4883-4800-8acf-dd639e9bec52; Wed, 27 Nov 2024 17:27:13 +0000 (UTC)
X-Farcaster-Flow-ID: 6824311c-4883-4800-8acf-dd639e9bec52
Received: from EX19D030EUC001.ant.amazon.com (10.252.61.228) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 27 Nov 2024 17:27:12 +0000
Received: from EX19MTAUEB001.ant.amazon.com (10.252.135.35) by
 EX19D030EUC001.ant.amazon.com (10.252.61.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 27 Nov 2024 17:27:12 +0000
Received: from email-imr-corp-prod-pdx-all-2c-619df93b.us-west-2.amazon.com
 (10.124.125.2) by mail-relay.amazon.com (10.252.135.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Wed, 27 Nov 2024 17:27:12 +0000
Received: from dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com (dev-dsk-kalyazin-1a-a12e27e2.eu-west-1.amazon.com [172.19.103.116])
	by email-imr-corp-prod-pdx-all-2c-619df93b.us-west-2.amazon.com (Postfix) with ESMTPS id 572FB40314;
	Wed, 27 Nov 2024 17:27:09 +0000 (UTC)
From: Nikita Kalyazin <kalyazin@amazon.com>
To: <pbonzini@redhat.com>, <corbet@lwn.net>, <seanjc@google.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<vkuznets@redhat.com>, <xiaoyao.li@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>
CC: <roypat@amazon.co.uk>, <xmarcalx@amazon.com>, <kalyazin@amazon.com>
Subject: [PATCH 1/2] KVM: x86: async_pf: remove support for KVM_ASYNC_PF_SEND_ALWAYS
Date: Wed, 27 Nov 2024 17:26:53 +0000
Message-ID: <20241127172654.1024-2-kalyazin@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20241127172654.1024-1-kalyazin@amazon.com>
References: <20241127172654.1024-1-kalyazin@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

3a7c8fafd1b42adea229fd204132f6a2fb3cd2d9 ("x86/kvm: Restrict
ASYNC_PF to user space") stopped setting KVM_ASYNC_PF_SEND_ALWAYS in
Linux guests.  While the flag can still be used by legacy guests, the
mechanism is best effort so KVM is not obliged to use it.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
---
 Documentation/virt/kvm/x86/msr.rst   | 11 +++++------
 arch/x86/include/asm/kvm_host.h      |  1 -
 arch/x86/include/uapi/asm/kvm_para.h |  2 +-
 arch/x86/kvm/x86.c                   |  4 +---
 4 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/Documentation/virt/kvm/x86/msr.rst b/Documentation/virt/kvm/x86/msr.rst
index 3aecf2a70e7b..b3bbc12b5d03 100644
--- a/Documentation/virt/kvm/x86/msr.rst
+++ b/Documentation/virt/kvm/x86/msr.rst
@@ -208,12 +208,11 @@ data:
 
 	Bits 5-4 of the MSR are reserved and should be zero. Bit 0 is set to 1
 	when asynchronous page faults are enabled on the vcpu, 0 when disabled.
-	Bit 1 is 1 if asynchronous page faults can be injected when vcpu is in
-	cpl == 0. Bit 2 is 1 if asynchronous page faults are delivered to L1 as
-	#PF vmexits.  Bit 2 can be set only if KVM_FEATURE_ASYNC_PF_VMEXIT is
-	present in CPUID. Bit 3 enables interrupt based delivery of 'page ready'
-	events. Bit 3 can only be set if KVM_FEATURE_ASYNC_PF_INT is present in
-	CPUID.
+	Bit 1 is reserved and should be zero. Bit 2 is 1 if asynchronous page
+	faults are delivered to L1 as #PF vmexits.  Bit 2 can be set only if
+	KVM_FEATURE_ASYNC_PF_VMEXIT is present in CPUID. Bit 3 enables
+	interrupt based delivery of 'page ready' events. Bit 3 can only be set
+	if KVM_FEATURE_ASYNC_PF_INT is present in CPUID.
 
 	'Page not present' events are currently always delivered as synthetic
 	#PF exception. During delivery of these events APF CR2 register contains
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e159e44a6a1b..8ce00b17316f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -975,7 +975,6 @@ struct kvm_vcpu_arch {
 		u64 msr_int_val; /* MSR_KVM_ASYNC_PF_INT */
 		u16 vec;
 		u32 id;
-		bool send_user_only;
 		u32 host_apf_flags;
 		bool delivery_as_pf_vmexit;
 		bool pageready_pending;
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index a1efa7907a0b..5558a1ec3dc9 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -87,7 +87,7 @@ struct kvm_clock_pairing {
 #define KVM_MAX_MMU_OP_BATCH           32
 
 #define KVM_ASYNC_PF_ENABLED			(1 << 0)
-#define KVM_ASYNC_PF_SEND_ALWAYS		(1 << 1)
+#define KVM_ASYNC_PF_SEND_ALWAYS		(1 << 1) /* deprecated */
 #define KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT	(1 << 2)
 #define KVM_ASYNC_PF_DELIVERY_AS_INT		(1 << 3)
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2e713480933a..8f784f07d423 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3558,7 +3558,6 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 					sizeof(u64)))
 		return 1;
 
-	vcpu->arch.apf.send_user_only = !(data & KVM_ASYNC_PF_SEND_ALWAYS);
 	vcpu->arch.apf.delivery_as_pf_vmexit = data & KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT;
 
 	kvm_async_pf_wakeup_all(vcpu);
@@ -13361,8 +13360,7 @@ static bool kvm_can_deliver_async_pf(struct kvm_vcpu *vcpu)
 	if (!kvm_pv_async_pf_enabled(vcpu))
 		return false;
 
-	if (vcpu->arch.apf.send_user_only &&
-	    kvm_x86_call(get_cpl)(vcpu) == 0)
+	if (kvm_x86_call(get_cpl)(vcpu) == 0)
 		return false;
 
 	if (is_guest_mode(vcpu)) {
-- 
2.40.1



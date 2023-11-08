Return-Path: <kvm+bounces-1183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CE7C7E5557
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:24:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD0911C20DF1
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:24:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16EE418029;
	Wed,  8 Nov 2023 11:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="lRDOzF+2"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79497179AA;
	Wed,  8 Nov 2023 11:24:26 +0000 (UTC)
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A871FC2;
	Wed,  8 Nov 2023 03:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442667; x=1730978667;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r3WKjqld4qql+FLcnzKJq/fsWtORZpLYW1PJ8L9F7HI=;
  b=lRDOzF+2/uSWtu6g6xiZPogGFIFZOEPhkU35BDMtOA7U8brSCvQ0mnZX
   jD8hivVkW40ZS2DOg3FS40/NOB5hG3A4n2gQbMg/ocMKnrcgInsI44svG
   MLXztXFUWmKvEOTR2olymytYWaNwqvRsY2Z8rlBbsWNEtaQ+AKlJonGxq
   w=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="618316712"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-54a853e6.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:24:26 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan3.iad.amazon.com [10.32.235.38])
	by email-inbound-relay-iad-1a-m6i4x-54a853e6.us-east-1.amazon.com (Postfix) with ESMTPS id 2BB5348ECD;
	Wed,  8 Nov 2023 11:24:21 +0000 (UTC)
Received: from EX19MTAEUC001.ant.amazon.com [10.0.10.100:34530]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.22.222:2525] with esmtp (Farcaster)
 id ada2ae65-467f-4b1a-8aba-0d7dc7fba03f; Wed, 8 Nov 2023 11:24:21 +0000 (UTC)
X-Farcaster-Flow-ID: ada2ae65-467f-4b1a-8aba-0d7dc7fba03f
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:24:19 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:24:14 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 29/33] KVM: VMX: Save instruction length on EPT violation
Date: Wed, 8 Nov 2023 11:18:02 +0000
Message-ID: <20231108111806.92604-30-nsaenz@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231108111806.92604-1-nsaenz@amazon.com>
References: <20231108111806.92604-1-nsaenz@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.13.235.138]
X-ClientProxiedBy: EX19D031UWC003.ant.amazon.com (10.13.139.252) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

Save the length of the instruction that triggered an EPT violation in
struct kvm_vcpu_arch. This will be used to populate Hyper-V VSM memory
intercept messages.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/vmx/vmx.c          | 1 +
 2 files changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1f5a85d461ce..1a854776d91e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -967,6 +967,8 @@ struct kvm_vcpu_arch {
 	/* set at EPT violation at this point */
 	unsigned long exit_qualification;
 
+	u32 exit_instruction_len;
+
 	/* pv related host specific info */
 	struct {
 		bool pv_unhalted;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6e502ba93141..9c83ee3a293d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5773,6 +5773,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
 
 	vcpu->arch.exit_qualification = exit_qualification;
+	vcpu->arch.exit_instruction_len = vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
 
 	/*
 	 * Check that the GPA doesn't exceed physical memory limits, as that is
-- 
2.40.1



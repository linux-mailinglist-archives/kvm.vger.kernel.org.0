Return-Path: <kvm+bounces-1185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B4647E5560
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:25:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E7897B209B4
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:25:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE5F2D267;
	Wed,  8 Nov 2023 11:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="Z/YNBkoS"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC14F1865A;
	Wed,  8 Nov 2023 11:24:57 +0000 (UTC)
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD7381BF5;
	Wed,  8 Nov 2023 03:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442697; x=1730978697;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hHT68F7U7dwhmAs9bVBPKto3xQgEmy+Yqg+nDVOZ3bk=;
  b=Z/YNBkoSDl3C+MQdSyj0WVOqBtScLnHFTYLoa/mgxst4T3XouSIqXDY7
   08g7AF1/ysE6OdUdRt+IidJ/ZqoU6FjJiLUuSTm6iCJrIUEnTY+9lYI31
   33iAME9kYq483k9N/5zJOejtipoiwZEIG8ED5QAyU0IJ3ZVm8efotJoo3
   c=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="614866460"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-1box-2bm6-32cf6363.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:24:55 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan2.pdx.amazon.com [10.39.38.66])
	by email-inbound-relay-pdx-1box-2bm6-32cf6363.us-west-2.amazon.com (Postfix) with ESMTPS id 14BD280674;
	Wed,  8 Nov 2023 11:24:54 +0000 (UTC)
Received: from EX19MTAEUB002.ant.amazon.com [10.0.43.254:55642]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.26.101:2525] with esmtp (Farcaster)
 id b825c34a-ac0f-48ab-b5f4-78e61c5f00c9; Wed, 8 Nov 2023 11:24:53 +0000 (UTC)
X-Farcaster-Flow-ID: b825c34a-ac0f-48ab-b5f4-78e61c5f00c9
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:24:52 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:24:47 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 31/33] KVM: x86: hyper-v: Inject intercept on VTL memory protection fault
Date: Wed, 8 Nov 2023 11:18:04 +0000
Message-ID: <20231108111806.92604-32-nsaenz@amazon.com>
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
X-ClientProxiedBy: EX19D032UWB003.ant.amazon.com (10.13.139.165) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

Inject a Hyper-V secure intercept when a VTL tries to access memory that
was protected by a more privileged VTL. The intercept is injected into
the next enabled privileged VTL (for now, this patch takes a shortcut
and assumes it's the one right after).

After injecting the request, the KVM vCPU that took the fault will exit
to user-space with a memory fault.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/kvm/hyperv.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 38ee3abdef9c..983bf8af5f64 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -3150,6 +3150,32 @@ struct kvm_hv_vtl_dev {
 
 static struct xarray *kvm_hv_vsm_get_memprots(struct kvm_vcpu *vcpu);
 
+static void kvm_hv_inject_gpa_intercept(struct kvm_vcpu *vcpu,
+					struct kvm_page_fault *fault)
+{
+	struct kvm_vcpu *target_vcpu =
+		kvm_hv_get_vtl_vcpu(vcpu, kvm_hv_get_active_vtl(vcpu) + 1);
+	struct kvm_vcpu_hv_intercept_info *intercept =
+		&target_vcpu->arch.hyperv->intercept_info;
+
+	/*
+        * No target VTL available, log a warning and let user-space deal with
+        * the fault.
+        */
+	if (WARN_ON_ONCE(!target_vcpu))
+		return;
+
+	intercept->type = HVMSG_GPA_INTERCEPT;
+	intercept->gpa = fault->addr;
+	intercept->access = (fault->user ? HV_INTERCEPT_ACCESS_READ : 0) |
+			    (fault->write ? HV_INTERCEPT_ACCESS_WRITE : 0) |
+			    (fault->exec ? HV_INTERCEPT_ACCESS_EXECUTE : 0);
+	intercept->vcpu = vcpu;
+
+	kvm_make_request(KVM_REQ_HV_INJECT_INTERCEPT, target_vcpu);
+	kvm_vcpu_kick(target_vcpu);
+}
+
 bool kvm_hv_vsm_access_valid(struct kvm_page_fault *fault, unsigned long attrs)
 {
 	if (attrs == KVM_MEMORY_ATTRIBUTE_NO_ACCESS)
@@ -3194,6 +3220,7 @@ int kvm_hv_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		return RET_PF_CONTINUE;
 	}
 
+	kvm_hv_inject_gpa_intercept(vcpu, fault);
 	return -EFAULT;
 }
 
-- 
2.40.1



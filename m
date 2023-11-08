Return-Path: <kvm+bounces-1160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90C037E54F4
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:20:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B3802816E6
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:20:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 504B015EB9;
	Wed,  8 Nov 2023 11:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="uoXdxXqx"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7D415E89;
	Wed,  8 Nov 2023 11:19:53 +0000 (UTC)
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FA91BEB;
	Wed,  8 Nov 2023 03:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442393; x=1730978393;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cyTCynOmMb0cQQa0wX5d7cLulbacT3tvj9NSCTRwhHI=;
  b=uoXdxXqxTJ+aXNNZAiSwqC9CpZyqE0rCCsnQYVD3oz+KZfPUCxjMgi4v
   DkfMnOq7N8xKvScGfVrJBv3yt4HvH5QadPHsir17js6YhAczT4/E+p9rz
   oaY9CCXZCcpgJ/iaZplwBa90b6O131+qYzCpi7o2Pu+rtUv12nNOFpB2p
   Q=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="366812308"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-f05d30a1.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:19:52 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan3.iad.amazon.com [10.32.235.38])
	by email-inbound-relay-iad-1d-m6i4x-f05d30a1.us-east-1.amazon.com (Postfix) with ESMTPS id 23B2F80D5F;
	Wed,  8 Nov 2023 11:19:48 +0000 (UTC)
Received: from EX19MTAEUA002.ant.amazon.com [10.0.10.100:19113]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.43.105:2525] with esmtp (Farcaster)
 id fbe08b9c-13d3-4e3e-a014-4f60b4421048; Wed, 8 Nov 2023 11:19:48 +0000 (UTC)
X-Farcaster-Flow-ID: fbe08b9c-13d3-4e3e-a014-4f60b4421048
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:19:47 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:19:43 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 08/33] KVM: x86: Don't use hv_timer if CAP_HYPERV_VSM enabled
Date: Wed, 8 Nov 2023 11:17:41 +0000
Message-ID: <20231108111806.92604-9-nsaenz@amazon.com>
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
X-ClientProxiedBy: EX19D033UWC002.ant.amazon.com (10.13.139.196) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

VSM's VTLs are modeled by using a distinct vCPU per VTL. While one VTL
is running the rest of vCPUs are left idle. This doesn't play well with
the approach of tracking emulated timer expiration by using the VMX
preemption timer. Inactive VTL's timers are still meant to run and
inject interrupts regardless of their runstate.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/kvm/lapic.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f55d216cb2a0..8cc75b24381b 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -152,9 +152,10 @@ static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
 
 bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
 {
-	return kvm_x86_ops.set_hv_timer
-	       && !(kvm_mwait_in_guest(vcpu->kvm) ||
-		    kvm_can_post_timer_interrupt(vcpu));
+	return kvm_x86_ops.set_hv_timer &&
+	       !(kvm_mwait_in_guest(vcpu->kvm) ||
+		 kvm_can_post_timer_interrupt(vcpu)) &&
+	       !(kvm_hv_vsm_enabled(vcpu->kvm));
 }
 
 static bool kvm_use_posted_timer_interrupt(struct kvm_vcpu *vcpu)
-- 
2.40.1



Return-Path: <kvm+bounces-1154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FB8E7E54DB
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:18:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60EC61C20DCF
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:18:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4057816404;
	Wed,  8 Nov 2023 11:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="cY0+dRyP"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CC7156FD;
	Wed,  8 Nov 2023 11:18:32 +0000 (UTC)
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7871186;
	Wed,  8 Nov 2023 03:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442313; x=1730978313;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Uq8x7FLfoIR318BRKD0i4hgYzW68ONMdLEubh/+ZbLg=;
  b=cY0+dRyPVwx/+v+HXR0Jhe77ryGubFD0miWlX3/F6w2LU8JJY03beq5H
   UlHqWKLtYvOXKD9YLBb5CoWwh+l9/3uWt2XKQauGXUdroYEFFOz7AAtFO
   G8lWw2z/bZWgPl7FrUHwDU7yi7pL+HkfHPkrhLjv/g2592ptsfSupSXi/
   o=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="361602176"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-44b6fc51.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:18:29 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan2.pdx.amazon.com [10.39.38.66])
	by email-inbound-relay-pdx-2a-m6i4x-44b6fc51.us-west-2.amazon.com (Postfix) with ESMTPS id 8BB26A07F7;
	Wed,  8 Nov 2023 11:18:26 +0000 (UTC)
Received: from EX19MTAEUC001.ant.amazon.com [10.0.10.100:45371]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.26.101:2525] with esmtp (Farcaster)
 id 58210a6b-8421-43e3-b3a6-2ece76fce745; Wed, 8 Nov 2023 11:18:25 +0000 (UTC)
X-Farcaster-Flow-ID: 58210a6b-8421-43e3-b3a6-2ece76fce745
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:18:25 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:18:20 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 01/33] KVM: x86: Decouple lapic.h from hyperv.h
Date: Wed, 8 Nov 2023 11:17:34 +0000
Message-ID: <20231108111806.92604-2-nsaenz@amazon.com>
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
X-ClientProxiedBy: EX19D037UWC004.ant.amazon.com (10.13.139.254) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

lapic.h has no dependencies with hyperv.h, so don't include it there.

Additionally, cpuid.c implicitly relied on hyperv.h's inclusion through
lapic.h, so include it explicitly there.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/kvm/cpuid.c | 1 +
 arch/x86/kvm/lapic.h | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 773132c3bf5a..eabd5e9dc003 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -28,6 +28,7 @@
 #include "trace.h"
 #include "pmu.h"
 #include "xen.h"
+#include "hyperv.h"
 
 /*
  * Unlike "struct cpuinfo_x86.x86_capability", kvm_cpu_caps doesn't need to be
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 0a0ea4b5dd8c..e1021517cf04 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -6,7 +6,6 @@
 
 #include <linux/kvm_host.h>
 
-#include "hyperv.h"
 #include "smm.h"
 
 #define KVM_APIC_INIT		0
-- 
2.40.1



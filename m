Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFD4232FC2
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 11:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgG3Jo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 05:44:56 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:5555 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgG3Jo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 05:44:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1596102296; x=1627638296;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=yS8mB8k1qRFT2l/VsyZ2ew82E3uftJGYIBk/EhMUB+U=;
  b=qMGyJ0vMT1pMpR4Aus87w65xlILIcKOgwm/4CZzPsjafTFk0HkGcAVGb
   7lTP/JHssJAKD8/Y0mQ33c6dpjSgUgwD6zIm1y0UGCgk6vIjUCCiFnDEn
   Kxh3mutWD2TNLLOFAO59FLTxTcmaajlwW0ScF132SQEgk54VRD8ENvXRH
   k=;
IronPort-SDR: CNk0xcG7ruz5shy5cGY4vfa2ZvAScrDvqnMExmPxQqHBcsX6Cy4H74gs+egxCgIkZa0eG1uVKb
 JMObEUP2Y+fA==
X-IronPort-AV: E=Sophos;i="5.75,414,1589241600"; 
   d="scan'208";a="45130693"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-62350142.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 30 Jul 2020 09:44:54 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-62350142.us-east-1.amazon.com (Postfix) with ESMTPS id D50C8A25A6;
        Thu, 30 Jul 2020 09:44:51 +0000 (UTC)
Received: from EX13D20UWC002.ant.amazon.com (10.43.162.163) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 30 Jul 2020 09:44:51 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.162.85) by
 EX13D20UWC002.ant.amazon.com (10.43.162.163) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 30 Jul 2020 09:44:49 +0000
From:   Alexander Graf <graf@amazon.com>
To:     <kvm@vger.kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        "Christoffer Dall" <christoffer.dall@arm.com>,
        Marc Zyngier <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: arm: Add trace name for ARM_NISV
Date:   Thu, 30 Jul 2020 11:44:41 +0200
Message-ID: <20200730094441.18231-1-graf@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.85]
X-ClientProxiedBy: EX13D22UWB004.ant.amazon.com (10.43.161.165) To
 EX13D20UWC002.ant.amazon.com (10.43.162.163)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit c726200dd106d ("KVM: arm/arm64: Allow reporting non-ISV data aborts
to userspace") introduced a mechanism to deflect MMIO traffic the kernel
can not handle to user space. For that, it introduced a new exit reason.

However, it did not update the trace point array that gives human readable
names to these exit reasons inside the trace log.

Let's fix that up after the fact, so that trace logs are pretty even when
we get user space MMIO traps on ARM.

Fixes: c726200dd106d ("KVM: arm/arm64: Allow reporting non-ISV data aborts to userspace")
Signed-off-by: Alexander Graf <graf@amazon.com>
---
 include/trace/events/kvm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 2c735a3e6613..9417a34aad08 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -17,7 +17,7 @@
 	ERSN(NMI), ERSN(INTERNAL_ERROR), ERSN(OSI), ERSN(PAPR_HCALL),	\
 	ERSN(S390_UCONTROL), ERSN(WATCHDOG), ERSN(S390_TSCH), ERSN(EPR),\
 	ERSN(SYSTEM_EVENT), ERSN(S390_STSI), ERSN(IOAPIC_EOI),          \
-	ERSN(HYPERV)
+	ERSN(HYPERV), ERSN(ARM_NISV)
 
 TRACE_EVENT(kvm_userspace_exit,
 	    TP_PROTO(__u32 reason, int errno),
-- 
2.16.4




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879




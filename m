Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74878264A50
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 18:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgIJQvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 12:51:33 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:31212 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgIJQuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 12:50:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599756649; x=1631292649;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9ENEb+OWsMgLP7SddzClIgFi508ntq+tzSER6yva+Q4=;
  b=YeYNSlrlJ9TU2G59HGQlzaM11FCaxRqCaohzPsW44xjMxroSCo6kD887
   1977+GdrZuXNXsFA6qvZ3nosi/Ngn9TThY5pP89GKVk91Io/RFqH6BGZu
   1OX/s6cd/L8uEI8LOtf5aKNgDEo3+3Zw+k4Pn01yG+Whj62tEaLqK82OP
   U=;
X-IronPort-AV: E=Sophos;i="5.76,413,1592870400"; 
   d="scan'208";a="73955160"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 10 Sep 2020 16:42:59 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-38ae4ad2.us-east-1.amazon.com (Postfix) with ESMTPS id 80B89A240F;
        Thu, 10 Sep 2020 16:42:56 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Sep 2020 16:42:53 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.161.85) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 10 Sep 2020 16:42:51 +0000
From:   Alexander Graf <graf@amazon.com>
To:     <kvmarm@lists.cs.columbia.edu>
CC:     Marc Zyngier <maz@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: [PATCH v3] KVM: arm64: Preserve PMCR immutable values across reset
Date:   Thu, 10 Sep 2020 18:42:43 +0200
Message-ID: <20200910164243.29253-1-graf@amazon.com>
X-Mailer: git-send-email 2.28.0.394.ge197136389
MIME-Version: 1.0
X-Originating-IP: [10.43.161.85]
X-ClientProxiedBy: EX13D40UWA004.ant.amazon.com (10.43.160.36) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We allow user space to set the PMCR register to any value. However,
when time comes for a vcpu reset (for example on PSCI online), PMCR
is reset to the hardware capabilities.

I would like to explicitly expose different PMU capabilities (number
of supported event counters) to the guest than hardware supports.
Ideally across vcpu resets.

So this patch adopts the reset path to only populate the immutable
PMCR register bits from hardware when they were not initialized
previously. This effectively means that on a normal reset, only the
guest settable fields are reset, while on vcpu creation the register
gets populated from hardware like before.

With this in place and a change in user space to invoke SET_ONE_REG
on the PMCR for every vcpu, I can reliably set the PMU event counter
number to arbitrary values.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 arch/arm64/kvm/sys_regs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 20ab2a7d37ca..28f67550db7f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -663,7 +663,14 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	u64 pmcr, val;
 
-	pmcr = read_sysreg(pmcr_el0);
+	/*
+	 * If we already received PMCR from a previous ONE_REG call,
+	 * maintain its immutable flags
+	 */
+	pmcr = __vcpu_sys_reg(vcpu, r->reg);
+	if (!__vcpu_sys_reg(vcpu, r->reg))
+		pmcr = read_sysreg(pmcr_el0);
+
 	/*
 	 * Writable bits of PMCR_EL0 (ARMV8_PMU_PMCR_MASK) are reset to UNKNOWN
 	 * except PMCR.E resetting to zero.
-- 
2.16.4




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879




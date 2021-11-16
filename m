Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F866452F81
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 11:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbhKPKyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 05:54:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27272 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234411AbhKPKxn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 05:53:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637059846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qTP4ucG3pQWzKEX1lRvFm3Ni+dj+qjerEUhy+Eu1QYE=;
        b=PWW5vVzSvImdovSOIFd1PCN30xhc8PDPq7+f8dlFrz48tL2If9apkXs2j5w2YfsFXHhOSc
        ZwViYL/IpqkVw0DW8qpgAZcVjEw4BW3ruBURFdmnkwZVPFVK6FHT2y1lcGz7TY6VrTlGb4
        m20dI/oIgqRwqFkwsHkS5PNVmyPGsaM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-sfzbpcoVNFy4SeauM6_4YQ-1; Tue, 16 Nov 2021 05:50:44 -0500
X-MC-Unique: sfzbpcoVNFy4SeauM6_4YQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F831A40C2;
        Tue, 16 Nov 2021 10:50:43 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (unknown [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4DDE55D9DE;
        Tue, 16 Nov 2021 10:50:43 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     jmattson@google.com, Like Xu <like.xu.linux@gmail.com>
Subject: [PATCH kvm-unit-tests] pmu: fix conditions for emulation test
Date:   Tue, 16 Nov 2021 05:50:38 -0500
Message-Id: <20211116105038.683627-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right now, unittests.cfg only supports a single check line.  Multiple
checks must be space separated.

However, the pmu_emulation test does not really need nmi_watchdog=0;
it is only needed by the PMU counters test because Linux reserves one
counter if nmi_watchdog=1, but the pmu_emulation test does not
allocate all counters in the same way.  By removing the counters
tests from pmu_emulation, the check on nmi_watchdog=0 can be
removed.

This also hid a typo for the force_emulation_prefix module parameter,
which is part of the kvm module rather than the kvm_intel module,
so fix that.

Reported-by: Like Xu <like.xu.linux@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/pmu.c         | 17 +++++++++--------
 x86/unittests.cfg |  3 +--
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index a159333..92206ad 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -638,16 +638,17 @@ int main(int ac, char **av)
 
 	apic_write(APIC_LVTPC, PC_VECTOR);
 
-	check_counters();
-
-	if (ac > 1 && !strcmp(av[1], "emulation"))
+	if (ac > 1 && !strcmp(av[1], "emulation")) {
 		check_emulated_instr();
-
-	if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES) {
-		gp_counter_base = MSR_IA32_PMC0;
-		report_prefix_push("full-width writes");
+	} else {
 		check_counters();
-		check_gp_counters_write_width();
+
+		if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES) {
+			gp_counter_base = MSR_IA32_PMC0;
+			report_prefix_push("full-width writes");
+			check_counters();
+			check_gp_counters_write_width();
+		}
 	}
 
 	return report_summary();
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 6585df4..27ecd31 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -189,8 +189,7 @@ check = /proc/sys/kernel/nmi_watchdog=0
 file = pmu.flat
 arch = x86_64
 extra_params = -cpu max -append emulation
-check = /sys/module/kvm_intel/parameters/force_emulation_prefix=Y
-check = /proc/sys/kernel/nmi_watchdog=0
+check = /sys/module/kvm/parameters/force_emulation_prefix=Y
 
 [vmware_backdoors]
 file = vmware_backdoors.flat
-- 
2.27.0


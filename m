Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B187AA0378
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 15:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbfH1NjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 09:39:12 -0400
Received: from foss.arm.com ([217.140.110.172]:59682 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbfH1NjL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 09:39:11 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7CE7215AB;
        Wed, 28 Aug 2019 06:39:10 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 55D9C3F73D;
        Wed, 28 Aug 2019 06:39:09 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, andre.przywara@arm.com
Subject: [kvm-unit-tests RFC PATCH 15/16] arm64: selftest: Expand EL2 test to disable and re-enable VHE
Date:   Wed, 28 Aug 2019 14:38:30 +0100
Message-Id: <1566999511-24916-16-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
KVM doesn't deal with a guest running with VHE enabled, then disabling it
[1]. I also proposed a fix [1] for it.

[1] https://www.spinics.net/lists/arm-kernel/msg749823.html

 arm/selftest.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arm/selftest.c b/arm/selftest.c
index 211bc8a5642b..4a6c943497ee 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -395,6 +395,18 @@ static void check_el2_cpu(void *data __unused)
 	report("CPU(%3d) Running at EL2", current_level() == CurrentEL_EL2, cpu);
 	report("CPU(%3d) VHE supported and enabled",
 			vhe_supported() && vhe_enabled(), cpu);
+
+	report_info("CPU(%3d) Disabling VHE", cpu);
+	disable_vhe();
+
+	report("CPU(%3d) Running at EL2", current_level() == CurrentEL_EL2, cpu);
+	report("CPU(%3d) VHE disabled", !vhe_enabled(), cpu);
+
+	report_info("CPU(%3d) Re-enabling VHE", cpu);
+	enable_vhe();
+
+	report("CPU(%3d) Running at EL2", current_level() == CurrentEL_EL2, cpu);
+	report("CPU(%3d) VHE enabled", vhe_enabled(), cpu);
 }
 
 static bool psci_check(void);
-- 
2.7.4


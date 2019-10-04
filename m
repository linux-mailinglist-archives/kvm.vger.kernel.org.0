Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27FD1CBCE0
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 16:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389005AbfJDOSn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 10:18:43 -0400
Received: from foss.arm.com ([217.140.110.172]:46254 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388987AbfJDOSn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 10:18:43 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 88F0F15BF;
        Fri,  4 Oct 2019 07:18:42 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BA7FF3F68E;
        Fri,  4 Oct 2019 07:18:41 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 4/6] arm: selftest: Split variable output data from test name
Date:   Fri,  4 Oct 2019 15:18:27 +0100
Message-Id: <20191004141829.87135-5-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191004141829.87135-1-andre.przywara@arm.com>
References: <20191004141829.87135-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For some tests we mix variable diagnostic output with the test name,
which leads to variable test line, confusing some higher level
frameworks.

Split the output to always use the same test name for a certain test,
and put diagnostic output on a separate line using the INFO: tag.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arm/selftest.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arm/selftest.c b/arm/selftest.c
index 28a17f7..a0c1ab8 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -43,13 +43,16 @@ static void check_setup(int argc, char **argv)
 			phys_addr_t memsize = PHYS_END - PHYS_OFFSET;
 			phys_addr_t expected = ((phys_addr_t)val)*1024*1024;
 
-			report("size = %" PRIu64 " MB", memsize == expected,
-							memsize/1024/1024);
+			report("memory size matches expectation",
+			       memsize == expected);
+			report_info("found %" PRIu64 " MB", memsize/1024/1024);
 			++nr_tests;
 
 		} else if (strcmp(argv[i], "smp") == 0) {
 
-			report("nr_cpus = %d", nr_cpus == (int)val, nr_cpus);
+			report("number of CPUs matches expectation",
+			       nr_cpus == (int)val);
+			report_info("found %d CPUs", nr_cpus);
 			++nr_tests;
 		}
 
-- 
2.17.1


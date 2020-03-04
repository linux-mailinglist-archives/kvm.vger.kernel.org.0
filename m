Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDC3C178F96
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 12:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387772AbgCDLdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 06:33:01 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:57462 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729256AbgCDLdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 06:33:00 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92.3)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1j9SGj-0000pl-Un; Wed, 04 Mar 2020 12:32:53 +0100
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] cpuidle-haltpoll: allow force loading on hosts without the REALTIME hint
Date:   Wed,  4 Mar 2020 12:32:48 +0100
Message-Id: <20200304113248.1143057-1-mail@maciej.szmigiero.name>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

Before commit 1328edca4a14 ("cpuidle-haltpoll: Enable kvm guest polling
when dedicated physical CPUs are available") the cpuidle-haltpoll driver
could also be used in scenarios when the host does not advertise the
KVM_HINTS_REALTIME hint.

While the behavior introduced by the aforementioned commit makes sense as
the default there are cases where the old behavior is desired, for example,
when other kernel changes triggered by presence by this hint are unwanted,
for some workloads where the latency benefit from polling overweights the
loss from idle CPU capacity that otherwise would be available, or just when
running under older Qemu versions that lack this hint.

Let's provide a typical "force" module parameter that allows restoring the
old behavior.

Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 drivers/cpuidle/cpuidle-haltpoll.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

Changes from v1:
Make the module parameter description more general, don't unnecessarily
break a line in haltpoll_init().

diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
index b0ce9bc78113..db124bc1ca2c 100644
--- a/drivers/cpuidle/cpuidle-haltpoll.c
+++ b/drivers/cpuidle/cpuidle-haltpoll.c
@@ -18,6 +18,10 @@
 #include <linux/kvm_para.h>
 #include <linux/cpuidle_haltpoll.h>
 
+static bool force __read_mostly;
+module_param(force, bool, 0444);
+MODULE_PARM_DESC(force, "Load unconditionally");
+
 static struct cpuidle_device __percpu *haltpoll_cpuidle_devices;
 static enum cpuhp_state haltpoll_hp_state;
 
@@ -90,6 +94,11 @@ static void haltpoll_uninit(void)
 	haltpoll_cpuidle_devices = NULL;
 }
 
+static bool haltpool_want(void)
+{
+	return kvm_para_has_hint(KVM_HINTS_REALTIME) || force;
+}
+
 static int __init haltpoll_init(void)
 {
 	int ret;
@@ -101,8 +110,7 @@ static int __init haltpoll_init(void)
 
 	cpuidle_poll_state_init(drv);
 
-	if (!kvm_para_available() ||
-		!kvm_para_has_hint(KVM_HINTS_REALTIME))
+	if (!kvm_para_available() || !haltpool_want())
 		return -ENODEV;
 
 	ret = cpuidle_register_driver(drv);

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4496235F3EA
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 14:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351000AbhDNMgf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 08:36:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36930 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1350977AbhDNMg1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Apr 2021 08:36:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618403766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BPj9B9SI4Ii5RY6ovJjvLP89Qdf3fZd8sHO2I12+bSw=;
        b=bA8WshyFGNwQD2B9VuItej3w/LBiT0bLMX2C/aP99Y3UpelxH8HS1JCjNVt/i+YeS4Rbpb
        e66lkBaSX9tYMyf1f42Z5okGtZRZJ1h2eWCMQ7t0mSwjINPjQKIct6cwGQp1M7MNoNKYWX
        hwVvm/dAbLHUqOWplyyRN/hyI/VP2OM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-aA_1HIK1Pxi8LIgBXzxJxA-1; Wed, 14 Apr 2021 08:36:04 -0400
X-MC-Unique: aA_1HIK1Pxi8LIgBXzxJxA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C26383DD20;
        Wed, 14 Apr 2021 12:36:03 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.196.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BAFF45D9CC;
        Wed, 14 Apr 2021 12:36:00 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Lenny Szubowicz <lszubowi@redhat.com>,
        Mohamed Aboubakr <mabouba@amazon.com>,
        Xiaoyi Chen <cxiaoyi@amazon.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] x86/kvm: Unify kvm_pv_guest_cpu_reboot() with kvm_guest_cpu_offline()
Date:   Wed, 14 Apr 2021 14:35:44 +0200
Message-Id: <20210414123544.1060604-6-vkuznets@redhat.com>
In-Reply-To: <20210414123544.1060604-1-vkuznets@redhat.com>
References: <20210414123544.1060604-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Simplify the code by making PV features shutdown happen in one place.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kernel/kvm.c | 42 +++++++++++++++++-------------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 1754b7c3f754..7da7bea96745 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -384,31 +384,6 @@ static void kvm_disable_steal_time(void)
 	wrmsr(MSR_KVM_STEAL_TIME, 0, 0);
 }
 
-static void kvm_pv_guest_cpu_reboot(void *unused)
-{
-	/*
-	 * We disable PV EOI before we load a new kernel by kexec,
-	 * since MSR_KVM_PV_EOI_EN stores a pointer into old kernel's memory.
-	 * New kernel can re-enable when it boots.
-	 */
-	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
-		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
-	kvm_pv_disable_apf();
-	kvm_disable_steal_time();
-}
-
-static int kvm_pv_reboot_notify(struct notifier_block *nb,
-				unsigned long code, void *unused)
-{
-	if (code == SYS_RESTART)
-		on_each_cpu(kvm_pv_guest_cpu_reboot, NULL, 1);
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block kvm_pv_reboot_nb = {
-	.notifier_call = kvm_pv_reboot_notify,
-};
-
 static u64 kvm_steal_clock(int cpu)
 {
 	u64 steal;
@@ -664,6 +639,23 @@ static struct syscore_ops kvm_syscore_ops = {
 	.resume		= kvm_resume,
 };
 
+static void kvm_pv_guest_cpu_reboot(void *unused)
+{
+	kvm_guest_cpu_offline(true);
+}
+
+static int kvm_pv_reboot_notify(struct notifier_block *nb,
+				unsigned long code, void *unused)
+{
+	if (code == SYS_RESTART)
+		on_each_cpu(kvm_pv_guest_cpu_reboot, NULL, 1);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block kvm_pv_reboot_nb = {
+	.notifier_call = kvm_pv_reboot_notify,
+};
+
 /*
  * After a PV feature is registered, the host will keep writing to the
  * registered memory location. If the guest happens to shutdown, this memory
-- 
2.30.2


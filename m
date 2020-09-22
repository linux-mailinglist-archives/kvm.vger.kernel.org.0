Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8470927450F
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 17:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgIVPPM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 11:15:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47610 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726650AbgIVPPL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 11:15:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600787710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hQSjgqVtilkBiWKNUMIsXVhf0Cxsgw+4bjov72hIPUQ=;
        b=cn3i91cvD4pHiQYZRpYq9dHVrMmz3Z3mv12lbYXFuUNacoZ3WKDwzmI6lFiIksavrdqnm4
        HgYKpAwsabibphLvKMC0Clb9LBUeaE84EPzHbpjZb+riEvG+XQmH/JbSyHneW5vOxET1Ac
        shd7hUU/tFmGG5TEnakcYvwdXwKqjoM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-TNCohAoeOT66zjxvPe1GZQ-1; Tue, 22 Sep 2020 11:15:01 -0400
X-MC-Unique: TNCohAoeOT66zjxvPe1GZQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 249311017DC9;
        Tue, 22 Sep 2020 15:15:00 +0000 (UTC)
Received: from localhost (unknown [10.10.67.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 930A673670;
        Tue, 22 Sep 2020 15:14:56 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        1896263@bugs.launchpad.net, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH] i386: Don't try to set MSR_KVM_ASYNC_PF_EN if kernel-irqchip=off
Date:   Tue, 22 Sep 2020 11:14:55 -0400
Message-Id: <20200922151455.1763896-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This addresses the following crash when running Linux v5.8
with kernel-irqchip=off:

  qemu-system-x86_64: error: failed to set MSR 0x4b564d02 to 0x0
  qemu-system-x86_64: ../target/i386/kvm.c:2714: kvm_buf_set_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.

There is a kernel-side fix for the issue too (kernel commit
d831de177217 "KVM: x86: always allow writing '0' to
MSR_KVM_ASYNC_PF_EN"), but it's nice to simply not trigger
the bug if running an older kernel.

Fixes: https://bugs.launchpad.net/bugs/1896263
Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 target/i386/kvm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 9efb07e7c83..1492f41349f 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -2818,7 +2818,12 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
         kvm_msr_entry_add(cpu, MSR_IA32_TSC, env->tsc);
         kvm_msr_entry_add(cpu, MSR_KVM_SYSTEM_TIME, env->system_time_msr);
         kvm_msr_entry_add(cpu, MSR_KVM_WALL_CLOCK, env->wall_clock_msr);
-        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF)) {
+        /*
+         * Some kernel versions (v5.8) won't let MSR_KVM_ASYNC_PF_EN to be set
+         * at all if kernel-irqchip=off, so don't try to set it in that case.
+         */
+        if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_ASYNC_PF) &&
+            kvm_irqchip_in_kernel()) {
             kvm_msr_entry_add(cpu, MSR_KVM_ASYNC_PF_EN, env->async_pf_en_msr);
         }
         if (env->features[FEAT_KVM] & (1 << KVM_FEATURE_PV_EOI)) {
-- 
2.26.2


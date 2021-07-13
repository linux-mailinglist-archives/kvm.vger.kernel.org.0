Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866C53C7448
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhGMQWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:22:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34075 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229723AbhGMQWG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 12:22:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626193155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g5Cdc7MIHpGu0GQUWuPrSUZWBnD4tfTQIZW41psbBxw=;
        b=PjBgln9sM6TWnnhoUOMGYq+HBHoMNVx2N4Npdez73Wle6frVVYxPyOHGWy2z4R7mBNUuhO
        8BBpbJM0L+xvH4E1DJY2UzGmu3lCBcn/FPw6qFw3X2uMaw6hK12/oufKlhnGMbiZmyqrAH
        nsrY0Z9lhuG/FGggbDdGHbPClBBHmzg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-cno4CPdCOtWnLX_IU6P9Ew-1; Tue, 13 Jul 2021 12:19:14 -0400
X-MC-Unique: cno4CPdCOtWnLX_IU6P9Ew-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18CDF8015F5;
        Tue, 13 Jul 2021 16:19:13 +0000 (UTC)
Received: from localhost (ovpn-113-28.rdu2.redhat.com [10.10.113.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D46665D9CA;
        Tue, 13 Jul 2021 16:19:12 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PULL 06/11] i386: HV_HYPERCALL_AVAILABLE privilege bit is always needed
Date:   Tue, 13 Jul 2021 12:09:52 -0400
Message-Id: <20210713160957.3269017-7-ehabkost@redhat.com>
In-Reply-To: <20210713160957.3269017-1-ehabkost@redhat.com>
References: <20210713160957.3269017-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

According to TLFS, Hyper-V guest is supposed to check
HV_HYPERCALL_AVAILABLE privilege bit before accessing
HV_X64_MSR_GUEST_OS_ID/HV_X64_MSR_HYPERCALL MSRs but at least some
Windows versions ignore that. As KVM is very permissive and allows
accessing these MSRs unconditionally, no issue is observed. We may,
however, want to tighten the checks eventually. Conforming to the
spec is probably also a good idea.

Enable HV_HYPERCALL_AVAILABLE bit unconditionally.

Reviewed-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20210608120817.1325125-8-vkuznets@redhat.com>
Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 target/i386/kvm/kvm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 945d24300c0..eee1a6b46ea 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -813,8 +813,6 @@ static struct {
     [HYPERV_FEAT_RELAXED] = {
         .desc = "relaxed timing (hv-relaxed)",
         .flags = {
-            {.func = HV_CPUID_FEATURES, .reg = R_EAX,
-             .bits = HV_HYPERCALL_AVAILABLE},
             {.func = HV_CPUID_ENLIGHTMENT_INFO, .reg = R_EAX,
              .bits = HV_RELAXED_TIMING_RECOMMENDED}
         }
@@ -823,7 +821,7 @@ static struct {
         .desc = "virtual APIC (hv-vapic)",
         .flags = {
             {.func = HV_CPUID_FEATURES, .reg = R_EAX,
-             .bits = HV_HYPERCALL_AVAILABLE | HV_APIC_ACCESS_AVAILABLE},
+             .bits = HV_APIC_ACCESS_AVAILABLE},
             {.func = HV_CPUID_ENLIGHTMENT_INFO, .reg = R_EAX,
              .bits = HV_APIC_ACCESS_RECOMMENDED}
         }
@@ -832,8 +830,7 @@ static struct {
         .desc = "clocksources (hv-time)",
         .flags = {
             {.func = HV_CPUID_FEATURES, .reg = R_EAX,
-             .bits = HV_HYPERCALL_AVAILABLE | HV_TIME_REF_COUNT_AVAILABLE |
-             HV_REFERENCE_TSC_AVAILABLE}
+             .bits = HV_TIME_REF_COUNT_AVAILABLE | HV_REFERENCE_TSC_AVAILABLE}
         }
     },
     [HYPERV_FEAT_CRASH] = {
@@ -1346,6 +1343,9 @@ static int hyperv_fill_cpuids(CPUState *cs,
     c->ebx = hv_build_cpuid_leaf(cs, HV_CPUID_FEATURES, R_EBX);
     c->edx = hv_build_cpuid_leaf(cs, HV_CPUID_FEATURES, R_EDX);
 
+    /* Unconditionally required with any Hyper-V enlightenment */
+    c->eax |= HV_HYPERCALL_AVAILABLE;
+
     /* Not exposed by KVM but needed to make CPU hotplug in Windows work */
     c->edx |= HV_CPU_DYNAMIC_PARTITIONING_AVAILABLE;
 
-- 
2.31.1


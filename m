Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0803C745B
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhGMQWX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:22:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32688 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230402AbhGMQWS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 12:22:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626193168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=py29WgyrzjjJ6A+bVx8kz61k4pLlvebyYgeg8K3lcxo=;
        b=jB6iHb6mnqpORNEX2kR5p+Jg7z+EPq00WaVfMW5y6ySoCz6q7NjW7mESHRDN6cdZtGmCW6
        ZtZ192xbN2RH/+hEF7axRUL9++NEC4d1KyrwIWIxpqu6F51lpbxUGKkLoUbIXxDGzotfHz
        TuHxnsRCVTDwkVFwEwPpgzRegfXiFEM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-EBAP7uZgN66rtRD0AtErPA-1; Tue, 13 Jul 2021 12:19:26 -0400
X-MC-Unique: EBAP7uZgN66rtRD0AtErPA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DD5FDF8A5;
        Tue, 13 Jul 2021 16:19:25 +0000 (UTC)
Received: from localhost (ovpn-113-28.rdu2.redhat.com [10.10.113.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 45F4060936;
        Tue, 13 Jul 2021 16:19:25 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        zhenwei pi <pizhenwei@bytedance.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>
Subject: [PULL 09/11] target/i386: Fix cpuid level for AMD
Date:   Tue, 13 Jul 2021 12:09:55 -0400
Message-Id: <20210713160957.3269017-10-ehabkost@redhat.com>
In-Reply-To: <20210713160957.3269017-1-ehabkost@redhat.com>
References: <20210713160957.3269017-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: zhenwei pi <pizhenwei@bytedance.com>

A AMD server typically has cpuid level 0x10(test on Rome/Milan), it
should not be changed to 0x1f in multi-dies case.

* to maintain compatibility with older machine types, only implement
  this change when the CPU's "x-vendor-cpuid-only" property is false

Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: zhenwei pi <pizhenwei@bytedance.com>
Fixes: a94e1428991 (target/i386: Add CPUID.1F generation support for multi-dies PCMachine)
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Message-Id: <20210708170641.49410-1-michael.roth@amd.com>
Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 target/i386/cpu.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 6b7043e4253..48b55ebd0a6 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5950,8 +5950,15 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
             }
         }
 
-        /* CPU topology with multi-dies support requires CPUID[0x1F] */
-        if (env->nr_dies > 1) {
+        /*
+         * Intel CPU topology with multi-dies support requires CPUID[0x1F].
+         * For AMD Rome/Milan, cpuid level is 0x10, and guest OS should detect
+         * extended toplogy by leaf 0xB. Only adjust it for Intel CPU, unless
+         * cpu->vendor_cpuid_only has been unset for compatibility with older
+         * machine types.
+         */
+        if ((env->nr_dies > 1) &&
+            (IS_INTEL_CPU(env) || !cpu->vendor_cpuid_only)) {
             x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x1F);
         }
 
-- 
2.31.1


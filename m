Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED8A9A34B
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 00:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405128AbfHVWwN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 18:52:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50230 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732657AbfHVWwN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 18:52:13 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 173A387633;
        Thu, 22 Aug 2019 22:52:13 +0000 (UTC)
Received: from localhost (ovpn-116-73.gru2.redhat.com [10.97.116.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D6BB600CD;
        Thu, 22 Aug 2019 22:52:12 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Yumei Huang <yuhuang@redhat.com>
Subject: [PATCH] i386: Omit all-zeroes entries from KVM CPUID table
Date:   Thu, 22 Aug 2019 19:52:10 -0300
Message-Id: <20190822225210.32541-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 22 Aug 2019 22:52:13 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM has a 80-entry limit at KVM_SET_CPUID2.  With the
introduction of CPUID[0x1F], it is now possible to hit this limit
with unusual CPU configurations, e.g.:

  $ ./x86_64-softmmu/qemu-system-x86_64 \
    -smp 1,dies=2,maxcpus=2 \
    -cpu EPYC,check=off,enforce=off \
    -machine accel=kvm
  qemu-system-x86_64: kvm_init_vcpu failed: Argument list too long

This happens because QEMU adds a lot of all-zeroes CPUID entries
for unused CPUID leaves.  In the example above, we end up
creating 48 all-zeroes CPUID entries.

KVM already returns all-zeroes when emulating the CPUID
instruction if an entry is missing, so the all-zeroes entries are
redundant.  Skip those entries.  This reduces the CPUID table
size by half while keeping CPUID output unchanged.

Reported-by: Yumei Huang <yuhuang@redhat.com>
Fixes: https://bugzilla.redhat.com/show_bug.cgi?id=1741508
Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 target/i386/kvm.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 8023c679ea..4e3df2867d 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -1529,6 +1529,13 @@ int kvm_arch_init_vcpu(CPUState *cs)
             c->function = i;
             c->flags = 0;
             cpu_x86_cpuid(env, i, 0, &c->eax, &c->ebx, &c->ecx, &c->edx);
+            if (!c->eax && !c->ebx && !c->ecx && !c->edx) {
+                /*
+                 * KVM already returns all zeroes if a CPUID entry is missing,
+                 * so we can omit it and avoid hitting KVM's 80-entry limit.
+                 */
+                cpuid_i--;
+            }
             break;
         }
     }
@@ -1593,6 +1600,13 @@ int kvm_arch_init_vcpu(CPUState *cs)
             c->function = i;
             c->flags = 0;
             cpu_x86_cpuid(env, i, 0, &c->eax, &c->ebx, &c->ecx, &c->edx);
+            if (!c->eax && !c->ebx && !c->ecx && !c->edx) {
+                /*
+                 * KVM already returns all zeroes if a CPUID entry is missing,
+                 * so we can omit it and avoid hitting KVM's 80-entry limit.
+                 */
+                cpuid_i--;
+            }
             break;
         }
     }
-- 
2.21.0


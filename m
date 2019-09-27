Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBC6BC08F9
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 17:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfI0Py3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 11:54:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52708 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbfI0Py3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 11:54:29 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E2976306059B;
        Fri, 27 Sep 2019 15:54:28 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.205.253])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 115416293B;
        Fri, 27 Sep 2019 15:54:14 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH] KVM: selftests: x86: clarify what is reported on KVM_GET_MSRS failure
Date:   Fri, 27 Sep 2019 17:54:13 +0200
Message-Id: <20190927155413.31648-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 27 Sep 2019 15:54:28 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When KVM_GET_MSRS fail the report looks like

==== Test Assertion Failure ====
  lib/x86_64/processor.c:1089: r == nmsrs
  pid=28775 tid=28775 - Argument list too long
     1	0x000000000040a55f: vcpu_save_state at processor.c:1088 (discriminator 3)
     2	0x00000000004010e3: main at state_test.c:171 (discriminator 4)
     3	0x00007fb8e69223d4: ?? ??:0
     4	0x0000000000401287: _start at ??:?
  Unexpected result from KVM_GET_MSRS, r: 36 (failed at 194)

and it's not obvious that '194' here is the failed MSR index and that
it's printed in hex. Change that.

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/lib/x86_64/processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index c53dbc6bc568..6698cb741e10 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1085,7 +1085,7 @@ struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
 	for (i = 0; i < nmsrs; i++)
 		state->msrs.entries[i].index = list->indices[i];
 	r = ioctl(vcpu->fd, KVM_GET_MSRS, &state->msrs);
-        TEST_ASSERT(r == nmsrs, "Unexpected result from KVM_GET_MSRS, r: %i (failed at %x)",
+        TEST_ASSERT(r == nmsrs, "Unexpected result from KVM_GET_MSRS, r: %i (failed MSR was 0x%x)",
                 r, r == nmsrs ? -1 : list->indices[r]);
 
 	r = ioctl(vcpu->fd, KVM_GET_DEBUGREGS, &state->debugregs);
-- 
2.20.1


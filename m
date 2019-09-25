Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91890BDEA9
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 15:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406177AbfIYNMt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 09:12:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49858 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405921AbfIYNMs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 09:12:48 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 061A230860DA;
        Wed, 25 Sep 2019 13:12:48 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.43.2.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FD7E5C1D4;
        Wed, 25 Sep 2019 13:12:43 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH] KVM: selftests: fix ucall on x86
Date:   Wed, 25 Sep 2019 15:12:42 +0200
Message-Id: <20190925131242.29986-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 25 Sep 2019 13:12:48 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After commit e8bb4755eea2("KVM: selftests: Split ucall.c into architecture
specific files") selftests which use ucall on x86 started segfaulting and
apparently it's gcc to blame: it "optimizes" ucall() function throwing away
va_start/va_end part because it thinks the structure is not being used.
Previously, it couldn't do that because the there was also MMIO version and
the decision which particular implementation to use was done at runtime.

With older gccs it's possible to solve the problem by adding 'volatile'
to 'struct ucall' but at least with gcc-8.3 this trick doesn't work.

'memory' clobber seems to do the job.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
s390 should, in theory, have the same problem. Thomas, Cornelia, could
you please take a look? Thanks!
---
 tools/testing/selftests/kvm/lib/x86_64/ucall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/ucall.c b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
index 4bfc9a90b1de..da4d89ad5419 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/ucall.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/ucall.c
@@ -32,7 +32,7 @@ void ucall(uint64_t cmd, int nargs, ...)
 	va_end(va);
 
 	asm volatile("in %[port], %%al"
-		: : [port] "d" (UCALL_PIO_PORT), "D" (&uc) : "rax");
+		: : [port] "d" (UCALL_PIO_PORT), "D" (&uc) : "rax", "memory");
 }
 
 uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
-- 
2.20.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A583A7E65
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 10:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729415AbfIDIwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 04:52:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43904 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbfIDIwN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 04:52:13 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4C9A3875222;
        Wed,  4 Sep 2019 08:52:13 +0000 (UTC)
Received: from thuth.com (ovpn-116-69.ams2.redhat.com [10.36.116.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A0B3600CD;
        Wed,  4 Sep 2019 08:52:11 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] KVM: selftests: Test invalid bits in kvm_valid_regs and kvm_dirty_regs on s390x
Date:   Wed,  4 Sep 2019 10:52:00 +0200
Message-Id: <20190904085200.29021-3-thuth@redhat.com>
In-Reply-To: <20190904085200.29021-1-thuth@redhat.com>
References: <20190904085200.29021-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Wed, 04 Sep 2019 08:52:13 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we disallow invalid bits in kvm_valid_regs and kvm_dirty_regs
on s390x, too, we should also check this condition in the selftests.
The code has been taken from the x86-version of the sync_regs_test.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .../selftests/kvm/s390x/sync_regs_test.c      | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/kvm/s390x/sync_regs_test.c b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
index bbc93094519b..d5290b4ad636 100644
--- a/tools/testing/selftests/kvm/s390x/sync_regs_test.c
+++ b/tools/testing/selftests/kvm/s390x/sync_regs_test.c
@@ -85,6 +85,36 @@ int main(int argc, char *argv[])
 
 	run = vcpu_state(vm, VCPU_ID);
 
+	/* Request reading invalid register set from VCPU. */
+	run->kvm_valid_regs = INVALID_SYNC_FIELD;
+	rv = _vcpu_run(vm, VCPU_ID);
+	TEST_ASSERT(rv < 0 && errno == EINVAL,
+		    "Invalid kvm_valid_regs did not cause expected KVM_RUN error: %d\n",
+		    rv);
+	vcpu_state(vm, VCPU_ID)->kvm_valid_regs = 0;
+
+	run->kvm_valid_regs = INVALID_SYNC_FIELD | TEST_SYNC_FIELDS;
+	rv = _vcpu_run(vm, VCPU_ID);
+	TEST_ASSERT(rv < 0 && errno == EINVAL,
+		    "Invalid kvm_valid_regs did not cause expected KVM_RUN error: %d\n",
+		    rv);
+	vcpu_state(vm, VCPU_ID)->kvm_valid_regs = 0;
+
+	/* Request setting invalid register set into VCPU. */
+	run->kvm_dirty_regs = INVALID_SYNC_FIELD;
+	rv = _vcpu_run(vm, VCPU_ID);
+	TEST_ASSERT(rv < 0 && errno == EINVAL,
+		    "Invalid kvm_dirty_regs did not cause expected KVM_RUN error: %d\n",
+		    rv);
+	vcpu_state(vm, VCPU_ID)->kvm_dirty_regs = 0;
+
+	run->kvm_dirty_regs = INVALID_SYNC_FIELD | TEST_SYNC_FIELDS;
+	rv = _vcpu_run(vm, VCPU_ID);
+	TEST_ASSERT(rv < 0 && errno == EINVAL,
+		    "Invalid kvm_dirty_regs did not cause expected KVM_RUN error: %d\n",
+		    rv);
+	vcpu_state(vm, VCPU_ID)->kvm_dirty_regs = 0;
+
 	/* Request and verify all valid register sets. */
 	run->kvm_valid_regs = TEST_SYNC_FIELDS;
 	rv = _vcpu_run(vm, VCPU_ID);
-- 
2.18.1


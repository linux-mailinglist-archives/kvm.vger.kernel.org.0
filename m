Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D66B0AC8
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 11:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730454AbfILJBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 05:01:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47556 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbfILJBD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 05:01:03 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 137FDC053FDF;
        Thu, 12 Sep 2019 09:01:03 +0000 (UTC)
Received: from thuth.com (ovpn-204-41.brq.redhat.com [10.40.204.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A00AB60C63;
        Thu, 12 Sep 2019 09:00:55 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: s390: Do not leak kernel stack data in the KVM_S390_INTERRUPT ioctl
Date:   Thu, 12 Sep 2019 11:00:50 +0200
Message-Id: <20190912090050.20295-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 12 Sep 2019 09:01:03 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the userspace program runs the KVM_S390_INTERRUPT ioctl to inject
an interrupt, we convert them from the legacy struct kvm_s390_interrupt
to the new struct kvm_s390_irq via the s390int_to_s390irq() function.
However, this function does not take care of all types of interrupts
that we can inject into the guest later (see do_inject_vcpu()). Since we
do not clear out the s390irq values before calling s390int_to_s390irq(),
there is a chance that we copy unwanted data from the kernel stack
into the guest memory later if the interrupt data has not been properly
initialized by s390int_to_s390irq().

Specifically, the problem exists with the KVM_S390_INT_PFAULT_INIT
interrupt: s390int_to_s390irq() does not handle it, but the function
__deliver_pfault_init() will later copy the uninitialized stack data
from the ext.ext_params2 into the guest memory.

Fix it by handling that interrupt type in s390int_to_s390irq(), too.
And while we're at it, make sure that s390int_to_s390irq() now
directly returns -EINVAL for unknown interrupt types, so that we
do not run into this problem again in case we add more interrupt
types to do_inject_vcpu() sometime in the future.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arch/s390/kvm/interrupt.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 3e7efdd9228a..165dea4c7f19 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -1960,6 +1960,16 @@ int s390int_to_s390irq(struct kvm_s390_interrupt *s390int,
 	case KVM_S390_MCHK:
 		irq->u.mchk.mcic = s390int->parm64;
 		break;
+	case KVM_S390_INT_PFAULT_INIT:
+		irq->u.ext.ext_params = s390int->parm;
+		irq->u.ext.ext_params2 = s390int->parm64;
+		break;
+	case KVM_S390_RESTART:
+	case KVM_S390_INT_CLOCK_COMP:
+	case KVM_S390_INT_CPU_TIMER:
+		break;
+	default:
+		return -EINVAL;
 	}
 	return 0;
 }
-- 
2.18.1


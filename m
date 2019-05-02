Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9C71211F
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 19:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfEBReU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 13:34:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37796 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726145AbfEBReU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 May 2019 13:34:20 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x42HMfqM044250
        for <kvm@vger.kernel.org>; Thu, 2 May 2019 13:34:18 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2s84ma117g-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 02 May 2019 13:34:18 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Thu, 2 May 2019 18:34:16 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 2 May 2019 18:34:15 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x42HYDtb47251652
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 May 2019 17:34:13 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90AF04C04E;
        Thu,  2 May 2019 17:34:13 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0B154C040;
        Thu,  2 May 2019 17:34:12 +0000 (GMT)
Received: from morel-ThinkPad-W530.boeblingen.de.ibm.com (unknown [9.145.190.191])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 May 2019 17:34:12 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     borntraeger@de.ibm.com
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, frankja@linux.ibm.com, akrowiak@linux.ibm.com,
        pasic@linux.ibm.com, david@redhat.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, freude@linux.ibm.com, mimu@linux.ibm.com
Subject: [PATCH v8 1/4] s390: ap: kvm: add PQAP interception for AQIC
Date:   Thu,  2 May 2019 19:34:08 +0200
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556818451-1806-1-git-send-email-pmorel@linux.ibm.com>
References: <1556818451-1806-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19050217-4275-0000-0000-00000330B6E3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050217-4276-0000-0000-0000384016ED
Message-Id: <1556818451-1806-2-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-02_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905020112
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We prepare the interception of the PQAP/AQIC instruction for
the case the AQIC facility is enabled in the guest.

First of all we do not want to change existing behavior when
intercepting AP instructions without the SIE allowing the guest
to use AP instructions.

In this patch we only handle the AQIC interception allowed by
facility 65 which will be enabled when the complete interception
infrastructure will be present.

We add a callback inside the KVM arch structure for s390 for
a VFIO driver to handle a specific response to the PQAP
instruction with the AQIC command and only this command.

But we want to be able to return a correct answer to the guest
even there is no VFIO AP driver in the kernel.
Therefor, we inject the correct exceptions from inside KVM for the
case the callback is not initialized, which happens when the vfio_ap
driver is not loaded.

We do consider the responsability of the driver to always initialize
the PQAP callback if it defines queues by initializing the CRYCB for
a guest.
If the callback has been setup we call it.
If not we setup an answer considering that no queue is available
for the guest when no callback has been setup.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h      |  7 +++
 arch/s390/kvm/priv.c                  | 86 +++++++++++++++++++++++++++++++++++
 drivers/s390/crypto/vfio_ap_private.h |  2 +
 3 files changed, 95 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 9fff9ab..af10a11 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -18,6 +18,7 @@
 #include <linux/kvm_host.h>
 #include <linux/kvm.h>
 #include <linux/seqlock.h>
+#include <linux/module.h>
 #include <asm/debug.h>
 #include <asm/cpu.h>
 #include <asm/fpu/api.h>
@@ -722,8 +723,14 @@ struct kvm_s390_cpu_model {
 	unsigned short ibc;
 };
 
+struct kvm_s390_module_hook {
+	int (*hook)(struct kvm_vcpu *vcpu);
+	struct module *owner;
+};
+
 struct kvm_s390_crypto {
 	struct kvm_s390_crypto_cb *crycb;
+	struct kvm_s390_module_hook *pqap_hook;
 	__u32 crycbd;
 	__u8 aes_kw;
 	__u8 dea_kw;
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 8679bd7..a9be84f 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -27,6 +27,7 @@
 #include <asm/io.h>
 #include <asm/ptrace.h>
 #include <asm/sclp.h>
+#include <asm/ap.h>
 #include "gaccess.h"
 #include "kvm-s390.h"
 #include "trace.h"
@@ -592,6 +593,89 @@ static int handle_io_inst(struct kvm_vcpu *vcpu)
 	}
 }
 
+/*
+ * handle_pqap: Handling pqap interception
+ * @vcpu: the vcpu having issue the pqap instruction
+ *
+ * We now support PQAP/AQIC instructions and we need to correctly
+ * answer the guest even if no dedicated driver's hook is available.
+ *
+ * The intercepting code calls a dedicated callback for this instruction
+ * if a driver did register one in the CRYPTO satellite of the
+ * SIE block.
+ *
+ * If no callback is available, the queues are not available, return this
+ * response code to the caller and set CC to 3.
+ * Else return the response code returned by the callback.
+ */
+static int handle_pqap(struct kvm_vcpu *vcpu)
+{
+	struct ap_queue_status status = {};
+	unsigned long reg0;
+	int ret;
+	uint8_t fc;
+
+	/* Verify that the AP instruction are available */
+	if (!ap_instructions_available())
+		return -EOPNOTSUPP;
+	/* Verify that the guest is allowed to use AP instructions */
+	if (!(vcpu->arch.sie_block->eca & ECA_APIE))
+		return -EOPNOTSUPP;
+	/*
+	 * The only possibly intercepted functions when AP instructions are
+	 * available for the guest are AQIC and TAPQ with the t bit set
+	 * since we do not set IC.3 (FIII) we currently will only intercept
+	 * the AQIC function code.
+	 */
+	reg0 = vcpu->run->s.regs.gprs[0];
+	fc = reg0 >> 24;
+	if (WARN_ON_ONCE(fc != 0x03))
+		return -EOPNOTSUPP;
+
+	/* PQAP instruction is allowed for guest kernel only */
+	if (vcpu->arch.sie_block->gpsw.mask & PSW_MASK_PSTATE)
+		return kvm_s390_inject_program_int(vcpu, PGM_PRIVILEGED_OP);
+
+	/* Common PQAP instruction specification exceptions */
+	/* bits 41-47 must all be zeros */
+	if (reg0 & 0x007f0000UL)
+		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
+	/* APFT not install and T bit set */
+	if (!test_kvm_facility(vcpu->kvm, 15) && (reg0 & 0x00800000UL))
+		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
+	/* APXA not installed and APID greater 64 or APQI greater 16 */
+	if (!(vcpu->kvm->arch.crypto.crycbd & 0x02) && (reg0 & 0x0000c0f0UL))
+		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
+
+	/* AQIC function code specific exception */
+	/* facility 65 not present for AQIC function code */
+	if (!test_kvm_facility(vcpu->kvm, 65))
+		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
+
+	/*
+	 * Verify that the hook callback is registered, lock the owner
+	 * and call the hook.
+	 */
+	if (vcpu->kvm->arch.crypto.pqap_hook) {
+		if (!try_module_get(vcpu->kvm->arch.crypto.pqap_hook->owner))
+			return -EOPNOTSUPP;
+		ret = vcpu->kvm->arch.crypto.pqap_hook->hook(vcpu);
+		module_put(vcpu->kvm->arch.crypto.pqap_hook->owner);
+		if (!ret && vcpu->run->s.regs.gprs[1] & 0x00ff0000)
+			kvm_s390_set_psw_cc(vcpu, 3);
+		return ret;
+	}
+	/*
+	 * A vfio_driver must register a hook.
+	 * No hook means no driver to enable the SIE CRYCB and no queues.
+	 * We send this response to the guest.
+	 */
+	status.response_code = 0x01;
+	memcpy(&vcpu->run->s.regs.gprs[1], &status, sizeof(status));
+	kvm_s390_set_psw_cc(vcpu, 3);
+	return 0;
+}
+
 static int handle_stfl(struct kvm_vcpu *vcpu)
 {
 	int rc;
@@ -878,6 +962,8 @@ int kvm_s390_handle_b2(struct kvm_vcpu *vcpu)
 		return handle_sthyi(vcpu);
 	case 0x7d:
 		return handle_stsi(vcpu);
+	case 0xaf:
+		return handle_pqap(vcpu);
 	case 0xb1:
 		return handle_stfl(vcpu);
 	case 0xb2:
diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
index 76b7f98..a910be1 100644
--- a/drivers/s390/crypto/vfio_ap_private.h
+++ b/drivers/s390/crypto/vfio_ap_private.h
@@ -16,6 +16,7 @@
 #include <linux/mdev.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
+#include <linux/kvm_host.h>
 
 #include "ap_bus.h"
 
@@ -81,6 +82,7 @@ struct ap_matrix_mdev {
 	struct ap_matrix matrix;
 	struct notifier_block group_notifier;
 	struct kvm *kvm;
+	struct kvm_s390_module_hook pqap_hook;
 };
 
 extern int vfio_ap_mdev_register(void);
-- 
2.7.4


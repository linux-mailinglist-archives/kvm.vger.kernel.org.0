Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 287EDDEC3
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 11:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbfD2JKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 05:10:23 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53384 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727749AbfD2JKP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Apr 2019 05:10:15 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3T99u1k043150
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2019 05:10:14 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2s5wg0j84u-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2019 05:10:13 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 29 Apr 2019 10:10:11 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 29 Apr 2019 10:10:08 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3T9A6QY48758836
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Apr 2019 09:10:06 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4ED9A406B;
        Mon, 29 Apr 2019 09:10:05 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D265AA405B;
        Mon, 29 Apr 2019 09:10:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 29 Apr 2019 09:10:05 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 93C9F20F606; Mon, 29 Apr 2019 11:10:05 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>
Subject: [GIT PULL 09/12] KVM: polling: add architecture backend to disable polling
Date:   Mon, 29 Apr 2019 11:09:59 +0200
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190429091002.71164-1-borntraeger@de.ibm.com>
References: <20190429091002.71164-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19042909-0012-0000-0000-0000031666D8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19042909-0013-0000-0000-0000214ECB00
Message-Id: <20190429091002.71164-10-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-29_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=766 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904290067
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are cases where halt polling is unwanted. For example when running
KVM on an over committed LPAR we rather want to give back the CPU to
neighbour LPARs instead of polling. Let us provide a callback that
allows architectures to disable polling.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 include/linux/kvm_host.h | 10 ++++++++++
 virt/kvm/Kconfig         |  3 +++
 virt/kvm/kvm_main.c      |  2 +-
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9d55c63db09b..b3aff1a3f633 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1305,6 +1305,16 @@ static inline bool vcpu_valid_wakeup(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_HAVE_KVM_INVALID_WAKEUPS */
 
+#ifdef CONFIG_HAVE_KVM_NO_POLL
+/* Callback that tells if we must not poll */
+bool kvm_arch_no_poll(struct kvm_vcpu *vcpu);
+#else
+static inline bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+#endif /* CONFIG_HAVE_KVM_NO_POLL */
+
 #ifdef CONFIG_HAVE_KVM_VCPU_ASYNC_IOCTL
 long kvm_arch_vcpu_async_ioctl(struct file *filp,
 			       unsigned int ioctl, unsigned long arg);
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index ea434ddc8499..aad9284c043a 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -57,3 +57,6 @@ config HAVE_KVM_VCPU_ASYNC_IOCTL
 
 config HAVE_KVM_VCPU_RUN_PID_CHANGE
        bool
+
+config HAVE_KVM_NO_POLL
+       bool
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 55fe8e20d8fd..23aec2f4ba71 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2253,7 +2253,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	u64 block_ns;
 
 	start = cur = ktime_get();
-	if (vcpu->halt_poll_ns) {
+	if (vcpu->halt_poll_ns && !kvm_arch_no_poll(vcpu)) {
 		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
 
 		++vcpu->stat.halt_attempted_poll;
-- 
2.19.1


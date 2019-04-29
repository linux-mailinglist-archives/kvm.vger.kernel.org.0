Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3580EDEC1
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 11:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727752AbfD2JKP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 05:10:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43268 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727721AbfD2JKN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Apr 2019 05:10:13 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3T99w3d085288
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2019 05:10:12 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2s5wub1b61-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2019 05:10:12 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 29 Apr 2019 10:10:10 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 29 Apr 2019 10:10:06 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3T9A5ML57278614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Apr 2019 09:10:05 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78C50AE06F;
        Mon, 29 Apr 2019 09:10:03 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E723AE068;
        Mon, 29 Apr 2019 09:10:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 29 Apr 2019 09:10:03 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 22F2820F606; Mon, 29 Apr 2019 11:10:03 +0200 (CEST)
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
Subject: [GIT PULL 01/12] KVM: s390: Fix potential spectre warnings
Date:   Mon, 29 Apr 2019 11:09:51 +0200
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190429091002.71164-1-borntraeger@de.ibm.com>
References: <20190429091002.71164-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19042909-0016-0000-0000-000002766B04
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19042909-0017-0000-0000-000032D2EFBD
Message-Id: <20190429091002.71164-2-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-29_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=852 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904290067
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

Fix some warnings from smatch:

arch/s390/kvm/interrupt.c:2310 get_io_adapter() warn: potential spectre issue 'kvm->arch.adapters' [r] (local cap)
arch/s390/kvm/interrupt.c:2341 register_io_adapter() warn: potential spectre issue 'dev->kvm->arch.adapters' [w]

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Message-Id: <20190417005414.47801-1-farman@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/interrupt.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 82162867f378..bfd55ad34a3e 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -14,6 +14,7 @@
 #include <linux/kvm_host.h>
 #include <linux/hrtimer.h>
 #include <linux/mmu_context.h>
+#include <linux/nospec.h>
 #include <linux/signal.h>
 #include <linux/slab.h>
 #include <linux/bitmap.h>
@@ -2307,6 +2308,7 @@ static struct s390_io_adapter *get_io_adapter(struct kvm *kvm, unsigned int id)
 {
 	if (id >= MAX_S390_IO_ADAPTERS)
 		return NULL;
+	id = array_index_nospec(id, MAX_S390_IO_ADAPTERS);
 	return kvm->arch.adapters[id];
 }
 
@@ -2320,8 +2322,13 @@ static int register_io_adapter(struct kvm_device *dev,
 			   (void __user *)attr->addr, sizeof(adapter_info)))
 		return -EFAULT;
 
-	if ((adapter_info.id >= MAX_S390_IO_ADAPTERS) ||
-	    (dev->kvm->arch.adapters[adapter_info.id] != NULL))
+	if (adapter_info.id >= MAX_S390_IO_ADAPTERS)
+		return -EINVAL;
+
+	adapter_info.id = array_index_nospec(adapter_info.id,
+					     MAX_S390_IO_ADAPTERS);
+
+	if (dev->kvm->arch.adapters[adapter_info.id] != NULL)
 		return -EINVAL;
 
 	adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
-- 
2.19.1


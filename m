Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDEB427247
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 22:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242193AbhJHUda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 16:33:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31192 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231643AbhJHUd1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 Oct 2021 16:33:27 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 198KRNc8029611;
        Fri, 8 Oct 2021 16:31:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=D0Ng5W6WETR3elvHra4RklqaF/XAofJOUiyq8K6cqeI=;
 b=nT5jIvyWIsj4kG7GNVq7ocZHZhOb8siCQXcAZlgb5/k5DTtmKfiMphuSEuUcKK9sRl4w
 sTN28AYi/SiRfmtA9P9F05IBdfRZFs9+1yV3rzWByDHYBtzTpqzwZwOGX6PmfvvdP/3q
 dIWR00HPUVYdsogTTXQNVA9ZESsImiknvcvJTuQQGikJa8wvElVAMX/DxLECSdWnsuKO
 7B1Kw68pbk0gDp4oKDxlUzbn2N3q29NKM3m+bWBufkQLXEUVX/y9TK6+/Ww7VVbQWL9z
 Gb0QJAe9v0czQiolodAwfXOsUTKJBiLT4kz384X9PF8av9ZA5+h3MvLgw1U3ECaN53Hp pA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bjtwh2wka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 16:31:30 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 198KRRa7030257;
        Fri, 8 Oct 2021 16:31:30 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bjtwh2wjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 16:31:30 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 198KMMsA020988;
        Fri, 8 Oct 2021 20:31:28 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3bhepdebkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Oct 2021 20:31:28 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 198KVO2X19726806
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Oct 2021 20:31:25 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF6FFA405F;
        Fri,  8 Oct 2021 20:31:24 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B7A6DA4059;
        Fri,  8 Oct 2021 20:31:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri,  8 Oct 2021 20:31:24 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 3EF47E035B; Fri,  8 Oct 2021 22:31:24 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v1 3/6] KVM: s390: Simplify SIGP Restart
Date:   Fri,  8 Oct 2021 22:31:09 +0200
Message-Id: <20211008203112.1979843-4-farman@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211008203112.1979843-1-farman@linux.ibm.com>
References: <20211008203112.1979843-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BI4OmBB6EC-KkGvf3mHlT_hL7i-XUzSc
X-Proofpoint-ORIG-GUID: NcpPmHkKEqDn3eJuQHBWPKi_lGaOWZmH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-08_06,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 suspectscore=0 clxscore=1011 impostorscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0 mlxlogscore=898
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110080112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we check for the STOP IRQ injection at the top of the SIGP
handler (before the userspace/kernelspace check), we don't need to do
it down here for the Restart order.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 arch/s390/kvm/sigp.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
index 6ca01bbc72cf..0c08927ca7c9 100644
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -240,17 +240,8 @@ static int __sigp_sense_running(struct kvm_vcpu *vcpu,
 static int __prepare_sigp_re_start(struct kvm_vcpu *vcpu,
 				   struct kvm_vcpu *dst_vcpu, u8 order_code)
 {
-	struct kvm_s390_local_interrupt *li = &dst_vcpu->arch.local_int;
 	/* handle (RE)START in user space */
-	int rc = -EOPNOTSUPP;
-
-	/* make sure we don't race with STOP irq injection */
-	spin_lock(&li->lock);
-	if (kvm_s390_is_stop_irq_pending(dst_vcpu))
-		rc = SIGP_CC_BUSY;
-	spin_unlock(&li->lock);
-
-	return rc;
+	return -EOPNOTSUPP;
 }
 
 static int __prepare_sigp_cpu_reset(struct kvm_vcpu *vcpu,
-- 
2.25.1


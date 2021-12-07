Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344AF46C587
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 21:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237040AbhLGVDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:03:04 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7938 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237016AbhLGVCx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:02:53 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7Jbjea013771;
        Tue, 7 Dec 2021 20:59:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eDSBlGhm+RALxEi7NZOjDXUdanFzOO/2k5KuZ5oZm0Q=;
 b=ahIWmqmGDjIzSbcVJxQVg56I29YD7PFRNnWds4FOv5wgweHu+GiqyIFEhlTuqpW2Rii/
 NXkrCV7KF6qYogInQUseXYJMqAq4GxuAUpRJ6GWuP1i2scrEzH/s8xXhmg90eoEk5zAT
 +Hwkp5ST6GCgnLfBghnCqz61ciiIrJ9BRRGShxM+MzHJTELcO+5yxAnl/0mC7qfuVdnn
 Nm3kKI/46gGWXkQQWKFBw3Zokbl3IRT+HEfF2TY7eU3hsGQGfCfgtDyxQ6z6GFHv6o0Z
 T6UqpCow42NFQJyQg3Nki/hJ0kxIakHVSX3N4bVWLuavXITpket2A1iYUUeBgYmi3dGw uA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctdn69rf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:59:22 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7KbBYU006564;
        Tue, 7 Dec 2021 20:59:21 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctdn69rf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:59:21 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7KwN3Y001889;
        Tue, 7 Dec 2021 20:59:21 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01wdc.us.ibm.com with ESMTP id 3cqyyamhtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:59:21 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7KxJ2n55378182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 20:59:19 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22023AE063;
        Tue,  7 Dec 2021 20:59:19 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 611DAAE062;
        Tue,  7 Dec 2021 20:59:14 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 20:59:14 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/32] KVM: s390: expose the guest zPCI interpretation facility
Date:   Tue,  7 Dec 2021 15:57:27 -0500
Message-Id: <20211207205743.150299-17-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207205743.150299-1-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ospw1jk1KqW10jbzsW1L1zK_6IsjZrwf
X-Proofpoint-ORIG-GUID: zQapEGCBifIhMu4aXIJirY6z0C0dCYlZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=888
 suspectscore=0 bulkscore=0 impostorscore=0 mlxscore=0 adultscore=0
 clxscore=1015 spamscore=0 malwarescore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This facility will be used to enable interpretive execution of zPCI
instructions.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index c8fe9b7c2395..09991d05c871 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2751,6 +2751,10 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		set_kvm_facility(kvm->arch.model.fac_mask, 147);
 		set_kvm_facility(kvm->arch.model.fac_list, 147);
 	}
+	if (sclp.has_zpci_interp && test_facility(69)) {
+		set_kvm_facility(kvm->arch.model.fac_mask, 69);
+		set_kvm_facility(kvm->arch.model.fac_list, 69);
+	}
 
 	if (css_general_characteristics.aiv && test_facility(65))
 		set_kvm_facility(kvm->arch.model.fac_mask, 65);
-- 
2.27.0


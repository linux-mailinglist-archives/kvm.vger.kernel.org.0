Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 503D8D27B4
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 13:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732927AbfJJLF1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 07:05:27 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33650 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732838AbfJJLF1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Oct 2019 07:05:27 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9AAcQbI001545
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 07:05:26 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vhynaqnp0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 07:05:26 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Thu, 10 Oct 2019 12:05:24 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 10 Oct 2019 12:05:20 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9AB5Jvm47251474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 11:05:19 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71F3452050;
        Thu, 10 Oct 2019 11:05:19 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 5EAB152051;
        Thu, 10 Oct 2019 11:05:19 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 20C6BE01C6; Thu, 10 Oct 2019 13:05:19 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>
Subject: [PATCH v2 2/2] KVM: s390: Do not yield when target is already running
Date:   Thu, 10 Oct 2019 13:05:18 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191010110518.129256-1-borntraeger@de.ibm.com>
References: <20191010110518.129256-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19101011-4275-0000-0000-00000370D677
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19101011-4276-0000-0000-00003883DDB9
Message-Id: <20191010110518.129256-3-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-10_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=894 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910100084
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the target is already running we do not need to yield.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/kvm/diag.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
index 609c55df3ce8..3fb54ec2cf3e 100644
--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -168,6 +168,10 @@ static int __diag_time_slice_end_directed(struct kvm_vcpu *vcpu)
 	if (!tcpu)
 		goto no_yield;
 
+	/* target already running */
+	if (READ_ONCE(tcpu->cpu) >= 0)
+		goto no_yield;
+
 	if (kvm_vcpu_yield_to(tcpu) <= 0)
 		goto no_yield;
 
-- 
2.21.0


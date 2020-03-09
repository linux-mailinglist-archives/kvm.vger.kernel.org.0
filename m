Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 312AB17DBC3
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 09:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgCIIwY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 04:52:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60182 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726616AbgCIIvl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 04:51:41 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0298oE21038755
        for <kvm@vger.kernel.org>; Mon, 9 Mar 2020 04:51:40 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ym6tmf1bv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 04:51:40 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 9 Mar 2020 08:51:37 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 9 Mar 2020 08:51:36 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0298pYUh39518402
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Mar 2020 08:51:34 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F900AE057;
        Mon,  9 Mar 2020 08:51:34 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E2CFAE058;
        Mon,  9 Mar 2020 08:51:34 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  9 Mar 2020 08:51:34 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 31B2AE0251; Mon,  9 Mar 2020 09:51:34 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Ulrich Weigand <uweigand@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL 20/36] KVM: s390/mm: handle guest unpin events
Date:   Mon,  9 Mar 2020 09:51:10 +0100
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309085126.3334302-1-borntraeger@de.ibm.com>
References: <20200309085126.3334302-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20030908-0016-0000-0000-000002EE810B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030908-0017-0000-0000-00003351DF4C
Message-Id: <20200309085126.3334302-21-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_02:2020-03-06,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015
 suspectscore=0 adultscore=0 impostorscore=0 mlxlogscore=991 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003090066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

The current code tries to first pin shared pages, if that fails (e.g.
because the page is not shared) it will export them. For shared pages
this means that we get a new intercept telling us that the guest is
unsharing that page. We will unpin the page at that point in time,
following the same rules as for making a page secure (i.e. waiting for
writeback, no elevated page references, etc.)

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/intercept.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index b6b7d4b0e26c..f907715d9479 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -16,6 +16,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/irq.h>
 #include <asm/sysinfo.h>
+#include <asm/uv.h>
 
 #include "kvm-s390.h"
 #include "gaccess.h"
@@ -484,12 +485,40 @@ static int handle_pv_sclp(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int handle_pv_uvc(struct kvm_vcpu *vcpu)
+{
+	struct uv_cb_share *guest_uvcb = (void *)vcpu->arch.sie_block->sidad;
+	struct uv_cb_cts uvcb = {
+		.header.cmd	= UVC_CMD_UNPIN_PAGE_SHARED,
+		.header.len	= sizeof(uvcb),
+		.guest_handle	= kvm_s390_pv_get_handle(vcpu->kvm),
+		.gaddr		= guest_uvcb->paddr,
+	};
+	int rc;
+
+	if (guest_uvcb->header.cmd != UVC_CMD_REMOVE_SHARED_ACCESS) {
+		WARN_ONCE(1, "Unexpected notification intercept for UVC 0x%x\n",
+			  guest_uvcb->header.cmd);
+		return 0;
+	}
+	rc = gmap_make_secure(vcpu->arch.gmap, uvcb.gaddr, &uvcb);
+	/*
+	 * If the unpin did not succeed, the guest will exit again for the UVC
+	 * and we will retry the unpin.
+	 */
+	if (rc == -EINVAL)
+		return 0;
+	return rc;
+}
+
 static int handle_pv_notification(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.sie_block->ipa == 0xb210)
 		return handle_pv_spx(vcpu);
 	if (vcpu->arch.sie_block->ipa == 0xb220)
 		return handle_pv_sclp(vcpu);
+	if (vcpu->arch.sie_block->ipa == 0xb9a4)
+		return handle_pv_uvc(vcpu);
 
 	return handle_instruction(vcpu);
 }
-- 
2.24.1


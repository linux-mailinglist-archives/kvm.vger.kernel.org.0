Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4C0158038
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 17:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgBJQyq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 11:54:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42002 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727860AbgBJQyp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Feb 2020 11:54:45 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01AGrOTu061893;
        Mon, 10 Feb 2020 11:54:44 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y1u2dxesy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Feb 2020 11:54:44 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01AGrctG063026;
        Mon, 10 Feb 2020 11:54:44 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y1u2dxesa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Feb 2020 11:54:44 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01AGrOuh024135;
        Mon, 10 Feb 2020 16:54:43 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02wdc.us.ibm.com with ESMTP id 2y1mm6bfky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Feb 2020 16:54:42 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01AGsfIi11862510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Feb 2020 16:54:41 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B6866E05E;
        Mon, 10 Feb 2020 16:54:41 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3EE06E056;
        Mon, 10 Feb 2020 16:54:40 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 10 Feb 2020 16:54:40 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 1/1] s390/uv: Fix handling of length extensions
Date:   Mon, 10 Feb 2020 11:54:39 -0500
Message-Id: <20200210165439.3767-2-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200210165439.3767-1-borntraeger@de.ibm.com>
References: <20200210165439.3767-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-10_06:2020-02-10,2020-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 malwarescore=0 adultscore=0 mlxlogscore=985 bulkscore=0
 spamscore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002100126
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The query parameter block might contain additional information and can
be extended in the future. If the size of the block does not suffice we
get an error code of rc=0x100.  The buffer will contain all information
up to the specified size and the hypervisor/guest simply do not need the
additional information as they do not know about the new data.  That
means that we can (and must) accept rc=0x100 as success.

Cc: stable@vger.kernel.org
Fixes: 5abb9351dfd9 ("s390/uv: introduce guest side ultravisor code")
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/boot/uv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/boot/uv.c b/arch/s390/boot/uv.c
index af9e1cc93c68..c003593664cd 100644
--- a/arch/s390/boot/uv.c
+++ b/arch/s390/boot/uv.c
@@ -21,7 +21,7 @@ void uv_query_info(void)
 	if (!test_facility(158))
 		return;
 
-	if (uv_call(0, (uint64_t)&uvcb))
+	if (uv_call(0, (uint64_t)&uvcb) && uvcb.header.rc != 0x100)
 		return;
 
 	if (IS_ENABLED(CONFIG_KVM)) {
-- 
2.24.0


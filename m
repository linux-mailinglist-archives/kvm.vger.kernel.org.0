Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED4B3B0779
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 16:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbhFVOgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 10:36:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5495 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230481AbhFVOgf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 10:36:35 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15MEYCx4176225;
        Tue, 22 Jun 2021 10:34:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=7PRdAVORoxXjdETnfpTatMWZxJ6ulj8FjajLvOB3gRU=;
 b=R+Z1OizydVv8MOGLRG4oKW0jqnk/FCF/6VzkQcwnC6Cvh+HvaNlEUmH0DpA6Fne2iefT
 wWE6CYGEfCJIuzDv9zSVVgnIZ0c0gobDIo/T+MhiVFqPmQZCds28bCKD42LvJoyjf5TF
 NqNBbB+q2MU+91lUr0arF1E68Y2kD/M2qhniEwNY9yMIKDPV/lIEU46rLUW+qJ0WA73H
 s2u9IYwnKK/fc3f2HqvaKWYRiqoWEsJlTTttKcUkCKOu26eYvz3BIQsHE91sU8kQWWvY
 NQOs4cyUBGcRn+LyKd1PL4tcOMYUtLJAtscM2J2Iu2c2rPVrfOhXIUWp5ISbPbTUYw9c Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39bhh3ggrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 10:34:18 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15MEYIq5177002;
        Tue, 22 Jun 2021 10:34:18 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39bhh3ggqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 10:34:18 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15MEWXwc010499;
        Tue, 22 Jun 2021 14:34:16 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3998788tv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 14:34:16 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15MEWqQr30343432
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 14:32:52 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46D00A4051;
        Tue, 22 Jun 2021 14:34:13 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3355FA4053;
        Tue, 22 Jun 2021 14:34:13 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 22 Jun 2021 14:34:13 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id E3F2EE0407; Tue, 22 Jun 2021 16:34:12 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 1/2] KVM: s390: gen_facilities: allow facilities 165, 193, 194 and 196
Date:   Tue, 22 Jun 2021 16:34:11 +0200
Message-Id: <20210622143412.143369-2-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622143412.143369-1-borntraeger@de.ibm.com>
References: <20210622143412.143369-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nWnRPCoHk9FLSZU1WbC95zsiPmIPtknF
X-Proofpoint-ORIG-GUID: FG5SgNe95b1iW2AjV5YGlYFzlPZho-8f
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_08:2021-06-21,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 adultscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 bulkscore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106220090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This enables the neural NNPA, BEAR enhancement,reset DAT protection and
processor activity counter facilities via the cpu model.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/tools/gen_facilities.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/s390/tools/gen_facilities.c b/arch/s390/tools/gen_facilities.c
index 61ce5b59b828..606324e56e4e 100644
--- a/arch/s390/tools/gen_facilities.c
+++ b/arch/s390/tools/gen_facilities.c
@@ -115,6 +115,10 @@ static struct facility_def facility_defs[] = {
 			12, /* AP Query Configuration Information */
 			15, /* AP Facilities Test */
 			156, /* etoken facility */
+			165, /* nnpa facility */
+			193, /* bear enhancement facility */
+			194, /* rdp enhancement facility */
+			196, /* processor activity instrumentation facility */
 			-1  /* END */
 		}
 	},
-- 
2.31.1


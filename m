Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28803B427B
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 13:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhFYL1E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 07:27:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39098 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229940AbhFYL1C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 07:27:02 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15PBEZwY157885;
        Fri, 25 Jun 2021 07:24:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=syzXsFeGixcgHP7buGraxv60QLmsi+8r1CF9T6tCIJE=;
 b=ZEe5Ne7GLmu+hUvrXi1Ampu+DTYrkIYThwwjMHfjyc6Ehv0bpNqmPd8IJ7H1nHOnVrQl
 xVZyuQefC5dQyCdxPXEgM1enqsGofFtEvF/lCOp6vZ9zSEAt/aNpF2KuijXcnWY5KS3K
 4nNxJKASWRV1a3QfAs8hiwwLgdjn0kpdFmU/AXwNTxMoIFV6AasZgxwenhrOU4ntFdQf
 /sE2ZyuW9ctwLkJbgxJi7jkaGZW3vhotc3rfJirGFM7dCE6SiRPib4Nh/K0wrzKYaXsn
 b6gt0Rb4WNmQPnOYOh5AGEsm1MSUgOSNq8obIWVLYLnMuki6jYesK/PBOcIGYpT0xwsP 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39de3d0bfq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Jun 2021 07:24:40 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15PBFXA7160459;
        Fri, 25 Jun 2021 07:24:40 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39de3d0bf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Jun 2021 07:24:40 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15PBHciN031492;
        Fri, 25 Jun 2021 11:24:38 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3997uhb08w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Jun 2021 11:24:38 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15PBN82m37093708
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Jun 2021 11:23:08 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7838152052;
        Fri, 25 Jun 2021 11:24:35 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 65EFC5204F;
        Fri, 25 Jun 2021 11:24:35 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 32D67E07DE; Fri, 25 Jun 2021 13:24:35 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [GIT PULL 2/3] KVM: s390: gen_facilities: allow facilities 165, 193, 194 and 196
Date:   Fri, 25 Jun 2021 13:24:33 +0200
Message-Id: <20210625112434.12308-3-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210625112434.12308-1-borntraeger@de.ibm.com>
References: <20210625112434.12308-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HYEnftaQ71pmjz_CjyKQBuluBqka99UC
X-Proofpoint-GUID: r9Jz51FJ6I5sGAiIjTq2kNMGl8O4bkKQ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_03:2021-06-25,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106250063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This enables the NNPA, BEAR enhancement,reset DAT protection and
processor activity counter facilities via the cpu model.

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
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


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243B13B0777
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 16:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbhFVOgg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 10:36:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19090 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231218AbhFVOgf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 10:36:35 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15MEXfkQ037477;
        Tue, 22 Jun 2021 10:34:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=NhXfN/m2EO4s+TcxSAuMzkz3f1y8aU5h+qoM58p934g=;
 b=nxO3ZAISn+Pxna7/B6cd77x6qEiwWn/+a5eRAzy0spiNynvVeghjNm360OIQyKwF38AI
 83OUi70Y5rAvs2UQtPFoHI2xaIQeq5XKs6Ow09yv3sP75oRFgUT4L6tm1h+irxEFfOT7
 Xa06ynzFbyOaZVC0X/6LJmMOkcBjrLLBwxqdFGszgCEdjTZ5C9QWNedUB+T5N+uFAZMt
 2CiYcpknSCPg9P3CEyoAuxntpYBhB+hqMg8TA6cOpc+60iYn4MHaiWu+OTs5K6bL0ZMb
 f4f7bWbmTB9VPocDj8lsh5xuyXmgpI7bCSJPeLn1x48in8c6bxw4VQDt/yKoNgJcR+gk Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39bcm3abqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 10:34:19 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15MEYIQF039744;
        Tue, 22 Jun 2021 10:34:18 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39bcm3abpg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 10:34:18 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15MEXbU9029012;
        Tue, 22 Jun 2021 14:34:16 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3998788tym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 14:34:16 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15MEYDYW27656646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 14:34:13 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00C2642042;
        Tue, 22 Jun 2021 14:34:13 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E38D14203F;
        Tue, 22 Jun 2021 14:34:12 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 22 Jun 2021 14:34:12 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 9E2A9E03CC; Tue, 22 Jun 2021 16:34:12 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 0/2] KVM: s390: Enable some more facilities
Date:   Tue, 22 Jun 2021 16:34:10 +0200
Message-Id: <20210622143412.143369-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lg2EF7O8DbVvtbPzgT4XwDaiG1V_dtag
X-Proofpoint-GUID: DQ0904tsOTUAeFR2xkRJMtL5Do182N0R
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_08:2021-06-21,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 adultscore=0 bulkscore=0 spamscore=0 mlxlogscore=948 mlxscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106220090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some more facilities that can be enabled in the future.

Christian Borntraeger (2):
  KVM: s390: gen_facilities: allow facilities 165, 193, 194 and 196
  KVM: s390: allow facility 192 (vector-packed-decimal-enhancement
    facility 2)

 arch/s390/kvm/kvm-s390.c         | 4 ++++
 arch/s390/tools/gen_facilities.c | 4 ++++
 2 files changed, 8 insertions(+)

-- 
2.31.1


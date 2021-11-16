Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842FF453364
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 14:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236969AbhKPOBI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 09:01:08 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13154 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236907AbhKPOBH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 09:01:07 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AGDhMxa018605;
        Tue, 16 Nov 2021 13:58:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=je6nlO/FiWqgF1uX3TbKw+7WkwKiUtY9YIYwUGXNpsg=;
 b=fZ1Ntb1y+gA5yRMrDddFeMsuROefc1tUsfKMCsad5S5WV1sue/uj/gQ+2bdUCWaCGXoy
 macmaG8nllZQWmLchww3UdA8VFJ4gHAOYpOzDbvDxDEw8M4efUdI6dRmMUjNS88CALoH
 4ZwLa5Gop8CyRAmRZsMaFUFGT6twgmXVNHXmT7ZiXB0Be3uJnladSWCjHRDdAk3GSAu6
 Wt+Ikx+FRHhshKIUbSQLIpuf80dLESJz9UobZEx6QlV2qOtj5oH8kb7TYW6ZGnEeDJLP
 +68Kp2YXCnjXp6Nz+hRzGeelhiJZffddHrO5Kc6ThVejOPkenjYlDXFBfMGiH4LrIJij SA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ccdscr9sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Nov 2021 13:58:09 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AGDiQhx023923;
        Tue, 16 Nov 2021 13:58:09 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ccdscr9s0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Nov 2021 13:58:08 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AGDT8tT032011;
        Tue, 16 Nov 2021 13:58:07 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3ca50a02v4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Nov 2021 13:58:07 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AGDw4dY59769236
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Nov 2021 13:58:04 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A000A40A1;
        Tue, 16 Nov 2021 13:58:04 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9C4EA40AC;
        Tue, 16 Nov 2021 13:58:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 16 Nov 2021 13:58:03 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 9943DE041C; Tue, 16 Nov 2021 14:58:03 +0100 (CET)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 0/1] Update my mail address
Date:   Tue, 16 Nov 2021 14:58:02 +0100
Message-Id: <20211116135803.119489-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: R_3Fr02eNFuYsdsiamnG5kVjfXMDY6wh
X-Proofpoint-ORIG-GUID: q5gACT3Hn9ggH0ng3nTT3A1bbYfR4s7M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-16_02,2021-11-16_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=856 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 clxscore=1011 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111160069
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo, Heiko, Vasily,

I plan to submit this via the s390/fixes tree.

Christian Borntraeger (1):
  MAINTAINERS: update email address of borntraeger

 .mailmap    | 3 +++
 MAINTAINERS | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

-- 
2.31.1


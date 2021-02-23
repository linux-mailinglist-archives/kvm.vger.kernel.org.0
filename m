Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E75032312E
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 20:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbhBWTOl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 14:14:41 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23520 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230114AbhBWTOk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 14:14:40 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NJ2h1q011765;
        Tue, 23 Feb 2021 14:13:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=ykJhJz2Y/yV96Zls5vPfzXgD4YnQ1pOgma5Gqu5wE/I=;
 b=r2cyRqBsjTf+8nNDdroxL72ER4uj2NbHkK2aZU3KOxupSI1H94vF/v+LD3LlSPCPyqTq
 yyrbAtGmLprEKFHM4n9Qme092SfEFOVEXGPy2HxgxhCmmSonJLt6OD20JA4zLXhwLdtI
 VOFvcwGOqqZxULbW019bgKg1L+mvC3CPZbpYl5xCqq0xpcwB82Skzcuqt0vk6nipmJu5
 jWyuHNLgoyqeM6SarWs2oPEunNbRrEA+r6gnZMO/wClkiQB6DTk37Xyb118wDpX6hgwi
 66QB331VUmrmZxxxN0Sn+KX9Zv5O6SnAZI9obPG7wZJib4OnGGZF0KcFSeYasuInbLET yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vkg3csgx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 14:13:59 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11NJ3BGq017316;
        Tue, 23 Feb 2021 14:13:59 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vkg3csgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 14:13:59 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11NJC9cp014507;
        Tue, 23 Feb 2021 19:13:56 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 36tt282w2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 19:13:56 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11NJDfkv36503892
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 19:13:41 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7CE2A4040;
        Tue, 23 Feb 2021 19:13:53 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6543FA404D;
        Tue, 23 Feb 2021 19:13:53 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.5.213])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Feb 2021 19:13:53 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v4 0/2] s390/kvm: fix MVPG when in VSIE
Date:   Tue, 23 Feb 2021 20:13:51 +0100
Message-Id: <20210223191353.267981-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_08:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 priorityscore=1501 malwarescore=0
 mlxlogscore=679 mlxscore=0 impostorscore=0 bulkscore=0 spamscore=0
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102230158
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current handling of the MVPG instruction when executed in a nested
guest is wrong, and can lead to the nested guest hanging.

This patchset fixes the behaviour to be more architecturally correct,
and fixes the hangs observed.

v3->v4
* added PEI_ prefix to DAT_PROT and NOT_PTE macros
* added small comment to explain what they are about

v2->v3
* improved some comments
* improved some variable and parameter names for increased readability
* fixed missing handling of page faults in the MVPG handler
* small readability improvements

v1->v2
* complete rewrite

Claudio Imbrenda (2):
  s390/kvm: extend kvm_s390_shadow_fault to return entry pointer
  s390/kvm: VSIE: correctly handle MVPG when in VSIE

 arch/s390/kvm/gaccess.c |  30 ++++++++++--
 arch/s390/kvm/gaccess.h |   6 ++-
 arch/s390/kvm/vsie.c    | 101 ++++++++++++++++++++++++++++++++++++----
 3 files changed, 122 insertions(+), 15 deletions(-)

-- 
2.26.2


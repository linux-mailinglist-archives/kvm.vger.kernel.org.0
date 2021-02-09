Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0733151D2
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 15:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbhBIOjd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 09:39:33 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30438 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232073AbhBIOjX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 09:39:23 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 119EZGEn052897;
        Tue, 9 Feb 2021 09:38:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=hXJYyxHSrJuhh5RhfOYW5auI8Vi9JDwjlDkvwP7NI6M=;
 b=cin/PQa7bAB4DRqcOrLHgwWGtI67ohzsBkten5f+2HbSto4DruMut9lfLaydQ3EBuk7E
 KFA/jnp2tSfW1pi1SPzKzn408NV0r1piMeOySaEYLq19Nr2YdmrLPFtmb8Z1GmZxuNOK
 yn0urNeq59PmB7siWjpHDHPteUYi4DwUjDzJj1hzSNTM73mrJuwlJcn3cn7+70WWpJIz
 ThoEevcvpniiQm+OegSG6uRJmlgVEr+o7SvWxJ+wWHquGkD0WMvCFxLSjD5Ut8wdpIZe
 licFIGmWrlzqDwPL8LTS04D+n2QhAecvH9qFB6iP5swPkardjkVrGMIWNNryexT5ci5w wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36kv9r8517-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 09:38:41 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 119EZKEf053275;
        Tue, 9 Feb 2021 09:38:41 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36kv9r850a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 09:38:41 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 119EXCw7002862;
        Tue, 9 Feb 2021 14:38:39 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 36hqda38q3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 14:38:38 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 119Ecap137355974
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Feb 2021 14:38:36 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F36611C052;
        Tue,  9 Feb 2021 14:38:36 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2F4011C04A;
        Tue,  9 Feb 2021 14:38:35 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.1.216])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Feb 2021 14:38:35 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com, pmorel@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 0/4] s390: Add support for large pages
Date:   Tue,  9 Feb 2021 15:38:31 +0100
Message-Id: <20210209143835.1031617-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_03:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 mlxscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090072
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce support for large (1M) and huge (2G) pages.

Add a simple testcase for EDAT1 and EDAT2.

Claudio Imbrenda (4):
  libcflat: add SZ_1M and SZ_2G
  s390x: lib: fix and improve pgtable.h
  s390x: mmu: add support for large pages
  s390x: edat test

 s390x/Makefile          |   1 +
 lib/s390x/asm/pgtable.h |  38 ++++++-
 lib/libcflat.h          |   2 +
 lib/s390x/mmu.h         |  73 +++++++++++-
 lib/s390x/mmu.c         | 246 ++++++++++++++++++++++++++++++++++++----
 s390x/edat.c            | 238 ++++++++++++++++++++++++++++++++++++++
 s390x/unittests.cfg     |   3 +
 7 files changed, 572 insertions(+), 29 deletions(-)
 create mode 100644 s390x/edat.c

-- 
2.26.2


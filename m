Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEA834264D
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 20:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhCSTeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 15:34:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41326 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230467AbhCSTeB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 15:34:01 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12JJXJI7161488;
        Fri, 19 Mar 2021 15:34:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=QiNxQUHTB+LUXXdMQbtriTAifyLUm8O4BBI9qJujYMs=;
 b=HPbRBdlaHS/zn30j9Spu03Pktsbaruqrul2VLvWrOEc5s1xXPB4AG7t8yZ4r7WukJ4tX
 TzR326l1Qx6vyJTr6d14pJWNUZCihsN06XkIQsDk/anK8ifWwGqaXzjqXpdqvcefzMZl
 Yq3QVmDGQ9zKg6zQ/3YH2lKvKp4iRV5RnoZPfC+Kb4xuBA5qlavgvFxPZFmNmc8BwwBA
 FVk7lUvSI9Z2jee3h+QKc1gHvW98CZV3QrJ1q0ONK1ICUP0KuMb+qLvf8KJ9zqgMSTWh
 VhdhIL4+JPWPsE1TozTOqscbT+yMnB22hnkllMXeqPZaSsEcIhdXfo/Ux0ISDU1A+Ucs 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c7m74ctf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 15:34:01 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12JJY1Vt165196;
        Fri, 19 Mar 2021 15:34:01 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37c7m74csy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 15:34:00 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12JJW3tG016919;
        Fri, 19 Mar 2021 19:33:58 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 378n18p00a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Mar 2021 19:33:58 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12JJXt2A16384384
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 19:33:55 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4619BA4054;
        Fri, 19 Mar 2021 19:33:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9D62A405B;
        Fri, 19 Mar 2021 19:33:54 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.2.56])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Mar 2021 19:33:54 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v1 0/2] s390/kvm: VSIE: fix prefixing and MSO for MVPG
Date:   Fri, 19 Mar 2021 20:33:52 +0100
Message-Id: <20210319193354.399587-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_10:2021-03-19,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=880 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190130
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest real address needs to pass through prefixing in order to yield
the absolute address.

The absolute address needs to be offset by the MSO in order to get the
host virtual address.

Claudio Imbrenda (2):
  s390/kvm: split kvm_s390_real_to_abs
  s390/kvm: VSIE: fix MVPG handling for prefixing and MSO

 arch/s390/kvm/gaccess.h | 23 +++++++++++++++++------
 arch/s390/kvm/vsie.c    | 10 +++++++---
 2 files changed, 24 insertions(+), 9 deletions(-)

-- 
2.26.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1783219D9
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 15:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbhBVOKh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 09:10:37 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34300 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231419AbhBVOJt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 09:09:49 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11ME589S018816;
        Mon, 22 Feb 2021 09:09:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=srmRYY9KOXm2In6DQzRA90ulNGhW3frH5GXWf7daVz0=;
 b=gPley3eGNat4tk6BdkBqQ+Rt+G0D0WwyrDD9mTU3fLBUsbX0vc2qOdjCatwNFt0yYXtN
 iQYMxRHbxld/KRC2jXl6iF57/PXDi9SdqYb3otSbAkTGsCiA+Cbg+K3FLZQacoK3Yqfj
 bUvwoahE5Qsk66IW2MElZV2kvc8hw0Q6bCl1KZY6JyEm33CHYHNO2wyxEhfkguuoGG8b
 bRTBzSLyg6Mi85bc8fHwNCcQGuNZsrmx+NVO9kOqp2WxjQifU5D6IDCX1nR26GVKirBA
 UsMUEmcWZvctXOxle5fbhP4kvMGROC/dmmdtZWc+NQ5gTEhnS7yJFnAnmT0yuH526sMs Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36ve1brdcr-42
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 09:09:07 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11MDQbjc013935;
        Mon, 22 Feb 2021 08:31:54 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vdgeg67e-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 08:31:54 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11MCRww8028401;
        Mon, 22 Feb 2021 12:41:06 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 36tt281mn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 12:41:06 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11MCepMA26608126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Feb 2021 12:40:51 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 512B6AE051;
        Mon, 22 Feb 2021 12:41:03 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDB2FAE045;
        Mon, 22 Feb 2021 12:41:02 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.71.218])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 22 Feb 2021 12:41:02 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, cohuck@redhat.com, david@redhat.com,
        thuth@redhat.com, pmorel@linux.ibm.com
Subject: [PATCH v4 0/1] KVM: s390: diag9c (directed yield) forwarding
Date:   Mon, 22 Feb 2021 13:41:00 +0100
Message-Id: <1613997661-22525-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-22_02:2021-02-22,2021-02-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102220130
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch will forward the yield_to hypercall (diag9c) if in the host
the target CPU is also not running. As we do not yet have performance
data (and recommendations) the default is turned off, but this can
be changed during runtime.

The documentation notation for the titles is kept coherent with
the other DIAGNOSE entries using the zVM notation DIAGNOSE 'X'9C,
While in the explanation part we use the standard Linux notation
DIAGNOSE 0x9c.

Regards,
Pierre


Pierre Morel (1):
  KVM: s390: diag9c (directed yield) forwarding

 Documentation/virt/kvm/s390-diag.rst | 33 ++++++++++++++++++++++++++++
 arch/s390/include/asm/kvm_host.h     |  1 +
 arch/s390/include/asm/smp.h          |  1 +
 arch/s390/kernel/smp.c               |  1 +
 arch/s390/kvm/diag.c                 | 31 +++++++++++++++++++++++---
 arch/s390/kvm/kvm-s390.c             |  6 +++++
 arch/s390/kvm/kvm-s390.h             |  8 +++++++
 7 files changed, 78 insertions(+), 3 deletions(-)

-- 
2.17.1

Changelog:

From v3:

- rewording of the commit message
  (Connie)

- great rewording of the documentation
  (Connie)

- Keep smp_yield_cpu symbol GPL
  (Connie)

- More explicit diag9c_forwarding_hz parameter description
  (Connie)

From v2:

- update overrun comparison, avoid comparison on unsigned
  (Pierre)

From v1:

- more precise comments
  (Connie)

- Documentation
  (Janosch)

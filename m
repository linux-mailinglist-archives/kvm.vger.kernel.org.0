Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334273406D6
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 14:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhCRN0j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Mar 2021 09:26:39 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39992 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229634AbhCRN0f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Mar 2021 09:26:35 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12ID60FB147611
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 09:26:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id; s=pp1;
 bh=07d9K59A7GE/IJ1a6zdRkn1UG/83ww2K8CdV7qUPkgo=;
 b=OW+QxRzfqUF1uHvfyTBFFR4u83EMrcpaKaIp9DvqBS3TQKoMYi695+2WcSQ0HZLyVpUN
 0bxH5WgB/k/q+FlJwCxQrA/0JfUNmJBguc9G/MsTYB3Ks6ndsLXvT7Z1mxpDm1Cv9eWj
 6qZJ3W4Fm7tRk6VTmT+NNXQxujLGFCMoAVKm6ovptfFNYALAM7syH6a3H0a6E1kEO57Q
 zZBLk7o9txolH0B2mxsbzKOYjKXH++K6hHk9LKOkc0yTBsQPo3hOd/Bl9QQQkXNP2NVM
 Y3g/8fEA9kMJU698ahJJyidIANVzq5sSCSqM2XLWg31GXqCyQg5R79hMCzK7K5uJBApD Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37c6tf1ytd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 09:26:34 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12ID6dPq154526
        for <kvm@vger.kernel.org>; Thu, 18 Mar 2021 09:26:34 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37c6tf1yss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 09:26:34 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12IDOccR016730;
        Thu, 18 Mar 2021 13:26:33 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 37b6xjgsx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 13:26:32 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12IDQD6v33948114
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 13:26:13 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB9C04C059;
        Thu, 18 Mar 2021 13:26:29 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FC4D4C058;
        Thu, 18 Mar 2021 13:26:29 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.64.4])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 18 Mar 2021 13:26:29 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 0/6] Testing SSCH, CSCH and HSCH for errors
Date:   Thu, 18 Mar 2021 14:26:22 +0100
Message-Id: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_07:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 adultscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=691 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103180097
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The goal of this series is to test some of the I/O instructions,
SSCH, CSCH and HSCH for errors like invalid parameters, addressing,
timing etc.
Testing about timing in QEMU/KVM is truncated to sending an instruction
before the status of the preceding instruction is cleared due ton
the QEMU serialization.

To be able to achieve these tests we we need to enhance the testing
environment with:

- new definitions for the SCSW control bits
- a new function to disable a subchannel
- handling multiple interrupts
- checking the reason of the interrupts
- deferring tsch outside of the interrupt routine

regards,
Pierre

Pierre Morel (6):
  s390x: lib: css: disabling a subchannel
  s390x: lib: css: SCSW bit definitions
  s390x: lib: css: upgrading IRQ handling
  s390x: lib: css: add expectations to wait for interrupt
  s390x: css: testing ssch error response
  s390x: css: testing clear and halt subchannel

 lib/s390x/css.h     |  55 ++++++++-
 lib/s390x/css_lib.c | 197 ++++++++++++++++++++++++++-----
 s390x/css.c         | 276 +++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 498 insertions(+), 30 deletions(-)

-- 
2.17.1


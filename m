Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA582B68E7
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 16:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgKQPnA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 10:43:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34256 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725767AbgKQPm7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Nov 2020 10:42:59 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHFWibm070855;
        Tue, 17 Nov 2020 10:42:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=ERJWrKqq4ZyO6mTIydb3k4QoL97E2UvynHRBDzBmMgU=;
 b=qCQV7SrfnUP5RsjDzLVD0sf05OAN0rsAvB+3hV93SwhfuPkkaOrHg+0nUiFvNoomFOPg
 NVplLICxvbaEFsDgyBoW+ynhRxeHrb9OmObRQZ7O6DLwgy3dfkxbDsKsSL7+yW9L3ico
 kBpxeTsJrec4nY/YCyZCrkYFuzLlFVZb6mG3/5BEOgzX1jxShAC9hzMKLHyYTlTnq9ne
 vp4sYJwh6oqG6x0dur34tBOyn41hw7M14sYJJcfPN3iecA/3vr5lX4c8/lNW1xGTjpuc
 05v6tQkbRtEvLU9cQ4ExfjKfptp8xsSTzvUWdC73N8pUtCyfa2HUqbYii3UPYi0eS1XM Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34vd6hscnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 10:42:58 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AHFWu1o072237;
        Tue, 17 Nov 2020 10:42:58 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34vd6hscm7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 10:42:58 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHFgWtv005677;
        Tue, 17 Nov 2020 15:42:55 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 34t6v8b2h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 15:42:55 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHFgqQH51577144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 15:42:52 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 568B24C044;
        Tue, 17 Nov 2020 15:42:52 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A33E74C040;
        Tue, 17 Nov 2020 15:42:51 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 Nov 2020 15:42:51 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 0/5] s390x: Add SIE library and simple test
Date:   Tue, 17 Nov 2020 10:42:10 -0500
Message-Id: <20201117154215.45855-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_04:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 suspectscore=0 impostorscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 mlxlogscore=780
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the absolute minimum needed to run VMs inside the KVM Unit
Tests. It's more of a base for other tests that I can't (yet) publish
than an addition of tests that check KVM functionality. However, I
wanted to decrease the number of WIP patches in my private
branch. Once the library is available maybe others will come and
extend the SIE test itself.

Yes, I have added VM management functionality like VM create/destroy,
etc but as it is not needed right now, I'd like to exclude it from
this patch set for now.

Gitlab:
https://gitlab.com/frankja/kvm-unit-tests/-/tree/sie

CI:
https://gitlab.com/frankja/kvm-unit-tests/-/pipelines/217336822

Janosch Frank (5):
  s390x: Add test_bit to library
  s390x: Consolidate sclp read info
  s390x: SCLP feature checking
  s390x: sie: Add SIE to lib
  s390x: sie: Add first SIE test

 lib/s390x/asm-offsets.c  |  13 +++
 lib/s390x/asm/arch_def.h |   7 ++
 lib/s390x/asm/bitops.h   |  16 ++++
 lib/s390x/asm/facility.h |   3 +-
 lib/s390x/interrupt.c    |   7 ++
 lib/s390x/io.c           |   2 +
 lib/s390x/sclp.c         |  48 ++++++++--
 lib/s390x/sclp.h         |  18 ++++
 lib/s390x/sie.h          | 197 +++++++++++++++++++++++++++++++++++++++
 lib/s390x/smp.c          |  23 ++---
 s390x/Makefile           |   1 +
 s390x/cstart64.S         |  56 +++++++++++
 s390x/sie.c              | 125 +++++++++++++++++++++++++
 13 files changed, 495 insertions(+), 21 deletions(-)
 create mode 100644 lib/s390x/sie.h
 create mode 100644 s390x/sie.c

-- 
2.25.1


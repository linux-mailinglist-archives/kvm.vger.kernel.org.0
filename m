Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571942FE97B
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 13:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbhAULUW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 06:20:22 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39272 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728116AbhAULTN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 06:19:13 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10LB2Tg1169325;
        Thu, 21 Jan 2021 06:18:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=n24oxlG++EA7+3fDUlpmfDXsrTtil7ul85RWh/Lqbes=;
 b=jfHwG8RhDz3gi2ACVrQErbr132BB1DdF02um3+72jNCQpXxJpmLGCZYewmCuG8UQoTy/
 Wj0TH5jFRem6GNJNNdXpk7sk93dIHVvG6hiImHEEmyKJh30IbYX4YqSIlLMwMPMElKCF
 BPTX6CpW9713u6lrETlGvS0XzGsX4HsA0PAIr0/uOrMDoESH4KXOgh3VDwCvGrilqy6Z
 3OjOMWzsMxDWQXExThJObWf4XT1tm1btlq/VW8SHNDMtXV8Jh1ltAtBR9bJ26PCyEf2V
 XLf6Nk2O0o7LEp2zTxpiQJZIihqeIZB9StmX0Jsg23JJ/0mAjB/UTT2hpQqf+OkyRApF Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3677nna12g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 06:18:24 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10LB5c2i183717;
        Thu, 21 Jan 2021 06:18:24 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3677nna11d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 06:18:24 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10LBHadO013053;
        Thu, 21 Jan 2021 11:18:22 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3668p0sk5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 11:18:22 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10LBIDvE35389700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 11:18:13 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CADD2AE058;
        Thu, 21 Jan 2021 11:18:19 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B316AE051;
        Thu, 21 Jan 2021 11:18:19 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.4.167])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 11:18:19 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com, lvivier@redhat.com,
        nadav.amit@gmail.com, krish.sadhukhan@oracle.com,
        dmatlack@google.com, seanjc@google.com
Subject: [kvm-unit-tests PATCH v1 0/2] Fix smap and pku tests for new allocator
Date:   Thu, 21 Jan 2021 12:18:06 +0100
Message-Id: <20210121111808.619347-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_04:2021-01-21,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 clxscore=1015 mlxscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101210056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The recent fixes to the page allocator broke the SMAP test.

The reason is that the test blindly took a chunk of memory and used it,
hoping that the page allocator would not touch it.

Unfortunately the memory area affected is exactly where the new
allocator puts the metadata information for the 16M-4G memory area.

This causes the SMAP test to fail.

The solution is to reserve the memory properly using the reserve_pages
function. To make things simpler, the memory area reserved is now
8M-16M instead of 16M-32M.

This issue was not found immediately, because the SMAP test needs
non-default qemu parameters in order not to be skipped.

I tested the patch and it seems to work.

While fixing the SMAP test, I also noticed that the PKU test was doing
the same thing, so I went ahead and fixed that test too in the same
way. Unfortunately I do not have the right hardware and therefore I
cannot test it.



I would really appreciate if someone who has the right hardware could
test the PKU test and see if it works.




Claudio Imbrenda (2):
  x86: smap: fix the test to work with new allocator
  x86: pku: fix the test to work with new allocator

 x86/pku.c  | 5 ++++-
 x86/smap.c | 9 ++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

-- 
2.26.2


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6FFD2F3179
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 14:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732358AbhALNV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 08:21:56 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51368 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729303AbhALNV4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 08:21:56 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CDG8Fk184721;
        Tue, 12 Jan 2021 08:21:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=IWj/54VTi75ZD4lwJOBWscmuML0OT0LXJ6DNcd/ZqsM=;
 b=FzImBZUN09lLDxXxyIkFXscplrMb0lDDc2fm15sTV7N6l5BMhlCLRu1Z9VZqtS5BjEA+
 sv+/hIsEp9y35A4SpEBYKh0ycJTqWp0Bm1zRVwVTNDAdBUUTIMv/4ymgrkHfBEMd1JYY
 5SNdoEGseP0BhTAb1bgVNXetlZDg22vfI/Weyl9CwnyF6bCzlRP3iGHsbXcHoaaLuzmx
 mzUA+V8D5ZEyZiUeAdmnpEkDuiYy4v7VNmtMadk6eQUTzSlpmkVhRy4UrOXStpGFz5pe
 DWMematlZHCUqUuZ6uHjhCCMuYEyd5LE3a3qRP32y6yFLDZDhoF1pEknOyIauQl1f3fE eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 361cgmr397-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 08:21:14 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10CDI26q192592;
        Tue, 12 Jan 2021 08:21:14 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 361cgmr38c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 08:21:14 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CDHSGi015940;
        Tue, 12 Jan 2021 13:21:12 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 35y447unt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 13:21:12 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CDL91k27394492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 13:21:09 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 472704C044;
        Tue, 12 Jan 2021 13:21:09 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E9954C059;
        Tue, 12 Jan 2021 13:21:08 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 13:21:08 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 0/9] s390x: Add SIE library and simple tests
Date:   Tue, 12 Jan 2021 08:20:45 -0500
Message-Id: <20210112132054.49756-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_07:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 mlxscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120071
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

v4:
	* Removed asm directory and moved all asm files into s390x/ (I changed my view)
	* Review fixes
	* Removed a stray newline in the asm offsets file

v3:
	* Rebased on re-license patches
	* Split assembly
	* Now using ICPT_* constants
	* Added read_info asserts
	* Fixed missing spin_lock() in smp.c lib
	* Replaced duplicated code in sie test with generic intercept test
	* Replaced uv-guest.x bit testing with test_bit_inv()
	* Some other minor cleanups

Gitlab:
https://gitlab.com/frankja/kvm-unit-tests/-/tree/sie

CI:
https://gitlab.com/frankja/kvm-unit-tests/-/pipelines/240506525


Janosch Frank (9):
  s390x: Add test_bit to library
  s390x: Consolidate sclp read info
  s390x: SCLP feature checking
  s390x: Split assembly into multiple files
  s390x: sie: Add SIE to lib
  s390x: sie: Add first SIE test
  s390x: Add diag318 intercept test
  s390x: Fix sclp.h style issues
  s390x: sclp: Add CPU entry offset comment

 lib/s390x/asm-offsets.c  |  11 +++
 lib/s390x/asm/arch_def.h |   9 ++
 lib/s390x/asm/bitops.h   |  26 ++++++
 lib/s390x/asm/facility.h |   3 +-
 lib/s390x/interrupt.c    |   7 ++
 lib/s390x/io.c           |   2 +
 lib/s390x/sclp.c         |  57 +++++++++--
 lib/s390x/sclp.h         | 181 +++++++++++++++++++----------------
 lib/s390x/sie.h          | 197 +++++++++++++++++++++++++++++++++++++++
 lib/s390x/smp.c          |  27 +++---
 s390x/Makefile           |   7 +-
 s390x/cstart64.S         | 119 +----------------------
 s390x/intercept.c        |  19 ++++
 s390x/lib.S              | 121 ++++++++++++++++++++++++
 s390x/macros.S           |  77 +++++++++++++++
 s390x/sie.c              | 113 ++++++++++++++++++++++
 s390x/unittests.cfg      |   3 +
 s390x/uv-guest.c         |   6 +-
 18 files changed, 761 insertions(+), 224 deletions(-)
 create mode 100644 lib/s390x/sie.h
 create mode 100644 s390x/lib.S
 create mode 100644 s390x/macros.S
 create mode 100644 s390x/sie.c

-- 
2.25.1


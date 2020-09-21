Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D31C271D92
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 10:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgIUIKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 04:10:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45058 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbgIUIKn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 04:10:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08L8961A163592;
        Mon, 21 Sep 2020 08:10:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=5vYeTsR3FXtTok9hIWQTwXvWr0ueKem5fAmGgOOBPyU=;
 b=XCXY2VfxFPGc1R5MIuVwJmuOlLi7LOcWkhOCTupN517ETL53vJxbkyrgYx3FPOB0CbVJ
 ITUNo97DJ3yrsI2cQz1wJxlPREM8vVaPMD1UtuQLqFyQSrKsoOOg5JcIYKsKB5dupD1t
 NE+m4P8jS08Dt1txjL2kVJeK7pjfqrw+lXhhu1Q1js1zV/kyfudbso7a7i0msrpsb5E7
 r0KcxpoYhMEuGuOO+UTlAHBKigagmO6cxuvFBBM3P3RCdngTlG8ba1IrvHGLZvX6pZ9R
 KmnjTTtnoI5o7KIl8007FjD1DEFNB+oxWNAxxM1z1X1tcefD5/83UndGc3qha5xUKXPQ tQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33n9xkm31u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 21 Sep 2020 08:10:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08L85mm6188353;
        Mon, 21 Sep 2020 08:10:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33nuw04r7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Sep 2020 08:10:38 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08L8AaxK022449;
        Mon, 21 Sep 2020 08:10:37 GMT
Received: from sadhukhan-nvmx.osdevelopmeniad.oraclevcn.com (/100.100.230.226)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 01:10:36 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 0/3 v3] kvm-unit-test: nVMX: Test Selector and Base Address fields of Guest Segment registers
Date:   Mon, 21 Sep 2020 08:10:24 +0000
Message-Id: <20200921081027.23047-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9750 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=13 adultscore=0 mlxlogscore=767 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009210059
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9750 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=13 priorityscore=1501 adultscore=0 spamscore=0 clxscore=1015
 mlxlogscore=791 bulkscore=0 mlxscore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009210059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's been a while since I sent out v2. This patch-series tests the Selector
and Base Address fields of the Guest Segement register according to section
"Checks on Guest Segment Registers" in SDM vol 3C. "Unrestricted guest"
VM-execution control is a condition in testing some parts of the Guest
Segement registers.

v2 -> v3
	1. Patch# 1 has been enhanced to check the "unrestricted VM-execution
	   control" of the nested VMCS, along with the
	   "enabled_unrestricted_guest" global variable, in some of the code
	   paths where the VM-execution control from both vmcs01 and vmcs02
	   needs to be considered.
	2. Patch# 3 is new. It adds a test for VMENTRY of an unrestricted guest
	   in unpaged protected mode.


[PATCH 1/3 v3] KVM: nVMX: KVM needs to unset "unrestricted guest"
[PATCH 2/3 v3] nVMX: Test Selector and Base Address fields of Guest Segment
[PATCH 3/3 v3] nVMX: Test vmentry of unrestricted (unpaged protected) nested

 arch/x86/kvm/vmx/nested.c |  3 +++
 arch/x86/kvm/vmx/vmx.c    | 17 +++++++++--------
 arch/x86/kvm/vmx/vmx.h    |  7 +++++++
 3 files changed, 19 insertions(+), 8 deletions(-)

Krish Sadhukhan (1):
      KVM: nVMX: KVM needs to unset "unrestricted guest" VM-execution control in vmcs02 if vmcs12 doesn't set it

 lib/x86/processor.h |   1 +
 x86/vmx_tests.c     | 200 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 201 insertions(+)

Krish Sadhukhan (1):
      nVMX: Test Selector and Base Address fields of Guest Segment Registers on vmentry of nested guests

 x86/vmx.c       |  2 +-
 x86/vmx.h       |  1 +
 x86/vmx_tests.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+), 1 deletion(-)

Krish Sadhukhan (1):
      nVMX: Test vmentry of unrestricted (unpaged protected) nested guest


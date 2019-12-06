Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4716E1159C4
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 00:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbfLFXtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 18:49:45 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56388 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfLFXto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 18:49:44 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB6NnOSS086156;
        Fri, 6 Dec 2019 23:49:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2019-08-05; bh=HrLa3JPmgI2BD/hl4QaZTaLG5zt/BshNOgciRsgr0H4=;
 b=kTM74hym35JkhD0z0znd0F+Qu0GKCpg7iS4+Fu7ZCKgaT7B3xlIrKTelY5k5fTzUPrhc
 OO7l+oivPOvLwmxiwpLIW0mfyXNu5vBmP3LVzJWJN4OmQK56VosANbZiMXovtanIiZkD
 IkPP2g1Hd8BlSCbOeNLGA6bUNsLzGsBjLINu2eslDc9JOCzXT6Xd9MyJ0Y8PT3b4kMT/
 7bkXT5xK8hGzZPLoquAaN1vF0s1oc3okQXc0l5OPmvHuW/uhCUpWF2rdCQUkmotnQrf0
 zmMp/JCRFuK69DJkepiWp688Hitv4vlcqhWDGBG7ePWmjdADQxV5NKDfwLZ2mpWWPe2g 3A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wkfuuy24e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Dec 2019 23:49:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB6NnNln146341;
        Fri, 6 Dec 2019 23:49:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2wqerb8kan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Dec 2019 23:49:39 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB6NnbWo004106;
        Fri, 6 Dec 2019 23:49:37 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 06 Dec 2019 15:49:37 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 0/4] KVM: nVMX: Check GUEST_SYSENTER_ESP and GUEST_SYSENTER_EIP on vmentry of nested guests
Date:   Fri,  6 Dec 2019 18:12:58 -0500
Message-Id: <20191206231302.3466-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9463 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=672
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912060190
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9463 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=737 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912060190
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Checks on Guest Control Registers, Debug Registers, and
and MSRs" in Intel SDM vol 3C, the following checks are performed on vmentry
of nested guests:

    "The IA32_SYSENTER_ESP field and the IA32_SYSENTER_EIP field must each
     contain a canonical address."

Patch# 1: Adds the required KVM checks.
Patch# 2: Modifies an existing kvm-unit-test function to suit the new test
	  being added as part of this KVM check.
Patch# 3: Removes a redundant function from the test suite.
Patch# 4: Adds a kvm-unit-test to validate this new KVM check.


[PATCH 1/4] KVM: nVMX: Check GUEST_SYSENTER_ESP and GUEST_SYSENTER_EIP on
[PATCH 2/4] kvm-unit-test: nVMX: Modify test_canonical() to process guest fields
[PATCH 3/4] kvm-unit-test: nVMX: Remove test_sysenter_field() and use
[PATCH 4/4] kvm-unit-test: nVMX: Test GUEST_SYSENTER_ESP and GUEST_SYSENTER_EIP on

 arch/x86/kvm/vmx/nested.c | 4 ++++
 1 file changed, 4 insertions(+)

Krish Sadhukhan (1):
      nVMX: Check GUEST_SYSENTER_ESP and GUEST_SYSENTER_EIP on vmentry of nested guests

 x86/vmx_tests.c | 85 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 46 insertions(+), 39 deletions(-)

Krish Sadhukhan (3):
      nVMX: Modify test_canonical() to process guest fields also
      nVMX: Remove test_sysenter_field() and use test_canonical() instead
      nVMX: Test GUEST_SYSENTER_ESP and GUEST_SYSENTER_EIP on vmentry of nested guests


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113761CBC14
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 03:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgEIBR3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 21:17:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51028 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728165AbgEIBR1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 21:17:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0491DJLB178991;
        Sat, 9 May 2020 01:17:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=iwocHYqZ4bnDXJUcJGr0L71fFplDLTZ+2sRGP6AzNOU=;
 b=BDcanLEe7QXuF4bnzqZ2N2epQJc3hkvQVHOIWcGFKvowX2A6Reds1N9AedHaIpnRuSZJ
 YUrQyitKc9gAwqRqHW1wrm/XAEWmFcg9ic+8J1DXeCoBrbdNWEnNrXVBWR+/cxeDV+S9
 OeucVtQ+qucbi2LLruDJ/KGyHH27ZpXN0pqKe93+GAXsuT+Ai9vtCwP20lgD72oGNzYA
 SDdKH0nWx9ED2sfhJulCXjTGvpH7OrThwurI8SAq4bhQaIp28yTMsnKpo53ngFS6SZE/
 gvLKu30RyAbx6KzkAIqAK6a1zte4q9zOzOhOPV9Yra6yiBZD9xvBHxEPzXmdb39ZNZGA lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30vtepnw2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 01:17:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04917cdA048468;
        Sat, 9 May 2020 01:17:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30vte1p7su-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 May 2020 01:17:22 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0491HMak016042;
        Sat, 9 May 2020 01:17:22 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 May 2020 18:17:22 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 0/3 v2] KVM: nSVM: Check MBZ bits in CR3 and CR4 on vmrun of nested guests
Date:   Fri,  8 May 2020 20:36:49 -0400
Message-Id: <20200509003652.25178-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9615 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=539 phishscore=0
 bulkscore=0 malwarescore=0 suspectscore=1 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9615 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 impostorscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 suspectscore=1 mlxscore=0
 mlxlogscore=594 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005090008
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1 -> v2:
	1. Removed the formation of the mask for guest CR4 bits, from
	   kvm_valid_cr4() to kvm_update_cpuid(). The mask is stashed
	   in a global variable called '__guest_cr4_reserved_bits'.
	   Patch# 1 contains these changes.
	2. nested_vmcb_checks() now uses is_long_mode(), instead of the
	   guest EFER, to check for Long Mode. Patch# 2 contains these
	   changes.
	3. Patch# 3 contains the kvm-unit-tests. No changes have been
	   made to the tests.


[PATCH 1/3 v2] KVM: x86: Create mask for guest CR4 reserved bits in
[PATCH 2/3 v2] KVM: nSVM: Check that MBZ bits in CR3 and CR4 are not set on
[PATCH 3/3 v2] KVM: nSVM: Test that MBZ bits in CR3 and CR4 are not set on vmrun

 arch/x86/kvm/cpuid.c      |  3 +++
 arch/x86/kvm/svm/nested.c | 22 ++++++++++++++++++++--
 arch/x86/kvm/svm/svm.h    |  5 ++++-
 arch/x86/kvm/x86.c        | 27 ++++-----------------------
 arch/x86/kvm/x86.h        | 21 +++++++++++++++++++++
 5 files changed, 52 insertions(+), 26 deletions(-)

Krish Sadhukhan (2):
      KVM: x86: Create mask for guest CR4 reserved bits in kvm_update_cpuid()
      nSVM: Check that MBZ bits in CR3 and CR4 are not set on vmrun of nested gu

 x86/svm.h       |   6 ++++
 x86/svm_tests.c | 105 +++++++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 99 insertions(+), 12 deletions(-)

Krish Sadhukhan (1):
      nSVM: Test that MBZ bits in CR3 and CR4 are not set on vmrun of nested gue


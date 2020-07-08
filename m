Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF890217C51
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 02:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgGHAkK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 20:40:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36776 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728001AbgGHAkJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 20:40:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0680WW94010604;
        Wed, 8 Jul 2020 00:40:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=98ZX2b7/Gzn1/H/GjRS7fzXCrqacNcK6JSXj56dzCJ4=;
 b=NI03Rp1qdos3raEmZF2lkH9h2QsMc7Ta1WkIClmxDP9jy5s1m0TTBcmGP1DC8yUzrUT5
 BQc0dJ52+9ecMUv2aZMQ8vEBegNiZGblpeRxusbw5QGQ2v6Q4V+afrj76t1RjL+oM/kd
 aOxwdn7a2bNACA/Z8pVOqh7iGIgEnFGuMwaGO7oWzgGog6Tht04ve8on+Luk5ChBE3mb
 wtvEK4e+7huCKW8vb4atqezuwCYYzqEZyLPUYFtBUmofw/PIzG/QTuO7NHv3DFxXBhQE
 GD6T+hmg0goGVkPNubNMaqgCY+73SxsdgjlvN1goE0kdi47D0A+KCA9ZGVgPMr4GlfeB RQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 323sxxuuqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 08 Jul 2020 00:40:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0680XF74100897;
        Wed, 8 Jul 2020 00:40:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3233bq0nup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jul 2020 00:40:06 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0680e5mr007323;
        Wed, 8 Jul 2020 00:40:05 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.231.196)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jul 2020 17:40:05 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 0/3 v4] KVM: nSVM: Check MBZ bits in CR3 and CR4 on vmrun of nested guests
Date:   Wed,  8 Jul 2020 00:39:54 +0000
Message-Id: <1594168797-29444-1-git-send-email-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=947 bulkscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007080000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=947
 bulkscore=0 impostorscore=0 adultscore=0 cotscore=-2147483648 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 suspectscore=1 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080000
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v3 -> v4:
	1. In patch# 1, 'guest_cr4_reserved_bits' has been renamed to
	   'cr4_guest_rsvd_bits' and it's now located where other CR4-related
	   members are.
	2. Rebased to the latest Upstream sources.


[PATCH 1/3 v4] KVM: x86: Create mask for guest CR4 reserved bits in
[PATCH 2/3 v4] KVM: nSVM: Check that MBZ bits in CR3 and CR4 are not set on
[PATCH 3/3 v4] kvm-unit-tests: nSVM: Test that MBZ bits in CR3 and CR4 are

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            |  2 ++
 arch/x86/kvm/svm/nested.c       | 22 ++++++++++++++++++++--
 arch/x86/kvm/svm/svm.h          |  5 ++++-
 arch/x86/kvm/x86.c              | 27 ++++-----------------------
 arch/x86/kvm/x86.h              | 21 +++++++++++++++++++++
 6 files changed, 52 insertions(+), 26 deletions(-)

Krish Sadhukhan (2):
      KVM: x86: Create mask for guest CR4 reserved bits in kvm_update_cpuid()
      nSVM: Check that MBZ bits in CR3 and CR4 are not set on vmrun of nested gu

 x86/svm.h       |  5 +++
 x86/svm_tests.c | 94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 95 insertions(+), 4 deletions(-)

Krish Sadhukhan (1):
      kvm-unit-tests: nSVM: Test that MBZ bits in CR3 and CR4 are not set on vmr

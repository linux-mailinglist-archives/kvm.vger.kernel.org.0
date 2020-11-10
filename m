Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB792ACA61
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 02:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731645AbgKJBXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 20:23:50 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:37818 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731581AbgKJBXr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 20:23:47 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AA1KDRY138928;
        Tue, 10 Nov 2020 01:23:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=u3ugKtb/hD7qDBm+r+haai4+xBCusqnBiUb7VIooum0=;
 b=D5Tpu6M2VphEkHQWxNQ3HNfTL8BvPmGYCy//QKq4MwiSK7NAyG7wHbPHaw+RbtZi02aW
 d2XxgkkPMDIJpdT4PBE8LtQu0pqoNtAgvvhHGIeKPUJhrz4sgQb8STJGCISGl3xNsi28
 /eehGagtlPhzOwx+PDRqmcbOaIqMNq0YSCgciBX/OuGUPMoo7ivzjTK49Gtr8gdSu9Yw
 07TaHpOcuKWD32hbQOCBFy7qgbl4TgQyuWIFM3y3f1EoiQnenXY2uhI0BOkT1GPgEHtT
 +5eLJVYKQaZ1Hk2AxZQWbBSmWtmgDOjMbUvh2fNekT93WpBaIgBZT7MAk4VIoyHG7TYL Kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34nh3asa70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 10 Nov 2020 01:23:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AA1K5A8023810;
        Tue, 10 Nov 2020 01:23:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34p5gw4a00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Nov 2020 01:23:32 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AA1NVpG005460;
        Tue, 10 Nov 2020 01:23:31 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Nov 2020 17:23:31 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, qemu-devel@nongnu.org
Subject: [PATCH 0/5 v4] KVM: x86: Fill in conforming {vmx|svm}_x86_ops and {vmx|svm}_nested_ops via macros
Date:   Tue, 10 Nov 2020 01:23:07 +0000
Message-Id: <20201110012312.20820-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=621 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1011 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=1
 mlxlogscore=635 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100008
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v3 -> v4:
	1. v3 did not include a few x86_ops and x86_nested_ops in the macro
	   expansion process of function names. This set has covered all those
	   left-out ops.
	2. Patch# 6 from v3 has been dropped as those changes already exist in
	   QEMU source.


[PATCH 1/5 v4] KVM: x86: Change names of some of the kvm_x86_ops
[PATCH 2/5 v4] KVM: SVM: Fill in conforming svm_x86_ops via macro
[PATCH 3/5 v4] KVM: nSVM: Fill in conforming svm_nested_ops via macro
[PATCH 4/5 v4] KVM: VMX: Fill in conforming vmx_x86_ops via macro
[PATCH 5/5 v4] KVM: nVMX: Fill in conforming vmx_nested_ops via macro

 arch/arm64/include/asm/kvm_host.h   |   2 +-
 arch/mips/include/asm/kvm_host.h    |   2 +-
 arch/powerpc/include/asm/kvm_host.h |   2 +-
 arch/s390/kvm/kvm-s390.c            |   2 +-
 arch/x86/include/asm/kvm_host.h     |  16 +-
 arch/x86/kvm/lapic.c                |   2 +-
 arch/x86/kvm/pmu.h                  |   4 +-
 arch/x86/kvm/svm/avic.c             |  11 +-
 arch/x86/kvm/svm/nested.c           |  20 +--
 arch/x86/kvm/svm/pmu.c              |   2 +-
 arch/x86/kvm/svm/sev.c              |   4 +-
 arch/x86/kvm/svm/svm.c              | 296 ++++++++++++++++++++----------------
 arch/x86/kvm/svm/svm.h              |  15 +-
 arch/x86/kvm/vmx/evmcs.c            |   6 +-
 arch/x86/kvm/vmx/evmcs.h            |   4 +-
 arch/x86/kvm/vmx/nested.c           |  39 +++--
 arch/x86/kvm/vmx/pmu_intel.c        |   2 +-
 arch/x86/kvm/vmx/posted_intr.c      |   6 +-
 arch/x86/kvm/vmx/posted_intr.h      |   4 +-
 arch/x86/kvm/vmx/vmx.c              | 262 +++++++++++++++----------------
 arch/x86/kvm/vmx/vmx.h              |   4 +-
 arch/x86/kvm/x86.c                  |  41 ++---
 include/linux/kvm_host.h            |   2 +-
 include/uapi/linux/kvm.h            |   6 +-
 tools/include/uapi/linux/kvm.h      |   6 +-
 virt/kvm/kvm_main.c                 |   4 +-
 26 files changed, 405 insertions(+), 359 deletions(-)

Krish Sadhukhan (5):
      KVM: x86: Change names of some of the kvm_x86_ops functions to make them more semantical and readable
      KVM: SVM: Fill in conforming svm_x86_ops via macro
      KVM: nSVM: Fill in conforming svm_nested_ops via macro
      KVM: VMX: Fill in conforming vmx_x86_ops via macro
      KVM: nVMX: Fill in conforming vmx_nested_ops via macro


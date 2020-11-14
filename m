Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C91442B2AA2
	for <lists+kvm@lfdr.de>; Sat, 14 Nov 2020 02:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgKNBuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 20:50:21 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44188 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgKNBuV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Nov 2020 20:50:21 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE1nnO1026863;
        Sat, 14 Nov 2020 01:50:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=6u7M5Az8dVGEjYUn2FVN9lV7QwjZnn7Aiuirfc+skio=;
 b=KP9Dvbd2TAZl79xjJ1bmQRhsMXdQnF4/10ccE6UDTvyBANXdtPIx3lD4SvSh+mMExbIs
 PqoJAR7ZRfo/v6IZcLNjLqXkrb6ouTgxOulTstUFQTz9XQkyZx6JEN/hqDHeQ+nNyHGx
 ls+WGHAW+0BAMTDWM2vUEn9V21KrrvrOtej9uaYDmqcRLUzSIdaE+RCB8Ws7BrKLhegH
 13UyuGJFSdcgVFW8ID14APeWRn+l3NfgqKXdZUmqice/FzwpY79FRpgVofWGOehSpeMj
 Z4HRix+Zw/Gm1A1r+i8XhdlL9EXz18HqmTrfwzZp1q6rTWu51O5CBT9bkd/Pm+9C+fSU JA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 34p72f31cp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 14 Nov 2020 01:50:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE1kK0l142852;
        Sat, 14 Nov 2020 01:50:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 34t4bsbp88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Nov 2020 01:50:06 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AE1o4tJ022709;
        Sat, 14 Nov 2020 01:50:04 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Nov 2020 17:50:03 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, qemu-devel@nongnu.org
Subject: [PATCH 0/5 v5] KVM: x86: Fill in conforming {vmx|svm}_x86_ops and {vmx|svm}_nested_ops via macros
Date:   Sat, 14 Nov 2020 01:49:50 +0000
Message-Id: <20201114014955.19749-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 mlxlogscore=766 spamscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011140009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=780 mlxscore=0
 malwarescore=0 suspectscore=1 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011140009
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v4 -> v5:
	1. The op 'prepare_guest_switch' has been renamed to
	   'prepare_switch_to_guest'.
	2. The following functions were missing the 'static' keyword (reported
	   by kernel test robot <lkp@intel.com>):
		
		svm_get_cs_db_l_bits
		svm_tlb_flush_all
		svm_tlb_flush_current
		svm_tlb_flush_guest


[PATCH 1/5 v5] KVM: x86: Change names of some of the kvm_x86_ops
[PATCH 2/5 v5] KVM: SVM: Fill in conforming svm_x86_ops via macro
[PATCH 3/5 v5] KVM: nSVM: Fill in conforming svm_nested_ops via macro
[PATCH 4/5 v5] KVM: VMX: Fill in conforming vmx_x86_ops via macro
[PATCH 5/5 v5] KVM: nVMX: Fill in conforming vmx_nested_ops via macro

 arch/arm64/include/asm/kvm_host.h   |   2 +-
 arch/mips/include/asm/kvm_host.h    |   2 +-
 arch/powerpc/include/asm/kvm_host.h |   2 +-
 arch/s390/kvm/kvm-s390.c            |   2 +-
 arch/x86/include/asm/kvm_host.h     |  18 +--
 arch/x86/kvm/lapic.c                |   2 +-
 arch/x86/kvm/pmu.h                  |   4 +-
 arch/x86/kvm/svm/avic.c             |  11 +-
 arch/x86/kvm/svm/nested.c           |  20 +--
 arch/x86/kvm/svm/pmu.c              |   2 +-
 arch/x86/kvm/svm/sev.c              |   4 +-
 arch/x86/kvm/svm/svm.c              | 298 ++++++++++++++++++++----------------
 arch/x86/kvm/svm/svm.h              |  15 +-
 arch/x86/kvm/vmx/evmcs.c            |   6 +-
 arch/x86/kvm/vmx/evmcs.h            |   4 +-
 arch/x86/kvm/vmx/nested.c           |  37 +++--
 arch/x86/kvm/vmx/pmu_intel.c        |   2 +-
 arch/x86/kvm/vmx/posted_intr.c      |   6 +-
 arch/x86/kvm/vmx/posted_intr.h      |   4 +-
 arch/x86/kvm/vmx/vmx.c              | 260 +++++++++++++++----------------
 arch/x86/kvm/vmx/vmx.h              |   2 +-
 arch/x86/kvm/x86.c                  |  43 ++----
 include/linux/kvm_host.h            |   2 +-
 include/uapi/linux/kvm.h            |   6 +-
 tools/include/uapi/linux/kvm.h      |   6 +-
 virt/kvm/kvm_main.c                 |   4 +-
 26 files changed, 405 insertions(+), 359 deletions(-)

Krish Sadhukhan (5):
      KVM: x86: Change names of some of the kvm_x86_ops functions to make them m
ore semantical and readable
      KVM: SVM: Fill in conforming svm_x86_ops via macro
      KVM: nSVM: Fill in conforming svm_nested_ops via macro
      KVM: VMX: Fill in conforming vmx_x86_ops via macro
      KVM: nVMX: Fill in conforming vmx_nested_ops via macro


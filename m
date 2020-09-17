Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607CF26E756
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 23:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgIQVX5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 17:23:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35920 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgIQVX4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 17:23:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HLExBO142522;
        Thu, 17 Sep 2020 21:22:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=t+VWV71FF9RYCPYbM3EXOGsdaz3UEhSiekOl2khfsVY=;
 b=QGKNvmJbNtVQYFLh6aAwH6JA+2NLEUUr4oTTdINcOSvvtVAozwuH7ZKgcFL4aZvoTlt9
 3l0DEcm2H44mlioxciQF77BCinAgyFBZPl65MFnx9BT+OZU1pjY+eolGF0HEcH8LVruu
 /OZDV7ZZkoUFCYmYRnMxaI5aThe/WhDYoUEiT3qxtnvSMdQFyeS0VLw1RNkn5FvlbnEc
 6D8XcY+CaPICmnU8IxgV4r/uUQnPGi2xVkleNlfumb1shvyzLArtQ9fyEunVh0vUNz2Q
 wyeEBVvWZJ60S2wRcN8DGt1yfgs5D+o5q/QFAqlw9atEilsBZ6MiBvrctpFJ6WXDfmPu yg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33j91dwhmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 21:22:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HLA5Y3133785;
        Thu, 17 Sep 2020 21:22:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33khpnp2hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 21:22:32 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08HLMPsW026926;
        Thu, 17 Sep 2020 21:22:25 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 21:22:25 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: [PATCH 0/3 v4] x86: AMD: Don't flush cache if hardware enforces cache coherency across encryption domains
Date:   Thu, 17 Sep 2020 21:20:35 +0000
Message-Id: <20200917212038.5090-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 mlxlogscore=655 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=1 mlxlogscore=662
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009170158
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v3 -> v4:
	1. Patch# 1 from v3 has been dropped.
	2. The CPUID feature for hardware-enforced cache coherency has been
	   renamed.

[PATCH 1/3 v4] x86: AMD: Add hardware-enforced cache coherency as a
[PATCH 2/3 v4] x86: AMD: Don't flush cache if hardware enforces cache
[PATCH 3/3 v4] KVM: SVM: Don't flush cache if hardware enforces cache

 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/scattered.c    | 1 +
 arch/x86/kvm/svm/sev.c             | 3 ++-
 arch/x86/mm/pat/set_memory.c       | 2 +-
 4 files changed, 5 insertions(+), 2 deletions(-)

Krish Sadhukhan (3):
      x86: AMD: Add hardware-enforced cache coherency as a CPUID feature
      x86: AMD: Don't flush cache if hardware enforces cache coherency across encryption domnains
      KVM: SVM: Don't flush cache if hardware enforces cache coherency across encryption domains


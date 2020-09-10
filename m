Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A9E263A40
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 04:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730394AbgIJCYv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 22:24:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34576 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730797AbgIJCWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 22:22:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08A2KrMv121139;
        Thu, 10 Sep 2020 02:22:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=js32OklEyd2b8i8qMTH9+2LrRCdizS72A7CcGfh2l2k=;
 b=kIlxF7Dc0PYsg716lm0qgqy6JtbMmtUi+u0sCvPhCf+DxQ3H0e2jkhhzmuM9n9TjT6hX
 yFJvrPUBZyQEi9D0ERH1xelZ2KXGXjM2C20CwO9iABhm3XA1t9PJzjaSQmJWyxNotIrB
 3E0erdgSAfBnCi3OPEKie+autyMDpfkVW8tlbmVFcSWFu48ho+UnO0iY1GV+6lFGihU3
 9KWeGpeMNZZ9Vn2iUgUfHniiCK7pgQGvwyxKmpK+Q0ZYSq+XpACgzCjbgY5AksEpXe12
 VyiopxlXRu9wbnoqmWgPPdTZar9ZV4D5uGjKO3jkab9ykU+3cu/CUY8NsW12/oITu+w1 zQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33c3an5513-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 02:22:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08A2L6d9023070;
        Thu, 10 Sep 2020 02:22:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33cmk88web-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Sep 2020 02:22:30 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08A2MTUc012664;
        Thu, 10 Sep 2020 02:22:29 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Sep 2020 19:22:29 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, thomas.lendacky@amd.com
Subject: [PATCH 0/3 v2] KVM: SVM: Don't flush cache of encrypted pages if hardware enforces cache coherency
Date:   Thu, 10 Sep 2020 02:22:08 +0000
Message-Id: <20200910022211.5417-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=752 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009100020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9739 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=767 suspectscore=1 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100020
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1 -> v2:
	1. Patch# 2 is the new addition. It adds the hardware-enforced cache
	   coherency as a CPUID feature.
	2. Patch# 3 (which was pach# 2 in v1) also adds the check to
	   __set_memory_enc_dec() so that cache/TLB is flushed only if
	   hardware doesn't enforce cache coherency.


[PATCH 1/3 v2] KVM: SVM: Replace numeric value for SME CPUID leaf with a
[PATCH 2/3 v2] KVM: SVM: Add hardware-enforced cache coherency as a
[PATCH 3/3 v2] KVM: SVM: Don't flush cache of encrypted pages if

 arch/x86/boot/compressed/mem_encrypt.S | 5 +++--
 arch/x86/include/asm/cpufeatures.h     | 6 ++++++
 arch/x86/kernel/cpu/amd.c              | 5 ++++-
 arch/x86/kernel/cpu/scattered.c        | 4 ++--
 arch/x86/kvm/cpuid.c                   | 2 +-
 arch/x86/kvm/svm/sev.c                 | 3 ++-
 arch/x86/kvm/svm/svm.c                 | 4 ++--
 arch/x86/mm/mem_encrypt_identity.c     | 4 ++--
 arch/x86/mm/pat/set_memory.c           | 6 ++++--
 9 files changed, 26 insertions(+), 13 deletions(-)

Krish Sadhukhan (3):
      KVM: SVM: Replace numeric value for SME CPUID leaf with a #define
      KVM: SVM: Add hardware-enforced cache coherency as a CPUID feature
      KVM: SVM: Don't flush cache of encrypted pages if hardware enforces cache 
coherenc


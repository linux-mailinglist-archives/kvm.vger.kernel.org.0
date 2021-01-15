Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3EAA2F70FA
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 04:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732519AbhAODbC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 22:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbhAODbC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 22:31:02 -0500
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C34AC061757;
        Thu, 14 Jan 2021 19:30:22 -0800 (PST)
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10F3QZTB018319;
        Fri, 15 Jan 2021 03:30:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id; s=jan2016.eng;
 bh=EsJzEXD057xgLTgHuE096X9huCN/rxWgiXs1QEyg+cQ=;
 b=lIY8zkl3ULhghHuuqjZVvAoLWXhv124Dbke+SwuEULytVwW04OReAJl5JxmVtz77K32e
 QvO7eNoos2Yei6itN/naiJtBLS8xBogNL9w+5MPM1Qwlg685xGLS1HTAnx0q8+DIlxs7
 xhcawYZIun4KJPHphdZEPsfbNfaIj9lj0xUCNftxjrnXaPA/AMXISK0Ib8J6xnjzIXIw
 7U7BizD+Xumoo2uPRXSQcU6oy7upB3M1aWV6r8KMWMBrXzjLBzRNkGKcSDHxIIBy7HxN
 feDZZUOwaSCo+WUlDn6FGLgrGU81mQSiGJHKHRidxV1tUxtCPHq9yo7MS8+53Wd1OfP+ OQ== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 35y5ep43kv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jan 2021 03:30:13 +0000
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.16.0.43/8.16.0.43) with SMTP id 10F3Pqsf007085;
        Thu, 14 Jan 2021 19:30:04 -0800
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint5.akamai.com with ESMTP id 35ybbec9rw-1;
        Thu, 14 Jan 2021 19:30:04 -0800
Received: from bos-lpjec.145bw.corp.akamai.com (bos-lpjec.145bw.corp.akamai.com [172.28.3.71])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id 9F445406AD;
        Fri, 15 Jan 2021 03:30:04 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] Use static_call for kvm_x86_ops
Date:   Thu, 14 Jan 2021 22:27:53 -0500
Message-Id: <cover.1610680941.git.jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_01:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=632 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101150015
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-15_01:2021-01-15,2021-01-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 mlxlogscore=575 mlxscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 impostorscore=0 spamscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101150015
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 184.51.33.60)
 smtp.mailfrom=jbaron@akamai.com smtp.helo=prod-mail-ppoint5
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Convert kvm_x86_ops to use static_call. Shows good performance
gains for cpuid loop micro-benchmark (results in patch 3/3).

Thanks,

-Jason


Changes from v1:
-Introduce kvm-x86-ops header with eye towards using this to define
 svm_x86_ops and vmx_x86_ops in follow on patches (Paolo, Sean)
-add new patch (1/3), that adds a vmx/svm prefix to help facilitate
 svm_x86_ops and vmx_x86_ops future conversions.
-added amd perf numbres to description of patch 3/3

Jason Baron (3):
  KVM: X86: append vmx/svm prefix to additional kvm_x86_ops functions
  KVM: x86: introduce definitions to support static calls for kvm_x86_ops
  KVM: x86: use static calls to reduce kvm_x86_ops overhead

 arch/x86/include/asm/kvm-x86-ops.h | 127 +++++++++++++++
 arch/x86/include/asm/kvm_host.h    |  21 ++-
 arch/x86/kvm/cpuid.c               |   2 +-
 arch/x86/kvm/hyperv.c              |   4 +-
 arch/x86/kvm/irq.c                 |   3 +-
 arch/x86/kvm/kvm_cache_regs.h      |  10 +-
 arch/x86/kvm/lapic.c               |  30 ++--
 arch/x86/kvm/mmu.h                 |   6 +-
 arch/x86/kvm/mmu/mmu.c             |  15 +-
 arch/x86/kvm/mmu/spte.c            |   2 +-
 arch/x86/kvm/pmu.c                 |   2 +-
 arch/x86/kvm/svm/svm.c             |  20 +--
 arch/x86/kvm/trace.h               |   4 +-
 arch/x86/kvm/vmx/nested.c          |   2 +-
 arch/x86/kvm/vmx/vmx.c             |  30 ++--
 arch/x86/kvm/vmx/vmx.h             |   2 +-
 arch/x86/kvm/x86.c                 | 307 +++++++++++++++++++------------------
 arch/x86/kvm/x86.h                 |   6 +-
 18 files changed, 369 insertions(+), 224 deletions(-)
 create mode 100644 arch/x86/include/asm/kvm-x86-ops.h

-- 
2.7.4


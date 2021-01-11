Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 846032F1C24
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 18:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389173AbhAKRU0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 12:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729496AbhAKRU0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 12:20:26 -0500
X-Greylist: delayed 1133 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 11 Jan 2021 09:19:41 PST
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15281C0617A4;
        Mon, 11 Jan 2021 09:19:40 -0800 (PST)
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.16.0.43/8.16.0.43) with SMTP id 10BGwxLv017013;
        Mon, 11 Jan 2021 17:00:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id; s=jan2016.eng;
 bh=7+uzNxtC4FyCIlNoqbVSn/Wrjh14z/hSraiASi7Xzh0=;
 b=CZ7Ngs/q3Gkqw5ZzS/0Uc8g6xQIZbJS4/ugbj1mOhBqOoabjx6A8FZBCwECGKkEiue/b
 Wxtk504NlIpBzgXVSmJsKqQ4zYkxR6XM6JJzhadSU/rQ1T1VY50JR4Nwf2s4u+ESjP9B
 G+Ekb0en6f0XfkYzJjS66yUlglhiLyjY3A7qkXPIfHKBBByUDyhe9LdfYcQm5v32LcCo
 Vl2I2RAay+NqbR3/a/eUUho5AdIzu6Bt90luziQoItz3m7ehjL1QEfYhwmXEll5okkro
 rS0j34w/+XoVtlbpsD+G5kkcC1DJk2E0Pa9Xk+PKUZrIryvbFQGEhZXDPTCW84glZeRE jQ== 
Received: from prod-mail-ppoint4 (a72-247-45-32.deploy.static.akamaitechnologies.com [72.247.45.32] (may be forged))
        by m0050096.ppops.net-00190b01. with ESMTP id 35y5sde7e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 17:00:18 +0000
Received: from pps.filterd (prod-mail-ppoint4.akamai.com [127.0.0.1])
        by prod-mail-ppoint4.akamai.com (8.16.0.43/8.16.0.43) with SMTP id 10BGn2N2017988;
        Mon, 11 Jan 2021 12:00:04 -0500
Received: from prod-mail-relay18.dfw02.corp.akamai.com ([172.27.165.172])
        by prod-mail-ppoint4.akamai.com with ESMTP id 35y8q31qwx-1;
        Mon, 11 Jan 2021 12:00:04 -0500
Received: from bos-lpjec.145bw.corp.akamai.com (unknown [172.28.3.71])
        by prod-mail-relay18.dfw02.corp.akamai.com (Postfix) with ESMTP id 15614400;
        Mon, 11 Jan 2021 17:00:04 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     pbonzini@redhat.com, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, aarcange@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Use static_call for kvm_x86_ops
Date:   Mon, 11 Jan 2021 11:57:26 -0500
Message-Id: <cover.1610379877.git.jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_28:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 spamscore=0 bulkscore=0 suspectscore=0 phishscore=0 mlxlogscore=540
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110098
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_28:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxlogscore=454 suspectscore=0 impostorscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110099
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 72.247.45.32)
 smtp.mailfrom=jbaron@akamai.com smtp.helo=prod-mail-ppoint4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Convert kvm_x86_ops to use static_call. Shows good performance
gains for cpuid loop micro-benchmark (resulsts included in patch 2).

Thanks,

-Jason

Jason Baron (2):
  KVM: x86: introduce definitions to support static calls for kvm_x86_ops
  KVM: x86: use static calls to reduce kvm_x86_ops overhead

 arch/x86/include/asm/kvm_host.h |  71 +++++++++-
 arch/x86/kvm/cpuid.c            |   2 +-
 arch/x86/kvm/hyperv.c           |   4 +-
 arch/x86/kvm/irq.c              |   2 +-
 arch/x86/kvm/kvm_cache_regs.h   |  10 +-
 arch/x86/kvm/lapic.c            |  28 ++--
 arch/x86/kvm/mmu.h              |   6 +-
 arch/x86/kvm/mmu/mmu.c          |  12 +-
 arch/x86/kvm/mmu/spte.c         |   2 +-
 arch/x86/kvm/pmu.c              |   2 +-
 arch/x86/kvm/trace.h            |   4 +-
 arch/x86/kvm/x86.c              | 299 ++++++++++++++++++++--------------------
 arch/x86/kvm/x86.h              |   6 +-
 13 files changed, 259 insertions(+), 189 deletions(-)

-- 
2.7.4


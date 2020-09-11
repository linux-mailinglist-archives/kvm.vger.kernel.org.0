Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA7B2668D9
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 21:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbgIKTdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 15:33:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51648 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgIKT3w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 15:29:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BJSbS1196406;
        Fri, 11 Sep 2020 19:28:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=UmHFa+oDemSLAXWoNZ5PjEOnBdTa5ORZkuWyFRvcKWU=;
 b=todjhhUe4nPBnZAYjmRZv3IAKQQMB/V12GIWWak2/fkf1tKfZvAta2VA0PRg14/JWNkP
 wf+jn4wxdBRr7+zh79ZmWP+H2ww6E+WghkvRmz4NuODoiFvRhrzTiq8rRysHpc6kEEb1
 F5DIfjd+i3298HmCEEADwtcsqQT1kthLaF4txzBWlx5htC4AVZhUDwneLPrzFS2qPIRd
 N59DabbiOp1RxHp+nQVV7l/DgOlfI+qAYY9/671CQfnQLdLWCGVrmdlj3I840lAiHUyl
 s2/c1Whvx8JOM23E7K8HPCT7YbUgXgAn3P85uwZd0s7/TUDuByb8hpdzhPOpFunFV/sQ Qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33c2mmg38t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 11 Sep 2020 19:28:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08BJQUEQ052944;
        Fri, 11 Sep 2020 19:26:31 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33cmm3y5b4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 19:26:31 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08BJQOCe006332;
        Fri, 11 Sep 2020 19:26:27 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 11 Sep 2020 12:26:24 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: [PATCH 0/4 v3] x86: AMD: Don't flush cache if hardware enforces cache coherency across encryption domains
Date:   Fri, 11 Sep 2020 19:25:57 +0000
Message-Id: <20200911192601.9591-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9741 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=1
 spamscore=0 mlxlogscore=682 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009110155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9741 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=694
 malwarescore=0 suspectscore=1 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110156
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In some hardware implementations, coherency between the encrypted and
unencrypted mappings of the same physical page is enforced. In such a system,
it is not required for software to flush the page from all CPU caches in the
system prior to changing the value of the C-bit for a page. This hardware-
enforced cache coherency is indicated by EAX[10] in CPUID leaf 0x8000001f.

Add this as a CPUID feature and skip flushing caches if the feature is present.

v2 -> v3:
        Patch# 2: Moves the addition of the CPUID feature from 
                  early_detect_mem_encrypt() to scattered.c.
        Patch# 3,4: These two are the split of patch# 3 from v2. Patch# 3
                 is for non[PATCH 0/4 v3] x86: AMD: Don't flush encrypted pages if hardware enforces cache coherency-SEV encryptions while patch#4 is for SEV
                 encryptions.

[PATCH 1/4 v3] x86: AMD: Replace numeric value for SME CPUID leaf with a
[PATCH 2/4 v3] x86: AMD: Add hardware-enforced cache coherency as a
[PATCH 3/4 v3] x86: AMD: Don't flush cache if hardware enforces cache
[PATCH 4/4 v3] KVM: SVM: Don't flush cache if hardware enforces cache

 arch/x86/boot/compressed/mem_encrypt.S | 5 +++--
 arch/x86/include/asm/cpufeatures.h     | 6 ++++++
 arch/x86/kernel/cpu/amd.c              | 2 +-
 arch/x86/kernel/cpu/scattered.c        | 5 +++--
 arch/x86/kvm/cpuid.c                   | 2 +-
 arch/x86/kvm/svm/sev.c                 | 3 ++-
 arch/x86/kvm/svm/svm.c                 | 4 ++--
 arch/x86/mm/mem_encrypt_identity.c     | 4 ++--
 arch/x86/mm/pat/set_memory.c           | 2 +-
 9 files changed, 21 insertions(+), 12 deletions(-)

Krish Sadhukhan (4):
      x86: AMD: Replace numeric value for SME CPUID leaf with a #define
      x86: AMD: Add hardware-enforced cache coherency as a CPUID feature
      x86: AMD: Don't flush cache if hardware enforces cache coherency across en
cryption domnains
      KVM: SVM: Don't flush cache if hardware enforces cache coherency across en
cryption domains


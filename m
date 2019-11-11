Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13247F79C1
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 18:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfKKRVk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 12:21:40 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40418 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbfKKRVk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 12:21:40 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABH94WP065097;
        Mon, 11 Nov 2019 17:20:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=LXuC9slDNCm1Z8lsjNLnLJ8l5lt0Lnee+xTW+cU1Dnk=;
 b=fdmOf2wFvwCuo/gi9Zd2Cw6PweVVD1/QqVZRzOPNgV1VKf5AXCwGTkif+CVi/It7YOvQ
 FJYy+4RKB4jTAYUoozQtYQx/Q0WMndpwgZIXZT1lmheQNLhqFC1fktFRpq5MnRHHjy7i
 sX/owKY2O5ls3Me/VX9o3YzEzn/JtBQj8SqlqZN5nWPc/vDECMcLJ22ZnzPY2R+i0148
 MNsJY+CmNmFv4ozue72gh/fMd65v+aEKQj0jGXQRzVoBVkuczh1EuRwk8Dgata6ldzN1
 usDNI3SApSe6+zxfvIHvCJe/0jIAm6yX8JvfPUkMCvryqj5EZOwiOwWzr+7FGZVdPXRw 7w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w5mvtg704-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 17:20:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABHFIrO081032;
        Mon, 11 Nov 2019 17:20:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2w66yyhmvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 17:20:34 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xABHKWuP003829;
        Mon, 11 Nov 2019 17:20:32 GMT
Received: from paddy.uk.oracle.com (/10.175.169.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 09:20:32 -0800
From:   Joao Martins <joao.m.martins@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>,
        Jag Raman <jag.raman@oracle.com>
Subject: [PATCH v2 3/3] KVM: VMX: Introduce pi_is_pir_empty() helper
Date:   Mon, 11 Nov 2019 17:20:12 +0000
Message-Id: <20191111172012.28356-4-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191111172012.28356-1-joao.m.martins@oracle.com>
References: <20191111172012.28356-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=621
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9438 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=687 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110155
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Streamline the PID.PIR check and change its call sites to use
the newly added helper.

Suggested-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 ++---
 arch/x86/kvm/vmx/vmx.h | 5 +++++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ccd06fdfbb76..74048629f0d6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1311,7 +1311,7 @@ static void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	 */
 	smp_mb__after_atomic();
 
-	if (!bitmap_empty((unsigned long *)pi_desc->pir, NR_VECTORS))
+	if (!pi_is_pir_empty(pi_desc))
 		pi_set_on(pi_desc);
 }
 
@@ -6158,8 +6158,7 @@ static bool vmx_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 
 	return pi_test_on(pi_desc) ||
-		(pi_test_sn(pi_desc) &&
-		!bitmap_empty((unsigned long *)pi_desc->pir, NR_VECTORS));
+		(pi_test_sn(pi_desc) && !pi_is_pir_empty(pi_desc));
 }
 
 static void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 1e32ab54fc2d..5a0f34b1e226 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -355,6 +355,11 @@ static inline int pi_test_and_set_pir(int vector, struct pi_desc *pi_desc)
 	return test_and_set_bit(vector, (unsigned long *)pi_desc->pir);
 }
 
+static inline bool pi_is_pir_empty(struct pi_desc *pi_desc)
+{
+	return bitmap_empty((unsigned long *)pi_desc->pir, NR_VECTORS);
+}
+
 static inline void pi_set_sn(struct pi_desc *pi_desc)
 {
 	set_bit(POSTED_INTR_SN,
-- 
2.11.0


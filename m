Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B79561442
	for <lists+kvm@lfdr.de>; Sun,  7 Jul 2019 09:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbfGGHjt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Jul 2019 03:39:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43890 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfGGHjs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Jul 2019 03:39:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x677cXIg175016;
        Sun, 7 Jul 2019 07:39:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=fRVAMtzp3zOS3FgUa85hrL6mViG9ufwtVo8zTnt+bos=;
 b=DbcYqz3P2sQ8HZeu79VKWvjvq97/oC4ZERRvKMaZ4t6SuN0UuTuKKAWafUDfFflSGSNe
 sO2GdbFsnxiYmshmgnWtRzmkaaEMyDoGIa0/PTblImf8iU4JsYTpmmofwZkgUSe75yju
 4Xzbe/MxyrLTVWW03XiTNz4KBUcvIvky6uziVx+sG1noB/lIUJvBxEzcGAdvFLXnRrZc
 2hdL9uX+oIzotOCqn8wqmTDaq/CH4x4AD1TShg8Mklkc46lB8V+qObDSjo76ofZ9wRNQ
 QsWGPgxMb0Ejv5TRcVZiMltRB6DTtzB5eJcvJQLelunlPYwpeC5skFmxuXSENX/JvXKf jQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2tjm9qa8ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jul 2019 07:39:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x677c8hM180642;
        Sun, 7 Jul 2019 07:39:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2tjhpc39s2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jul 2019 07:39:24 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x677dNpN023828;
        Sun, 7 Jul 2019 07:39:23 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jul 2019 07:39:23 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 5/5] KVM: nVMX: Skip Guest State Area vmentry checks that are necessary only if VMCS12 is dirty
Date:   Sun,  7 Jul 2019 03:11:47 -0400
Message-Id: <20190707071147.11651-6-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707071147.11651-1-krish.sadhukhan@oracle.com>
References: <20190707071147.11651-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9310 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=803
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907070104
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9310 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=850 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907070104
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  ..so that every nested vmentry is not slowed down by those checks.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b610f389a01b..095923b1d765 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2748,10 +2748,23 @@ static int nested_check_guest_non_reg_state(struct vmcs12 *vmcs12)
 	return 0;
 }
 
+static int nested_vmx_check_guest_state_full(struct kvm_vcpu *vcpu,
+					     struct vmcs12 *vmcs12,
+					     u32 *exit_qual)
+{
+	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS) &&
+	    (is_noncanonical_address(vmcs12->guest_bndcfgs & PAGE_MASK, vcpu) ||
+	     (vmcs12->guest_bndcfgs & MSR_IA32_BNDCFGS_RSVD)))
+		return -EINVAL;
+
+	return 0;
+}
+
 static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 					struct vmcs12 *vmcs12,
 					u32 *exit_qual)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	bool ia32e;
 
 	*exit_qual = ENTRY_FAIL_DEFAULT;
@@ -2788,10 +2801,9 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 	}
 
-	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS) &&
-	    (is_noncanonical_address(vmcs12->guest_bndcfgs & PAGE_MASK, vcpu) ||
-	     (vmcs12->guest_bndcfgs & MSR_IA32_BNDCFGS_RSVD)))
-		return -EINVAL;
+	if (vmx->nested.dirty_vmcs12 &&
+	    nested_vmx_check_guest_state_full(vcpu, vmcs12, exit_qual))
+			return -EINVAL;
 
 	if (nested_check_guest_non_reg_state(vmcs12))
 		return -EINVAL;
-- 
2.20.1


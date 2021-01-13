Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491212F4200
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 03:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbhAMCr1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 21:47:27 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:42942 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726724AbhAMCr1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 21:47:27 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D2isTC069864;
        Wed, 13 Jan 2021 02:46:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=BvKQ+4rje6Vv4d5nG5NeVQcTFzmuWKNZ/3wRAXhWw2M=;
 b=EzH7esSvbtvT0+QGm+ga3TzUIFbxdcUfBxXfi69LFXBuCqviu756T6D+smFmaL1etCJn
 Aww+GB3qf2FzsZLRJxYxJqjbh0bqm68K720y7ZDk5xri/jq9Sy6Blf7jRkIRkmYs5mKu
 GzhvQ0JWii7bxAKCOI55uk2M4WPVRbPVZzS1zXP0PAVx9bvIBUEnhdaq7SsPoudsqc7/
 8l8Vo3AL56tgMtzq9CcRPhop02HGKTAxvrvux0fHYqeUkxRbmYdtAuugL82AXE8Eeib2
 IlYZsGYHT7wRSTbtxF9tDX1qv/bKzJFfyKIHnPdJSix+acSt5UmZnOAk2Z+9qgAYLY7S uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 360kg1sb89-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 02:46:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D2kTdn051239;
        Wed, 13 Jan 2021 02:46:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 360kf6mnn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 02:46:42 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10D2kfEN012996;
        Wed, 13 Jan 2021 02:46:41 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 18:46:41 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 1/3] KVM: nSVM: Check addresses of MSR and IO bitmap
Date:   Wed, 13 Jan 2021 02:46:31 +0000
Message-Id: <20210113024633.8488-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210113024633.8488-1-krish.sadhukhan@oracle.com>
References: <20210113024633.8488-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130014
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Canonicalization and Consistency Checks" in APM vol 2,
the following guest state is illegal:

    "The MSR or IOIO intercept tables extend to a physical address that
     is greater than or equal to the maximum supported physical address."

Also check that these addresses are aligned on page boundary.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index cb4c6ee10029..389a8108ddb5 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -211,8 +211,11 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
+static bool nested_vmcb_check_controls(struct vcpu_svm *svm,
+				       struct vmcb_control_area *control)
 {
+	int maxphyaddr;
+
 	if ((vmcb_is_intercept(control, INTERCEPT_VMRUN)) == 0)
 		return false;
 
@@ -223,6 +226,14 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 	    !npt_enabled)
 		return false;
 
+	maxphyaddr = cpuid_maxphyaddr(&svm->vcpu);
+	if (!IS_ALIGNED(control->msrpm_base_pa, PAGE_SIZE) ||
+	    control->msrpm_base_pa >> maxphyaddr)
+		return false;
+	if (!IS_ALIGNED(control->iopm_base_pa, PAGE_SIZE) ||
+	    control->iopm_base_pa >> maxphyaddr)
+		return false;
+
 	return true;
 }
 
@@ -258,7 +269,7 @@ static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
 	if (!kvm_is_valid_cr4(&svm->vcpu, vmcb12->save.cr4))
 		return false;
 
-	return nested_vmcb_check_controls(&vmcb12->control);
+	return nested_vmcb_check_controls(svm, &vmcb12->control);
 }
 
 static void load_nested_vmcb_control(struct vcpu_svm *svm,
@@ -1173,7 +1184,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 		goto out_free;
 
 	ret = -EINVAL;
-	if (!nested_vmcb_check_controls(ctl))
+	if (!nested_vmcb_check_controls(svm, ctl))
 		goto out_free;
 
 	/*
-- 
2.27.0


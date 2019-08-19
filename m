Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B02BB95011
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 23:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728477AbfHSVrW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 17:47:22 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58248 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728435AbfHSVrW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 17:47:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7JLd2FD147087
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 21:47:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=OC50fzjxjiWsUIzRqdiyMeyCyexDpFuZeuefPP1fi4Y=;
 b=hn6XOJotxaz7wYYOMbMSRX5gU7nTKTOYsH4ju4Mig8OMoS+p5tvZFqvVFThdgJafMTJR
 wakE+NgYHdLnFLbg7CqLPqMkCngDFGiqVJuhp+yu3KYnidsMypNcdQigy1mkhqc8IQ3y
 +xrBncNPbwN+sOXAMHAeXd78pl0iVOVXuE7DFU8Oda6YJhxnasal26B2S/nW2i/jV0+w
 M9uOej1svHE/r8anddG4UT3LfrXZ0YdNogGchO1YUwP9IWT/cJsiITM9VlolwNPBh2qY
 PjlF+LO69YJEvNk+TeUmZAJMjwLBH7MfglhToubjdSBhhqVbj1PYTrvTDgaNIib1evyH KQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uea7qj4d7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 21:47:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7JLcO6V086308
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 21:47:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2uejxemsjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 21:47:20 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7JLlJGP010151
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2019 21:47:19 GMT
Received: from spark.ravello.local (/213.57.127.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 19 Aug 2019 14:47:19 -0700
From:   Nikita Leshenko <nikita.leshchenko@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Liran Alon <liran.alon@oracle.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH 2/2] KVM: nVMX: Check guest activity state on vmentry of nested guests
Date:   Tue, 20 Aug 2019 00:46:50 +0300
Message-Id: <20190819214650.41991-3-nikita.leshchenko@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190819214650.41991-1-nikita.leshchenko@oracle.com>
References: <20190819214650.41991-1-nikita.leshchenko@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908190217
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9354 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908190217
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The checks are written in the same order and structure as they appear in "SDM
26.3.1.5 - Checks on Guest Non-Register State", to ease verification.

Reviewed-by: Liran Alon <liran.alon@oracle.com>
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
---
 arch/x86/kvm/vmx/nested.c | 24 ++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmcs.h   | 13 +++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 24734946ec75..e2ee217f8ffe 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2666,10 +2666,34 @@ static int nested_vmx_check_vmcs_link_ptr(struct kvm_vcpu *vcpu,
  */
 static int nested_check_guest_non_reg_state(struct vmcs12 *vmcs12)
 {
+	/* Activity state must contain supported value */
 	if (vmcs12->guest_activity_state != GUEST_ACTIVITY_ACTIVE &&
 	    vmcs12->guest_activity_state != GUEST_ACTIVITY_HLT)
 		return -EINVAL;
 
+	/* Must not be HLT if SS DPL is not 0 */
+	if (VMX_AR_DPL(vmcs12->guest_ss_ar_bytes) != 0 &&
+	    vmcs12->guest_activity_state == GUEST_ACTIVITY_HLT)
+		return -EINVAL;
+
+	/* Must be active if blocking by MOV-SS or STI */
+	if ((vmcs12->guest_interruptibility_info &
+	    (GUEST_INTR_STATE_MOV_SS | GUEST_INTR_STATE_STI)) &&
+	    vmcs12->guest_activity_state != GUEST_ACTIVITY_ACTIVE)
+		return -EINVAL;
+
+	/* In HLT, only some interruptions are allowed */
+	if (vmcs12->vm_entry_intr_info_field & INTR_INFO_VALID_MASK &&
+	    vmcs12->guest_activity_state == GUEST_ACTIVITY_HLT) {
+		u32 intr_info = vmcs12->vm_entry_intr_info_field;
+		if (!is_ext_interrupt(intr_info) &&
+		    !is_nmi(intr_info) &&
+		    !is_debug(intr_info) &&
+		    !is_machine_check(intr_info) &&
+		    !is_mtf(intr_info))
+		    return -EINVAL;
+	}
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index cb6079f8a227..c5577c40b19d 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -102,6 +102,13 @@ static inline bool is_machine_check(u32 intr_info)
 		(INTR_TYPE_HARD_EXCEPTION | MC_VECTOR | INTR_INFO_VALID_MASK);
 }
 
+static inline bool is_mtf(u32 intr_info)
+{
+	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK |
+			     INTR_INFO_VALID_MASK)) ==
+		(INTR_TYPE_OTHER_EVENT | 0 | INTR_INFO_VALID_MASK);
+}
+
 /* Undocumented: icebp/int1 */
 static inline bool is_icebp(u32 intr_info)
 {
@@ -115,6 +122,12 @@ static inline bool is_nmi(u32 intr_info)
 		== (INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK);
 }
 
+static inline bool is_ext_interrupt(u32 intr_info)
+{
+	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VALID_MASK))
+		== (INTR_TYPE_EXT_INTR | INTR_INFO_VALID_MASK);
+}
+
 enum vmcs_field_width {
 	VMCS_FIELD_WIDTH_U16 = 0,
 	VMCS_FIELD_WIDTH_U64 = 1,
-- 
2.20.1


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFAB3F704E
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 10:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbfKKJRO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 04:17:14 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39948 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbfKKJRO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 04:17:14 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAB9EKQ0035056;
        Mon, 11 Nov 2019 09:17:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=vlYPEE4YvT8Ta4VzqQljjC/3m4BtHqGyWCZYnNL3vxM=;
 b=pMyTqQtrgxrI/OptHwcarmAQlVywVq1mIquh6n/fsCS0BxaOVDfkpgMcZdAYfJqew+ab
 p+muzH2DkWjrDgB1CB+7VVhkNDP7YyUrvqTkjOe2vQb61jhEwQtHG+f5qNw/zpTwMhWN
 TdPmFImAhtfdRY2gI2nQRQ+LNAToONxn+PyLOY85NSpIPkXP6cFBkdEWs7zE8S/engcr
 cX1i1Min+UCyQgI58RHtaow7xayzY2XEWDfm3yhtmlIWtPW0hAsGgE32tVKChTc2vtxY
 pd2L+a+3d1VF/gGKxyVfNhWxwz8IP4EIt1tSyOz0kg8tdvsc0ZlaMO+yOB8pnB1OXy2G oA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2w5p3qdny9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 09:17:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAB9Dswf174232;
        Mon, 11 Nov 2019 09:17:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w66yw7ch6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 09:17:06 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xAB9H5am013688;
        Mon, 11 Nov 2019 09:17:05 GMT
Received: from localhost.localdomain (/77.139.185.199)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 01:17:05 -0800
From:   Liran Alon <liran.alon@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Liran Alon <liran.alon@oracle.com>,
        Mihai Carabas <mihai.carabas@oracle.com>
Subject: [PATCH 1/2] KVM: x86: Evaluate latched_init in KVM_SET_VCPU_EVENTS when vCPU not in SMM
Date:   Mon, 11 Nov 2019 11:16:39 +0200
Message-Id: <20191111091640.92660-2-liran.alon@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191111091640.92660-1-liran.alon@oracle.com>
References: <20191111091640.92660-1-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=994
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110091
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110092
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 4b9852f4f389 ("KVM: x86: Fix INIT signal handling in various CPU states")
fixed KVM to also latch pending LAPIC INIT event when vCPU is in VMX
operation.

However, current API of KVM_SET_VCPU_EVENTS defines this field as
part of SMM state and only set pending LAPIC INIT event if vCPU is
specified to be in SMM mode (events->smi.smm is set).

Change KVM_SET_VCPU_EVENTS handler to set pending LAPIC INIT event
by latched_init field regardless of if vCPU is in SMM mode or not.

Fixes: 4b9852f4f389 ("KVM: x86: Fix INIT signal handling in various CPU states")
Reviewed-by: Mihai Carabas <mihai.carabas@oracle.com>
Signed-off-by: Liran Alon <liran.alon@oracle.com>
---
 arch/x86/kvm/x86.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff395f812719..f41d5d05e9f2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3792,12 +3792,13 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 				vcpu->arch.hflags |= HF_SMM_INSIDE_NMI_MASK;
 			else
 				vcpu->arch.hflags &= ~HF_SMM_INSIDE_NMI_MASK;
-			if (lapic_in_kernel(vcpu)) {
-				if (events->smi.latched_init)
-					set_bit(KVM_APIC_INIT, &vcpu->arch.apic->pending_events);
-				else
-					clear_bit(KVM_APIC_INIT, &vcpu->arch.apic->pending_events);
-			}
+		}
+
+		if (lapic_in_kernel(vcpu)) {
+			if (events->smi.latched_init)
+				set_bit(KVM_APIC_INIT, &vcpu->arch.apic->pending_events);
+			else
+				clear_bit(KVM_APIC_INIT, &vcpu->arch.apic->pending_events);
 		}
 	}
 
-- 
2.20.1


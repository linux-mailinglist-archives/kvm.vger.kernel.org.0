Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 016791B886
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730405AbfEMOj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:39:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45680 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730320AbfEMOj5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:39:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DESlCI171427;
        Mon, 13 May 2019 14:38:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=GS3GihsPyz7Y99NHOiQDTtmA0apAWQh5Zi8mHVLNyoo=;
 b=mJcTtw571vBY/DqchePtoK+a2fMaLqNsWff99ts41cz3uW81AVh8k2kIjQIXfkadX5Q3
 6F/E6e4/O6myTDqiwNYcUSpAOVMeeIBt5z6sBwlWmvIiYKdfzx0Qg4nsfGs0iR0Ee/ws
 8fyDT/ryZpc/Obi/2zRq7DJqs0810bOvF26HLCD7ir3wtStKFUFAa7Ws6PKz+Pu1UJQL
 dU9UJa5EK8+LYETRyQ5DuH2DbGMtHYVtA2jgoPUK3ziD1XjXnCkAD9TDmm7V4635R9i5
 XflzqnTQJehHeZrV5CJoVBXa8ETCmtisHC5rPPYYhukBl0cMbZnPTDNSWhzzDSLkexDm Fw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2sdnttfecf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:38:54 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQ7022780;
        Mon, 13 May 2019 14:38:50 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 04/27] KVM: x86: Switch to KVM address space on entry to guest
Date:   Mon, 13 May 2019 16:38:12 +0200
Message-Id: <1557758315-12667-5-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9255 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130102
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liran Alon <liran.alon@oracle.com>

Switch to KVM address space on entry to guest and switch
out on immediately at exit (before enabling host interrupts).

For now, this is not effectively switching, we just remain on
the kernel address space. In addition, we switch back as soon
as we exit guest, which makes KVM #VMExit handlers still run
with full host address space.

However, this introduces the entry points and places for switching.

Next commits will change switch to happen only when necessary.

Signed-off-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/isolation.c |   20 ++++++++++++++++++++
 arch/x86/kvm/isolation.h |    2 ++
 arch/x86/kvm/x86.c       |    8 ++++++++
 3 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/isolation.c b/arch/x86/kvm/isolation.c
index 74bc0cd..35aa659 100644
--- a/arch/x86/kvm/isolation.c
+++ b/arch/x86/kvm/isolation.c
@@ -119,3 +119,23 @@ void kvm_isolation_uninit(void)
 	kvm_isolation_uninit_mm();
 	pr_info("KVM: x86: End of isolated address space\n");
 }
+
+void kvm_isolation_enter(void)
+{
+	if (address_space_isolation) {
+		/*
+		 * Switches to kvm_mm should happen from vCPU thread,
+		 * which should not be a kernel thread with no mm
+		 */
+		BUG_ON(current->active_mm == NULL);
+		/* TODO: switch to kvm_mm */
+	}
+}
+
+void kvm_isolation_exit(void)
+{
+	if (address_space_isolation) {
+		/* TODO: Kick sibling hyperthread before switch to host mm */
+		/* TODO: switch back to original mm */
+	}
+}
diff --git a/arch/x86/kvm/isolation.h b/arch/x86/kvm/isolation.h
index cf8c7d4..595f62c 100644
--- a/arch/x86/kvm/isolation.h
+++ b/arch/x86/kvm/isolation.h
@@ -4,5 +4,7 @@
 
 extern int kvm_isolation_init(void);
 extern void kvm_isolation_uninit(void);
+extern void kvm_isolation_enter(void);
+extern void kvm_isolation_exit(void);
 
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4b7cec2..85700e0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7896,6 +7896,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		goto cancel_injection;
 	}
 
+	kvm_isolation_enter();
+
 	if (req_immediate_exit) {
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 		kvm_x86_ops->request_immediate_exit(vcpu);
@@ -7946,6 +7948,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.last_guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
 
+	/*
+	 * TODO: Move this to where we architectually need to access
+	 * host (or other VM) sensitive data
+	 */
+	kvm_isolation_exit();
+
 	vcpu->mode = OUTSIDE_GUEST_MODE;
 	smp_wmb();
 
-- 
1.7.1


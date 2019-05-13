Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 828531B8B2
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730310AbfEMOjp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:39:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59418 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730144AbfEMOjo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:39:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DEd2YY194903;
        Mon, 13 May 2019 14:39:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=BckiUE2qwd6ce7s4e94ZCEH08ViWVb2Uhow4MmaOmmg=;
 b=MqxRlocDO4PBVSKI4njGqiBJNQ3Dwy7bXoxOg336yVqnxDPoOo4C8bDcoA+hRinUelY/
 IfBGNpsi5hC0VByASVpiWMEgObQsMVJz2ebCqcSbAU7+bP+dXw4f4OP72FR/CyrWZMzm
 C5l9JlMKOqhD3L7yBz6qxyBISnDBFSOI418qbfcikgzUXjTPisA4nha1WqGfH00pB+fR
 MAPL3suB/BEgJ7y+NOdtYN4R08kIlmFj7UCcos/Hh23ufmYdF9aqYoILoddmclvElloo
 MtVyLdQhfuOp3oe6RJY+QcC2ZMynhm3bA4JOkdVlLXIFA7MOvRKhnhe+hFi0uBip4m9o lw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2sdq1q7aum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:39:05 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQB022780;
        Mon, 13 May 2019 14:39:02 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 08/27] KVM: x86: Optimize branches which checks if address space isolation enabled
Date:   Mon, 13 May 2019 16:38:16 +0200
Message-Id: <1557758315-12667-9-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9255 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Liran Alon <liran.alon@oracle.com>

As every entry to guest checks if should switch from host_mm to kvm_mm,
these branches is at very hot path. Optimize them by using
static_branch.

Signed-off-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/isolation.c |   11 ++++++++---
 arch/x86/kvm/isolation.h |    7 +++++++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/isolation.c b/arch/x86/kvm/isolation.c
index eeb60c4..43fd924 100644
--- a/arch/x86/kvm/isolation.c
+++ b/arch/x86/kvm/isolation.c
@@ -23,6 +23,9 @@ struct mm_struct kvm_mm = {
 	.mmlist			= LIST_HEAD_INIT(kvm_mm.mmlist),
 };
 
+DEFINE_STATIC_KEY_FALSE(kvm_isolation_enabled);
+EXPORT_SYMBOL(kvm_isolation_enabled);
+
 /*
  * When set to true, KVM #VMExit handlers run in isolated address space
  * which maps only KVM required code and per-VM information instead of
@@ -118,15 +121,17 @@ int kvm_isolation_init(void)
 
 	kvm_isolation_set_handlers();
 	pr_info("KVM: x86: Running with isolated address space\n");
+	static_branch_enable(&kvm_isolation_enabled);
 
 	return 0;
 }
 
 void kvm_isolation_uninit(void)
 {
-	if (!address_space_isolation)
+	if (!kvm_isolation())
 		return;
 
+	static_branch_disable(&kvm_isolation_enabled);
 	kvm_isolation_clear_handlers();
 	kvm_isolation_uninit_mm();
 	pr_info("KVM: x86: End of isolated address space\n");
@@ -140,7 +145,7 @@ void kvm_may_access_sensitive_data(struct kvm_vcpu *vcpu)
 
 void kvm_isolation_enter(void)
 {
-	if (address_space_isolation) {
+	if (kvm_isolation()) {
 		/*
 		 * Switches to kvm_mm should happen from vCPU thread,
 		 * which should not be a kernel thread with no mm
@@ -152,7 +157,7 @@ void kvm_isolation_enter(void)
 
 void kvm_isolation_exit(void)
 {
-	if (address_space_isolation) {
+	if (kvm_isolation()) {
 		/* TODO: Kick sibling hyperthread before switch to host mm */
 		/* TODO: switch back to original mm */
 	}
diff --git a/arch/x86/kvm/isolation.h b/arch/x86/kvm/isolation.h
index 1290d32..aa5e979 100644
--- a/arch/x86/kvm/isolation.h
+++ b/arch/x86/kvm/isolation.h
@@ -4,6 +4,13 @@
 
 #include <linux/kvm_host.h>
 
+DECLARE_STATIC_KEY_FALSE(kvm_isolation_enabled);
+
+static inline bool kvm_isolation(void)
+{
+	return static_branch_likely(&kvm_isolation_enabled);
+}
+
 extern int kvm_isolation_init(void);
 extern void kvm_isolation_uninit(void);
 extern void kvm_isolation_enter(void);
-- 
1.7.1


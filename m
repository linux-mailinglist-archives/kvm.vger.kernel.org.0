Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81E2B658F0
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbfGKO3g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:29:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39164 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbfGKO3g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:29:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEO8vQ001464;
        Thu, 11 Jul 2019 14:27:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=p0TwseF6Rl2ptej9BTwWkpZCi9Mm6El6sXWBWxSv9Wc=;
 b=VxnBJQPSh0LmxFyWqVND6G3imbrgiNDc2XYktPKhPxTH7jeK12iQ07uhiR7KSkYssaXb
 Pv64TstUQ6TZGJ1PMaSuITPpNq63mpZXM6Iv7MEPC/m1XIUd6uAVwnuCuLzWwEkJpk+d
 bLhzpPXWzEGxFhxH1pYNQvLU4rahHXqpvu4/IcVK0tDJMHq3A7NSNALQrgdnEe+A5MWw
 HjWBvSrm/StSA0wUZr133cDwxkrZIL+2nTAatg2QWIUq+pis7baTZiMjbcwkfcdkdyAy
 8SJFtfEFVLR+g5pFWeVErgqD0yalSI8+c1PK8OfF5ETzFY1qWu5XfRWDWSejjFNNjfXr 8Q== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2tjk2u0e5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:27:15 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEPcuJ021444;
        Thu, 11 Jul 2019 14:27:06 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, alexandre.chartre@oracle.com
Subject: [RFC v2 26/26] KVM: x86/asi: Map KVM memslots and IO buses into KVM ASI
Date:   Thu, 11 Jul 2019 16:25:38 +0200
Message-Id: <1562855138-19507-27-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907110162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Map KVM memslots and IO buses into KVM ASI. Mapping is checking on each
KVM ASI enter because they can change.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/x86.c       |   36 +++++++++++++++++++++++++++++++++++-
 include/linux/kvm_host.h |    2 ++
 2 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9458413..7c52827 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7748,11 +7748,45 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
 
 static void vcpu_isolation_enter(struct kvm_vcpu *vcpu)
 {
-	int err;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_io_bus *bus;
+	int i, err;
 
 	if (!vcpu->asi)
 		return;
 
+	/*
+	 * Check memslots and buses mapping as they tend to change.
+	 */
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		if (vcpu->asi_memslots[i] == kvm->memslots[i])
+			continue;
+		pr_debug("remapping kvm memslots[%d]: %px -> %px\n",
+			 i, vcpu->asi_memslots[i], kvm->memslots[i]);
+		err = asi_remap(vcpu->asi, &vcpu->asi_memslots[i],
+				kvm->memslots[i], sizeof(struct kvm_memslots));
+		if (err) {
+			pr_debug("failed to map kvm memslots[%d]: error %d\n",
+				 i, err);
+		}
+	}
+
+
+	for (i = 0; i < KVM_NR_BUSES; i++) {
+		bus = kvm->buses[i];
+		if (bus == vcpu->asi_buses[i])
+			continue;
+		pr_debug("remapped kvm buses[%d]: %px -> %px\n",
+			 i, vcpu->asi_buses[i], bus);
+		err = asi_remap(vcpu->asi, &vcpu->asi_buses[i], bus,
+				sizeof(*bus) + bus->dev_count *
+				sizeof(struct kvm_io_range));
+		if (err) {
+			pr_debug("failed to map kvm buses[%d]: error %d\n",
+				 i, err);
+		}
+	}
+
 	err = asi_enter(vcpu->asi);
 	if (err)
 		pr_debug("KVM isolation failed: error %d\n", err);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2a9d073..1f82de4 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -324,6 +324,8 @@ struct kvm_vcpu {
 
 #ifdef CONFIG_ADDRESS_SPACE_ISOLATION
 	struct asi *asi;
+	void *asi_memslots[KVM_ADDRESS_SPACE_NUM];
+	void *asi_buses[KVM_NR_BUSES];
 #endif
 };
 
-- 
1.7.1


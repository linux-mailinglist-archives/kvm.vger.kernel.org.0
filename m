Return-Path: <kvm+bounces-32421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 056029D84D3
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 12:51:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B852628B5F2
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 11:51:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 888971A0B07;
	Mon, 25 Nov 2024 11:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="D6tnLnHs"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0ECB156F5D;
	Mon, 25 Nov 2024 11:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732535448; cv=none; b=T+HC3VUC2QIyGxshWu+U6/xuBKaDXvrdbqqY4SC9MXwZVmH0XCzfv6yKffXN8AOX5636iImqCvjfA/efL+GJrBhOMyA92APmRzfJIVJdDoKPhh7nVo+GdLBJGC9uYd5nQZ5xOsYpurlyElDp5lmdIA6H2fJOItmime3MJ03J6CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732535448; c=relaxed/simple;
	bh=BQZ6jFxYHALFLkOY7QUYMfMmlSBr03TuibmXjXTU0tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DyupeeiBMKGQFSoH2ZaUYM/6B92Jy8bsr+hBWZjjn377mdNjUfB91SvoTnZqkGeDY5LD/WckvOBqc9oS9BKGeysqiPfvcF7G4PF7lKbGf9VXM6nWJVg+LHPduEa4cS2CRmzL0vSrdw7RtNdfM97EzYD6Da/ZqsaC4eBN56MRzZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=D6tnLnHs; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AP1Mntt005260;
	Mon, 25 Nov 2024 11:50:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=k3JkQNu1KsN+FiKZ9
	rSvtovvjGuzBmGeXhOyNgkANU0=; b=D6tnLnHsR/KWueS4BYTq1xPZT4rfm2kUR
	3AB2J+8dkvFWfwP3Cea0GPFTjklkbUy/TUl6hftaQHLh5TJHpOXGa64Ekh+EZh7U
	KujZ/qmyXiKyScuYNrHLNGyigsGvWygc92hb3mGZPCQtCGh8zsJf3S+gvzZVAEHx
	UMP+23akbsTFpxwGEN2bmKtfZOUnsc1nCi7vI0JCLXy7bHt3LFGkr5WXobKqn833
	Or/mIWn7qJcVV/cs0xaaEA+JPkaICl90mQ+xyuJeROOV7oas+nbPBH2yfvYxEVl3
	fpupzuCaq1xuTOYopwJruJR6jpbyObDRZMjMMVx1etqfuCBogFbIw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43386jqwrk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 11:50:44 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AP5HHq7002627;
	Mon, 25 Nov 2024 11:50:43 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 433tcmaej5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 25 Nov 2024 11:50:43 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4APBodrw20840914
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 11:50:40 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DA3BC20043;
	Mon, 25 Nov 2024 11:50:39 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B7AE82004D;
	Mon, 25 Nov 2024 11:50:39 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 25 Nov 2024 11:50:39 +0000 (GMT)
From: Heiko Carstens <hca@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] KVM: s390: Use try_cmpxchg() instead of cmpxchg() loops
Date: Mon, 25 Nov 2024 12:50:37 +0100
Message-ID: <20241125115039.1809353-2-hca@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241125115039.1809353-1-hca@linux.ibm.com>
References: <20241125115039.1809353-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kPqVggdK4f9JJEXWIx3IRJM9Hbf-9d2f
X-Proofpoint-GUID: kPqVggdK4f9JJEXWIx3IRJM9Hbf-9d2f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 mlxlogscore=722 spamscore=0 suspectscore=0 phishscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411250094

Convert all cmpxchg() loops to try_cmpxchg() loops. With gcc 14 and the
usage of flag output operands in try_cmpxchg() this allows the compiler to
generate slightly better code.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/kvm/gaccess.c   | 16 ++++++++--------
 arch/s390/kvm/interrupt.c | 12 ++++++------
 arch/s390/kvm/kvm-s390.c  |  4 ++--
 arch/s390/kvm/pci.c       |  5 ++---
 4 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index a688351f4ab5..9816b0060fbe 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -129,8 +129,8 @@ static void ipte_lock_simple(struct kvm *kvm)
 retry:
 	read_lock(&kvm->arch.sca_lock);
 	ic = kvm_s390_get_ipte_control(kvm);
+	old = READ_ONCE(*ic);
 	do {
-		old = READ_ONCE(*ic);
 		if (old.k) {
 			read_unlock(&kvm->arch.sca_lock);
 			cond_resched();
@@ -138,7 +138,7 @@ static void ipte_lock_simple(struct kvm *kvm)
 		}
 		new = old;
 		new.k = 1;
-	} while (cmpxchg(&ic->val, old.val, new.val) != old.val);
+	} while (!try_cmpxchg(&ic->val, &old.val, new.val));
 	read_unlock(&kvm->arch.sca_lock);
 out:
 	mutex_unlock(&kvm->arch.ipte_mutex);
@@ -154,11 +154,11 @@ static void ipte_unlock_simple(struct kvm *kvm)
 		goto out;
 	read_lock(&kvm->arch.sca_lock);
 	ic = kvm_s390_get_ipte_control(kvm);
+	old = READ_ONCE(*ic);
 	do {
-		old = READ_ONCE(*ic);
 		new = old;
 		new.k = 0;
-	} while (cmpxchg(&ic->val, old.val, new.val) != old.val);
+	} while (!try_cmpxchg(&ic->val, &old.val, new.val));
 	read_unlock(&kvm->arch.sca_lock);
 	wake_up(&kvm->arch.ipte_wq);
 out:
@@ -172,8 +172,8 @@ static void ipte_lock_siif(struct kvm *kvm)
 retry:
 	read_lock(&kvm->arch.sca_lock);
 	ic = kvm_s390_get_ipte_control(kvm);
+	old = READ_ONCE(*ic);
 	do {
-		old = READ_ONCE(*ic);
 		if (old.kg) {
 			read_unlock(&kvm->arch.sca_lock);
 			cond_resched();
@@ -182,7 +182,7 @@ static void ipte_lock_siif(struct kvm *kvm)
 		new = old;
 		new.k = 1;
 		new.kh++;
-	} while (cmpxchg(&ic->val, old.val, new.val) != old.val);
+	} while (!try_cmpxchg(&ic->val, &old.val, new.val));
 	read_unlock(&kvm->arch.sca_lock);
 }
 
@@ -192,13 +192,13 @@ static void ipte_unlock_siif(struct kvm *kvm)
 
 	read_lock(&kvm->arch.sca_lock);
 	ic = kvm_s390_get_ipte_control(kvm);
+	old = READ_ONCE(*ic);
 	do {
-		old = READ_ONCE(*ic);
 		new = old;
 		new.kh--;
 		if (!new.kh)
 			new.k = 0;
-	} while (cmpxchg(&ic->val, old.val, new.val) != old.val);
+	} while (!try_cmpxchg(&ic->val, &old.val, new.val));
 	read_unlock(&kvm->arch.sca_lock);
 	if (!new.kh)
 		wake_up(&kvm->arch.ipte_wq);
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 4f0e7f61edf7..eff69018cbeb 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -247,12 +247,12 @@ static inline int gisa_set_iam(struct kvm_s390_gisa *gisa, u8 iam)
 {
 	u64 word, _word;
 
+	word = READ_ONCE(gisa->u64.word[0]);
 	do {
-		word = READ_ONCE(gisa->u64.word[0]);
 		if ((u64)gisa != word >> 32)
 			return -EBUSY;
 		_word = (word & ~0xffUL) | iam;
-	} while (cmpxchg(&gisa->u64.word[0], word, _word) != word);
+	} while (!try_cmpxchg(&gisa->u64.word[0], &word, _word));
 
 	return 0;
 }
@@ -270,10 +270,10 @@ static inline void gisa_clear_ipm(struct kvm_s390_gisa *gisa)
 {
 	u64 word, _word;
 
+	word = READ_ONCE(gisa->u64.word[0]);
 	do {
-		word = READ_ONCE(gisa->u64.word[0]);
 		_word = word & ~(0xffUL << 24);
-	} while (cmpxchg(&gisa->u64.word[0], word, _word) != word);
+	} while (!try_cmpxchg(&gisa->u64.word[0], &word, _word));
 }
 
 /**
@@ -291,14 +291,14 @@ static inline u8 gisa_get_ipm_or_restore_iam(struct kvm_s390_gisa_interrupt *gi)
 	u8 pending_mask, alert_mask;
 	u64 word, _word;
 
+	word = READ_ONCE(gi->origin->u64.word[0]);
 	do {
-		word = READ_ONCE(gi->origin->u64.word[0]);
 		alert_mask = READ_ONCE(gi->alert.mask);
 		pending_mask = (u8)(word >> 24) & alert_mask;
 		if (pending_mask)
 			return pending_mask;
 		_word = (word & ~0xffUL) | alert_mask;
-	} while (cmpxchg(&gi->origin->u64.word[0], word, _word) != word);
+	} while (!try_cmpxchg(&gi->origin->u64.word[0], &word, _word));
 
 	return 0;
 }
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 442d4a227c0e..d8080c27d45b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1937,11 +1937,11 @@ static void kvm_s390_update_topology_change_report(struct kvm *kvm, bool val)
 
 	read_lock(&kvm->arch.sca_lock);
 	sca = kvm->arch.sca;
+	old = READ_ONCE(sca->utility);
 	do {
-		old = READ_ONCE(sca->utility);
 		new = old;
 		new.mtcr = val;
-	} while (cmpxchg(&sca->utility.val, old.val, new.val) != old.val);
+	} while (!try_cmpxchg(&sca->utility.val, &old.val, new.val));
 	read_unlock(&kvm->arch.sca_lock);
 }
 
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index a61518b549f0..9b9e7fdd5380 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -208,13 +208,12 @@ static inline int account_mem(unsigned long nr_pages)
 
 	page_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 
+	cur_pages = atomic_long_read(&user->locked_vm);
 	do {
-		cur_pages = atomic_long_read(&user->locked_vm);
 		new_pages = cur_pages + nr_pages;
 		if (new_pages > page_limit)
 			return -ENOMEM;
-	} while (atomic_long_cmpxchg(&user->locked_vm, cur_pages,
-					new_pages) != cur_pages);
+	} while (!atomic_long_try_cmpxchg(&user->locked_vm, &cur_pages, new_pages));
 
 	atomic64_add(nr_pages, &current->mm->pinned_vm);
 
-- 
2.45.2



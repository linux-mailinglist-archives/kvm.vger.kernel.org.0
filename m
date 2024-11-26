Return-Path: <kvm+bounces-32515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14D119D9582
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 11:26:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2C401676CE
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 10:25:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C36281CEAD8;
	Tue, 26 Nov 2024 10:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IvpejsNq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD941BCA07;
	Tue, 26 Nov 2024 10:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732616726; cv=none; b=fcqBVFxIlKfFnmgtCUo5FUTWBnomDc14aX+BrnzFrZKqBs6lxzmNvG+ItsSA9lbk30TNY/GTKz1iyTfx+Vtw6EhXt51ntlUeQoH5yt5DZ1oPp/o1/pIa7aaUHxxhyujpiDWyWiPYFPium/qw4BctLKX5p2OMOTKhqlTHAldKe38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732616726; c=relaxed/simple;
	bh=p7YikioJQOthVp6KPQFYJhq2pY0lPHz9yV2cJtGxnk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AgYMrq40bQ/YL14FDZjDrpfbM2rh78tKlLJFbzYuHnlWrax4gRgZ+kjhyPimY9yKdT96tdbpTkr8tnd7HWxT1MiulBiYnX83robujWFZOK7KENnqPOVuO71E0bXK/p9N3m66A5180JLGjxqBzuynfBkSE1wptnJp3BMrflm0wWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IvpejsNq; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AQ7Dx9R013702;
	Tue, 26 Nov 2024 10:25:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ZV4tiiOpPkAdRf2Td
	JSMDUd+f5ReH42FtNfEnQmPzZA=; b=IvpejsNqESuF8OSwHAyXMqiGaqBuNmMkF
	du7FbW0qjK+QP6Sd59dqv9nvz/XJAK+44WGPH9dPJNEnFGCUP7ZMKGBF9VwQOSu+
	DjOOoOLnrOJvtao+bu/EHKA+agPlzeSizzAd94KpAEmSQRSzuMxGt5HB5aMFbwGc
	sWae8TR2TnLsAHectSXoM7BcNZgxNEIZspHB+UEUmfIgg0+lC9odKBJ8I5/YXUf9
	uSYsQyefF9VC7xP/HQ3ok+6WlzZWIxbxEwt2Hm2J85QBL8BYlKKZkCgf+rzgddVE
	owurfgZqI/WVnNEv0Igu5N1P4xWu2Tc8PqUZtv8rMyBfbi3BCgW9g==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43386ndc1t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 10:25:21 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AQABJ0x000866;
	Tue, 26 Nov 2024 10:25:20 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 433sry9kq4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 10:25:20 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AQAPGa927198004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Nov 2024 10:25:16 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E71820072;
	Tue, 26 Nov 2024 10:25:16 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4AE6120078;
	Tue, 26 Nov 2024 10:25:16 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 26 Nov 2024 10:25:16 +0000 (GMT)
From: Heiko Carstens <hca@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] KVM: s390: Use try_cmpxchg() instead of cmpxchg() loops
Date: Tue, 26 Nov 2024 11:25:13 +0100
Message-ID: <20241126102515.3178914-2-hca@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241126102515.3178914-1-hca@linux.ibm.com>
References: <20241126102515.3178914-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 31W-JFQRLHTgiavhIj6pgwBbbkOqEoAK
X-Proofpoint-ORIG-GUID: 31W-JFQRLHTgiavhIj6pgwBbbkOqEoAK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=781 suspectscore=0 impostorscore=0 malwarescore=0 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2411260079

Convert all cmpxchg() loops to try_cmpxchg() loops. With gcc 14 and the
usage of flag output operands in try_cmpxchg() this allows the compiler to
generate slightly better code.

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
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



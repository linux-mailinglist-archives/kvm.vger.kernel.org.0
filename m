Return-Path: <kvm+bounces-62536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 786B3C4849E
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:23:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 129D74F6A56
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 17:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8A182798EA;
	Mon, 10 Nov 2025 17:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GFc5gWgG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3AE29ACF7;
	Mon, 10 Nov 2025 17:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762795069; cv=none; b=AZcTCj07PsolQwJoUdUP7YNBDyX75/bLAeP/hxMJYIVU8aFntlxlmmno6BBbMvK6U0NEVfmY2/UbGMftFBl5TFm5e3vGNnuEWYZZ3Xk4JL3bykYJJMOMlkljF62U8pY9GVFBolho6rS6e8slxoSH4cEV36qsfRrCIlRXkwNMYRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762795069; c=relaxed/simple;
	bh=tYPFe1cF0s8OoLV4EZM1YANW3GNB/NgDla4Qqonkces=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JEujQ7BtjABnTaHCbqQ3Az2UxxfSNHoXwQbGvhiyhD6WtXHIeWrt29CNd8mKvSyYdNnE6f++ccZQSW8btq/8ldQJ4nw/4ByeJgS2RbSaXO3htdNGe3T8zuXwckpyaDEOm1+pPGTH7kqYBKdmHf3mx0dz6yaIlB9G6VcqDYRIt+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GFc5gWgG; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AADa9Zo031615;
	Mon, 10 Nov 2025 17:17:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=C21nHx
	c9wEQGGvhn1IYKmX/7DpqgHsyXKFrPQZr08Bc=; b=GFc5gWgGXTjCa+TiGzpfwB
	1GBtHAroLWWdljLJxo+i0mFvEOLHFltUJtj+1QbVjBmKeBhWsWA4YR1T8fkd54U/
	zmtH6He8zwQ+95aZQQU56QL3kUjYRc0VC40VwhfDhWpuwdMReuWfJOY2fOIue+NJ
	cHMpdxbapGEH7ZWwHN+gG7OE+S43lPvtjjUiIFNmHL8y7hSkT8Mvw2nL1zrTxPTh
	EC7CkyyTx8lx3NgzjrYWDCV3J5UmS7LArlp5W1LKrCYQbqaDEe/hVQ5dfJ/EAQjj
	NijJUyK6lWjXK3nZBreQ6lCBxiVF9huo9nkdcNFmAIToI6ukyDJXq0YRil/VNtVw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wk81c46-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 17:17:42 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAGeTmZ011600;
	Mon, 10 Nov 2025 17:17:41 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aajw16en4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 17:17:41 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AAHHchQ58720536
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 17:17:38 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 43C8A20040;
	Mon, 10 Nov 2025 17:17:38 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B6DB820043;
	Mon, 10 Nov 2025 17:17:37 +0000 (GMT)
Received: from [192.168.88.52] (unknown [9.111.69.239])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 10 Nov 2025 17:17:37 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Date: Mon, 10 Nov 2025 18:16:49 +0100
Subject: [PATCH RFC v2 09/11] KVM: s390: Allow guest-3 switch to extended
 sca with vsie sigpif
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251110-vsieie-v2-9-9e53a3618c8c@linux.ibm.com>
References: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
In-Reply-To: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1677;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=tYPFe1cF0s8OoLV4EZM1YANW3GNB/NgDla4Qqonkces=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJlCctqzLzEJrj263Xnru1+bjnp6ytpL+zn6RvsFCYkFz
 +oPi8noKGVhEONikBVTZKkWt86r6mtdOueg5TWYOaxMIEMYuDgFYCJpgYwMlzcXySzz27Pu96FV
 /+079urPFFCJKnjXLW8rrNf0WvUGP8P/ihUM+0OWHX/nzKv9eXWhAb+f+rSCGzP5foebvfx3m+0
 9KwA=
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAyMiBTYWx0ZWRfXziJimmIVlheA
 VAE5Shb91j91o6m/wJhCHu1Nbejz3MbgtWo8Z2t/yI8oSrO4X5Nbdsla9bBAUsc5Y9NxPF35OPT
 WiY7Lusa+SSxO8KG7RAZ25U2rEVMpnVKMBzf7kbzm9+5zKOkAcWpSURfrjR77UZcRVez4H3QKXT
 L4fA4i2qN/o8tPWHgERUsROpVq9WNris9QwneK59adnE0KjBbMulLTHmJFWgc8GBgibmd8dM18i
 VcoKt2mtdzFUcjzEhgf6wZG7CG78w83xqrdJ4yEjMqvhhuuzKJiBz/BmDn79Hyqf7C4aK3aFzvo
 Ca28KbRq0Y0NF5f9F7HoF3P1Nxov4ugjJ1jh4o/VpMGHpEn98zaCdyo8bkgJHyms0vMW+LeoGjk
 PfF54gQ7ts27BQH+TKo6LwsQqg5IhA==
X-Authority-Analysis: v=2.4 cv=ZK3aWH7b c=1 sm=1 tr=0 ts=69121e36 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=ZEuDopgq87Z3SAe1qa4A:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: nplvHFsZPvsQS_BqE-pz9yIEvRYELGQN
X-Proofpoint-GUID: nplvHFsZPvsQS_BqE-pz9yIEvRYELGQN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_06,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0 adultscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511080022

If a guest wants to use more than 64 and use sigp interpretation it
needs to use the extended system control area. When the ESCA is not
already used and the 65th cpu is added the VM host will kick all cpus
destroy the old basic system control area (BSCA) and create a new ESCA
for the guest configuration.

In VSIE execution using vsie sigpif this also means the SSCA need to be
updated. The structure of the SSCA remains the same but the pointers to
the original SCA as well as its entries will have changed.

In guest-1 we can detect this change relatively simple as the original
SCA address changes.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 1e15220e1f1ecfd83b10aa0620ca84ff0ff3c1ac..b69ef763b55296875522f2e63169446b5e2d5053 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -932,8 +932,16 @@ static struct vsie_sca *get_vsie_sca(struct kvm_vcpu *vcpu, struct vsie_page *vs
 	if (sca)
 		goto out;
 
+	if (vsie_page->sca) {
+		/* switch to extended system control area (esca) */
+		sca = vsie_page->sca;
+		WARN_ON_ONCE(atomic_read(&sca->ref_count));
+		unpin_sca(kvm, sca);
+		/* trigger init_ssca() later */
+		if (sca->ssca)
+			sca->ssca->osca = 0;
 	/* check again under write lock if we are still under our sca_count limit */
-	if (sca_new && kvm->arch.vsie.sca_count < max_sca) {
+	} else if (sca_new && kvm->arch.vsie.sca_count < max_sca) {
 		/* make use of vsie_sca just created */
 		sca = sca_new;
 		sca_new = NULL;

-- 
2.51.1



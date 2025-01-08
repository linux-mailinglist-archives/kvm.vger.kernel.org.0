Return-Path: <kvm+bounces-34792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 860DAA05FFF
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 16:24:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A901F3A7823
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 15:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59FEA1FECD0;
	Wed,  8 Jan 2025 15:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rSIzzBTd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E3D1FDE2C;
	Wed,  8 Jan 2025 15:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736349840; cv=none; b=quq9qkIOSa1PqSjtMKahfebUv9vBZ5X/q+A7NjdvUDhKiCJsQX9+ip/JDJi0amXspR9nnTOj3h7ah5uWRmgt66ilN0Bwx67XviZebyqBt9lXxwL15Uq7vG9F9KW4VY6qJgJBk7aRH2ZC96OL7ZqNsiqM1dAkD20V35+QE2H6fiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736349840; c=relaxed/simple;
	bh=x5noGS8xATHCvMWIZnBKCz9MWAsrULcTebmrwSiB5mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igfH/AU4bB8y8KB29/U/Fy/+i68DE75b1IgI7/at832ahgXg82k7yHF4GjDNaVKFrw8SAMvSsT9z4dilT352TptgHdRLQ8FizI/VtExrf77NNZwTGrb77KuGAGh1GIOGDDMjYJg+bbCRNgoSgORdjiPwQx/FR1c6g5NbgOuId80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rSIzzBTd; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 508DA0uk029113;
	Wed, 8 Jan 2025 15:23:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ZLHp7TNnsY2FZawg0
	YD5cr6rGzikUEAmWI7mgkf46Y8=; b=rSIzzBTd4hheEkuPq/Tg4Ida3kqNaM/Qe
	yo8JNBH+Nz2RvyL4zoZm6t6oO1eO6vvv3waySK8krkSciIlnzbA+nzsR5BBomQd/
	QWqQwJL8lAqCbgB0dPWrBthA338UoM7BfZqPZyqQZF5e88tJulIy0V75nxtKLR4K
	QgWxDUm5bPUkQt90/epCHDT2XnLscPUnfprIuvGSZjz/y7zzH/nn0Qarql3UbD7Z
	TfyhgfYtk8xCxmFlbqPaUC/YWc11XB9XewKbaiwHDh9qa2hq4l2IgQYTL9S15lj/
	7Wg72cAqU5Wj00GWuf8W9u+bwRF2Ws2RJqniPXyp8aqe/SE0uw8AA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441e3b3mt9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 15:23:55 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 508DQTNk013648;
	Wed, 8 Jan 2025 15:23:55 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43ygap0a05-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 15:23:55 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 508FNoLk51184068
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 15:23:50 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CEA1520043;
	Wed,  8 Jan 2025 15:23:50 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AF9BB2004F;
	Wed,  8 Jan 2025 15:23:50 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jan 2025 15:23:50 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 1/6] KVM: s390: vsie: fix virtual/physical address in unpin_scb()
Date: Wed,  8 Jan 2025 16:23:45 +0100
Message-ID: <20250108152350.48892-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250108152350.48892-1-imbrenda@linux.ibm.com>
References: <20250108152350.48892-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0cC7iXaCv6GGRFAlT7z-Ps5FKENfpf36
X-Proofpoint-GUID: 0cC7iXaCv6GGRFAlT7z-Ps5FKENfpf36
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 phishscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 mlxlogscore=913 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501080125

In commit 77b533411595 ("KVM: s390: VSIE: sort out virtual/physical
address in pin_guest_page"), only pin_scb() has been updated. This
means that in unpin_scb() a virtual address was still used directly as
physical address without conversion. The resulting physical address is
obviously wrong and most of the time also invalid.

Since commit d0ef8d9fbebe ("KVM: s390: Use kvm_release_page_dirty() to
unpin "struct page" memory"), unpin_guest_page() will directly use
kvm_release_page_dirty(), instead of kvm_release_pfn_dirty(), which has
since been removed.

One of the checks that were performed by kvm_release_pfn_dirty() was to
verify whether the page was valid at all, and silently return
successfully without doing anything if the page was invalid.

When kvm_release_pfn_dirty() was still used, the invalid page was thus
silently ignored. Now the check is gone and the result is an Oops.
This also means that when running with a V!=R kernel, the page was not
released, causing a leak.

The solution is simply to add the missing virt_to_phys().

Fixes: 77b533411595 ("KVM: s390: VSIE: sort out virtual/physical address in pin_guest_page")
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20241210083948.23963-1-imbrenda@linux.ibm.com
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20241210083948.23963-1-imbrenda@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 150b9387860a..a687695d8f68 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -854,7 +854,7 @@ static int pin_blocks(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 static void unpin_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
 		      gpa_t gpa)
 {
-	hpa_t hpa = (hpa_t) vsie_page->scb_o;
+	hpa_t hpa = virt_to_phys(vsie_page->scb_o);
 
 	if (hpa)
 		unpin_guest_page(vcpu->kvm, gpa, hpa);
-- 
2.47.1



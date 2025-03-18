Return-Path: <kvm+bounces-41439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 74661A67C6C
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 19:59:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A50031767D8
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 18:59:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88A1C21325D;
	Tue, 18 Mar 2025 18:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="H6yGQ/M+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35150204C39;
	Tue, 18 Mar 2025 18:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742324386; cv=none; b=KzKafjOc1b2orEjmpI9kWYcyLKHi5/AJ2e0CGO/OsoNeinnxpglqkaiQfHhK8M8OIDVEBjfUvicoaL4yUrWHurCEYSR1rfxwrDdDoPVH7P0t/PIh/7j/6icJD+hbcMyYqVKPgZ+vyJmBLiNhzu6UXcIHhsD4NMjiJ6ygOkvwzVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742324386; c=relaxed/simple;
	bh=OtzNrSdu1+sx3C4TFX1kAUIS8obAQl0pRmdXQEgPOY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YCC/5az88ijkT1vqwj2bEIacF1JcfkosJCLLXuKPSMCAJKNLtSMZMHg1inE8mRjVxVF21UNhrlE2i1aVGyAq5oIadJW0r0inhEG9nlGo//xylbrIb+Pksn76Fug5gf2d4mT57yQzK4+ynaGqwT6HQlX7RuE5yPtUGtlzi4UvJSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=H6yGQ/M+; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52IGmWgp011686;
	Tue, 18 Mar 2025 18:59:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=y7Eng7
	Z8nj6XQZGhf62zYGtGMh1cfHIlQ5xijmnRhSI=; b=H6yGQ/M+FFXCAdlZAjsJgU
	sWNTldXnTCtCJcjgmp2Xylm/cp314Aw/O//KIZGIJzppUOgyMe/slLO+lcPN0ISP
	IWWp4grAnQPjZGRPuVm13PyR/y4lutX+M9nKgH2EPQcA4qe0RSiwNpP76QwkqsOV
	xlG08VhCkEsFApJPYLwRDcEOyWq+zUgLI/WxZ6PLdFKcKp1oLfkyd8uMhQK4eA5w
	GI2LCE3qoLxr5s+xg4H9peh9tss4ZGexOqWbu0Yi2J0KIu13t/PGpTyPlB6DQzGR
	LiqU03gmLYI0yFtp9A3wEDmn+DahFy1qYYXiMaZu79U9h8SvkhncE0FxOoMpAV9w
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45eu55wq4h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Mar 2025 18:59:42 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52IHCwA7031961;
	Tue, 18 Mar 2025 18:59:41 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 45dkvtdrhv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Mar 2025 18:59:41 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52IIxc7j19202354
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 18:59:38 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5062720043;
	Tue, 18 Mar 2025 18:59:38 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BC5FC20040;
	Tue, 18 Mar 2025 18:59:37 +0000 (GMT)
Received: from darkmoore.ibmuc.com (unknown [9.171.51.150])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 18 Mar 2025 18:59:37 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-s390@vger.kernel.org
Subject: [PATCH RFC 1/5] KVM: s390: Add vsie_sigpif detection
Date: Tue, 18 Mar 2025 19:59:18 +0100
Message-ID: <20250318-vsieie-v1-1-6461fcef3412@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250318-vsieie-v1-0-6461fcef3412@linux.ibm.com>
References: <20250318-vsieie-v1-0-6461fcef3412@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0LsWa9SHMfYYjoRecROvCoEgNAFRWxIH
X-Proofpoint-GUID: 0LsWa9SHMfYYjoRecROvCoEgNAFRWxIH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-18_08,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 mlxlogscore=962 priorityscore=1501 adultscore=0 suspectscore=0
 impostorscore=0 mlxscore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2503180137

Add sensing of the VSIE Interpretation Extension Facility as vsie_sigpif
from SCLP. This facility is introduced with IBM Z gen17.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Hendrik Brueckner <brueckner@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 1 +
 arch/s390/include/asm/sclp.h     | 1 +
 arch/s390/kvm/kvm-s390.c         | 1 +
 drivers/s390/char/sclp_early.c   | 1 +
 4 files changed, 4 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 9a367866cab0eb5f24960aea9fd552e0a919cffa..149912c3b1ffd0f8ed978b8c06a70efc892b7e01 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -983,6 +983,7 @@ struct kvm_arch{
 	int use_pfmfi;
 	int use_skf;
 	int use_zpci_interp;
+	int use_vsie_sigpif;
 	int user_cpu_state_ctrl;
 	int user_sigp;
 	int user_stsi;
diff --git a/arch/s390/include/asm/sclp.h b/arch/s390/include/asm/sclp.h
index 18f37dff03c9924190c1f9ae02d83967ae944f1b..f843cd0f148b0cb52e5e12f6c7d84cce26259442 100644
--- a/arch/s390/include/asm/sclp.h
+++ b/arch/s390/include/asm/sclp.h
@@ -101,6 +101,7 @@ struct sclp_info {
 	unsigned char has_dirq : 1;
 	unsigned char has_iplcc : 1;
 	unsigned char has_zpci_lsi : 1;
+	unsigned char has_vsie_sigpif : 1;
 	unsigned char has_aisii : 1;
 	unsigned char has_aeni : 1;
 	unsigned char has_aisi : 1;
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index ebecb96bacce7d75563bd3a130a7cc31869dc254..16204c638119fa3a6c36e8e24af2b0b399f8123b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -3458,6 +3458,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	kvm->arch.use_pfmfi = sclp.has_pfmfi;
 	kvm->arch.use_skf = sclp.has_skey;
+	kvm->arch.use_vsie_sigpif = sclp.has_vsie_sigpif;
 	spin_lock_init(&kvm->arch.start_stop_lock);
 	kvm_s390_vsie_init(kvm);
 	if (use_gisa)
diff --git a/drivers/s390/char/sclp_early.c b/drivers/s390/char/sclp_early.c
index d9d6edaf8de828a51b30098c288e76b2a61749cd..a06eb5fd3986910f05ac463640ad929a2579815f 100644
--- a/drivers/s390/char/sclp_early.c
+++ b/drivers/s390/char/sclp_early.c
@@ -60,6 +60,7 @@ static void __init sclp_early_facilities_detect(void)
 		sclp.has_diag318 = !!(sccb->byte_134 & 0x80);
 		sclp.has_diag320 = !!(sccb->byte_134 & 0x04);
 		sclp.has_iplcc = !!(sccb->byte_134 & 0x02);
+		sclp.has_vsie_sigpif = !!(sccb->byte_134 & 0x01);
 	}
 	if (sccb->cpuoff > 137) {
 		sclp.has_sipl = !!(sccb->cbl & 0x4000);

-- 
2.48.1


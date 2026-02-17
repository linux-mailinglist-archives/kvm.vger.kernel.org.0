Return-Path: <kvm+bounces-71148-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2As7Ir4ulGnQAQIAu9opvQ
	(envelope-from <kvm+bounces-71148-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 10:02:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 06BA014A255
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 10:02:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4BD723024A3D
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 09:02:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D44EA2F3C18;
	Tue, 17 Feb 2026 09:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HlJogC1n"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EDF1D88D7;
	Tue, 17 Feb 2026 09:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771318969; cv=none; b=hSkrhPzs4SblqeKRilWa6XOacJd3vRQAYrGbqvG9mhkT1JsaBc0pT7RAVh6xFAGgINmemzEGs9Aey/8i4G9nc6sP2ldcOvbPurpmMxx397uBdIQDcGSjMlb2iFtULep4PiD0UiucdP8G+oF/E9rYjDkDTilWpO0K+gk3q7qVkj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771318969; c=relaxed/simple;
	bh=G5rMIEIPCijPQh6Jt8hxzxn+I9BcjjKMfnp/3qeGGYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYp9EOm+avzBIQFjI3k25UuReNWH1rWpS1LI+NZtVSKaHZeV6YM2GzG7m0tMpdGHlIdBYbXtAiv6MJNCAP+8Z2vMNhtMSdscvNtq9BgQZrodEAllJCBjvpy0NxmGcF23kLoqQ6JSoWilj8BIBBjWKNasyafkPynlTnsCUNuYKTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HlJogC1n; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61H3GVFI3128045;
	Tue, 17 Feb 2026 09:02:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ixbs4KRZS/3iyLJGn
	hOl6XzRT6+HHPOatNdaxk020AI=; b=HlJogC1nPoAFU1iIO/w1KiFim/eeaQ0E2
	nRHI/PJjU7mTQ1KzqY3SST6CGmZUMtQesr9ubROTB8pKQRRYq4ijC71CVwm89vsb
	HkfwiNT2U50HUi8aS5z1kCvuT3G6mTtgo3z05qDgcR08Hk5Kti8VCgR3yczIc0VK
	miI9Yeme57meWe8wZqzLTPX3mzqEpnScb6+H2VvRLOrutenuo++M7Myk/Hef/2Sk
	m5aPi7UhKcoqQoqOVH017cUJfxNqUVCe/dhWlBXSmz0dPtay1ss3DfmP0wS4QUT/
	3LVucAYIgV8Oi8NdEGQ1FcbhBKkEVagSj2wl/r2EmmRWaHGQ6L71w==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cajcqu6r2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Feb 2026 09:02:47 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61H8nmLx030175;
	Tue, 17 Feb 2026 09:02:46 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ccb451skf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Feb 2026 09:02:46 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61H92gtB28836136
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Feb 2026 09:02:42 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A09B320040;
	Tue, 17 Feb 2026 09:02:42 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A63720043;
	Tue, 17 Feb 2026 09:02:42 +0000 (GMT)
Received: from b46lp25.lnxne.boe (unknown [9.87.84.240])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 17 Feb 2026 09:02:42 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com, freimuth@linux.ibm.com,
        mjrosato@linux.ibm.com
Subject: [PATCH 1/2] KVM: s390: Limit adapter indicator access to mapped page
Date: Tue, 17 Feb 2026 09:54:22 +0100
Message-ID: <20260217090230.8116-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217090230.8116-1-frankja@linux.ibm.com>
References: <20260217090230.8116-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: K3M7czXdjkK4cIgdFgNYBT2U9AhIg_Uy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE3MDA3MSBTYWx0ZWRfX2Cdadee0Jx7D
 6i3y2vTyesjIrtGjUVr1PUpOJsRcPR0eYRwJ/A/hym82plTv+OW1Eczwjh08r563V1mvG9oEkE6
 wQc3F+Xk40TC0fP8F+X6mTPwO3tlkAzEHXllex2DeV9GgJzaWO1OHuaNdJYmyLuqJ7E4Sy/AP6Q
 p0BTky0w2avtjdNGwblPfIPYs8uNffFX/ByTqtvjkhs3S0f4GtvlZSco0KzEK/FeYqScQ67mtMS
 K3VgdAS3j/6mG+BSmVAUBypas2jYeWc3PcZhjdbPK0EaLTHc07BJtyoo8SUmiL4V1MJsn6yNmtR
 wsT0RI1VcVhmDf5DG+MqRsqiesToaAWEfkFZDhvptaArx0M0BxFBhBNWn6moeKoxxPBb2p3QxIB
 XjlldzOS33vd0qUC54dK14wSVBMC8BuX2dGNvu7j9qs/KcdhERYxM5h70AN3TZoVY5dvOWAIW9S
 huuuVmDShLByTRVOTqg==
X-Authority-Analysis: v=2.4 cv=UPXQ3Sfy c=1 sm=1 tr=0 ts=69942eb7 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=4bGgk7TxAfJRkC2M7-gA:9
X-Proofpoint-ORIG-GUID: K3M7czXdjkK4cIgdFgNYBT2U9AhIg_Uy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-17_01,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 phishscore=0 impostorscore=0 adultscore=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602170071
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71148-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[frankja@linux.ibm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[ibm.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 06BA014A255
X-Rspamd-Action: no action

While we check the address for errors, we don't seem to check the bit
offsets and since they are 32 and 64 bits a lot of memory can be
reached indirectly via those offsets.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Fixes: 84223598778b ("KVM: s390: irq routing for adapter interrupts.")
---
 arch/s390/kvm/interrupt.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 1c2bb5cd7e12..cd4851e33a5b 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -2724,6 +2724,9 @@ static unsigned long get_ind_bit(__u64 addr, unsigned long bit_nr, bool swap)
 
 	bit = bit_nr + (addr % PAGE_SIZE) * 8;
 
+	/* kvm_set_routing_entry() should never allow this to happen */
+	WARN_ON_ONCE(bit > (PAGE_SIZE * BITS_PER_BYTE - 1));
+
 	return swap ? (bit ^ (BITS_PER_LONG - 1)) : bit;
 }
 
@@ -2852,6 +2855,7 @@ int kvm_set_routing_entry(struct kvm *kvm,
 			  struct kvm_kernel_irq_routing_entry *e,
 			  const struct kvm_irq_routing_entry *ue)
 {
+	const struct kvm_irq_routing_s390_adapter *adapter;
 	u64 uaddr_s, uaddr_i;
 	int idx;
 
@@ -2862,6 +2866,14 @@ int kvm_set_routing_entry(struct kvm *kvm,
 			return -EINVAL;
 		e->set = set_adapter_int;
 
+		adapter = &ue->u.adapter;
+		if (adapter->summary_addr + BITS_TO_BYTES(adapter->summary_offset) >=
+		    (adapter->summary_addr & PAGE_MASK) + PAGE_SIZE)
+			return -EINVAL;
+		if (adapter->ind_addr + BITS_TO_BYTES(adapter->ind_offset) >=
+		    (adapter->ind_addr & PAGE_MASK) + PAGE_SIZE)
+			return -EINVAL;
+
 		idx = srcu_read_lock(&kvm->srcu);
 		uaddr_s = gpa_to_hva(kvm, ue->u.adapter.summary_addr);
 		uaddr_i = gpa_to_hva(kvm, ue->u.adapter.ind_addr);
-- 
2.53.0



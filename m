Return-Path: <kvm+bounces-66101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D865CC5D9C
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 04:01:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0459130322AE
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 03:01:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83A3D27F18F;
	Wed, 17 Dec 2025 03:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lf+zmmbF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74BE265CC2;
	Wed, 17 Dec 2025 03:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765940487; cv=none; b=H4hWeIgiGTJtlEMWU0Zt1tTS4H0bysTZ4EEIR8N1OEwBfjZovI3RAKgmvTKpTuP9pqJoLolnp3rQlKgDEWED8hYfHoCt+ic9yeA1POCtEBjn2fXD5Ub4GPaXKAqn1P7+G6I8VSh6dXxbzmORfhT8CP0f+WznHfbKvzfuauDkV3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765940487; c=relaxed/simple;
	bh=OeR9k5KOTVFmDqEKHl9Bzj3XwRnJ4b1VeLWQ7KiUUrA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o2xulcTMGYtZuPr8Eda2sjrh0tdFWbA/p1SlVJV/vRB64CCCyvJLMq5lc5wmBXmU56ahuaK6TQpOhQXdX59t+vbXcaI0iO8JJOb6ihsq/nlA0BJVmI5XiEUAqu23i5SuUlmDnJpFYbxRrVtXB4yrZ6mwuideeAJZFH/6PfjgDic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lf+zmmbF; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BH08hDG001735;
	Wed, 17 Dec 2025 03:01:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=/nZQaxJI/xb9idZfrXXe2tlipbfkbJ3weyniQSBS6
	4U=; b=lf+zmmbFMFvAPvCTRYy5COYSmp0y0L9CWJrCrJXnxBzQ/SmJsEAKB9QzC
	dXTb1dw400aNrnLSyQM2zcyxWSy+cUtJOUf1mj+41HvyLH3vWR3wih0bLs384sqb
	lkWlP4hAoq7R93MWxgOyrSXsFHwjmLoXBcz3oi5TNTh+BnZOSilo9joKmr1iAqw/
	WJgmCI/g2a+HTFOb89mObQAg5YuhD/315l1xAd84kddCU6m5nS35o/74lqlaw6lc
	SnPF+gn5gM2dfJ+hTbHyP4zlO3xERZoTtkmmAmJFyha4TJV3kEIGJ8XL/ZjkeSZB
	sAFRmUYBReyGUvKoq9u8+XKvN8nEQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0ytvakww-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Dec 2025 03:01:17 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BGN7oZq014420;
	Wed, 17 Dec 2025 03:01:16 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4b1mpjyruc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Dec 2025 03:01:16 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BH31DAV25756204
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 03:01:13 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 234A42004B;
	Wed, 17 Dec 2025 03:01:13 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 13CB820043;
	Wed, 17 Dec 2025 03:01:13 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 17 Dec 2025 03:01:13 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
	id CF9ABE0973; Wed, 17 Dec 2025 04:01:12 +0100 (CET)
From: Eric Farman <farman@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH] KVM: s390: vsie: retry SIE when unable to get vsie_page
Date: Wed, 17 Dec 2025 04:01:07 +0100
Message-ID: <20251217030107.1729776-1-farman@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEzMDAyMyBTYWx0ZWRfXzP430IDmi32R
 vAt1w83rNV6Syo0RPTiCLMSpRsWxcHjPonb3JVKbb097FRAaDQ+jBYzjwoBi6ivZdfVlTvmcVUl
 sLrHBwGYgFuzftyJ8RDss/HlEFu4gD9A0lBfX8rp2pgi5PNTun4xM9DEoc06sisdCuwi4jFvKjl
 xRYvnhAtZKBbArVL0db/v/TxTYJHJgmL0wr+n7jqeL2AWIuqYov0afhLyKTgcX4Dqu78PCo/3oR
 MVYmPXl2yr+QhGIOoAy1Ec0WLpoJ88jI/QDxY2fDaI6d4cz8OVcB/uR8J+6GaO3iIB+wuVVgzHx
 6wxkCJam+B7JsUBWEAKS1Rt41AqtaBi+oAnl+OGiomN1H0xy3znvUjhmv3qslZsFt3rFkJhwn+w
 Ih1cq4LIWSFvh7f8gfgZ4lptCV4Chg==
X-Proofpoint-ORIG-GUID: xJdl-CPTf2l98TTVw8jANTQt_fYQJxCJ
X-Authority-Analysis: v=2.4 cv=QtRTHFyd c=1 sm=1 tr=0 ts=69421cfd cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=HSVDk6IH-gmX55RuthsA:9 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19
X-Proofpoint-GUID: xJdl-CPTf2l98TTVw8jANTQt_fYQJxCJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-16_03,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 impostorscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2512130023

SIE may exit because of pending host work, such as handling an interrupt,
in which case VSIE rewinds the guest PSW such that it is transparently
resumed (see Fixes tag). There is still one scenario where those conditions
are not present, but that the VSIE processor returns with effectively rc=0,
resulting in additional (and unnecessary) guest work to be performed.

For this case, rewind the guest PSW as we do in the other non-error exits.

Fixes: 33a729a1770b ("KVM: s390: vsie: retry SIE instruction on host intercepts")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 arch/s390/kvm/vsie.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index b526621d2a1b..b8064c6a4b57 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1498,11 +1498,13 @@ int kvm_s390_handle_vsie(struct kvm_vcpu *vcpu)
 	}
 
 	vsie_page = get_vsie_page(vcpu->kvm, scb_addr);
-	if (IS_ERR(vsie_page))
+	if (IS_ERR(vsie_page)) {
 		return PTR_ERR(vsie_page);
-	else if (!vsie_page)
+	} else if (!vsie_page) {
 		/* double use of sie control block - simply do nothing */
+		kvm_s390_rewind_psw(vcpu, 4);
 		return 0;
+	}
 
 	rc = pin_scb(vcpu, vsie_page, scb_addr);
 	if (rc)
-- 
2.51.0



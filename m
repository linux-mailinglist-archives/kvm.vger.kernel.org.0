Return-Path: <kvm+bounces-22935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 510A8944A50
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 13:26:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 07B621F226CE
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:26:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 972D0189BA4;
	Thu,  1 Aug 2024 11:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JXEciysd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167FF183CC8;
	Thu,  1 Aug 2024 11:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722511560; cv=none; b=FCrWjIc5manFIMqWnnOaHss8uQHgygt0M24QMxomhdw7LC+7YxdOb8dV1M51D/iwot9fAFM6LTm/F89UPNtfdANNBdlP/aFlicKpaVDOvtSFfShVKj9KJD/rSBtCSxFUa/RgIGUHC/QDxnlygGjg3w/s3gkULJ6Du2Lsnx5tieI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722511560; c=relaxed/simple;
	bh=JNchXePlzqkPMmlcRfiSZulgcHMk/yG4yFYtv683y6k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J5+FZxmzLRZoayhl98DfwsSD1w3G7WawpUeLFlv/LHEautiDhui3m142VV2jtbKotztGdUfdrKZypcx+TqIbtaxo/Ux0/uGXymcvbJ7768O3DIrotO8CfgjdypqVNVk3F4LrcwbsH8v5/VJtnErat68u2fKqh49zEOWEZK1ramw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JXEciysd; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 471BKpOn004202;
	Thu, 1 Aug 2024 11:25:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=rvAyAM97Q57EqiEOuf3wItRHsx
	XsuyfgLDiE1HeJZhQ=; b=JXEciysdWClSkg07BVo2xi3Or78AcAqVMpaQDhSvt8
	cLH6WFC3Dq5GEoorb3uRqYg4zR2xgAQ1VgUEcOaFCc+xcs1ObLaAoPozZM0TZvUD
	bk0+1H3+G1Sd31OXmUFQ0soOxgecm5+crRwnenXbU3STjtmuniIlMGGQwikArjcq
	QkqTKE99bd9EDN2rsLcUwwsu1VTS9Q2sNnLOdvo+33bZyegE9ooJVaXvyYMOj8i+
	SCEadRAdLkM8FQeTLQLASAydWUiz9CYKzykcZS1kxvaeWJ1cn+tC5XgdsDtlUV3S
	HB5sBd91kqrjjpVBNIIgSf9JjdN2jY7y9dUy+m5cEadA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40r3tprtwm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Aug 2024 11:25:55 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 47192MIi003776;
	Thu, 1 Aug 2024 11:25:54 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 40ndems5fj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Aug 2024 11:25:54 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 471BPna835259010
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 1 Aug 2024 11:25:51 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 44DD320049;
	Thu,  1 Aug 2024 11:25:49 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 18FFE20040;
	Thu,  1 Aug 2024 11:25:49 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  1 Aug 2024 11:25:49 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, hca@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, borntraeger@de.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, seiden@linux.ibm.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v1 1/1] s390/uv: Panic if the security of the system cannot be guaranteed.
Date: Thu,  1 Aug 2024 13:25:48 +0200
Message-ID: <20240801112548.85303-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2f1zp06cB4bi18ff_exhR03wOVvk5xmr
X-Proofpoint-ORIG-GUID: 2f1zp06cB4bi18ff_exhR03wOVvk5xmr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-01_08,2024-07-31_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 mlxlogscore=303 malwarescore=0 adultscore=0 spamscore=0 priorityscore=1501
 bulkscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2407110000
 definitions=main-2408010072

The return value uv_set_shared() and uv_remove_shared() (which are
wrappers around the share() function) is not always checked. The system
integrity of a protected guest depends on the Share and Unshare UVCs
being successful. This means that any caller that fails to check the
return value will compromise the security of the protected guest.

No code path that would lead to such violation of the security
guarantees is currently exercised, since all the areas that are shared
never get unshared during the lifetime of the system. This might
change and become an issue in the future.

The Share and Unshare UVCs can only fail in case of hypervisor
misbehaviour (either a bug or malicious behaviour). In such cases there
is no reasonable way forward, and the system needs to panic.

This patch replaces the return at the end of the share() function with
a panic, to guarantee system integrity.

Fixes: 5abb9351dfd9 ("s390/uv: introduce guest side ultravisor code")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/uv.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 0b5f8f3e84f1..153d93468b77 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -441,7 +441,10 @@ static inline int share(unsigned long addr, u16 cmd)
 
 	if (!uv_call(0, (u64)&uvcb))
 		return 0;
-	return -EINVAL;
+	pr_err("%s UVC failed (rc: 0x%x, rrc: 0x%x), possible hypervisor bug.\n",
+	       uvcb.header.cmd == UVC_CMD_SET_SHARED_ACCESS ? "Share" : "Unshare",
+	       uvcb.header.rc, uvcb.header.rrc);
+	panic("System security cannot be guaranteed unless the system panics now.\n");
 }
 
 /*
-- 
2.45.2



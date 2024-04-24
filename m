Return-Path: <kvm+bounces-15795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AB1018B07E9
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 13:01:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4AB231F23228
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 11:01:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9717015B14F;
	Wed, 24 Apr 2024 10:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cFft8j1F"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD2315B102
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 10:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713956398; cv=none; b=KAR18YbrDgCjcEdoks+i/TDYYRQOz/0uZZbI635Wd88x5mQWFPqSrnRfP12yI+wfSkgkKwY3qkDKofTXLMMGBDH1MkxHhbSwDgzsOhYlSC6aX9YnGutn0asGpJmd0thI9eRy7oyDPaj0GG+foLyU9rQgYlU+6WOzV8/EGH5VlqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713956398; c=relaxed/simple;
	bh=aKWmBM8Bt8rooR3wYBHjC2Tzpc1cDVkcb4gC9gXPbQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iE5Ndwb2FEbJYzqfkVwstV6oF3FAuMeSGYkowX+manJH9Tiyqwu4UDFKYwd9JiLUTCwvikOkGcgszNSVC1gFLrCR2MihPxIZ5eCHPsLwGT9dfs+Dly7PbdDVLDohbt2d+G4wJ8ZnCEm9vLDGecC6QaMPeTQ+ZU8wWN+xp39Jjjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cFft8j1F; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43OAgRa2008495;
	Wed, 24 Apr 2024 10:59:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=IluY/7oij9rogCrrjOtLGv86ZpDcycC0oOPLji6Qv20=;
 b=cFft8j1Fc6oW1EHq1vdalONYWWvkjomMQqPsyeN7lwBwpR+nXAQBYhk3K2RXGKCDHtYx
 wPp999jJG7FkpWcFw8PX6ETD/rApUzOMv90W2PZNkRenaUUV6JoBRGD5GBOWE18/m+BI
 Nt/cxXpxhWRIE83P1ZClIe9uCr4npWfDFSORz+X5xv7atiIQ4S5wcNcAMR9zuk441d6f
 XLerNbjZGL11hB94I7b/vMO6ibEcJLTgs3rqxZux75OEqzzDdUd0yn9YO+TEkFV0yfTC
 fKSJncRNBUYH4EodygNIqPSH2f8WKVE2nbilFPPHNXjJ/llOXWc9MbN75jfSKvBJPdne gA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xq0jb80wn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:45 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43OAu01L029126;
	Wed, 24 Apr 2024 10:59:45 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xq0jb80wk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:45 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43OAxFJv029905;
	Wed, 24 Apr 2024 10:59:44 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xmr1tkefx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:44 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43OAxcNt44499334
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Apr 2024 10:59:41 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E23B02004E;
	Wed, 24 Apr 2024 10:59:38 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B45AA2004F;
	Wed, 24 Apr 2024 10:59:38 +0000 (GMT)
Received: from t14-nrb.boeblingen.de.ibm.com (unknown [9.152.224.21])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Apr 2024 10:59:38 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 02/13] lib: s390x: sigp: Dirty CC before sigp execution
Date: Wed, 24 Apr 2024 12:59:21 +0200
Message-ID: <20240424105935.184138-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424105935.184138-1-nrb@linux.ibm.com>
References: <20240424105935.184138-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -odxPmvUEE0QNl7w1hAEpDUCOLu94fHN
X-Proofpoint-GUID: _0DsWqR7FwU8kKsVXOuiHK2CwHloS-f5
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-24_08,2024-04-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 phishscore=0 malwarescore=0 impostorscore=0 suspectscore=0 adultscore=0
 mlxlogscore=980 lowpriorityscore=0 mlxscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404240045

From: Janosch Frank <frankja@linux.ibm.com>

Dirtying the CC allows us to find missing CC changes when sigp is
emulated.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20240131074427.70871-2-frankja@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/sigp.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/asm/sigp.h b/lib/s390x/asm/sigp.h
index 61d2c625..4eae95d0 100644
--- a/lib/s390x/asm/sigp.h
+++ b/lib/s390x/asm/sigp.h
@@ -49,13 +49,17 @@ static inline int sigp(uint16_t addr, uint8_t order, unsigned long parm,
 		       uint32_t *status)
 {
 	register unsigned long reg1 asm ("1") = parm;
+	uint64_t bogus_cc = SIGP_CC_NOT_OPERATIONAL;
 	int cc;
 
 	asm volatile(
+		"	tmll	%[bogus_cc],3\n"
 		"	sigp	%1,%2,0(%3)\n"
 		"	ipm	%0\n"
 		"	srl	%0,28\n"
-		: "=d" (cc), "+d" (reg1) : "d" (addr), "a" (order) : "cc");
+		: "=d" (cc), "+d" (reg1)
+		: "d" (addr), "a" (order), [bogus_cc] "d" (bogus_cc)
+		: "cc");
 	if (status)
 		*status = reg1;
 	return cc;
-- 
2.44.0



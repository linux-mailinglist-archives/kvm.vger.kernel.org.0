Return-Path: <kvm+bounces-34047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98EFA9F67B5
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 14:52:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9C8C67A3951
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 13:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87D1B1BEF89;
	Wed, 18 Dec 2024 13:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FlDaIgj5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D1F1B0423;
	Wed, 18 Dec 2024 13:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734529913; cv=none; b=aIZJcNTDaOLCmQgps+fNKWy6Ic6w0siNjqfaAI3NoQUmOhos9g/gZRuQBo+XAF1JEWoaKoRVgsqEG9evIqKGQEEVduuGnxUh3Y2HsFPdjftn2/2NclxoBKUmu0grM55FrKE3Z8MRG+YpvatDT93o0O2xJ2ob/FDX1a+9bU/GkKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734529913; c=relaxed/simple;
	bh=+PfV9OCeej3YJ5cqWsevSZNbpB8aIXg1oK2fVSg+hJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlEloHeqRN/RSyTlbUFG2JoCdujeV52903yGcTn+DOVvbna/G9K6Q8q1/EtubaOJq+oAHENTH6WTYyyarcGf1P2JOTTSGfT6PV4iq+aeh6pvvsjrXH5cRvG5/OkeVDUR0JrwLeR/a+cjNpPfBvIOqflVBx+Unz6x+WE1S2OP5uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FlDaIgj5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI3rG0q029783;
	Wed, 18 Dec 2024 13:51:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=clVQCKxv1ExJvrG7d
	9dBSaXGdqZ04BIPWy7tsF66SXo=; b=FlDaIgj5TBaKKVTvCLt7pEiYUpkfOSenY
	DpW2+0Rz04ayZ8fQeqJL9meIXz1g2/Rn0CY2X9sU/wMCMLygHU8L8UNfXG0rTrxi
	BfISg79WexNC/Q8tfzRhiv1FTFPxwbGR5P2ownnusDLmHfhbGhQMCoJqoq/OXR9u
	jPLhGxdnjd4CrTAglTydFyAT4xgAR+o07yspQ8lfTJUrXqr/XUaj9dBRrpZkRIjw
	sJroJD0b7QIpxzlrFHB5gD7EDjdtcAxOMF383OZ5rUZYI5K3iV+PxZcws0Y/GKNG
	ugOJESHIWEpIL3EWSA4JI9mRxUBO6lF8wWqqPTY2FchSX7drHv9tQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43kpvgtgd4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Dec 2024 13:51:48 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BIBVCTa029326;
	Wed, 18 Dec 2024 13:51:47 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 43hmbsramw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Dec 2024 13:51:47 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BIDpdv740632754
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 13:51:39 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8CE7E20040;
	Wed, 18 Dec 2024 13:51:39 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5FC1D2004E;
	Wed, 18 Dec 2024 13:51:39 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 18 Dec 2024 13:51:39 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: nrb@linux.ibm.com, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        thuth@redhat.com, david@redhat.com, schlameuss@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 2/3] lib: s390x: add function to test available UV features
Date: Wed, 18 Dec 2024 14:51:37 +0100
Message-ID: <20241218135138.51348-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241218135138.51348-1-imbrenda@linux.ibm.com>
References: <20241218135138.51348-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UEiwsyFvWcEQFcxdrM90RfKac8FKN_gz
X-Proofpoint-ORIG-GUID: UEiwsyFvWcEQFcxdrM90RfKac8FKN_gz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412180106

Add uv_query_test_feature(), to test specific bits in the
uv_feature_indications bitmask, similar to uv_query_test_call().

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/uv.h | 1 +
 lib/s390x/uv.c | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
index 00a37041..b0fbc478 100644
--- a/lib/s390x/uv.h
+++ b/lib/s390x/uv.h
@@ -10,6 +10,7 @@ bool uv_os_is_guest(void);
 bool uv_os_is_host(void);
 bool uv_host_requirement_checks(void);
 bool uv_query_test_call(unsigned int nr);
+bool uv_query_test_feature(unsigned int nr);
 const struct uv_cb_qui *uv_get_query_data(void);
 void uv_init(void);
 int uv_setup(void);
diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
index 723bb4f2..03499272 100644
--- a/lib/s390x/uv.c
+++ b/lib/s390x/uv.c
@@ -67,6 +67,15 @@ bool uv_query_test_call(unsigned int nr)
 	return test_bit_inv(nr, uvcb_qui.inst_calls_list);
 }
 
+bool uv_query_test_feature(unsigned int nr)
+{
+	/* Query needs to be called first */
+	assert(uvcb_qui.header.rc);
+	assert(nr < BITS_PER_LONG);
+
+	return test_bit_inv(nr, &uvcb_qui.uv_feature_indications);
+}
+
 const struct uv_cb_qui *uv_get_query_data(void)
 {
 	/* Query needs to be called first */
-- 
2.47.1



Return-Path: <kvm+bounces-36997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E1E8A23D5A
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 12:53:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7BA818848F0
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 11:53:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B20371C2443;
	Fri, 31 Jan 2025 11:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VvDnGMA8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858822AD11
	for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 11:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738324410; cv=none; b=gnl4plZItBGXkwMPE1Ot1w29j+iOTQUYMtWpW1aJmtZ4rNjZbgEfwD0AcZ1sl1cn3BgknKejrCZe6vNkBpj4bCR2O2ipEa3pNv17nOg2vVk0rJz6FOeOPcNnP+IVaYdmBxLHKZwk4+VFR1pZ397uL+8zEnhmTI9Y9yFwQ4eec70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738324410; c=relaxed/simple;
	bh=QIrB1sF92FQtENDwLzensYU5CODYU6hPW1xXfAbWGSc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fig2KPoSbPw5N2sdY2aLO+Et4T0wRPuDhIB/lMsrXaH4SErW6VHfzWgfAythxNMYcjdHADIlNUPzyhcfhwp8KeuB0dQu1o6R1TJPK7OawnmTswgHykepLw5Mo6kb0n/+I9k/Xi805rHgTfuHrvoicEdD+g2JSqzVKbwVzL7Uul0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VvDnGMA8; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50V2ORSB030648;
	Fri, 31 Jan 2025 11:53:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=4yrmOhEhbtI7SNkPDMhbKaH7+YAGX5mM52D20Qpmr
	9E=; b=VvDnGMA8UWgY0fRzTU/OdZ2cyLV7h5BTPF+PodNlVNxWM4sirf8Ym/ik6
	XhmhrnW5R4C9+x3WSyGMtqjAgMWuMBlRr5KHAyW5T7Rk5I2X4j76HGFOBLqvabic
	24NtEJbIeJ/O3w8LuQJmUbGvNB9Oyg/cwydrK5uGmODPbwUNVRKcbirhZO8DuezF
	Gn3ao8Q669pvtMsKIYVi1zlEPVJjbxUMt0YhBRmDSo6NquRa3k/3OCBvARcMbkRv
	+2YBvouesigJWSc0lb9Tw77JlqLzwB/3LWx/A/IAeGWctC/d+o1waK7AUjAywTDd
	FMAvyM5Iuhf2URTnPwy4xtB0QEk9g==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44gfn5bd42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:53:16 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50V873pf024576;
	Fri, 31 Jan 2025 11:53:15 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44gf913dk9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jan 2025 11:53:15 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50VBrBO953805526
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jan 2025 11:53:11 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C9A8A201C8;
	Fri, 31 Jan 2025 11:53:11 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 65EE6201C4;
	Fri, 31 Jan 2025 11:53:11 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.fritz.box (unknown [9.179.26.180])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jan 2025 11:53:11 +0000 (GMT)
From: Marc Hartmayer <mhartmay@linux.ibm.com>
To: <kvm@vger.kernel.org>
Cc: Janosch Frank <frankja@linux.ibm.com>, Nico Boehr <nrb@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm-unit-tests PATCH v1] editorconfig: Add max line length setting for commit message and branch description
Date: Fri, 31 Jan 2025 12:53:07 +0100
Message-ID: <20250131115307.70334-1-mhartmay@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: L9wiIonLLO7fYlaq0gWmLTMsc0MZJ8hU
X-Proofpoint-GUID: L9wiIonLLO7fYlaq0gWmLTMsc0MZJ8hU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-31_04,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2501170000
 definitions=main-2501310087

Add max line length setting for commit messages and branch descriptions to
the Editorconfig configuration. Use herefor the same value as used by
checkpatch [1]. See [2] for details about the file 'COMMIT_EDITMSG'.

[1] https://github.com/torvalds/linux/blob/69e858e0b8b2ea07759e995aa383e8780d9d140c/scripts/checkpatch.pl#L3270
[2] https://git-scm.com/docs/git-commit/2.46.1#Documentation/git-commit.txt-codeGITDIRCOMMITEDITMSGcode

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
---
 .editorconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/.editorconfig b/.editorconfig
index 46d4ac64f897..03bb16cb9442 100644
--- a/.editorconfig
+++ b/.editorconfig
@@ -13,3 +13,6 @@ insert_final_newline = true
 charset = utf-8
 indent_style = tab
 indent_size = 8
+
+[{COMMIT_EDITMSG,EDIT_DESCRIPTION}]
+max_line_length = 75

base-commit: 2e66bb4b9423970ceb6ea195bd8697733bcd9071
-- 
2.43.0



Return-Path: <kvm+bounces-179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 44BDF7DCA4D
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 10:59:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1F0B1F220CE
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 09:59:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0966818C10;
	Tue, 31 Oct 2023 09:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XiGoT1lp"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB6D13AD4
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 09:59:36 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321CE97
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 02:59:35 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39V9BIui028144
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 09:59:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=UFEf31kd8bpnRCU/TRhpjNYx01qWnhWVgJhB/qeKdLY=;
 b=XiGoT1lpsjPLrUN2/VLpbjQ59XejP1b6O+W9XNDgBpWttX8dd0CDEcsZiocxDI6VBtnj
 ZhrezTtUnJ4+c/Xedm8n+vUscw7giIhBRPg7rPItLe8Wezj7MfQLZfowm8xsuUoPRaVf
 dv5mPzBz90pF4KzjGc9GcEvvkCV5wN+eWG5/+5TElroj/ThUWFk8uCgvTA9K3JYGUpPN
 xQzXTxzgggyUTNcy2mjIf5NNjtzicE90M2T4zbhQJsr5wtc4BcXvxyzhQU86a0Md0f0H
 QeVS/SOU3xg0vk/x7g1C5QzvZG9CAZsclz8MxHVz0oyUgfTxbwRigmTwOXMypJc8uG5d Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2x3au264-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 09:59:34 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39V9fDk0013105
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 09:59:34 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u2x3au0vs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 31 Oct 2023 09:59:22 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39V83GsJ007734;
	Tue, 31 Oct 2023 09:55:57 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u1dmnffay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 31 Oct 2023 09:55:57 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39V9tr2O39453060
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 31 Oct 2023 09:55:53 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C6A192004D;
	Tue, 31 Oct 2023 09:55:53 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A106620043;
	Tue, 31 Oct 2023 09:55:53 +0000 (GMT)
Received: from a46lp67.. (unknown [9.152.108.100])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 31 Oct 2023 09:55:53 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: nrb@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com
Subject: [kvm-unit-tests PATCH v2 0/3] s390x: Improve console handling
Date: Tue, 31 Oct 2023 09:55:16 +0000
Message-Id: <20231031095519.73311-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uNHy4uPsyMd8qpIqhE9KLyu96kSTEwR8
X-Proofpoint-GUID: aqB58hJ30QqM8LhL7h9yjafo11y5ESMp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-30_13,2023-10-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=383 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2310240000 definitions=main-2310310078

Console IO is and has been in a state of "works for me". I don't think
that will change soon since there's no need for a proper console
driver when all we want is the ability to print or read a line at a
time.

However since input is only supported on the ASCII console I was
forced to use it on the HMC. The HMC generally does not add a \r on a
\n so each line doesn't start at column 0. It's time to finally fix
that.

Also, since there are environments that only provide the line-mode
console it's time to add line-mode input to properly support them.

v2:
	* Reworked detect_host routine to support being called in early setup
	* Added length checks in sclp_print_ascii for compat handling
	* Added Linux reference to lib/s390x/sclp-console.c header
v1:
	* Fenced ASCII compat handling so it's only use in LPAR
	* Squashed compat handling into one patch
	* Added an early detect_host since SCLP might be used in setup
	* Fixed up a few formatting issues in input patch
	* Fixed up copyright stuff

Janosch Frank (3):
  lib: s390x: hw: rework do_detect_host so we don't need allocation
  lib: s390x: sclp: Add compat handling for HMC ASCII consoles
  lib: s390x: sclp: Add line mode input handling

 lib/s390x/hardware.c     |  11 +--
 lib/s390x/sclp-console.c | 206 +++++++++++++++++++++++++++++++++++----
 lib/s390x/sclp.h         |  26 ++++-
 3 files changed, 215 insertions(+), 28 deletions(-)

-- 
2.34.1



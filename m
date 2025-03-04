Return-Path: <kvm+bounces-40071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D83BA4EC28
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 19:44:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7BD538E4BB5
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 18:31:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDB14280CC1;
	Tue,  4 Mar 2025 18:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rWcVsqAv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D67C27FE62;
	Tue,  4 Mar 2025 18:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741112603; cv=none; b=YGzr6+JUXXF7BDWAhMMNsp5U4GHupeYWzI0UTpSRXVxytUtr3CVwvj5CkyoOgO3EDrf/KQlEiYX5TG0fH/TCWG4lBs6HVYUkryASnDDiMOA9weVPlXAJp0oo0Vd2ZD33C0bSy+Vaiqmj3KLOsJJgDdcxhndZ9gpbKCAJA4Ce5iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741112603; c=relaxed/simple;
	bh=nJxN0OF+NV+pP7a2nHlRBnE7O4eJYLZXYsG9b6RtaTI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sySyiY/8bvypovragC7xFGZMmFqqf8BGR+Ve6UtVfuAtySKZum+EjkRt70vvt7Pb4WQSQoJ0GxTpbJqunSDM2yPxzZBmxUjsmAG3JQKexAX375L9jlSNoi2h3COwfuqvLIE07sU09j76fuVVk5AV+h4aEQfHIFqFAU7/KJNUixE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rWcVsqAv; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 524GEPW1023631;
	Tue, 4 Mar 2025 18:23:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=cHkOY2aFm4MBzD9JOYJEt0kX6l/PwwLDRWhBCbIyP
	Jw=; b=rWcVsqAvuhYPPQMCtF3PiFidkTRiYPl5mYXOgNZY057CSSHfEVsXEHRgw
	uQFmGj4XNgckstFTOYiUadjamqmFppjF3UAIuvgyXVwRX3FaE3ZpjpAPL+jxKsAW
	5h5C10vpMp2NKggGYjOHXDzMWfXL2OLH5co0AYnwZFGu2yF9B/U4Ken4Ml1C4l/M
	JTtglu/VAmo9WCmBIfuvc8eYFs57RYrAzxsyp4ax93HR/sxyj2wKExcaujUw9ISL
	yXKHS+5xu7Kxt2Re18RzoCYOSZWsUI0mOy8U00y32h7pi9QEvooZATNvjyJxG71b
	gWpmDxEkV1MgBrfYYus/mW1PBk83Q==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 455ku55ke7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Mar 2025 18:23:14 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 524GlFiP020800;
	Tue, 4 Mar 2025 18:23:14 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 454esjxgmj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Mar 2025 18:23:14 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 524INA0q30737108
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Mar 2025 18:23:10 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 66E8920043;
	Tue,  4 Mar 2025 18:23:10 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9E5B120040;
	Tue,  4 Mar 2025 18:23:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.171.33.201])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  4 Mar 2025 18:23:09 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, david@redhat.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com
Subject: [PATCH v4 0/1] KVM: s390: fix a newly introduced bug
Date: Tue,  4 Mar 2025 19:23:03 +0100
Message-ID: <20250304182304.178746-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xu9pspZucWmZHK1_7WqZYEpn6K7X8ZOd
X-Proofpoint-GUID: xu9pspZucWmZHK1_7WqZYEpn6K7X8ZOd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_07,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 clxscore=1015 mlxscore=0 suspectscore=0 impostorscore=0 bulkscore=0
 mlxlogscore=649 lowpriorityscore=0 spamscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2503040144

Fix race when making a page secure (hold pte lock again)

This should fix the issues I have seen, which I think/hope are also the same
issues that David found.

v3->v4:
* move and rename s390_wiggle_split_folio() to fix a compile issue when
  KVM is not selected
* removed obsolete reference to __() from comments

v2->v3:
* added check for pte_write() in make_hva_secure() [thanks David]

v1->v2:
* major refactoring
* walk the page tables only once
* when importing, manually fault in pages if needed

Claudio Imbrenda (1):
  KVM: s390: pv: fix race when making a page secure

 arch/s390/include/asm/gmap.h |   1 -
 arch/s390/include/asm/uv.h   |   3 +-
 arch/s390/kernel/uv.c        | 135 +++++++++++++++++++++++++++++++++--
 arch/s390/kvm/gmap.c         | 101 ++------------------------
 arch/s390/kvm/kvm-s390.c     |  25 ++++---
 arch/s390/mm/gmap.c          |  28 --------
 6 files changed, 153 insertions(+), 140 deletions(-)

-- 
2.48.1



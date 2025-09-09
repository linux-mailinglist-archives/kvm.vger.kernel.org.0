Return-Path: <kvm+bounces-57100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE073B4ACF8
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 13:55:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0DD8718867B8
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 11:55:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B2943218B4;
	Tue,  9 Sep 2025 11:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jGOjkvQp"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6355D322DAC;
	Tue,  9 Sep 2025 11:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757418913; cv=none; b=oQpEc6dHfsJOq/1JgpRnkHXFNsHWeQQsXIdCcBtITI+gaPf4cWYwvEAtvD67nCSrs6zcWUplt9fCR0R1yAjsHsFBAmXu9xmweb9If+7Zcd8PEewJ1dKYSOfqfcJQ6nswfX9bS2TNxW2FchMDTlJL0297x94FebLEDnHxXSD7IAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757418913; c=relaxed/simple;
	bh=96uMP4DTYFhW4ojkT1mw+Lz8HU/FlOUeJnLLY+1x1Vo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O7EmZi++NA0Zp8GgBgLzEcvJzSL6VOzjajwHzgH+lqI2yMiZ7PRPzImFDYbwdr3AQcC4XPvRUCxu0M4QsfPMuL45HpsmaaUpAMHqS1h+O9TnluT00yikGfNGvv+TcIbO6OVYBh3qDMX3AGVNfKPoPYxXdRtfGuNtgARLEHA9eIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jGOjkvQp; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5896kdq9031789;
	Tue, 9 Sep 2025 11:55:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=26DrLd+MNjuof9rN10LToeGgMhxj9crtBAOAPGYDT
	A0=; b=jGOjkvQpruS1Uq/CIbUHdo1273q1S0Nurgqjb4WpsFmYyPjghoGetMX4p
	fH438zJlbLDk3j3D+V3UiYz7tQCpcfYsSDVzfh9afzTQy1fjxHKNv+jhxB7qpB48
	F+yVOcIGssPCAav67Avj8s30rxaWaWET6qAPvY+gdtkD0EFjAMTzRCgNh1OkGv94
	8e61+amhDQjpGkL5xKJCVCh9QVt0lnsOV8Oe/su65UjyRJxScHs3KHzu6gUm8wyz
	B5J3jvkHOi+b2oOVPSaxS4WwG6Us/AFiQTqYo+n40qZGS2171CesK9aoKnQ2/FDX
	yED21Wbb6zF3mkSX/RGBRtJdVxKCw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490acqydh4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 11:55:08 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 589B0Cv2017188;
	Tue, 9 Sep 2025 11:55:07 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4911gmarj5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 11:55:07 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 589Bt4g457606608
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 11:55:04 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ED12720043;
	Tue,  9 Sep 2025 11:55:03 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8AF9820040;
	Tue,  9 Sep 2025 11:55:03 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.111.71.18])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Sep 2025 11:55:03 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [GIT PULL 0/3] KVM: s390: fixes for 6.17
Date: Tue,  9 Sep 2025 13:46:12 +0200
Message-ID: <20250909115446.90338-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YlnVMoKHzGcwG1_B4hV-DOIwpwQIVTok
X-Authority-Analysis: v=2.4 cv=Mp1S63ae c=1 sm=1 tr=0 ts=68c0159c cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=SrvvcybseHtfX3BO3ioA:9
X-Proofpoint-ORIG-GUID: YlnVMoKHzGcwG1_B4hV-DOIwpwQIVTok
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAwMCBTYWx0ZWRfX+mLGlDxJwNRw
 9zIlrKCgF4Iz1CVgCyYWkqUD/SHvgeOtf1qCWEtqogvX19M3FHYqDTRN5QZGPfNDOzRbBJBPq0R
 dMRbw/tvptLlJRcY1/jLJgnVwf7mwyHkxtb8miNq4+D9EcgRp6YNvwRzNubO4OAIC6sljbRlW5I
 AGvyq6vUooWA+garqAqDDTVk9lHQvMZ0Z0qA58v3Ed8FtvHSu+rgz/OssJW9gn4yNam/ms1f40W
 PVjQJd25/sz0ZGxLOeFlHGwclraI1TkwuepXR9Q7WIsbCYM0eafGb3qOow6C0iG9Eew4V86bzOm
 AA5Dl/PdOgxVAtIckdjdtmZ7DTH6rul7gKmJFtrzkn7DlCVRAP70vYuWRGRMytf/ijTx8XVH+iw
 0AhqCq+o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_01,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 clxscore=1015 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060000

Paolo,

here are three fixes for KVM s390. Claudio contributed mm fixes as a
preparation for upcoming rework and Thomas fixed a postcopy fault.

I've had these on master for two weeks already but there was KVM Forum
in between so here they are based on rc7.

Please pull.

Cheers,
Janosch

The following changes since commit 76eeb9b8de9880ca38696b2fb56ac45ac0a25c6c:

  Linux 6.17-rc5 (2025-09-07 14:22:57 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-master-6.17-1

for you to fetch changes up to 5f9df945d4e862979b50e4ecaba3dc81fb06e8ed:

  KVM: s390: Fix FOLL_*/FAULT_FLAG_* confusion (2025-09-09 08:17:39 +0000)

----------------------------------------------------------------
- KVM mm fixes
- Postcopy fix
----------------------------------------------------------------

Claudio Imbrenda (2):
  KVM: s390: Fix incorrect usage of mmu_notifier_register()
  KVM: s390: Fix FOLL_*/FAULT_FLAG_* confusion

Thomas Huth (1):
  KVM: s390: Fix access to unavailable adapter indicator pages during
    postcopy

 arch/s390/kvm/interrupt.c | 15 +++++++++++----
 arch/s390/kvm/kvm-s390.c  | 24 ++++++++++++------------
 arch/s390/kvm/pv.c        | 16 +++++++++++-----
 3 files changed, 34 insertions(+), 21 deletions(-)

-- 
2.51.0



Return-Path: <kvm+bounces-27051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6348097B20F
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 17:44:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2ADE1285A83
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2024 15:44:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EC801CFED6;
	Tue, 17 Sep 2024 15:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ApmThZpw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E05180021;
	Tue, 17 Sep 2024 15:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726586386; cv=none; b=XPX1AFsVnja/chdWSMyWtWQk5sSvUCvfJ4Ssaa/wud+n7Gj7iP7+UoISQfMZ0z7oqOzW2WuCVacpFfDYOvYVCd2ePKGpoIh+QmLJVkkck5bAuK5u/wIP0TrvXqN0VxD/j+83YoVzYE7P5qqSVD+QTSTI3YjxBdiAP1uHMlOr4RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726586386; c=relaxed/simple;
	bh=mgd/1m1MmL2fqWXTJYOZMNfoG1HKf9XzfrUFm3JR8oc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EDAekXTNep/p0/4D80oiHj11fOT35+3aRhulcfoYzeS/HYwwRS1A4RvwbTr7RfSGL+soj5dC99Xs4oXP5aNLQAKLYm10Ums47ftvw6xonLW7UlMvvzY/PCMWqWj/SivWRU9XNnApu2NbxvndpTP8CT5lu8lPQDXC0XJWTwV3R1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ApmThZpw; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48H9MQwQ007518;
	Tue, 17 Sep 2024 15:19:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=MLtQDoqNuqmpDSg5NRbeVo8NUP
	H8pIjEuF9tm0KjhWc=; b=ApmThZpwo8uDCG5fNJ1XHLierzbN1PC54vRpSMAPga
	YWoLV+e5kxpn2sPCad8cz1ECxSeHqn0niBBzRuo6mV2qWsIo+h7ZO0detDptx+sq
	g8gigMs7CPB4POC1J7UGXPIy2UvuGkhWSSlNCYvZsk00SOx2mOhAlapCA+EZCkdb
	oEU1K0qUpj6tCvO0xUA4iedUIPExlLcj3A6bsLMlwA3D8j6atMlp9TjajS/9G8Od
	+Dwz0buois0PZ9iSxFGnWNcrYxPcszRY+872yi1PN6DRqHm0m18eXWtq77wgQGZY
	JBx6hJGD5POUiw6rXKmEJaN0gC2HTF7i4lC4LZ8vM+nw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n3vdh0wq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Sep 2024 15:19:43 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 48HFGj9G025703;
	Tue, 17 Sep 2024 15:19:42 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n3vdh0u9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Sep 2024 15:19:42 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48HEwQpb000628;
	Tue, 17 Sep 2024 15:19:08 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41nn7163se-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Sep 2024 15:19:08 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48HFJ4QM57409842
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Sep 2024 15:19:04 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A86620040;
	Tue, 17 Sep 2024 15:19:04 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3906C2004B;
	Tue, 17 Sep 2024 15:19:04 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 17 Sep 2024 15:19:04 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        david@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v1 0/2] KVM: s390: fix diag258 virtual-physical confusion
Date: Tue, 17 Sep 2024 17:18:32 +0200
Message-ID: <20240917151904.74314-1-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AjRm98rRzPHAuDQMYyod4n9wySe_SOPj
X-Proofpoint-GUID: hgDVYWlymsFfh_1USVoL5HHLFgIRrLal
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-17_07,2024-09-16_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1015 mlxscore=0
 malwarescore=0 mlxlogscore=475 priorityscore=1501 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409170110

The parameters for the diag 0x258 are real addresses, not virtual, but
KVM was using them as virtual addresses. This only happened to work, since
the Linux kernel as a guest used to have a 1:1 mapping for physical vs
virtual addresses.

In addition, add handling for guest addresses outside memslots in
access_guest_page() for architectural compliance and testability.

Michael Mueller (1):
  KVM: s390: Change virtual to physical address access in diag 0x258
    handler

Nico Boehr (1):
  KVM: s390: gaccess: check if guest address is in memslot

 arch/s390/kvm/diag.c    |  2 +-
 arch/s390/kvm/gaccess.c |  7 +++++++
 arch/s390/kvm/gaccess.h | 14 ++++++++------
 3 files changed, 16 insertions(+), 7 deletions(-)

-- 
2.46.0



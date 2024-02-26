Return-Path: <kvm+bounces-9856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 93C0C8674C0
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 13:24:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DE7228A9CF
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 12:24:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1774E604D0;
	Mon, 26 Feb 2024 12:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VONUaNQQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CCD604AC;
	Mon, 26 Feb 2024 12:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708950291; cv=none; b=GIvAORSNZtP+elnSmd7cUoOIpY9e8peO6oUdgweu++fwT/+utHl+IqVGBt2LI62hHcq86XfD076NdH6IFy7AeJ/Xg6d0LB+BKIvQW0Gnys0Z0b8tbcJBtL+9V23CijX2XLYyhkzkIT5TPAR3QvBAsi/kUm97BBBnNxd3y8YrTSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708950291; c=relaxed/simple;
	bh=PL4vr3TS0IRIYycWNFzYRijN/D926hnuNHHGaQbCYEM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gpbrYijedn+XoNllaTvl1xMGnbF0zSwXrBhAuAnVK5VWYxEhLZWEeGGtUQztkjbQifANLb4hJy760tQk6mxfHvyavhArmdlRuyVIgB660SqJufH44Y4hBCW7GwtDPn3iq9PgcKmefjowfTktbY+6Uz4RsPmb4gcX5cjttX6DnH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VONUaNQQ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41QAYXtc008294;
	Mon, 26 Feb 2024 12:24:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=1BCIkZT10NATQir98WX8LShg4oBO6vIMpVO1Wg4WaEM=;
 b=VONUaNQQpwtT8B4/7rP2yKj/0KVAIXHmtkJbRl8dnA8O0GTFbB/k4sPk9ot6ATVrFjej
 CFsynb/TS8ExGtP5RRetieE1oa9ZAPVJ142gn50zvyTRmfZhIpkcuZDC6LWjeLYJCF87
 mat6yzTd9KjJSPC2i7Wbl5FxcNbvTGIMq9YwPmhYsLVgDmpPUyRFube1CV/7i5EFGk9o
 St1P3czcs6dkOIkHsw+ph0LQ0Ig8MqFB4G0FRMl733rI2LUl6x0nYECiBkVgGcAIbBLu
 uki26XTGKXZ0bMt74xJmG5Fe89xIX/aDyKoImEGls1xyo4n7lbUpgnFcid2z9CWcF7mY 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wgpbkwt63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 12:24:48 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41QBp6sW009899;
	Mon, 26 Feb 2024 12:24:47 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wgpbkwssg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 12:24:47 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41QA0jaD024151;
	Mon, 26 Feb 2024 12:22:14 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3wfw0k0jvu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 12:22:14 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41QCM96A5308960
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 12:22:11 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B42420040;
	Mon, 26 Feb 2024 12:22:09 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 926112004B;
	Mon, 26 Feb 2024 12:22:08 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.77.191])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 26 Feb 2024 12:22:08 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        seiden@linux.ibm.com, nsg@linux.ibm.com, farman@linux.ibm.com,
        agordeev@linux.ibm.com
Subject: [GIT PULL 0/3] KVM: s390: Changes for 6.9
Date: Mon, 26 Feb 2024 13:13:05 +0100
Message-ID: <20240226122059.58099-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.43.2
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8LPBYFXVvkFLauKkJM9JDUZ5CJrcC4YU
X-Proofpoint-ORIG-GUID: H6hzZOxak1n6G8KmSHD5g691K3CoBFNx
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_09,2024-02-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=773 phishscore=0 adultscore=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402260094

Paolo,

please pull the 3 fixes that I've held on to as they were very low priority:
- Memop selftest rotate fix
- SCLP event bits over indication fix
- Missing virt_to_phys for the CRYCB fix


Attention:
Three additional patches will go over the main s390 repository since
Heiko made changes to the FPU handling that caused a conflict with KVM
but we didn't want to create a feature branch.

See:
https://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git/log/?h=for-next

- KVM: s390: fix access register usage in ioctls
- KVM: s390: selftests: memop: add a simple AR test
- KVM: s390: introduce kvm_s390_fpu_(store|load)


Cheers,
Janosch


The following changes since commit 41bccc98fb7931d63d03f326a746ac4d429c1dd3:

  Linux 6.8-rc2 (2024-01-28 17:01:12 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-6.9-1

for you to fetch changes up to 00de073e2420df02ac0f1a19dbfb60ff8eb198be:

  KVM: s390: selftest: memop: Fix undefined behavior (2024-02-23 14:02:27 +0100)

----------------------------------------------------------------
- Memop selftest rotate fix
- SCLP event bits over indication fix
- Missing virt_to_phys for the CRYCB fix
----------------------------------------------------------------
Alexander Gordeev (1):
      KVM: s390: fix virtual vs physical address confusion

Eric Farman (1):
      KVM: s390: only deliver the set service event bits

Nina Schoetterl-Glausch (1):
      KVM: s390: selftest: memop: Fix undefined behavior

 arch/s390/kvm/interrupt.c                 | 4 ++--
 arch/s390/kvm/kvm-s390.c                  | 2 +-
 tools/testing/selftests/kvm/s390x/memop.c | 2 ++
 3 files changed, 5 insertions(+), 3 deletions(-)





-- 
2.43.2



Return-Path: <kvm+bounces-6568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78352836D13
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 18:23:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99FFA1C26D18
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 17:23:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C1645479F;
	Mon, 22 Jan 2024 16:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IYGtVHD8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D64654278;
	Mon, 22 Jan 2024 16:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705940737; cv=none; b=uA96lf8LABpPqrTJ2ssHuhXREWEz3oguDxZFTa7KnjN7cq4DU3icY/oFDFqZyr5MM6hXeQawRpyC8npeisPvBGJTbUUpJLEsqY57x0+i6rXkDXq/eYXK5UGT4yRizIatLFKnsVOxD47rlizZQM5ZabBNX100oPLeUqDV/bF0l6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705940737; c=relaxed/simple;
	bh=YV1S92U6p3UaVNws9GQHpH5MEtaRlV/nYZXUHha44eg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TSRPtnpgOcyQjvg/Xq0m8BbE4saJWK1Hd5rfv0w9JIgc/zr8bUMjO/QZpodaJ/5sU7IwLnh6nVu6nr5+nbQvbneOhEmo65gYnJqjRa/qDGOxfJllLOBB1OwawgMaUzQiWJSGRS/QLLoDTQaPbE0bsAg94UQPYmfDg7hFizOPdSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IYGtVHD8; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40MGNH1i032583;
	Mon, 22 Jan 2024 16:25:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=/NYL2QK/FLgBNyly+4xlTQ4Yq+VpYkZip7XyvIZjJCQ=;
 b=IYGtVHD8EP9OTKCVB9s+JE1vUqOP0qeahTkQMzfrjnhGdlKTWYFukzSIWwlB+znmACZX
 yauwL3+DsOwv2gUYye5mbfuvEd7rKlUYyx+FMDmrNmUHDL8Whdc3nAp2+d/ss9u6IiuQ
 sQS7GjdvCl9wb2TIvNVDZUg+wjF5xNYrjobBSl8pufv8c3OP0xX87LQ8iNo0zxRgrut8
 wcY6PL7ej0BMoYHByjSiJA4yZB8krCeUSQu6mMDhVquNiVQloz3TFsFt/tz3Ocn0rvaH
 Kq2gaNkp4/E+GewvNfC3FKBsOpojwlZwuJMwLHaw8ev76XRVKxlKbwjYbJjjUu3GHmup vg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vstkfb6sv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Jan 2024 16:25:34 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40MGOEWY003972;
	Mon, 22 Jan 2024 16:25:33 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vstkfb6s2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Jan 2024 16:25:33 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40MFg5DA028248;
	Mon, 22 Jan 2024 16:25:32 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vru729aym-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Jan 2024 16:25:32 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40MGPUlr3408552
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Jan 2024 16:25:30 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EA5AE20043;
	Mon, 22 Jan 2024 16:25:29 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A65120040;
	Mon, 22 Jan 2024 16:25:29 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.78.16])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Jan 2024 16:25:29 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [GIT PULL 0/2] KVM: s390: Fixes for 6.8
Date: Mon, 22 Jan 2024 17:22:29 +0100
Message-ID: <20240122162445.107260-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ewVNYGjLWGjZu37SiK--q67TsloFYjWm
X-Proofpoint-GUID: EW-DsAG3xtWKeZioTzBqKGHFCsbOZG9P
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
 definitions=2024-01-22_06,2024-01-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=510
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 phishscore=0
 mlxscore=0 malwarescore=0 adultscore=0 clxscore=1015 impostorscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401220112

Paolo,

please pull the fixes for the following two problems:
 - The PQAP instruction did not set the CC in all occasions
 - We observed crashes with nested guests because a pointer to struct
   kvm was accessed before being valid (resulting in NULL pointers).

You'll see that the fixes are still based on 6.7-rc4 since they've
lived on our master for quite a while. But I've re-based them on
Linus' master and your queue and next branches without an issue.

The following changes since commit 4cdf351d3630a640ab6a05721ef055b9df62277f:

  KVM: SVM: Update EFER software model on CR0 trap for SEV-ES (2023-12-08 13:37:05 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-master-6.8-1

for you to fetch changes up to 83303a4c776ce1032d88df59e811183479acea77:

  KVM: s390: fix cc for successful PQAP (2024-01-08 18:05:44 +0100)

----------------------------------------------------------------
pqap instruction missing cc fix
vsie shadow creation race fix
----------------------------------------------------------------

Christian Borntraeger (1):
  KVM: s390: vsie: fix race during shadow creation

Eric Farman (1):
  KVM: s390: fix cc for successful PQAP

 arch/s390/kvm/priv.c | 8 ++++++--
 arch/s390/kvm/vsie.c | 1 -
 arch/s390/mm/gmap.c  | 1 +
 3 files changed, 7 insertions(+), 3 deletions(-)

-- 
2.43.0



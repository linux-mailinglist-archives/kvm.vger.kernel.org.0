Return-Path: <kvm+bounces-16826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8008E8BE21B
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 14:30:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3702F28AF96
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 12:30:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D752F15ADB8;
	Tue,  7 May 2024 12:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="P3VLFPrP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFD8156F39;
	Tue,  7 May 2024 12:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715084996; cv=none; b=rfYcbuJ52etKl5BlI18HER1XOlXRh4aSLhChKDuqMfAAZpcgigG9wZU8lEN73bqzGF4EZt3Y/RKzaoCFP7/Nsk9UMO1s6p/khPzQ20lEzjAmsSKT5rorUUq8bZGjM9BwZjQ6g9UWXQ7UYrY9A26kpHjKkojXhqqCSYDlXEytZC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715084996; c=relaxed/simple;
	bh=39cF6JGV0KEK1SNEEBenCELE44m5KE8iw8HoplNrNQM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nTKADbLzVxpZ3FzoWE9i+dBRCaZaM6QyB0CEzl9mhzsQk0fMwqx97GcipYDskLNy5GgbP/irHQ+Mz/PObzM7xKlIty6Jhp8tqXG89mb9LG5+7EYKR3OGp/khkNGaecQWj6aDb31bOm6fxRCYAl0PzbB88yQiXE+X3e5ciOj5HzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=P3VLFPrP; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 447CRge6013539;
	Tue, 7 May 2024 12:29:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=7IusaSmN/1TtKe36R2nh/qRwDIW4LW0JwQYzueBK42I=;
 b=P3VLFPrP/vpNO6+9aJOezBplROwxuaePhS65oWHtjbEHeyxkaP7IW6/TNP5tekf48GiM
 Tw1/R8u/j5suxMZ5cK+FvQ7WaCd42IP5hHcvM9GGGFEfYK1tDXh4CCV/dH0a+v71z/zR
 l5+C0qbeOAkvJuEocKtTYA8C1rz8l2AoxbX3gssfXrqoQjV2Kk9cZ4Iv+wyxEnGGpTGi
 8xcAKQmQg/zrfsbLD+StdSxQtvFFJPZh5QJnPcJf9AuVC1fRHNqCKLmGAgeQDcKTVetF
 yrJguBHJdnQnvHLsr9FkoS5d5soVqHirj4p16Yy2qkS56lWB1cXGrkmeeDK/geZXAtqy kA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xyman806x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 12:29:52 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 447CTqOo016875;
	Tue, 7 May 2024 12:29:52 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xyman806v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 12:29:52 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 447AxTKI013859;
	Tue, 7 May 2024 12:29:51 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xx222wn02-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 May 2024 12:29:51 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 447CTkWJ52953408
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 May 2024 12:29:48 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0C4F720040;
	Tue,  7 May 2024 12:29:46 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AE3DC2004B;
	Tue,  7 May 2024 12:29:45 +0000 (GMT)
Received: from m83lp52.lnxne.boe (unknown [9.152.108.100])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 May 2024 12:29:45 +0000 (GMT)
From: Christian Borntraeger <borntraeger@linux.ibm.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [GIT PULL 0/1] KVM: s390: Fix for 6.9
Date: Tue,  7 May 2024 14:29:44 +0200
Message-ID: <20240507122945.2571-1-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.45.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Jg2c7kijo_C5zBP3x1goTu7KCFZWCqU_
X-Proofpoint-ORIG-GUID: pX9Va7OW15gYY8IOBxEmquMjwGPj2RK5
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-07_06,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 adultscore=0 mlxlogscore=671 phishscore=0
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2404010000 definitions=main-2405070086

Paolo,

one fix for s390.

The following changes since commit 16c20208b9c2fff73015ad4e609072feafbf81ad:

  Merge tag 'kvmarm-fixes-6.9-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2024-04-30 13:50:55 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-master-6.9-1

for you to fetch changes up to 175f2f5bcdfce9e728f1ff956a50f28824d28791:

  KVM: s390: Check kvm pointer when testing KVM_CAP_S390_HPAGE_1M (2024-05-02 09:41:38 +0200)

----------------------------------------------------------------
KVM: s390: Fix for 6.9

Fix wild read on capability check.

----------------------------------------------------------------
Jean-Philippe Brucker (1):
      KVM: s390: Check kvm pointer when testing KVM_CAP_S390_HPAGE_1M

 arch/s390/kvm/kvm-s390.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


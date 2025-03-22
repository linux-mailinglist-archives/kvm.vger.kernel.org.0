Return-Path: <kvm+bounces-41751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E48FA6C9DC
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 12:12:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24DD44632AE
	for <lists+kvm@lfdr.de>; Sat, 22 Mar 2025 11:12:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9AB41F9A83;
	Sat, 22 Mar 2025 11:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Sodi8A4o"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7751E835C;
	Sat, 22 Mar 2025 11:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742641934; cv=none; b=NXCe/KwR+k4mThjGi4l/4drqHHMRIY7Oa+2BUyvJzRalr9hhKNKH+kuVtqUxHBNdPILYkJzax2p6mQHmxqlMfTfhveYI+etGP5kxmaB3NHDSLFs4MC+3WKGgOPCQqliEKLqTzXilR4Hl0YQEeWZCVYXB2qUgekgbdEBPnGE+CiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742641934; c=relaxed/simple;
	bh=Y2x5W4i+73hGMwee9ZoPAr06USCM59CMimSEii/ScpI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kwJdbb77D1nCsbSLWRaP7NA53OlD5GmlFANYa+f0XoxbV34ZkJTU03zvPg9JFVQi1DyzIll0MnSVlW+nz6jdRiGvVTAXXeCh2bAzLz7HqJLEgobwIHKdc5uzkl5CRC6/c78xLMna9Q5vtN5jmJOeQ9yPJZ8qclw2tIutOYJlGbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Sodi8A4o; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52M7kRQv025882;
	Sat, 22 Mar 2025 11:12:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=U2RT1DSjs++ydAfjjQaRslAegWp1
	E+H8XDQ2EiJYiSw=; b=Sodi8A4oRrN9WEqql/EnfBR7msVShP0IEbucFCGOBrr6
	xXAvL6pJ2qBdT1yGyPwiZTD7bxiIP8rPja+eWaT716M5enbvJo1jZU6WzkqHC6Zk
	aiYEwB6gDuOV8gmbvWq0Ut59Y3z8DmLHW9bYDNIjObzLYlsBWUVmq3wEAurVoYXk
	MQ/bNd/F4IlUNn/Tvh4fFv8xsxWVBygcauRnWlX9wK1My3M8NlE+BhyIr9scHsEL
	kRPtI6CsrN2EoOAltOuTJ2sL0ZfhZ2MjQUzqTCpEu90drpyDoIYRzTvu1Z4HlSi3
	ZDz6LI+Qz/va4YPJCAfhB0XW5qztt3yjp5iD3sVXAQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45hnfsh3q1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 22 Mar 2025 11:12:10 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52M9154G026180;
	Sat, 22 Mar 2025 11:12:09 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 45hn8nh8db-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 22 Mar 2025 11:12:09 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52MBC5DR35193138
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 22 Mar 2025 11:12:06 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DF36B20043;
	Sat, 22 Mar 2025 11:12:05 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 58C8620040;
	Sat, 22 Mar 2025 11:12:05 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.47.152])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 22 Mar 2025 11:12:05 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [GIT PULL 0/2] KVM: s390: updates for 6.15
Date: Sat, 22 Mar 2025 12:06:43 +0100
Message-ID: <20250322111119.24548-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -rui0QqDaKcb6W5PGcg5pgmi5318LSqo
X-Proofpoint-ORIG-GUID: -rui0QqDaKcb6W5PGcg5pgmi5318LSqo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-22_04,2025-03-21_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 spamscore=0 clxscore=1015 mlxscore=0 bulkscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=360 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2503220080

Paolo,

only two cleanup patches by Thomas Weissschuh fixing our pointer print
formats in s390 KVM.

I'll be on a conference next week but I'll check my mails periodically
and I really don't expect problems with those two patches.

Please pull.


Cheers,
Janosch


The following changes since commit a64dcfb451e254085a7daee5fe51bf22959d52d3:

  Linux 6.14-rc2 (2025-02-09 12:45:03 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-6.15-1

for you to fetch changes up to 0c7fbae5bc782429c97d68dc40fb126748d7e352:

  KVM: s390: Don't use %pK through debug printing (2025-03-17 08:55:46 +0000)

----------------------------------------------------------------
Pointer print format fixes

----------------------------------------------------------------


Thomas Weißschuh (2):
  KVM: s390: Don't use %pK through tracepoints
  KVM: s390: Don't use %pK through debug printing

 arch/s390/kvm/intercept.c  |  2 +-
 arch/s390/kvm/interrupt.c  |  8 ++++----
 arch/s390/kvm/kvm-s390.c   | 10 +++++-----
 arch/s390/kvm/trace-s390.h |  4 ++--
 4 files changed, 12 insertions(+), 12 deletions(-)

-- 
2.49.0



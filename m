Return-Path: <kvm+bounces-21818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AB83934BF8
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 12:53:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 957BDB20F54
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 10:53:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7F1D136E01;
	Thu, 18 Jul 2024 10:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="f9DMev/1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB1013664C;
	Thu, 18 Jul 2024 10:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721299993; cv=none; b=iP3d5YKVC5xVJMYQ+ANrvT3QyRpZDyfv94yqi7PiDE0SGTAXzYrgEpTWkRIP8H8p6u740BlHwQgoJMwPFsMmhBHDWlqPLGRbT7F9uJi/LSSxmRHWtgWjS2Q+r3xgP4pqk+4ryAEA1Jxnh46+lOYV7eUqdrkfvvHQd7dlQURwqtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721299993; c=relaxed/simple;
	bh=3z/n9T4BHMbc7++0IH60AtMbl6jpLD586QZHs6AjScU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aYZykBINupI8lIV809j7yKLEG6NpG7QhNzWW+RYUCA8ypqwdRLBDrQ67Xm6mlnvf4ZQjSwwTXYtKPypb1WEFQMZ10MjBujZLmXY0RQOeQ8XkH7o5oVsPoQOhxXY4HpmvNXb/1mQ58Hz7z+mDb432vjaE5mXWu5L5pHbbl6p1AFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=f9DMev/1; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46I9uUHa032742;
	Thu, 18 Jul 2024 10:53:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=lw1VhgKO9zaTG1e2q1ypNkgMhn
	k+klZ7QJKDK01xjWA=; b=f9DMev/1ax1FMM3q98mBEFebjxsEmnF4aJP5I9l+t6
	8d+F+5J1q9ofs6ZHh0GoHbmNmi6prOi/aiMTa3u9+Spnc3JCt6PnNp2j+ji7yF+B
	wpngxl8n9zXxrcLMOhsv/85cGTTCdf5wBEv4BakFAZxtDXoVdwA+JlYuPzCREOIn
	fgMe0A9NhM6OVFz2bV1AC65UBNTpU7/xqCTiL2iWiulZVqbkSaH9WafcwXQfkM1G
	PBDjaeLCllys+PjB3LAK1y+GSpXotKtpAHZg4u9n/wP4B/TLC+GUMS7PKnGhWZ21
	U24/UK3BslUNJ2sHc3cg+E0RZYzcvgtv8yMD3jaQcJxg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40eyjp89tm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jul 2024 10:53:09 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46IAr8Or016253;
	Thu, 18 Jul 2024 10:53:08 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40eyjp89ry-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jul 2024 10:53:08 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46I95YeN009173;
	Thu, 18 Jul 2024 10:52:29 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 40dwkms7ne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jul 2024 10:52:29 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46IAqOjn30671482
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jul 2024 10:52:26 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1898420043;
	Thu, 18 Jul 2024 10:52:24 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CFDC820040;
	Thu, 18 Jul 2024 10:52:23 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Jul 2024 10:52:23 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
        npiggin@gmail.com, nsg@linux.ibm.com, mhartmay@linux.ibm.com
Subject: [kvm-unit-tests PATCH 0/4] s390x: split off snippet and sie related code
Date: Thu, 18 Jul 2024 10:50:15 +0000
Message-ID: <20240718105104.34154-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: G5EdapE4fm6NSL5lW2_07CiGHj8yGXcF
X-Proofpoint-ORIG-GUID: ibdRINMinOoRu7BdZXVmGBIWMcCi7fro
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-18_07,2024-07-17_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=828 adultscore=0
 impostorscore=0 clxscore=1015 mlxscore=0 spamscore=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 priorityscore=1501 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2407110000
 definitions=main-2407180072

The makefile is getting long and increasingly complex. Let's move the
snippet part to s390x/snippets/ and sprinkle a couple comments on top.

While we're moving things around we can split lib/s390x/sie.h into sie
architecture code and sie library code and split the sie assembly in
cpu.S into its own file.

Janosch Frank (4):
  s390x: Split snippet makefile rules into new file
  s390x/Makefile: Add more comments
  s390x: Move SIE assembly into new file
  lib: s390x: Split SIE fw structs from lib structs

 lib/s390x/{sie.h => asm/sie-arch.h} |  58 +------
 lib/s390x/sie.h                     | 231 +---------------------------
 s390x/Makefile                      |  41 ++---
 s390x/{cpu.S => cpu-sie.S}          |  59 +------
 s390x/cpu.S                         |  64 --------
 s390x/snippets/Makefile             |  30 ++++
 6 files changed, 45 insertions(+), 438 deletions(-)
 copy lib/s390x/{sie.h => asm/sie-arch.h} (81%)
 copy s390x/{cpu.S => cpu-sie.S} (56%)
 create mode 100644 s390x/snippets/Makefile

-- 
2.43.0



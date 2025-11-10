Return-Path: <kvm+bounces-62530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 27CEFC484AD
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:23:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 999FA4F01FD
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 17:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45F6D293C4E;
	Mon, 10 Nov 2025 17:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Nev/A3NH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E701826C39F;
	Mon, 10 Nov 2025 17:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762795064; cv=none; b=tOEoUfvtqXRlXakuG9H76nlG/C6jj5pfq4Vc24DYcBKNnX0J2JHyNy8ZuUtOvZZWo978EaeckoKiEnnFpouMzwbUe66lkv5wxX7yZg0MOikmW9/MVqx8bVeKjoyHaxLxws2+gf1ZzT+zcZ3Zv0osnEKI63fGTBEHgDwBAsdI8uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762795064; c=relaxed/simple;
	bh=lI/nEJMJODueKUd5QjWmkX1Ilbm4jrdu6TAToCeWiIM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=lGNqzvuzxG+hn/FChTSmWj14mpLuoUblECKvDuhMrJTaWLM7gztzIFx8jQmZZNyLZ/bDy9u3GteR2TFvkfu3oXxMnQCn5WKI9fR86FUt+sacEzc4OMcl4MeOqmb0RbfTVOerEJM8YuiZlxHpDwivdi0R3iFDm1rfeKifCQhChPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Nev/A3NH; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AADa9Zm031615;
	Mon, 10 Nov 2025 17:17:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=1fq6WfH10IaQNhmm2T2SUVeF3/pC
	3vtE1lqeoOp+9ic=; b=Nev/A3NHzDCO+QTE6NBTTxapfu6ZOCE2mgYCOG/Gy9NQ
	C78zJRFY8gHlmhE94HrQyh7O1liZN3N/yO/Izl69gbimpsixOupgckq3CJgSYMYt
	+FPKDjTbH0Ut3/RhaXhU5US15ttLsrmMZz+z+pi+rqn3KZwb8MZsRri+gO1yc9gr
	WwbHrTVDS3UAz8X5+X6ic6Frxbu4ysaS6TkparmxYCeAtX3YgTUhpaOf3XbKishC
	HiS78K69LSGWRzrcrp3uH9OcqP76OheI2srLVfs1TMtFHsNzKFPMhOF2fuP6c/1W
	YAJOeppu2O82FTaAvr1RWWexiQg4bRCXvp9VAnFTiw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wk81c3t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 17:17:37 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAGbcMc011437;
	Mon, 10 Nov 2025 17:17:36 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aajw16emn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 17:17:36 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AAHHWl816450000
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 17:17:32 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 99D9620043;
	Mon, 10 Nov 2025 17:17:32 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0E40120040;
	Mon, 10 Nov 2025 17:17:32 +0000 (GMT)
Received: from [192.168.88.52] (unknown [9.111.69.239])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 10 Nov 2025 17:17:31 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
Subject: [PATCH RFC v2 00/11] KVM: s390: Add VSIE SIGP Interpretation
 (vsie_sigpif)
Date: Mon, 10 Nov 2025 18:16:40 +0100
Message-Id: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPgdEmkC/02Pz07DMAyHX6XymVT517TrCQmJB+CKdkg8l1msL
 SRdNDTt3UnLNHG0/fPnz1dIFJkS9NUVImVOPE+l0E8V4NFPHyT4UGrQUjdS607kxMQkZBvI2AH
 NrrNQwl+RBr5soHd4e32BfWkeOS1z/NngWW2jjWPUg5OVkMJZpwakwViln088nS81h7HGeYT97
 Q8e6ftc5Jb7hYdbUV2JjTIijiIk9MIHRZ2zO4++7XML/1+5x53Ua3xNn2b8FIcWFaHXjQ6qz3p
 dCT6RKAYjL32VXV2UIzbF5/YLIWuwoTQBAAA=
X-Change-ID: 20250228-vsieie-07be34fc3984
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2689;
 i=schlameuss@linux.ibm.com; h=from:subject:message-id;
 bh=lI/nEJMJODueKUd5QjWmkX1Ilbm4jrdu6TAToCeWiIM=;
 b=owGbwMvMwCUmoqVx+bqN+mXG02pJDJlCclrM+jsj9jc31Lfq+G786lG2oLac9f+W0mTm6oCzH
 d6rf1d1lLIwiHExyIopslSLW+dV9bUunXPQ8hrMHFYmkCEMXJwCMJF76owMczZqRK22NLvAv4Kr
 WSuG661e+GungshL+WeF1q7cVHKngOF/ZWmrbME15QmPf7DFLtJJ7jSumX3sxb4ZGdN1fjotFQh
 mBAA=
X-Developer-Key: i=schlameuss@linux.ibm.com; a=openpgp;
 fpr=0E34A68642574B2253AF4D31EEED6AB388551EC3
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAyMiBTYWx0ZWRfX4QAirXkGE2xr
 6U9pd64uovsGgmuDoee19tIVwZBVAloNzkWIJmye8x6BvtzUd3OkBcY4D7FIrLnrJm+rLuKxIfn
 kC/p7zS6Z5O+bDoVJlBore1fJ5SAVm8mHwiyBn0E/BMsxF5XvuAAr/tkOxhVKOblsO8OX0NpUgh
 Illf8CLUO81tERelTPXnEObhiiAWEronYoKChLEERQlMA2ivsir2Sj8/ebeiNg8KB5G6tWvjLNM
 qy/dqIQPgviQAsdHrkbn+ZNj8+CHwLAr4DFFUzHIQkdNxExqfgrdA8BmyKc5HF8QCDSce0JT3Qe
 7r3ZS8NL8Sa2ymcgt7b7yyboG8+rd/P819eYXxumgqZCw+aOwd1uRYZvilYjjFwASvULKi0mMt8
 RNHA48qmeHqI+++MyBvY+CZciVWMBA==
X-Authority-Analysis: v=2.4 cv=ZK3aWH7b c=1 sm=1 tr=0 ts=69121e31 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=p1OOIYIeqOTM9QzR76EA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: GXgFPiZLJTkiecBGAyBN4DT_FdF-0-tB
X-Proofpoint-GUID: GXgFPiZLJTkiecBGAyBN4DT_FdF-0-tB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_06,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0 adultscore=0
 clxscore=1011 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511080022

In the upcoming IBM Z machine generation (gen17) the s390x architecture
adds a new VSIE Interpretation Extension Facility (vsie_sigpif) to
improve guest-3 guest performance.

To exploit the new machine support the guest-1 KVM needs to create and
maintain shadow structures pointing to the original state descriptions
and system control areas of currently running guest-3 configurations.
These pointers are followed by the machines firmware and modifications
of the original SCA for guest-3 (located in guest-2) are monitored and
handled by firmware. This results in fewer VSIE exits.

---
There are still some problems with the current state but I think it is
in a good state to gather some feedback.

Known Functional Problems:
- reuse of sca allocation with sigpif enabled does hang

Known Non-Functional Problems:
- Performance of the initial configuration shadowing can be streamlined
- Performance for reentry can likely be improved
- Locking can be improved to allow for more concurrency

---
Christoph Schlameuss (11):
      KVM: s390: Add SCAO read and write helpers
      KVM: s390: Remove double 64bscao feature check
      KVM: s390: Move scao validation into a function
      KVM: s390: Add vsie_sigpif detection
      KVM: s390: Add ssca_block and ssca_entry structs for vsie_ie
      KVM: s390: Add helper to pin multiple guest pages
      KVM: s390: Shadow VSIE SCA in guest-1
      KVM: s390: Allow guest-3 cpu add and remove with vsie sigpif
      KVM: s390: Allow guest-3 switch to extended sca with vsie sigpif
      KVM: s390: Add VSIE shadow configuration
      KVM: s390: Add VSIE shadow stat counters

 arch/s390/include/asm/kvm_host.h               |  16 +-
 arch/s390/include/asm/kvm_host_types.h         |  24 +-
 arch/s390/include/asm/sclp.h                   |   1 +
 arch/s390/kvm/kvm-s390.c                       |  14 +-
 arch/s390/kvm/kvm-s390.h                       |   2 +-
 arch/s390/kvm/vsie.c                           | 852 +++++++++++++++++++++----
 drivers/s390/char/sclp_early.c                 |   1 +
 tools/testing/selftests/kvm/include/s390/sie.h |   2 +-
 8 files changed, 773 insertions(+), 139 deletions(-)
---
base-commit: 62ad2b01b0c7dba966c6843b77e99b06a3b12d27
change-id: 20250228-vsieie-07be34fc3984
prerequisite-change-id: 20250513-rm-bsca-ab1e8649aca7:v7
prerequisite-patch-id: 52dadcc65bc9fddfee7499ed55a3fa909051ab1c
prerequisite-change-id: 20250602-rm-sca-lock-d7c1eca252b1:v2
prerequisite-patch-id: 52dadcc65bc9fddfee7499ed55a3fa909051ab1c
prerequisite-patch-id: 7117176d5763754fc7c1474288bcbe4de567c60e

Best regards,
-- 
Christoph Schlameuss <schlameuss@linux.ibm.com>



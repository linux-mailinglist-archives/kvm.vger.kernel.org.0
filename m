Return-Path: <kvm+bounces-36898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF949A22AB6
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 10:51:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B2C118881DE
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 09:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F1C01B87F8;
	Thu, 30 Jan 2025 09:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ax7gnmzO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF581B6CF1;
	Thu, 30 Jan 2025 09:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738230688; cv=none; b=j1EtjzRpe9vN4b9V9xJEcn23XORRqMxUfSqt0vYtfxnBVtPGsaLK6iql2dzxUV1LE80Cf3fRvWeWkEGCjj/xzKMSmyeYLb/cHVEQ2F0b9OWv2Ik1jpGZoKF2NIHE2GPRYn8g/0XMtGpDAIafKtwo4YvYW4sPzSYbOQN+Gbxdou0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738230688; c=relaxed/simple;
	bh=2Frmzlw4NrJiTYTMu/LFc95YKkr+hFZDALstqqKTFXk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UVrIxKnhIrQ9cwEmlUMAMehWPZ+VTN4UdmMVjMjHoT1SRYYiDypr2dDX+gEGQ+BxX6SXxxCsPuTbTM3Sg6Rn0aZVKzjyJangPOUYxsdwTFZWKEo4AygzOuzEEbawyX76qproPcYpZGqZ2bcuJ4YX/colBECLQR/A17xBvCmmbpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ax7gnmzO; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50U20ZnJ019516;
	Thu, 30 Jan 2025 09:51:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=YEbIFVWBf1kUTHaNQSbTTnDo/VnvtI3uVUBN2k0qt
	BI=; b=ax7gnmzORBi7BAPCu0LGuiKHQ+JRnUgfE4Au8jxwLydYqWAan2esPbyTX
	lEvOCsOadzBCff2zmtC1rQf428nPo4VdIVmoE6LdsZl6UqB5QUC7vBanlZ4CCYkn
	9caFrEkRY5Ah+0CS7elBhS9BfDpcvzY7autUMu/txOsOg5J3ohaSdDPJo7n5CCpi
	B3plDOC1Ecpcc8EEPFlJ7De6kcrdSSUJNdZMfznfov4m/T8iuBzGV6LNowFTtwUo
	6/rRy8m21FB16XjVaK/LTR+pTBSTB7Z1ahXN85hLAfgCGvwRYDoSyiv5JS2vLDpi
	9yvkKROo9kWrfHUIcRwlei0NfE1Jg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44g08ysnnb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jan 2025 09:51:24 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50U93qXH022172;
	Thu, 30 Jan 2025 09:51:23 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44dcgjw7ds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jan 2025 09:51:23 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50U9pJfq34734420
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jan 2025 09:51:19 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7701820145;
	Thu, 30 Jan 2025 09:51:19 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 50A4320147;
	Thu, 30 Jan 2025 09:51:19 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jan 2025 09:51:19 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, david@redhat.com
Subject: [GIT PULL v1 00/20] KVM: s390: some non-trivial fixes and cleanups for 6.14
Date: Thu, 30 Jan 2025 10:50:53 +0100
Message-ID: <20250130095113.166876-1-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PVnUXfTE7rnko1fT64ARMl8pzPw4Pp-5
X-Proofpoint-ORIG-GUID: PVnUXfTE7rnko1fT64ARMl8pzPw4Pp-5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-30_05,2025-01-29_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 mlxlogscore=566 lowpriorityscore=0 mlxscore=0
 impostorscore=0 phishscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501300069

Ciao Paolo,

please pull the following changes:

- some selftest fixes
- move some kvm-related functions from mm into kvm
- remove all usage of page->index and page->lru from kvm
- fixes and cleanups for vsie


The following changes since commit 72deda0abee6e705ae71a93f69f55e33be5bca5c:

  Merge tag 'soundwire-6.14-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/vkoul/soundwire (2025-01-29 14:38:19 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-6.14-1

for you to fetch changes up to 8bc53739bc8f26c3418ca17a7dbe030bce22a60d:

  KVM: s390: selftests: Streamline uc_skey test to issue iske after sske (2025-01-30 08:49:54 +0100)

----------------------------------------------------------------
- some selftest fixes
- move some kvm-related functions from mm into kvm
- remove all usage of page->index and page->lru from kvm
- fixes and cleanups for vsie

----------------------------------------------------------------
Christoph Schlameuss (1):
      KVM: s390: selftests: Streamline uc_skey test to issue iske after sske

Claudio Imbrenda (14):
      KVM: s390: wrapper for KVM_BUG
      KVM: s390: fake memslot for ucontrol VMs
      KVM: s390: selftests: fix ucontrol memory region test
      KVM: s390: move pv gmap functions into kvm
      KVM: s390: use __kvm_faultin_pfn()
      KVM: s390: get rid of gmap_fault()
      KVM: s390: get rid of gmap_translate()
      KVM: s390: move some gmap shadowing functions away from mm/gmap.c
      KVM: s390: stop using page->index for non-shadow gmaps
      KVM: s390: stop using lists to keep track of used dat tables
      KVM: s390: move gmap_shadow_pgt_lookup() into kvm
      KVM: s390: remove useless page->index usage
      KVM: s390: move PGSTE softbits
      KVM: s390: remove the last user of page->index

David Hildenbrand (4):
      KVM: s390: vsie: fix some corner-cases when grabbing vsie pages
      KVM: s390: vsie: stop using page->index
      KVM: s390: vsie: stop messing with page refcount
      KVM: s390: vsie: stop using "struct page" for vsie page

Sean Christopherson (1):
      KVM: Do not restrict the size of KVM-internal memory regions

 Documentation/virt/kvm/api.rst                   |   2 +-
 arch/s390/include/asm/gmap.h                     |  20 +-
 arch/s390/include/asm/kvm_host.h                 |   6 +-
 arch/s390/include/asm/pgtable.h                  |  21 +-
 arch/s390/include/asm/uv.h                       |   6 +-
 arch/s390/kernel/uv.c                            | 292 +---------
 arch/s390/kvm/Makefile                           |   2 +-
 arch/s390/kvm/gaccess.c                          |  44 +-
 arch/s390/kvm/gmap-vsie.c                        | 142 +++++
 arch/s390/kvm/gmap.c                             | 212 +++++++
 arch/s390/kvm/gmap.h                             |  39 ++
 arch/s390/kvm/intercept.c                        |   7 +-
 arch/s390/kvm/interrupt.c                        |  19 +-
 arch/s390/kvm/kvm-s390.c                         | 237 ++++++--
 arch/s390/kvm/kvm-s390.h                         |  19 +
 arch/s390/kvm/pv.c                               |  21 +
 arch/s390/kvm/vsie.c                             | 106 ++--
 arch/s390/mm/gmap.c                              | 681 +++++------------------
 arch/s390/mm/pgalloc.c                           |   2 -
 tools/testing/selftests/kvm/s390/ucontrol_test.c |  32 +-
 virt/kvm/kvm_main.c                              |  10 +-
 21 files changed, 990 insertions(+), 930 deletions(-)
 create mode 100644 arch/s390/kvm/gmap-vsie.c
 create mode 100644 arch/s390/kvm/gmap.c
 create mode 100644 arch/s390/kvm/gmap.h


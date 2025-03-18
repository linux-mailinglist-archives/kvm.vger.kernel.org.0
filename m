Return-Path: <kvm+bounces-41438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D50DA67C6B
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 19:59:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 811241760C2
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 18:59:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19692213232;
	Tue, 18 Mar 2025 18:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lc3lnRkS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B621F1CF5E2;
	Tue, 18 Mar 2025 18:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742324386; cv=none; b=Wal2gM9WOvSPxQ92BtAUVPo4KGWhYGuqpQ+TMmJm75H+fo88t9Fpkc0uEeVgMFsEKCi6nC5KPDzuBSGhnSNrh9PB2i2srdmBWzrRVQ8l2TjJE1NHyBmXxVbvRDolBv6XEZCoyx0U3ahwdG3imAF98Zbkpkw03tG2LFdVuRy6tZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742324386; c=relaxed/simple;
	bh=p0pB3bI52Cxr9pwO2nW1IzVzgYHt2aFcUCsN/6HI4Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VG9XFg32HRohB506CMR2P8vSpMKD5opb1vun2FPG4uVy6dIM1ezMEm8B2N914Gjt6m2CfHubQNl2itzFwB2MsnCML+amtBficeipcxuFT8zh5LF4uiWa33qAWmQSKQX9XN0RBfS+56bVVkcmcR9tY63t2Oy6vlzzfIOwnTF1Yx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lc3lnRkS; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52IIltD7032756;
	Tue, 18 Mar 2025 18:59:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=YYCcpaRPL+EiTWF0EUvf9mEwd1W9
	43NIqLZwEQ+pqM0=; b=lc3lnRkSe7v2HPvXRBqtL/Nnjaq6niDAuNZl5myTPmJp
	4O8EF80Tsg/9w9SLttNlY100RMm/qgajnc/m63gfyb7ahCQl9FuGzPoDPUG7OXMI
	MLZ3Pl8JLoTGwlyuWYFhtfz2f1hdLrKBUwXQj5orxGnNdqYOqanO2fQ5LqDjDzOb
	Spt3Y8GDP89/Uslg6/HH5zXXwWqHVrZbHBTuK+LkMjz+oVGZqd3wYTeeW9qXg3E5
	jY/93h3WJYbm1nVlYK9jZM/jPiUxIo1goOoDTLtVSyowi13vtsxmqbNiqfabwJee
	oyxlIW5xHB3ZbF10dSn3tccfJ2KcSwrrMYuTWyZ+dA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45ety0nr3j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Mar 2025 18:59:42 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52IGYCLX005648;
	Tue, 18 Mar 2025 18:59:41 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 45dm8ywpcu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Mar 2025 18:59:41 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52IIxb6h37290334
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 18:59:37 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A55FD20043;
	Tue, 18 Mar 2025 18:59:37 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 209DD20040;
	Tue, 18 Mar 2025 18:59:37 +0000 (GMT)
Received: from darkmoore.ibmuc.com (unknown [9.171.51.150])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 18 Mar 2025 18:59:37 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-s390@vger.kernel.org
Subject: [PATCH RFC 0/5] KVM: s390: Add VSIE Interpretation Extension Facility (vsie_sigpif)
Date: Tue, 18 Mar 2025 19:59:17 +0100
Message-ID: <20250318-vsieie-v1-0-6461fcef3412@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20250228-vsieie-07be34fc3984
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MtlKR4m_ZXt0tifIzkfu-4D5x30-5XsW
X-Proofpoint-ORIG-GUID: MtlKR4m_ZXt0tifIzkfu-4D5x30-5XsW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-18_08,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 suspectscore=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2503180137


In the upcoming IBM Z machine generation (gen17) the s390x architecture
adds a new VSIE Interpretation Extension Facility (vsie_sigpif) to
improve guest-3 guest performance.

To exploit the new machine support the guest-1 KVM needs to create and
maintain shadow structures pointing to the original state descriptions
and system control areas.
These pointers are followed by the machines firmware and modifications
of the original SCA in guest-3 are monitored and handled by firmware.

---
Christoph Schlameuss (5):
      KVM: s390: Add vsie_sigpif detection
      KVM: s390: Add ssca_block and ssca_entry structs for vsie_ie
      KVM: s390: Shadow VSIE SCA in guest-1
      KVM: s390: Re-init SSCA on switch to ESCA
      KVM: s390: Add VSIE shadow stat counters

 arch/s390/include/asm/kvm_host.h               |  44 +++-
 arch/s390/include/asm/sclp.h                   |   1 +
 arch/s390/kvm/kvm-s390.c                       |   5 +
 arch/s390/kvm/vsie.c                           | 285 ++++++++++++++++++++++++-
 drivers/s390/char/sclp_early.c                 |   1 +
 tools/testing/selftests/kvm/include/s390/sie.h |   2 +-
 6 files changed, 333 insertions(+), 5 deletions(-)
---
base-commit: 4701f33a10702d5fc577c32434eb62adde0a1ae1
change-id: 20250228-vsieie-07be34fc3984

Best regards,
-- 
Christoph Schlameuss <schlameuss@linux.ibm.com>


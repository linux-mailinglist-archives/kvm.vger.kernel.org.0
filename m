Return-Path: <kvm+bounces-37112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0766BA2548E
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:38:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2351B162417
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 08:38:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BDDB207DF3;
	Mon,  3 Feb 2025 08:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="H95J1i5T"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C1C20766C
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 08:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738571810; cv=none; b=QrYA2W9Uao6tqCpx2tWzbvn0MDuZ29iKC+JdShWLadO8Sj3TgsXP8rw25wQ8wqaTKUUVeGn5Tn1gwKTnrFSLgYrR9PiJLsuCyKNui4P0jXfhd7msziwHHjFTcCagcASEvdEHDLT5FhS8aou+TrEYedtd09pzb/kETM0dIUAZDZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738571810; c=relaxed/simple;
	bh=LznEXqgR9tVR2hA1p9YnoLGgu5w7CGsfML1+Rr8ABzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KIUxal+O71soaHqKenc0bPkvfKs7p2jDhVZi7lHod/16suk6iJ9jP5aKuVlGZQTh7c9jIVHATbEuAf87fN8uS5r8b6UkWd0j9NMDfYky0AkLbrQTGjkxiNX/HGQlNFA/54AHQxtF6VZ70udpsoxJh7bEw/5Ucc0c8oINhrk/X7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=H95J1i5T; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51318Tck027273;
	Mon, 3 Feb 2025 08:36:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=fn2MbfMHxrsTEH1qS
	3fO4eZGX6GDX4vBjCzWaX3YL88=; b=H95J1i5TYe8jxqPXq2olgPypqg/7utfHn
	Fzt67c4JCRIIuXBBHPlrxG3wJKluRS8Bhl9xcfJGii/V5mISVTUJCEXs3Z096NhS
	u8rx9obLYwT1hzcnE4FB9xGxhZlhmxdKCoArQJpdjC9jCsl+nPYKWqriF+jPgOUL
	1dzxxu5Q1K1Exk5Jqi3lxHKwmlVofxpZ6gosTIswFtBmbsve0V2RcKyWrirQaDXf
	ZKm2i/aZ9PO7SoCAUS9isew+fu/1OVmgn54wjeXNKElfcRlRauaCFpqc4I346xKg
	MCariB1kBX1nrAHlzFgzNg7whYrO0abCTkX9oKjxb7ZL92xwLpekw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44jkv91n9s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:38 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5137A87A016280;
	Mon, 3 Feb 2025 08:36:37 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44hwxs5kub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:37 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5138aYEA42140008
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Feb 2025 08:36:34 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0022520040;
	Mon,  3 Feb 2025 08:36:34 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7CF6520043;
	Mon,  3 Feb 2025 08:36:33 +0000 (GMT)
Received: from t14-nrb.lan (unknown [9.171.84.16])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Feb 2025 08:36:33 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 18/18] s390x/Makefile: Add auxinfo.o to cflatobjs
Date: Mon,  3 Feb 2025 09:35:26 +0100
Message-ID: <20250203083606.22864-19-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250203083606.22864-1-nrb@linux.ibm.com>
References: <20250203083606.22864-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xqeCVZkZA2mfIF0GP6QvOZHbCCFPlSTQ
X-Proofpoint-ORIG-GUID: xqeCVZkZA2mfIF0GP6QvOZHbCCFPlSTQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_03,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502030068

From: Marc Hartmayer <mhartmay@linux.ibm.com>

This makes sure that the file is removed in case of `make clean` as the top
Makefile cleans all objects defined in 'cflagsobjs'.

AFAICT, the computed sh256sum values of the generated .elf and .bin files
did not change.

Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20250128100639.41779-3-mhartmay@linux.ibm.com
[ nrb: remove "Note" in commit msg since it looked like a tag ]
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/s390x/Makefile b/s390x/Makefile
index eb3d5431..47dda6d2 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -96,6 +96,7 @@ LDFLAGS += -Wl,--build-id=none
 asm-offsets = lib/$(ARCH)/asm-offsets.h
 include $(SRCDIR)/scripts/asm-offsets.mak
 
+cflatobjs += lib/auxinfo.o
 cflatobjs += lib/util.o
 cflatobjs += lib/alloc.o
 cflatobjs += lib/alloc_phys.o
-- 
2.47.1



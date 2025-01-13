Return-Path: <kvm+bounces-35310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AE6F6A0BEE5
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 18:31:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4D5567A10E8
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 17:31:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 226571BD9C1;
	Mon, 13 Jan 2025 17:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BO/QF2TM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39251AAA3D;
	Mon, 13 Jan 2025 17:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736789461; cv=none; b=PqqTzcsk6sMnuztPgB9nlqC+wGGU18/je94T+FperWIlr/caO1s8GtKqZie3aYVmfht3iHtbMB54XR9eG8ak+Y9Ag7aaTd6TUaNHvdxBa+1xkRXYE4dKuXRdR1i2MhFEON2WFL42NOg0MUUYJx0krdI2ltgrqGeRKYTPYswuVGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736789461; c=relaxed/simple;
	bh=CJDTD91NwB58SF9b13WK+duuxiRgu3sEyCBeb2I1DvU=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=WizX2u6eplaEaxoQKvKuN1WGK9YPBwBl2sapQY+bidqSfuKxrfzw66rkGJXZiZGvirGddVPvjMPlM5x+6i/q0bXGfnYXEDDtZOhuZgcnkZNwSwd1OVHkCJstnvDpyK+Sil1xsLgrgLSrEEs37wTeMl1twCMCE1BW43pyzZcGbIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BO/QF2TM; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50DE70oS020899;
	Mon, 13 Jan 2025 17:30:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=tbllvC
	fsBS60ycTEFMX3aBw/CjsDHL2pea8FntFTRlQ=; b=BO/QF2TMV5nKKv2CEy5ysY
	DstV8MhApTEsvnJC87wSf87Ef3bLZ/7aadrXmdVnhfAuejwkCDNqETitC55N8GzJ
	Ha4vdEbB4mioVOTlkhNjYMTmGD6SoBj0cSaEBIdUpt3T/EwtGOa1+HWsrqbyGVlo
	2uQk0NwS8ruGUiTcGev/KUvkXVAC6u8jSXdr3Xgu5dhKujVi9dqkNPtJLPpRpF64
	Bm7M9ODyx57zHv1anRqe4Dztjdj2oVzdBUJ9khHvkARFBq4STfI7hGjjBvzioHaO
	i4Diluj+7ZZt4nyNsWTWqkwqPAfKzZkZn2hYbqelKCYzqLw1kL2aPCmreEpE/MwA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4454a58ysf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jan 2025 17:30:53 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50DHTZZS010972;
	Mon, 13 Jan 2025 17:30:53 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4454a58ysd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jan 2025 17:30:53 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50DFqnJZ004540;
	Mon, 13 Jan 2025 17:30:52 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4442ysfgn0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jan 2025 17:30:52 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50DHUm6T55902584
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jan 2025 17:30:49 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E394D2004B;
	Mon, 13 Jan 2025 17:30:48 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B559520040;
	Mon, 13 Jan 2025 17:30:48 +0000 (GMT)
Received: from darkmoore (unknown [9.171.41.227])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 13 Jan 2025 17:30:48 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 13 Jan 2025 18:30:43 +0100
Message-Id: <D714H3L41ZMM.1R3UEQ00HD8XG@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Tao Su"
 <tao1.su@linux.intel.com>,
        "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        "Christian Borntraeger" <borntraeger@de.ibm.com>,
        "Xiaoyao Li"
 <xiaoyao.li@intel.com>
To: "Sean Christopherson" <seanjc@google.com>,
        "Paolo Bonzini"
 <pbonzini@redhat.com>
Subject: Re: [PATCH v2 0/5] KVM: kvm_set_memory_region() cleanups
X-Mailer: aerc 0.18.2
References: <20250111002022.1230573-1-seanjc@google.com>
In-Reply-To: <20250111002022.1230573-1-seanjc@google.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fe0F3bi9aFx8-5ygAGQCLFHmzx0KE_dM
X-Proofpoint-ORIG-GUID: PbwdJFwfjyjXZ29pYru1nrgEBE4ayf1i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 mlxlogscore=827 spamscore=0 impostorscore=0
 clxscore=1011 lowpriorityscore=0 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501130141

On Sat Jan 11, 2025 at 1:20 AM CET, Sean Christopherson wrote:
> Cleanups related to kvm_set_memory_region(), salvaged from similar patche=
s
> that were flying around when we were sorting out KVM_SET_USER_MEMORY_REGI=
ON2.
>
> And, hopefully, the KVM-internal memslots hardening will also be useful f=
or
> s390's ucontrol stuff (https://lore.kernel.org/all/Z4FJNJ3UND8LSJZz@googl=
e.com).

Whole series:

Acked-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

>
> v2:
>  - Keep check_memory_region_flags() where it is. [Xiaoyao]
>  - Rework the changelog for the last patch to account for the change in
>    motiviation.
>  - Fix double spaces goofs. [Tao]
>  - Add a lockdep assertion in the x86 code, too. [Tao]
>
> v1: https://lore.kernel.org/all/20240802205003.353672-1-seanjc@google.com
>
> Sean Christopherson (5):
>   KVM: Open code kvm_set_memory_region() into its sole caller (ioctl()
>     API)
>   KVM: Assert slots_lock is held when setting memory regions
>   KVM: Add a dedicated API for setting KVM-internal memslots
>   KVM: x86: Drop double-underscores from __kvm_set_memory_region()
>   KVM: Disallow all flags for KVM-internal memslots
>
>  arch/x86/kvm/x86.c       |  7 ++++---
>  include/linux/kvm_host.h |  8 +++-----
>  virt/kvm/kvm_main.c      | 33 ++++++++++++++-------------------
>  3 files changed, 21 insertions(+), 27 deletions(-)
>
>
> base-commit: 10b2c8a67c4b8ec15f9d07d177f63b563418e948



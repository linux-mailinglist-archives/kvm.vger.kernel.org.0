Return-Path: <kvm+bounces-36020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1688DA16EB7
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 15:45:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE9151882236
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 14:45:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D27701E3DD3;
	Mon, 20 Jan 2025 14:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HY6/Nl3l"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB5D1E377D;
	Mon, 20 Jan 2025 14:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737384290; cv=none; b=c4wCVQxT8lD1Irdesrb+sk+uIRUZ25Ze9NOcyRgTEMZSKn+1FXtrk9su2OOtWWZ4cPpm95g3ao4QcgWN0au/vxagBZmFy/08R7U9wh6aZu8v2sODgQORFOVbgHbaEnxqgjt6WHTKuJsqXbbwPMctGQDQsSJI3n1PYpjak7Lo14Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737384290; c=relaxed/simple;
	bh=bOmMoBat1CWb5QLTa8XXZYmdpHtthhXXObwXhg5vBac=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=VQzVbDCFZskBmSowNkbr8Uh/rsTt8+ByT5X8zP948OEBGf4huAurzNgi0aW8jA9Ljvgo9ha8iiAIaG+i4jJYdd63VvVwbihsHAxqMqv8S3l3Y47QBRgG0UvxxxQ8I3lGf7XGnZxdkqFU3swhwJDah5K9BAbvhWYyasWAha8xcVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HY6/Nl3l; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50K9GSdN008671;
	Mon, 20 Jan 2025 14:44:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=0aS6LO
	W8zPzOBD6RH+XCagFp3AAo0WRcl0veVy398w4=; b=HY6/Nl3lBzBUiyHccly7p1
	H5QnW495S7RiI7qjvJkxG/sA1OS4i7oMmilGH5WgH4iQgnN5c3DvZ5ibOTNmDZMT
	CuOAbSgAgNhnbca6o/WirizZV1GLRt/3ks+YM7dZJ6XSYe25oG7lpFICSRWA/1jv
	MHnhIukEEnARKday24zdptGQcwsI2IUjqzbJ0WBu9QlkAC+SB+HkvI2gPvlXA1r3
	uWNoRyR2TrjVOmF0U5JoPjKBhqbEccCVfAhhuSmlRdYW2jKdxozuuCSSm1OQc/Sz
	mUCPDrk03t2IAS5BLoM8XnqvI6/t9F98PYFNQ2eHf7bk0k1uZqzNLntXEumMoqew
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44947svgqv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 14:44:44 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50KEdTY3017563;
	Mon, 20 Jan 2025 14:44:44 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44947svgqt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 14:44:44 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50KB4D4D024225;
	Mon, 20 Jan 2025 14:44:43 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 448q0xxx67-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 14:44:43 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50KEidQC54198778
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Jan 2025 14:44:39 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5A68520067;
	Mon, 20 Jan 2025 14:44:39 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 32F7C2004E;
	Mon, 20 Jan 2025 14:44:39 +0000 (GMT)
Received: from darkmoore (unknown [9.171.4.105])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 Jan 2025 14:44:39 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 20 Jan 2025 15:44:33 +0100
Message-Id: <D76ZBOXNTIGF.3D0BBERDWTY2C@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Paolo Bonzini"
 <pbonzini@redhat.com>,
        "Tao Su" <tao1.su@linux.intel.com>,
        "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>,
        "Christian Borntraeger"
 <borntraeger@de.ibm.com>,
        "Xiaoyao Li" <xiaoyao.li@intel.com>
To: "Sean Christopherson" <seanjc@google.com>
Subject: Re: [PATCH v2 3/5] KVM: Add a dedicated API for setting
 KVM-internal memslots
X-Mailer: aerc 0.18.2
References: <20250111002022.1230573-1-seanjc@google.com>
 <20250111002022.1230573-4-seanjc@google.com>
In-Reply-To: <20250111002022.1230573-4-seanjc@google.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lE2xijtsZ4sWaaOmO4YxWpW9HH5o_MW9
X-Proofpoint-ORIG-GUID: MGDp5MVbtsXQcwr_arLoX8pu0hZ8wHgM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-20_03,2025-01-20_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=598
 malwarescore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 phishscore=0 adultscore=0 spamscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501200120

On Sat Jan 11, 2025 at 1:20 AM CET, Sean Christopherson wrote:
> Add a dedicated API for setting internal memslots, and have it explicitly
> disallow setting userspace memslots.  Setting a userspace memslots withou=
t
> a direct command from userspace would result in all manner of issues.
>
> No functional change intended.
>
> Cc: Tao Su <tao1.su@linux.intel.com>
> Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/x86.c       |  2 +-
>  include/linux/kvm_host.h |  4 ++--
>  virt/kvm/kvm_main.c      | 15 ++++++++++++---
>  3 files changed, 15 insertions(+), 6 deletions(-)

[...]

> +int kvm_set_internal_memslot(struct kvm *kvm,
> +			     const struct kvm_userspace_memory_region2 *mem)
> +{
> +	if (WARN_ON_ONCE(mem->slot < KVM_USER_MEM_SLOTS))
> +		return -EINVAL;
> +

Looking at Claudios changes I found that this is missing to acquire the
slots_lock here.

guard(mutex)(&kvm->slots_lock);

> +	return __kvm_set_memory_region(kvm, mem);
> +}
> +EXPORT_SYMBOL_GPL(kvm_set_internal_memslot);
> =20
>  static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
>  					  struct kvm_userspace_memory_region2 *mem)



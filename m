Return-Path: <kvm+bounces-35287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C2876A0B62A
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 12:57:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0F691886833
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 11:57:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4F14204581;
	Mon, 13 Jan 2025 11:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ViVEMW6U"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA4E1C3C05;
	Mon, 13 Jan 2025 11:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736769422; cv=none; b=SMcy853743IizQYZSHgG4cBDiy5aEIYlDgPbsxNrB3svRBsU/ClmDXEftFFaPJVOXbfB+mplbdbQzFkD703RhnXk8elc6MpvN488L/+U+eWWQcxFxUz16Rs4OKwSrCQc78obsbw67vblibWhFG3rGDH5bpSgwgQRGVnzfZUwJpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736769422; c=relaxed/simple;
	bh=TJugCJ3kzNIo/HDQHaZAzQIdQoBg+3ZeSf6WKPoWlEY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q0QvmmiN0FZG4yNOJvXm1EI/EYUntwhJu0l1bKYu7VXD64vsivmOPuZg37DOzXAompIb2+bsBRyReuvl+OfzibQ2oVR4tv1I46P+cu5d9IDLetEPAL6tBjaAEdmO2EOML+dQp9dAONa/oNMI32ll5RzEVy7qOR74Uu+4E5RISPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ViVEMW6U; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50D85Z05000367;
	Mon, 13 Jan 2025 11:56:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Nqsecq
	5L+vlRAmD/KiYp0sdVBMKVD3lskC1lk0yqwPY=; b=ViVEMW6U+aeeTUvBiwq9Ru
	DBaER3WEzsHtQD5FmbnZd5ifMhHz90VHDWTG2YQqO4vs+cwki/nooi99LoU6FHCj
	+KjOelYtLHE8iQXI//7ugzAt3TmJsvG39oxiKSmfnXCFPq+eyu7Rfn/y3L68Bm7l
	VbmWnvgzN8HV/EaEczrWRpjBXv/lAbG+jHDnH0AabzC+qCs5Ta1PtKdOEXFbx3EZ
	lqQoEYV4UB3qBGy9HEqEMgeQXHdmPIx8vVbmGNcOhs9JJbdMwObQpLnIQMIoNieP
	NE6fqKZHsBRBz8guHNYv4L3EMre3bJEqg4yFXqENpIL+HL5oZpXwePCjIpdEp38w
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 444y12gw2u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jan 2025 11:56:56 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50DButOF017513;
	Mon, 13 Jan 2025 11:56:55 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 444y12gw2t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jan 2025 11:56:55 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50DBl8Av004571;
	Mon, 13 Jan 2025 11:56:55 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4442yse5xd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jan 2025 11:56:54 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50DBurLU53084462
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jan 2025 11:56:53 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 526392004B;
	Mon, 13 Jan 2025 11:56:53 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1400820043;
	Mon, 13 Jan 2025 11:56:53 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 13 Jan 2025 11:56:53 +0000 (GMT)
Date: Mon, 13 Jan 2025 12:56:51 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tao Su <tao1.su@linux.intel.com>,
        Christian
 Borntraeger <borntraeger@de.ibm.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v2 0/5] KVM: kvm_set_memory_region() cleanups
Message-ID: <20250113125651.3955b342@p-imbrenda>
In-Reply-To: <20250111002022.1230573-1-seanjc@google.com>
References: <20250111002022.1230573-1-seanjc@google.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dLNul5mqQs405cOZCQ67Q-hSW5pf0YC5
X-Proofpoint-GUID: Ww8GQPwLx60HZ7c0NG4u7XVdp4eKAwmw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 clxscore=1011 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501130097

On Fri, 10 Jan 2025 16:20:17 -0800
Sean Christopherson <seanjc@google.com> wrote:

> Cleanups related to kvm_set_memory_region(), salvaged from similar patches
> that were flying around when we were sorting out KVM_SET_USER_MEMORY_REGION2.
> 
> And, hopefully, the KVM-internal memslots hardening will also be useful for
> s390's ucontrol stuff (https://lore.kernel.org/all/Z4FJNJ3UND8LSJZz@google.com).

whole series:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

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



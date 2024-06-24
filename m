Return-Path: <kvm+bounces-20410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B07E791528B
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 17:34:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 40D7C1F249AB
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 15:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 529BA19D08B;
	Mon, 24 Jun 2024 15:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pT3MAgxs"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B7419CD0B;
	Mon, 24 Jun 2024 15:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719243216; cv=none; b=nsHwDtf8up+2FiYlUs1wK/Ad5rajkavot+U8HQqZuerKr2ryk/OmyehMgkBWgk39wMr3wnhC/TBkuwXI/E8lPaKGRpo7Cv5kXOyK5J8hrhI/n9C0YYP0ThVJZLeEE5FkWkKK0YHGrPngVUoPPjteZK/Hbk3VTtRHc08Y57g3lrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719243216; c=relaxed/simple;
	bh=5ykkTM3tDcbuQoWGhaZLK27SIENhfMfemlid8CPn4Kg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mRD0uA/z20ztWVxIk76eXwuwKxx8AKX5TzIPf+s1YfUTCOc3d1em7MEjChI/EnVb+QlbGVis/1LVM4FcDzW6N0ZYEQYRC+BE+kBswfbzp1AMTNDHSOfKDkNQ+ezaFTDbDvagppo1igPl3i1r4zNyEV1ZduGJ0CZiERL7d51bzm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pT3MAgxs; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45OFWthF023432;
	Mon, 24 Jun 2024 15:33:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	DwKF700X7v7NDl8u9rp3XuBAKSkCRL78vee6uDoYhZs=; b=pT3MAgxsueUWoawV
	sWNaK4n24wRXLrEhgjGBi5zyCQ4vlV5ljyiV33kfo1X8/rFfHgBy1isr+DkjXgf/
	69Si6DZxC7kKvRZj4eu97ebTlkqMhfZgHLQhsG/htZyUdwEdkT/IfKmU5rGTONcF
	XWaFpkRIsgIw/vOKrQ/f5vC5LieQ56AOTe6SdJ7vLoIvIRClGXTuBXERU1FHerRU
	GaFlMPtDPf8nJ6V2mmLrJTXSoJrx8rC2MZQXYnUPAM0H6r6QnAmKyUDTrzn7IcGB
	2SRwF+fuzZ0rvIKNK+qCnPs7fMZ6MiuEdoXH3x6/oTmzNOMyGgmX8APw03V8hs95
	rZW9lg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yybhar044-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jun 2024 15:33:30 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45OFXTH8025268;
	Mon, 24 Jun 2024 15:33:29 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yybhar042-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jun 2024 15:33:29 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45OFJwi9018103;
	Mon, 24 Jun 2024 15:33:29 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yx8xu1ryy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jun 2024 15:33:28 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45OFXN0U56033664
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Jun 2024 15:33:25 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F26752004E;
	Mon, 24 Jun 2024 15:33:22 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C21E02004B;
	Mon, 24 Jun 2024 15:33:22 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Jun 2024 15:33:22 +0000 (GMT)
Date: Mon, 24 Jun 2024 17:33:21 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Christoph Schlameuss <schlameuss@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David
 Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] s390/kvm: Reject memory region operations for ucontrol
 VMs
Message-ID: <20240624173321.6b27b2a4@p-imbrenda>
In-Reply-To: <20240624095902.29375-1-schlameuss@linux.ibm.com>
References: <20240624095902.29375-1-schlameuss@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: erNYpFx8aIUkWEDaftjifnsw6_yIPEi8
X-Proofpoint-ORIG-GUID: j5cn5q80zcd2a9G4n2SbR4IvPjNl5u8H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-24_12,2024-06-24_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=866
 adultscore=0 clxscore=1015 suspectscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406240123

On Mon, 24 Jun 2024 11:59:02 +0200
Christoph Schlameuss <schlameuss@linux.ibm.com> wrote:

> This change rejects the KVM_SET_USER_MEMORY_REGION and
> KVM_SET_USER_MEMORY_REGION2 ioctls when called on a ucontrol VM.
> This is neccessary since ucontrol VMs have kvm->arch.gmap set to 0 and
> would thus result in a null pointer dereference further in.
> Memory management needs to be performed in userspace and using the
> ioctls KVM_S390_UCAS_MAP and KVM_S390_UCAS_UNMAP.
> 
> Also improve s390 specific documentation for KVM_SET_USER_MEMORY_REGION
> and KVM_SET_USER_MEMORY_REGION2.
> 
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  Documentation/virt/kvm/api.rst | 12 ++++++++++++
>  arch/s390/kvm/kvm-s390.c       |  3 +++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index a71d91978d9e..eec8df1dde06 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1403,6 +1403,12 @@ Instead, an abort (data abort if the cause of the page-table update
>  was a load or a store, instruction abort if it was an instruction
>  fetch) is injected in the guest.
>  
> +S390:
> +^^^^^
> +
> +Returns -EINVAL if the VM has the KVM_VM_S390_UCONTROL flag set.
> +Returns -EINVAL if called on a protected VM.
> +
>  4.36 KVM_SET_TSS_ADDR
>  ---------------------
>  
> @@ -6273,6 +6279,12 @@ state.  At VM creation time, all memory is shared, i.e. the PRIVATE attribute
>  is '0' for all gfns.  Userspace can control whether memory is shared/private by
>  toggling KVM_MEMORY_ATTRIBUTE_PRIVATE via KVM_SET_MEMORY_ATTRIBUTES as needed.
>  
> +S390:
> +^^^^^
> +
> +Returns -EINVAL if the VM has the KVM_VM_S390_UCONTROL flag set.
> +Returns -EINVAL if called on a protected VM.
> +
>  4.141 KVM_SET_MEMORY_ATTRIBUTES
>  -------------------------------
>  
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 82e9631cd9ef..854d0d1410be 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -5748,6 +5748,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  {
>  	gpa_t size;
>  
> +	if (kvm_is_ucontrol(kvm))
> +		return -EINVAL;
> +
>  	/* When we are protected, we should not change the memory slots */
>  	if (kvm_s390_pv_get_handle(kvm))
>  		return -EINVAL;
> 
> base-commit: f2661062f16b2de5d7b6a5c42a9a5c96326b8454



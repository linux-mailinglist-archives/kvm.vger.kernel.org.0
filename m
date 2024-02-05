Return-Path: <kvm+bounces-8033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 071BC84A106
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 18:38:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C16B1C226EC
	for <lists+kvm@lfdr.de>; Mon,  5 Feb 2024 17:38:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C052A482C6;
	Mon,  5 Feb 2024 17:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VUYpnmZq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05EC8481D8;
	Mon,  5 Feb 2024 17:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707154551; cv=none; b=aPvXc1Wta9oT9U+xJwAY9sOHD4hw1Yn0Ow0zYMGb0ufqwvVa9DCSdz1vV8bC5ogKwCzVBnDeYfnlb1yWD7e4sEA96Wy/Qbzvmcm6bZrgqii5qn1+7MT/7DdV83PLfZEhXorDdPIIiAcSxxCxIhrSV9d2hPHOnPNN8O4VrXv8An8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707154551; c=relaxed/simple;
	bh=5JFqEmkOGc/As5iC/2BClGHdvHxa1EQgvh2dI2uGnSo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=B+zPgQZrUudXwOdrfRWM3jDysTON9Nn1nAdydlvukIgjHUvDWmoSIwdFAfQ+4rS+tntldBKYvm2W7IkABZzk8uvapYCf2+pjFHnxJmOzxMlMq67mw+O2/5vScM0cOlbQ1QwOsPpnZ+PI6TUT/SAQKfdTfM9z4d8Tjwns0Rj6Z50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VUYpnmZq; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 415H73uW022996;
	Mon, 5 Feb 2024 17:35:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=/m7ENcWw8jBryuscCbgPp7hzCQ34mIrSeEoKDPRIxks=;
 b=VUYpnmZq8uYLKWiMuY+HaiWasuEGFv+Q2STxO+vIgc42uKNqAIt5sagMNivWBCcH98jn
 Ck1fQ/BFAo63duCwVrRn6I5Rz1fMwF2WBuWug0OH51SdwQnY1Y8fCb2DFa++QwxRijW1
 nA/R+4CgAcWqjlLEvR5Acj6P7ohghZiHSzvnOiBlL+cbfnrjIVpsXePI34cKk5NzJd0p
 0MUxgekfiQ6jUvlT/r6rYGEBFg7HpZyQ8m4lo/iBmUMY1plCkfxfygLVIpz2LVSX7Acu
 KUtDv4ElARcdH29vgLCiBJpv2SV4z34RVQe1hIjnSwYAHkQioBGX7cxyu2+Go039RMrt Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w337chrqx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Feb 2024 17:35:36 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 415HQ8q3032430;
	Mon, 5 Feb 2024 17:35:36 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w337chrqb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Feb 2024 17:35:36 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 415H5Sov005455;
	Mon, 5 Feb 2024 17:35:35 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3w21ak9t5r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Feb 2024 17:35:35 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 415HZWqx20316814
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 5 Feb 2024 17:35:32 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B08720043;
	Mon,  5 Feb 2024 17:35:32 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3E72C2004E;
	Mon,  5 Feb 2024 17:35:27 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.43.112.222])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon,  5 Feb 2024 17:35:26 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Mon, 05 Feb 2024 23:05:23 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: Amit Machhiwal <amachhiw@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman
 <mpe@ellerman.id.au>,
        Jordan Niethe <jniethe5@gmail.com>,
        Vaidyanathan
 Srinivasan <svaidy@linux.ibm.com>,
        "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Amit Machhiwal
 <amachhiw@linux.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: PPC: Book3S HV: Fix L2 guest reboot failure due
 to empty 'arch_compat'
In-Reply-To: <20240205132607.2776637-1-amachhiw@linux.ibm.com>
References: <20240205132607.2776637-1-amachhiw@linux.ibm.com>
Date: Mon, 05 Feb 2024 23:05:23 +0530
Message-ID: <87h6img6g4.fsf@vajain21.in.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5TnpgDh3nHIvKvMD6hFMeSDCRi2B20hH
X-Proofpoint-ORIG-GUID: uIRLN9AqnSJ7beZNDqSxnZYfllpJf0Ed
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_12,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=798 priorityscore=1501
 spamscore=0 phishscore=0 mlxscore=0 clxscore=1011 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402050134

Hi Amit,

Thanks for the patch. Minor comment on the patch below:

Amit Machhiwal <amachhiw@linux.ibm.com> writes:

<snip>

>  
> +static inline unsigned long map_pcr_to_cap(unsigned long pcr)
> +{
> +	unsigned long cap = 0;
> +
> +	switch (pcr) {
> +	case PCR_ARCH_300:
> +		cap = H_GUEST_CAP_POWER9;
> +		break;
> +	case PCR_ARCH_31:
> +		cap = H_GUEST_CAP_POWER10;
Though CONFIG_CC_IMPLICIT_FALLTHROUGH and '-Wimplicit-fallthrough'
doesnt explicitly flag this usage, please consider using the
'fallthrough;' keyword here.

However you probably dont want this switch-case to fallthrough so please
use a 'break' instead.

> +	default:
> +		break;
> +	}
> +
> +	return cap;
> +}
> +
>
<snip>

With the suggested change above

Reviewed-by: Vaibhav Jain <vaibhav@linux.ibm.com>

-- 
Cheers
~ Vaibhav


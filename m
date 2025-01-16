Return-Path: <kvm+bounces-35659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 52C06A139CF
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 13:18:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0E9B188A6D7
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 12:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDC891DE4F1;
	Thu, 16 Jan 2025 12:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qQDQfj0C"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBD31DE2CA;
	Thu, 16 Jan 2025 12:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737029896; cv=none; b=UHwsUnU41DbazoEqTipQI0BESxrKj2t409Ocye9djYz31z+oPaI4BIsNeKsp5+eoVmixHSUwo/qqAn80yaVMVPkHy8XADHGsudGuD09lRsmSsFm9M20thY6PdGp8eInBb7wLanwNoiituJeg6jFzH+O9GdNoHIAMjM4frEopmC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737029896; c=relaxed/simple;
	bh=8xGg+8JjwiceqRMkZaCdi4taDhkaMGOyaXVXe7ElnnU=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=R9U6y9u7xJGAKjlAr2X/c1FTrGtgd4iV12CVJjZgQdnjs7gD/BnNQM+P16ImVu1Mj5lhm+C+h1jTpcgo6DfKebeUEecovgr6+XkGkDVhio/+eUmP7V+vSgUwy6tWP7kgz1oMJMDekZN+fbU6tZbo7KY7lLObzQOb9BaK9dfb530=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qQDQfj0C; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50G3qaD2005777;
	Thu, 16 Jan 2025 12:18:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=7GNZKm
	sVkHiHn+HkZ+U6i2t5h/z3J9uds1v7RHrmfpk=; b=qQDQfj0CNzfuSl8gpDo4MC
	laChqEIY63f9XKgbk4otDj0yC8y6sFzzsODqHXBb6Rb1Jxu8H6HYBfVk5Dhptpqe
	YbIBuShlY3d8ysENg2Pcm8Z3PUMs6tNwZTMdmT07GiiAzbbPBnBE6B4dd0LyhzRr
	wqyytuZiKkUy8H84rrcJxB9x7Jf2CTMP8u74SSSLB+/mMD8SX66oz8TzkmTwNFpz
	3PEPOTOsW+67ow8hDGbacGa0g3vKqs1Ywoep46QlLvOf8aJtktnBvPPNxBhuNkur
	US/7jTnK2RSOTpYEZ77/fP2S1dew8zvyxNfkwSS01zXPZvg4lUVn3KgUPcg7eAMQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446tkcj6y0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 12:18:03 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50GC567p011135;
	Thu, 16 Jan 2025 12:18:02 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446tkcj6xv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 12:18:02 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50GB631X016499;
	Thu, 16 Jan 2025 12:18:01 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4445p1wd2n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jan 2025 12:18:01 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50GCHwEJ20251134
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 12:17:58 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C5A12004D;
	Thu, 16 Jan 2025 12:17:58 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E5A1C2004B;
	Thu, 16 Jan 2025 12:17:57 +0000 (GMT)
Received: from darkmoore (unknown [9.171.87.28])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 16 Jan 2025 12:17:57 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 16 Jan 2025 13:17:52 +0100
Message-Id: <D73HP785C5WW.2NO07MN6I9AST@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-s390@vger.kernel.org>, <frankja@linux.ibm.com>,
        <borntraeger@de.ibm.com>, <david@redhat.com>, <willy@infradead.org>,
        <hca@linux.ibm.com>, <svens@linux.ibm.com>, <agordeev@linux.ibm.com>,
        <gor@linux.ibm.com>, <nrb@linux.ibm.com>, <nsg@linux.ibm.com>,
        <seanjc@google.com>, <seiden@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 01/15] KVM: Do not restrict the size of KVM-internal
 memory regions
X-Mailer: aerc 0.18.2
References: <20250116113355.32184-1-imbrenda@linux.ibm.com>
 <20250116113355.32184-2-imbrenda@linux.ibm.com>
In-Reply-To: <20250116113355.32184-2-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: cCwhLJnt1ThKTIDXzUjHf840INCECcHy
X-Proofpoint-GUID: AqXyZz-mxkLeiKfe_FZxD-nd6pUl110k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_05,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 mlxlogscore=902 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2411120000 definitions=main-2501160090

On Thu Jan 16, 2025 at 12:33 PM CET, Claudio Imbrenda wrote:
> From: Sean Christopherson <seanjc@google.com>
>
> Exempt KVM-internal memslots from the KVM_MEM_MAX_NR_PAGES restriction, a=
s
> the limit on the number of pages exists purely to play nice with dirty
> bitmap operations, which use 32-bit values to index the bitmaps, and dirt=
y
> logging isn't supported for KVM-internal memslots.
>
> Link: https://lore.kernel.org/all/20240802205003.353672-6-seanjc@google.c=
om
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

> ---
>  virt/kvm/kvm_main.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a8a84bf450f9..ee3f040a4891 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1966,7 +1966,15 @@ static int kvm_set_memory_region(struct kvm *kvm,
>  		return -EINVAL;
>  	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
>  		return -EINVAL;
> -	if ((mem->memory_size >> PAGE_SHIFT) > KVM_MEM_MAX_NR_PAGES)
> +
> +	/*
> +	 * The size of userspace-defined memory regions is restricted in order
> +	 * to play nice with dirty bitmap operations, which are indexed with an
> +	 * "unsigned int".  KVM's internal memory regions don't support dirty
> +	 * logging, and so are exempt.
> +	 */
> +	if (id < KVM_USER_MEM_SLOTS &&
> +	    (mem->memory_size >> PAGE_SHIFT) > KVM_MEM_MAX_NR_PAGES)
>  		return -EINVAL;
> =20
>  	slots =3D __kvm_memslots(kvm, as_id);



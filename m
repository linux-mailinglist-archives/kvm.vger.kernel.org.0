Return-Path: <kvm+bounces-29057-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC7DE9A1F2E
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 11:56:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFBBB1C25D0D
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 09:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45CBD1DD872;
	Thu, 17 Oct 2024 09:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="F9kRHCX9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E4A1DAC9B;
	Thu, 17 Oct 2024 09:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729158855; cv=none; b=pHx6O2l78U0vtKn0NecbbvCXaor7zGvgLi/ft7VDmBvk6C9OdGdfrHjkVX/NO5cJtLIxyXF2N2/9sXlHxwDXHA9L7UHThqEwJAWAf3wtP0OwZGrZX7dMh4eyZ7onzfLtIsa4OsnAR9TgcAh8I8LgK9o+YxIRb03Z4/V3FA1h3vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729158855; c=relaxed/simple;
	bh=tTHLZwbeqBOqBvWlmD9E+niNphUJawMItIl5A2gawTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=scKPAiPGE6Wh+ZDEUNrVPB+cD0zdw6J2LeP4Ynm28b3b20UL6PIiiru1LaI+QsJ8AFQwEg5ridUiJKWEHybceAmJ0WDyAfe1kf0x1NECGS4gmtnbPnVvVJsjqPFfohpUsRCLa9zcQTaiWvPak+C3xNR4AG96hDZkJXUbIk4/LgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=F9kRHCX9; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49H1t2FY027500;
	Thu, 17 Oct 2024 09:54:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=+TRddsrmmpM1wtQaANF9W3y1Tj2RP3
	bionyyPXGXt6Q=; b=F9kRHCX9egziWpTQJ43HZlaPP6ZucKQ/AeAMdpw3NXZTxu
	FhVxJy0BJ4Sc/fRMntQfmS3E17JEqVp8fLk/ntCzzopaYJbwx1uTVtsUTL2SobeA
	+ZaqhCY2Ml7x/GHd4GO3M2ALeT/+dwKKTT0VHuibNCFnvBhxX3X2g9Zm22l75Bo+
	QXlufT64R+rfoNpCQxV7aDAax4JIQiVw2zilEKla2CeUeub7aJ9OLjl9ehSh4OmO
	pcdYxObsFjLC/MhHm0nmfwoQCZjgPVlXMT1qMfIy4zqfIrWjDqzAcYEBCB4CTU+a
	PkzkftNO+wW2K/QbFdQDhMmRGXk/uabXRyeouXjA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42asbd1tar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Oct 2024 09:54:06 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49H9pCeX010672;
	Thu, 17 Oct 2024 09:54:05 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42asbd1tak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Oct 2024 09:54:05 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49H6Fj8D005218;
	Thu, 17 Oct 2024 09:54:04 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4285njdtg8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Oct 2024 09:54:04 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49H9s0Po18022718
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Oct 2024 09:54:00 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 93E0A20043;
	Thu, 17 Oct 2024 09:54:00 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7BFCE20040;
	Thu, 17 Oct 2024 09:53:59 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.179.26.155])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 17 Oct 2024 09:53:59 +0000 (GMT)
Date: Thu, 17 Oct 2024 11:53:58 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Mario Casquero <mcasquer@redhat.com>
Subject: Re: [PATCH v2 4/7] s390/physmem_info: query diag500(STORAGE LIMIT)
 to support QEMU/KVM memory devices
Message-ID: <ZxDetq73hETPMjln@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-5-david@redhat.com>
 <ZxC+mr5PcGv4fBcY@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <04d5169f-3289-4aac-abca-90b20ad4e9c9@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04d5169f-3289-4aac-abca-90b20ad4e9c9@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: rsW7nei5PMxsFNxCpTTeWNX0xwVxfCqF
X-Proofpoint-GUID: G8r6oOg0lIoIYHzFUNbBTccmQlmMrzuo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0
 clxscore=1015 adultscore=0 priorityscore=1501 mlxlogscore=282
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410170064

> > Why search_mem_end() is not tried in case sclp_early_get_memsize() failed?
> 
> Patch #3 documents that:
> 
> +    The storage limit does not indicate currently usable storage, it may
> +    include holes, standby storage and areas reserved for other means, such
> +    as memory hotplug or virtio-mem devices. Other interfaces for detecting
> +    actually usable storage, such as SCLP, must be used in conjunction with
> +    this subfunction.

Yes, I read this and that exactly what causes my confusion. In this wording it
sounds like SCLP *or* other methods are fine to use. But then you use SCLP or
DIAGNOSE 260, but not memory scanning. So I am still confused ;)

> If SCLP would fail, something would be seriously wrong and we should just crash
> instead of trying to fallback to the legacy way of scanning.

But what is wrong with the legacy way of scanning?

> > > +	case MEM_DETECT_DIAG500_STOR_LIMIT:
> > > +		return "diag500 storage limit";
> > 
> > AFAIU you want to always override MEM_DETECT_DIAG500_STOR_LIMIT method
> > with an online memory detection method. In that case this code is dead.
> 
> Not in the above case, pathological case above where something went wrong
> during sclp_early_get_memsize(). In that scenario, die_oom() would indicate
> that there are no memory ranges but that "diag500 storage limit" worked.
> 
> Does that make sense?

Yes, I get your approach.

> Thanks for the review!

Thanks!

> -- 
> Cheers,
> 
> David / dhildenb


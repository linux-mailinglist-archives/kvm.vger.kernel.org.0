Return-Path: <kvm+bounces-28799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C15AA99D61D
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 20:04:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85F8D28351B
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 18:04:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E06D81C8767;
	Mon, 14 Oct 2024 18:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="q7e0q4gU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821541C7265;
	Mon, 14 Oct 2024 18:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728929073; cv=none; b=EpHKvxH7wkZqAD9yYwRmmI+b2Xrj9Mn7zPnDiMiGD4gxIiGfsg5KkrQ5B02ikXt7Q5mS7Vqi1srU0mGjRlrDJWwIQDsafTZmG+cV44hzF+JxYHW+YG4RSw4P+VAGzzEsRNVGmMbYVwyjErJLIUPwMjcasu/4vWmuDrN7IXj4FGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728929073; c=relaxed/simple;
	bh=SdjcDP5OfxIiwCoIu7fbZLksQxYF8RhGxJo4XtKvbnY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pHDcid/TpkmzOA4RIb74IXMt1igfdN/4QUfuNdOkw88uhk2HCvgPTOeet5glO1ou1+y5gaWoxvNn+RS/I4THGDWna+bylN/RGOLCYfF1yWtnHj5nLjr/IYgd2jhfqd7J+Op4oAto1+XopmP4aA1O/Lz3k5NBP1bsNK0AGSqDhdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=q7e0q4gU; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49EHLg4D026615;
	Mon, 14 Oct 2024 18:04:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=8xiOAnxSdyu4+TwMLojb8uRtGgH
	cpSJojTKbAe3+Zfc=; b=q7e0q4gUB0e5gGeqE1i4IP6FAi/TA9U+3HUGibUu/ZK
	6Iw2ZZwxq4Mgef20pGP9Y9TOIKKqQfsQxuz4JX6h8POTlMGPHaE3MD7bRwSVePAa
	JSgEaCbiNDeQhkdKePuj9URoQvudq+RRJFAlvekc6Z3bTD74hT6SvW3aIBD2BQ1o
	ZsC0KtjV9iCq6jXnfU3ehZsfhhVhOP3FZDbGhAYAuR5wEytAAbDZ9y7deaiZ79MF
	t7vQSxpiR7kMz9ADJ2OJnmYSlJshOir1hQyfRKMTjKkti0n8GyG1qWaSutpzQSnA
	Kl60k3w5aVpex1ywVVNUjUJM288oNNnF3jmWcT3qSZw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4297mh0693-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 18:04:17 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49EI4Hv6021968;
	Mon, 14 Oct 2024 18:04:17 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4297mh068y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 18:04:17 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49EEuaSf007025;
	Mon, 14 Oct 2024 18:04:16 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4284xjyssc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 18:04:16 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49EI4CWL17367318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Oct 2024 18:04:12 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7F40020043;
	Mon, 14 Oct 2024 18:04:12 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D82320040;
	Mon, 14 Oct 2024 18:04:11 +0000 (GMT)
Received: from osiris (unknown [9.171.66.174])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 14 Oct 2024 18:04:11 +0000 (GMT)
Date: Mon, 14 Oct 2024 20:04:10 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
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
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2 2/7] Documentation: s390-diag.rst: make diag500 a
 generic KVM hypercall
Message-ID: <20241014180410.10447-C-hca@linux.ibm.com>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-3-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014144622.876731-3-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jXoQsbGwi2M09wVIau-wlOgpnwDPXmRm
X-Proofpoint-GUID: riwysc8s6Iq-tjcvsxftDgfGdw7fL_8J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-14_12,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 spamscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 mlxlogscore=577 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410140128

On Mon, Oct 14, 2024 at 04:46:14PM +0200, David Hildenbrand wrote:
> Let's make it a generic KVM hypercall, allowing other subfunctions to
> be more independent of virtio.
> 
> This is a preparation for documenting a new hypercall.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  Documentation/virt/kvm/s390/s390-diag.rst | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)

...

> -DIAGNOSE function code 'X'500' - KVM virtio functions
> ------------------------------------------------------
> +DIAGNOSE function code 'X'500' - KVM functions
> +----------------------------------------------
>  
> -If the function code specifies 0x500, various virtio-related functions
> -are performed.
> +If the function code specifies 0x500, various KVM-specific functions
> +are performed, including virtio functions.
>  
> -General register 1 contains the virtio subfunction code. Supported
> -virtio subfunctions depend on KVM's userspace. Generally, userspace
> -provides either s390-virtio (subcodes 0-2) or virtio-ccw (subcode 3).
> +General register 1 contains the subfunction code. Supported subfunctions
> +depend on KVM's userspace. Regarding virtio subfunctions, generally
> +userspace provides either s390-virtio (subcodes 0-2) or virtio-ccw
> +(subcode 3).

Reading this file leaves a number of questions open: how does one know
which subcodes are supported, and what happens if an unsupported
subcode is used?

I'm afraid there is no indication available and the only way to figure
out is to try and if it is unsupported the result is a specification
exception. Is that correct?

If so, it would be nice to document that too; but that is not
necessarily your problem.

I guess we won't see too many new diag 500 subcodes, or would it make
sense to implement some query subcode?


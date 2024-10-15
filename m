Return-Path: <kvm+bounces-28843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7405099E088
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 10:12:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33420283AC5
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 08:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 050B81C7608;
	Tue, 15 Oct 2024 08:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QxPqLRoI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09D318BC21;
	Tue, 15 Oct 2024 08:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728979949; cv=none; b=aGKmsynJLwiPkkE95osgTZHa9lMddx6eV1tJRyI2vgWz4VCgHw2CaLELk+KbOXJFW+LSQlU4wZjRhDmf+yVT70YuY0UScM/k/tX70ZyjS3hEEzB0WoIZgRynNOBiNS2fq++wa/LSr2lwVIax+xM8ZBKIuuJljUYlLruByiwZw9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728979949; c=relaxed/simple;
	bh=iwSe1Na/qWlgaUNBJ35acuf/Ju5lCxWmRxgZho0WeWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NIRofJYQZ7vpmLMCzS+XApqI4Sth8f4eFAjOq4pG0qKfisg5B3vYjlJ8xuITffo+Hol6LjNF8obKqsL7SjrWG29oKGSTbZhrNnuAEWypevA3911PCn4yHRzcJfQS0FTOqpL4lqvXDpMjnl1OhZc/5J/M3Wg59bYotCgRlZYIAGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QxPqLRoI; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49F7ssVi022825;
	Tue, 15 Oct 2024 08:12:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Gj2eff/gDKvrExQ0+U5SRr43vqoklI
	2ZPTnRHbRAPdQ=; b=QxPqLRoIwrlhYxR/G8ca8oI31/biUBd+KcVRUQl+bDw1TC
	HH0nxcV64tw+3sLV/9kPa/89SCu+zeACdBBaBTk2kf9a1HyV5IFVwKBqJWl7KSlW
	HlZib7pCxv8B/d+1T0a34KIbTdWKHA8Fgg9XyetlgR/U2dWBEUdnnjVy//0/cLe8
	+oHOYPOJpzYlrpfevjbUSWAlnlIucLRnlkoy+ltx0n7w4Ap4Hw97z/4IHVmMhJuw
	kWJloHTZD9a2PN3eBD7QluycYo10q/BwTmyY1MD/8ctB0eg3347YdxBaXsq9OB4P
	BIK9Uyjrfah1lJ6H2oNfWxp/SOS6RjC74OU4yTiQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429me102fb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 08:12:20 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49F88uwr021532;
	Tue, 15 Oct 2024 08:12:19 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429me102f6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 08:12:19 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49F5Sdm0005936;
	Tue, 15 Oct 2024 08:12:18 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 428650tabn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 08:12:18 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49F8CFYE56820040
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 08:12:15 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2880F2004D;
	Tue, 15 Oct 2024 08:12:15 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8EF8B20040;
	Tue, 15 Oct 2024 08:12:14 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 15 Oct 2024 08:12:14 +0000 (GMT)
Date: Tue, 15 Oct 2024 10:12:12 +0200
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
Message-ID: <20241015081212.7641-A-hca@linux.ibm.com>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-3-david@redhat.com>
 <20241014180410.10447-C-hca@linux.ibm.com>
 <78e8794a-d89f-4ded-b102-afc7cea20d1d@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78e8794a-d89f-4ded-b102-afc7cea20d1d@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2n-W7mBbZ4G_mAo1_wnkX_RTK_1WA3Sm
X-Proofpoint-ORIG-GUID: HNLO0T6YpVxtKhQmcClC95BGRIIZvtZD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=465 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 impostorscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2410150052

On Mon, Oct 14, 2024 at 09:35:27PM +0200, David Hildenbrand wrote:
> On 14.10.24 20:04, Heiko Carstens wrote:
> > On Mon, Oct 14, 2024 at 04:46:14PM +0200, David Hildenbrand wrote:
> > If so, it would be nice to document that too; but that is not
> > necessarily your problem.
> 
> I can squash:
> 
> diff --git a/Documentation/virt/kvm/s390/s390-diag.rst b/Documentation/virt/kvm/s390/s390-diag.rst
> index d9b7c6cbc99e..48a326d41cc0 100644
> --- a/Documentation/virt/kvm/s390/s390-diag.rst
> +++ b/Documentation/virt/kvm/s390/s390-diag.rst
> @@ -50,6 +50,9 @@ Upon completion of the DIAGNOSE instruction, general register 2 contains
>  the function's return code, which is either a return code or a subcode
>  specific value.
> +If the specified subfunction is not supported, a SPECIFICATION exception
> +will be triggered.
> +

Looks good. Thanks!

> > I guess we won't see too many new diag 500 subcodes, or would it make
> > sense to implement some query subcode?
> 
> In the context of STORAGE LIMIT, a "query" subfunction is not really beneficial:
> 
> it's either one invocation of "query", conditionally followed by one invocation of "STORAGE LIMIT"
> vs. one invocation of "STORAGE LIMIT".
> 
> Once there might be a bunch of other subfunctions, a "query" might make more sense.

"If only there would be a query subcode available, so that the program
check handling would not be necessary; but in particular my new subcode
is not worth adding it" :)

Anyway, I do not care too much.


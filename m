Return-Path: <kvm+bounces-19055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 99F898FFD4F
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 09:39:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 340FCB228F1
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 07:39:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68E61155C9E;
	Fri,  7 Jun 2024 07:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WeO7QRoP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05A5155A55;
	Fri,  7 Jun 2024 07:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717745944; cv=none; b=WqsiYHb6XrtsAVjZw3w8LsrCsFGEQGzArMrNKgY6it4S08oREciaxg9wCqRvswwql987VTk3PGG0v+L9tKul2YPb9dfIIBTqpgdGvfZp3jUG+EDOq2imOtiVV4lp4jp2TLyFvZmPThPlRjQLWgUmrUnn46PyNvNbLMdfMLGIrNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717745944; c=relaxed/simple;
	bh=Aj+JI2KLsc8kaNoEKq/IQt2kWGg5Xh3SQxldOGykM28=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cDTu5bOFk7F//nnmNyrNL2PnWiQCV3GpfKD78mbhFAhERMvjxgKHGZLmm8FooTZy84LUNczdTAzl5GBPc97USwpthNCahapQU3cLvFAb19ZOcO3Zi1WJMjkNsqx1+tsZVKRfsHGG7K/1ykOcZYMeqzoiCJSg8DzovNCEPLiJktg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WeO7QRoP; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4577Q6oj017951;
	Fri, 7 Jun 2024 07:39:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc : content-type : date
 : from : in-reply-to : message-id : mime-version : references : subject :
 to; s=pp1; bh=DT9ffK8LdF9NfJNx8Odj/petbcfEFbaCDP/HYtgmcFM=;
 b=WeO7QRoPsR5P0rWwvjv/z/iq9edtDYfkb3QXF+ZzW4JOMeXBh2tzmdvYn2sIbjbQF5tQ
 ueiYiuBpKME/wni/D0Gqoj2nQL0UNy2RawTvA589FlQMCmqtHf8Ct2emB3eUpZiHy6au
 9Tvn9FEXU9MCGRsDisdL/fW6cbrY72l5biolVb+L+EziOL/PhADKUecaXLGS/lYoNGVF
 5ogP0QblqpQCIdKo6XVEL4nQETVf3VaVShjOCdj6yy+Ban2zUtlTru2CupW/+1775bdq
 eMR5cQgKd62n7qh3kiwPw3eEzuKrf+gAAoNBgj1kDa3lRjacHl2yUBxjcLqbrHFO0Jbb 1A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ykwe1r2xy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Jun 2024 07:39:01 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4577d1KN007491;
	Fri, 7 Jun 2024 07:39:01 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ykwe1r2xw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Jun 2024 07:39:00 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4574g9JS000795;
	Fri, 7 Jun 2024 07:39:00 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ygdyufn03-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Jun 2024 07:39:00 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4577cs3o35390154
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 7 Jun 2024 07:38:56 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 78C8D2004D;
	Fri,  7 Jun 2024 07:38:54 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 616A52004B;
	Fri,  7 Jun 2024 07:38:53 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.179.28.98])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  7 Jun 2024 07:38:53 +0000 (GMT)
Date: Fri, 7 Jun 2024 09:38:51 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Gerd Bayer <gbayer@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/3] vfio/pci: s390: Fix issues preventing
 VFIO_PCI_MMAP=y for s390 and enable it
Message-ID: <ZmK5C09Sc0I75z8A@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20240529-vfio_pci_mmap-v3-0-cd217d019218@linux.ibm.com>
 <0a4622ce-3826-4b08-ab81-375887ab6a46@linux.ibm.com>
 <20240606112718.0171f5b3.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606112718.0171f5b3.alex.williamson@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lunxstx6QXg5tzkbtrkvKNTgFDrGw9N5
X-Proofpoint-GUID: YZJfu7798kCOIUVAQvvpZEhG3rMkDruR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-07_02,2024-06-06_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=524
 spamscore=0 impostorscore=0 suspectscore=0 malwarescore=0 phishscore=0
 clxscore=1011 lowpriorityscore=0 priorityscore=1501 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406070053

On Thu, Jun 06, 2024 at 11:27:18AM -0600, Alex Williamson wrote:

Hi Alex,

> If we expect any conflicts with 1/ in the next merge window I can take
> a branch for it and apply 2/ and 3/ through the vfio tree, otherwise I
> can bring them all through the vfio tree if the s390 folks agree.

Yes. Pull it via the vfio tree, please.

> Thanks,
> 
> Alex

Thanks!


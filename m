Return-Path: <kvm+bounces-29400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 322FD9AA21C
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 14:30:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8A26281A81
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3DD819D88F;
	Tue, 22 Oct 2024 12:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YHPqnTd4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD1919B581;
	Tue, 22 Oct 2024 12:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729600206; cv=none; b=mF8zsDHtgQWd4Xr5GHd/3IKkySrJle+bbQ3hdHHpJ7n4t71eqrkEJRNJE96u3iyJbYDxrelPkA1GHrx+shH9t0VbatdvkTXCqMoXm+yOa8IOgaVSg3m7eHsVb/apc56FwKPKMUbEWwlSznaHFE7KOP+Fu5Cs3iIjEBXYbj7P0G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729600206; c=relaxed/simple;
	bh=BVlS5TlIm6fWcE59PK24oXPf/yyptAG0or/rh8SXNUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kZEazRqoeKryUqLGiIqPsbz96S/LR3cd39IcQ2WaYCJlKY24Aq/bqZW5oauRjvHlqWchhV5b8m+hncRZZLymdTPAQ5lLCkpWww4OuoWgNweDT7l0QYk4de/jdXM5IJ2ehF2xHzepxp0Iah6MC8QWxo4RfNYV5X3hfk4BwYKkbBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YHPqnTd4; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49M2HKVM022959;
	Tue, 22 Oct 2024 12:30:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=uzuUzc2h9fOrJnEQHi0Oae8nll/TP/
	bAIw0CEOEn1c8=; b=YHPqnTd48GXhwQlI/6PatyW2HI1AEfNgUA0bwpfMPHbpYO
	ItiouQEvazZPiGOnAu1DpT+NlY0uq8nE+jZiUCNjhIt4+CHHhi30mqEKI4col7xF
	55yOIZfTo+D52d412WnNGRi6PbMs/P1fphr4PZoeCqHRzLYIjb5Y8aIJZMCcG9sp
	DnhzXW12lvafVGSYsvbfcGeMe/i7+O7rJ0Y3rY+b3c8xUpwj18yhrO9DbmX6/lJv
	tQ6q2qI7FInrGQ8Hnwd2Bn/0qNW/87q7ug+Ue6etenzvBxRpgAQSEhLznpADiiUQ
	rDCWxlEytI8NyxtYBogAmlc/e1zQgvA5/b46m04w==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42c5h36fyc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:30:02 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49MASJux029161;
	Tue, 22 Oct 2024 12:30:01 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42crkk31n0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Oct 2024 12:30:01 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49MCTvIo29819234
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 12:29:57 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3D37220040;
	Tue, 22 Oct 2024 12:29:57 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0272B20043;
	Tue, 22 Oct 2024 12:29:57 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 22 Oct 2024 12:29:56 +0000 (GMT)
Date: Tue, 22 Oct 2024 14:29:55 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, borntraeger@de.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, frankja@linux.ibm.com, seiden@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com
Subject: Re: [PATCH v4 11/11] s390/mm: Convert to LOCK_MM_AND_FIND_VMA
Message-ID: <Zxeaw4vQx3QCW++8@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20241022120601.167009-1-imbrenda@linux.ibm.com>
 <20241022120601.167009-12-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241022120601.167009-12-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5XgPyLaCbq6yPKzkbEJEzBisLMtyle-s
X-Proofpoint-ORIG-GUID: 5XgPyLaCbq6yPKzkbEJEzBisLMtyle-s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=538
 adultscore=0 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410220078

On Tue, Oct 22, 2024 at 02:06:01PM +0200, Claudio Imbrenda wrote:
> From: Heiko Carstens <hca@linux.ibm.com>
> 
> With the gmap code gone s390 can be easily converted to
> LOCK_MM_AND_FIND_VMA like it has been done for most other
> architectures.
> 
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> ---
>  arch/s390/Kconfig    |  1 +
>  arch/s390/mm/fault.c | 13 ++-----------
>  2 files changed, 3 insertions(+), 11 deletions(-)

Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>


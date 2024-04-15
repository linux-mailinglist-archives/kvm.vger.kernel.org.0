Return-Path: <kvm+bounces-14648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 897FB8A5137
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 15:26:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 466A5287A91
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 13:26:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11A15811FF;
	Mon, 15 Apr 2024 13:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AEkZu/Mm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1126271B4B;
	Mon, 15 Apr 2024 13:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713186918; cv=none; b=OFiume3G4xDrgtbmpG4vxO+vOk6QAyCXn+ZofrvuDw20vSdEkbZnNEIhr+Uyy5JwqhOvHZvuE7Ng2UQI4saa3E9bPGOLjNq4td2ylwkoy7HxHcPtg5Kn/KeTVUusIDjbp3HOZW2PvkDFnV/A4XUnXmiN807QCqS5sDEnSAmI84E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713186918; c=relaxed/simple;
	bh=cgfDAaVZZtWPrtKdxCE2gH6bdJu8NmsHhTkgce2G2lw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BFYFSH3FEkL979hij/3hy+CWu1lYHhdR1El759I45iTkIuTTFXpCIWlZ+ND5/b0PnUsxTKkGLOKReyQZOu/dHRl2yy8EF6cBFqZnHWGBHhHRPynKe38QRQ8Y2E+MC4lAi+R6isLpaY+JygoEB2AYb7rdYeOmFelrav2UbtSdYrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AEkZu/Mm; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43F7PIRQ026480;
	Mon, 15 Apr 2024 13:15:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=3rN8HQolmFxM+YUKj2uZxSUDCD7dmomLpdfAKbofYKI=;
 b=AEkZu/Mm7Ca+NFMCjtJrRKZNcU2479rSJi3pmnksZWpZAKnK+uxDRgxP+MMwdKoxpzdI
 m3LGYAukWvsk3u8UmLsK2zNqN8UnI52a/OeysImif87mmxx/17mmY07WOgzVbh0zmGnQ
 o/GV//yItdyYyJIEv/nkcSZs+Hj1m2cyV9GqmjVjU3S6Jo5nIvMJ2Rc5qhPwVYL3uvx1
 JoXTVb8ZZNyP1kNrNGbc7kKNqjZMYmOaFJbrfn1DoO8id7M9rCPjjfjrDMwIA5IB+1za
 LQteC1XGnCcVdd51OgggkHnaP0HAMUQbD/jvAI5nrFX2/+d4YPVdrE7m0ZvL3zLKV6Md Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xgueuh492-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Apr 2024 13:15:10 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43FDF9cq018621;
	Mon, 15 Apr 2024 13:15:09 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xgueuh48x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Apr 2024 13:15:09 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43FCF5Za027323;
	Mon, 15 Apr 2024 13:15:08 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xg4ryr51r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Apr 2024 13:15:08 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43FDF2Qe30736856
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Apr 2024 13:15:04 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A94F72004F;
	Mon, 15 Apr 2024 13:15:02 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0A8762004B;
	Mon, 15 Apr 2024 13:15:01 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.171.5.235])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 15 Apr 2024 13:15:00 +0000 (GMT)
Date: Mon, 15 Apr 2024 15:14:59 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>, Sven Schnelle <svens@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 2/2] s390/mm: re-enable the shared zeropage for !PV
 and !skeys KVM guests
Message-ID: <Zh0oUwOqQaUxqqOt@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20240411161441.910170-1-david@redhat.com>
 <20240411161441.910170-3-david@redhat.com>
 <ZhgRxB9qxz90tAwy@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <bd4d940e-5710-446f-9dc5-928e67920ec6@redhat.com>
 <2a4ce6bc-49cc-45b8-ba15-82eb330f409f@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a4ce6bc-49cc-45b8-ba15-82eb330f409f@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zS_AuAQk6eAifeK-Okqo40-aOdlhSPHG
X-Proofpoint-ORIG-GUID: ocuVy9OvAL0I0P9GUTSSneucdjWqhqk3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-15_10,2024-04-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=791 lowpriorityscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404150086

On Mon, Apr 15, 2024 at 01:49:15PM +0200, Christian Borntraeger wrote:

Hi Christian,

> > On 11.04.24 18:37, Alexander Gordeev wrote:
> > > On Thu, Apr 11, 2024 at 06:14:41PM +0200, David Hildenbrand wrote:
> > > David, Christian,
> > > > Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> > > Please, correct me if I am wrong, but (to my understanding) the
> > > Tested-by for v2 does not apply for this version of the patch?
> > I thought I'd removed it -- you're absolutely, this should be dropped. Hopefully Christian has time to retest.
> 
> So I can confirm that this patch does continue fix the qemu memory consumption for a guest doing managedsave/start.

I will re-add your Tested-by.

> A quick check of other aspects seems to be ok. We will have more coverage on the base functionality as soon as it hits next(via Andrew) as our daily CI will pick this up for lots of KVM tests.

As per the cover letter I will pull it via s390 tree:
"Based on s390/features. Andrew agreed that both patches can go via the
s390x tree."

Thanks!


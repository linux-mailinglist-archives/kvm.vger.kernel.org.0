Return-Path: <kvm+bounces-14149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CC4F89FEEA
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 19:46:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D1E9B1F24036
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 17:46:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4CC4181BAA;
	Wed, 10 Apr 2024 17:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="m3kgc7rW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31021802C5;
	Wed, 10 Apr 2024 17:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712771101; cv=none; b=d9L2vuLc2uTZcWWkBfg7qp1ujL7dTOtofZ7dDvwbVYapA3aoscPq1GwqR3fFnirQzxD1knzlNoETIC50NGDdGRj27xMGHbXKRhl39SXH7F4GeV8N6q7IbVc5etemVrO/615fFiIVs90GBmnJaOuYlbRR2Y3i3nQG0T+AevsvNdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712771101; c=relaxed/simple;
	bh=MYZ49kfUTmA96CPgAoFfywkkTAq54Nvfjl0/Ad61t+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sPTE7mxL9tIeXDHinFKgCMrRHrUDJB3BDJAskLhrJoCtdeCb+RxWQWPlfwB7vy9FDEeqNtFDPTQA4Xt6mH9fd8iUPC5YF7+vnOQ+ipIOCEmcHqUHE0XGzsAe8ay8V6j7gnb32LPSnxOOdw6dSJqPhP/yAc8dPkHMCTU1VzvzxVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=m3kgc7rW; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43AH7f3K030658;
	Wed, 10 Apr 2024 17:44:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=BJcgfHWq1ewryUx+vAe2bkNgQ5hFSsCInNCGSnrsG4k=;
 b=m3kgc7rWgxTRGnsouMF4gpEkqCnFMARnpicpmJGytmYmFFy1A3OG0sLO286qWmL0oJid
 31+tKZP1xWmVQr7dJTfsFaJNRSgRYZhO7WesQHB8BfbmTcvRLWpmQBjFCTrh3kqRp7dr
 jd05SgKWUgD3wb9Ojsy6A6MaDsxVS7I+nnrQWeH6qraLCZWg2UCLnv6WEaRk48f5HdUH
 H4kZ/iuAV1bh5aCI8aJcauHbKIv4dNcqF45ta8oJIg0fjHxTJ/KeWFZSab5J1QHsQBGX
 q5E9X6p75zELYjZ70oFfxOdYlactMKA1/bItRuPF1m1isuwqjZ6WbaSKhwSJNzNifymn 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xdxnrr59s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Apr 2024 17:44:48 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43AHfA31026191;
	Wed, 10 Apr 2024 17:44:47 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xdxnrr59p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Apr 2024 17:44:47 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43AGDLsm019092;
	Wed, 10 Apr 2024 17:44:46 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xbh40ef8k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Apr 2024 17:44:46 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43AHiexZ51249428
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Apr 2024 17:44:42 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C543320043;
	Wed, 10 Apr 2024 17:44:40 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 982C120040;
	Wed, 10 Apr 2024 17:44:40 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 10 Apr 2024 17:44:40 +0000 (GMT)
Date: Wed, 10 Apr 2024 19:32:10 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Heiko
 Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander
 Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Janosch
 Frank <frankja@linux.ibm.com>,
        Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v1 2/5] s390/uv: convert gmap_make_secure() to work on
 folios
Message-ID: <20240410193210.61f3e069@p-imbrenda>
In-Reply-To: <67557c5b-afd8-4578-a00d-6750accc1026@redhat.com>
References: <20240404163642.1125529-1-david@redhat.com>
	<20240404163642.1125529-3-david@redhat.com>
	<Zg9wNKTu4JxGXrHs@casper.infradead.org>
	<67557c5b-afd8-4578-a00d-6750accc1026@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Cunzjy_HxNYjM4_b2ia_0WbkCwexYEl6
X-Proofpoint-GUID: df6pIICEe-2EkmOQDiuilxJEEgdxbzxm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-10_04,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 malwarescore=0 mlxlogscore=909 bulkscore=0 adultscore=0 phishscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404100130

On Fri, 5 Apr 2024 09:09:30 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 05.04.24 05:29, Matthew Wilcox wrote:
> > On Thu, Apr 04, 2024 at 06:36:39PM +0200, David Hildenbrand wrote:  
> >> +		/* We might get PTE-mapped large folios; split them first. */
> >> +		if (folio_test_large(folio)) {
> >> +			rc = -E2BIG;  
> > 
> > We agree to this point.  I just turned this into -EINVAL.
> >   
> >>   
> >> +	if (rc == -E2BIG) {
> >> +		/*
> >> +		 * Splitting might fail with -EBUSY due to unexpected folio
> >> +		 * references, just like make_folio_secure(). So handle it
> >> +		 * ahead of time without the PTL being held.
> >> +		 */
> >> +		folio_lock(folio);
> >> +		rc = split_folio(folio);
> >> +		folio_unlock(folio);
> >> +		folio_put(folio);
> >> +	}  
> > 
> > Ummm ... if split_folio() succeeds, aren't we going to return 0 from
> > this function, which will be interpreted as make_folio_secure() having
> > succeeded?  
> 
> I assume the code would have to handle that, because it must deal with 
> possible races that would try to convert the folio page.
> 
> But the right thing to do is
> 
> if (!rc)
> 	goto again;
> 
> after the put.

yes please



Return-Path: <kvm+bounces-58633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E2A94B99D91
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 14:31:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0CA877B4153
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 12:29:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 574552FDC5E;
	Wed, 24 Sep 2025 12:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NNZiFE4I"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020B61DF742;
	Wed, 24 Sep 2025 12:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758717072; cv=none; b=hctXGWPD8i/FHAqUz5G5cZAROMhsAlRojjM+MybAZWfXZW9FWzr6fzIJpv/KLJWzsz3KX27xaFn2l8mrSqjSKpPV9cVdSs4N3hQQ1O9Uy3hNTi7Uy9Dn/kBPAk+Lv9UgHSbqRh4NXkwRVVyPPk8+ZuChGBenlgyfqLfEZ01Aqt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758717072; c=relaxed/simple;
	bh=0Fed2Zw2gmFX2sQM1bsAPOW+MraM1RjFZa2JSExiWvI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sT6AqBX5VO7Od3mcIBxcUx1sDqfxBVRSGplWvP0cVcQA6NqlKE+pgzf8o7C71Jn27v2X282y+6gYo4a1mRcSkyExxgC5ISCuMKpEfKwHc2neB95evofYhMZ1/s9sVa1Ljudexseaej6EfCybDMbUF2eusEWYO+s9ohGaLktrnTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NNZiFE4I; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OAo6Xt027350;
	Wed, 24 Sep 2025 12:31:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=b20ElG
	kFlkG4nGVXlf02QYbTOhUJ2Q7whEyivhKQl88=; b=NNZiFE4Ihdzw6OElPdc9XJ
	UHh2ERW1hsBAIsTx7elagvNAPOVlE5IFIt4gxGO/U8qYIR/zLgII4j+4cD0YD55J
	iGUHiCO4fB6jFGePi2+Lr02iUiwL1wzijOcQ4TTEKwDaDx4X57ZolAk1v0BfqRUs
	OdL+7lJamoVUIjfTLW0QUlVNzJto0WZwpQyPLqzqwyOFikoefgWM5mzykA3zLvgX
	oFO9v4GKvAK+NeF+hCKATOapiJDPelYKSrdFD185y7YK3DXIgjn0qoR+Jv9G/QYp
	J9tTHKnU4dPThsD3t/Zp5BaupUK85bDSfh2eDD+6FtdXEmzfZBfpDlFeLSyH+L4g
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499kwypktb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 12:31:08 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58O9B4Xx031186;
	Wed, 24 Sep 2025 12:31:08 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 49b9vd9h73-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 12:31:07 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58OCV3GL50201016
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Sep 2025 12:31:03 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C09320043;
	Wed, 24 Sep 2025 12:31:03 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DE19F20040;
	Wed, 24 Sep 2025 12:31:02 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Sep 2025 12:31:02 +0000 (GMT)
Date: Wed, 24 Sep 2025 14:31:01 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: Gautam Gala <ggala@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: Fix to clear PTE when discarding a swapped
 page
Message-ID: <20250924143101.5c6e5f4b@p-imbrenda>
In-Reply-To: <dfc83821-f2ff-4b9c-b9cf-9dda89e8eb77@redhat.com>
References: <20250924121707.145350-1-ggala@linux.ibm.com>
	<dfc83821-f2ff-4b9c-b9cf-9dda89e8eb77@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=J5Cq7BnS c=1 sm=1 tr=0 ts=68d3e48c cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8
 a=wVQWkhML-FEOxgKYoe8A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 8m2-uYjM5ZVHzleGYvKfexkNL40mwDZ3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxNSBTYWx0ZWRfX3UkT1XWLNkoR
 nqtd+2SBbb7ElXYtOZwLP1+3lpqMDVjKPadKsuBlTSoKf5KPPpHemV/9SYGBt0cev7gnw0D/7z/
 uL9cw7qQw0Evqj7ZzHR5nFUcU5isYDqemnLOcpUeb0UfMCPY4skrZqOicFtrjIGpF3ECczheyOx
 Fw2bYHopm0lgNyDK8s2w62yCbSNbU5YuNTl5hGmyhMp19AOfBeSZ3cjIuhCYespDx9X/cwME8eN
 +hXQgxkAnVA6XtO2IY5QhfNf827r9FY+YFbULecgxTadmLw+Zb9zZZqlRNBfXEZ2B0X1oiJUDdw
 /HHcOsweVoyaC16nbK4Wy1oRmlzczOkeFexjw5n+qJvpgaFAWaFBbR1+SuwqUqgZ1J1CUi/Z00N
 RK0rh9sK
X-Proofpoint-ORIG-GUID: 8m2-uYjM5ZVHzleGYvKfexkNL40mwDZ3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_03,2025-09-22_05,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 malwarescore=0 spamscore=0 bulkscore=0
 phishscore=0 clxscore=1015 adultscore=0 suspectscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509200015

On Wed, 24 Sep 2025 14:22:05 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 24.09.25 14:17, Gautam Gala wrote:
> > KVM run fails when guests with 'cmm' cpu feature and host are
> > under memory pressure and use swap heavily. This is because
> > npages becomes ENOMEN (out of memory) in hva_to_pfn_slow()
> > which inturn propagates as EFAULT to qemu. Clearing the page
> > table entry when discarding an address that maps to a swap
> > entry resolves the issue.
> > 
> > Suggested-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Signed-off-by: Gautam Gala <ggala@linux.ibm.com>
> > ---  
> 
> Sounds bad,
> 
> I assume we want Fixes: and CC: stable, right?

yes; I'll add those when picking up

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>


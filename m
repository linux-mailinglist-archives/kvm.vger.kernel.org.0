Return-Path: <kvm+bounces-57843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8611CB7CE51
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:12:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4168D3A94A6
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 12:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BA6032BBFF;
	Wed, 17 Sep 2025 12:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="o2dbTon8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BD232BBED;
	Wed, 17 Sep 2025 12:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758111140; cv=none; b=F7sExaleVtsVbb258aYN9/1Cz6kGDgNpJdBNVQrQfZbX5nf2hnLjOi8AYy/wp/hVVuWKvX9LRaWeTt0GlJKKHKcFg4savP9m8FOUqJuw8pjczJMnFsS3WpiDg0RbL2uKkatO0rlCqv06ouTygzilIqzeC0b5FeAH7SvZb0EaKAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758111140; c=relaxed/simple;
	bh=2jKotyDewF3bpqDVKQcZlboHPWFFel1Ls9PwsPtw9Xc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cT58a2Tq5Yba6Ln2A+qI1r8Xpg44sRq5f2MF0suOJC2Ps5cNgPxiiKhlnlxhU/ebzrX1Ml29VznF88zDT5DxMyd12UGTfw7kvg5oVhUgJ8BnbIdacfmfZJfu5uKr1wMpJ8laslVUDCqK9ZolOP/kRHy6Mq8iupqM3xkjefWL7is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=o2dbTon8; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58H7qcpJ027055;
	Wed, 17 Sep 2025 12:12:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=4t5GoY
	C4bG15nNT2pvDslfhb9SUhdgGlU4ykx+AMT2w=; b=o2dbTon8+5ZJmEcrpRJ0GR
	d/y546QWjnDf0CqWGxOPbyBHZAhhQ1xmqi39drCCuLk+EUVPX0wKIu1ly+XKpcdz
	aYnPRUKR5BgMLnxJlTTM9V3HuOfv13KF00LjpFhoBa+skB/+v07no30nPHdg1PSu
	TzeDHQ0n7ANXGRMYiFMwmTK0EmGUfojwDlAOyDla2iJb+RhuWark7eBoqFh7NFSa
	Sdcb3tVWXKCEaxoFZexkURAMVn03d/LQ7bMQrtL641c3o96ZyZUkreM6Wy/Yyasv
	SHOFg+sspm4aq0EJY6EQFGYMnfS8XeQbXBOMOxdgMiO57sN8BMKXLzwPy4+m+XjQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4p3j1q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 12:12:16 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58H9coOH006385;
	Wed, 17 Sep 2025 12:12:15 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 495jxu9b64-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 12:12:15 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58HCCBia56295720
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 12:12:11 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C8E4B20043;
	Wed, 17 Sep 2025 12:12:11 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 77DA92004B;
	Wed, 17 Sep 2025 12:12:11 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 17 Sep 2025 12:12:11 +0000 (GMT)
Date: Wed, 17 Sep 2025 14:12:09 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 08/20] KVM: s390: KVM page table management
 functions: allocation
Message-ID: <20250917141209.377a05aa@p-imbrenda>
In-Reply-To: <20250916173644.27229Kcc-hca@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
	<20250910180746.125776-9-imbrenda@linux.ibm.com>
	<20250916162653.27229G04-hca@linux.ibm.com>
	<20250916184737.47224f56@p-imbrenda>
	<63e8c905-28b1-4e1f-be77-e0789bd75692@de.ibm.com>
	<20250916190514.1a3082bd@p-imbrenda>
	<15f451d9-ecb3-4a82-9b9a-2de64b93944d@de.ibm.com>
	<20250916173644.27229Kcc-hca@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX9NDipppFPFFM
 JnZk1PUH7zG9niKR4MewqU7qdacMKQEhb6wZNH4rnwhAf9lO9+bFX9p98pYpEU8QB6dvgErPfqm
 /APL8lz+Xk87cPzEYOU5rHI0llkAmQshszOFU0nUTygZaXn/kjB6mMZoaCAgt0ne8ijMfqAHJN0
 l1mYxfiHGAa5GW7VU6IHnPk7qOnxgKkqMQUErTw+gf9tuooZTD/YDx+OVYUZ3ATsfzmEr8h0oF1
 P1hDHTNhVOvrcDYq+Auc+ml47mSeQhPN9QaF0MnX/IvyIBZHuagq13irrXpUI23Bgom2acyUdh4
 rUcHha2UGQ6iFwuAPxqFmujDPgC8ruz2zSNfBR3663PFWY15KvFyQTh7gjLSCok4M13S5Vd61se
 gt0S8zC/
X-Proofpoint-ORIG-GUID: EYQUKlSnyC2_83UsxatAWFB_qtgRGLJR
X-Proofpoint-GUID: EYQUKlSnyC2_83UsxatAWFB_qtgRGLJR
X-Authority-Analysis: v=2.4 cv=cNzgskeN c=1 sm=1 tr=0 ts=68caa5a0 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=07d9gI8wAAAA:8 a=VnNF1IyMAAAA:8
 a=ifL_N-yr7MKzoRw6B2EA:9 a=CjuIK1q_8ugA:10 a=e2CUPOnPG4QKp8I52DXD:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204

On Tue, 16 Sep 2025 19:36:44 +0200
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Tue, Sep 16, 2025 at 07:06:06PM +0200, Christian Borntraeger wrote:
> > 
> > Am 16.09.25 um 19:05 schrieb Claudio Imbrenda:
> >   
> > > > > I think GFP_ATOMIC actually gives more guarantees?  
> > > > 
> > > > In real life GFP_ATOMIC can fail, GFP_KERNEL does not.All gfp allocation failures
> > > > are usually the atomic ones.  
> > > 
> > > interesting... then I guess I need GFP_KERNEL | GFP_ATOMIC ?  
> > 
> > No. ATOMIC always means: can fail.  
> 
> So GFP_KERNEL alone is what is needed here. It is undocumented that
> small GFP_KERNEL allocations will never fail (retried for ever):
> 
> https://lwn.net/Articles/627419/
> https://lwn.net/Articles/723317/
> 
> While GFP_ATOMIC will fail e.g. if I/O is required to free up some
> memory.

ah, "how small is small" is answered in those links, ignore my question


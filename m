Return-Path: <kvm+bounces-32523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0236E9D9732
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 13:22:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F1791651A0
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 12:22:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5FBA1D12E0;
	Tue, 26 Nov 2024 12:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CgCV91id"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D521CF5EC;
	Tue, 26 Nov 2024 12:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732623722; cv=none; b=GHeA0+XT1NZaCE4LB9Io8KoNzQ+Qy/gFF7zXGb6luv0NzGjxPi7C6Z+PkuIncLCS0UnnaOwFWqcy7rqxcN1mEtlceTlWrs4tIYwOe5DX4ynOkhKo4+V5RkkrpwmtKKFKyPyT5X/ZuFPg2e1spnU1DLkItpDf6qBLJeubmemJQRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732623722; c=relaxed/simple;
	bh=Lb5b7gjijv5h+7cZ9uoPLYZB+/voErDLAPOz7AAgPJA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=arkTqshvDImqSz1nU+48kqbD4l0yz2XkTg4MlKsClDdUdwJokjk11QW2OieHRH3E8yPhm4R3q9B0+Ks/whFcp6KML5nFbog7SHbeyvv/BzZz0wVevf+SNDfJ67fdKqOMvnYPDIIeqo4zPCoqnE+E82DNzGGeKnqPmUjRPLLsDas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CgCV91id; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AQ5p1AB010886;
	Tue, 26 Nov 2024 12:21:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=HBPyy+
	o8mzVbP3YoSjpj+Fhyb6Py7hZ+KR1ucAo9+Hs=; b=CgCV91id1Y9hCAvnPjcX+l
	8m9GISkR9wFnH6CdKY0cw5mWLWAq6jvIlPxliuOhO45tNs71ptn757mLuvKYbanT
	YZZWq8LYfeSCs8W+Ne/Winlls5YRMelSW0n6aTYm8wBLzZa4mw7mnWyuUxlBYcGb
	MSz/1HUWK8AZhFQsPn7MNQ3EdoOMQP7d0NJWTsbYWgUuf3WnQ6VFbWCV/MUdourW
	0f1Z35BiGIJD6Ne8CIjRAD41YjvXsUS1cXS2ayvNN7Hpeob8kSEok/1iOndww12W
	YtKN9/Vn6TEoKlLzVleA/1LjmWe15bB+1cJN0vrNR69O99vr84YsRe4hu8mqGkdg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43386jwftd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 12:21:58 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AQ45loe003114;
	Tue, 26 Nov 2024 12:21:57 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 433tcmcdpr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 12:21:57 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AQCLrWB20251042
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Nov 2024 12:21:53 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B7CAE20049;
	Tue, 26 Nov 2024 12:21:53 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9385420040;
	Tue, 26 Nov 2024 12:21:53 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 26 Nov 2024 12:21:53 +0000 (GMT)
Date: Tue, 26 Nov 2024 13:21:52 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] KVM: s390: Increase size of union sca_utility to
 four bytes
Message-ID: <20241126132152.3dc746e7@p-imbrenda>
In-Reply-To: <2d3862ea-4112-4a03-9e4b-ac4e8e23a7f4@linux.ibm.com>
References: <20241126102515.3178914-1-hca@linux.ibm.com>
	<20241126102515.3178914-4-hca@linux.ibm.com>
	<2d3862ea-4112-4a03-9e4b-ac4e8e23a7f4@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hJCDb6B0ISbIclv93TnTg2qWuEg1w0PO
X-Proofpoint-GUID: hJCDb6B0ISbIclv93TnTg2qWuEg1w0PO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 mlxlogscore=878 spamscore=0 suspectscore=0 phishscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411260097

On Tue, 26 Nov 2024 13:09:56 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 11/26/24 11:25 AM, Heiko Carstens wrote:
> [...]
> >   union sca_utility {  
> 
> Would you mind adding a comment?
> 
> 
> ""Utility is defined as 2 bytes but having it 4 bytes wide generates 
> more efficient code. Since the following bytes are reserved this makes 
> no functional difference.""

looks good, thanks!

> 
> > -	__u16 val;
> > +	__u32 val;
> >   	struct {
> > -		__u16 mtcr : 1;
> > -		__u16 reserved : 15;
> > +		__u32 mtcr : 1;
> > +		__u32	   : 31;
> >   	};
> >   };
> >   
> > @@ -107,7 +107,7 @@ struct bsca_block {
> >   	__u64	reserved[5];
> >   	__u64	mcn;
> >   	union sca_utility utility;
> > -	__u8	reserved2[6];
> > +	__u8	reserved2[4];
> >   	struct bsca_entry cpu[KVM_S390_BSCA_CPU_SLOTS];
> >   };
> >   
> > @@ -115,7 +115,7 @@ struct esca_block {
> >   	union ipte_control ipte_control;
> >   	__u64   reserved1[6];
> >   	union sca_utility utility;
> > -	__u8	reserved2[6];
> > +	__u8	reserved2[4];
> >   	__u64   mcn[4];
> >   	__u64   reserved3[20];
> >   	struct esca_entry cpu[KVM_S390_ESCA_CPU_SLOTS];  
> 



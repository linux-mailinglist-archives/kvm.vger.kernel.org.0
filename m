Return-Path: <kvm+bounces-47150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EA181ABDF9F
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 17:55:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E73C81896A1A
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 15:55:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A802825C6E7;
	Tue, 20 May 2025 15:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XiNVxsZl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02019261596;
	Tue, 20 May 2025 15:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747756494; cv=none; b=OU7LDK3tlZ5vHtGAMVs/owEufqOwAIu4SVl0wfJ/AGuTz7OcAxOpG9ahZ4pfGrQkixNcFZ9ZvUFyqukXJQyFANUv09Cgj/PFVhBHLhpOEZx6VtbT981ZbDpgPN8mrOR2eTj9mCv7X7v6ZryahgceLJ8Rf23BH1TtFodT5IcLlKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747756494; c=relaxed/simple;
	bh=khpO6nTdgEs/t+6f2mpbp5mVcH9V/RCYTZNqzcCFOpE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oc5ugXaNInjnbcFzCi+brZ99dOHp4f62ncO6/WFXtBb4HcKcG9xQ9SqsYxPdiGL2qG0EnvQrfn3EQ5H76FZmFEKAA0o1l2NFMDGqsh1ZaUJiHHKPbtBz1NSfzeVyYCvNeOm14Gzq1alHM5aKJD0Y7vKpcwi6uAAzY4mAy+QDnhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XiNVxsZl; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54KDn9Rb014272;
	Tue, 20 May 2025 15:54:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=wdJ1jw
	LeaCaXnJQgO3tBJIQWMGl4H2EoSYzh9CBvdn0=; b=XiNVxsZlvaP6AUdLPjj/1Z
	pZwRwscvLPGeLDxhp3AXf/zq7zDOUSitKESagUOL/ol+eEC8esL91WN4LC/Ko6yg
	u3EDTpbb+Zg1v4XZV0Nm4EDLcFi3MsTsPVSdbq+UivqiuaP7EQazJEh2XhJxf7LV
	rQRD6p2wA+iyOBU8Yz7/+3am3XIPyjhIOQ1g1lh9Co7wfSQjwJhzQhP9NnxC86Ez
	+RLUR/u7g8qDHYEUQzNd4pROQ1KFQGda/sOginb8wNj/rwCReRG8Va44pd+D0dQg
	9OPOGVz05fDXTP9vVRbZ3pzczrYAAmz6ZNBRedGFzioEDJFl9ZgUL+OO+ztnpjVw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46rty3gqvb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 15:54:37 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 54KFg5Ki019123;
	Tue, 20 May 2025 15:54:36 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46rty3gqv1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 15:54:36 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54KDCAuq014262;
	Tue, 20 May 2025 15:54:35 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 46q4stcy3q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 15:54:35 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54KFsVPU50594076
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 15:54:31 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 54DEB2004B;
	Tue, 20 May 2025 15:54:31 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C967020043;
	Tue, 20 May 2025 15:54:30 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 20 May 2025 15:54:30 +0000 (GMT)
Date: Tue, 20 May 2025 17:54:28 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Houghton
 <jthoughton@google.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
        Yang Shi
 <yang@os.amperecomputing.com>,
        David Hildenbrand <david@redhat.com>,
        "Liam
 R . Howlett" <Liam.Howlett@oracle.com>,
        Matthew Wilcox
 <willy@infradead.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko
 Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander
 Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY
Message-ID: <20250520175428.24ec47b7@p-imbrenda>
In-Reply-To: <cb0894b6-3c41-4850-a077-2d18f5547d2e@lucifer.local>
References: <20250519145657.178365-1-lorenzo.stoakes@oracle.com>
	<20250520171009.49b2bd1b@p-imbrenda>
	<cb0894b6-3c41-4850-a077-2d18f5547d2e@lucifer.local>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDEyOCBTYWx0ZWRfX+SmD9pxtFRWL Y1A5CvRO5j3pLbJXgfJ3tYZTv5xTJ2ADxBegmCEskjfRhabnYdPZwMZsYAzewILo2kFo8TrOUs1 rqQklZ9hOB2kjgti7XAoPtboPYftAQT7x+MpZ+fwDgmEsqQ3G2n2EbA7P69GK2+wWYp8Vh/uwu/
 RJvfhG7lfNn/YGLB3Jibr9Lpc38LUjY8AIVRh9Vb41QK9g33sTJ90TAvd39dEie+lbImUQZYZW0 kleqa2qaU1QNXMeeGAgVShdYsJ2bQ6K1og+rvffMapKCP9P7W3RR1VPZdlAyN1DMRcqAMM08St4 hnAeBWDHcYuwv5yE9qGA/Htf+o4mb7hyfCy/WL0Jhe8LDwkUJhslstLenI0aORMJvpvvveGJqYq
 TBBK8tr+yv+pDpofjLYbs9z5QRhcb5GqZAnNVOnGmwV7+FqHIsM7J3QoLnnBTiScT4NuujDM
X-Proofpoint-ORIG-GUID: NqSYhNXr9uJIwok2XATvZpjkj1adV_zo
X-Authority-Analysis: v=2.4 cv=DKeP4zNb c=1 sm=1 tr=0 ts=682ca5bd cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8 a=TAZUD9gdAAAA:8 a=VnNF1IyMAAAA:8
 a=vzhER2c_AAAA:8 a=20KFwNOVAAAA:8 a=-dfg5vNDZjZ0OaYXpFQA:9 a=CjuIK1q_8ugA:10 a=f1lSKsbWiCfrRWj5-Iac:22 a=0YTRHmU2iG2pZC6F1fw2:22
X-Proofpoint-GUID: uIm7Ji6apohDdQkSspMSiXzoGwXD6Qz_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_06,2025-05-20_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 mlxscore=0 impostorscore=0
 malwarescore=0 phishscore=0 bulkscore=0 clxscore=1015 adultscore=0
 spamscore=0 mlxlogscore=999 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505200128

On Tue, 20 May 2025 16:24:10 +0100
Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> On Tue, May 20, 2025 at 05:10:09PM +0200, Claudio Imbrenda wrote:
> > On Mon, 19 May 2025 15:56:57 +0100
> > Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> >  
> > > The enum type prot_type declared in arch/s390/kvm/gaccess.c declares an
> > > unfortunate identifier within it - PROT_NONE.
> > >
> > > This clashes with the protection bit define from the uapi for mmap()
> > > declared in include/uapi/asm-generic/mman-common.h, which is indeed what
> > > those casually reading this code would assume this to refer to.
> > >
> > > This means that any changes which subsequently alter headers in any way
> > > which results in the uapi header being imported here will cause build
> > > errors.
> > >
> > > Resolve the issue by renaming PROT_NONE to PROT_TYPE_DUMMY.
> > >
> > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > Suggested-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
> > > Fixes: b3cefd6bf16e ("KVM: s390: Pass initialized arg even if unused")
> > > Cc: stable@vger.kernel.org
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Closes: https://lore.kernel.org/oe-kbuild-all/202505140943.IgHDa9s7-lkp@intel.com/
> > > Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> > > Acked-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
> > > Acked-by: Yang Shi <yang@os.amperecomputing.com>
> > > Reviewed-by: David Hildenbrand <david@redhat.com>
> > > Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>  
> >
> > if you had put me in CC, you would have gotten this yesterday already:
> >
> > Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>  
> 
> Thanks and apologies for not cc-ing you, clearly my mistake.
> 
> Though I would suggest your level of grumpiness here is a little over the
> top under the circumstances :) we maintainers must scale our grumpiness
> accordingly...

it was not meant to be grumpy, sorry if it came through that way!

> 
> >  
> > > ---
> > > Separated out from [0] as problem found in other patch in series.
> > >
> > > [0]: https://lore.kernel.org/all/cover.1747338438.git.lorenzo.stoakes@oracle.com/
> > >
> > >  arch/s390/kvm/gaccess.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> > > index f6fded15633a..4e5654ad1604 100644
> > > --- a/arch/s390/kvm/gaccess.c
> > > +++ b/arch/s390/kvm/gaccess.c
> > > @@ -318,7 +318,7 @@ enum prot_type {
> > >  	PROT_TYPE_DAT  = 3,
> > >  	PROT_TYPE_IEP  = 4,
> > >  	/* Dummy value for passing an initialized value when code != PGM_PROTECTION */
> > > -	PROT_NONE,
> > > +	PROT_TYPE_DUMMY,
> > >  };
> > >
> > >  static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva, u8 ar,
> > > @@ -334,7 +334,7 @@ static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva,
> > >  	switch (code) {
> > >  	case PGM_PROTECTION:
> > >  		switch (prot) {
> > > -		case PROT_NONE:
> > > +		case PROT_TYPE_DUMMY:
> > >  			/* We should never get here, acts like termination */
> > >  			WARN_ON_ONCE(1);
> > >  			break;
> > > @@ -804,7 +804,7 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
> > >  			gpa = kvm_s390_real_to_abs(vcpu, ga);
> > >  			if (!kvm_is_gpa_in_memslot(vcpu->kvm, gpa)) {
> > >  				rc = PGM_ADDRESSING;
> > > -				prot = PROT_NONE;
> > > +				prot = PROT_TYPE_DUMMY;
> > >  			}
> > >  		}
> > >  		if (rc)
> > > @@ -962,7 +962,7 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
> > >  		if (rc == PGM_PROTECTION)
> > >  			prot = PROT_TYPE_KEYC;
> > >  		else
> > > -			prot = PROT_NONE;
> > > +			prot = PROT_TYPE_DUMMY;
> > >  		rc = trans_exc_ending(vcpu, rc, ga, ar, mode, prot, terminate);
> > >  	}
> > >  out_unlock:
> > > --
> > > 2.49.0
> > >  
> >  



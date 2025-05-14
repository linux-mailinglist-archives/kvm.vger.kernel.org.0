Return-Path: <kvm+bounces-46507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 17466AB6E87
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 16:52:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0EB0F7B5E74
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 14:49:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07A8F27C15B;
	Wed, 14 May 2025 14:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jG99cOU+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B7D2749C6;
	Wed, 14 May 2025 14:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747234134; cv=none; b=Ci8f8Vtj4l/K5xBpSlQKgRDUgSxekohMuFWxd0HGqJJcvxyxlLO5TKrKPMPkoVIMLW9QKXDBAGr2bNU6OnIKB3I0ppeeilW5qxxVrm7CUoHaSkyDj4NvEYKBHKlMpXIV3PKFXLkOD/sGls8F58G39uHNE7lQQbOMt/uce2CXDkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747234134; c=relaxed/simple;
	bh=S1Tv5seaUyKpTUhwUVjcwaVgNefXie8/d6meg7WHH4g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KkQt1Xugcn49lFTwHlyLAfTg4I93TNzEcWjcPcXAJDDO/ya4dY2A22qnJcuNzGfGsTbd9bwMmlUae+bpPMYbRrYwiZeGsbYA3jbOpW55bIBAebLvkGigO1/vpA41l7qwztDAp5AWmGMG1Btzy0HUAbWptuTPl5XBIJDVkNlWWLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jG99cOU+; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54E6IQZH026395;
	Wed, 14 May 2025 14:48:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=/y32Pq
	DRTmB9OsHjOqffgO3cxRDIFcN3iXySsATDOxg=; b=jG99cOU+3NPE2uY1SyyqCV
	+Lmi4Hpw9CqhY9eSRHL44CyGc98Gia2EcveTQSNVi5/MQAQ1NxWyo2iRA34s6BkV
	/F/qPCM6vxcI+B+u8mL3Ux/e6xEBwzVMK2o5P+gBq4KdZ6cfpzBo18dufASe05z1
	N20fkSJHS9aZBFdKedO/A4lK/FsdmU5Da4KzhKN9yLxQmLcJHpqm4LHBP2QklXjw
	FLf2FPIn8eE15dnB7GIRFZ4uI4KSHFUTBqqHhKvibwEPDxBTPtvFx8zzCsqmCXox
	CAr6a+LfpTu/Iff4ChHosieLrZ4hcxbuarXXP70id/1nNRgzS2ktRJf+yFUUeGUg
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46mnst2etw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 14:48:29 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54EDJoEx026954;
	Wed, 14 May 2025 14:48:28 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46mbfpcrj4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 14:48:28 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54EEmOJB58589608
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 14:48:24 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D9BB20161;
	Wed, 14 May 2025 14:48:24 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 03F6620162;
	Wed, 14 May 2025 14:48:24 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 May 2025 14:48:23 +0000 (GMT)
Date: Wed, 14 May 2025 16:48:22 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Ignacio Moreno Gonzalez
 <Ignacio.MorenoGonzalez@kuka.com>,
        kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Yang Shi
 <yang@os.amperecomputing.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David
 Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [akpm-mm:mm-new 320/331] arch/s390/kvm/gaccess.c:321:2: error:
 expected identifier
Message-ID: <20250514164822.4b44dc5c@p-imbrenda>
In-Reply-To: <0da0f2fc-c97f-4e95-b28e-fa8e7bede9cb@linux.ibm.com>
References: <202505140943.IgHDa9s7-lkp@intel.com>
	<63ddfc13-6608-4738-a4a2-219066e7a36d@kuka.com>
	<8e506dd6-245f-4987-91de-496c4e351ace@lucifer.local>
	<20250514162722.01c6c247@p-imbrenda>
	<0da0f2fc-c97f-4e95-b28e-fa8e7bede9cb@linux.ibm.com>
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
X-Proofpoint-GUID: yCPpAy43Tt1i9T-xP-kkPDcB9UDi83gN
X-Authority-Analysis: v=2.4 cv=V+590fni c=1 sm=1 tr=0 ts=6824ad3d cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=yPCof4ZbAAAA:8 a=FEjADQhAx8tm0xh6MsIA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: yCPpAy43Tt1i9T-xP-kkPDcB9UDi83gN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDEzMCBTYWx0ZWRfX12irjiclNwuP T7FN+ygx0oTU8D3iBX1J55lKNEwAttYnU7+RBQXHs1bHZICBcRNWGUU/MnXXwDutGcLT4NZuYoW 9afmguP3vQOjWQgZr85vQytlkSElhT03uH2c1CeNU3D4AiB9gC7cXHzpTPvCj9dU0/nFQx83o7D
 XynfQauzfUPIEpw8Uw05pvCihNCZs4K18YVMyPlkcZjGIUV6wA1+h8AWYMiWezKywYCV7t/wllD X6aytexoDD9WYD3lBOIqMLGwQI6leNxKhSq9yG+UYzDCJfpeJaFzNPIfl5do6OsEGhHgKMSg5Ff jWtw9GbBHVbyh/iLU8snfmfv9n81BW2bJfSvuTLrTbvGmnfyCqCqqmGm71Wg818OSQDvA/Pe8nU
 OOiaYYkKwcdfEDusXlAFBiahBdUoLDtAHAB7QLkg8VDPhGe1c329vTBOlCjnAOBmbdK67nQ7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_04,2025-05-14_03,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 phishscore=0 adultscore=0 clxscore=1015
 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505140130

On Wed, 14 May 2025 16:39:11 +0200
Christian Borntraeger <borntraeger@linux.ibm.com> wrote:

> Am 14.05.25 um 16:27 schrieb Claudio Imbrenda:
> > On Wed, 14 May 2025 14:48:44 +0100
> > Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> >   
> >> +cc s390 people, kvm s390 people + lists. sorry for noise but get_maintainers.pl
> >> says there's a lot of you :)
> >>
> >> On Wed, May 14, 2025 at 03:28:47PM +0200, Ignacio Moreno Gonzalez wrote:  
> >>> Hi,
> >>>
> >>> Due to the line:
> >>>
> >>> include/linux/huge_mm.h:509 '#include <uapi/asm/mman.h>'  
> >>
> >> BTW, I didn't notice at the time, but shouldn't this be linux/mman.h? You
> >> shouldn't be importing this header this way generally (only other users are arch
> >> code).
> >>
> >> But at any rate, you will ultimately import the PROT_NONE declaration.
> >>  
> >>>
> >>> there is a name collision in arch/s390/kvm/gaccess.c, where 'PROT_NONE' is also defined as value for 'enum prot_type'.  
> >>
> >> That is crazy. Been there since 2022 also...!
> >>  
> >>>
> >>> A possible fix for this would be to rename PROT_NONE in the enum to PROT_TYPE_NONE.  
> > 
> > please write a patch to rename PROT_NONE in our enum to
> > PROT_TYPE_DUMMY, I can review it quickly.
> > 
> > if Paolo has no objections, I'm fine with having the patch go through
> > the mm tree  
> 
> Yes, lets do a quick fix and I can also do
> Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> 
> for a s/PROT_NONE/PROT_TYPE_NONE/g
> patch.

I'd rather have PROT_TYPE_DUMMY, since it's a dummy value and not
something that indicates "no protection"


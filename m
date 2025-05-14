Return-Path: <kvm+bounces-46504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B483AB6E21
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 16:28:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA4893BE61A
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 14:27:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFE821AAE01;
	Wed, 14 May 2025 14:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FZ0TaHOK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EDA13B284;
	Wed, 14 May 2025 14:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747232866; cv=none; b=dYRykVrJL365AIWxdm7C1ip5xDwPsgp3Z3TZjZ+L0MFbqxV5gpLZYFUD8XPjaiKiag16gH3bnXd8FAQcvsoD7EpP4Gqxr4jrRQ1bEEV+JKg3FgqVQ8TOITFKK4jglUSea9kf2y4h9kkuj0U5u9eEcla6VM+PZYoFxVK/H3AHesM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747232866; c=relaxed/simple;
	bh=e3LubSvZ2hA9Wz5eH+CgWgUL1D1ORqO77rCnpfWfo+o=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R/rBmyrLBwwyEIzs4mTFMijj2OSPD85VEFQzw0hZOaApVvvJxe8J9S46N6Gof7x27omiNNS3IsGLkrCOAcgW5jZqsind313ZjGAK3/Bv3brnag74KRkeDgtVE1g0yiVfNGlilzCmyMs95ZzEPUrSFg7XN0mNSEdF5XRxakffqew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FZ0TaHOK; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54E7ZRQr016936;
	Wed, 14 May 2025 14:27:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=egx7Iu
	qCYH2ItVv53dPViRPkCT0UPv7EjOBZEZOHMnQ=; b=FZ0TaHOK30+4W041sHmKj4
	kzpKSjfyKGmop58akTTcN0dFOB/HLJXuL2AjJetjQB7bx6yhK1zGmTYQG4aquH6K
	rf6D3FbHuWjcGRLsGjbmuHCK53upyXSW4+1J0o0KQPUVu2mGv3+z+fvguB2lEpVm
	PvhocslnmE2oRpLssn6HdLKDudo/fuZ/jQbCJ5EDjED5hEZc6E9sxF3V/eap9taK
	unAKnCbI9qtCZNemH3Iz2t75lO3fsgBWUur0UO/LyNJiRDK3E9IgOONHkRxS10tZ
	iuVTc2trfLWLYdDPSQ4LgTcyS/dDjY6E97GhB1ehpt6VhV+xKywEkQavPE9udFBA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46mbq8mumk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 14:27:29 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54EDaLRA015315;
	Wed, 14 May 2025 14:27:28 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 46mbfpvn21-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 14:27:28 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54EEROJT60358940
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 14:27:24 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 73ABD2006A;
	Wed, 14 May 2025 14:27:24 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EAB6420040;
	Wed, 14 May 2025 14:27:23 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 May 2025 14:27:23 +0000 (GMT)
Date: Wed, 14 May 2025 16:27:22 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
        kernel test
 robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
        Andrew Morton
 <akpm@linux-foundation.org>,
        Linux Memory Management List
 <linux-mm@kvack.org>,
        Yang Shi <yang@os.amperecomputing.com>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko
 Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander
 Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [akpm-mm:mm-new 320/331] arch/s390/kvm/gaccess.c:321:2: error:
 expected identifier
Message-ID: <20250514162722.01c6c247@p-imbrenda>
In-Reply-To: <8e506dd6-245f-4987-91de-496c4e351ace@lucifer.local>
References: <202505140943.IgHDa9s7-lkp@intel.com>
	<63ddfc13-6608-4738-a4a2-219066e7a36d@kuka.com>
	<8e506dd6-245f-4987-91de-496c4e351ace@lucifer.local>
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
X-Proofpoint-ORIG-GUID: yg3a8ZZEOC0Z4BsOLBfrPeJ0odXCNOv6
X-Authority-Analysis: v=2.4 cv=GrRC+l1C c=1 sm=1 tr=0 ts=6824a851 cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=TAZUD9gdAAAA:8 a=i3X5FwGiAAAA:8 a=NEAV23lmAAAA:8
 a=yPCof4ZbAAAA:8 a=m4NsZjHeC5rv4vFivSYA:9 a=CjuIK1q_8ugA:10 a=f1lSKsbWiCfrRWj5-Iac:22 a=mmqRlSCDY2ywfjPLJ4af:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDEyMCBTYWx0ZWRfX4XuijPxY05Ar 5xq9IRfa3QBgHWzV9TamoSH0ImtlPWdQAX7Akbg4QB9d46ODcUWLk1H2X/L8j6ljPYVnWYIMR5Z nofbG5Wy5Wf/Ih9gu9+MWo5tBAVki1pFsUzzcDYyZ9Wo1PFQcq/nGdkMMmvowiDKgF1b8bWBC0d
 F3SyniISQ9mQWisf+/IVYbMmdb0JP1sSg18QLTPc0pKrkDN52ltaTtCssjIhhFU5awUIUTs5XhM VtBomDnyGMCsYgtTxtX9ujYPsORnowJA6jeu4VHtoEEk+AunV0ZllvcBNJweM1ZWrDWBKPnDgex 1Z1y1cfZ8vN3fcTT3yJdcIT40DEgTiJ3ZinyBcZBh6dRyrvED8s2/xf7SGwb88LfT530hm2zvTs
 penK1VAx/RHrDdiwE6p0cda1xYEnawXGFJFWTi6xG9SdlZ++/+qR+JzqwvhNTnHjmrVKkC/1
X-Proofpoint-GUID: yg3a8ZZEOC0Z4BsOLBfrPeJ0odXCNOv6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_04,2025-05-14_03,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 phishscore=0 mlxscore=0 clxscore=1011
 mlxlogscore=999 spamscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505140120

On Wed, 14 May 2025 14:48:44 +0100
Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> +cc s390 people, kvm s390 people + lists. sorry for noise but get_maintainers.pl
> says there's a lot of you :)
> 
> On Wed, May 14, 2025 at 03:28:47PM +0200, Ignacio Moreno Gonzalez wrote:
> > Hi,
> >
> > Due to the line:
> >
> > include/linux/huge_mm.h:509 '#include <uapi/asm/mman.h>'  
> 
> BTW, I didn't notice at the time, but shouldn't this be linux/mman.h? You
> shouldn't be importing this header this way generally (only other users are arch
> code).
> 
> But at any rate, you will ultimately import the PROT_NONE declaration.
> 
> >
> > there is a name collision in arch/s390/kvm/gaccess.c, where 'PROT_NONE' is also defined as value for 'enum prot_type'.  
> 
> That is crazy. Been there since 2022 also...!
> 
> >
> > A possible fix for this would be to rename PROT_NONE in the enum to PROT_TYPE_NONE.  

please write a patch to rename PROT_NONE in our enum to
PROT_TYPE_DUMMY, I can review it quickly.

if Paolo has no objections, I'm fine with having the patch go through
the mm tree

> 
> Yeah this is the correct fix, IMO, but you will need to get that sorted with the
> arch maintainers.
> 
> I think this suggests we should back out this change for now and try again next
> cycle given we haven't much time left.
> 
> Have cc'd s390/kvm for s390 maintainers for their input however!
> 
> >
> > The patch causing this problem was created by me based on a suggestion in the review process of another patch that I submitted first:
> >
> > https://lore.kernel.org/linux-mm/ee95ddf9-0d00-4523-ad2a-c2410fd0e1a3@lucifer.local/
> >
> > In case '#include <uapi/asm/mman.h>' causes unexpected trouble, we can also take the patch back... What do you think?  
> 
> I guess we need to back this out for the time being, since we're so near the end of the cycle.
> 
> >
> > Thanks and regards
> > Ignacio
> >
> > On 5/14/2025 3:05 AM, kernel test robot wrote:  
> > >>> arch/s390/kvm/gaccess.c:344:8: error: duplicate case value: '0' and 'PROT_TYPE_LA' both equal '0'  
> >
> >  
> 
> For convenience, let me include the top of the original report. The full thing
> is at https://lore.kernel.org/all/202505140943.IgHDa9s7-lkp@intel.com/
> 
> The original patch for this is at
> https://lore.kernel.org/all/20250508-madvise-nohugepage-noop-without-thp-v1-1-e7ceffb197f3@kuka.com/
> 
> Original report:
> 
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   24e96425873f27730d30dcfc639a3995e312e6f2
> commit: cd07d277e6acce78e103478ea19a452bcf31013e [320/331] mm: madvise: make MADV_NOHUGEPAGE a no-op if !THP
> config: s390-randconfig-r062-20250514
> +(https://download.01.org/0day-ci/archive/20250514/202505140943.IgHDa9s7-lkp@intel.com/config)
> compiler: clang version 21.0.0git (https://github.com/llvm/llvm-project f819f46284f2a79790038e1f6649172789734ae8)
> reproduce (this is a W=1 build):
> +(https://download.01.org/0day-ci/archive/20250514/202505140943.IgHDa9s7-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202505140943.IgHDa9s7-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> arch/s390/kvm/gaccess.c:321:2: error: expected identifier  
>      321 |         PROT_NONE,
>          |         ^
>    include/uapi/asm-generic/mman-common.h:16:19: note: expanded from macro 'PROT_NONE'
>       16 | #define PROT_NONE       0x0             /* page can not be accessed */
>          |                         ^
> >> arch/s390/kvm/gaccess.c:344:8: error: duplicate case value: '0' and 'PROT_TYPE_LA' both equal '0'  
>      344 |                 case PROT_TYPE_LA:
>          |                      ^
>    arch/s390/kvm/gaccess.c:337:8: note: previous case defined here
>      337 |                 case PROT_NONE:
>          |                      ^
>    include/uapi/asm-generic/mman-common.h:16:19: note: expanded from macro 'PROT_NONE'
>       16 | #define PROT_NONE       0x0             /* page can not be accessed */
>          |                         ^



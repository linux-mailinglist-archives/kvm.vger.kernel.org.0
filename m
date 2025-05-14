Return-Path: <kvm+bounces-46513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B767AB70E1
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 18:11:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 200D1867F7E
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 16:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A336327A442;
	Wed, 14 May 2025 16:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="b7fmcAP2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D2623CE;
	Wed, 14 May 2025 16:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747239028; cv=none; b=OF7dNI7ull767oMNcsRTEFjENytj90QFe6qC4oVJUm1nSJq9f13URofA5zFX88w95dRdD7o7wydHafvBT1Gjv6EIQQGlU2c5XVTyleQHXuaSr76SnhisjAnXiXmXsU4UezoUYFbQ7PKo2EQ8CP3HQUch9FjGL4vJZHhuRHxgAJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747239028; c=relaxed/simple;
	bh=gGwiUiW+HXiTkW5h4eGIohF0qoaEcQJpmzc0TrVJeeA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u761uebkdrm8BBZBs8woOr2K7I++FyfNtgZi2IMNqUfZm8XVSIFHpAP38Kb/JpewIBvaloqa71s1NmUroohj/QuOsutWz2FIjEtDQLOqxIxyZbt0ZMVB+d+lbxPii6WBPcT0okpnXn+O8nKLBPG5NpkTusTdqYugoJ+/99GhdwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=b7fmcAP2; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54EDn45X003568;
	Wed, 14 May 2025 16:10:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Gx2b4Z
	IlWG4aK2ZNItTwwPT+mm7hjHfKNLZ7/PvK6W0=; b=b7fmcAP2H+fmHZNZmAYAHW
	6fmF5/CmNz6wG77TsK29vTYx/9JZgq3unTcnFoOU/9vHjz4Y4M9rsbM4IPbOTtC8
	XpcZKMYMW5wehJLS4iulp7S5x50V5uKzMcEnYu6d1iNgiIfkz8iKAL7NaHpDTOE7
	+VRUdtF09xtM0MtDNZSsQGpxjCZWS89SvghP9xdBdrdErNgDnoNzg0stwE8QXzPV
	D+iNAxc3d2Oht8N4uYn5xSt1XgzDHyMJt+L1czqoOOt96CEBVxIoDnkufWJxy22s
	zKbFXUrwOh8cVNRNYGua1e9ataus+rNLqFWZvAWeBocfKkZz+HDDUXi8AHfjFg/g
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46mvd38ugx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 16:10:10 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54EDZJBF021396;
	Wed, 14 May 2025 16:10:10 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46mbfrn5kj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 16:10:09 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54EGA5vm19988794
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 16:10:06 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD038200B7;
	Wed, 14 May 2025 16:10:05 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 456B4200B8;
	Wed, 14 May 2025 16:10:05 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 May 2025 16:10:05 +0000 (GMT)
Date: Wed, 14 May 2025 18:10:03 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Ignacio Moreno
 Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
        kernel test robot
 <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
        Andrew Morton
 <akpm@linux-foundation.org>,
        Linux Memory Management List
 <linux-mm@kvack.org>,
        Yang Shi <yang@os.amperecomputing.com>,
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
Message-ID: <20250514181003.3b4caa3c@p-imbrenda>
In-Reply-To: <6d415e22-9461-4434-9a0b-25423478674f@lucifer.local>
References: <202505140943.IgHDa9s7-lkp@intel.com>
	<63ddfc13-6608-4738-a4a2-219066e7a36d@kuka.com>
	<8e506dd6-245f-4987-91de-496c4e351ace@lucifer.local>
	<20250514162722.01c6c247@p-imbrenda>
	<0da0f2fc-c97f-4e95-b28e-fa8e7bede9cb@linux.ibm.com>
	<20250514164822.4b44dc5c@p-imbrenda>
	<6f8f3780-902b-49d4-a766-ea2e1a8f85ea@linux.ibm.com>
	<6d415e22-9461-4434-9a0b-25423478674f@lucifer.local>
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
X-Proofpoint-GUID: NXX-GJsxG1skImeDNDQFWIh7c_4GFWUe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDE0MCBTYWx0ZWRfX1/d3m/tOXQtF tzyxSEThKWfVNTi+WJgbIXOlxjmKHk5+dOT14LOsVr+x0xpgHJEy8fuQPB5YmHgTy0+IR2mo58s QmkS/QLJorv90PhXS6fbezdM0qtWXztw1unJIZZOeg8kvtBycaxQZpM96SWROoUcDaBcarUbzSj
 oHG9QUWtDT4KdD4jZkVBbF7wcmcdVLkkXjUSR2+c+aKe7p0Cou7YZ/RuyrG34N0RQarn6YpfN8C uoVf2h1/jnsn5E7x3KReezSS0f/XJ+1Np2hsf9ds8+nk/LJOXc3Ttidp3W+NelDVKB0SLSerNHS j30Ubw/w6Hd2LtT8hc/+gISTQl/SH0xC9I6SU/U/oVWbkKAMluSHyowovz+PN4cQEEKf965f4jB
 GTEen1yxYL1YbJxjsMC/VHg1ZFmxV5mkxfYbcBhdV312B3RyUj8m9HosWG1BJURdmrYihrci
X-Proofpoint-ORIG-GUID: NXX-GJsxG1skImeDNDQFWIh7c_4GFWUe
X-Authority-Analysis: v=2.4 cv=GbEXnRXL c=1 sm=1 tr=0 ts=6824c062 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=yPCof4ZbAAAA:8 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=OnEVUMqZS2F2_DRSUccA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_04,2025-05-14_03,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505140140

On Wed, 14 May 2025 17:01:55 +0100
Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> On Wed, May 14, 2025 at 04:52:18PM +0200, Christian Borntraeger wrote:
> >
> >
> > Am 14.05.25 um 16:48 schrieb Claudio Imbrenda:
> >  
> > > > > > > A possible fix for this would be to rename PROT_NONE in the enum to PROT_TYPE_NONE.  
> > > > >
> > > > > please write a patch to rename PROT_NONE in our enum to
> > > > > PROT_TYPE_DUMMY, I can review it quickly.
> > > > >
> > > > > if Paolo has no objections, I'm fine with having the patch go through
> > > > > the mm tree  
> > > >
> > > > Yes, lets do a quick fix and I can also do
> > > > Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> > > >
> > > > for a s/PROT_NONE/PROT_TYPE_NONE/g
> > > > patch.  
> > >
> > > I'd rather have PROT_TYPE_DUMMY, since it's a dummy value and not
> > > something that indicates "no protection"  
> >
> > makes sense.  
> 
> Thanks for the quick response guys, did you want us to write the patch?

yes please

please don't forget to also add the following tags:

Fixes: b3cefd6bf16e ("KVM: s390: Pass initialized arg even if unused")
Cc: stable@vger.kernel.org

> 
> We can put something together quickly if so and cc you on it.

yep

> 
> Ack on the comment above, of course!
> 
> Cheers, Lorenzo



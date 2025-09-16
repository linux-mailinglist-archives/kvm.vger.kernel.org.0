Return-Path: <kvm+bounces-57770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EC63B59F6E
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 19:37:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD2781C021E8
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 17:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85EEA2F5A2F;
	Tue, 16 Sep 2025 17:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eRC+ZfaN"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F936279DC9;
	Tue, 16 Sep 2025 17:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758044216; cv=none; b=G6WzPH3gJxUgTLUqoaWn4Gvd++Og2ugnT7N0+FzTlhPqpi41OkQfkGsNTeFV9knl0wWaEKEQqKpqZ59bCpvWvEmgBqbNB3R7mdC615XECf+XNIxl7DMOMW++/23DYNH5q0FY6fA8HKa2Pl/BX7jgpQF58r7Qs0XNU+nLHlMeZOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758044216; c=relaxed/simple;
	bh=Tq3qiRdKHtGWFmyfJ8T9cJP2l3xcUcWt+2RBWmB87kM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TBlte4oV6yCYSmAnejzsZVip6Z8ifeR1StCZ62oqXvY6qkEhOIgvP52q4C4vd3fi3JPQuezKymNUGSHaLnIwyARF8nz+ALEqlEkmyPXmfY8/skAlDhzgbfWa7d4R1D0gl9IoAom3R04hNTleA9Ki2/1K/IRe+bx85T78uEZR3LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eRC+ZfaN; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GBfdZi024021;
	Tue, 16 Sep 2025 17:36:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=pIAJLowRgmaD1xgD3TMkulRkgRy+H0
	16SyypMSofyyk=; b=eRC+ZfaNDnHhlSLHrVVFJtnyx8fzmaJ4r00LA/JYgkqy0Z
	5B4BRTAhE1KOFisHhn/K5bSLJqUbNlfl+ii0TO936sgWAPCuliSvyDZxYdkoDdXV
	yA75qTK2NpLda/ryMndaJ8HNvUv+pMi4HuuJtXsCwXUJ4tYg7C7cO3glOmGCg2rr
	LLHW3NZDsEFsib/GXHsV7lfiC9fq1Pkjyad4vx0Gh2uH0NiV66U1mg78NA66vfjB
	JwKCfrTMNNFiFL4gIPnZCnuGUIlSsX6DwAKWGjpuCXhl3EbPNeTm+jk24FBCZP1X
	CMimjXxVS17tM/FS4qsADtbYLnHrrlMNFrcMopjA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 496avntu1p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 17:36:51 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58GFH1tQ018632;
	Tue, 16 Sep 2025 17:36:50 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 495n5mcye6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 17:36:50 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58GHakJs60227930
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 17:36:46 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3C7A920043;
	Tue, 16 Sep 2025 17:36:46 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A4D5F20040;
	Tue, 16 Sep 2025 17:36:45 +0000 (GMT)
Received: from osiris (unknown [9.111.88.139])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 16 Sep 2025 17:36:45 +0000 (GMT)
Date: Tue, 16 Sep 2025 19:36:44 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 08/20] KVM: s390: KVM page table management functions:
 allocation
Message-ID: <20250916173644.27229Kcc-hca@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
 <20250910180746.125776-9-imbrenda@linux.ibm.com>
 <20250916162653.27229G04-hca@linux.ibm.com>
 <20250916184737.47224f56@p-imbrenda>
 <63e8c905-28b1-4e1f-be77-e0789bd75692@de.ibm.com>
 <20250916190514.1a3082bd@p-imbrenda>
 <15f451d9-ecb3-4a82-9b9a-2de64b93944d@de.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15f451d9-ecb3-4a82-9b9a-2de64b93944d@de.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6Gu3lOm8AHS-3R8C-G1m7UJPuKzXB--7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE1MDAyOCBTYWx0ZWRfX6V/RQNCp2U6K
 ryv1ye8MSJ/mCs4FvCxFEwFzwqvwt37VY5wq6HXOv/NUDe18X3mzdLThc2V3vxb0RIn3qPLiWOs
 2URJZ4izd5vxEgHxlEPg4blLnzDV1WfxnrJ9BVe+p1FPWrVHBIv3fvgveGVpEUqwIsUv69E9atv
 WoRlTbHA6UJgWEVjVtC/leqq0U6zpI/aovmy0uvzVWXbTTIoPXM11UKNno1xWEvUJV9IDBMAd7H
 ujgsF12bpyxILb5o7WxOqs8PyZUBRXJreLN3Mnk1xq8qNHwj/loV7XYH1VJcjcjDtGE03nFTU7b
 4yBuo5/NMC8sdej9wWNJAzEJiGoE1RN2gS2O1NW5Y7SeIx0VLJ+byY5Q8Xgj3MCYl+bGig16gFM
 pGzwfl1Q
X-Authority-Analysis: v=2.4 cv=HecUTjE8 c=1 sm=1 tr=0 ts=68c9a033 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=07d9gI8wAAAA:8 a=pldl6WKZccRfTaVWpKkA:9
 a=CjuIK1q_8ugA:10 a=e2CUPOnPG4QKp8I52DXD:22
X-Proofpoint-GUID: 6Gu3lOm8AHS-3R8C-G1m7UJPuKzXB--7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509150028

On Tue, Sep 16, 2025 at 07:06:06PM +0200, Christian Borntraeger wrote:
> 
> Am 16.09.25 um 19:05 schrieb Claudio Imbrenda:
> 
> > > > I think GFP_ATOMIC actually gives more guarantees?
> > > 
> > > In real life GFP_ATOMIC can fail, GFP_KERNEL does not.All gfp allocation failures
> > > are usually the atomic ones.
> > 
> > interesting... then I guess I need GFP_KERNEL | GFP_ATOMIC ?
> 
> No. ATOMIC always means: can fail.

So GFP_KERNEL alone is what is needed here. It is undocumented that
small GFP_KERNEL allocations will never fail (retried for ever):

https://lwn.net/Articles/627419/
https://lwn.net/Articles/723317/

While GFP_ATOMIC will fail e.g. if I/O is required to free up some
memory.


Return-Path: <kvm+bounces-57845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B20CB7DB06
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:32:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 498D11883003
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 12:30:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC73C30CB23;
	Wed, 17 Sep 2025 12:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oR4EE22w"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870AD3074B7;
	Wed, 17 Sep 2025 12:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112222; cv=none; b=G9jcqbsfQ5kZU3ydNzzMExt4qzn200Rckmy38O4qyYlJ3JvXEuF2cNiHaNJVAbTH9eetqF94nkaqW12W779EZP3qT2nhUe+NVXYv1nPG8BtiFa6dulmxzbSBC1peyiD7s4Qtdov9BoADn6T7T7HFBOiqGvlYO6S6YTc4PmFoQK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112222; c=relaxed/simple;
	bh=pgjsoGN/QnRmE64z/FFgIhQj0CgOnvLspuH4uPdkQz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z9xZ3kIU4/JNk0ZFikyH9WlxM6KKEZhasa7yRiYJR3ABsPxnmcyXfsHKOfOU5nYkp42A/4X51bKpr597nTHivis6wE1PkbWTMxxof0pOzu6Cv0cKVyJ5v5Ez0GA859rVSPmI7xjowazfBnapv0RZXzy9CWD+KnBXsGSyCLKhd8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oR4EE22w; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58H9UXE6012254;
	Wed, 17 Sep 2025 12:30:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=kdv4hgpVvNlrr1dhET+2pFxsqa9hMZ
	gtSQtoutfU4K0=; b=oR4EE22wgi20lGZNzdo+k8kmGrK7mKfnAuy+LLDVGAMsgM
	k/9hlDtqCdW6fO7udmgZRQrn5MWq3rD83ObHUP/oL1USjnBR8cD3BsxtR19wnl61
	E7FHRay7k+KVrBJcMF8L0ZaL5BaosmwRgPiXNjoQqHIlz9J2Bu/fxyCPMpF0DNBT
	aErFKr6j4yIs5de6oF95sZyadjwhtNIAsNLi07rUZFobDqbk+CzQnCgWfZbnV+iD
	PG1Z5MY63IldHWYRg9GCtOYo9rnPYbepIE/oUiw7AgUwzx9fFjkY84cXd6oe5WA4
	+3ez7WdXwdP4udH6EkabR6Q281Qp24x8TVC2u3Lg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4j3mjf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 12:30:12 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58H9gWck005929;
	Wed, 17 Sep 2025 12:30:12 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 495jxu9d1f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 12:30:11 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58HCU8cq18743664
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 12:30:08 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F1C912004B;
	Wed, 17 Sep 2025 12:30:07 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BFE5920040;
	Wed, 17 Sep 2025 12:30:07 +0000 (GMT)
Received: from osiris (unknown [9.152.212.133])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 17 Sep 2025 12:30:07 +0000 (GMT)
Date: Wed, 17 Sep 2025 14:30:06 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: Re: [PATCH v2 08/20] KVM: s390: KVM page table management functions:
 allocation
Message-ID: <20250917123006.7515C59-hca@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
 <20250910180746.125776-9-imbrenda@linux.ibm.com>
 <20250916162653.27229G04-hca@linux.ibm.com>
 <20250916184737.47224f56@p-imbrenda>
 <63e8c905-28b1-4e1f-be77-e0789bd75692@de.ibm.com>
 <20250916190514.1a3082bd@p-imbrenda>
 <15f451d9-ecb3-4a82-9b9a-2de64b93944d@de.ibm.com>
 <20250916173644.27229Kcc-hca@linux.ibm.com>
 <20250917072733.7515Af5-hca@linux.ibm.com>
 <20250917132556.4814fe98@p-imbrenda>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917132556.4814fe98@p-imbrenda>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Qf5mvtbv c=1 sm=1 tr=0 ts=68caa9d4 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=wDlmtC-mBC1sNVY2sJ0A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: y6kJKswtGmz2LxLkEARMGkMbp8NL934k
X-Proofpoint-GUID: y6kJKswtGmz2LxLkEARMGkMbp8NL934k
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX6SgtxQ3rDhwB
 hzgDx1laFKx7MlPWvkZJxp1TgKy4rcP0mZe/R4ZIHhw0fQblbxNOiNuNSQk2YHGSJLwLWPqLkQK
 p8tBqhye9wJtaW0ldz7gbmKXYsyiqY0rNYpX2RjtlXb6keYl32FrsfneElc2BWXZOiI+YromRof
 Ae6yfviHyCJlvNCUnECCle2agMvW17pxdbO8IaJS84ZtomHqKdng46/bTEulm3RFBYBP9VIOk1p
 DzpU/ciKsNd7WXQVo0i6bipLw+L5p+29gvMAmfTQ2BevdK6cfWSCDwCk4wlQPlxRjviV2jm554M
 631dFRMSofSa4YdIvT89FUtaYhUbUzGZ37PcZM3Y+f7EGkycdDqRsuf+HVGTPuXgTz3PqBYHuD4
 szgWmorb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 phishscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204

On Wed, Sep 17, 2025 at 01:25:56PM +0200, Claudio Imbrenda wrote:
> On Wed, 17 Sep 2025 09:27:33 +0200
> Heiko Carstens <hca@linux.ibm.com> wrote:
> 
> > On Tue, Sep 16, 2025 at 07:36:44PM +0200, Heiko Carstens wrote:
> > > On Tue, Sep 16, 2025 at 07:06:06PM +0200, Christian Borntraeger wrote:  
> > > > 
> > > > Am 16.09.25 um 19:05 schrieb Claudio Imbrenda:
> > > >   
> > > > > > > I think GFP_ATOMIC actually gives more guarantees?  
> > > > > > 
> > > > > > In real life GFP_ATOMIC can fail, GFP_KERNEL does not.All gfp allocation failures
> > > > > > are usually the atomic ones.  
> > > > > 
> > > > > interesting... then I guess I need GFP_KERNEL | GFP_ATOMIC ?  
> > > > 
> > > > No. ATOMIC always means: can fail. 
> 
> my issue is that GFP_KERNEL can sleep, and this allocation is sometimes
> called from atomic contexts (e.g. while holding spinlocks)
> 
> the right way to do this would be with mempools, to allocate memory
> (and potentially sleep) when we are not in atomic context, and use it
> whenever needed. this is on my to-do list for the future, but right now
> I'd like to avoid having to refactor a ton of code.

I doubt this is accetable even for an intermediate solution. As soon
as the host is under memory pressure and starts doing I/O to free up
memory, you will end up in -ENOMEM situations for simple guest page
allocations.

What happens with a guest in such a situation? Is this gracefully
handled without that the guest is terminated?

> > Another correction: it should be GFP_KERNEL_ACCOUNT instead, like it
> > used to be before in gmap_alloc_crst() since those page tables should
> > be accounted to the process which is allocating them.
> 
> gfp_types.h says:
> 
>  * %GFP_KERNEL_ACCOUNT is the same as GFP_KERNEL, except the allocation is
>  * accounted to kmemcg.
> 
> I thought that without GFP_KERNEL_ACCOUNT, it would be accounted toward
> the process?
> The documentation is a little confusing here

Documentation/core-api/memory-allocation.rst:

  * Untrusted allocations triggered from userspace should be a subject
    of kmem accounting and must have ``__GFP_ACCOUNT`` bit set. There
    is the handy ``GFP_KERNEL_ACCOUNT`` shortcut for ``GFP_KERNEL``
    allocations that should be accounted.

This is done for all page table allocations, except if mm == init_mm
(and unfortunately also not for the s390 specific crste alloc
functions - I'll send a patch for that).


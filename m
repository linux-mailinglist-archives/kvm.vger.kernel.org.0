Return-Path: <kvm+bounces-32525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 726EA9D9893
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 14:33:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 078BD163D90
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 13:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C630D193408;
	Tue, 26 Nov 2024 13:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mikvDnbK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770A3B652;
	Tue, 26 Nov 2024 13:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732628002; cv=none; b=Aq9O6NsK0gmUvkLCiFthDwXbFlm8otu/AzN06uJUG/cZzxDpOm22NrIZuGvZ3uaVipZKeJOU67Qd+bHRcGFhKTxdGbyXICu6z/A8azSUiF6yw6aixNOwwudJZT2KejgEljMijuRUVfzW6LAZhdtbxPhm1v83vYBFLGTDekHigVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732628002; c=relaxed/simple;
	bh=xfKsoAevVrw3eYrCV3zDJDoJY9EpGFkYsAtur1PbF54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KSTAt+6E0KTvrfHs7RfMnmdz+x8/kTIqT2lpwYmMW6esedfFGJsZbcnCu4cgOOxBaJJUYJHNcvh7KV2k+uRwIX/trw0pFjGKo41vSyNOifGv2w8LoYoxYg/CBA3j+/DEmidFAuMNvPKuTbfentZoqtBMyS54Po0phJ7VUDhwtIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mikvDnbK; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AQ75vYU022515;
	Tue, 26 Nov 2024 13:33:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ztQg2zVAQwGhslLLUkcoUyVTe60KBL
	qcMI6KHH1mwBA=; b=mikvDnbK1iuI0kYdn8ZDadN768jAE48/xRoBKyZZq+/Bq2
	quAig4LYQKdBq+g17BzHvTHCeiGHsY94z/BQhfuoYW66ulr1YwSR2hPk8YolNAi8
	pa+12OW0/mLQot4mhnLBOW0CwZjSK+exsQ8iXgZgtmGHvNllxZRo2U59UoCVJvx3
	JP5OwEp6eJGItF8aWCBVqaATYDI/9StrzlmRLoVqj/qMCLmtdTgXNTxR5iQgRRJB
	3tfl+BCbGUwzRmoPuoX81z/9uOOe/+vSGasLCvaawxz94ezkNZ54VPAsYvS0jSC6
	SrrlvownVBTSdENS+9xePD1Pu1tqIraT2mClobLA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43386jwsad-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 13:33:16 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AQ6oUNw005727;
	Tue, 26 Nov 2024 13:33:16 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 433ukj4e6n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 13:33:16 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AQDXC5F40370596
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Nov 2024 13:33:12 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AD9272004D;
	Tue, 26 Nov 2024 13:33:12 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 88C5620043;
	Tue, 26 Nov 2024 13:33:12 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 26 Nov 2024 13:33:12 +0000 (GMT)
Date: Tue, 26 Nov 2024 14:33:10 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] KVM: s390: Increase size of union sca_utility to
 four bytes
Message-ID: <20241126133310.8074-A-hca@linux.ibm.com>
References: <20241126102515.3178914-1-hca@linux.ibm.com>
 <20241126102515.3178914-4-hca@linux.ibm.com>
 <2d3862ea-4112-4a03-9e4b-ac4e8e23a7f4@linux.ibm.com>
 <20241126132152.3dc746e7@p-imbrenda>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241126132152.3dc746e7@p-imbrenda>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: en8fffoQ29N7LvOXiFJ5hCZsjhtQA2Me
X-Proofpoint-GUID: en8fffoQ29N7LvOXiFJ5hCZsjhtQA2Me
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 mlxlogscore=731 spamscore=0 suspectscore=0 phishscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411260109

On Tue, Nov 26, 2024 at 01:21:52PM +0100, Claudio Imbrenda wrote:
> On Tue, 26 Nov 2024 13:09:56 +0100
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
> > On 11/26/24 11:25 AM, Heiko Carstens wrote:
> > [...]
> > >   union sca_utility {  
> > 
> > Would you mind adding a comment?
> > 
> > 
> > ""Utility is defined as 2 bytes but having it 4 bytes wide generates 
> > more efficient code. Since the following bytes are reserved this makes 
> > no functional difference.""
> 
> looks good, thanks!

Thanks a lot! I added the comment and applied the series.


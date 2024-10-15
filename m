Return-Path: <kvm+bounces-28904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78B5299F0EA
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 17:20:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D01F2835E1
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 15:20:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4161E1B3921;
	Tue, 15 Oct 2024 15:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TpHTiMsV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DBA1CB9FE;
	Tue, 15 Oct 2024 15:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729005625; cv=none; b=Q1cprr0AMJv98VOgwzgRcSj5Cul5XqISgC2EvR3+0+EaTCO33ikGOc0fxLYllq+u1yIyAf8max0q9Io5jn0O9M+VFQ1Vi18jsIiiFjl9ss/RmI/XARru0MLCQ/JextviBLcegIaFcayX3M3hKK8a7ND3X3glDkiz/DvlY/Px3Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729005625; c=relaxed/simple;
	bh=lVkV1vFjNJEMDvdyimYUH+siM7VBxYLLrgPg2wIHi2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IQgD4wYbTVn50HTqWxwWhxF+ak7OqGEIM1R06df/PquIlWME75WdJ6r4lg9VL0vBkas2x8NeNKdL/GXBqepzKX2uk5DsKh2uI8mbdTUSVWVC3eu0YibpL4sCwN18oOueyLMZrffizfrUbUW7eAeHm3D1vwa/oPzXjM11yYw+DKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TpHTiMsV; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FFJqMo016714;
	Tue, 15 Oct 2024 15:20:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=iGuQeqwI6HZC3u7lEqO9aIAaSIscVF
	1CMX/wdfvit/s=; b=TpHTiMsV7gss9CE2gbTv2CeHsBmwRk9TsMr12i/hKys93P
	WKlRkjvobxfliO1vTzhtIxt+eW5FfqcrDXvU1ucgCaZCC8y4F+nwbiO7zezxjUOk
	TUwI9kmcCTCGDAd9VrQ4PoTD9oO0joSVgiuTDmBl4io9IwAaF71Y7u168DIqGS4+
	MokAYq7Sl1D3LCgAi0k9IuBtPoJirNfIt7OmSf0A5WLM0LzpVjTrq59FBGwRbNKT
	Q+TYgxxaHAyejOuT3a7N/lXpAr4gdzStgwz8h5PRBpDmgFGvR0gFCNBtbXqtz8gt
	s8j/VF7dXYidIvDu/zIsipCnLc2M6oPxIFVCSW6A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429txf004v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 15:20:16 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49FFKFsp017969;
	Tue, 15 Oct 2024 15:20:15 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429txf004n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 15:20:15 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49FEdsIN006401;
	Tue, 15 Oct 2024 15:20:14 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4284xk4fps-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 15:20:14 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49FFKA2H57999682
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 15:20:10 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AA9F62004F;
	Tue, 15 Oct 2024 15:20:10 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 133C420040;
	Tue, 15 Oct 2024 15:20:10 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 15 Oct 2024 15:20:10 +0000 (GMT)
Date: Tue, 15 Oct 2024 17:20:08 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Eric Farman <farman@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux.dev, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Mario Casquero <mcasquer@redhat.com>
Subject: Re: [PATCH v2 4/7] s390/physmem_info: query diag500(STORAGE LIMIT)
 to support QEMU/KVM memory devices
Message-ID: <20241015152008.7641-P-hca@linux.ibm.com>
References: <20241014144622.876731-1-david@redhat.com>
 <20241014144622.876731-5-david@redhat.com>
 <20241014184339.10447-E-hca@linux.ibm.com>
 <8131b905c61a7baf4bd09ec4a08e1ace84d36754.camel@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8131b905c61a7baf4bd09ec4a08e1ace84d36754.camel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: i1zBRW8UGLcWVcN5Coobxt0ARxFddDl7
X-Proofpoint-ORIG-GUID: Ub7xaX8YqTGNc9RIsPz804moAAXEwY3a
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1015 mlxscore=0 adultscore=0
 mlxlogscore=649 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410150105

On Tue, Oct 15, 2024 at 11:01:44AM -0400, Eric Farman wrote:
> On Mon, 2024-10-14 at 20:43 +0200, Heiko Carstens wrote:
> > On Mon, Oct 14, 2024 at 04:46:16PM +0200, David Hildenbrand wrote:
...
> > +#define DIAG500_SC_STOR_LIMIT 4
...
> I like the idea of a defined constant here instead of hardcoded, but maybe it should be placed
> somewhere in include/uapi so that QEMU can pick it up with update-linux-headers.sh and be in sync
> with the kernel, instead of just an equivalent definition in [1] ?
> 
> [1] https://lore.kernel.org/qemu-devel/20241008105455.2302628-8-david@redhat.com/

It is already a mess; we have already subcode 3 defined:

#define KVM_S390_VIRTIO_CCW_NOTIFY 3

in

arch/s390/include/uapi/asm/virtio-ccw.h

which for some reason is uapi. But it doesn't make sense to put the
new subcode 4 there too. So what is the end result?

Another uapi file? I think resolving this would be a project on its own.


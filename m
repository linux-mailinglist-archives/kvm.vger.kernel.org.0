Return-Path: <kvm+bounces-30005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC0039B5EDE
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 10:30:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9D9F2840DF
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 09:30:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C25C1E22FB;
	Wed, 30 Oct 2024 09:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SKauxu8J"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32EF197531;
	Wed, 30 Oct 2024 09:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730280641; cv=none; b=GTjFUcHFpPBVOz5yk/QN2VnYIduoruWiimolVDiyt72vmudeWm1HDY4ZHq9j0TlSrkFAFqoTp+2RJglhLNjdxzqrzKp5MpIisOcu1QNdvSstLkdPPCBDAvijWr+df+pXaryohc91z5vKTl5S0QMHlrUjnJt1aoXPgjZpeCerPjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730280641; c=relaxed/simple;
	bh=E8XocLVaBm4vpPCQMIH8vrzt3TugyPkWTEMWKAAVU7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MpS+vFe2mbyvm+lD+Z5R2VYNWuSq4ozHQEjUPe6K0nLviy17JFdv3ZWAZtWiPXKplEQarNPDsgz5cf8hJj7K0MM7XdKtX/nyxYEFpW58kvon1L/JQnVxmwC4FPBCBscSQk7mmlIRTXLU2vhATpDdwC+gNDOUgltimcqRubvGC0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SKauxu8J; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49U2d4GX003254;
	Wed, 30 Oct 2024 09:30:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ynyclhhbgRfDHStF+YBUgdBncEbAoS
	gsFp83z+7rLMA=; b=SKauxu8J6NwxObko2XflkjLEsNLzMCaRu7csK7NZ+Z1x2W
	QjGquG5vhbqdeCZrJpqPezewGPkds+IaDgY5Uu/LvSHhlbU+dhVQozYZOneNzBWE
	NyPsdsl8mwe2fhD6x9sjlbZ66f/jvXocWEBoQs+qmfKVlNPbTM7dlI1tEltPPkm0
	C9pgPsvOKPTUNWOL2K7MoVEjiumFT+uVU4y4CKvE8GPhrFjPlWH992+Gp3DwIk0E
	5ua/pUC4VEqWviIWpJLjpfInJ5c0a8gi0bzKQ9ub0dOZdfoXhSsQLq+qdBCjYNHv
	ro9vmu5fMumyb/95+hUC5Yank7AIysKYFXMdkk/Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42j3nsxa4b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 09:30:29 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49U9UTxt027922;
	Wed, 30 Oct 2024 09:30:29 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42j3nsxa42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 09:30:29 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49U77mvw013589;
	Wed, 30 Oct 2024 09:30:27 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42hbrmyc9r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 09:30:27 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49U9UONX32899720
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 09:30:24 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E18CF20043;
	Wed, 30 Oct 2024 09:30:23 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2FA7420040;
	Wed, 30 Oct 2024 09:30:21 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 30 Oct 2024 09:30:21 +0000 (GMT)
Date: Wed, 30 Oct 2024 10:30:17 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
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
        Eric Farman <farman@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v3 7/7] s390/sparsemem: provide
 memory_add_physaddr_to_nid() with CONFIG_NUMA
Message-ID: <20241030093017.6264-G-hca@linux.ibm.com>
References: <20241025141453.1210600-1-david@redhat.com>
 <20241025141453.1210600-8-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025141453.1210600-8-david@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KANImo9SxKQni0nP7uMhU3bAxJm1G1xZ
X-Proofpoint-GUID: h1PsrlS2Uz19eKGx8RjTRA0zXxFEnG3d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 bulkscore=0 mlxlogscore=758 clxscore=1015 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 mlxscore=0 impostorscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410300072

On Fri, Oct 25, 2024 at 04:14:52PM +0200, David Hildenbrand wrote:
> virtio-mem uses memory_add_physaddr_to_nid() to determine the NID to use
> for memory it adds.
> 
> We currently fallback to the dummy implementation in mm/numa.c with
> CONFIG_NUMA, which will end up triggering an undesired pr_info_once():
> 
> 	Unknown online node for memory at 0x100000000, assuming node 0
> 
> On s390, we map all cpus and memory to node 0, so let's add a simple
> memory_add_physaddr_to_nid() implementation that does exactly that,
> but without complaining.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/s390/include/asm/sparsemem.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
...

> diff --git a/arch/s390/include/asm/sparsemem.h b/arch/s390/include/asm/sparsemem.h
> index ff628c50afac..6377b7ea8a40 100644
> --- a/arch/s390/include/asm/sparsemem.h
> +++ b/arch/s390/include/asm/sparsemem.h
> @@ -5,4 +5,12 @@
>  #define SECTION_SIZE_BITS	27
>  #define MAX_PHYSMEM_BITS	CONFIG_MAX_PHYSMEM_BITS
>  
> +#ifdef CONFIG_NUMA
> +static inline int memory_add_physaddr_to_nid(u64 addr)
> +{
> +	return 0;
> +}
> +#define memory_add_physaddr_to_nid memory_add_physaddr_to_nid
> +#endif /* CONFIG_NUMA */
> +

We would need to have the same for phys_to_target_node(), even though
it looks like this won't be used on s390 currently.

Anyway, I'll add that, if I don't forget about it :)

For this patch:
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>


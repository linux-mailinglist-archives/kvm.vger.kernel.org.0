Return-Path: <kvm+bounces-10834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DD773870E88
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 22:44:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93F8D288357
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 21:44:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F8C57A706;
	Mon,  4 Mar 2024 21:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="akR5iVBL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3A1200D4
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 21:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588686; cv=none; b=BgwOm0TloQf86bK9FvISPnr4IUv5Fb4uTNKjWbWeRPairZ1xdU0uF5wUbVWrCEo/Xah9d5etsdsNOgIuMUNJmGo9BLcOVcdFBZTN2VR8F0O6pJ3XRKHhmH7yuclPuR0NIReKpPBTR3eJAJNEXG4Mp++CTA6mq2CimkvcAAHFBT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588686; c=relaxed/simple;
	bh=qUXY5SCymmcXUwvaMMEJ16SNv1huaucR8QQQ5IVuvMA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ocgIlOpEhB85jymTEiUsJ1R6ShxZLl94Q8j3OAAcny3JDC3QGPATu50He+Tk2E/aT2+6iyo/gIIuxHPWysiYihmMMkXAqR0RC10D0KQSNnvs0qKMMv/3pzPgMX0EEouZuzzDLShI6nruMbu3qHDvKZD5cwuQGS+jOis/rt+MsjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=akR5iVBL; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 424LdMin022408;
	Mon, 4 Mar 2024 21:43:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	date:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=qcppdkim1; bh=El06DMQvHJyxIKKDY/bs9
	Vo40o7B7hw2Rs+SBJ2tHBM=; b=akR5iVBLVaNC8y5fU4hH5Mgk90A3k97IMb4we
	dHz6+q1x+Z+m7NgtcasBWZxQP1/02BxVRfVhDbtOiIUpxmi0dVvrmC06EagOPiV0
	/KZZOBtc2MCFYPqGAdvCjTO6ZeKWzTbZmq5hgjc6BNKYYzvEDsZYTzDj6OYFmTKf
	bRVlkduLMPnH8DK5eGPsE91xMis4Y2Jtr+MQm+YHgQRicPNW+s2c8V6h9yE742iz
	X9zZ2wRLgi4T6Y3YVK5b2plfLhVFNv2khTefd8o+K8IQDxvmrcoys3Vyq1uFhXfC
	XceZWS9cOUaqdp5Ts0S2CFC4OX6PH/ercyPO8wBI2rqyB+gLA==
Received: from nasanppmta01.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3wn6qx234s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Mar 2024 21:43:45 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 424Lhik8015397
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 4 Mar 2024 21:43:44 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Mon, 4 Mar 2024 13:43:43 -0800
Date: Mon, 4 Mar 2024 13:43:43 -0800
From: Elliot Berman <quic_eberman@quicinc.com>
To: David Hildenbrand <david@redhat.com>
CC: Sean Christopherson <seanjc@google.com>,
        Quentin Perret
	<qperret@google.com>,
        Matthew Wilcox <willy@infradead.org>, Fuad Tabba
	<tabba@google.com>,
        <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>, <pbonzini@redhat.com>,
        <chenhuacai@kernel.org>, <mpe@ellerman.id.au>, <anup@brainfault.org>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <viro@zeniv.linux.org.uk>,
        <brauner@kernel.org>, <akpm@linux-foundation.org>,
        <xiaoyao.li@intel.com>, <yilun.xu@intel.com>,
        <chao.p.peng@linux.intel.com>, <jarkko@kernel.org>,
        <amoorthy@google.com>, <dmatlack@google.com>,
        <yu.c.zhang@linux.intel.com>, <isaku.yamahata@intel.com>,
        <mic@digikod.net>, <vbabka@suse.cz>, <vannapurve@google.com>,
        <ackerleytng@google.com>, <mail@maciej.szmigiero.name>,
        <michael.roth@amd.com>, <wei.w.wang@intel.com>,
        <liam.merwick@oracle.com>, <isaku.yamahata@gmail.com>,
        <kirill.shutemov@linux.intel.com>, <suzuki.poulose@arm.com>,
        <steven.price@arm.com>, <quic_mnalajal@quicinc.com>,
        <quic_tsoni@quicinc.com>, <quic_svaddagi@quicinc.com>,
        <quic_cvanscha@quicinc.com>, <quic_pderrin@quicinc.com>,
        <quic_pheragu@quicinc.com>, <catalin.marinas@arm.com>,
        <james.morse@arm.com>, <yuzenghui@huawei.com>,
        <oliver.upton@linux.dev>, <maz@kernel.org>, <will@kernel.org>,
        <keirf@google.com>, <linux-mm@kvack.org>
Subject: Re: Re: folio_mmapped
Message-ID: <20240304132732963-0800.eberman@hu-eberman-lv.qualcomm.com>
Mail-Followup-To: David Hildenbrand <david@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Quentin Perret <qperret@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, 
	steven.price@arm.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, 
	quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com, 
	yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, 
	keirf@google.com, linux-mm@kvack.org
References: <925f8f5d-c356-4c20-a6a5-dd7efde5ee86@redhat.com>
 <Zd8PY504BOwMR4jO@google.com>
 <755911e5-8d4a-4e24-89c7-a087a26ec5f6@redhat.com>
 <Zd8qvwQ05xBDXEkp@google.com>
 <99a94a42-2781-4d48-8b8c-004e95db6bb5@redhat.com>
 <Zd82V1aY-ZDyaG8U@google.com>
 <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>
 <ZeXAOit6O0stdxw3@google.com>
 <ZeYbUjiIkPevjrRR@google.com>
 <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com>
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: r2OsvqXDWNRuVAFSM5_fKjXXZ6SmFPTW
X-Proofpoint-ORIG-GUID: r2OsvqXDWNRuVAFSM5_fKjXXZ6SmFPTW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-04_18,2024-03-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 phishscore=0
 clxscore=1015 adultscore=0 spamscore=0 mlxlogscore=753 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2402120000 definitions=main-2403040167

On Mon, Mar 04, 2024 at 09:17:05PM +0100, David Hildenbrand wrote:
> On 04.03.24 20:04, Sean Christopherson wrote:
> > On Mon, Mar 04, 2024, Quentin Perret wrote:
> > > > As discussed in the sub-thread, that might still be required.
> > > > 
> > > > One could think about completely forbidding GUP on these mmap'ed
> > > > guest-memfds. But likely, there might be use cases in the future where you
> > > > want to use GUP on shared memory inside a guest_memfd.
> > > > 
> > > > (the iouring example I gave might currently not work because
> > > > FOLL_PIN|FOLL_LONGTERM|FOLL_WRITE only works on shmem+hugetlb, and
> > > > guest_memfd will likely not be detected as shmem; 8ac268436e6d contains some
> > > > details)
> > > 
> > > Perhaps it would be wise to start with GUP being forbidden if the
> > > current users do not need it (not sure if that is the case in Android,
> > > I'll check) ? We can always relax this constraint later when/if the
> > > use-cases arise, which is obviously much harder to do the other way
> > > around.
> > 
> > +1000.  At least on the KVM side, I would like to be as conservative as possible
> > when it comes to letting anything other than the guest access guest_memfd.
> 
> So we'll have to do it similar to any occurrences of "secretmem" in gup.c.
> We'll have to see how to marry KVM guest_memfd with core-mm code similar to
> e.g., folio_is_secretmem().
> 
> IIRC, we might not be able to de-reference the actual mapping because it
> could get free concurrently ...
> 
> That will then prohibit any kind of GUP access to these pages, including
> reading/writing for ptrace/debugging purposes, for core dumping purposes
> etc. But at least, you know that nobody was able to optain page references
> using GUP that might be used for reading/writing later.

Do you have any concerns to add to enum mapping_flags, AS_NOGUP, and
replacing folio_is_secretmem() with a test of this bit instead of
comparing the a_ops? I think it scales better.

Thanks,
Elliot



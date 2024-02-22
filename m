Return-Path: <kvm+bounces-9447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21C4186071A
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 00:45:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 78D24B21413
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 23:45:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2364D13BAE1;
	Thu, 22 Feb 2024 23:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="ewZeBfW5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D655B20B2E
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 23:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708645493; cv=none; b=ammPsx16vLH+/t/MCfgT+CQUPs8WXWaIpbeuWN0homqMJ9MLKBwUKQUHJyukGDB1nIYzJMzH6iBDVR0gGkCJygOfsmVlOL+gbvg/BgBjwOjhPexoFPFoQXUF2esvKwOUdXrqHEij29JwPxXf07twerDTDfzEQlggUUjmRM2j7Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708645493; c=relaxed/simple;
	bh=7l1JwDg0WinQwMDu1NIfsE37VvOC5VSEzSKwpcu5mWg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mkoro/AwHTHJKLnhHQuGMrPffYe0V85avvml5LTlGtwce0o4JUXvT7JXqh8xCuEARgY08Gz0kr2nVe4QzpUe5Davy3VFFBmuAAQXwMdqwj8+2a2AQilszEcKTzQcsQ3+To/A/m4wJAO63tCIL8zLuPeLAztoWlXx+IF1jrwyyuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=ewZeBfW5; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41MNhHow000650;
	Thu, 22 Feb 2024 23:43:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	date:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=qcppdkim1; bh=tHh4pceW3IuORx5D3OPtB
	tFCVLBx6FAHJl1RcllaU/U=; b=ewZeBfW57Gv81jHW6w6jP6EinFlRoGB1XJZU+
	a4uvPPgZAZqMoIezyqpHoT5GF/31dYnhaXvq9UJJrxz3/N0P3HRIg24yQXLqVjSh
	CCvBO2Ia9shNUAp9b92+w/JUXrPn9RVfMQ8kNrDkR8vuPcJYlqL2Lj1YwqufWY49
	qr2b9hqM/hXyrR8GY+PO0WIU2TU4EN4HxjrSPEnip955z6O0uaFA+vNXof8GJRh1
	EPUDI6lFIkLar58pk386sYjjHisb1b9cD74d2fA6BJrt5DZ4G5RMcbtQZhBp7Lms
	WC9FvT9eXujb/xR7zZ5eLBust/2d9yeJZP5hst0QyMlwjv2Lw==
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3weasbs7s0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Feb 2024 23:43:58 +0000 (GMT)
Received: from nasanex01b.na.qualcomm.com (nasanex01b.na.qualcomm.com [10.46.141.250])
	by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 41MNhwRH018673
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Feb 2024 23:43:58 GMT
Received: from hu-eberman-lv.qualcomm.com (10.49.16.6) by
 nasanex01b.na.qualcomm.com (10.46.141.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Thu, 22 Feb 2024 15:43:56 -0800
Date: Thu, 22 Feb 2024 15:43:56 -0800
From: Elliot Berman <quic_eberman@quicinc.com>
To: Fuad Tabba <tabba@google.com>
CC: <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>, <pbonzini@redhat.com>,
        <chenhuacai@kernel.org>, <mpe@ellerman.id.au>, <anup@brainfault.org>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <seanjc@google.com>,
        <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <willy@infradead.org>,
        <akpm@linux-foundation.org>, <xiaoyao.li@intel.com>,
        <yilun.xu@intel.com>, <chao.p.peng@linux.intel.com>,
        <jarkko@kernel.org>, <amoorthy@google.com>, <dmatlack@google.com>,
        <yu.c.zhang@linux.intel.com>, <isaku.yamahata@intel.com>,
        <mic@digikod.net>, <vbabka@suse.cz>, <vannapurve@google.com>,
        <ackerleytng@google.com>, <mail@maciej.szmigiero.name>,
        <david@redhat.com>, <michael.roth@amd.com>, <wei.w.wang@intel.com>,
        <liam.merwick@oracle.com>, <isaku.yamahata@gmail.com>,
        <kirill.shutemov@linux.intel.com>, <suzuki.poulose@arm.com>,
        <steven.price@arm.com>, <quic_mnalajal@quicinc.com>,
        <quic_tsoni@quicinc.com>, <quic_svaddagi@quicinc.com>,
        <quic_cvanscha@quicinc.com>, <quic_pderrin@quicinc.com>,
        <quic_pheragu@quicinc.com>, <catalin.marinas@arm.com>,
        <james.morse@arm.com>, <yuzenghui@huawei.com>,
        <oliver.upton@linux.dev>, <maz@kernel.org>, <will@kernel.org>,
        <qperret@google.com>, <keirf@google.com>
Subject: Re: [RFC PATCH v1 00/26] KVM: Restricted mapping of guest_memfd at
 the host and pKVM/arm64 support
Message-ID: <20240222141602976-0800.eberman@hu-eberman-lv.qualcomm.com>
Mail-Followup-To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, 
	steven.price@arm.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, 
	quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com, 
	yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, 
	qperret@google.com, keirf@google.com
References: <20240222161047.402609-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240222161047.402609-1-tabba@google.com>
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nasanex01b.na.qualcomm.com (10.46.141.250)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: fhC0kUwfYdTDLExX1jxdzFUHmT50Xkij
X-Proofpoint-GUID: fhC0kUwfYdTDLExX1jxdzFUHmT50Xkij
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-22_15,2024-02-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 bulkscore=0 phishscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 malwarescore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2402120000 definitions=main-2402220182

On Thu, Feb 22, 2024 at 04:10:21PM +0000, Fuad Tabba wrote:
> This series adds restricted mmap() support to guest_memfd [1], as
> well as support guest_memfd on pKVM/arm64.
> 
> We haven't started using this in Android yet, but we aim to move
> away from anonymous memory to guest_memfd once we have the
> necessary support merged upstream. Others (e.g., Gunyah [8]) are
> also looking into guest_memfd for similar reasons as us.

I'm especially interested to see if we can factor out much of the common
implementation bits between KVM and Gunyah. In principle, we're doing
same thing: the difference is the exact mechanics to interact with the
hypervisor which (I think) could be easily extracted into an ops
structure.

[...]

> In addition to general feedback, we would like feedback on how we
> handle mmap() and faulting-in guest pages at the host (KVM: Add
> restricted support for mapping guest_memfd by the host).
> 
> We don't enforce the invariant that only memory shared with the
> host can be mapped by the host userspace in
> file_operations::mmap(), but in vm_operations_struct:fault(). On
> vm_operations_struct::fault(), we check whether the page is
> shared with the host. If not, we deliver a SIGBUS to the current
> task. The reason for enforcing this at fault() is that mmap()
> does not elevate the pagecount(); it's the faulting in of the
> page which does. Even if we were to check at mmap() whether an
> address can be mapped, we would still need to check again on
> fault(), since between mmap() and fault() the status of the page
> can change.
> 
> This creates the situation where access to successfully mmap()'d
> memory might SIGBUS at page fault. There is precedence for
> similar behavior in the kernel I believe, with MADV_HWPOISON and
> the hugetlbfs cgroups controller, which could SIGBUS at page
> fault time depending on the accounting limit.

I added a test: folio_mmapped() [1] which checks if there's a vma
covering the corresponding offset into the guest_memfd. I use this
test before trying to make page private to guest and I've been able to
ensure that userspace can't even mmap() private guest memory. If I try
to make memory private, I can test that it's not mmapped and not allow
memory to become private. In my testing so far, this is enough to
prevent SIGBUS from happening.

This test probably should be moved outside Gunyah specific code, and was
looking for maintainer to suggest the right home for it :)

[1]: https://lore.kernel.org/all/20240222-gunyah-v17-20-1e9da6763d38@quicinc.com/

> 
> Another pKVM specific aspect we would like feedback on, is how to
> handle memory mapped by the host being unshared by a guest. The
> approach we've taken is that on an unshare call from the guest,
> the host userspace is notified that the memory has been unshared,
> in order to allow it to unmap it and mark it as PRIVATE as
> acknowledgment. If the host does not unmap the memory, the
> unshare call issued by the guest fails, which the guest is
> informed about on return.
> 
> Cheers,
> /fuad
> 
> [1] https://lore.kernel.org/all/20231105163040.14904-1-pbonzini@redhat.com/
> 
> [2] https://android-kvm.googlesource.com/linux/+/refs/heads/for-upstream/pkvm-core
> 
> [3] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestmem-6.8-rfc-v1
> 
> [4] https://android-kvm.googlesource.com/kvmtool/+/refs/heads/tabba/guestmem-6.8
> 
> [5] Protected KVM on arm64 (slides)
> https://static.sched.com/hosted_files/kvmforum2022/88/KVM%20forum%202022%20-%20pKVM%20deep%20dive.pdf
> 
> [6] Protected KVM on arm64 (video)
> https://www.youtube.com/watch?v=9npebeVFbFw
> 
> [7] Supporting guest private memory in Protected KVM on Android (presentation)
> https://lpc.events/event/17/contributions/1487/
> 
> [8] Drivers for Gunyah (patch series)
> https://lore.kernel.org/all/20240109-gunyah-v16-0-634904bf4ce9@quicinc.com/

As of 5 min ago when I send this, there's a v17:
https://lore.kernel.org/all/20240222-gunyah-v17-0-1e9da6763d38@quicinc.com/

Thanks,
Elliot



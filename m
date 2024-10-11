Return-Path: <kvm+bounces-28605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B0FB599A0BB
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 12:04:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F27028565F
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 10:04:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90A0C2101A6;
	Fri, 11 Oct 2024 10:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pfhwPVVd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371C120B203;
	Fri, 11 Oct 2024 10:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728641060; cv=none; b=YoTru0xfA0M5/36mJF3k36hblbCYp67wbjVGfsCuXAjpTMNUaGG37eE4LjVSiQsnPuhzqs15mTwWjkQ+uwJe7ArdtdLiYZDZfengHMkOTDWaWktpEjRKHBxD6TYjVud6u2x8bG8cupJYNwvNBwYsauIoz0SnqACsP8iT5EN8aJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728641060; c=relaxed/simple;
	bh=u62Iqwq1j9hEwHj88f6U4rqUI1Tow4Rkw952pQqSRFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UIhDt/CpzeV1/Gzvq/fKUv9wH9K1HN7wSUEWmQzVhYRMDirymmg22bK1M+E8/XNzbWv4jUUb5Xas3xLM24NzQI02HSGaCv5WB3F026b/Qz5kX/y1vv53/TIaYwo5n9ymrPNwwv8OYWU/bfTjwd25OlcywTC7zA/Pe1hT6XoKsbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pfhwPVVd; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49B9qtUe002354;
	Fri, 11 Oct 2024 10:03:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=pp1; bh=RMS407JH1GzvOCAB6bUsycq2laE
	xGgR1zHnxYphVvgo=; b=pfhwPVVdIv1XUkO/O79nLwPUWAX9nJmw3MRKv3goE+X
	6+IKdNG7am1n2kyuWpdnUMHXpr7forAs7CZIgPMFMo+WWCn4yy1cSfjwHTyARaHi
	wCwUMFBGSShS4+6XkYLfrWpjtTF+I0t9aV8qDnMTbPyt4KP3MYb973Zp4qdZYN+l
	1beZv0RKTBBfkUtcyiH/2og2fmwqebsx0cYEzrslM7YzP3JNgjDMQzfDv4/WiPDn
	9MB/MXI5Gpg8WnCF55Zg1U4R8x4aUBrL97AWj6GHG5njCm0QKf1I05eDkQ7AyrWY
	NGPROE6EsOPVEVZETEV9TC8pxD40a+PVWJRBrbKw3DA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4271s1g1e0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Oct 2024 10:03:57 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49BA3uYA027445;
	Fri, 11 Oct 2024 10:03:56 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4271s1g1dt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Oct 2024 10:03:56 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49B7u9DM030168;
	Fri, 11 Oct 2024 10:03:55 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 423gsn4q8w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Oct 2024 10:03:55 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49BA3rHw57344328
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Oct 2024 10:03:53 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4D1062004F;
	Fri, 11 Oct 2024 10:03:53 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9564B20040;
	Fri, 11 Oct 2024 10:03:49 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.124.219.55])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 11 Oct 2024 10:03:49 +0000 (GMT)
Date: Fri, 11 Oct 2024 15:33:46 +0530
From: Vishal Chourasia <vishalc@linux.ibm.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linuxppc-dev@lists.ozlabs.org, Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Naveen N Rao <naveen@kernel.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] powerpc/kvm: Fix spinlock member access for PREEMPT_RT
Message-ID: <Zwj4AllH_JjH5xEb@linux.ibm.com>
References: <ZwgYXsCDDwsOBZ4a@linux.ibm.com>
 <640d6536-e1b3-4ca8-99f8-676e8905cc3e@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <640d6536-e1b3-4ca8-99f8-676e8905cc3e@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SH0o1WOF3K4iszZHkugJGIa9qTP8DiKn
X-Proofpoint-GUID: inWjXg4msE69DpFZkDC_wWRY_x9um5QI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-11_07,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=642 impostorscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 mlxscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410110067

On Thu, Oct 10, 2024 at 11:23:55PM +0200, Paolo Bonzini wrote:
> On 10/10/24 20:09, Vishal Chourasia wrote:
> > Hi,
> > 
> > While building the kernel with CONFIG_PREEMPT_RT, I encountered several
> > compilation errors in the PowerPC KVM code. The issues appear in
> > book3s_hv_rm_mmu.c where it tries to access the 'rlock' member of struct
> > spinlock, which doesn't exist in the RT configuration.
> 
> How was this tested? I suspect that putting to sleep a task that is running
> in real mode is a huge no-no.  The actual solution would have to be to split
> mmu_lock into a spin_lock and a raw_spin_lock, but that's a huge amount of
> work probably.  I'd just add a "depends on !PPC || !KVM_BOOK3S_64_HV" or
> something like that, to prevent enabling KVM-HV on PREEMPT_RT kernels.
Hi Paolo,

This is a build time error, I didn't boot the kernel.

I used pseries_le_defconfig with some other configs enabled. I was trying
to see if the kernel would compile with ARCH_SUPPORTS_RT and
CONFIG_PREEMPT_RT enabled.

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 8094a01974cca..568dc856f0dfa 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -168,6 +168,7 @@ config PPC
        select ARCH_STACKWALK
        select ARCH_SUPPORTS_ATOMIC_RMW
        select ARCH_SUPPORTS_DEBUG_PAGEALLOC    if PPC_BOOK3S || PPC_8xx
+       select ARCH_SUPPORTS_RT                 if !PPC || !KVM_BOOK3S_64_HV
        select ARCH_USE_BUILTIN_BSWAP
        select ARCH_USE_CMPXCHG_LOCKREF         if PPC64
        select ARCH_USE_MEMTEST
I tried rebuilding with the above diff as per your suggestion
though it works when KVM_BOOK3S_64_HV is set to N, but for 
pseries_le_defconfig, it's set to M, by default, which then requires setting it
to N explicitly.


Will something like below be a better solution? This will set
KVM_BOOK3S_64_HV to N if ARCH_SUPPORTS_RT is set.

diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index dbfdc126bf144..33e0d50b08b14 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -80,7 +80,7 @@ config KVM_BOOK3S_64

 config KVM_BOOK3S_64_HV
        tristate "KVM for POWER7 and later using hypervisor mode in host"
-       depends on KVM_BOOK3S_64 && PPC_POWERNV
+       depends on KVM_BOOK3S_64 && PPC_POWERNV && !ARCH_SUPPORTS_RT
        select KVM_BOOK3S_HV_POSSIBLE
        select KVM_GENERIC_MMU_NOTIFIER
        select CMA

Thanks



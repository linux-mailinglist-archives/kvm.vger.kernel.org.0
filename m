Return-Path: <kvm+bounces-8334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AE4C84E00A
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 12:53:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 52DA8B2A938
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 11:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F38396F098;
	Thu,  8 Feb 2024 11:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MzOM9tFv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A06D6D1C1;
	Thu,  8 Feb 2024 11:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707393044; cv=none; b=GbF1cM4CeVITZop4iAAy7WofqIS90grQA62++rUf2TyKXEbucbnHxLXqrIXoIigC6cHEWQjdlYRwI0Gg4upiH0ISNLXpJALRJ4RN965WMsj0yZTmaGiZeIR2H9k3iWLhhvqKiuiUKhjS76j3KFS8hEbhKwPiPdU3tiXeUztiblw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707393044; c=relaxed/simple;
	bh=z0pLCfBmQSj8MXDwKz2A6EPTxulq2kP20S8lZknDLTM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q9ipeo9pSJRlRs7TtmSu1DXG2c9m6+rZHblFnpga8+xMWgm4tSfI0TJq4FDGcgIkRZrG7VzHgqwoqkX1M4TSWCuHUXt7ISEexH8y9RIAOULSIk8fzpI3VIvYooDoqDCggVzyjE0Jx4M8bOp3MIqwYRVvIX/4l2vJs9K7Nmk8V70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MzOM9tFv; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 418BOpeR031361;
	Thu, 8 Feb 2024 11:50:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=ac8E2xNpE9coHGTjPGI+N7+31o95QIX0cqSjP1jxoHE=;
 b=MzOM9tFvIEcue/xaYW2rF4hwubpJURVz3wtx4yOGD/0ud2lP5zQzfhGcYV6Qh8CXIoUy
 ZHl4w2T7XvFCOWEhrUYewaY0X+fwzlVGVChDs5ZrZ669/rDpChweQZgJVmAHQ41SjeYW
 2pw50cwAhLicE/Hc6sQyga3m9zV/jgG39RSKAnKCdeDxJ8bWkl69KpUlm0IrENRWzID5
 yjXjzSsohM1InNRnUGHS86ZREm31U2vR5wWzwhkPl816HOf7FRFn7hPc8jI9CrqYbvtU
 8A/0NVIh1AmgS95Mfd0lGi+YHZh7N717jNcUoiXvXc8/TBinDiB/s6xzrAlBuwFFr5qt 0Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w4wqy9311-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Feb 2024 11:50:41 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 418Bgij9009146;
	Thu, 8 Feb 2024 11:50:40 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w4wqy930r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Feb 2024 11:50:40 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4189rRIr005455;
	Thu, 8 Feb 2024 11:50:40 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3w21akv0cp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Feb 2024 11:50:39 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 418BoaLC46400214
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Feb 2024 11:50:36 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A608C20043;
	Thu,  8 Feb 2024 11:50:36 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 83AFF2004B;
	Thu,  8 Feb 2024 11:50:36 +0000 (GMT)
Received: from [9.152.224.222] (unknown [9.152.224.222])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  8 Feb 2024 11:50:36 +0000 (GMT)
Message-ID: <5ecbe9f3-827d-4308-90cd-84e065a76489@linux.ibm.com>
Date: Thu, 8 Feb 2024 12:50:36 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] KVM: s390: remove extra copy of access registers into
 KVM_RUN
To: Eric Farman <farman@linux.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
References: <20240131205832.2179029-1-farman@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20240131205832.2179029-1-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XaEcwj4Q8bL-j5MhJ6ytRkv4PVxVM5rv
X-Proofpoint-ORIG-GUID: 7Hn7jita6LXwTvIfAEgo1wb8bLXC4z01
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-08_03,2024-02-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 lowpriorityscore=0
 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=657 impostorscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402080062

Am 31.01.24 um 21:58 schrieb Eric Farman:
> The routine ar_translation() is called by get_vcpu_asce(), which is
> called from a handful of places, such as an interception that is
> being handled during KVM_RUN processing. In that case, the access
> registers of the vcpu had been saved to a host_acrs struct and then
> the guest access registers loaded from the KVM_RUN struct prior to
> entering SIE. Saving them back to KVM_RUN at this point doesn't do
> any harm, since it will be done again at the end of the KVM_RUN
> loop when the host access registers are restored.
> 
> But that's not the only path into this code. The MEM_OP ioctl can
> be used while specifying an access register, and will arrive here.
> 
> Linux itself doesn't use the access registers for much, but it does
> squirrel the thread local storage variable into ACRs 0 and 1 in
> copy_thread() [1]. This means that the MEM_OP ioctl may copy
> non-zero access registers (the upper- and lower-halves of the TLS
> pointer) to the KVM_RUN struct, which will end up getting propogated
> to the guest once KVM_RUN ioctls occur. Since these are almost
> certainly invalid as far as an ALET goes, an ALET Specification
> Exception would be triggered if it were attempted to be used.
> 
> [1] arch/s390/kernel/process.c:169
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
> 
> Notes:
>      I've gone back and forth about whether the correct fix is
>      to simply remove the save_access_regs() call and inspect
>      the contents from the most recent KVM_RUN directly, versus
>      storing the contents locally. Both work for me but I've
>      opted for the latter, as it continues to behave the same
>      as it does today but without the implicit use of the
>      KVM_RUN space. As it is, this is (was) the only reference
>      to vcpu->run in this file, which stands out since the
>      routines are used by other callers.
>      
>      Curious about others' thoughts.

Given the main idea that we have the guest ARs loaded in the kvm module
when running a guest and that the kernel does not use those. This avoids
saving/restoring the ARs for all the fast path exits.
The MEM_OP is indeed a separate path.
So what about making this slightly slower by doing something like this
(untested, white space damaged)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 7aa0e668488f0..79e8b3aa7b1c0 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5402,6 +5402,7 @@ static long kvm_s390_vcpu_mem_op(struct kvm_vcpu *vcpu,
                         return -ENOMEM;
         }
  
+       sync_regs(vcpu);
         acc_mode = mop->op == KVM_S390_MEMOP_LOGICAL_READ ? GACC_FETCH : GACC_STORE;
         if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
                 r = check_gva_range(vcpu, mop->gaddr, mop->ar, mop->size,
@@ -5432,6 +5433,7 @@ static long kvm_s390_vcpu_mem_op(struct kvm_vcpu *vcpu,
  
  out_free:
         vfree(tmpbuf);
+       store_regs(vcpu);
         return r;
  }
  

Maybe we could even have a bit in sync/store regs and a BUG_ON in places where
we access any lazy register.


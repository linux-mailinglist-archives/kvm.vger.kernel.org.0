Return-Path: <kvm+bounces-7720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2514C845B0D
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 16:14:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0AD4287061
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 15:14:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3768C62162;
	Thu,  1 Feb 2024 15:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sOSlLiV5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF395F496;
	Thu,  1 Feb 2024 15:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706800482; cv=none; b=X0GAZIRnZFyDTPw2os3nrrviRPLiSAuunK3oxer78wSm6PJYqb1/IhfMx41J96toBckv03H0gEbJmr/lVdJozuxd3a7sQBJ5/JTgwXp3OgV/cpRAyBM1Sjij8R7w1HTiNV5oCMwBPKqY3QqSDm3PGazLvjILhVFyqpfYgqBhefU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706800482; c=relaxed/simple;
	bh=nfg9cZaG2yGkj0edBhLDrl6slCt+cGfgI59wyyuirbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PLas/v8x0pDzPFwPMQtmpViJXKW6B1SiT5Bn1AdsRuzG8+D+fUxFXNW+9bcZLCNAWvsSk1ElS73dPIuoqIRoChMcfkJdumN0J4xdr3nmnHBH1rs3jQxHANu79j+XEzvZOi/0V/nTVcQ+okWmNm+EcfXfzuZFbe88LeyPgHFkeuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sOSlLiV5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 411F7ONd032674;
	Thu, 1 Feb 2024 15:14:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=j+uQ3TxjeGhpkktygYo6NLUSuR79BECdLepfMxB5+As=;
 b=sOSlLiV5egWo0BH/DW+WxBeNYRkV9o4261ZPJYkKSMuFSfkWBU/96PaWyxLB02dhRK2z
 ymQDcUgV2DAF2AlSaIyQxrvqSYWhfDhthWOhi1YqdqB2do0WM3Xi8Pk72BgiF61olq+K
 nGpVhQUZ9xN8flr7aW4xmQUUj510IUF0Eki3/mjedbBHPqUsYaPJhHScg2s7Eee4xMY4
 RJcFKM2QTmXq7mLEf8Ibxpa/tferL7JmQFyouZ8xWQ9OH8gbQAT7Of9bsGLfPBYne5qd
 0TPoBQZgNHbGrD94fokWdnUmZg2DY/WaLanPQt5Bizn15eAMwc/ofS1tCwh/o4dkI4eg OA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w0dnmr6kh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 15:14:39 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 411F7ZM6000577;
	Thu, 1 Feb 2024 15:14:39 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w0dnmr6jy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 15:14:39 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 411Evk6P017712;
	Thu, 1 Feb 2024 15:14:38 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vwcj052wt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 15:14:38 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 411FEZdw8258084
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 1 Feb 2024 15:14:35 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1477F20043;
	Thu,  1 Feb 2024 15:14:35 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D6AC620040;
	Thu,  1 Feb 2024 15:14:34 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  1 Feb 2024 15:14:34 +0000 (GMT)
Date: Thu, 1 Feb 2024 16:14:32 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Eric Farman <farman@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [RFC PATCH] KVM: s390: remove extra copy of access registers
 into KVM_RUN
Message-ID: <20240201151432.6306-C-hca@linux.ibm.com>
References: <20240131205832.2179029-1-farman@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240131205832.2179029-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Mg4PeVfiJKKgV1rHL8qlBsrbiH2YYVBL
X-Proofpoint-ORIG-GUID: 8BZmU-JgjVGtwKFYb4dgspNOM4naUvPV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-01_02,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=668 adultscore=0 clxscore=1011 mlxscore=0 phishscore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402010119

On Wed, Jan 31, 2024 at 09:58:32PM +0100, Eric Farman wrote:
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

What's the code path that can lead to this scenario?

>  arch/s390/kvm/gaccess.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index 5bfcc50c1a68..9205496195a4 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -380,6 +380,7 @@ void ipte_unlock(struct kvm *kvm)
>  static int ar_translation(struct kvm_vcpu *vcpu, union asce *asce, u8 ar,
>  			  enum gacc_mode mode)
>  {
> +	int acrs[NUM_ACRS];
>  	union alet alet;
>  	struct ale ale;
>  	struct aste aste;
> @@ -391,8 +392,8 @@ static int ar_translation(struct kvm_vcpu *vcpu, union asce *asce, u8 ar,
>  	if (ar >= NUM_ACRS)
>  		return -EINVAL;
>  
> -	save_access_regs(vcpu->run->s.regs.acrs);
> -	alet.val = vcpu->run->s.regs.acrs[ar];
> +	save_access_regs(acrs);
> +	alet.val = acrs[ar];

If the above is like you said, then this code would use the host
access register contents for ar translation of the guest?

Or maybe I'm simply misunderstanding what you write.


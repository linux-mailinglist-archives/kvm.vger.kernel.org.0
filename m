Return-Path: <kvm+bounces-47679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FD54AC3B94
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 10:22:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B9521895AFB
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 08:22:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07D291E0DEA;
	Mon, 26 May 2025 08:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tRYcFvNh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984DA41C64;
	Mon, 26 May 2025 08:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748247753; cv=none; b=gxEC39+uCGECFLyCD3IdfeZ73E7O12Vx/BxLK4LXa3r2rR9//XX7VzX6Rmv1jn+4UEwEJ4WBj/jcEACPm7G8nbRjL8VhFW0RdFVBCWW4ggfmjzHZ+FdNRdUa5PVPbXe64V1NcHhUBozpXOX6AwBa5l0OM0YJjppHaligX9jmNOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748247753; c=relaxed/simple;
	bh=h9J2MymMSNNCG7NaS9D4WSbxppEcONeQ3/zHopd/B8I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BWvaHEBGytoWCpNtqB2vn7akOjVDlFgZwdVwLIA6F4B6d2tRa7ZrICIHOuobVzqR6wO8tB1qSe0beyCoymY+MEl5fYubz9LMHCs4eYUEnliL2+WwyD8sCHUGcHCYJygPeoiymjzkscBJ+PnJTaG6qTYHCGoi9eIGMqJFy0LqrI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tRYcFvNh; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54PMnjBl010015;
	Mon, 26 May 2025 08:22:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=5/iqCd
	tdF6phtWKohXTbPBj+rsTeDi36icCDoxQFILk=; b=tRYcFvNhScLVzZzL7NKeI9
	RPx+5FqMmS0MCeaQoIByM4OL0hGKvAO20sMaAPGkCWh2Z0eKtPgyK96LtHhmEy8I
	fYVwieZhf1H8pr52qBKBeGXTX5Iyk5ni9hQFzE8AZhs4j0TytEm0pcVig37OvNhq
	4e00gqH+v6OyANNhDzNkgHlkogRhmJs/QRwnjmrEM7p/yUM6BLQYHwtbFVCLo/+b
	SW5KgiApcjnPcKd7mt8bxD2u07bKZOa00FDzoHaJUIGK5LisTqFI3todiU7A2OAA
	SDmAKis6uDMUq1e5aGQXWHaihPaGlCWpQ2tdNlmuTNfi2Gp9Yad/5BPPPDU0YQwg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46u3hrrfc6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 May 2025 08:22:28 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54Q4VwhL006402;
	Mon, 26 May 2025 08:22:27 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 46utnmd2sd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 May 2025 08:22:27 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54Q8MO2X38535548
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 May 2025 08:22:24 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F219C20043;
	Mon, 26 May 2025 08:22:23 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A9C320040;
	Mon, 26 May 2025 08:22:23 +0000 (GMT)
Received: from [9.111.82.242] (unknown [9.111.82.242])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 26 May 2025 08:22:23 +0000 (GMT)
Message-ID: <7ca1e834-a501-4c91-9458-63d5e0e2ec79@linux.ibm.com>
Date: Mon, 26 May 2025 10:22:23 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] KVM: s390: Always allocate esca_block
To: Christoph Schlameuss <schlameuss@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
References: <20250522-rm-bsca-v3-0-51d169738fcf@linux.ibm.com>
 <20250522-rm-bsca-v3-2-51d169738fcf@linux.ibm.com>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <20250522-rm-bsca-v3-2-51d169738fcf@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=AOOMbaiN c=1 sm=1 tr=0 ts=683424c4 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=NnW4VVLYpB-IhxFGeE8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: trwr057UMWK8VHx2RT2TgJMvvmSFV8ct
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI2MDA2NyBTYWx0ZWRfX564rJ4HN5xDS Dhakl1tZ1sCLAbxDakuiPXfQMA084PpE8cWTuNjxZw/prSZvLbsTWnRSBsUVbiKsz1BDuHAqSsp gRVPymVWuVntMhuYBO30iTlZ70lT/4cD+pMGTpp2QsINrRGR4fM8eHZl//tPmxXwJBhVsIVARLR
 syHsKksZUnkCkiz51IeGKfsALYuTcVQb/74erzzSiCdMtfu0WLDf7KamOr3fk2BTcFDzRt11V5B SpI4aqzTSOw9NYkarAUfJIgCNCu1bFm0qxReqzN7c4J8qI7vvKIB4XttyTPvLok5g4IKOknzqpi apLxfq9+yGNtZb+Ftt0zBn0P5IYtfypOBa9XmFLL73nrz9zk9oMuys5JqCEyijRT8HfaF/ZkGsw
 Y2OmahK+ELzqnbWEfE8kkr0b7G6le3CVximItEJctMoe149ySLYmaxQwdgizsLgAcLXlH/u0
X-Proofpoint-GUID: trwr057UMWK8VHx2RT2TgJMvvmSFV8ct
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-26_04,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0
 impostorscore=0 mlxlogscore=733 malwarescore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505260067

On 5/22/25 11:31 AM, Christoph Schlameuss wrote:
> Instead of allocating a BSCA and upgrading it for PV or when adding the
> 65th cpu we can always use the ESCA.
> 
> The only downside of the change is that we will always allocate 4 pages
> for a 248 cpu ESCA instead of a single page for the BSCA per VM.
> In return we can delete a bunch of checks and special handling depending
> on the SCA type as well as the whole BSCA to ESCA conversion.
> 
> As a fallback we can still run without SCA entries when the SIGP
> interpretation facility or ESCA are not available.
> 
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h |   1 -
>   arch/s390/kvm/interrupt.c        |  71 +++++------------
>   arch/s390/kvm/kvm-s390.c         | 161 ++++++---------------------------------
>   arch/s390/kvm/kvm-s390.h         |   4 +-
>   4 files changed, 45 insertions(+), 192 deletions(-)

[...]

> @@ -80,33 +70,17 @@ static int sca_inject_ext_call(struct kvm_vcpu *vcpu, int src_id)
>   
>   	BUG_ON(!kvm_s390_use_sca_entries());
>   	read_lock(&vcpu->kvm->arch.sca_lock);
> -	if (vcpu->kvm->arch.use_esca) {
> -		struct esca_block *sca = vcpu->kvm->arch.sca;
> -		union esca_sigp_ctrl *sigp_ctrl =
> -			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
> -		union esca_sigp_ctrl new_val = {0}, old_val;
> -
> -		old_val = READ_ONCE(*sigp_ctrl);
> -		new_val.scn = src_id;
> -		new_val.c = 1;
> -		old_val.c = 0;
> -
> -		expect = old_val.value;
> -		rc = cmpxchg(&sigp_ctrl->value, old_val.value, new_val.value);
> -	} else {
> -		struct bsca_block *sca = vcpu->kvm->arch.sca;
> -		union bsca_sigp_ctrl *sigp_ctrl =
> -			&(sca->cpu[vcpu->vcpu_id].sigp_ctrl);
> -		union bsca_sigp_ctrl new_val = {0}, old_val;
> +	struct esca_block *sca = vcpu->kvm->arch.sca;
> +	union esca_sigp_ctrl *sigp_ctrl = &sca->cpu[vcpu->vcpu_id].sigp_ctrl;
> +	union esca_sigp_ctrl new_val = {0}, old_val;


Since we don't have a need for inline declarations anymore, could you 
move those to the beginning of the function?

@Christian @Claudio:
Another interesting question is locking.
The SCA RW lock protected against the bsca->esca switch which never 
happens after this patch.

Can't we rip out that lock and maybe get a bit of performance and even 
less code? (In another patch set to limit the destructive potential)


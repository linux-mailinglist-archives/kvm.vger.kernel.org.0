Return-Path: <kvm+bounces-30174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E8369B7ACA
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 13:39:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9C4A1F25468
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 12:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94B6B19E998;
	Thu, 31 Oct 2024 12:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="T1WMjQNN"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D1819E81F;
	Thu, 31 Oct 2024 12:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730378305; cv=none; b=sdJ9mvN3B/aMJVlsyUYFPiu5xYm8XWbauFwv1xA7dCsEPSGDLrte5He9Oz0Px+HpO1anNV7d4xitbk5hGOTp3933WYu/8+C68gED8fw8lD/T2FBpqtxfYVhKFi5d4H6jvbU+jVk2Zi8Y1gChCVJHTeE+NV+073ExciRisRzIe6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730378305; c=relaxed/simple;
	bh=zmCuAac+R8y48cQD0tvCZMIKDNoqWcL7q6ckuRch6DM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qfJHG6JbmYRbtN3GLP8JDcTuGz0fj63cnKjm1BQxvPNDDy2hEFN0P0GMYsk8MrABIUqYJDM57BKgJsBTZngi5g3K0Q3B7ApuwVdf7ebdC0L5IPLbQjflpQOSYYvZHt4a1dHb6xkEsJPAnGZ8au1S2o5LQu07wEPy9dv1vdUo5x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=T1WMjQNN; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49V2jFDN000416;
	Thu, 31 Oct 2024 12:38:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=yKP7qLgubDSPbkug/ChDspf/T3yphb
	IOZkkS4+Yezn0=; b=T1WMjQNNgf8jeyPwZyLutq75g4ja+vEzQJk8vPVKiAFCzf
	uoCJEbJr2tSupFNJ/j2amhL5k3LTMuGXikpkXxSzufttWXmdFrqBdZa1Ogcz9NJT
	L2xeFkBikV8ou8JiWj4Iwbxr6FEDHWHvrpPMUSlJ6v7e5Uozj0sAlsbl/4xi/8ZI
	Oh4BWHaKhm2oBUlGaBw/kvB5GbB7cyzP1FVa7Yyks+yoEpEml4BgitusmeXR6pwa
	3XTeqkLZrwR6Sy2+kcHTQ0006depmRrUph+oYKURDXaFkyJFsCV+pIy0EHFkpI8F
	+DjJiKHVA8cm4fFZs+zJn5w55QLwkasexLTEN9BQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42jb65qvpb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 12:38:22 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49VA5F3B013506;
	Thu, 31 Oct 2024 12:38:21 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42hbrn4u1j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 31 Oct 2024 12:38:21 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49VCcHHs25494022
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Oct 2024 12:38:17 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AC2912004B;
	Thu, 31 Oct 2024 12:38:17 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 38A9120049;
	Thu, 31 Oct 2024 12:38:17 +0000 (GMT)
Received: from osiris (unknown [9.171.15.29])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 31 Oct 2024 12:38:17 +0000 (GMT)
Date: Thu, 31 Oct 2024 13:38:15 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, borntraeger@de.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, frankja@linux.ibm.com, seiden@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/1] s390/kvm: mask extra bits from program interrupt
 code
Message-ID: <20241031123815.8297-A-hca@linux.ibm.com>
References: <20241031120316.25462-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031120316.25462-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tMzgJntMPRCwD6easqXiRmG1M0dcfyKb
X-Proofpoint-GUID: tMzgJntMPRCwD6easqXiRmG1M0dcfyKb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=654
 impostorscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410310095

On Thu, Oct 31, 2024 at 01:03:16PM +0100, Claudio Imbrenda wrote:
> The program interrupt code has some extra bits that are sometimes set
> by hardware for various reasons; those bits should be ignored when the
> program interrupt number is needed for interrupt handling.
> 
> Fixes: ce2b276ebe51 ("s390/mm/fault: Handle guest-related program interrupts in KVM")
> Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 8b3afda99397..f2d1351f6992 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -4737,7 +4737,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
>  	if (kvm_s390_cur_gmap_fault_is_write())
>  		flags = FAULT_FLAG_WRITE;
>  
> -	switch (current->thread.gmap_int_code) {
> +	switch (current->thread.gmap_int_code & PGM_INT_CODE_MASK) {

Can you give an example? When reviewing your patch I was aware of this, but
actually thought we do want to know when this happens, since the kernel did
something which causes such bits to be set; e.g. single stepping with PER
on the sie instruction. If that happens then such program interruptions
should not be passed for kvm handling, since that would indicate a host
kernel bug (the sie instruction is not allowed to be single stepped).

Or in other words: this should never happen. Of course I might have missed
something; so when could this happen where this is not a bug and the bits
should be ignored?


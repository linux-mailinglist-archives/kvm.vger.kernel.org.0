Return-Path: <kvm+bounces-15346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 17AEF8AB389
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:43:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0BDB284E4B
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:43:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89EB1132804;
	Fri, 19 Apr 2024 16:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HNamWsO6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF79E81216;
	Fri, 19 Apr 2024 16:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713545030; cv=none; b=Zu04Ld3e5WsidtJa7MjbMe2s+QIU5liiBJdUrJ9mW2LUKTsv/RzdPbIKmR6TglH32QGdGG8OIC9MiWYPWGEXQA1Wx2d72ZfCiffQugNmyz3b4rr4rj9oLj+AQjYKnWhVyKAatR9BFndUuOGSha4Br0ysa2Yf1Gj+AazfR7Kl9Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713545030; c=relaxed/simple;
	bh=rXg3N5b05dfWhPDIHb+7PQ9EHjAo3PdLesmeK9C7vjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TbiHDa4rR5b2X5ES6O66YIub30VccPh2pG52Tw9ghcE5UDO+IdPoQOD2haSN8wmpBXw2KQg94L5g7BUWE7y0J/amUTeoADsdk4St4lTPqxw8VtddQ8NrRsBVGr/PswqMTPcZOGi/y484Nm2piIuDDKWFU8TKSPoFpGWHotTHoRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HNamWsO6; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43JGgwOX001835;
	Fri, 19 Apr 2024 16:43:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=qqY0ggVd6vRY8E1NNhjzfUM0pu6D+sORLvesEWRZxRg=;
 b=HNamWsO6qm4UMJDnN2vDI7REwEulQvLmP3wsGalosHd5BGKfLzRsDr5ektEv1mYmlbB+
 fmbXNsOPBcWecVTHP1W3MitvVwA6FZux7uR2E01kvGkHfMpHsm+0vFJGXteWKKy3zA5S
 +D9L3k5RTwMTVa8GexD3rFmMQusFq3LJ9SUnOT8rKRPF4NoIIdj8uT7wDgMRj90ZqCDF
 O9fSGLGtNXlyUl3z6ORSZMreCz8SK+k6ezZXdHX9lq8/a0oUdtVPBBnuFCqbgQNgjzJW
 0GdyBPoHJCGIg3MmI7U4Pyl+bsD2eabhCcGYRnBtalySBALJNVl4oSaXPWk1bmng0CY9 Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xkvc4g03a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Apr 2024 16:43:46 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43JGhkgH002452;
	Fri, 19 Apr 2024 16:43:46 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xkvc4g038-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Apr 2024 16:43:46 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43JFPgZc030372;
	Fri, 19 Apr 2024 16:43:45 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xkbmcms9g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Apr 2024 16:43:45 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43JGhekg52494700
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Apr 2024 16:43:42 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 09E632004D;
	Fri, 19 Apr 2024 16:43:40 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C167820043;
	Fri, 19 Apr 2024 16:43:39 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 19 Apr 2024 16:43:39 +0000 (GMT)
Date: Fri, 19 Apr 2024 18:43:38 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: borntraeger@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: Check kvm pointer when testing
 KVM_CAP_S390_HPAGE_1M
Message-ID: <20240419184338.51efead9@p-imbrenda>
In-Reply-To: <20240419160723.320910-2-jean-philippe@linaro.org>
References: <20240419160723.320910-2-jean-philippe@linaro.org>
Organization: IBM
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3en2dehuIMVGPmT8vH6jWyHtI88mefx2
X-Proofpoint-ORIG-GUID: 1RYE2lgh0OVdiaTuwwgzYziUYsjPzneu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-19_11,2024-04-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 spamscore=0 priorityscore=1501 clxscore=1011
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404190127

On Fri, 19 Apr 2024 17:07:24 +0100
Jean-Philippe Brucker <jean-philippe@linaro.org> wrote:

> KVM allows issuing the KVM_CHECK_EXTENSION ioctl either on the /dev/kvm
> fd or the VM fd. In the first case, kvm_vm_ioctl_check_extension() is
> called with kvm==NULL. Ensure we don't dereference the pointer in that
> case.
> 
> Fixes: 40ebdb8e59df ("KVM: s390: Make huge pages unavailable in ucontrol VMs")
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
> Only build-tested
> ---
>  arch/s390/kvm/kvm-s390.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 5147b943a864a..7721eb522f43d 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -587,7 +587,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		break;
>  	case KVM_CAP_S390_HPAGE_1M:
>  		r = 0;
> -		if (hpage && !kvm_is_ucontrol(kvm))
> +		if (hpage && !(kvm && kvm_is_ucontrol(kvm)))
>  			r = 1;
>  		break;
>  	case KVM_CAP_S390_MEM_OP:



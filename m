Return-Path: <kvm+bounces-62782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94B12C4EE03
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 16:54:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68D603BCEEA
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 15:47:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 939DD36A033;
	Tue, 11 Nov 2025 15:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Xo4o0LhA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C147E330328;
	Tue, 11 Nov 2025 15:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762876042; cv=none; b=UAxZH3UX5ZOjtjkfBUrJFqbqxDgzjMbRFuyFzPnUjMU1/fpJ5l1hQPM+O4r4Vtfnc7iFRdEbQyy8z3DWPOfSLm7NPk0Oaf84CZoKiBI83DH8Zw0LVy+fvE/8Nwly1JIRpCcYN0N5wcBLp85QK2QwZQNJw0CO8a++dFqV+iJ2E+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762876042; c=relaxed/simple;
	bh=lSRr/eMRfhJG9qFc8yreZvR26GB6xWROBgaCDiGUfp0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bRBv+ADTU3OTvxszUSBm36wh2pTJVgUDvilzPnTGVRBOF1t7Bku9t9yfTWeAxdg8Q0rU5XCBhmRqxl5MYP1cpUdmDXfeVcvIwMsYTmybmmhthEgQ3Y3LNqZ5Xt4O6I31vJNDIihZJ/PNI56e8Fo4oT4Aoqre6N1Ogovp+Zr/bGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Xo4o0LhA; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ABF2mMp009449;
	Tue, 11 Nov 2025 15:47:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ZqahaM
	W8RlcE7yyQUS+makVDBs7cN1TxIpAimx17qN8=; b=Xo4o0LhANynkAIOoVnHm0x
	Y1qy/Hv1A845TVxZ1YWx6ZT/KSRYelXpDLYx28P5vuYWshCOw2ElfPwL186uk1pE
	TipiXFtvi+p/e6QkZGwS/6SUlTxFTk+tYmFYIOZvoht3LO5VG9+z/p7wEMGBoeHN
	dGpVxQrSBpu+Y0PHgNASvdEp4qXGtD1/GzYLI/C7YorXBg7uSdSOafY59SqaQjlu
	2FAjUMSiLC/PASMK++VokhhqkiPUyiqhpset+FxGsTcojDDsOWnqfpyxZsSUvfkR
	l+29sQSdR4STWc2zQOUhB4jh7DKd0shUF/COLTGcO42vxvVmd1D9YKnubyMHg6yw
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wk85xue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 15:47:16 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5ABDaMrA007309;
	Tue, 11 Nov 2025 15:47:15 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aajdjbb43-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 15:47:15 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5ABFlCDp22414004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 15:47:12 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ED1BA2004D;
	Tue, 11 Nov 2025 15:47:11 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 50BCC20043;
	Tue, 11 Nov 2025 15:47:11 +0000 (GMT)
Received: from [9.111.10.174] (unknown [9.111.10.174])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Nov 2025 15:47:11 +0000 (GMT)
Message-ID: <1a694540-3e7b-4453-8f7f-294eaf904afe@linux.ibm.com>
Date: Tue, 11 Nov 2025 16:47:11 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 08/11] KVM: s390: Allow guest-3 cpu add and remove
 with vsie sigpif
To: Christoph Schlameuss <schlameuss@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
References: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
 <20251110-vsieie-v2-8-9e53a3618c8c@linux.ibm.com>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <20251110-vsieie-v2-8-9e53a3618c8c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAyMiBTYWx0ZWRfX/WFAUW6A6yzI
 WyuAsv/8fkvnLS9GA1xVVPLC3RGkYefjmBa4GC/JTTIgyhIblunjirsb9hhYHlqY1wBc4iOIIOz
 iFxALwgsO9SlYRHAVR8X7VbFKBUEbXjEDpyP5dJkt+29V34QZ3/+EtfCx9t1kVN1xbZrdxc3ZBb
 RLgx5k+N4QxrEv/rBJl4pjZEsDqYzp+VM2lPh6DmRTUfP3sPXOMQrH/qvZ4hIYT+CfcNQCAbDZs
 Q85UUIckHLmW7QNOAdsqKZk8PyPO+H/yxpp46/+gA2VfWHFHMLBkSTtOXeSUQBIhW16l6aiqdBS
 AP+aqIubcJQDopBDh7fHlpdfvm/DTInf7TuSgDryQLDgUJnljjrS8VlaAwG5tTBPwlE3N+lCuL4
 5quRf/IPA9FzUOAG3gpkDc0S3LPZyA==
X-Authority-Analysis: v=2.4 cv=ZK3aWH7b c=1 sm=1 tr=0 ts=69135a84 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=KbLqQ6qR0etDXQnJZboA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: oFp1qKCN6PF35FHbiMzDF5iL10UHQdDy
X-Proofpoint-GUID: oFp1qKCN6PF35FHbiMzDF5iL10UHQdDy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-11_02,2025-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0 adultscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511080022

On 11/10/25 18:16, Christoph Schlameuss wrote:
> As we are shadowing the SCA we need to add and remove the pointers to
> the shadowed control blocks and sca entries whenever the mcn changes.
> 
> It is not expected that the mcn changes frequently for a already running
> guest-3 configuration. So we can simply re-init the ssca whenever the
> mcn changes.
> To detect the mcn change we store the expected mcn in the struct
> vsie_sca when running the ssca init.
> 
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> ---
>   arch/s390/kvm/vsie.c | 20 ++++++++++++++++++--
>   1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 72c794945be916cc107aba74e1609d3b4780d4b9..1e15220e1f1ecfd83b10aa0620ca84ff0ff3c1ac 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -1926,12 +1926,27 @@ static int init_ssca(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struct
>   	return PTR_ERR(vsie_page_n);
>   }
>   
> +static bool sca_mcn_equals(struct vsie_sca *sca, u64 *mcn)
> +{
> +	bool is_esca = test_bit(VSIE_SCA_ESCA, &sca->flags);
> +	int i;
> +
> +	if (!is_esca)
> +		return ((struct bsca_block *)phys_to_virt(sca->ssca->osca))->mcn == *mcn;
> +
> +	for (i = 0; i < 4; i++)
> +		if (((struct esca_block *)phys_to_virt(sca->ssca->osca))->mcn[i] != sca->mcn[i])
> +			return false;

You're reimplementing memcmp(), no?
Instead of casting which makes the comparison really messy you could use 
offsetof.

Something like this (+- errors):

void *osca = phys_to_virt(sca->ssca->osca);
int offset = offsetof(struct bsca_block, mcn);
int size = 8;

if (test_bit(VSIE_SCA_ESCA, &sca->flags)) {
	size = 8 * 4;
	offset = offsetof(struct esca_block, mcn);
}

return !memcmp(osca + offset, mcn, size);


> +	return true;
> +}
> +
>   /*
>    * Shadow the sca on vsie enter.
>    */
>   static int shadow_sca(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struct vsie_sca *sca)
>   {
>   	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
> +	bool do_init_ssca;
>   	int rc;
>   
>   	vsie_page->sca = sca;
> @@ -1947,8 +1962,9 @@ static int shadow_sca(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struct
>   	if (!use_vsie_sigpif_for(vcpu->kvm, vsie_page))
>   		return false;
>   
> -	/* skip if the guest does not have an usable sca */
> -	if (!sca->ssca->osca) {
> +	do_init_ssca = !sca->ssca->osca;
> +	do_init_ssca = do_init_ssca || !sca_mcn_equals(sca, sca->mcn);
> +	if (do_init_ssca) {
>   		rc = init_ssca(vcpu, vsie_page, sca);
>   		if (rc)
>   			return rc;
> 



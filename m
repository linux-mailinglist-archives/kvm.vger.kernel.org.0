Return-Path: <kvm+bounces-63833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C942FC73AAC
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 12:18:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7ADB74E65B4
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 11:16:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AE9B2FF155;
	Thu, 20 Nov 2025 11:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="J7XsMEsX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80B32D192B;
	Thu, 20 Nov 2025 11:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763637358; cv=none; b=A/ikzyBlv1zMUGUKvln18EfGCi3HJzWbgRfm0OLU8ZPcgLeR3rg0AhtY0dG0ZrcHDVYYfE5X2hmcFvhgzs4rjNkqcb0uMDLnp957v33Gi+tnrPvjZms9Ax0kzt1BdgCdefwIEOgeqtbi4hRM557pdI3YqEj+bMljVHoeEFKXyi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763637358; c=relaxed/simple;
	bh=cBrk6VrawyPJTRZtMf2Lx1zOo2zBuyFOufvWxfQpV4I=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=l6QMMheXIyhduUANh7qTrMIy6c9rGuQBkHh88ZYLNS00/hDbyQLnt2eZx/PhsGBA8mkGVLvphhP2FhXWghd/TyweGMuFu7D8cZ/zoI/rWtyzB98ErQ3t7ReX1C3W3Ly+TkuKZU/v90W+Gkcv8pacmA1IvmKCQzxTcDtCkDIv4H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=J7XsMEsX; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJLkwV5012697;
	Thu, 20 Nov 2025 11:15:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ZtUan9
	ok1Mu9O/T9A5t2MCMl0ocW9dsom4AVjzTmv60=; b=J7XsMEsX+LWiU2p7PVq2eM
	DMNBCPgt+vDrW8OPvFjh85lg/Z9K8vALuvRKQTucVUv6ahh8b+Kcs2+Spz/4SLoU
	7d6MRBSL4SfmNrJFLUUCcemzYXG+s99rwigHBBjXcmLBPq8Q6QyNbZ/zjmCpZMEW
	TT6b9QCeGax2y7I/onxFMbzEEfcmkheqNVBAkSlmUlpDBjRGNgOdiKLSVZ08EWXe
	eWel1R08nV8czBfYGcxszN/9Rb70EtpFugcxjtne8eTbEcSkbegELTGy3ijpy0hM
	5vYkhon/7BJcelcTDletz4UYdfmXE7Q0/UV0XHT7/MkEBbvtJ3n8IUXeFrb8lbIA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejgx4nd3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 11:15:43 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AKA4TO7005137;
	Thu, 20 Nov 2025 11:15:43 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af5bke1q1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 11:15:42 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AKBFcLS46399924
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 11:15:38 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3CBC320043;
	Thu, 20 Nov 2025 11:15:38 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6264020040;
	Thu, 20 Nov 2025 11:15:35 +0000 (GMT)
Received: from [9.111.95.204] (unknown [9.111.95.204])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Nov 2025 11:15:35 +0000 (GMT)
Message-ID: <058cd342-223c-4a3f-b647-cd119ca3d48a@linux.ibm.com>
Date: Thu, 20 Nov 2025 12:15:34 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH RFC v2 07/11] KVM: s390: Shadow VSIE SCA in guest-1
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
 <20251110-vsieie-v2-7-9e53a3618c8c@linux.ibm.com>
Content-Language: en-US
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 xsFNBFubpD4BEADX0uhkRhkj2AVn7kI4IuPY3A8xKat0ihuPDXbynUC77mNox7yvK3X5QBO6
 qLqYr+qrG3buymJJRD9xkp4mqgasHdB5WR9MhXWKH08EvtvAMkEJLnqxgbqf8td3pCQ2cEpv
 15mH49iKSmlTcJ+PvJpGZcq/jE42u9/0YFHhozm8GfQdb9SOI/wBSsOqcXcLTUeAvbdqSBZe
 zuMRBivJQQI1esD9HuADmxdE7c4AeMlap9MvxvUtWk4ZJ/1Z3swMVCGzZb2Xg/9jZpLsyQzb
 lDbbTlEeyBACeED7DYLZI3d0SFKeJZ1SUyMmSOcr9zeSh4S4h4w8xgDDGmeDVygBQZa1HaoL
 Esb8Y4avOYIgYDhgkCh0nol7XQ5i/yKLtnNThubAcxNyryw1xSstnKlxPRoxtqTsxMAiSekk
 0m3WJwvwd1s878HrQNK0orWd8BzzlSswzjNfQYLF466JOjHPWFOok9pzRs+ucrs6MUwDJj0S
 cITWU9Rxb04XyigY4XmZ8dywaxwi2ZVTEg+MD+sPmRrTw+5F+sU83cUstuymF3w1GmyofgsU
 Z+/ldjToHnq21MNa1wx0lCEipCCyE/8K9B9bg9pUwy5lfx7yORP3JuAUfCYb8DVSHWBPHKNj
 HTOLb2g2UT65AjZEQE95U2AY9iYm5usMqaWD39pAHfhC09/7NQARAQABzSVKYW5vc2NoIEZy
 YW5rIDxmcmFua2phQGxpbnV4LmlibS5jb20+wsF3BBMBCAAhBQJbm6Q+AhsjBQsJCAcCBhUI
 CQoLAgQWAgMBAh4BAheAAAoJEONU5rjiOLn4p9gQALjkdj5euJVI2nNT3/IAxAhQSmRhPEt0
 AmnCYnuTcHRWPujNr5kqgtyER9+EMQ0ZkX44JU2q7OWxTdSNSAN/5Z7qmOR9JySvDOf4d3mS
 bMB5zxL9d8SbnSs1uW96H9ZBTlTQnmLfsiM9TetAjSrR8nUmjGhe2YUhJLR1v1LguME+YseT
 eXnLzIzqqpu311/eYiiIGcmaOjPCE+vFjcXL5oLnGUE73qSYiujwhfPCCUK0850o1fUAYq5p
 CNBCoKT4OddZR+0itKc/cT6NwEDwdokeg0+rAhxb4Rv5oFO70lziBplEjOxu3dqgIKbHbjza
 EXTb+mr7VI9O4tTdqrwJo2q9zLqqOfDBi7NDvZFLzaCewhbdEpDYVu6/WxprAY94hY3F4trT
 rQMHJKQENtF6ZTQc9fcT5I3gAmP+OEvDE5hcTALpWm6Z6SzxO7gEYCnF+qGXqp8sJVrweMub
 UscyLqHoqdZC2UG4LQ1OJ97nzDpIRe0g6oJ9ZIYHKmfw5jjwH6rASTld5MFWajWdNsqK15k/
 RZnHAGICKVIBOBsq26m4EsBlfCdt3b/6emuBjUXR1pyjHMz2awWzCq6/6OWs5eANZ0sdosNq
 dq2v0ULYTazJz2rlCXV89qRa7ukkNwdBSZNEwsD4eEMicj1LSrqWDZMAALw50L4jxaMD7lPL
 jJbazsFNBFubpD4BEADAcUTRqXF/aY53OSH7IwIK9lFKxIm0IoFkOEh7LMfp7FGzaP7ANrZd
 cIzhZi38xyOkcaFY+npGEWvko7rlIAn0JpBO4x3hfhmhBD/WSY8LQIFQNNjEm3vzrMo7b9Jb
 JAqQxfbURY3Dql3GUzeWTG9uaJ00u+EEPlY8zcVShDltIl5PLih20e8xgTnNzx5c110lQSu0
 iZv2lAE6DM+2bJQTsMSYiwKlwTuv9LI9Chnoo6+tsN55NqyMxYqJgElk3VzlTXSr3+rtSCwf
 tq2cinETbzxc1XuhIX6pu/aCGnNfuEkM34b7G1D6CPzDMqokNFbyoO6DQ1+fW6c5gctXg/lZ
 602iEl4C4rgcr3+EpfoPUWzKeM8JXv5Kpq4YDxhvbitr8Dm8gr38+UKFZKlWLlwhQ56r/zAU
 v6LIsm11GmFs2/cmgD1bqBTNHHcTWwWtRTLgmnqJbVisMJuYJt4KNPqphTWsPY8SEtbufIlY
 HXOJ2lqUzOReTrie2u0qcSvGAbSfec9apTFl2Xko/ddqPcZMpKhBiXmY8tJzSPk3+G4tqur4
 6TYAm5ouitJsgAR61Cu7s+PNuq/pTLDhK+6/Njmc94NGBcRA4qTuysEGE79vYWP2oIAU4Fv6
 gqaWHZ4MEI2XTqH8wiwzPdCQPYsSE0fXWiYu7ObeErT6iLSTZGx4rQARAQABwsFfBBgBCAAJ
 BQJbm6Q+AhsMAAoJEONU5rjiOLn4DDEP/RuyckW65SZcPG4cMfNgWxZF8rVjeVl/9PBfy01K
 8R0hajU40bWtXSMiby7j0/dMjz99jN6L+AJHJvrLz4qYRzn2Ys843W+RfXj62Zde4YNBE5SL
 jJweRCbMWKaJLj6499fctxTyeb9+AMLQS4yRSwHuAZLmAb5AyCW1gBcTWZb8ON5BmWnRqeGm
 IgC1EvCnHy++aBnHTn0m+zV89BhTLTUal35tcjUFwluBY39R2ux/HNlBO1GY3Z+WYXhBvq7q
 katThLjaQSmnOrMhzqYmdShP1leFTVbzXUUIYv/GbynO/YrL2gaQpaP1bEUEi8lUAfXJbEWG
 dnHFkciryi092E8/9j89DJg4mmZqOau7TtUxjRMlBcIliXkzSLUk+QvD4LK1kWievJse4mte
 FBdkWHfP4BH/+8DxapRcG1UAheSnSRQ5LiO50annOB7oXF+vgKIaie2TBfZxQNGAs3RQ+bga
 DchCqFm5adiSP5+OT4NjkKUeGpBe/aRyQSle/RropTgCi85pje/juYEn2P9UAgkfBJrOHvQ9
 Z+2Sva8FRd61NJLkCJ4LFumRn9wQlX2icFbi8UDV3do0hXJRRYTWCxrHscMhkrFWLhYiPF4i
 phX7UNdOWBQ90qpHyAxHmDazdo27gEjfvsgYMdveKknEOTEb5phwxWgg7BcIDoJf9UMC
In-Reply-To: <20251110-vsieie-v2-7-9e53a3618c8c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FV1_8SfQU2Ijf0ijD7ZRPrQ-rtBpkDas
X-Authority-Analysis: v=2.4 cv=YqwChoYX c=1 sm=1 tr=0 ts=691ef85f cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=G-ggXSbbhjAM1VX-Xf8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: FV1_8SfQU2Ijf0ijD7ZRPrQ-rtBpkDas
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX9UcqoNlY6lk/
 J5eFz8IhYURbzL+38T3QPaZ4GTw64Bdq9T/WLv+Vv4Xq0Z92mSnIZjrgXWz2EdoXGy+I0fkLMCt
 BqA2V2j78GhegitIi+IEuBFiXvQIt6BLQktBT7UDRtY1qO/brd0P7PnqUnBOmovd5dBmLKpHxhN
 rMUxzJH5Ufr7SHndbFE0/M/JHLRhSOfYQnq23/pH9V+9PuLhgw/M+jSICpBppQ9Fbth/oZCw9v/
 wz0fvxQXbWpClofRPAxGdINAwswgET0ivTE9+LGRWe3hWQisO/FOn0l6A4zXCPlOhJvuGtSCTqD
 ICZ4uUQiID911YKVq1ZAf5C8ckFUXDHRq9zTB2Su8Xt6BM3QMTfdofOJajELbUckPJfBQAkdaUk
 NgJfxpwDM8MbO5apEFfaQ1hGQCKp+w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_03,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 adultscore=0 bulkscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511150032

On 11/10/25 18:16, Christoph Schlameuss wrote:
> Restructure kvm_s390_handle_vsie() to create a guest-1 shadow of the SCA
> if guest-2 attempts to enter SIE with an SCA. If the SCA is used the
> vsie_pages are stored in a new vsie_sca struct instead of the arch vsie
> struct.

I think there should be more focus on this.
Having scbs tracked in two places is a huge change compared to how it 
worked before.

> 
> When the VSIE-Interpretation-Extension Facility is active (minimum z17)
> the shadow SCA (ssca_block) will be created and shadows of all CPUs
> defined in the configuration are created.
> SCAOL/H in the VSIE control block are overwritten with references to the
> shadow SCA.
> 
> The shadow SCA contains the addresses of the original guest-3 SCA as
> well as the original VSIE control blocks. With these addresses the
> machine can directly monitor the intervention bits within the original
> SCA entries, enabling it to handle SENSE_RUNNING and EXTERNAL_CALL sigp
> instructions without exiting VSIE.
> 
> The original SCA will be pinned in guest-2 memory and only be unpinned
> before reuse. This means some pages might still be pinned even after the
> guest 3 VM does no longer exist.
> 
> The ssca_blocks are also kept within a radix tree to reuse already
> existing ssca_blocks efficiently. While the radix tree and array with
> references to the ssca_blocks are held in the vsie_sca struct.
> The use of vsie_scas is tracked using an ref_count.
> 
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

I'd like to see more function header comments for the big functions.
Also think about adding lockdep checks and descriptions about what the 
lock protects.

I've needed more time to understand this patch than I'd like to admit.

[...]

>   /*
>    * Get or create a vsie page for a scb address.
>    *
> + * Original control blocks are pinned when the vsie_page pointing to them is
> + * returned.
> + * Newly created vsie_pages only have vsie_page->scb_gpa and vsie_page->sca_gpa
> + * set.
> + *
>    * Returns: - address of a vsie page (cached or new one)
>    *          - NULL if the same scb address is already used by another VCPU
>    *          - ERR_PTR(-ENOMEM) if out of memory
>    */
> -static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
> +static struct vsie_page *get_vsie_page(struct kvm_vcpu *vcpu, unsigned long addr)
>   {
> -	struct vsie_page *vsie_page;
> -	int nr_vcpus;
> +	struct vsie_page *vsie_page, *vsie_page_new;
> +	struct kvm *kvm = vcpu->kvm;
> +	unsigned int max_vsie_page;
> +	int rc, pages_idx;
> +	gpa_t sca_addr;
>   
> -	rcu_read_lock();
>   	vsie_page = radix_tree_lookup(&kvm->arch.vsie.addr_to_page, addr >> 9);
> -	rcu_read_unlock();
> -	if (vsie_page) {
> -		if (try_get_vsie_page(vsie_page)) {
> -			if (vsie_page->scb_gpa == addr)
> -				return vsie_page;
> -			/*
> -			 * We raced with someone reusing + putting this vsie
> -			 * page before we grabbed it.
> -			 */
> -			put_vsie_page(vsie_page);
> -		}
> +	if (vsie_page && try_get_vsie_page(vsie_page)) {
> +		if (vsie_page->scb_gpa == addr)
> +			return vsie_page;
> +		/*
> +		 * We raced with someone reusing + putting this vsie
> +		 * page before we grabbed it.
> +		 */
> +		put_vsie_page(vsie_page);
>   	}
>   
> -	/*
> -	 * We want at least #online_vcpus shadows, so every VCPU can execute
> -	 * the VSIE in parallel.
> -	 */
> -	nr_vcpus = atomic_read(&kvm->online_vcpus);
> +	max_vsie_page = MIN(atomic_read(&kvm->online_vcpus), KVM_S390_MAX_VSIE_VCPUS);
> +
> +	/* allocate new vsie_page - we will likely need it */
> +	if (addr || kvm->arch.vsie.page_count < max_vsie_page) {

Is addr ever NULL?

> +		vsie_page_new = malloc_vsie_page(kvm);
> +		if (IS_ERR(vsie_page_new))
> +			return vsie_page_new;
> +	}
>   
>   	mutex_lock(&kvm->arch.vsie.mutex);
> -	if (kvm->arch.vsie.page_count < nr_vcpus) {
> -		vsie_page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO | GFP_DMA);
> -		if (!vsie_page) {
> -			mutex_unlock(&kvm->arch.vsie.mutex);
> -			return ERR_PTR(-ENOMEM);
> -		}adows of all CPUs
> defined in the configuration are created.
> -		__set_bit(VSIE_PAGE_IN_USE, &vsie_page->flags);
> -		kvm->arch.vsie.pages[kvm->arch.vsie.page_count] = vsie_page;
> +	if (addr || kvm->arch.vsie.page_count < max_vsie_page) {
> +		pages_idx = kvm->arch.vsie.page_count;
> +		vsie_page = vsie_page_new;
> +		vsie_page_new = NULL;
> +		kvm->arch.vsie.pages[kvm->arch.vsie.page_count] = vsie_page_new;
>   		kvm->arch.vsie.page_count++;
>   	} else {
>   		/* reuse an existing entry that belongs to nobody */
> +		if (vsie_page_new)
> +			free_vsie_page(vsie_page_new);
>   		while (true) {
>   			vsie_page = kvm->arch.vsie.pages[kvm->arch.vsie.next];
> -			if (try_get_vsie_page(vsie_page))
> +			if (try_get_vsie_page(vsie_page)) {
> +				pages_idx = kvm->arch.vsie.next;
>   				break;
> +			}
>   			kvm->arch.vsie.next++;
> -			kvm->arch.vsie.next %= nr_vcpus;
> +			kvm->arch.vsie.next %= max_vsie_page;
>   		}
> +
> +		unpin_scb(kvm, vsie_page);
>   		if (vsie_page->scb_gpa != ULONG_MAX)
>   			radix_tree_delete(&kvm->arch.vsie.addr_to_page,
>   					  vsie_page->scb_gpa >> 9);
>   	}
> -	/* Mark it as invalid until it resides in the tree. */
> -	vsie_page->scb_gpa = ULONG_MAX;
> +
> +	vsie_page->scb_gpa = addr;
> +	rc = pin_scb(vcpu, vsie_page);
> +	if (rc) {
> +		vsie_page->scb_gpa = ULONG_MAX;
> +		free_vsie_page(vsie_page);

free_vsie_page() is a wrapper for free_page(), writing to vsie_page 
before freeing makes no sense.

> +		mutex_unlock(&kvm->arch.vsie.mutex);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +	sca_addr = read_scao(kvm, vsie_page->scb_o);
> +	vsie_page->sca_gpa = sca_addr;
> +	__set_bit(VSIE_PAGE_IN_USE, &vsie_page->flags);
>   
>   	/* Double use of the same address or allocation failure. */
>   	if (radix_tree_insert(&kvm->arch.vsie.addr_to_page, addr >> 9,
>   			      vsie_page)) {
> +		unpin_scb(kvm, vsie_page);
>   		put_vsie_page(vsie_page);
>   		mutex_unlock(&kvm->arch.vsie.mutex);
>   		return NULL;
>   	}
> -	vsie_page->scb_gpa = addr;
>   	mutex_unlock(&kvm->arch.vsie.mutex);
>   
> +	/*
> +	 * If the vsie cb does use a sca we store the vsie_page within the
> +	 * vsie_sca later. But we need to allocate an empty page to leave no
> +	 * hole in the arch.vsie.pages.
> +	 */
> +	if (sca_addr) {
> +		vsie_page_new = malloc_vsie_page(kvm);
> +		if (IS_ERR(vsie_page_new)) {
> +			unpin_scb(kvm, vsie_page);
> +			put_vsie_page(vsie_page);
> +			return vsie_page_new;
> +		}
> +		kvm->arch.vsie.pages[pages_idx] = vsie_page_new;
> +		vsie_page_new = NULL;
> +	}
> +
>   	memset(&vsie_page->scb_s, 0, sizeof(struct kvm_s390_sie_block));
>   	release_gmap_shadow(vsie_page);
>   	vsie_page->fault_addr = 0;
> @@ -1529,11 +1855,124 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
>   	return vsie_page;
>   }
>   
> +static struct vsie_page *get_vsie_page_cpu_nr(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
> +					      gpa_t scb_o_gpa, u16 cpu_nr)
> +{
> +	struct vsie_page *vsie_page_n;
> +
> +	vsie_page_n = get_vsie_page(vcpu, scb_o_gpa);
> +	if (IS_ERR(vsie_page_n))
> +		return vsie_page_n;
> +	shadow_scb(vcpu, vsie_page_n);
> +	vsie_page_n->scb_s.eca |= vsie_page->scb_o->eca & ECA_SIGPI;
> +	vsie_page_n->scb_s.ecb |= vsie_page->scb_o->ecb & ECB_SRSI;
> +	put_vsie_page(vsie_page_n);
> +	WARN_ON_ONCE(!((u64)vsie_page_n->scb_gpa & PAGE_MASK));
> +	WARN_ON_ONCE(!((u64)vsie_page_n & PAGE_MASK));
> +
> +	return vsie_page_n;
> +}
> +
> +/*
> + * Fill the shadow system control area used for vsie sigpif.
> + */
> +static int init_ssca(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struct vsie_sca *sca)
> +{
> +	hpa_t sca_o_entry_hpa, osca = sca->sca_o_pages[0].hpa;
> +	bool is_esca = sie_uses_esca(vsie_page->scb_o);
> +	unsigned int cpu_nr, cpu_slots;
> +	struct vsie_page *vsie_page_n;
> +	gpa_t scb_o_gpa;
> +	int i;
> +
> +	/* copy mcn to detect updates */
> +	if (is_esca)
> +		for (i = 0; i < 4; i++)
> +			sca->mcn[i] = ((struct esca_block *)phys_to_virt(osca))->mcn[i];
> +	else
> +		sca->mcn[0] = ((struct bsca_block *)phys_to_virt(osca))->mcn;
> +
> +	/* pin and make minimal shadow for ALL scb in the sca */
> +	cpu_slots = is_esca ? KVM_S390_MAX_VSIE_VCPUS : KVM_S390_BSCA_CPU_SLOTS;
> +	for_each_set_bit_inv(cpu_nr, (unsigned long *)&vsie_page->sca->mcn, cpu_slots) {
> +		get_sca_entry_addr(vcpu->kvm, vsie_page, sca, cpu_nr, NULL, &sca_o_entry_hpa);
> +		if (is_esca)
> +			scb_o_gpa = ((struct esca_entry *)sca_o_entry_hpa)->sda;
> +		else
> +			scb_o_gpa = ((struct bsca_entry *)sca_o_entry_hpa)->sda;
> +
> +		if (vsie_page->scb_s.icpua == cpu_nr)
> +			vsie_page_n = vsie_page;
> +		else
> +			vsie_page_n = get_vsie_page_cpu_nr(vcpu, vsie_page, scb_o_gpa, cpu_nr);
> +		if (IS_ERR(vsie_page_n))
> +			goto err;
> +
> +		if (!sca->pages[vsie_page_n->scb_o->icpua])
> +			sca->pages[vsie_page_n->scb_o->icpua] = vsie_page_n;
> +		WARN_ON_ONCE(sca->pages[vsie_page_n->scb_o->icpua] != vsie_page_n);
> +		sca->ssca->cpu[cpu_nr].ssda = virt_to_phys(&vsie_page_n->scb_s);
> +		sca->ssca->cpu[cpu_nr].ossea = sca_o_entry_hpa;
> +	}
> +
> +	sca->ssca->osca = osca;
> +	return 0;
> +
> +err:
> +	for_each_set_bit_inv(cpu_nr, (unsigned long *)&vsie_page->sca->mcn, cpu_slots) {
> +		sca->ssca->cpu[cpu_nr].ssda = 0;
> +		sca->ssca->cpu[cpu_nr].ossea = 0;
> +	}
> +	return PTR_ERR(vsie_page_n);
> +}
> +
> +/*
> + * Shadow the sca on vsie enter.
> + */
> +static int shadow_sca(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, struct vsie_sca *sca)
> +{
> +	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
> +	int rc;
> +
> +	vsie_page->sca = sca;
> +	if (!sca)
> +		return false;
> +
> +	if (!sca->pages[vsie_page->scb_o->icpua])
> +		sca->pages[vsie_page->scb_o->icpua] = vsie_page;
> +	WARN_ON_ONCE(sca->pages[vsie_page->scb_o->icpua] != vsie_page);
> +
> +	if (!sca->ssca)
> +		return false;
> +	if (!use_vsie_sigpif_for(vcpu->kvm, vsie_page))
> +		return false;
> +
> +	/* skip if the guest does not have an usable sca */
> +	if (!sca->ssca->osca) {
> +		rc = init_ssca(vcpu, vsie_page, sca);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	/*
> +	 * only shadow sigpif if we actually have a sca that we can properly
> +	 * shadow with vsie_sigpif
> +	 */
> +	scb_s->eca |= vsie_page->scb_o->eca & ECA_SIGPI;
> +	scb_s->ecb |= vsie_page->scb_o->ecb & ECB_SRSI;
> +
> +	WRITE_ONCE(scb_s->osda, virt_to_phys(vsie_page->scb_o));
> +	write_scao(scb_s, virt_to_phys(sca->ssca));
> +
> +	return false;
> +}
> +
>   int kvm_s390_handle_vsie(struct kvm_vcpu *vcpu)
>   {
>   	struct vsie_page *vsie_page;
> -	unsigned long scb_addr;
> -	int rc;
> +	struct vsie_sca *sca = NULL;
> +	gpa_t scb_addr;
> +	int rc = 0;
>   
>   	vcpu->stat.instruction_sie++;
>   	if (!test_kvm_cpu_feat(vcpu->kvm, KVM_S390_VM_CPU_FEAT_SIEF2))
> @@ -1554,31 +1993,45 @@ int kvm_s390_handle_vsie(struct kvm_vcpu *vcpu)
>   		return 0;
>   	}
>   
> -	vsie_page = get_vsie_page(vcpu->kvm, scb_addr);
> +	/* get the vsie_page including the vsie control block */
> +	vsie_page = get_vsie_page(vcpu, scb_addr);
>   	if (IS_ERR(vsie_page))
>   		return PTR_ERR(vsie_page);
> -	else if (!vsie_page)
> +	if (!vsie_page)
>   		/* double use of sie control block - simply do nothing */
>   		return 0;
>   
> -	rc = pin_scb(vcpu, vsie_page, scb_addr);
> -	if (rc)
> -		goto out_put;
> +	/* get the vsie_sca including references to the original sca and all cbs */
> +	if (vsie_page->sca_gpa) {
> +		sca = get_vsie_sca(vcpu, vsie_page, vsie_page->sca_gpa);
> +		if (IS_ERR(sca)) {
> +			rc = PTR_ERR(sca);
> +			goto out_put_vsie_page;
> +		}
> +	}
> +
> +	/* shadow scb and sca for vsie_run */
>   	rc = shadow_scb(vcpu, vsie_page);
>   	if (rc)
> -		goto out_unpin_scb;
> +		goto out_put_vsie_sca;
> +	rc = shadow_sca(vcpu, vsie_page, sca);
> +	if (rc)
> +		goto out_unshadow_scb;
> +
>   	rc = pin_blocks(vcpu, vsie_page);
>   	if (rc)
> -		goto out_unshadow;
> +		goto out_unshadow_scb;
>   	register_shadow_scb(vcpu, vsie_page);
> +
>   	rc = vsie_run(vcpu, vsie_page);
> +
>   	unregister_shadow_scb(vcpu);
>   	unpin_blocks(vcpu, vsie_page);
> -out_unshadow:
> +out_unshadow_scb:
>   	unshadow_scb(vcpu, vsie_page);
> -out_unpin_scb:
> -	unpin_scb(vcpu, vsie_page, scb_addr);
> -out_put:
> +out_put_vsie_sca:
> +	put_vsie_sca(sca);
> +out_put_vsie_page:
>   	put_vsie_page(vsie_page);
>   
>   	return rc < 0 ? rc : 0;
> @@ -1589,27 +2042,58 @@ void kvm_s390_vsie_init(struct kvm *kvm)
>   {
>   	mutex_init(&kvm->arch.vsie.mutex);
>   	INIT_RADIX_TREE(&kvm->arch.vsie.addr_to_page, GFP_KERNEL_ACCOUNT);
> +	init_rwsem(&kvm->arch.vsie.ssca_lock);
> +	INIT_RADIX_TREE(&kvm->arch.vsie.osca_to_sca, GFP_KERNEL_ACCOUNT);
> +}
> +
> +static void kvm_s390_vsie_destroy_page(struct kvm *kvm, struct vsie_page *vsie_page)
> +{
> +	if (!vsie_page)
> +		return;
> +	unpin_scb(kvm, vsie_page);
> +	release_gmap_shadow(vsie_page);
> +	/* free the radix tree entry */
> +	if (vsie_page->scb_gpa != ULONG_MAX)
> +		radix_tree_delete(&kvm->arch.vsie.addr_to_page,
> +				  vsie_page->scb_gpa >> 9);
> +	free_vsie_page(vsie_page);
>   }
>   
>   /* Destroy the vsie data structures. To be called when a vm is destroyed. */
>   void kvm_s390_vsie_destroy(struct kvm *kvm)

When we arrive at this function all vcpus have been destroyed already.
All shadow gmaps have received a put as did the parent gmap.

>   {
>   	struct vsie_page *vsie_page;
> -	int i;
> +	struct vsie_sca *sca;
> +	int i, j;
>   
>   	mutex_lock(&kvm->arch.vsie.mutex);

struct kvm's refcount is 0 at this point, what are we protecting against?
What am I missing?

>   	for (i = 0; i < kvm->arch.vsie.page_count; i++) {
>   		vsie_page = kvm->arch.vsie.pages[i];
>   		kvm->arch.vsie.pages[i] = NULL;
> -		release_gmap_shadow(vsie_page);
> -		/* free the radix tree entry */
> -		if (vsie_page->scb_gpa != ULONG_MAX)
> -			radix_tree_delete(&kvm->arch.vsie.addr_to_page,
> -					  vsie_page->scb_gpa >> 9);
> -		free_page((unsigned long)vsie_page);
> +		kvm_s390_vsie_destroy_page(kvm, vsie_page);
>   	}
> -	kvm->arch.vsie.page_count = 0;
>   	mutex_unlock(&kvm->arch.vsie.mutex);
> +	down_write(&kvm->arch.vsie.ssca_lock);
> +	for (i = 0; i < kvm->arch.vsie.sca_count; i++) {
> +		sca = kvm->arch.vsie.scas[i];
> +		kvm->arch.vsie.scas[i] = NULL;
> +
> +		mutex_lock(&kvm->arch.vsie.mutex);
> +		for (j = 0; j < KVM_S390_MAX_VSIE_VCPUS; j++) {
> +			vsie_page = sca->pages[j];
> +			sca->pages[j] = NULL;
> +			kvm_s390_vsie_destroy_page(kvm, vsie_page);
> +		}
> +		sca->page_count = 0;
> +		mutex_unlock(&kvm->arch.vsie.mutex);
> +
> +		unpin_sca(kvm, sca);
> +		atomic_set(&sca->ref_count, 0);
> +		radix_tree_delete(&kvm->arch.vsie.osca_to_sca, sca->sca_gpa);
> +		free_pages_exact(sca, sizeof(*sca));
> +	}
> +	kvm->arch.vsie.sca_count = 0;
> +	up_write(&kvm->arch.vsie.ssca_lock);

Why do we need to set anything to 0 here?

struct kvm and all struct vsie_page are either freed here or a couple 
meters down the road.

>   }
>   
>   void kvm_s390_vsie_kick(struct kvm_vcpu *vcpu)
> 





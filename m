Return-Path: <kvm+bounces-59655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 51C06BC6980
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 22:34:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3714818868C8
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 20:34:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5E5F2BE65F;
	Wed,  8 Oct 2025 20:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Qqr95zdR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C2515CD74;
	Wed,  8 Oct 2025 20:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759955636; cv=none; b=VMMVtPY+69xQ/9nHCYyFbVfTcLLiU/XDYJWqLIbqR/tWemG23i9HSfodBsAugq66MdANanLFmxoUAPS3kN/pjWrLnhirE4upsuc6/cGUM3+MBIOtMEHgwABJScWnA0/aQf9TK/wTTFdiAGSInN5Wkk8qXsp012t5aRwzD0AjDhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759955636; c=relaxed/simple;
	bh=wkhAFtCzu3XVkh3ilfHMTjPgkSwz+wsx5+N+L6e1yQ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LFsqkz+9OOVeYfQ1ZqXIamrYwPUpcWeo2lrGPg8nlXcU/7vsV/q1hQ7i5/CU50hGT2BRgN0O19QH1yLClI6vIHn13u8kcg4cfhmw7nab9NwwTPQHFCH7dM2TA6AvqZ4NkFA1imzJEEXp1Ztu/RiM38bX9zpDmdgS2wvF9lQkb6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Qqr95zdR; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 598HIX6D002809;
	Wed, 8 Oct 2025 20:33:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=WC5qp6
	fkfr6TzxoEwxO1NY6ms7E1TbDePj28l360bm0=; b=Qqr95zdRhsJJ+m2gPeMmCG
	3h8tqdIqRfJFZnr5NyzvdzSLfQePvxZ4O+YQ8MbQ3HEv85DCDxlqIT37K0N/Tr06
	b8dAGVP6MEsDUkgK8h5V2FlWmvpbhsOR1JXakC3tUlVl2tHJJ/TrOER0/2w2aEni
	LmvmYJitbtapUtKFjFD1hmAC35HyaQ+Bjg7X4QDh5/aLSYSIrLrytL6PInOoO44X
	PNL3uYi/EwvVurS029jf6rd3qMIYwTvRun39Dx83K9wg20IcmKSYz8yRTc4QNj94
	hYpdshmVfiB0doS3g7YvogFmzROwaVkNTgYbLTWMZ6zGFzL7GyrtszcqLlxipbpA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49nv86rtf9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Oct 2025 20:33:34 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 598KNBva025483;
	Wed, 8 Oct 2025 20:33:34 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49nv86rtf7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Oct 2025 20:33:34 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 598HNexQ013034;
	Wed, 8 Oct 2025 20:33:33 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 49nvamrrpk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Oct 2025 20:33:33 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 598KXTuw41419158
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Oct 2025 20:33:29 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B66F12004B;
	Wed,  8 Oct 2025 20:33:29 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8445C20040;
	Wed,  8 Oct 2025 20:33:25 +0000 (GMT)
Received: from [9.111.61.171] (unknown [9.111.61.171])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Oct 2025 20:33:25 +0000 (GMT)
Message-ID: <7dae0ecc-338f-4f37-a42b-13b4ceb5ed20@linux.ibm.com>
Date: Thu, 9 Oct 2025 02:03:23 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] powerpc, ocxl: Fix extraction of struct xive_irq_data
To: Nam Cao <namcao@linutronix.de>, Madhavan Srinivasan
 <maddy@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Frederic Barrat <fbarrat@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Andrew Donnellan <ajd@linux.ibm.com>
References: <20251008081359.1382699-1-namcao@linutronix.de>
Content-Language: en-US
From: Ganesh G R <ganeshgr@linux.ibm.com>
In-Reply-To: <20251008081359.1382699-1-namcao@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GcnWcb3UfBIiwED1j1qNXUlh9rkcDyA0
X-Proofpoint-ORIG-GUID: d1R5iGGtTD8T2BnpzXkdY5qh4nbJRgCx
X-Authority-Analysis: v=2.4 cv=MKNtWcZl c=1 sm=1 tr=0 ts=68e6ca9e cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8
 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=3HY11Wxk7Qll88ziligA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX3eHLW7S6uMb1
 853sEsarewi83qhJs/jC3bFZzggu2NqoPEYt9msa2eDAXywK4XyPPRAv+TX1EjVEoSOIcXnlujA
 +Yao+loS/bM9WBdXBOeSiHiyzshUz4v0XWWHhpakxmzwhkQ451e4xIuCUHbBl0/+OLSQErQF7mK
 oWwmhunJ4GTXEc9tDFC6BDJtvDXSEY8fc+p/h1lR6sUgRqRJwKLSCRbVUM/w6magD6jvyPRPpZP
 8Z5V8NWJas60tFCtJ8RqIkPPgZrVVsgD1BeO/cEkvLcL0pmhqdMlJokf0szam8PpoY4M3olLpgV
 Jk+NHfR04GGXXIYN3bPxfjBDYwEU1eUz2F9/lM2IQia9rwsNOwqlob4pnuyZaYemFpO3E1GgS1Z
 S0avcMuUthlge53MPx4RBwFF69Wedw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-08_07,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0 spamscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 clxscore=1011
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510020000
 definitions=main-2510080121

On 10/8/25 1:43 PM, Nam Cao wrote:
> Commit cc0cc23babc9 ("powerpc/xive: Untangle xive from child interrupt
> controller drivers") changed xive_irq_data to be stashed to chip_data
> instead of handler_data. However, multiple places are still attempting to
> read xive_irq_data from handler_data and get a NULL pointer deference bug.
> 
> Update them to read xive_irq_data from chip_data.
> 
> Non-XIVE files which touch xive_irq_data seem quite strange to me,
> especially the ocxl driver. I think there ought to be an alternative
> platform-independent solution, instead of touching XIVE's data directly.
> Therefore, I think this whole thing should be cleaned up. But perhaps I
> just misunderstand something. In any case, this cleanup would not be
> trivial; for now, just get things working again.
> 
> Fixes: cc0cc23babc9 ("powerpc/xive: Untangle xive from child interrupt controller drivers")
> Reported-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Closes: https://lore.kernel.org/linuxppc-dev/68e48df8.170a0220.4b4b0.217d@mx.google.com/
> Signed-off-by: Nam Cao <namcao@linutronix.de>
> ---
> VAS and OCXL has not been tested. I noticed them while grepping.
> ---

Looks good to me.
Reviewed-by: Ganesh Goudar <ganeshgr@linux.ibm.com>


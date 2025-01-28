Return-Path: <kvm+bounces-36758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F235AA20A06
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 12:58:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 328EA3A550F
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2025 11:57:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEC1D1A2396;
	Tue, 28 Jan 2025 11:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ayYcsvup"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6150A199E94;
	Tue, 28 Jan 2025 11:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738065478; cv=none; b=BPIlVpE5eLiC2ULPXjfpG2Fz2k9x/Jq1+NLkNRPz4Aqdt9Aq0BE82pprAMSSuGyu6pSFr6/UqDH73jjbWFr4psLNciLND8MqnkwMQ0bhqK1OP40p/wiZlYQkvLc+VmvGETsxfSw8ztg9OosyxBq4a6DqOn7eYicLfPOxgKujfb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738065478; c=relaxed/simple;
	bh=F0/9IQ0AYzRMcpDNLidcpn2pdwdSs/7SE5pzI5AlAq0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZZ6bM1aObm6on88OfKMYRrP4XzeDepSW/gP98vIylgb691gQm+Ng5UghzSB2eyd+73nCm3xYhkBWb3ksOEyTk2G4VorovUqoIG2UkdXHuFr7xH1MSBjqhaKNT+shQj7t0Q8+535gcTyaYArcINeVDMrT7ZZzHS0UMmFAm16q2uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ayYcsvup; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50S7X5hL023185;
	Tue, 28 Jan 2025 11:57:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=r7X8KG
	ofGjzXyiXmNpCqfsbsuZB60462r6ZQo2dzXl8=; b=ayYcsvupPRKoRP/G+OPys1
	QycJqFRxlExFL71+Y+8MCKAm6S1eALhR9up6ADp3MbVEqBKOshE/ZYtSHJiMqyL5
	tmr2CCEkfCgeCMaAnWbOYrn43csIYdq6hgajcdaDtRWbQQifCae0mL/R2u++ata5
	ogooXpH9EldEpu4pukHkOVBLdOeKtWYstJ6YFhIpqIGCaRfJJaLQ0AOkyLMTdp+e
	ulQ+nD402A07THf8Qw6jVJEamD4nKzuZvkoBm3w/O5OksjGmS1ci+dQFIEFte1+D
	GPJqES0cmvlqnKilTldeOzX14lQd5/w2D0I5G9KrgTIM9LVcpCFyQIPrqekhN+gw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44etxrs2p0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jan 2025 11:57:45 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50SBs3oD013874;
	Tue, 28 Jan 2025 11:57:44 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44etxrs2nw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jan 2025 11:57:44 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50S88cr2012444;
	Tue, 28 Jan 2025 11:57:43 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44dany38gc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jan 2025 11:57:43 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50SBvg2M22282896
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jan 2025 11:57:42 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 64A8D58055;
	Tue, 28 Jan 2025 11:57:42 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B5505803F;
	Tue, 28 Jan 2025 11:57:38 +0000 (GMT)
Received: from [9.204.206.207] (unknown [9.204.206.207])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 Jan 2025 11:57:38 +0000 (GMT)
Message-ID: <27978f31-6b66-4d4c-886b-e2bfb41d5261@linux.ibm.com>
Date: Tue, 28 Jan 2025 17:27:36 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] kvm powerpc/book3s-apiv2: Introduce kvm-hv
 specific PMU
To: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.ibm.com,
        amachhiw@linux.ibm.com
References: <20250123120749.90505-1-vaibhav@linux.ibm.com>
 <20250123120749.90505-5-vaibhav@linux.ibm.com>
 <40C19755-ABE4-4E23-A75A-1F6F6DDC505A@linux.vnet.ibm.com>
 <87y0ywu2ri.fsf@vajain21.in.ibm.com>
Content-Language: en-US
From: Madhavan Srinivasan <maddy@linux.ibm.com>
In-Reply-To: <87y0ywu2ri.fsf@vajain21.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MNESt_Kp7udNeKkgSEzO62Q2Ay1u4sAz
X-Proofpoint-GUID: ENHdIdwhxCCLeW6MK-1CsGIb68TQgiQs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-28_04,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 impostorscore=0 bulkscore=0 suspectscore=0 mlxlogscore=710
 priorityscore=1501 phishscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2411120000 definitions=main-2501280089



On 1/27/25 1:06 PM, Vaibhav Jain wrote:
> Hi Athira,
> 
> Thanks for reviewing this patch series. My responses to your review
> comment inline below:
> 
> 
> Athira Rajeev <atrajeev@linux.vnet.ibm.com> writes:
> 
>>> On 23 Jan 2025, at 5:37 PM, Vaibhav Jain <vaibhav@linux.ibm.com> wrote:
>>>
>>> Introduce a new PMU named 'kvm-hv' to report Book3s kvm-hv specific
> <snip>
>>
>> Hi Vaibhav
>>
>> All PMU specific code is under “arch/powerpc/perf in the kernel source. Here since we are introducing a kvm-hv specific PMU, can we please have it in arch/powerpc/perf ?
> 
> Is it common convention to put PMU specific code in
> arch/powerpc/perf across ppc achitecture variants ? If its there can you
> please mention the reasons behind it.
> 

My concern is about fragmentation. Would prefer to have
the pmu code under perf folder. Secondly, we did handle
module case for vpa-pmu.

Maddy


> Also the code for this PMU, will be part of kvm-hv kernel module as it
> utilizes the functionality implemented there. Moving this PMU code to
> arch/powerpc/perf will need this to be converted in yet another new
> kernel module, adding a dependency to kvm-hv module and exporting a
> bunch of functionality from kvm-hv. Which looks bit messy to me
> 
> <snip>
> 



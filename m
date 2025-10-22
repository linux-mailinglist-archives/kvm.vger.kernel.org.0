Return-Path: <kvm+bounces-60802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FDB6BFA6EC
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 09:04:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 477AF5045D2
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 07:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD7F52F5330;
	Wed, 22 Oct 2025 07:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="V1899jEU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2382B2F3C27
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 07:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761116605; cv=none; b=XYI7zP+N3JzAWQAQcdjDBNh1L/cGSYaFzvePuvOoBEPqUM3uEAxSKlMy2rEFIHVDGmjQRMY2R2YZyYjWZLaDKmyo+sXUg3u7t0XSX+iikvoNFMOsH1jUesA3fdE5zh3BmIIERk38QMa8Hotn9CjSLj8qr2oGtbftVQ8txx6oLy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761116605; c=relaxed/simple;
	bh=PkV8fpf6eJuV0xSYHjd3ihwKW54C6r7ZnklAg96Obt8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o6xlqm/CwXg+OkgkFl5MsSfQOEiY86/gQ9DvCURLhaHWzyJ9k9F2+gHoiF9PeyClXjaWtGJDRDgwmymkhXiR+Cltjm0YlmvqrBR8KH79L/tVhqsDfHcrV2GKfOGmlrSqe28HycxAC1KFdNq+DAjnPwIFk/dkYmyDS5ud419NTn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=V1899jEU; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59LMeLlV016406;
	Wed, 22 Oct 2025 07:03:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=QOLj5V
	QaUwHOEH8RL6jeG0xU7RG3kgqnclCQRhLvZMc=; b=V1899jEURJMolk++yByj1/
	tuj7iY/aO4sQ1fdjYMVjvE1ZI5KTTy9/B35iBeg7n/90jj/j16hDvTae/kjzfX3T
	A2Wbqc9sGM4ZrTXmONNwZVYDNZD9ApPr/2VUXd1j1NuFOlNzK0Zp8dzys7pUiSQ/
	NyvT0GFqWqMzB0uTtoCH2ZTugwkP94tQGUu0A1K5IGRJ58PFuHPYqhfRKQwJcuPH
	suR70FPuL+wElnV1PzwDg8PSTj9bXuobPTzkFv+Xneuiw83fByZbwMG3Y/llhaz/
	WsGvVDrJCecXPxco4y3rNrLAbDZSXg50vAjP/zXhpL0Y4UqAZyrUS7dCy9ixLMVw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v32hhrn0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 07:03:17 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59M73Dt8024333;
	Wed, 22 Oct 2025 07:03:17 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v32hhrmw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 07:03:17 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59M6gI4c017058;
	Wed, 22 Oct 2025 07:03:16 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49vnkxy383-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 07:03:16 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59M73FLY26804774
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 07:03:15 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D7F658063;
	Wed, 22 Oct 2025 07:03:15 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B6C9D58043;
	Wed, 22 Oct 2025 07:03:12 +0000 (GMT)
Received: from [9.79.201.141] (unknown [9.79.201.141])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 22 Oct 2025 07:03:12 +0000 (GMT)
Message-ID: <27da22c4-6212-4ff9-8f11-e04b35039a2b@linux.ibm.com>
Date: Wed, 22 Oct 2025 12:33:09 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/11] hw/ppc/spapr: Inline spapr_dtb_needed()
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org, Nicholas Piggin <npiggin@gmail.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@redhat.com>
References: <20251021084346.73671-1-philmd@linaro.org>
 <20251021084346.73671-5-philmd@linaro.org>
 <602c19bc-bed9-43c2-b98c-491b75921604@linux.ibm.com>
 <d264c81b-119e-439f-a4c2-68a7336d6ba6@linaro.org>
Content-Language: en-US
From: Chinmay Rath <rathc@linux.ibm.com>
In-Reply-To: <d264c81b-119e-439f-a4c2-68a7336d6ba6@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX2I0X0TmC3bRo
 k9dU7S0E50pNSj4qkxHWC4ACpm5oesDmxtRaoLDzueUN44XDV7bM2dsLuMadGH1c9eCBIXHywpZ
 XGcmDrbB/1R1gC31nN/t06TNaNxDCW91b0QrjM5JkjfttMAPspikEuf0uEkKr8Io9QVS2RWeZtq
 29Gg8rIswTFaHLTueXrRerGQSoKM8RLjamp/5qrbIeKfMX9C4EUrAZQ0NS9+NGUjwNj8e2ik3V/
 QGNeaY1OSsQk7RQpYskCuOqoMqhtEiDK+RNyDY/lWHpH45t34izljkRLsQd5V5B5gL/sTO2Q9sn
 AU9Zd7H25ATXYl1m3cassb//sYg226wMG50sXBiZxBkVYmirAXo8OVNAIXcxafNvouxoQFUfHrn
 d85DbodhKkV0cXJx6L/OoytZgIYtag==
X-Authority-Analysis: v=2.4 cv=OrVCCi/t c=1 sm=1 tr=0 ts=68f881b5 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=KKAkSRfTAAAA:8 a=MvvTU35B-mzZJSykrPEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=cvBusfyB2V15izCimMoJ:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: swkTMFdgntB-3iu97LvVOF7k4NDyeK2l
X-Proofpoint-ORIG-GUID: LC3uRKAJMFZE3SgYcC_85cXVAQLOsIDl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022


On 10/21/25 19:51, Philippe Mathieu-Daudé wrote:
> On 21/10/25 15:25, Chinmay Rath wrote:
>> Hey Philippe,
>> The commit message says that this commit is inline-ing 
>> spapr_dtb_needed(), but it is actually removing it. I think it's 
>> better to convey that in the commit message.
>> Or did I miss something ?
>>
>> On 10/21/25 14:13, Philippe Mathieu-Daudé wrote:
>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>>> ---
>>>   hw/ppc/spapr.c | 6 ------
>>>   1 file changed, 6 deletions(-)
>>>
>>> diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
>>> index 458d1c29b4d..ad9fc61c299 100644
>>> --- a/hw/ppc/spapr.c
>>> +++ b/hw/ppc/spapr.c
>>> @@ -2053,11 +2053,6 @@ static const VMStateDescription 
>>> vmstate_spapr_irq_map = {
>>>       },
>>>   };
>>> -static bool spapr_dtb_needed(void *opaque)
>>> -{
>>> -    return true; /* backward migration compat */
>>> -}
>>> -
>>>   static int spapr_dtb_pre_load(void *opaque)
>>>   {
>>>       SpaprMachineState *spapr = (SpaprMachineState *)opaque;
>>> @@ -2073,7 +2068,6 @@ static const VMStateDescription 
>>> vmstate_spapr_dtb = {
>>>       .name = "spapr_dtb",
>>>       .version_id = 1,
>>
>> Does this version number need to be incremented ?
>
> No, this is a no-op.
>
>>
>> Regards,
>> Chinmay
>>
>>>       .minimum_version_id = 1,
>>> -    .needed = spapr_dtb_needed,
>
> Here is the inlining, as '.needed = true' is the default.
Ahh I see.
> Would "Inline and remove spapr_dtb_needed()" be clearer?
Yeah that'd be nice.

Thanks,
Chinmay
>
>>>       .pre_load = spapr_dtb_pre_load,
>>>       .fields = (const VMStateField[]) {
>>>           VMSTATE_UINT32(fdt_initial_size, SpaprMachineState),
>
>


Return-Path: <kvm+bounces-60335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 064BCBEA5BD
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 17:59:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA1387C3D4A
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 15:23:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEBAB33509C;
	Fri, 17 Oct 2025 15:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cHPiCTe3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B16D2F12C5;
	Fri, 17 Oct 2025 15:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714496; cv=none; b=rU/a7NXP+suIFLIeDPN9F1ewm/V0OoYEHeSJ2C8R1osv/6/xMJLJPUFsoekaVEoYMe7fItj6GCO+M/BnaW4/Rq29uSy8mqJjVn4Y+z5DK1fVzE6mR3f9rW5qFGxLhsmxZwfAcDoDFs7bOS+iHdb+SZ1Uai+PXPqxWlvq9nFnNBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714496; c=relaxed/simple;
	bh=mDahcTPHvx4LuHVT34Rn/jzszo2zkYNRn7cRycenOQ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xh2RrU0n8cLF4wxof1bjzQVov4d6Aj+HPDB0OXVtdwYbTRKaCxiVjQnoNGR8jEghxOKBhzluhcBpsvEtjMndoYde/lMDAiZNcfEsToCIvMixf2I6FKx/DRv1OFtd1YjJJQI1H2jQKaLVHDI+bDzxBV7YvGg0dNtvx0aYpMFxhEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cHPiCTe3; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59H94tnC023481;
	Fri, 17 Oct 2025 15:21:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=N/iODX
	MaEcdTtcfpLTo1WY7S5SoeD9xRtvc0dSPWt2I=; b=cHPiCTe3BB4zSirLfoyQkh
	bhWoMbMoLkFIwZwnSxvgdXVkyrAGHx2Uv9SVViKiPOP30Fy329vXSWgKyF8eF8ag
	8JPtdTxrd1uRu3krH5PA6mOMKC0+cb8mV69TztevYu5PFKrT1Bfh470xlHHHZoOV
	xBoapRMsWilp6NtCIXvMCpkP+YV3Czpn99sGU54GCzDTmYYIiLGSARv8SgxO7WUn
	I7EHAZQJmvS4nSFzaxUCqdpxKIYFxUueTNuWsYvKN0kPfcPqtRBMKmzr0rtz0+jT
	cfHoBZ8vH58uDBfZ7rKO3jwOYMktQvhLuOwNGpP6y46eeZZ2wfhoOBSWObyOE8nw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49tfxpw02d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Oct 2025 15:21:00 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59HFE3Ti030823;
	Fri, 17 Oct 2025 15:20:59 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49tfxpw02b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Oct 2025 15:20:59 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59HF1Dih003613;
	Fri, 17 Oct 2025 15:20:59 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49r1xye332-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Oct 2025 15:20:58 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59HFKvAx19005772
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 15:20:57 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EA2012004B;
	Fri, 17 Oct 2025 15:20:56 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B922020040;
	Fri, 17 Oct 2025 15:20:55 +0000 (GMT)
Received: from [9.111.36.47] (unknown [9.111.36.47])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Oct 2025 15:20:55 +0000 (GMT)
Message-ID: <74272098-cfb7-424b-a55e-55e94f04524e@linux.ibm.com>
Date: Fri, 17 Oct 2025 17:20:55 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: linux-next: KVM/s390x regression
To: David Hildenbrand <david@redhat.com>, balbirs@nvidia.com
Cc: Liam.Howlett@oracle.com, airlied@gmail.com, akpm@linux-foundation.org,
        apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
        byungchul@sk.com, dakr@kernel.org, dev.jain@arm.com,
        dri-devel@lists.freedesktop.org, francois.dugast@intel.com,
        gourry@gourry.net, joshua.hahnjy@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, lyude@redhat.com, matthew.brost@intel.com,
        mpenttil@redhat.com, npache@redhat.com, osalvador@suse.de,
        rakie.kim@sk.com, rcampbell@nvidia.com, ryan.roberts@arm.com,
        simona@ffwll.ch, ying.huang@linux.alibaba.com, ziy@nvidia.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-next@vger.kernel.org
References: <20251001065707.920170-4-balbirs@nvidia.com>
 <20251017144924.10034-1-borntraeger@linux.ibm.com>
 <9beff9d6-47c7-4a65-b320-43efd1e12687@redhat.com>
 <c67386be-5278-411d-97e7-43fc34bf7c98@linux.ibm.com>
 <8c778cd0-5608-4852-9840-4d98828d7b33@redhat.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <8c778cd0-5608-4852-9840-4d98828d7b33@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DcfLWxOGbv9bYKiDoMpZ6va0xN-YJXnG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE1MDEyNSBTYWx0ZWRfXxU8GH3q1YuZ0
 c8BgXMsDBFk4hHBo0vPh+QUbB0ubWIN3+kWBj/+COUXkJBKtLbfQoiwRBWeXdw/GkNP3E7O3mnG
 MjRp5R24at9SzmEtPfe8IaV0KYWgCseqOjVH3PD7I13IA4rLOMlm3dx8nFFSgJpwHIkLZUs4nKz
 UfkyFGF4BnRXztDDU3rymsyOUnTHW6xNzyK0jzzDgSQ7kgEy3/tJTx8mSdDPl/rACGztbSsGGg9
 7UVhoK3OxQzkhpE3LFEex92y4kPkzFXVMcS2uw1HRLIkPJExq2bgk65n9hXFGTvym2/wGd/VPyf
 SS/JwNJAYEl0F7B/ztPHDmw4XKNN05Ngz/7j+W8s0WveeTQn+7Oh19xOyvxl7gnbRpbkiGIRStK
 u8sdlROg1EfmKkjNfCANEDX13yoRYw==
X-Authority-Analysis: v=2.4 cv=R+wO2NRX c=1 sm=1 tr=0 ts=68f25edc cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=czJfVngKFEUMndguRe4A:9 a=QEXdDO2ut3YA:10 a=nl4s5V0KI7Kw-pW0DWrs:22
 a=pHzHmUro8NiASowvMSCR:22 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-ORIG-GUID: HxlDaZqVRm6WsCaN2EWRamDscKrmDVZz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 spamscore=0 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510150125



Am 17.10.25 um 17:07 schrieb David Hildenbrand:
> On 17.10.25 17:01, Christian Borntraeger wrote:
>> Am 17.10.25 um 16:54 schrieb David Hildenbrand:
>>> On 17.10.25 16:49, Christian Borntraeger wrote:
>>>> This patch triggers a regression for s390x kvm as qemu guests can no longer start
>>>>
>>>> error: kvm run failed Cannot allocate memory
>>>> PSW=mask 0000000180000000 addr 000000007fd00600
>>>> R00=0000000000000000 R01=0000000000000000 R02=0000000000000000 R03=0000000000000000
>>>> R04=0000000000000000 R05=0000000000000000 R06=0000000000000000 R07=0000000000000000
>>>> R08=0000000000000000 R09=0000000000000000 R10=0000000000000000 R11=0000000000000000
>>>> R12=0000000000000000 R13=0000000000000000 R14=0000000000000000 R15=0000000000000000
>>>> C00=00000000000000e0 C01=0000000000000000 C02=0000000000000000 C03=0000000000000000
>>>> C04=0000000000000000 C05=0000000000000000 C06=0000000000000000 C07=0000000000000000
>>>> C08=0000000000000000 C09=0000000000000000 C10=0000000000000000 C11=0000000000000000
>>>> C12=0000000000000000 C13=0000000000000000 C14=00000000c2000000 C15=0000000000000000
>>>>
>>>> KVM on s390x does not use THP so far, will investigate. Does anyone have a quick idea?
>>>
>>> Only when running KVM guests and apart from that everything else seems to be fine?
>>
>> We have other weirdness in linux-next but in different areas. Could that somehow be
>> related to use disabling THP for the kvm address space?
> 
> Not sure ... it's a bit weird. I mean, when KVM disables THPs we essentially just remap everything to be mapped by PTEs. So there shouldn't be any PMDs in that whole process.
> 
> Remapping a file THP (shmem) implies zapping the THP completely.
> 
> 
> I assume in your kernel config has CONFIG_ZONE_DEVICE and CONFIG_ARCH_ENABLE_THP_MIGRATION set, right?

yes.

> 
> I'd rule out copy_huge_pmd(), zap_huge_pmd() a well.
> 
> 
> What happens if you revert the change in mm/pgtable-generic.c?

That partial revert seems to fix the issue
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 0c847cdf4fd3..567e2d084071 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -290,7 +290,7 @@ pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
  
         if (pmdvalp)
                 *pmdvalp = pmdval;
-       if (unlikely(pmd_none(pmdval) || !pmd_present(pmdval)))
+       if (unlikely(pmd_none(pmdval) || is_pmd_migration_entry(pmdval)))
                 goto nomap;
         if (unlikely(pmd_trans_huge(pmdval)))
                 goto nomap;







Return-Path: <kvm+bounces-60332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B7F0BE9898
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 17:11:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B35F0742BAF
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 15:04:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B8BD36999D;
	Fri, 17 Oct 2025 15:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OCn34bF2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A63F32E141;
	Fri, 17 Oct 2025 15:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713333; cv=none; b=bOjgDnniwXloitRZMmcExzUgO6zCHuBRI9fsX1lij4qpSZG0Ooizc0FTe7zqR45H1JiJWH36ba1t9O9BmPp3+wefh1FOl7++ZGl1ghFPLLNr6sWBSHT8S5ugdWN1fUKnGdtgrmeC8SzoLts0vFx62esWNRzZQFZHes17+9DAozA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713333; c=relaxed/simple;
	bh=DxLnhdIQ2kU+zeD/wAroujRESZq6V2Rlm0i8ySn6fOs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HfRBCvtd6VUhoRXcQKYVK/8zfuUpltO0909L4fCi17ifdRic8v+zJG3O2oLzZszeyfu1xWReKucxgr0n0bi7MTvwhwLy+3ETBD4rK3qSqPrC/NyX3LVbU3HFR640F761JYBq/NgWtJ3JMTZfD5WrWl1ohyCkHh/kmlan/lZ2X8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OCn34bF2; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59HBHM9h021066;
	Fri, 17 Oct 2025 15:01:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=WjlOEp
	jA/dZDxYCSjsqfVgbZFM/SxanKWySMXDeQTRA=; b=OCn34bF2k/4rTHZa89TN+a
	tJKPMQDGoxH2pn9ne2v6SOaGqeVSxpPjHe/iOg5w/NXb5+58U+J80m+CDwg0WZ6U
	DY9ssF3TJmj8rLrVmIQkObSShDGbdGdd3+JJIpxjN3lnvCq+e2UGidVRTL3trVh8
	Mbh+epPmp8zruQgMiRuj9VbWP0cLNmAoWlBVbIj6jGWy2mfkiHhqmR3w4ndJOQqS
	IPORSIeVzR9+5OFTlGysUwxV6uOitTHZnEuToToFS24otgwEj1BSALjizSgTBdfJ
	b0dLnWC2Ixo1T2Yoy4SFlRczoKLEN9UWT1G0iqHDLsEH8uDPk5aDwpZDDtExCGMw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49qew0hwd6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Oct 2025 15:01:45 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59HEY0SR015227;
	Fri, 17 Oct 2025 15:01:45 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49qew0hwd2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Oct 2025 15:01:45 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59HBd3uE018917;
	Fri, 17 Oct 2025 15:01:44 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49r2jn5x58-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Oct 2025 15:01:44 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59HF1ge619988834
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 15:01:42 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E81E20043;
	Fri, 17 Oct 2025 15:01:42 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E57DF20040;
	Fri, 17 Oct 2025 15:01:40 +0000 (GMT)
Received: from [9.111.36.47] (unknown [9.111.36.47])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Oct 2025 15:01:40 +0000 (GMT)
Message-ID: <c67386be-5278-411d-97e7-43fc34bf7c98@linux.ibm.com>
Date: Fri, 17 Oct 2025 17:01:39 +0200
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
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <9beff9d6-47c7-4a65-b320-43efd1e12687@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9LKX8Nmv4XcVUXrLvHE_HxecLxk_cP8h
X-Authority-Analysis: v=2.4 cv=eJkeTXp1 c=1 sm=1 tr=0 ts=68f25a59 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=U-Hwjmto4vr2S7wfJqkA:9 a=QEXdDO2ut3YA:10 a=nl4s5V0KI7Kw-pW0DWrs:22
 a=pHzHmUro8NiASowvMSCR:22 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxNCBTYWx0ZWRfXwHOgqQ6tTe+U
 eJeOmxYOFp6+xojNs6VzBRrLhYngNWxnQYx4056hPZU3A7tztlpmQKe0jl4dRsHm2EY5V4OwECd
 wfXh8kvLFSBLNWQO6YChYGy8sO5WM4VZzr8m4sgqW6h5Ode2RGLfx0nNgfJ6/OIZqgqp3jebCHe
 dmip45P6cxhsJignJNv2FmPri77wdU9CW/FxJ8EHR1zW+g4xOQmIisNydT7y5lhEebl5F7X762z
 F59ssPdVoDm8ELtqeqRw8YLucK+fiFaZoZ6bzLG5yyQGtkx8T1J2LG04XKhx60ksW8Zheieeyiy
 hdZEIis1wsxG2DnvxK4WS+PNIjnS5x8eC2KBhybUtz5i6wzPM91FG6A/3s+VFhy+r+YRTQPrmaJ
 LApWx8jnpGwmr0TM/gRlRO66VANL4g==
X-Proofpoint-GUID: P8unXoLWz4BehbTrBCBmfoLT7VBR8y9s
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015 impostorscore=0
 phishscore=0 malwarescore=0 adultscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510110014

Am 17.10.25 um 16:54 schrieb David Hildenbrand:
> On 17.10.25 16:49, Christian Borntraeger wrote:
>> This patch triggers a regression for s390x kvm as qemu guests can no longer start
>>
>> error: kvm run failed Cannot allocate memory
>> PSW=mask 0000000180000000 addr 000000007fd00600
>> R00=0000000000000000 R01=0000000000000000 R02=0000000000000000 R03=0000000000000000
>> R04=0000000000000000 R05=0000000000000000 R06=0000000000000000 R07=0000000000000000
>> R08=0000000000000000 R09=0000000000000000 R10=0000000000000000 R11=0000000000000000
>> R12=0000000000000000 R13=0000000000000000 R14=0000000000000000 R15=0000000000000000
>> C00=00000000000000e0 C01=0000000000000000 C02=0000000000000000 C03=0000000000000000
>> C04=0000000000000000 C05=0000000000000000 C06=0000000000000000 C07=0000000000000000
>> C08=0000000000000000 C09=0000000000000000 C10=0000000000000000 C11=0000000000000000
>> C12=0000000000000000 C13=0000000000000000 C14=00000000c2000000 C15=0000000000000000
>>
>> KVM on s390x does not use THP so far, will investigate. Does anyone have a quick idea?
> 
> Only when running KVM guests and apart from that everything else seems to be fine?

We have other weirdness in linux-next but in different areas. Could that somehow be
related to use disabling THP for the kvm address space?


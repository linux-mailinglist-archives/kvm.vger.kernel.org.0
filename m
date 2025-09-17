Return-Path: <kvm+bounces-57890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 48A4BB7F550
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:32:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A62EE188DADB
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:27:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE2D7283FD6;
	Wed, 17 Sep 2025 13:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Bb3riT5C"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533AA18BC3B;
	Wed, 17 Sep 2025 13:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115605; cv=none; b=uREP61CTGKZgaf3ufGFFoWHyODdn0pwMAiOpTp7tyzyFrayq6Ro+/8KZoVhQewnAhc4/gDeZd/1v/0bQSblsyRGd5mn9wJ+RQAW/EuxRJs4sQbODKiLQEMbwCp2IlwC8CvtdmwQv8sUWnt3Lba7bordzy8Nvs2OoAyiUcy6QpyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115605; c=relaxed/simple;
	bh=9+wfAo7wCz8Iqh0/nEyw8UzDNFGfAB2P/gUjbe68qVY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tgKrQGTReXmGFxRyzgrqe+j0iWBqfXuih5mGAaxSnoURl+bDjviw/I4kLhXynHH8y5g+ZJ0BRR3dVNJ/zIyBKzmjIAjVYH92vQ3ZjUE/cEQyazhH2kaQvNQAa1yl/BKqraE2YE2614aOb6aG6kti8JPDFvyg3zc9GiOty/NFp1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com; spf=pass smtp.mailfrom=de.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Bb3riT5C; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=de.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58H7Viq7011481;
	Wed, 17 Sep 2025 13:26:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ulcSY3
	RPz6EvuMMcK5h/qpJC5zyUbRgJ2m+augro9q0=; b=Bb3riT5CYfbdAconSaBkJ4
	d0eieXE90PyWnkoRg03qVoPJCqIXeypGVt7MSKSrMhjo3FUuKK1DDVLT1e6+95h8
	HjC0NesaAQTgMHp/+2KGJWTNZU1cTJ/rnPwxTgilHPxR7R+3cs/J8B2/MxGRlm0W
	1l0U/x20fZMEGDIToaAy8VMRelkLe2fK0hi/ji5yHOppnrlbEFFIc3RbgjPcmSf/
	yAXGf0OJfOIM2zyPJxcVLWufrej52Ne+Aeaq3N0IdM1Rbu8xbnne0BCaC8tF2C/y
	puVqsQDjgDRjYitXyCbscq1lhteJXmQ+c5sosxzycYdVjzmDSfKVxCK963tpOwtg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4nbr0n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 13:26:39 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58HDIGLo005963;
	Wed, 17 Sep 2025 13:26:38 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 495jxu9mw1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Sep 2025 13:26:38 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58HDQY1f53281136
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 13:26:34 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6C5CD20043;
	Wed, 17 Sep 2025 13:26:34 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E491620040;
	Wed, 17 Sep 2025 13:26:33 +0000 (GMT)
Received: from [9.87.128.228] (unknown [9.87.128.228])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 17 Sep 2025 13:26:33 +0000 (GMT)
Message-ID: <976f2cf6-e56f-4089-923d-29098746018b@de.ibm.com>
Date: Wed, 17 Sep 2025 15:26:33 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/20] KVM: s390: KVM page table management functions:
 allocation
To: Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        schlameuss@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        david@redhat.com, gerald.schaefer@linux.ibm.com
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
 <20250910180746.125776-9-imbrenda@linux.ibm.com>
 <20250916162653.27229G04-hca@linux.ibm.com>
 <20250916184737.47224f56@p-imbrenda>
 <63e8c905-28b1-4e1f-be77-e0789bd75692@de.ibm.com>
 <20250916190514.1a3082bd@p-imbrenda>
 <15f451d9-ecb3-4a82-9b9a-2de64b93944d@de.ibm.com>
 <20250916173644.27229Kcc-hca@linux.ibm.com>
 <20250917072733.7515Af5-hca@linux.ibm.com>
 <20250917132556.4814fe98@p-imbrenda>
 <20250917123006.7515C59-hca@linux.ibm.com>
 <20250917151124.1a53b0a6@p-imbrenda>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20250917151124.1a53b0a6@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=MN5gmNZl c=1 sm=1 tr=0 ts=68cab70f cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=W2zA-1P5fN6Qusm-TuAA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: vlEZJRES2aTGx5awJesYP4kHjSfuWxyp
X-Proofpoint-ORIG-GUID: vlEZJRES2aTGx5awJesYP4kHjSfuWxyp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfXwy8LHta6JhLz
 a6m37hVZtz1r/hbZMgzb+YhS4nO1INM5xweqih/RqmiCNDqu8K0pZUJoSP3R6i27mdm7BC7TIfe
 lDWdUrjhIg//qcBsD2D/bQ56tSGTK+g7KN7FRjFuhX9jziho3GJHDZ+oJGaixkMm2jAM3rx+f5H
 WqiXa8mBfN8LkcZFjo2EBtlqHKXWn3aKVDFADlj4avbT4RfUXzI6SWrBSI1qsg5uM+5HOcALlrp
 7nXVUTiUgwBzetkv0fhRGcW/qkAMlIqyswAFU5pv84GWJ/gdNCjtt/wfXw7bKwRZP8IkI6BZ8jy
 FwWtXoxeM2k+Ll3NXaSluox3ra0cPvV63dwMniieaX8gDXL9eM+LHbmDJcxbjp6D0YmrCts0zNc
 BfTDIFLH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509160204

Am 17.09.25 um 15:11 schrieb Claudio Imbrenda:
> On Wed, 17 Sep 2025 14:30:06 +0200
> Heiko Carstens <hca@linux.ibm.com> wrote:
> 
>> On Wed, Sep 17, 2025 at 01:25:56PM +0200, Claudio Imbrenda wrote:
>>> On Wed, 17 Sep 2025 09:27:33 +0200
>>> Heiko Carstens <hca@linux.ibm.com> wrote:
>>>    
>>>> On Tue, Sep 16, 2025 at 07:36:44PM +0200, Heiko Carstens wrote:
>>>>> On Tue, Sep 16, 2025 at 07:06:06PM +0200, Christian Borntraeger wrote:
>>>>>>
>>>>>> Am 16.09.25 um 19:05 schrieb Claudio Imbrenda:
>>>>>>      
>>>>>>>>> I think GFP_ATOMIC actually gives more guarantees?
>>>>>>>>
>>>>>>>> In real life GFP_ATOMIC can fail, GFP_KERNEL does not.All gfp allocation failures
>>>>>>>> are usually the atomic ones.
>>>>>>>
>>>>>>> interesting... then I guess I need GFP_KERNEL | GFP_ATOMIC ?
>>>>>>
>>>>>> No. ATOMIC always means: can fail.
>>>
>>> my issue is that GFP_KERNEL can sleep, and this allocation is sometimes
>>> called from atomic contexts (e.g. while holding spinlocks)
>>>
>>> the right way to do this would be with mempools, to allocate memory
>>> (and potentially sleep) when we are not in atomic context, and use it
>>> whenever needed. this is on my to-do list for the future, but right now
>>> I'd like to avoid having to refactor a ton of code.
>>
>> I doubt this is accetable even for an intermediate solution. As soon
>> as the host is under memory pressure and starts doing I/O to free up
>> memory, you will end up in -ENOMEM situations for simple guest page
>> allocations.
>>
>> What happens with a guest in such a situation? Is this gracefully
>> handled without that the guest is terminated?
> 
> well, we return -ENOMEM to userspace (and qemu will probably kill the
> guest)
> 
> but if we can't even allocate 16kB, probably we're already in a pretty
> bad situation
> 
> if you think this is not acceptable, I guess I'll have to implement
> mempools

This is not acceptable. 16k atomic allocations are pretty much guaranteed
to fail after a while of high workload.
What are the callers of this allocation?


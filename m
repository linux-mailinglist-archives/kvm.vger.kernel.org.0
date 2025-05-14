Return-Path: <kvm+bounces-46506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D90EAB6E43
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 16:39:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7F521BA28A7
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 14:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63D441B0420;
	Wed, 14 May 2025 14:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TWoPqJ9q"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1489918B464;
	Wed, 14 May 2025 14:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747233574; cv=none; b=W+GpsTzdHQSrzhJmnntW7SEZR/tdzlsfXL/ewvDgv2azaa7yAauFLF9aSwdBefla3KrstN9xz5bOEd97yRLKf0OA08Z22LAw4MNBy869DCpCXm9P5WjUBK+C7+3+zliRL4f4ShikKGaOEkid9nh71BDOJtmkN1zdDMoP/nVBDdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747233574; c=relaxed/simple;
	bh=XKEX2qhzEUVACLSTBniCIOvEwKQGjpnye85R2UUvn+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bxhCKBYmH2mvAUomrFhaKmM6jp8WgEBQ56VvUvG3NacBZDezxegVyvHo9lOwhzfVPI7R/hUkiWsBpBGMTdOwCsPxnSA8CjyiMpvdNZmzKsdNWWmK1LHNZ3sA4uoCavv1ScDcgE1zBd7A5f1DSthJuMH8FHcPR4mN+bzKAgHr0B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TWoPqJ9q; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54E9F0QU012707;
	Wed, 14 May 2025 14:39:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ezwU+W
	ajc1URSZiFHClykjUSbxb5eibJQFNP5amua4A=; b=TWoPqJ9qCM5e2hA89Yjs00
	hKluK7YvMdo8jeBYHg/gIIUXATY4BmMaUX7uNFtbXN3JqQM9V7f/WLCRpyo+Yrmb
	j996/Dro+I8gQPiUZ4c35UjVndWaXKR53hdprHPO51ceZzrfAD5xTBqXbskh5nJh
	7pu+0cmBGaaYEG4TYJt9sNPIwN0vXr1Ojjyjz7RkdRd2+t+jWpvV1Gj2NfruN8dm
	++Dx5kJdQU8fPB3EB21oZPaF3COZUggcq41Z6Fsrftds8D1qP6isxM5G3s1qSyzP
	+8AtppjrJTxo+5u02bQ9Xd4cnSAkWuiXowRefdMhlruLnXWM3BqkbdzCkFGYIILQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46mrcj9k2e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 14:39:16 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54EDJoAU026954;
	Wed, 14 May 2025 14:39:16 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46mbfpcpfr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 14:39:16 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54EEdCQU48562540
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 14:39:12 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 224BF20067;
	Wed, 14 May 2025 14:39:12 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 703D72006A;
	Wed, 14 May 2025 14:39:11 +0000 (GMT)
Received: from [9.111.70.163] (unknown [9.111.70.163])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 May 2025 14:39:11 +0000 (GMT)
Message-ID: <0da0f2fc-c97f-4e95-b28e-fa8e7bede9cb@linux.ibm.com>
Date: Wed, 14 May 2025 16:39:11 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [akpm-mm:mm-new 320/331] arch/s390/kvm/gaccess.c:321:2: error:
 expected identifier
To: Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
        kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Yang Shi <yang@os.amperecomputing.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
References: <202505140943.IgHDa9s7-lkp@intel.com>
 <63ddfc13-6608-4738-a4a2-219066e7a36d@kuka.com>
 <8e506dd6-245f-4987-91de-496c4e351ace@lucifer.local>
 <20250514162722.01c6c247@p-imbrenda>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20250514162722.01c6c247@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=ZYgdNtVA c=1 sm=1 tr=0 ts=6824ab14 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=yPCof4ZbAAAA:8 a=VnNF1IyMAAAA:8 a=MLotpr-hrvjVaw7tvBEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 8iAoW7lo_vp6J9jGatN1MfANXFUdCSHA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDEzMCBTYWx0ZWRfXy0zqz9bFhi3f U1XNqE+ms5x8XPDbBABTS0bicAxD4v/C8AhKXtfEgBE+blfAfaHQ6pYBVsFLPYLEADkNPvAwbLU NLgV2a3PJzMrek7V3rVxCVYfYDeBHiKRs/WKgKWMPdXlBFn3dzqagvutgurMEJwtI88xIRXZrG6
 dTjagqt4y0EB4Ugz9ix0Q7LHCNcYCeZl/s7fuZ1s5cFAYVCKzUwBBvtMlcKRiG6JtgU1touXLG0 4WjGrLD7MyOPMbcRsAXf/Iz8CO7S567+ZjTtc3pLkpUp5G7KUFzA2Bcw+MyHs+YjxONZy6Up1jv U/QPkUW3+MMUdGfqx/Xudi6dWiwQXKnqVFBpeTII2koF9LrEk6d77U0mSNqXfLnxJ0NYO+YDGyB
 Lyx5JCNdt4QLGLg0zIAvvMVmpNUZArKlVdjShmgeN2VLltIgDHgBwL7M/sNDvmN2UaOLxAET
X-Proofpoint-GUID: 8iAoW7lo_vp6J9jGatN1MfANXFUdCSHA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_04,2025-05-14_03,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 clxscore=1011 lowpriorityscore=0 priorityscore=1501 mlxscore=0 spamscore=0
 suspectscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505140130

Am 14.05.25 um 16:27 schrieb Claudio Imbrenda:
> On Wed, 14 May 2025 14:48:44 +0100
> Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> 
>> +cc s390 people, kvm s390 people + lists. sorry for noise but get_maintainers.pl
>> says there's a lot of you :)
>>
>> On Wed, May 14, 2025 at 03:28:47PM +0200, Ignacio Moreno Gonzalez wrote:
>>> Hi,
>>>
>>> Due to the line:
>>>
>>> include/linux/huge_mm.h:509 '#include <uapi/asm/mman.h>'
>>
>> BTW, I didn't notice at the time, but shouldn't this be linux/mman.h? You
>> shouldn't be importing this header this way generally (only other users are arch
>> code).
>>
>> But at any rate, you will ultimately import the PROT_NONE declaration.
>>
>>>
>>> there is a name collision in arch/s390/kvm/gaccess.c, where 'PROT_NONE' is also defined as value for 'enum prot_type'.
>>
>> That is crazy. Been there since 2022 also...!
>>
>>>
>>> A possible fix for this would be to rename PROT_NONE in the enum to PROT_TYPE_NONE.
> 
> please write a patch to rename PROT_NONE in our enum to
> PROT_TYPE_DUMMY, I can review it quickly.
> 
> if Paolo has no objections, I'm fine with having the patch go through
> the mm tree

Yes, lets do a quick fix and I can also do
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>

for a s/PROT_NONE/PROT_TYPE_NONE/g
patch.


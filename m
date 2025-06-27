Return-Path: <kvm+bounces-50957-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52B85AEB191
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 10:45:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A8FDB4A66AC
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 08:45:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55CD3267AFC;
	Fri, 27 Jun 2025 08:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PLfnY8P3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFE225C81F;
	Fri, 27 Jun 2025 08:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751013916; cv=none; b=nGC5AaoKiBI1lv7zdzbxVSjp1Zlf40PdyBnzOryahW2NnggUIA6NfrU1TJWD7CAozKvmVtmQOJZyc2/N5cxShPhoCv2XFVsPokD1dOJzHthrVInwzqT2B6osDUOuXQivLItPLIpFcAIBQ0R6+KPO5T0Y4QrAsLdgi+UFyWTLrP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751013916; c=relaxed/simple;
	bh=8w5TeuyPxlptFjUY6ArFjdkAPl+REWCj4tvTr+seV7o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ON4K1MpgAWNmUCPrfVh4yWo027dExlDLE1rmGMlzSlJDzHPDhAqHkQK1HUHsWnRsgfok4M6Tx7lSZLr/uDz/R4EO0j9YnHWA7FWRL4ACt2PNE3/N70B2RhgxvvZQdVzUimz0yKrxsHfDVTqtQgmOF7ftzcgVKZ+qBL0neMs6QYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com; spf=pass smtp.mailfrom=de.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PLfnY8P3; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=de.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55QMWGsp031577;
	Fri, 27 Jun 2025 08:45:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=fN8e7t
	+1zr8+1WCchHeHmB33VLUmUSL2gWn8n+v4ZwM=; b=PLfnY8P3CTO8+u0sBkpsmN
	bz06r0RYT3xKFRGX0Oize/oQkRn246TvocnNCyctAHOU7ZVWsCQ/BUJf9l9VaaYD
	dTtVML8//DwIOabmp3bRwKQm5mLOHLV+1ft9Oc/6i06LshDlJJWRVkFopI51dOYe
	DhWTrSrnUajK561opa9CdlvQXflKzo7KnpDbrLgO11Fr34oGBy1Iz19X9rz17NDo
	dhcWGbZpr1KDkfIIbHjeR9RalqQkB+UOxNdrc6G89cr2qBECL4voC59KeKKupDp1
	CiJUiusCiQIZaF8Yvo5ITBhm+5DkH0WDt2WdDk4lCeU1fA2r08cy+legI/2pKerQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47dj5uc23h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Jun 2025 08:45:11 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55R81lYO014987;
	Fri, 27 Jun 2025 08:45:10 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 47e72u3f5u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Jun 2025 08:45:10 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55R8j6U458786234
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Jun 2025 08:45:07 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DB5822004D;
	Fri, 27 Jun 2025 08:45:06 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3355E20043;
	Fri, 27 Jun 2025 08:45:06 +0000 (GMT)
Received: from [9.111.32.43] (unknown [9.111.32.43])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Jun 2025 08:45:06 +0000 (GMT)
Message-ID: <faa9ad1e-2497-42da-a825-c25986251005@de.ibm.com>
Date: Fri, 27 Jun 2025 10:45:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/5] KVM: s390: remove unneeded srcu lock
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com,
        gor@linux.ibm.com
References: <20250514163855.124471-1-imbrenda@linux.ibm.com>
 <20250514163855.124471-3-imbrenda@linux.ibm.com>
 <8373c4a476e6a8f714a559d0fad8f3fed66089f1.camel@linux.ibm.com>
 <0b90cd0ad24727c9d7b110f09fd79b2525b4fbe1.camel@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <0b90cd0ad24727c9d7b110f09fd79b2525b4fbe1.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GlP2qVrpn1eigaspF6t0UFwcJnru7XY_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI3MDA2NiBTYWx0ZWRfXys4I6R2dq0fP +t0MSeD4Rqlp6ZkQ9JscAnrYVxuspA6H5PzYnCfsUa5SHuT7bSKihMzCvN6f1zNUyrnVfjbZgWJ UPailssoTf3pdwrgkkX7wzpcN3noc5e/4PjIcoUS/FlLAPDyaTDCE+y/WegkqCVz74TYkisim9b
 XNvB9GM4Z63wtDpwXKyIp8ezOm52n1bBUNKh4uEnGtokVLxopvkpNN1Exe6MyUennVPPP9ZrtSI B/ZasfFIX8at9UITA1Rf8l6+cs+2PEMiiPAgf08ADhnzKVP2SdjOBdpXbRo7xoRQnBzNvfN/hz1 iVr4Ef/MtEC4gufJeOoT/KoGSZrFUEF7hHosXmTFSOdRQPMA9hJ57zRH9mU9KrLI4wWfT4KaUuH
 6HFSQnNmKE6R9Mz4zk8i6dwg0lWyGE6zleRDwR0GHGc65VzM5J5Yvxdnzti1oKPI8NupZRUz
X-Authority-Analysis: v=2.4 cv=MshS63ae c=1 sm=1 tr=0 ts=685e5a17 cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=zO_5yEawC278s_0qgMcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: GlP2qVrpn1eigaspF6t0UFwcJnru7XY_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-27_03,2025-06-26_05,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=618 impostorscore=0
 clxscore=1015 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0
 priorityscore=1501 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506270066



Am 20.05.25 um 16:34 schrieb Nina Schoetterl-Glausch:
> On Mon, 2025-05-19 at 16:42 +0200, Nina Schoetterl-Glausch wrote:
>> On Wed, 2025-05-14 at 18:38 +0200, Claudio Imbrenda wrote:
>>> All paths leading to handle_essa() already hold the kvm->srcu.
>>> Remove unneeded srcu locking from handle_essa().
>>>
>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>
>> Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>>
>> Why are you removing it tho?
>> It should be very low cost and it makes the code more robust,
>> since handle_essa itself ensures that it has the lock.
>> It is also easier to understand which synchronization the function does.
>> You could of course add a comment stating that the kvm srcu read side needs
>> to be held. I think this would be good to have if you really don't want the
>> srcu_read_lock here.
>> But then you might also want that documented up the call chain.
> 
> Actually, can we use __must_hold or have some assert?

Yes, that might be the best way.



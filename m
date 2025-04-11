Return-Path: <kvm+bounces-43157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A6E3A85B5D
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 13:17:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F1548C0C8A
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 11:12:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1DAC238C1A;
	Fri, 11 Apr 2025 11:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fcLkhqJT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEA0221261;
	Fri, 11 Apr 2025 11:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744369932; cv=none; b=dzFxITI1XAMQKo7BaWossQt5sRDkJ7kMwI1xGgu+qwjE4MVU+roqQsjqWO/3G85IuOHRQQBYeCHtgpUMP7vowRs5zHY5avodVbTJWambV5OxZFq5fxoSvFwHt5n5DzgTEywxyhe3xcMVgcm9kBjdVMfhlV9ovNAVwYr0l+WokRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744369932; c=relaxed/simple;
	bh=FUQOpShM/qKPlkYr0w/mK5JyznMNm4iflYY28xYMzuc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tRg93maQbz4Lr+8YG6lMDHx/q8QMtYbROPWzkyejgtn0OuqHFU/Rlkift0edPI5+hFx6nv1abzielJDVu02FQOqvFA1bczJLu28nTgiF+4mgP+Tw6kYm23cW5rGwyTxSaRaFxKh8qV3A+6e73oYxLTBZNTUVv0fDtTRNweqGpwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fcLkhqJT; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53B3kJD6027632;
	Fri, 11 Apr 2025 11:12:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=qFNRJ0
	NLHfjTNq+Xox+fYdzva/4pe8ltrKWFdZWaN/I=; b=fcLkhqJTA93tRApbCxcP7H
	MdmzynvcEsxkbsxhV8gfGf+q4nB/Pbsl/+GOJurTZxbs71uKWyABCri5dvSNMX70
	Nod+H9wgf3IjSFpZutTA1oPgzu8nKvUuBgBFgpT3juIG2Jonb7NlUFuASutTTHzK
	KIFafoN0EzNuOXVA/erRh2hMrlSddivIKPM6jApC7Th9UKCg4KPoD0cYrQWZTfXF
	yxRoDH2mYdKPyDgfkrYhJ0UhiriPbeRuOWnVQNHJihLVy1ngODZYxLKbdaTs4ezw
	fZ02HS6QJ284bk2honJvQ9VdHmKvMJSyavBakgdr0GHy5rH66/jX/5kk7EdwLknw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45xufa9v72-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Apr 2025 11:12:01 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53B9EIrl024577;
	Fri, 11 Apr 2025 11:12:00 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 45ueuttvvn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Apr 2025 11:12:00 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53BBBuAP43057640
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Apr 2025 11:11:56 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6F6902004B;
	Fri, 11 Apr 2025 11:11:56 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F2F620043;
	Fri, 11 Apr 2025 11:11:55 +0000 (GMT)
Received: from [9.171.62.213] (unknown [9.171.62.213])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Apr 2025 11:11:55 +0000 (GMT)
Message-ID: <a6f667b2-ef7d-4636-ba3c-cf4afe8ff6c3@linux.ibm.com>
Date: Fri, 11 Apr 2025 13:11:55 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, Chandra Merla <cmerla@redhat.com>,
        Stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Wei Wang <wei.w.wang@intel.com>
References: <20250402203621.940090-1-david@redhat.com>
 <065d46ba-83c1-473a-9cbe-d5388237d1ea@redhat.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <065d46ba-83c1-473a-9cbe-d5388237d1ea@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7j2Hpeh7kYNRktpeuE5HSecIMZ7XXZyg
X-Proofpoint-ORIG-GUID: 7j2Hpeh7kYNRktpeuE5HSecIMZ7XXZyg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-11_04,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 adultscore=0 spamscore=0 bulkscore=0 mlxlogscore=852
 clxscore=1015 suspectscore=0 malwarescore=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2504110069

Am 10.04.25 um 20:44 schrieb David Hildenbrand:
[...]
>> ---
> 
> So, given that
> 
> (a) people are actively running into this
> (b) we'll have to backport this quite a lot
> (c) the spec issue is not a s390x-only issue
> (d) it's still unclear how to best deal with the spec issue
> 
> I suggest getting this fix here upstream asap. It will neither making sorting out the spec issue easier nor harder :)
> 
> I can spot it in the s390 fixes tree already.

Makes sense to me. MST, ok with you to send via s390 tree?



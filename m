Return-Path: <kvm+bounces-57765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FD5AB59ECC
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 19:07:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60F993B227F
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 17:06:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61DB72F7AA6;
	Tue, 16 Sep 2025 17:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bSysYenv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58912F5A39;
	Tue, 16 Sep 2025 17:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758042378; cv=none; b=X1k1O5Q3pOvKdQSch6dgl2SHFka03oFke/3SQtS/3NradEmIgRMHHY9hXQ22sNEWQBQNHtefnWj/U7PDWV/39JmlwM4PUH/8gKlH1LxWMJ3Wrl/TzKbvfPwrBU5MMpSQtIAeseaRRK0lC2W6sQYi/SIrTaIyp5CxeV8TndHeeDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758042378; c=relaxed/simple;
	bh=kyqm4NbpdtE0dP8pVgnlair1uI/jShOLZO+H5NR338w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AgjF7tmfmvV4FHDPeHu0lbYnkOn8+PmAfELp9G05gyH1t1toy7J1dScEBH+4IMRTfwBQbT5CwbqhA6maxxKwobQhIXHHzUQLL8dgJws+DYRgfPv39TWFLXwaMqH83jUczam5rTrqjlUfvO0fHI5pi2+TmF0WZNqIasv2nvirH5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com; spf=pass smtp.mailfrom=de.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bSysYenv; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=de.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=de.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GH140H006714;
	Tue, 16 Sep 2025 17:06:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ki0J/A
	pYZNt66X2eGhoSNYCseD6FlHxPJje7QBSL9Vw=; b=bSysYenv0hE3anUXdT/K77
	Dkfs2/WPbpjyd92TVecFJLUt4jG4pBvqEjtxOWfTndR79exE9tWIqTZpozyw+Q/e
	aPKSvAaPewCeuS19s6naonLP9oQHtYMnGj5711azu+1TUvVWy88A/hvr2XLurFwB
	+iHTZNpXAMkafI3+4jrssRqlViYaTH1OvqhNnvbP01+L1nYMYELYaWg/nlZ4wvcU
	dJJiaz3f79i2OB35r3lDf89WqH55dshmpJRh1CBL8mvOLHrpc1Af/AsOFn1EhzQf
	orurF2ub0OEy5qgLAja9cXKYaixP5jrYSkL2fSwDvU6KJy4gCvbkXwwpBZbKEB9w
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 494y1x9r13-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 17:06:12 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58GH0cIH005923;
	Tue, 16 Sep 2025 17:06:11 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 495jxu588q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 17:06:11 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58GH67bw45875626
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 17:06:07 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BC6CB2004B;
	Tue, 16 Sep 2025 17:06:07 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0950520043;
	Tue, 16 Sep 2025 17:06:07 +0000 (GMT)
Received: from [9.87.138.242] (unknown [9.87.138.242])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 Sep 2025 17:06:06 +0000 (GMT)
Message-ID: <15f451d9-ecb3-4a82-9b9a-2de64b93944d@de.ibm.com>
Date: Tue, 16 Sep 2025 19:06:06 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/20] KVM: s390: KVM page table management functions:
 allocation
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
 <20250910180746.125776-9-imbrenda@linux.ibm.com>
 <20250916162653.27229G04-hca@linux.ibm.com>
 <20250916184737.47224f56@p-imbrenda>
 <63e8c905-28b1-4e1f-be77-e0789bd75692@de.ibm.com>
 <20250916190514.1a3082bd@p-imbrenda>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20250916190514.1a3082bd@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAxMCBTYWx0ZWRfXzzZ5UejXd4g8
 uA6kFRGALrz7SJV4eZL7UEg+qoBfaPVQ9LJYkD4fdpKuDFSrSvVxJPmaTGYi2lEoyTvIYfdjdft
 qv2tLXekgUFi1mClPsmkW7O33JAgwIb1XBbrNyTgMWEpUylTxcSuZaJTK5/dVckpwYGa5YcbrgM
 6IliSTMRlw6S8k+xf0s12a9TVNNK6POX8ElP5rtBrZtnFItE/QuqjrbpS3LMsy3TiMtV0zvUurb
 AvlBemRBnuieJHBsYWlPdCcZgSVpBd6jMYs9PDe+HtIUh7whze495mS1+lftKRVvYfN61e3wHka
 2ER5sT7jfH+RbJ43L3W8bz5MSbx/rGlta3kapv2inTnVlza3uuzxrSoSZBK98ztrGEHH9CNf/Iw
 gRmwymvw
X-Proofpoint-ORIG-GUID: HmpNuYblTvkx7q1wXa5bSxa9eFQyfiJ-
X-Authority-Analysis: v=2.4 cv=euPfzppX c=1 sm=1 tr=0 ts=68c99904 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=K85XzNye_aR_7k20X00A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: HmpNuYblTvkx7q1wXa5bSxa9eFQyfiJ-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509130010


Am 16.09.25 um 19:05 schrieb Claudio Imbrenda:

>>> I think GFP_ATOMIC actually gives more guarantees?
>>
>> In real life GFP_ATOMIC can fail, GFP_KERNEL does not.All gfp allocation failures
>> are usually the atomic ones.
> 
> interesting... then I guess I need GFP_KERNEL | GFP_ATOMIC ?

No. ATOMIC always means: can fail.


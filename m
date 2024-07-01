Return-Path: <kvm+bounces-20789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CC4791DCE1
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 12:39:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D434282F60
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 10:39:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA0307404F;
	Mon,  1 Jul 2024 10:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BiXL0FZy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98F939FD0;
	Mon,  1 Jul 2024 10:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719830365; cv=none; b=S8OoGF21MFOXzYb0WHAqMSYuKnktHtSmD3hS/2zTUsUSmAIVevVC2x6xtj8RYwZiu3Q3nRMK98MlO4riu/K0r6V636jVdacXJi/vaycXbO5ds9iWVfVKmw4COi+5OdtMuQ4ZaxQS/ms2ZfIeQLlQFu3v1zqIZyHxsqNKM8w8YZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719830365; c=relaxed/simple;
	bh=w1BDiXXPPbCkqYm/BgCBf5sypVQRXTRS+TGXHwrNmwI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nnNEQIzpLiwVMAO9LQW80tg9jToWRAl1EzhDldTw64TZoVb0sLylxnyauNL8s4WdQJfbE3yTdC/3t7Po28SrEZVZwzJSxkGfB3WGbqBicF8nzuNwwIDgzjn5MbcRcqymCDDKtyKk+Fu03wYCGhUt95Y+Er2gr5+/mzYcBy8N2o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BiXL0FZy; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 461AT3JE009837;
	Mon, 1 Jul 2024 10:39:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=v
	mVWy9cRc0IqmqPQG1mDAHJpkbQCf4E1RJ7NwXIpq0w=; b=BiXL0FZyO1G+sDApM
	CFxf9BSmKgvOSgIoSrwMzirIftEdaeBcIL7B/ZIBjtWMvyXJU8w4iKy7XLbtkTo1
	I3q5AdT0ItxezlRqmSA+3EXt0HklkqYNfyhPT5qi0zXviqNalmx4XZtllHjysEtI
	ymCazshrigUqKLkS+/gMT1ZMYArmSOZdAA1VWQraIiyZpFcVCh/AcfRWHoBvJsR9
	L2paNrM3Zhb9FmU/aoPo9kZNYDlDHUOypErDcgC33oHQrvXyZH0dpsoFuVPR/kSw
	OkjZVWRDoXJTtBqDYPKsnyW69/wAV32kV8fazjFwtLm+8D6tyQW67VJu32UmnKHh
	Wk2+w==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 403tqv00ne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jul 2024 10:39:16 +0000 (GMT)
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 461AdGTA022964;
	Mon, 1 Jul 2024 10:39:16 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 403tqv00nb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jul 2024 10:39:16 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4617PDuP009086;
	Mon, 1 Jul 2024 10:39:14 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 402w00evyp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jul 2024 10:39:14 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 461Ad80q15139220
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Jul 2024 10:39:10 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A32EA2004F;
	Mon,  1 Jul 2024 10:39:08 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 71D412004B;
	Mon,  1 Jul 2024 10:39:08 +0000 (GMT)
Received: from [9.152.224.222] (unknown [9.152.224.222])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  1 Jul 2024 10:39:08 +0000 (GMT)
Message-ID: <908b208e-57e9-495d-8936-f48c83c893da@linux.ibm.com>
Date: Mon, 1 Jul 2024 12:39:08 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: s390: fix LPSWEY handling
To: KVM <kvm@vger.kernel.org>
Cc: Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390
 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
References: <20240628163547.2314-1-borntraeger@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20240628163547.2314-1-borntraeger@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YWq3EnLsIN9aitQUv68PiB8igBgWu5j7
X-Proofpoint-ORIG-GUID: Ty7vzh3xSf_74MlRng9tuo92jf2TWLJ0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-01_08,2024-06-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 mlxscore=0 lowpriorityscore=0 spamscore=0 adultscore=0 mlxlogscore=655
 suspectscore=0 priorityscore=1501 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2407010080

Am 28.06.24 um 18:35 schrieb Christian Borntraeger:
> in rare cases, e.g. for injecting a machine check we do intercept all
> load PSW instructions via ICTL_LPSW. With facility 193 a new variant
> LPSWEY was added. KVM needs to handle that as well.
> 
> Fixes: a3efa8429266 ("KVM: s390: gen_facilities: allow facilities 165, 193, 194 and 196")
> Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>

applied.


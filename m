Return-Path: <kvm+bounces-56861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11B7EB45014
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 09:40:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 65B167AFF36
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 07:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 056A8259C98;
	Fri,  5 Sep 2025 07:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Vjc363P/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD72261B64;
	Fri,  5 Sep 2025 07:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757058000; cv=none; b=JnkHPvO9dwqWzF5C1h2tW8ccHPoY7rc01Kg0Jt3sWp9elsQFmB45F3QXrNBNknK8u/VL8RFUr8KBfNNSsCpdlPZh4aStXjMbG2J7MoATS40BSz3M4ibqkqgpZS3ninkeXDleiWnDHcgwHEZpEFu5Oij8609OdpVtA06xZv4uiY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757058000; c=relaxed/simple;
	bh=LGKicp9IFp1aqLOkYP7ORkUSIFY5d0s5obaMoKxBCEU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q40ckQfh4DAvF7K7OfYpFP6IaqnMpWci4W7FL1sYQfGxZ26/0QdXCGbWkOXrNEDoAZgbyXGGPGsnqt8mm3hVQUX7O//e4e3HFBmfgrguXgTXw9rl+1bHhYb3mKI9AGOiQ05G/hSojSI56VRywTaQ7khUwEVkZwutbnvoknn72zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Vjc363P/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584IfMfw000698;
	Fri, 5 Sep 2025 07:39:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=sO+BFf
	nmRMxbqV3YViJUn+kn/sxHKFAEXD/c/QdX9sc=; b=Vjc363P/+mFjCC/82YI0Kk
	oogVYI8+XMOoWn4oYwapaySxJtGtfhuzRRW1y/3t85ldb79x96aCA0iMX4Z1gAer
	PKoUHqGSfdB+ALvDbw2PERcmPgz9NxN+S13B2HKxBXduC3mvQPH3K2OdPCdGkFfr
	aNefKk8HslO94F3M/Ew9ZmIs80Y3Odqia/k00m/pP9QZvFKlvcKtZsfnKN9P6N1k
	r8JzR7qFqCXTsKhRF8P2hXD46EgEv2YqLHNATYDz8Gm36vzFt3yrSkM7dz31tmDe
	XmMBQnkEToctYZwb57wSzM6OKE1CcFUi8+RP9M/y1AaTWb1fd3m2OF/lYEUqJ2ag
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48wshfacv3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Sep 2025 07:39:55 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5856GgVj013959;
	Fri, 5 Sep 2025 07:39:55 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 48veb3r466-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Sep 2025 07:39:54 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5857doAk54133198
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 5 Sep 2025 07:39:50 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A9872004B;
	Fri,  5 Sep 2025 07:39:50 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0D8AD20043;
	Fri,  5 Sep 2025 07:39:50 +0000 (GMT)
Received: from [9.111.23.44] (unknown [9.111.23.44])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  5 Sep 2025 07:39:49 +0000 (GMT)
Message-ID: <46a981a1-84fb-4f35-bb91-da4f0d6b1378@linux.ibm.com>
Date: Fri, 5 Sep 2025 09:39:47 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: improve interrupt cpu for wakeup
To: Janosch Frank <frankja@linux.vnet.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org
References: <20250904113927.119306-1-borntraeger@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20250904113927.119306-1-borntraeger@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Iz40JNIrcRe2OQNjxPKvLl-wHC-OgXCo
X-Authority-Analysis: v=2.4 cv=do3bC0g4 c=1 sm=1 tr=0 ts=68ba93cb cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=O1rW9cO9ph_K1hW2cTAA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Iz40JNIrcRe2OQNjxPKvLl-wHC-OgXCo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTAyMDA0MCBTYWx0ZWRfXwJQcM8sCCVZS
 XbvgsM3k7JKP/0x/ipvUzpR6rLM1a/skRk1wVM5Dcjk3Wpz9BBMeQ4DqonC2DIA3nz/o4IX0Yte
 AA1PbLTT6JUC0yLn6LlJ9SpCT+bchZ4708wkvWd3QXbML0NJbuRSdvxXmjEQ4FWFPQPCbkK89in
 7QcJBXTqv7xZvgm3RxxuBlz+8oAdd4+LiXyqLPp1ab3/j6v0LN+Z7yr9SyLbdlAeHe7mVtFUPU6
 x6L4nCnHxFVT7/g0/ltNnkZ3ZTudMhxrslzd9wJRlLjjyuIa1Wdixb74VJ6Djn6ZRbnRnIRcVHc
 yMjdtVmSvO9a3wNVj4Y5wvQKZP3agmot1HNuHdQMNsvwKYluxkgRW7fb4C5E/Lt8pV2N8sRAvHB
 vYQgXyWR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_02,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 impostorscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509020040

Am 04.09.25 um 13:39 schrieb Christian Borntraeger:
> Turns out that picking an idle CPU for floating interrupts has some
> negative side effects. The guest will keep the IO workload on its CPU
> and rather use an IPI from the interrupt CPU instead of moving workload.
> For example a guest with 2 vCPUss and 1 fio process might run that fio on
> vcpu1. If after diag500 both vCPUs are idle then vcpu0 is woken up. The
> guest will then do an IPI from vcpu0 to vcpu1.
> 
> So lets change the heuristics and prefer the last CPU that went to
> sleep. This one is likely still in halt polling and can be woken up
> quickly.
> 
> This patch shows significant improvements in terms of bandwidth or
> cpu consumption for fio and uperf workloads and seems to be a net
> win.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>


applied internally for CI regression runs. Will push to next if successful.



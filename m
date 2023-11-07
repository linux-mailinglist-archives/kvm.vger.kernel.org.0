Return-Path: <kvm+bounces-880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CE127E3E80
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 13:39:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B9EE1F21CBC
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 12:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 059A530CF1;
	Tue,  7 Nov 2023 12:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nj7WawsW"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4CB30CE2
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 12:39:21 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121ED5FE6;
	Tue,  7 Nov 2023 04:39:05 -0800 (PST)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7CGbTt011726;
	Tue, 7 Nov 2023 12:39:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=x4PHbO9XaSO6JKYzqJWog0YUAelsRwA3UtI7UlY25vo=;
 b=nj7WawsW0mZHQgQMAagiGhe1+wvWv1NJCs3Gmfq3cfmTWsY+/b9J2lWMiMookIpPbPvy
 ffn9BC7W+M5V0+d8XZI/YM9jT4SKMXdG9cFncsC/H9ei2t//pMQs+1UAy4+EHISDtoh/
 l4ZF8GxmYDSZDVUtTdfZRn7+dNOl/5EeQnEoLOsESgbYSkTSWM51Hs8i5243oOMi7NSA
 gxft431Vlyv8fLj9HyWwNZ/vAz0VGsDkBKo03FNmH06anZArkjYyxOLHZJvMSZj5evPo
 QluPr41Q3bbSGSLqxxKJj62liqtMl4QhSXID9s6FqcaFVeva0YirzZwIkL+7fBg2zlK4 Ww== 
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u7n3n8mwg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 12:39:04 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7C1kIn012794;
	Tue, 7 Nov 2023 12:39:03 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u609srttj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 12:39:03 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A7Cd0YS15926012
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Nov 2023 12:39:00 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 83C022004E;
	Tue,  7 Nov 2023 12:39:00 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 50F2320043;
	Tue,  7 Nov 2023 12:39:00 +0000 (GMT)
Received: from [9.152.212.186] (unknown [9.152.212.186])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  7 Nov 2023 12:39:00 +0000 (GMT)
Message-ID: <b54e18a9-582d-3619-773e-695dcf19eaad@linux.ibm.com>
Date: Tue, 7 Nov 2023 13:39:00 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH 1/1] s390/cio: make sch->lock a spinlock (is a pointer)
Content-Language: en-US
To: Halil Pasic <pasic@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20231101115751.2308307-1-pasic@linux.ibm.com>
From: Vineeth Vijayan <vneethv@linux.ibm.com>
In-Reply-To: <20231101115751.2308307-1-pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: V8WkhQe0FWl7sGOLSw2i938sj1O19URY
X-Proofpoint-ORIG-GUID: V8WkhQe0FWl7sGOLSw2i938sj1O19URY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-07_02,2023-11-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 impostorscore=0
 spamscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=754
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311070104



On 11/1/23 12:57, Halil Pasic wrote:
> The lock member of struct subchannel used to be a spinlock, but became
> a pointer to a spinlock with commit 2ec2298412e1 ("[S390] subchannel
> lock conversion."). This might have been justified back then, but with
> the current state of affairs, there is no reason to manage a separate
> spinlock object.
> 
> Let's simplify things and pull the spinlock back into struct subchannel.
> 
> Signed-off-by: Halil Pasic<pasic@linux.ibm.com>
> ---
> I know it is a lot of churn, but I do believe in the end it does make
> the code more maintainable.

You are right. Makes the code easy to read and a bit less complex.
Looks good to me. Thanks

Reviewed-by: Vineeth Vijayan <vneethv@linux.ibm.com>

--snip--


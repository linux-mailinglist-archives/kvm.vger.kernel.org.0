Return-Path: <kvm+bounces-1983-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 377DD7EFB9D
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 23:49:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B2554B20B8D
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 22:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA27047782;
	Fri, 17 Nov 2023 22:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SCdeXJlw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BE7D5B;
	Fri, 17 Nov 2023 14:49:39 -0800 (PST)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AHMeRNW008624;
	Fri, 17 Nov 2023 22:49:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Bzz4F3zy9NB6M3oOX0CI34HMPpk7JdJuCetn/hvE+Ik=;
 b=SCdeXJlwBbW+LhouPw4jhT3juFMHcbLKOm4KfnmDOJImbC5oQnN0viivqk6v0tzY6zuS
 3L5HhOFsA2Ml9gEoxEhWUIoqjQ0mhsIrFkBYyBzRH/Oq1eo20F+cQrNXmcA7HXGQgSDs
 wgExZCzu+WPxJGv08ohWoyDfQeb8aoAbu/yrSqrCwtuC+/QRCBDmt2pjK5svu/luFYsi
 UfL8VtV/EHXjtqRid+K0bTGjrjhce0M3FdQ5+3lZC8BHMQ1i3SBCZkx8MXbGUT6sXAlN
 UpAuMiaQWxOtiLen0ffJJWF+3teP9TwzMkYaDMu0nENxRuZmuEg6N7obsOIm7yCGKIDB hQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uegb21nam-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 22:49:38 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AHMgwCl014923;
	Fri, 17 Nov 2023 22:49:37 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uegb21nag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 22:49:37 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AHLJD0J012347;
	Fri, 17 Nov 2023 22:49:37 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3uamb01gcn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 22:49:37 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AHMna2Y9372402
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Nov 2023 22:49:36 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 42E835805A;
	Fri, 17 Nov 2023 22:49:36 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DEBCF58054;
	Fri, 17 Nov 2023 22:49:34 +0000 (GMT)
Received: from [9.61.190.175] (unknown [9.61.190.175])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Nov 2023 22:49:34 +0000 (GMT)
Message-ID: <356d1ce0-26e9-474d-8b00-bac4e7421a2b@linux.ibm.com>
Date: Fri, 17 Nov 2023 17:49:34 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] s390/vfio-ap: a couple of corrections to the IRQ
 enablement function
Content-Language: en-US
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, pasic@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com
References: <20231109164427.460493-1-akrowiak@linux.ibm.com>
 <ZVTV37wqwu8cDmK7@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <602a4845-726d-e034-bd77-20be1ff1d491@linux.ibm.com>
From: Tony Krowiak <akrowiak@linux.ibm.com>
Organization: IBM
In-Reply-To: <602a4845-726d-e034-bd77-20be1ff1d491@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uK6v9-HETanOPR0zFMmQmhrysxlCbRBS
X-Proofpoint-ORIG-GUID: M0GNDoB7efXn-yXX5DuWoqbyROgQfVOp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-17_21,2023-11-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999 spamscore=0
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311170171



On 11/17/23 10:31, Christian Borntraeger wrote:
> Am 15.11.23 um 15:29 schrieb Alexander Gordeev:
>> On Thu, Nov 09, 2023 at 11:44:19AM -0500, Tony Krowiak wrote:
>>> This series corrects two issues related to enablement of interrupts in
>>> response to interception of the PQAP(AQIC) command:
>> ...
>>
>> Hi Tony!
>>
>> Via which tree this series is to be pulled?
>>
>> Thanks!
> 
> I wanted to create a topic repository/branch for s390-specfic vfio code 
> when we expect conflicts or touch kvm or vfio base code.
> I started that but I have not finished my preparations.
> 
> Given the diffstat:
> drivers/s390/crypto/vfio_ap_ops.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
> 
> This looks pretty much isolated to s390, so unless Paolo or Alex complain,
> we should simply carry that via the s390 tree.
> Alexander, can you take those patches?
> Tony, I assume none if the patches is urgent and can wait for the next 
> merge window, correct?

It is not urgent.

> 
> Christian


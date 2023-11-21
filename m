Return-Path: <kvm+bounces-2227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1A447F38A7
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 23:03:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D913B219A4
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 22:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7FF454678;
	Tue, 21 Nov 2023 22:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hTk39W0X"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98346D4B;
	Tue, 21 Nov 2023 14:02:49 -0800 (PST)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ALLv8nj004956;
	Tue, 21 Nov 2023 22:02:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=e9gLnnnQBY16GXpEz0eYBqi+hifeX2GNwOnaQeYWbLQ=;
 b=hTk39W0Xl7NHgxTVX7tD9lawsGud5qMRX9Z4a0/J7LMAVRR5MFGCvge9n9H/FZMhoB+y
 Sp5Y/07cPx2+85jxgM1Gi4VKFz71RP4ZacMNMMYWCLyC4W6PBQ/8izF3LZuHNZlxW3t9
 Ax7p7Lb27v2hHhSWBhsdOsuoE5TgRNY8WbyeTSwnGFzDWNy7gBBmvIc3pBc+MNeNxsf8
 P8O55fB1Rl7zC3jPbmR5NjIQ7HehUnXcPOrPCSTX7dBVgtnrs63d846vdMAX2jUlpw0V
 637ZymvPcRN8reNh6fVWTlbGpVvSx6x8MkrdT8HyvLK5Y6uWXzZ91i25mMj88+6RBVTW rw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uh4wn85eg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Nov 2023 22:02:48 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3ALLwnBX008939;
	Tue, 21 Nov 2023 22:02:48 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uh4wn85e2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Nov 2023 22:02:48 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3ALLnRIV022911;
	Tue, 21 Nov 2023 22:02:47 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uf7kt403n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Nov 2023 22:02:47 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3ALM2kWi66257178
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Nov 2023 22:02:46 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5F6405805F;
	Tue, 21 Nov 2023 22:02:46 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 12B7758043;
	Tue, 21 Nov 2023 22:02:45 +0000 (GMT)
Received: from [9.61.106.42] (unknown [9.61.106.42])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 Nov 2023 22:02:44 +0000 (GMT)
Message-ID: <0891a316-1a62-4236-bfae-6fbb4f5341cf@linux.ibm.com>
Date: Tue, 21 Nov 2023 17:02:44 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] s390/vfio-ap: fix sysfs status attribute for AP queue
 devices
To: Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, jjherne@linux.ibm.com,
        pasic@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        david@redhat.com, Harald Freudenberger <freude@linux.ibm.com>
References: <20231108201135.351419-1-akrowiak@linux.ibm.com>
 <17ef8d76-5dec-46a3-84e1-1b92fadd27b0@linux.ibm.com>
 <f18f6993-17e8-cab4-6a7f-059f669fc890@linux.ibm.com>
 <ZVzAWPzAFR5JV2jZ@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Content-Language: en-US
From: Tony Krowiak <akrowiak@linux.ibm.com>
Organization: IBM
In-Reply-To: <ZVzAWPzAFR5JV2jZ@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lle0B6Izk6B8x0dFi1_AddrBebUpjZDZ
X-Proofpoint-ORIG-GUID: xy0tjfvqK7p_2QmQV8_hMnR0c0A0vMLi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-21_12,2023-11-21_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 bulkscore=0 phishscore=0 clxscore=1011
 spamscore=0 mlxlogscore=966 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311060000 definitions=main-2311210172



On 11/21/23 09:36, Alexander Gordeev wrote:
> On Mon, Nov 20, 2023 at 10:16:10AM +0100, Christian Borntraeger wrote:
>> I think this can go via the s390 tree as well. Alexander do you want to take it?
> 
> Applied, thanks!
> 
> I assume, it does not need to wait until the merge window?

I can't answer that question, but this is not a critical fix as it 
simply fixes an erroneous display of a queue's status via it's sysfs 
status attribute which is reflected in the lszcrypt -V output. The error 
only occurs in a specific instance which is likely rare.


Return-Path: <kvm+bounces-1971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F0C07EF552
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 16:32:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D7AC31F26611
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 15:32:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 986C936B00;
	Fri, 17 Nov 2023 15:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="U/AOMy5L"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49ADBA6;
	Fri, 17 Nov 2023 07:31:56 -0800 (PST)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AHFTiSC012403;
	Fri, 17 Nov 2023 15:31:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=iTnEspwMQooT9kADRW8KyPSffBI1ZjR94hnZaJV7CxU=;
 b=U/AOMy5LF6CXYJo+Tgvo6Smwo1xWR01GDNEbPnHX1yv2Av1MBb8t1CG9Wn5XMs1rfeQH
 zFkU0e68vAJ4dB7Yp/AKQhKI6CaaQmJZZfHtxtgbL7RVCcX6dR4OFTyF9A8EduVXFGzX
 JDftFhhBi8RgOG6Lxt0WOIAQWD4PJ+ZwJWdoh0ULTe88gQb89UnJ3bh0LDaOXVeMC6Rp
 jqMwcAngZ3qM2ofCby9ZtctvM+jsp+qvk9zQRaLXsOintlJ29f2+0OzCQfLYPgssgsOV
 TT+w6P6pgYEUMvS3wdGZRv7flTdHRLNUKjptXyDchLrcz1zis01Utd504sTy5yxBSdho 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ueav0823v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 15:31:55 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AHFV9Ja019173;
	Fri, 17 Nov 2023 15:31:54 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ueav08236-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 15:31:54 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AHFJM2j015911;
	Fri, 17 Nov 2023 15:31:53 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3uanem6s7h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Nov 2023 15:31:53 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AHFVoUt22938142
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Nov 2023 15:31:50 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ABB2820040;
	Fri, 17 Nov 2023 15:31:50 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D5D0820049;
	Fri, 17 Nov 2023 15:31:49 +0000 (GMT)
Received: from [9.171.85.46] (unknown [9.171.85.46])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 17 Nov 2023 15:31:49 +0000 (GMT)
Message-ID: <602a4845-726d-e034-bd77-20be1ff1d491@linux.ibm.com>
Date: Fri, 17 Nov 2023 16:31:49 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 0/3] s390/vfio-ap: a couple of corrections to the IRQ
 enablement function
Content-Language: en-US
To: Alexander Gordeev <agordeev@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, pasic@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com
References: <20231109164427.460493-1-akrowiak@linux.ibm.com>
 <ZVTV37wqwu8cDmK7@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <ZVTV37wqwu8cDmK7@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7tchSGKMnRkGjNvmQmANIL7J-leeLhyz
X-Proofpoint-ORIG-GUID: O-UUqnOanJES3bFbnc4RB5pMyDjRESVU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-17_14,2023-11-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 phishscore=0 clxscore=1011
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311170115

Am 15.11.23 um 15:29 schrieb Alexander Gordeev:
> On Thu, Nov 09, 2023 at 11:44:19AM -0500, Tony Krowiak wrote:
>> This series corrects two issues related to enablement of interrupts in
>> response to interception of the PQAP(AQIC) command:
> ...
> 
> Hi Tony!
> 
> Via which tree this series is to be pulled?
> 
> Thanks!

I wanted to create a topic repository/branch for s390-specfic vfio code when we expect conflicts or touch kvm or vfio base code.
I started that but I have not finished my preparations.

Given the diffstat:
drivers/s390/crypto/vfio_ap_ops.c | 12 ++++++++----
  1 file changed, 8 insertions(+), 4 deletions(-)

This looks pretty much isolated to s390, so unless Paolo or Alex complain,
we should simply carry that via the s390 tree.
Alexander, can you take those patches?
Tony, I assume none if the patches is urgent and can wait for the next merge window, correct?

Christian


Return-Path: <kvm+bounces-3392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D183F803C0F
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 18:52:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D1E21C20ADF
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 17:52:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 864242EAF7;
	Mon,  4 Dec 2023 17:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YjTiAXFM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2E9101;
	Mon,  4 Dec 2023 09:51:55 -0800 (PST)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B4HMPgE012658;
	Mon, 4 Dec 2023 17:51:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zJQivNQzwYAPrjvrnOhA8LkNaDPkJCVbeU257TYsUHI=;
 b=YjTiAXFMT9x/PGgJaNKGrPJG2/2snhvz4LiQCiBVI/hsV6Lpa/+e9kIShI9W2BQujKOF
 BXJ5L1WEU1Xxob7jieVTW4g+Zz60o2rMO6HFUA4xfJpueIASIL6j+8AqbC9GZ7lkBHqr
 sJHXr1h4xzNET94Sj7VnB3ko6UUH98VLFRfs8BRIBCdjRZ2mjyOgA3TSmkYSakuvPqbJ
 DxcX1Fm8zJMp4nJO34/r094hoTGod/QqeFgJAgH/kf967VetL7mlrcwwhSWp/YGpaMT+
 tTU3m41zAmUS+BNN4pm6Ajk1+lMU1+wbVorn/mKLvFPPNkTaTG8Nh9uJrS2vRLXvMu8v Ww== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3usk3yh02a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Dec 2023 17:51:53 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B4HgY7B006769;
	Mon, 4 Dec 2023 17:51:53 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3usk3yh01u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Dec 2023 17:51:53 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B4GvbiX017881;
	Mon, 4 Dec 2023 17:51:51 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3urv8axh36-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Dec 2023 17:51:51 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B4Hpo7l21037614
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 Dec 2023 17:51:50 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C554E58059;
	Mon,  4 Dec 2023 17:51:50 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9ED0258053;
	Mon,  4 Dec 2023 17:51:49 +0000 (GMT)
Received: from [9.61.175.104] (unknown [9.61.175.104])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 Dec 2023 17:51:49 +0000 (GMT)
Message-ID: <7c0d0ad2-b814-47b1-80e9-28ad62af6476@linux.ibm.com>
Date: Mon, 4 Dec 2023 12:51:49 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] s390/vfio-ap: handle response code 01 on queue reset
Content-Language: en-US
To: Halil Pasic <pasic@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, alex.williamson@redhat.com,
        borntraeger@linux.ibm.com, kwankhede@nvidia.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
References: <20231129143529.260264-1-akrowiak@linux.ibm.com>
 <20231204131045.217586a3.pasic@linux.ibm.com>
From: Tony Krowiak <akrowiak@linux.ibm.com>
Organization: IBM
In-Reply-To: <20231204131045.217586a3.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Cy6EtFrHIgsctPWmYdNoQTZ9VmSUgmuV
X-Proofpoint-GUID: S_Dh2bv_Z21y3ZzWOZif0m9h88i58wRM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-04_17,2023-12-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 suspectscore=0 mlxscore=0
 adultscore=0 phishscore=0 mlxlogscore=990 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2312040137



On 12/4/23 07:10, Halil Pasic wrote:
> On Wed, 29 Nov 2023 09:35:24 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
>> In the current implementation, response code 01 (AP queue number not valid)
>> is handled as a default case along with other response codes returned from
>> a queue reset operation that are not handled specifically. Barring a bug,
>> response code 01 will occur only when a queue has been externally removed
>> from the host's AP configuration; nn this case, the queue must
>> be reset by the machine in order to avoid leaking crypto data if/when the
>> queue is returned to the host's configuration.
> 
> s/if\/when/at latest before/
> 
> I would argue that some of the cleanups need to happen before even 01 is
> reflected...

To what cleanups are you referring?

> 
> The code comments may also require a similar rewording. With that fixed:
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
> 
> Regards,
> Halil
> 
>> The response code 01 case
>> will be handled specifically by logging a WARN message followed by cleaning
>> up the IRQ resources.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>


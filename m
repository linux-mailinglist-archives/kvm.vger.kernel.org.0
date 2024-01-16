Return-Path: <kvm+bounces-6358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B681882F526
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 20:14:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC4471C239D9
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 19:14:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D870B1D552;
	Tue, 16 Jan 2024 19:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NDiQZGVC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696661D520;
	Tue, 16 Jan 2024 19:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705432463; cv=none; b=JSLjBAURffo5xc3MV+oh2K2wKiLPeG8tuzl3gj0oN9mg48Wxl9kBvgYYcGY4vZKK8HFcVIfh47MQWPzbnCq7CPECY6VDlxpW//eV+4Q1PxgAezXO6+7cLFwLPnKdmqobnelbT6mLt5zElWEqSvGl9HL0Qkgq6t/+802tOZYyIik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705432463; c=relaxed/simple;
	bh=Gk5fOr4dIPtf5iRYPCjl8L1MH8Ozxm5N9FBGAXYdF6s=;
	h=Received:DKIM-Signature:Received:Received:Received:Received:
	 Received:Received:Received:Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details; b=gvhxkYz62Fh14dR+YTyruurcRvdl6qS8vWa+YnvuIIKOT8TJOSZ8kxCHOogXV1MQBREOju/c/Fan0vWE25DbetXpJowz3pG9fDips1FcvdkBC0hF+OmxcwfQDGX8EFz4TXZbHRMKLTPCjSOhpl5Oh7GrQ6tHgd4lyflw4nX7ML0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NDiQZGVC; arc=none smtp.client-ip=148.163.158.5
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40GJE8YM003004;
	Tue, 16 Jan 2024 19:14:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=IdifBVBt/VVz8Kl9dCjHxdLKBd4kg9p5JkNDFDBHN7U=;
 b=NDiQZGVCxy/FdSFclfq2tXWYLnan55UL5HYMf4zd2ucF5WVvELUU/1S/qkk1En2yASTx
 r6Vxlev4GZmK2f5IKEHPrnYME1CIbArmIWJUBGxYRZdjpn54+hhvnlG0CpnB2CVuN7eM
 xUEChDwt9Ks+9tq5xiVLaiZ8bURGQdEHLJFNnkJH3BHZdQk/gYPeN0P57xJ5JgVQYE76
 VCHdTcdxnHVMGHzoiVDlzpUxWNE9BSbvNU3imLSQKDLcds1ytYx7BqonE56I8WWUBHP1
 ezUvBkn8G1auiujLvMJCu62BXmlEzzW8u/IftIX9k+0vggDb4/HlPxfsqv0kbcf9/gi1 ow== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vnwm645ya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 19:14:18 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40GJ7esF003788;
	Tue, 16 Jan 2024 19:14:17 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vnwm645h3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 19:14:16 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40GJ1fuC003699;
	Tue, 16 Jan 2024 19:12:18 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vm4usrt8v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 19:12:18 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40GJCG9N30016166
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jan 2024 19:12:16 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7B2DB58052;
	Tue, 16 Jan 2024 19:12:16 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 78BC358056;
	Tue, 16 Jan 2024 19:12:09 +0000 (GMT)
Received: from [9.61.48.5] (unknown [9.61.48.5])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 Jan 2024 19:12:08 +0000 (GMT)
Message-ID: <a5ccb86a-cc56-4e25-9b7c-e55a54101daf@linux.ibm.com>
Date: Tue, 16 Jan 2024 14:12:06 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/6] s390/vfio-ap: reset queues filtered from the
 guest's AP config
Content-Language: en-US
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, gor@linux.ibm.com, stable@vger.kernel.org
References: <20240115185441.31526-1-akrowiak@linux.ibm.com>
 <20240115185441.31526-5-akrowiak@linux.ibm.com>
 <ZabGAx5BpIiYW+b3@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <ZabGAx5BpIiYW+b3@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yy8cEHpJ0eLe2CpHFepbk5_Y6KFN-aFH
X-Proofpoint-ORIG-GUID: Kxz-GnwL5U2IS-Dv3b9ZmLIrWM6zpQZP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-16_11,2024-01-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 mlxlogscore=957
 impostorscore=0 bulkscore=0 phishscore=0 malwarescore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401160152


On 1/16/24 1:08 PM, Alexander Gordeev wrote:
> On Mon, Jan 15, 2024 at 01:54:34PM -0500, Tony Krowiak wrote:
>> From: Tony Krowiak <akrowiak@linux.ibm.com>
> ...
>> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
>> index 88aff8b81f2f..20eac8b0f0b9 100644
>> --- a/drivers/s390/crypto/vfio_ap_private.h
>> +++ b/drivers/s390/crypto/vfio_ap_private.h
>> @@ -83,10 +83,10 @@ struct ap_matrix {
>>   };
>>   
>>   /**
>> - * struct ap_queue_table - a table of queue objects.
>> - *
>> - * @queues: a hashtable of queues (struct vfio_ap_queue).
>> - */
>> +  * struct ap_queue_table - a table of queue objects.
>> +  *
>> +  * @queues: a hashtable of queues (struct vfio_ap_queue).
>> +  */
>>   struct ap_queue_table {
>>   	DECLARE_HASHTABLE(queues, 8);
>>   };
> If this change is intended?


It makes not sense, not sure why/how it happened. Probably an artifact 
of the many rebases done to get to this version.




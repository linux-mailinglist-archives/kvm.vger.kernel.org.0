Return-Path: <kvm+bounces-6359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 010C382F536
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 20:21:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 98B8BB232FB
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 19:21:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 006B61D52D;
	Tue, 16 Jan 2024 19:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LDO9s2ez"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE201CF9A;
	Tue, 16 Jan 2024 19:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705432901; cv=none; b=d0K5fHeVVhD/mR+6ZnTiyFxv7OPFqwB9duKUmr/082WZGZ4HFAocKm4ykSBzdZHb5FT/yBn1FNYGu8+Q+7R/2qi8iV//jb9mUMqaFxXOGAvGSj+B3KsaEWsrRhd0RnR7f4MLvOZPSrdlRRec/5W3aYfzPK7rqpAknxWZ2RPwRw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705432901; c=relaxed/simple;
	bh=PoFBxJcLe/JHbT29e2YHu2EvynAkiiApc4ZrBwLacjk=;
	h=Received:DKIM-Signature:Received:Received:Received:Received:
	 Received:Received:Received:Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details; b=r1a0LrxA8o1/wK8buuILcCWFqm/y3gyVFMzfh+K9C9abiwJAUjt4aHjEQFCEo7JDEZexQhOqNFPFm61OaypZSmjEZXGfeJd9wQQSYig0ezZMhWopFcmokb/b+GEOkbJTDdhKxqBJNm+T1BHAkD6VhqWox8SGGI7KbChhom9nGaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LDO9s2ez; arc=none smtp.client-ip=148.163.158.5
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40GJIMnG008000;
	Tue, 16 Jan 2024 19:21:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FMJzYPagzaWsJGolp/P4LKDRnXrdsEHWJ1xmmTCugII=;
 b=LDO9s2ezBEq+NQoHBKvKW3MQSfJDn0Nf012tnijx+8vk4xOu42Y0lhNn2/o8HwmC1JZu
 0zYuwq64YGUP/uHVXFibxVK8faijeX9PS3LW5byp5SuCJqFoIFFbvPGpvnGOasJUrkj4
 dkn+hRzzXm1pFup0oeq/E7T65R06bvs3mshw7o1btZ6xSwdHvPHP971scae+fD0/LJfK
 CJVxQ2QtEVkRwjmIPvlty+EcEMIUxJFMAOSTACZJzyLosq1W/oGIKlAzJdsQ/Wf8U2rc
 4/LMT7gwr/FAEsU8RUeqXTWUTB6VM/Jv6szYWHZSQIwx8OW+E37ANpqdr/3qkiczYGr0 oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vnyu6838f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 19:21:36 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40GJKsoP021383;
	Tue, 16 Jan 2024 19:21:36 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vnyu68381-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 19:21:36 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40GJ1fxE003699;
	Tue, 16 Jan 2024 19:21:35 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vm4usruph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 19:21:35 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40GJLYT446007008
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jan 2024 19:21:34 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4325A58056;
	Tue, 16 Jan 2024 19:21:34 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F1EA058052;
	Tue, 16 Jan 2024 19:21:25 +0000 (GMT)
Received: from [9.61.48.5] (unknown [9.61.48.5])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 Jan 2024 19:21:25 +0000 (GMT)
Message-ID: <a54e223c-8965-480c-9361-b483b47502d0@linux.ibm.com>
Date: Tue, 16 Jan 2024 14:21:23 -0500
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
X-Proofpoint-ORIG-GUID: 8ItaOwwyKNC5PRVryJzWlzFzkQbbqepu
X-Proofpoint-GUID: C9KafgIl72Igcbk6C9cg4_kLLsaLnEFi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-16_11,2024-01-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 malwarescore=0 mlxscore=0 priorityscore=1501 spamscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401160152


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


Shall I fix this and submit a v5?





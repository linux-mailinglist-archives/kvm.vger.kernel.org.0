Return-Path: <kvm+bounces-6392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5941B83079E
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 15:09:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0B9F21F231F3
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 14:09:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ADFD20339;
	Wed, 17 Jan 2024 14:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SiTy1NAv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48AC200DD;
	Wed, 17 Jan 2024 14:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705500547; cv=none; b=qslnB56m5IeDSglrlWmaNxLbMQnalAqA5A3hnWGnx8vIcGO77GTTix3w3lNJSo+xLTBjj3kVBX/c7kNrIKA98moqzfJOE6RNYLUQdnolTx44Dbj8qQVBzRDSAObzeKwynXGhOV4E3c1ViHvttzFBsXrwYQb8C1eZ1chKOjDG34U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705500547; c=relaxed/simple;
	bh=NSBHDc6VuWG7H3muQ0gHvk58qFiPJw0f+YiQy5rDces=;
	h=Received:DKIM-Signature:Received:Received:Received:Received:
	 Received:Received:Received:Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details; b=EuRqezcMItb5TqQoqtz1QhLkShtsDJjpCTDxUhSjTRxVq6+WZSL9WoMVZ/T8WYHkt8dnnzuXOiV8KFjnQoDiyZWsRJpLM1btj0NaXXAAgEbWkqHbRowdG/WMjnCw1kwmE9z7unz9w9mQ+j/kXcVFTWMiQquWXpnox/cF8KGlg58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SiTy1NAv; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40HE7C6F019145;
	Wed, 17 Jan 2024 14:09:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=NSBHDc6VuWG7H3muQ0gHvk58qFiPJw0f+YiQy5rDces=;
 b=SiTy1NAvP0XtXuHEFwKNnxk0jr/GF+uj2N6gU8nxt3l/LO8NCMC8kUGXLl6WA4C1GDNb
 WUdbmK/1dOsfRK0bB4aaciKIV1U7zCmXXqnaZCzzsNrcHTZyAR6Af4xEldFJlMeSeI6D
 ZUSjP1KTG52yDi6pSFYJtpv2gyK+RtriVDCoMxUhps9p6paLZDKQIpiSh0PADBRvu9jj
 5pi2OyBszeAdT8LJFYMNCjNYYHZIGaf/dCoCNtamYH/MVVrkBkp0tpiuaTKIljuttQ7l
 gXHz3sqNhgC97U/PCl63e9gaaD4rRuVABPHxKCMo2okoPKPk8nbcgcMsApQrdJ/0XNTh VQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vpgcj023d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Jan 2024 14:09:01 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40HE7He2019585;
	Wed, 17 Jan 2024 14:09:00 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vpgcj022w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Jan 2024 14:09:00 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40HBTwhv005414;
	Wed, 17 Jan 2024 14:08:59 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vm7j1w73r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Jan 2024 14:08:59 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40HE8whp20251322
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jan 2024 14:08:58 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6DBFB58052;
	Wed, 17 Jan 2024 14:08:58 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 79C575805E;
	Wed, 17 Jan 2024 14:08:57 +0000 (GMT)
Received: from [9.61.48.5] (unknown [9.61.48.5])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 17 Jan 2024 14:08:57 +0000 (GMT)
Message-ID: <1cf296ae-fdbc-45ef-b7b7-9f2bc7eb6524@linux.ibm.com>
Date: Wed, 17 Jan 2024 09:08:57 -0500
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
 <a54e223c-8965-480c-9361-b483b47502d0@linux.ibm.com>
 <ZabaK3DxABHiGh8V@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <ZabaK3DxABHiGh8V@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WLTHyoUWpsIMD1zg3McK2gdvvG7GuIQ-
X-Proofpoint-GUID: 8J0k8-NKt3UGBsobbporIgABl6fjtDPB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-17_08,2024-01-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 phishscore=0 impostorscore=0 mlxlogscore=714 adultscore=0
 mlxscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401170101


On 1/16/24 2:34 PM, Alexander Gordeev wrote:
> On Tue, Jan 16, 2024 at 02:21:23PM -0500, Anthony Krowiak wrote:
>>> If this change is intended?
>> Shall I fix this and submit a v5?
> No, I will handle it.


Thanks Alex.




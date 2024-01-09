Return-Path: <kvm+bounces-5900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BF4E828A2C
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 17:41:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D86C1C23780
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 16:41:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7E193A8C4;
	Tue,  9 Jan 2024 16:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GO3ICfKv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD643A26E;
	Tue,  9 Jan 2024 16:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 409GbbS0020661;
	Tue, 9 Jan 2024 16:41:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rdy7cRVvDz1ivprbP/Jb3r7TRUspqYk3N6p4pQ6+aSg=;
 b=GO3ICfKv9N9aAtOuM6b0gI0895ZJm4XW/JIOjrPnEoEs4gFYni3OwiAdCSEMoSdwM5uJ
 JgzDeb8PvrwjpE4tzY784+bEAEE2O+q056ilDI6nNU7j3mYKx6jNOZNkT8bP+Nln1KGU
 EqOGWjou4ZK/we/Sm7+Oe0U9rhDsx5d4/Mg5ns+RHrGW72af3vf5Me1g+eQPKZDWsY1a
 XCSuTtpWhI+tntHCtpf+wMqZ2B7OR4RvgSyBDZOOgbvf6CZvyqYux6ew2Pt9JWwL5DB7
 4gbUeg/Lh9em6f7msNAsQl8WdRyJa76ffzPxQJIH3zhK5v9UjZ3dRn/HjuZ6P9QkkYqa Xg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vh9tt04bm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jan 2024 16:41:25 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 409GdnWE029564;
	Tue, 9 Jan 2024 16:41:24 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vh9tt043v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jan 2024 16:41:24 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 409Fsu9E028027;
	Tue, 9 Jan 2024 16:41:06 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vgwfsks99-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jan 2024 16:41:06 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 409Gf5wB27132596
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Jan 2024 16:41:05 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0372658053;
	Tue,  9 Jan 2024 16:41:05 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D82485805D;
	Tue,  9 Jan 2024 16:41:03 +0000 (GMT)
Received: from [9.61.76.57] (unknown [9.61.76.57])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Jan 2024 16:41:03 +0000 (GMT)
Message-ID: <bc5d11db-fb7a-4975-8896-d1cf271a8f95@linux.ibm.com>
Date: Tue, 9 Jan 2024 11:41:03 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/6] s390/vfio-ap: reset queues removed from guest's AP
 configuration
To: Janosch Frank <frankja@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        pbonzini@redhat.com, imbrenda@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
References: <20231212212522.307893-1-akrowiak@linux.ibm.com>
 <11ac008c-9bea-4b34-bc4b-e0d7e7ed9bef@linux.ibm.com>
 <d5c3d69e-3405-4cf2-a2e7-0dad7d941e0c@linux.ibm.com>
Content-Language: en-US
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <d5c3d69e-3405-4cf2-a2e7-0dad7d941e0c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gjl9uLGpBX2_lzvNfSlBZCnF4fWKIFNm
X-Proofpoint-GUID: YBIf8ZPezp6etBNrnQaKK32bBIIS1DOX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-09_08,2024-01-09_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 adultscore=0 phishscore=0 mlxlogscore=756 clxscore=1015 bulkscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401090136


On 1/9/24 3:27 AM, Janosch Frank wrote:
> On 1/8/24 17:52, Anthony Krowiak wrote:
>> PING!
>>
> You're waiting for review of the last patch, right?


Patch 6/6 does not have an r-b, so yes, that is one thing. The other's 
have been reviewed internally with some receiving only an acked-by, so I 
guess I'm looking for a final blessing so they can be merged. If I'm not 
mistaken, the primary problem for which theses patches were created - 
i.e., not resetting all queues when an adapter is removed from the guest 
- will cause unique problems for SE guests that are bound/associated. 
That being the case, I think these patches need to be merged sooner 
rather than later.




Return-Path: <kvm+bounces-6339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5247D82F0E7
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 15:58:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DFD9F1F24193
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 14:58:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5472D1C298;
	Tue, 16 Jan 2024 14:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HCMu2aZX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F200F1BF30;
	Tue, 16 Jan 2024 14:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40GE2I3A022697;
	Tue, 16 Jan 2024 14:57:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WJKvXg2gsScM+vxfqV0R+Mz7P3AscR3fNfey/AiNOto=;
 b=HCMu2aZXY6FWzwuPfp3wgEklM8dYN9AJVIsWBEQafqCrnkE25LQpNlOQhhUi6YtKk3aB
 8udFLeZlhtITKx5IlBaX1rhFsP8Z5oW3e0O+uf7zQCllAlQ0yErcH8W9mkws2ZixA5+Z
 ugCDl5gEe5OeXrOdbxKY092kyFzy8OgVIQ+Oetg3jQef12zEsyOTkeN1xBZOoFo9sW6F
 lq8iza4E5ujwHM0kI0G7IItSrZFtYKQBr9REkPc5e2vq1ycyX+vpat6EQ104MHO36jR5
 fkZYRgHc5So6VKaq8RTAb0H2CTFXLvvNyeO+Z9+vhFcCkjpbzciqprTlGH78A6Rj91+q Fw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vnu74hrpg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 14:57:30 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40GEQjqP022581;
	Tue, 16 Jan 2024 14:57:29 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vnu74hrnu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 14:57:29 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40GDUNuF008844;
	Tue, 16 Jan 2024 14:57:28 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vm5unf6tg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 14:57:28 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40GEvRFh26083942
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jan 2024 14:57:27 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 364D858054;
	Tue, 16 Jan 2024 14:57:27 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BE8795805D;
	Tue, 16 Jan 2024 14:57:25 +0000 (GMT)
Received: from [9.61.152.128] (unknown [9.61.152.128])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 Jan 2024 14:57:25 +0000 (GMT)
Message-ID: <4eb35fab-eb85-487d-90cd-c4b10b8410ec@linux.ibm.com>
Date: Tue, 16 Jan 2024 09:57:25 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/6] s390/vfio-ap: let 'on_scan_complete' callback
 filter matrix and update guest's APCB
Content-Language: en-US
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, gor@linux.ibm.com
References: <20240115185441.31526-1-akrowiak@linux.ibm.com>
 <20240115185441.31526-4-akrowiak@linux.ibm.com>
 <ZaY/fGxUMx2z4OQH@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
From: Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <ZaY/fGxUMx2z4OQH@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 6PToCPfSVZ-aTqeM4cxAEX_OeS0ZJuWD
X-Proofpoint-GUID: -0rsVH5sPg1Hvajp9OKvlUfeAyVs3dwI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-16_08,2024-01-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=878 spamscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401160117


On 1/16/24 3:34 AM, Alexander Gordeev wrote:
> On Mon, Jan 15, 2024 at 01:54:33PM -0500, Tony Krowiak wrote:
> Hi Tony,
>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
> No Fixes tag for this patch?


This patch is more of an enhancement as opposed to a bug, so no Fixes.


>
> Thanks!
>


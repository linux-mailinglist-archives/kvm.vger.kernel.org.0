Return-Path: <kvm+bounces-5893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0A61828899
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 15:59:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 63D1AB23398
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 14:59:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C136039AEB;
	Tue,  9 Jan 2024 14:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SQB2clK0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A6039FC6;
	Tue,  9 Jan 2024 14:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 409ECQL1012079;
	Tue, 9 Jan 2024 14:59:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : subject : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=i4aHDK9WhIWp4MS31BTdOBZKdybseEmGYz9J/V4GiAQ=;
 b=SQB2clK0PEvAT6E3rnyGrMU3LuvpF06X70fanW9+P2CoM6x7YFciytYRKLQXQ+T6luDq
 dyD7Qup3uhpkahZA5lozSuyp/LDV2M6YWkGmJLY/uTk00xwfxdgbQeJ+4LSwXY1hBSVI
 N3v6PoJRJ1w0dYqOmz6XoOK5hAAW80w8qSAmjZdgjdmpCTaIQR3b6CABE4QSLPAQqayn
 wvzJIjFiZIzUhUiksEW51YA2R7WMMYC2X+uybJLd619i1a7tdvJ9WqnRG68NN7IVxaeH
 wUB0cgZZGiPyJcVvk2YCttEudOkdwDKT2pz+90INxVLOMIYe5QFanv0h+nycxD4NDgg1 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vh7pvhajc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jan 2024 14:59:39 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 409Ek8XI013112;
	Tue, 9 Jan 2024 14:59:38 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vh7pvhah6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jan 2024 14:59:38 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 409DKTxb022819;
	Tue, 9 Jan 2024 14:59:36 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vfhjyfcs3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jan 2024 14:59:36 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 409ExaB618547262
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Jan 2024 14:59:36 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 197885805F;
	Tue,  9 Jan 2024 14:59:36 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 931F858045;
	Tue,  9 Jan 2024 14:59:34 +0000 (GMT)
Received: from [9.171.17.65] (unknown [9.171.17.65])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Jan 2024 14:59:34 +0000 (GMT)
Message-ID: <af124c42-946d-46c8-b01f-d0bc9fb99d91@linux.ibm.com>
Date: Tue, 9 Jan 2024 15:59:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: mhartmay@linux.ibm.com
Cc: frankja@linux.ibm.com, imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, nrb@linux.ibm.com, thuth@redhat.com
References: <20231121172338.146006-1-mhartmay@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1] s390x/Makefile: simplify Secure
 Execution boot image generation
Content-Language: en-US
From: Steffen Eiden <seiden@linux.ibm.com>
In-Reply-To: <20231121172338.146006-1-mhartmay@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WlZ9EHDQKm3XfFUazR8E8gjJxrt2v6bo
X-Proofpoint-ORIG-GUID: yX2ou3xCwjLGQQeYzfyQiw3ozhusS3_y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-09_07,2024-01-09_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 impostorscore=0 mlxscore=0 adultscore=0 priorityscore=1501 clxscore=1011
 suspectscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401090123

LGTM.



> Changes:
> + merge Makefile rules for the generation of the Secure Execution boot
>   image
> + fix `parmfile` dependency for the `selftest.pv.bin` target
> + rename `genprotimg_pcf` to `GENPROTIMG_PCF` to match the coding style
>   in the file
> + always provide a customer communication key - not only for the
>   confidential dump case. Makes the code little easier and doesn't hurt.
> 
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>

Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>


> ---
>  s390x/Makefile | 40 +++++++++++++++++-----------------------
>  1 file changed, 17 insertions(+), 23 deletions(-)

[...]


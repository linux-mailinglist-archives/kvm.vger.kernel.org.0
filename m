Return-Path: <kvm+bounces-502-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 760E37E0499
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 15:22:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6225AB2147E
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 14:22:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 088891A29A;
	Fri,  3 Nov 2023 14:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iWif6+kv"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FDE19BD9
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 14:21:59 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D562D48
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 07:21:58 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3EBBKG032183
	for <kvm@vger.kernel.org>; Fri, 3 Nov 2023 14:21:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Dcj8D2RpClPH+9po9tmeochETX+6eQnLtPe495FshjE=;
 b=iWif6+kvXF5YL36akpl4UO1Bws0EXAeiY/2vM6SfQZenSHPd56YoFQX06w7zfbFGbLjp
 gtgyFk2jM5VU9Lsv/GIuGCCqpVA1SZDqOm0Y0mxeDQrJxp9ETCNoiA410k7h1FDHRcYL
 iyHScn9obzgZKQFYfJeb8cQD4nlU3CTC61KK8sCCeaJCEqEMKfFqpMLJgpWPSZUhobmZ
 5CB9OIFm0HD+I6i8SyyZ4qDQs/2cnc++q3pe7hP+ivyL4H5MlQzIAF4dOCNTGJ1/56yv
 E2cfmm8+QR5F/pGwTOvYNrqQTWWfPSqlMp+pvXLTEPS4P0TLcuS1xw/P1pX9naLoyT2g sQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u52700tee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 14:21:57 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A3EBcUr004130
	for <kvm@vger.kernel.org>; Fri, 3 Nov 2023 14:21:54 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u52700t5q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 14:21:54 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3CXcZS011588;
	Fri, 3 Nov 2023 14:21:29 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u1e4meb7g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 14:21:29 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A3ELOwG44696010
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Nov 2023 14:21:24 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 716E02004B;
	Fri,  3 Nov 2023 14:21:24 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 48C5D20043;
	Fri,  3 Nov 2023 14:21:24 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 Nov 2023 14:21:24 +0000 (GMT)
Date: Fri, 3 Nov 2023 15:21:22 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, nrb@linux.ibm.com, nsg@linux.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
Subject: Re: [PATCH v2 1/1] KVM: s390: vsie: fix wrong VIR 37 when MSO is
 used
Message-ID: <20231103152122.4d0d01cf@p-imbrenda>
In-Reply-To: <87e310d4-bf9b-41c4-a284-193c1a50bf88@redhat.com>
References: <20231102153549.53984-1-imbrenda@linux.ibm.com>
	<87e310d4-bf9b-41c4-a284-193c1a50bf88@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZsV3jYYLOBx2g3n-DQ7rZM9lV11FGUEe
X-Proofpoint-ORIG-GUID: 0WDhY_2aI6SRO-6EAe9DHI1Fed40A9tM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_13,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 suspectscore=0 mlxlogscore=611 spamscore=0 lowpriorityscore=0
 clxscore=1015 mlxscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311030121

On Thu, 2 Nov 2023 21:38:43 +0100
David Hildenbrand <david@redhat.com> wrote:

[...]

> >   	/*
> >   	 * Only new shadow blocks are added to the list during runtime,
> >   	 * therefore we can safely reference them all the time.  
> 
> Right, mso is 64bit, the prefix is 18bit (shifted by 13) -> 31bit.
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>

thanks

> 
> Does it make sense to remember the maximum prefix address across all 
> shadows (or if the mso was ever 0), so we can optimize for the mso == 0 
> case and not have to go through all vsie pages on all notification? 
> Sounds like a reasonable optimization on top.
 
yes, but it adds complexity to already complex code


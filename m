Return-Path: <kvm+bounces-1346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C3B0A7E6B0A
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 14:12:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9765B1C20A03
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 13:12:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BA011DDC5;
	Thu,  9 Nov 2023 13:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tqTf21IS"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954941DA43
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 13:11:55 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5A81FEB;
	Thu,  9 Nov 2023 05:11:54 -0800 (PST)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A9DBBOP010759;
	Thu, 9 Nov 2023 13:11:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8G0FDVfBrCxKOxsk8y+IddWYDC94RL4fGkRSMZeh3WM=;
 b=tqTf21ISCNcldh/pEP3qu8kjI//Sn3eP49Ib4LeBQltts2xYJT6DHo8IXR9WrMK/t+Kr
 Prdnnobmuc93Z1W1dDDFaSC/ZZfMh7WMH8WtWYK5LSXD/lpvpuCb+Tfm0zH8tuZdvEPX
 A8CRoy3ypvYFm9olDiRmZii+bly6NkmxI9e2KdPJXWCYAm4FeFHnlU1/nROe4TvAfttE
 XFStR5a7BO4mKYL5hx8+UlwWM+0QlOd7/DWpPIcHxJYuD/Jsx+fZeEqcCiM/66pDL7pm
 r9Ue2zg4FcXjGzejkWPL5A8pNKjf2skrExODOipcQuh0HZ3tGejXNT39p8n4oNPPLrky gw== 
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u8ykeh1j6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Nov 2023 13:11:54 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A9B12CJ028310;
	Thu, 9 Nov 2023 13:11:53 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u7w22kvxp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Nov 2023 13:11:53 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A9DBolJ28181240
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Nov 2023 13:11:50 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EB5D22004B;
	Thu,  9 Nov 2023 13:11:49 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AC7C720049;
	Thu,  9 Nov 2023 13:11:49 +0000 (GMT)
Received: from [9.152.224.228] (unknown [9.152.224.228])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Nov 2023 13:11:49 +0000 (GMT)
Message-ID: <c64f27ac-3367-c58c-d8d5-075e7bf6b7f8@de.ibm.com>
Date: Thu, 9 Nov 2023 14:11:48 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v1 1/1] KVM: s390/mm: Properly reset no-dat
Content-Language: en-US
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>
References: <20231109123624.37314-1-imbrenda@linux.ibm.com>
From: Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20231109123624.37314-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UrG5xTsnPoYJzUOA-xWRw1aNA0J6OCA7
X-Proofpoint-GUID: UrG5xTsnPoYJzUOA-xWRw1aNA0J6OCA7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-09_10,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 malwarescore=0 impostorscore=0 mlxlogscore=686 lowpriorityscore=0
 clxscore=1011 adultscore=0 phishscore=0 priorityscore=1501 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311090099

Am 09.11.23 um 13:36 schrieb Claudio Imbrenda:
> When the CMMA state needs to be reset, the no-dat bit also needs to be
> reset. Failure to do so could cause issues in the guest, since the
> guest expects the bit to be cleared after a reset.

This happens during reset of a guest (or whenever QEMU calls the CLR_CMMA thingi).
I think after reset a normal Linux guest has no DAT tables and very likely
a cpu reset (with explicit full guest flush) will happen. It will very likely
also set the CMMA state during boot before setting up its DAT tables.
So for the normal reboot this should be ok. But I can imagine cases that would
not be ok. So maybe add cc stable?


Return-Path: <kvm+bounces-1179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C98597E5547
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:24:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 89CFF1F21FE3
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:24:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31A2F17987;
	Wed,  8 Nov 2023 11:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fXFFj9Ev"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE271774C
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 11:23:49 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0FF2599;
	Wed,  8 Nov 2023 03:23:47 -0800 (PST)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8BIXjd005362;
	Wed, 8 Nov 2023 11:23:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=jtWIZGyRTnMfkGH9XQM+li0IZT1L/GHYJT26KII8tH4=;
 b=fXFFj9EvWZDQA6eYDjwMrkByFIwPeB5P/zqke8Fkr5DFqGGOe9G3L4XQqf9KoaZveO+R
 F7/Vonbu8Xff82wxMCFSHtpYW4eMPGrU9WQ7z3t9jEuWqgfAc6tR3l235cCGIH2WwWOe
 uZzXISBJ1tABFZZSGcafFZt6u9EvTMZ8tfpRf9YRuZs1WOo3RUR4KcittkRHynqEVx0N
 24QaZEIBj0aWeirW1zmjFCfdCMav926ed/WTJVqvHhpo4yBsH3GuIOyW/ocP8X4Vq4SD
 aye+2niyWcjqmvoRkLA7dRuXwsNGaqaCRqaI6X6mUu6JNsAHoXnesVCSaUc98Rr5FsLm KA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u88uqt903-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 11:23:46 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A8BJBFH011564;
	Wed, 8 Nov 2023 11:23:46 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u88uqt8xg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 11:23:46 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8BHcaY014372;
	Wed, 8 Nov 2023 11:23:44 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u7w21vam1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 11:23:43 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A8BNeuR19202686
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Nov 2023 11:23:40 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2812320040;
	Wed,  8 Nov 2023 11:23:40 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DC47220043;
	Wed,  8 Nov 2023 11:23:39 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Nov 2023 11:23:39 +0000 (GMT)
Date: Wed, 8 Nov 2023 12:23:38 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sven Schnelle
 <svens@linux.ibm.com>
Subject: Re: [PATCH v2 2/4] KVM: s390: vsie: Fix length of facility list
 shadowed
Message-ID: <20231108122338.0ff2052e@p-imbrenda>
In-Reply-To: <20231107123118.778364-3-nsg@linux.ibm.com>
References: <20231107123118.778364-1-nsg@linux.ibm.com>
	<20231107123118.778364-3-nsg@linux.ibm.com>
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
X-Proofpoint-GUID: GxDAHOQa6n4JoM46DkxvLLCBTAf_3boB
X-Proofpoint-ORIG-GUID: 1YW4mzqluCbKw_l2-51fxetIjt6yvfcd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-08_01,2023-11-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=727 clxscore=1015 adultscore=0 mlxscore=0
 spamscore=0 suspectscore=0 bulkscore=0 phishscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311080095

On Tue,  7 Nov 2023 13:31:16 +0100
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

[...]

> diff --git a/arch/s390/kernel/facility.c b/arch/s390/kernel/facility.c
> new file mode 100644
> index 000000000000..5e80a4f65363
> --- /dev/null
> +++ b/arch/s390/kernel/facility.c
> @@ -0,0 +1,21 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright IBM Corp. 2023
> + */
> +
> +#include <asm/facility.h>
> +
> +unsigned int stfle_size(void)
> +{
> +	static unsigned int size;
> +	u64 dummy;
> +	unsigned int r;

reverse Christmas tree please :)


with that fixed:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

[...]


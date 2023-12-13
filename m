Return-Path: <kvm+bounces-4364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D018D811A48
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 18:01:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 736221F20F16
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 17:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 191A21D52D;
	Wed, 13 Dec 2023 17:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EYqqx5PC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034BB9C;
	Wed, 13 Dec 2023 09:00:48 -0800 (PST)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDFq1k5011715;
	Wed, 13 Dec 2023 17:00:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=epOCWH5lZoZ92960I3gEGWTRDTDPb2x1zOvXkfaxr4o=;
 b=EYqqx5PCOQtCRNsNAncPBBcKtrDhE23dv7eqTTKvxjnc1d0JHuYx7xYc835X4wtL/+Nw
 0EIU6PH7aJ/4AVyOVMP5SyxwX9L/D6Zvk47du+d/Nl+4rTEDWYVL9SV7i8OKpKdVjA6+
 O7rGRqb/M37bO/MDITsBhs2dQbmqbiZHEiQkoelTsceW39fF837zRkraLbKvhsIjmzfM
 R5sweuLpvUFrMPod8SCS7Ht3qKAbqHtruWKbS9uES2aNJaX55R6ltcyi4VZt+LiQSCgf
 qoWBfyOO30ksEO26gFDSFzkOSY7PcAbutgNWG30APbXZsC2+wdRLs3YHRR04LcoYSdM8 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uyfmmhtq9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 17:00:44 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BDGIIlr008271;
	Wed, 13 Dec 2023 17:00:44 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uyfmmhtpk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 17:00:44 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BDGMK2e008462;
	Wed, 13 Dec 2023 17:00:43 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uw2jtjhud-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Dec 2023 17:00:43 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BDH0eVM9765590
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Dec 2023 17:00:40 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7EA052004D;
	Wed, 13 Dec 2023 17:00:40 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4EA9B20040;
	Wed, 13 Dec 2023 17:00:40 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Dec 2023 17:00:40 +0000 (GMT)
Date: Wed, 13 Dec 2023 17:42:35 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>,
        Nico =?UTF-8?B?QsO2aHI=?=
 <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        Andrew Jones
 <andrew.jones@linux.dev>, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand
 <david@redhat.com>, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 2/5] s390x: lib: Remove double include
Message-ID: <20231213174235.0b43cd81@p-imbrenda>
In-Reply-To: <20231213124942.604109-3-nsg@linux.ibm.com>
References: <20231213124942.604109-1-nsg@linux.ibm.com>
	<20231213124942.604109-3-nsg@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: OHoivyOZIf1ZF3ZFJQqCm-WjQ_WTfhIg
X-Proofpoint-ORIG-GUID: -0S6iouV62uc5JdhURyQGcIjByfFqnFI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-13_10,2023-12-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 malwarescore=0 clxscore=1015 mlxscore=0 mlxlogscore=925 adultscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312130121

On Wed, 13 Dec 2023 13:49:39 +0100
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> libcflat.h was included twice.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/sie.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> index 28fbf146..40936bd2 100644
> --- a/lib/s390x/sie.c
> +++ b/lib/s390x/sie.c
> @@ -14,7 +14,6 @@
>  #include <sie.h>
>  #include <asm/page.h>
>  #include <asm/interrupt.h>
> -#include <libcflat.h>
>  #include <alloc_page.h>
>  #include <vmalloc.h>
>  #include <sclp.h>



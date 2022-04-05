Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AADD4F3ADE
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 17:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242573AbiDELtg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 07:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380292AbiDELm0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 07:42:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51EF5108575;
        Tue,  5 Apr 2022 04:06:05 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2358eDF5029313;
        Tue, 5 Apr 2022 11:06:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=gJnEgKcMkt+xC+BHjh3AOKgkM24fVPOOrWs5m5hI0PY=;
 b=nDT/KRPWPUCiuoszz2TIm1EUbzyNK7Jym9vSkmG71bzHWsgikCKDUA359tDILOjZxyfY
 yw7zwn+Kf+WgYPpExvCQmDVKj27DHUM9piJYMzFWbqYIETQTEgem8gMledLwtKFCQrwb
 m2DRCq+ziCD6/T6Ga9PnBfuEBmiNiu5D4B79oMSw0i7HDoMhTM+mPMyb0SwRlQIishMw
 SeJ5gjlhrHyix+qix2bKt51kp0UIPIhlZEZEPMsRy8Rkc8nAlQcl6nDqmSqYGFBlYq+Q
 S3tBSvZxrQdyEZMXQ/7zbND9S98MVZn3VpxnFHyYNsqmVB6DBtS1ECOnAiI/MtKmeWZO Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f8cuhrghb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 11:06:04 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 235B0Qvk022045;
        Tue, 5 Apr 2022 11:06:04 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f8cuhrggm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 11:06:04 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 235B30Uj009574;
        Tue, 5 Apr 2022 11:06:02 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3f6e48wjnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 11:06:01 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 235B5wLo44958106
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Apr 2022 11:05:58 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA5D8A405C;
        Tue,  5 Apr 2022 11:05:58 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45ED3A405F;
        Tue,  5 Apr 2022 11:05:58 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.14.146])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Apr 2022 11:05:58 +0000 (GMT)
Date:   Tue, 5 Apr 2022 13:04:02 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, nrb@linux.ibm.com, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 4/8] s390x: snippets: asm: Add license
 and copyright headers
Message-ID: <20220405130402.06218b3b@p-imbrenda>
In-Reply-To: <20220405075225.15903-5-frankja@linux.ibm.com>
References: <20220405075225.15903-1-frankja@linux.ibm.com>
        <20220405075225.15903-5-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0-gpXTsjuUTYAGlLQ36I-uI0Tbt9ULRx
X-Proofpoint-ORIG-GUID: dczyzcRo4r9y50Bvp7SQeQ3kxKAxYQmu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-05_02,2022-04-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=999 bulkscore=0
 clxscore=1015 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204050066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  5 Apr 2022 07:52:21 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Time for some cleanup of the snippets to make them look like any other
> test file.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/snippets/asm/snippet-pv-diag-288.S   | 9 +++++++++
>  s390x/snippets/asm/snippet-pv-diag-500.S   | 9 +++++++++
>  s390x/snippets/asm/snippet-pv-diag-yield.S | 9 +++++++++
>  3 files changed, 27 insertions(+)
> 
> diff --git a/s390x/snippets/asm/snippet-pv-diag-288.S b/s390x/snippets/asm/snippet-pv-diag-288.S
> index e3e63121..aaee3cd1 100644
> --- a/s390x/snippets/asm/snippet-pv-diag-288.S
> +++ b/s390x/snippets/asm/snippet-pv-diag-288.S
> @@ -1,3 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Diagnose 0x288 snippet used for PV interception testing.
> + *
> + * Copyright (c) 2021 IBM Corp
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + */
>  #include <asm/asm-offsets.h>
>  .section .text
>  
> diff --git a/s390x/snippets/asm/snippet-pv-diag-500.S b/s390x/snippets/asm/snippet-pv-diag-500.S
> index 50c06779..8dd66bd9 100644
> --- a/s390x/snippets/asm/snippet-pv-diag-500.S
> +++ b/s390x/snippets/asm/snippet-pv-diag-500.S
> @@ -1,3 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Diagnose 0x500 snippet used for PV interception tests
> + *
> + * Copyright (c) 2021 IBM Corp
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + */
>  #include <asm/asm-offsets.h>
>  .section .text
>  
> diff --git a/s390x/snippets/asm/snippet-pv-diag-yield.S b/s390x/snippets/asm/snippet-pv-diag-yield.S
> index 5795cf0f..78a5b07a 100644
> --- a/s390x/snippets/asm/snippet-pv-diag-yield.S
> +++ b/s390x/snippets/asm/snippet-pv-diag-yield.S
> @@ -1,3 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Diagnose 0x44 and 0x9c snippet used for PV interception tests
> + *
> + * Copyright (c) 2021 IBM Corp
> + *
> + * Authors:
> + *  Janosch Frank <frankja@linux.ibm.com>
> + */
>  .section .text
>  
>  xgr	%r0, %r0


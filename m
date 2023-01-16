Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2B1866CEED
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 19:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbjAPSgw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 13:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234278AbjAPSgU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 13:36:20 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3607E2F7A9
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 10:25:33 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30GHda5q025765
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 18:25:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=uoIZF2dAZg10k07k12+Rf9w/f2wRyZbc1srbA/6xlXw=;
 b=VdXoa6ENqtMOK97m4G9Vzj5gYKPGQhwXq3dFgMXIHY1iAcy93mrcPvxcmIJJWf4P1n4c
 OxviKy/qxFXSMmh3MktNFlftO87KBnQPDwDwRfof52xvwJf9/p7AJ8XJb4LWbUDSKAZl
 BO8ca4mmuuVnSQF7EDjMuhsYn27Qd+8gDQSWvsVSgB/8eSFkwGlRwV9thF3/DHwtRZpR
 MMoasKFCPj6wzv8q2bF7BdOMKOm2t+cVePRSHJxML7+RVwqMqLRB6yYlz9arituT06jJ
 0zB+UVMyk/5KXLkanW2nGkEzUbr2JIjYG9n32TQ0kkskhtqdIrqOAUn09J7KTlqGGao2 zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n58x1v5du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 18:25:32 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30GIPVcM018518
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 18:25:31 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n58x1v5d5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 18:25:31 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30GFV9HD004659;
        Mon, 16 Jan 2023 18:25:30 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3n3m16js9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 18:25:29 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30GIPQ6L46662064
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 18:25:26 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6422120049;
        Mon, 16 Jan 2023 18:25:26 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2480520040;
        Mon, 16 Jan 2023 18:25:26 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 18:25:26 +0000 (GMT)
Date:   Mon, 16 Jan 2023 19:23:45 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 8/9] s390x: use STACK_FRAME_SIZE macro in
 linker scripts
Message-ID: <20230116192345.7478e566@p-imbrenda>
In-Reply-To: <20230116175757.71059-9-mhartmay@linux.ibm.com>
References: <20230116175757.71059-1-mhartmay@linux.ibm.com>
        <20230116175757.71059-9-mhartmay@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wmfvJT-w21_euKbcxnLBDkOqGUbBqvYN
X-Proofpoint-ORIG-GUID: 9NW8iFRKnv67b8CMDvSWEt22b96tNcVa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_15,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301160135
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Jan 2023 18:57:56 +0100
Marc Hartmayer <mhartmay@linux.ibm.com> wrote:

> Use the `STACK_FRAME_SIZE` macro instead of a hard-coded value of 160.
> 
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>

merge patch 6 into this one

> ---
>  s390x/flat.lds.S            | 4 +++-
>  s390x/snippets/c/flat.lds.S | 6 ++++--
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/s390x/flat.lds.S b/s390x/flat.lds.S
> index 952f6cd457ed..0cb7e383cc76 100644
> --- a/s390x/flat.lds.S
> +++ b/s390x/flat.lds.S
> @@ -1,3 +1,5 @@
> +#include <asm/asm-offsets.h>
> +
>  SECTIONS
>  {
>  	.lowcore : {
> @@ -44,6 +46,6 @@ SECTIONS
>  	/*
>  	 * stackptr set with initial stack frame preallocated
>  	 */
> -	stackptr = . - 160;
> +	stackptr = . - STACK_FRAME_SIZE;
>  	stacktop = .;
>  }
> diff --git a/s390x/snippets/c/flat.lds.S b/s390x/snippets/c/flat.lds.S
> index 9e5eb66bec23..468b5f1eebe8 100644
> --- a/s390x/snippets/c/flat.lds.S
> +++ b/s390x/snippets/c/flat.lds.S
> @@ -1,3 +1,5 @@
> +#include <asm/asm-offsets.h>
> +
>  SECTIONS
>  {
>  	.lowcore : {
> @@ -18,9 +20,9 @@ SECTIONS
>  	. = 0x4000;
>  	/*
>  	 * The stack grows down from 0x4000 to 0x2000, we pre-allocoate
> -	 * a frame via the -160.
> +	 * a frame via the -STACK_FRAME_SIZE.
>  	 */
> -	stackptr = . - 160;
> +	stackptr = . - STACK_FRAME_SIZE;
>  	stacktop = .;
>  	/* Start text 0x4000 */
>  	.text : {


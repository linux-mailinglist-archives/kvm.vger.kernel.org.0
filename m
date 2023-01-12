Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7AE7667D06
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 18:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbjALRyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 12:54:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbjALRx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 12:53:27 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495537458D;
        Thu, 12 Jan 2023 09:14:13 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30CGiM7G000397;
        Thu, 12 Jan 2023 17:14:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=im36Uq8Fgz1pqZBt7cyV7tlwUEL0snD9GG9u0WXEzxo=;
 b=dTYftaVWgENV5UYE/Uo4I/u0RXdhqg7dz55fkkyNocBx7SCJQME+Gxs51VQoHXn/pDkj
 XX1bjaFU2p/cOcDOAdYNvBXGdCFfDu/bnq00RkL70ChREKFbNSeI9DNDca5Lle4F3O5q
 3/rYIVZYvPzh+JE6Av9bQxju6nxm1+NKSTwZwqtpt9igPflJ82+dFOx9yB8dyjwRho3D
 IZuotStxtld0aK4XXKjn3YXHt/to3XU+OoIaQuraFxphqbsAwFCkzwxvj0l+0HcowcfD
 iynN9E92jC/avYR7V93+kf1SqMpXGV6hXn5GbMrlbM7MqjIp/Ehg69ZoZIoDBL7MM/+Q Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n2p08rjw8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 17:14:12 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30CH7VKV022749;
        Thu, 12 Jan 2023 17:14:12 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n2p08rjvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 17:14:12 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30CFw0mH025740;
        Thu, 12 Jan 2023 17:14:09 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3n1kv7trkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 17:14:09 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30CHE5Y219464590
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 17:14:05 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 983632004B;
        Thu, 12 Jan 2023 17:14:05 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 571902004D;
        Thu, 12 Jan 2023 17:14:05 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 12 Jan 2023 17:14:05 +0000 (GMT)
Date:   Thu, 12 Jan 2023 18:05:05 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 1/7] s390x: Cleanup flat.lds
Message-ID: <20230112180505.633cdf87@p-imbrenda>
In-Reply-To: <20230112154548.163021-2-frankja@linux.ibm.com>
References: <20230112154548.163021-1-frankja@linux.ibm.com>
        <20230112154548.163021-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5lz8aJF7JRQPxYt3b99aMqNRYthRzsh7
X-Proofpoint-ORIG-GUID: X_QELP7RTD8aa-zM04eXexu_EikRtdnc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-12_08,2023-01-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 malwarescore=0 bulkscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301120124
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Jan 2023 15:45:42 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> It seems like the loader file was copied over from another
> architecture which has a different page size (64K) than s390 (4K).
> 
> Let's use a 4k alignment instead of the 64k one and remove unneeded
> entries.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/flat.lds | 19 ++++---------------
>  1 file changed, 4 insertions(+), 15 deletions(-)
> 
> diff --git a/s390x/flat.lds b/s390x/flat.lds
> index de9da1a8..952f6cd4 100644
> --- a/s390x/flat.lds
> +++ b/s390x/flat.lds
> @@ -24,20 +24,8 @@ SECTIONS
>  		*(.text)
>  		*(.text.*)
>  	}
> -	. = ALIGN(64K);
> +	. = ALIGN(4K);
>  	etext = .;
> -	.opd : { *(.opd) }
> -	. = ALIGN(16);
> -	.dynamic : {
> -		dynamic_start = .;
> -		*(.dynamic)
> -	}
> -	.dynsym : {
> -		dynsym_start = .;
> -		*(.dynsym)
> -	}
> -	.rela.dyn : { *(.rela*) }
> -	. = ALIGN(16);
>  	.data : {
>  		*(.data)
>  		*(.data.rel*)
> @@ -48,10 +36,11 @@ SECTIONS
>  	__bss_start = .;
>  	.bss : { *(.bss) }
>  	__bss_end = .;
> -	. = ALIGN(64K);
> +	. = ALIGN(4K);
>  	edata = .;
> +	/* Reserve 64K for the stack */
>  	. += 64K;
> -	. = ALIGN(64K);
> +	. = ALIGN(4K);
>  	/*
>  	 * stackptr set with initial stack frame preallocated
>  	 */


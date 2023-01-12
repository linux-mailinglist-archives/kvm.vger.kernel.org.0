Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDF0667D01
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 18:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbjALRyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 12:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbjALRxY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 12:53:24 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2478274582;
        Thu, 12 Jan 2023 09:14:09 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30CH9AfF013431;
        Thu, 12 Jan 2023 17:14:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=uB7+IqNDYNPS9kqM1e+U7w36V8xq8rOOoYqN+arlJDs=;
 b=SedRgsFtVgFaOR5sG4WXOykrKHrKyjS1e1EetioqeBmxxGv9nBaTeAGlRaBzfhAJGDen
 eiD/RK9+/qVN0TTFy+DocEGmXBDpAUoSoGKPUAz9sdADR4gEuCJe/k/HTt3+MTg9dP3l
 DD4KU+1x2Nw36/cf1G7qdDuz6Uqab65w+zmoTkPwepFcjHskFQ3iwmkXcGyVgA+oX3Ry
 QeeBaySGhR5x1QQ2MEEwExDMh6dMl6uOMFoHBiwpDCP/n2rgXWTUcw8BA21RBjEmlkVG
 j6dP/hzaRbGlu2bhluDreGnr0VJEF9Hs74tC63QoknDJOjpV9ZG+C4LGCs9z6/yISJsc jA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n2nd79kk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 17:14:08 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30CH9xAa017227;
        Thu, 12 Jan 2023 17:14:07 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n2nd79kj2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 17:14:07 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30CBV3tA018081;
        Thu, 12 Jan 2023 17:14:05 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3n1km6a1hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 17:14:05 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30CHE1FK44826882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 17:14:02 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D430C2004B;
        Thu, 12 Jan 2023 17:14:01 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DD912004D;
        Thu, 12 Jan 2023 17:14:01 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 12 Jan 2023 17:14:01 +0000 (GMT)
Date:   Thu, 12 Jan 2023 18:05:12 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 2/7] s390x: snippets: c: Cleanup
 flat.lds
Message-ID: <20230112180512.5f0c4f32@p-imbrenda>
In-Reply-To: <20230112154548.163021-3-frankja@linux.ibm.com>
References: <20230112154548.163021-1-frankja@linux.ibm.com>
        <20230112154548.163021-3-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5-nn2-9GM_qVnkTNpqyd14DnWKV6hkHt
X-Proofpoint-ORIG-GUID: 2YhPgp1ZRk792JuAynGnor4ERIiWdZgJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-12_08,2023-01-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 bulkscore=0 clxscore=1015 adultscore=0
 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301120124
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Jan 2023 15:45:43 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> There are a lot of things in there which we don't need for snippets
> and the alignments can be switched from 64K to 4K since that's the
> s390 page size.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/snippets/c/flat.lds | 28 +++++++++-------------------
>  1 file changed, 9 insertions(+), 19 deletions(-)
> 
> diff --git a/s390x/snippets/c/flat.lds b/s390x/snippets/c/flat.lds
> index 260ab1c4..9e5eb66b 100644
> --- a/s390x/snippets/c/flat.lds
> +++ b/s390x/snippets/c/flat.lds
> @@ -16,27 +16,22 @@ SECTIONS
>  		 QUAD(0x0000000000004000)
>  	}
>  	. = 0x4000;
> +	/*
> +	 * The stack grows down from 0x4000 to 0x2000, we pre-allocoate
> +	 * a frame via the -160.
> +	 */
>  	stackptr = . - 160;
>  	stacktop = .;
> +	/* Start text 0x4000 */
>  	.text : {
>  		*(.init)
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
> +	/* End text */
> +	/* Start data */
>  	.data : {
>  		*(.data)
>  		*(.data.rel*)
> @@ -44,11 +39,6 @@ SECTIONS
>  	. = ALIGN(16);
>  	.rodata : { *(.rodata) *(.rodata.*) }
>  	. = ALIGN(16);
> -	__bss_start = .;
>  	.bss : { *(.bss) }
> -	__bss_end = .;
> -	. = ALIGN(64K);
> -	edata = .;
> -	. += 64K;
> -	. = ALIGN(64K);
> +	/* End data */
>  }


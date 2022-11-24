Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF1F638046
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 21:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiKXUnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 15:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKXUnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 15:43:02 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F6379E16;
        Thu, 24 Nov 2022 12:43:01 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AOIuWxW034217;
        Thu, 24 Nov 2022 20:43:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=7v7MAozaEptcbSRz3nhq2mbACETYE/3fYJB2l1xWFbw=;
 b=MCRAN2T2Sm5ikz7+b1xahKyJu/McbZdxBFuiz3Nw0jbRgYA6Zv8JU4+MnoYExdLKpaDO
 s3YdBwTiyO0wEFVlCZcfDU9qs4yzO4OWaDC5FsmWsUuLkGpO4X6xHoOBA927YHppfq1P
 y8Quf3wGXEztFHm9MQZ7JoYGeswaPxfsOwtpsJOa5HIliFU1fJPT7pX1o4CQ3hdyoVsC
 tmHK5CVAu7OuKj/e4kh32QXDx4n0bVcA+uSNRqHfQlev87pNn4u5ZYW3cEe0YVgogrNW
 cBvc/hhm+Y29Y/W5erdtZ6BXBhwZheHD+8eDbSMZg7Y2DoUxopAybY08pid7gUMhOIlD 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2eb7hkgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 20:43:00 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AOKeEJO022076;
        Thu, 24 Nov 2022 20:43:00 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2eb7hkfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 20:42:59 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AOKZOY4010633;
        Thu, 24 Nov 2022 20:42:58 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3kxps8p7pq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Nov 2022 20:42:58 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AOKgsAE7930572
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Nov 2022 20:42:54 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81E52A4054;
        Thu, 24 Nov 2022 20:42:54 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 204ECA405C;
        Thu, 24 Nov 2022 20:42:54 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.83.22])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 24 Nov 2022 20:42:54 +0000 (GMT)
Message-ID: <2803564dcc325f716548ea3a8938d8c0b7814a33.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 1/5] s390x: Add a linker script to
 assembly snippets
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com
Date:   Thu, 24 Nov 2022 21:42:48 +0100
In-Reply-To: <20221123084656.19864-2-frankja@linux.ibm.com>
References: <20221123084656.19864-1-frankja@linux.ibm.com>
         <20221123084656.19864-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SQnMERe7_npsOdoEECW5JfN3NFxtb43I
X-Proofpoint-GUID: DZuohBVXRsIhJ3fXr9nZgDyvZaTDekct
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_12,2022-11-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211240153
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-11-23 at 08:46 +0000, Janosch Frank wrote:
> A linker script has a few benefits:
> - Random data doesn't end up in the binary breaking tests
> - We can easily define a lowcore and load the snippet from 0x0 instead
> of 0x4000 which makes asm snippets behave like c snippets
> - We can easily define an invalid PGM new PSW to ensure an exit on a
> guest PGM
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/snippet.h         |  3 +--
>  s390x/Makefile              |  5 +++--
>  s390x/mvpg-sie.c            |  2 +-
>  s390x/pv-diags.c            |  6 +++---
>  s390x/snippets/asm/flat.lds | 43 +++++++++++++++++++++++++++++++++++++
>  5 files changed, 51 insertions(+), 8 deletions(-)
>  create mode 100644 s390x/snippets/asm/flat.lds
> 
> diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
> index b17b2a4c..57045994 100644
> --- a/lib/s390x/snippet.h
> +++ b/lib/s390x/snippet.h
> @@ -32,8 +32,7 @@
> 
>  #define SNIPPET_PV_TWEAK0	0x42UL
>  #define SNIPPET_PV_TWEAK1	0UL
> -#define SNIPPET_OFF_C		0
> -#define SNIPPET_OFF_ASM		0x4000
> +#define SNIPPET_UNPACK_OFF	0

You could also get rid of the offset parameter, couldn't you?
> 
> 
>  /*
> diff --git a/s390x/Makefile b/s390x/Makefile
> index bf1504f9..bb0f9eb8 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -135,7 +135,8 @@ $(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
>  	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
> 
>  $(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o
> -	$(OBJCOPY) -O binary -j ".rodata" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $(patsubst %.gbin,%.o,$@) $@
> +	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/snippets/asm/flat.lds $(patsubst %.gbin,%.o,$@)
> +	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@

I assume .bss=alloc allocates the bss in the binary...

>  	truncate -s '%4096' $@
> 
>  $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS)
> @@ -144,7 +145,7 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS)
>  	truncate -s '%4096' $@
> 
>  $(SNIPPET_DIR)/asm/%.hdr: $(SNIPPET_DIR)/asm/%.gbin $(HOST_KEY_DOCUMENT)
> -	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x4000,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
> +	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
> 
>  $(SNIPPET_DIR)/c/%.hdr: $(SNIPPET_DIR)/c/%.gbin $(HOST_KEY_DOCUMENT)
>  	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
> 
[...]

> diff --git a/s390x/snippets/asm/flat.lds b/s390x/snippets/asm/flat.lds
> new file mode 100644
> index 00000000..366d2d78
> --- /dev/null
> +++ b/s390x/snippets/asm/flat.lds
> @@ -0,0 +1,43 @@
> +SECTIONS
> +{
> +	.lowcore : {
> +		/*
> +		 * Initial short psw for disk boot, with 31 bit addressing for
> +		 * non z/Arch environment compatibility and the instruction
> +		 * address 0x4000.
> +		 */
> +		. = 0;
> +		 LONG(0x00080000)
> +		 LONG(0x80004000)
> +		 /* Restart new PSW for booting via PSW restart. */
> +		 . = 0x1a0;
> +		 QUAD(0x0000000180000000)
> +		 QUAD(0x0000000000004000)
> +		 /*
> +		  * Invalid PGM new PSW so we hopefully get a code 8
> +		  * intercept on a PGM
> +		  */
> +		 . = 0x1d0;
> +		 QUAD(0x0008000000000000)
> +		 QUAD(0x0000000000000001)
> +	}
> +	. = 0x4000;
> +	.text : {
> +		*(.text)
> +		*(.text.*)
> +	}
> +	. = ALIGN(64K);
> +	etext = .;
> +	. = ALIGN(16);
> +	.data : {
> +		*(.data)
> +		*(.data.rel*)
> +	}
> +	. = ALIGN(16);
> +	.rodata : { *(.rodata) *(.rodata.*) }
> +	. = ALIGN(16);
> +	__bss_start = .;

.. so the __bss symbols are not necessary.
But then, the c flat.lds has them too.
> +	.bss : { *(.bss) }
> +	__bss_end = .;
> +	. = ALIGN(64K);
> +}


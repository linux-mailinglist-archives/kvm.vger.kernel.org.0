Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8EF16EAE14
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 17:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbjDUPcf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 11:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbjDUPcc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 11:32:32 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A54C65A;
        Fri, 21 Apr 2023 08:32:31 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33LEulik005952;
        Fri, 21 Apr 2023 15:32:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=g4IYW756EY7PK7fdrjL/9wsJNhCCKvwy2T++T4bscP0=;
 b=KuRBo6UhirrDLo8/bM7IFU2Ejlt9DVdmBhJ0Wl6FYUdoROFGfdj9FuMn0IZkUV4CWscc
 xQJ74G+YH/tkwV8x19iVtRs4P6TGkQZ04rIXnkGIR7SyTuzm6A+PEaxkDAJWlo3Lsev6
 NcqxKIHAYIy/GxIDyd3oAu/9QdJKSExMQIpK9iGFRnZ6AofL68fzYX9WiTlP8O94sU2Z
 Y6OwS7wXcjPijdZoRMgzxPZmh/7/sO1mBUJKZav4kvhTqdGZ/BZQMebEl5xlFqAf74do
 EMjLh3eYHp59+0QEHQCi8AldMmeDI+b8y4Pk7fG8erF2NK72PeUOvCMeJRqsfyybjbzL vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3vhksy24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 15:32:30 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33LEk7M4025794;
        Fri, 21 Apr 2023 15:32:29 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3vhksy00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 15:32:29 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33L7A4MP014464;
        Fri, 21 Apr 2023 15:32:27 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3pykj6ke37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 15:32:27 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33LFWORd35652202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 15:32:24 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E3FB220040;
        Fri, 21 Apr 2023 15:32:23 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75D5220049;
        Fri, 21 Apr 2023 15:32:23 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.17.52])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
        Fri, 21 Apr 2023 15:32:23 +0000 (GMT)
Date:   Fri, 21 Apr 2023 16:10:19 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        nrb@linux.ibm.com, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 3/7] s390x: pv-diags: Drop snippet
 from snippet names
Message-ID: <20230421161019.374881b3@p-imbrenda>
In-Reply-To: <20230421113647.134536-4-frankja@linux.ibm.com>
References: <20230421113647.134536-1-frankja@linux.ibm.com>
        <20230421113647.134536-4-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: s2Jn6Xgnui6a1pegEIGy0hVKLJv3ZA_m
X-Proofpoint-ORIG-GUID: Muk6dMJYykjveBtgDZdpGUFxXTGmvjUh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-21_08,2023-04-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=999 clxscore=1015 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304210132
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Apr 2023 11:36:43 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> It's a bit redundant.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/Makefile                                |  6 +--
>  s390x/pv-diags.c                              | 48 +++++++++----------
>  .../{snippet-pv-diag-288.S => pv-diag-288.S}  |  0
>  .../{snippet-pv-diag-500.S => pv-diag-500.S}  |  0
>  ...nippet-pv-diag-yield.S => pv-diag-yield.S} |  0
>  5 files changed, 27 insertions(+), 27 deletions(-)
>  rename s390x/snippets/asm/{snippet-pv-diag-288.S => pv-diag-288.S} (100%)
>  rename s390x/snippets/asm/{snippet-pv-diag-500.S => pv-diag-500.S} (100%)
>  rename s390x/snippets/asm/{snippet-pv-diag-yield.S => pv-diag-yield.S} (100%)
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index a80db538..8d1cfc7c 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -122,9 +122,9 @@ snippet_lib = $(snippet_asmlib) lib/auxinfo.o
>  $(TEST_DIR)/mvpg-sie.elf: snippets = $(SNIPPET_DIR)/c/mvpg-snippet.gbin
>  $(TEST_DIR)/spec_ex-sie.elf: snippets = $(SNIPPET_DIR)/c/spec_ex.gbin
>  
> -$(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-diag-yield.gbin
> -$(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-diag-288.gbin
> -$(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/snippet-pv-diag-500.gbin
> +$(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-diag-yield.gbin
> +$(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-diag-288.gbin
> +$(TEST_DIR)/pv-diags.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-diag-500.gbin
>  
>  ifneq ($(GEN_SE_HEADER),)
>  snippets += $(pv-snippets)
> diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
> index 096ac61f..fa4e5532 100644
> --- a/s390x/pv-diags.c
> +++ b/s390x/pv-diags.c
> @@ -18,17 +18,17 @@ static struct vm vm;
>  
>  static void test_diag_500(void)
>  {
> -	extern const char SNIPPET_NAME_START(asm, snippet_pv_diag_500)[];
> -	extern const char SNIPPET_NAME_END(asm, snippet_pv_diag_500)[];
> -	extern const char SNIPPET_HDR_START(asm, snippet_pv_diag_500)[];
> -	extern const char SNIPPET_HDR_END(asm, snippet_pv_diag_500)[];
> -	int size_hdr = SNIPPET_HDR_LEN(asm, snippet_pv_diag_500);
> -	int size_gbin = SNIPPET_LEN(asm, snippet_pv_diag_500);
> +	extern const char SNIPPET_NAME_START(asm, pv_diag_500)[];
> +	extern const char SNIPPET_NAME_END(asm, pv_diag_500)[];
> +	extern const char SNIPPET_HDR_START(asm, pv_diag_500)[];
> +	extern const char SNIPPET_HDR_END(asm, pv_diag_500)[];
> +	int size_hdr = SNIPPET_HDR_LEN(asm, pv_diag_500);
> +	int size_gbin = SNIPPET_LEN(asm, pv_diag_500);
>  
>  	report_prefix_push("diag 0x500");
>  
> -	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_500),
> -			SNIPPET_HDR_START(asm, snippet_pv_diag_500),
> +	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, pv_diag_500),
> +			SNIPPET_HDR_START(asm, pv_diag_500),
>  			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
>  
>  	sie(&vm);
> @@ -70,17 +70,17 @@ static void test_diag_500(void)
>  
>  static void test_diag_288(void)
>  {
> -	extern const char SNIPPET_NAME_START(asm, snippet_pv_diag_288)[];
> -	extern const char SNIPPET_NAME_END(asm, snippet_pv_diag_288)[];
> -	extern const char SNIPPET_HDR_START(asm, snippet_pv_diag_288)[];
> -	extern const char SNIPPET_HDR_END(asm, snippet_pv_diag_288)[];
> -	int size_hdr = SNIPPET_HDR_LEN(asm, snippet_pv_diag_288);
> -	int size_gbin = SNIPPET_LEN(asm, snippet_pv_diag_288);
> +	extern const char SNIPPET_NAME_START(asm, pv_diag_288)[];
> +	extern const char SNIPPET_NAME_END(asm, pv_diag_288)[];
> +	extern const char SNIPPET_HDR_START(asm, pv_diag_288)[];
> +	extern const char SNIPPET_HDR_END(asm, pv_diag_288)[];
> +	int size_hdr = SNIPPET_HDR_LEN(asm, pv_diag_288);
> +	int size_gbin = SNIPPET_LEN(asm, pv_diag_288);
>  
>  	report_prefix_push("diag 0x288");
>  
> -	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_288),
> -			SNIPPET_HDR_START(asm, snippet_pv_diag_288),
> +	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, pv_diag_288),
> +			SNIPPET_HDR_START(asm, pv_diag_288),
>  			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
>  
>  	sie(&vm);
> @@ -111,17 +111,17 @@ static void test_diag_288(void)
>  
>  static void test_diag_yield(void)
>  {
> -	extern const char SNIPPET_NAME_START(asm, snippet_pv_diag_yield)[];
> -	extern const char SNIPPET_NAME_END(asm, snippet_pv_diag_yield)[];
> -	extern const char SNIPPET_HDR_START(asm, snippet_pv_diag_yield)[];
> -	extern const char SNIPPET_HDR_END(asm, snippet_pv_diag_yield)[];
> -	int size_hdr = SNIPPET_HDR_LEN(asm, snippet_pv_diag_yield);
> -	int size_gbin = SNIPPET_LEN(asm, snippet_pv_diag_yield);
> +	extern const char SNIPPET_NAME_START(asm, pv_diag_yield)[];
> +	extern const char SNIPPET_NAME_END(asm, pv_diag_yield)[];
> +	extern const char SNIPPET_HDR_START(asm, pv_diag_yield)[];
> +	extern const char SNIPPET_HDR_END(asm, pv_diag_yield)[];
> +	int size_hdr = SNIPPET_HDR_LEN(asm, pv_diag_yield);
> +	int size_gbin = SNIPPET_LEN(asm, pv_diag_yield);
>  
>  	report_prefix_push("diag yield");
>  
> -	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, snippet_pv_diag_yield),
> -			SNIPPET_HDR_START(asm, snippet_pv_diag_yield),
> +	snippet_pv_init(&vm, SNIPPET_NAME_START(asm, pv_diag_yield),
> +			SNIPPET_HDR_START(asm, pv_diag_yield),
>  			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
>  
>  	/* 0x44 */
> diff --git a/s390x/snippets/asm/snippet-pv-diag-288.S b/s390x/snippets/asm/pv-diag-288.S
> similarity index 100%
> rename from s390x/snippets/asm/snippet-pv-diag-288.S
> rename to s390x/snippets/asm/pv-diag-288.S
> diff --git a/s390x/snippets/asm/snippet-pv-diag-500.S b/s390x/snippets/asm/pv-diag-500.S
> similarity index 100%
> rename from s390x/snippets/asm/snippet-pv-diag-500.S
> rename to s390x/snippets/asm/pv-diag-500.S
> diff --git a/s390x/snippets/asm/snippet-pv-diag-yield.S b/s390x/snippets/asm/pv-diag-yield.S
> similarity index 100%
> rename from s390x/snippets/asm/snippet-pv-diag-yield.S
> rename to s390x/snippets/asm/pv-diag-yield.S


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C989B6B0C75
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 16:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbjCHPUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 10:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbjCHPTk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 10:19:40 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7B5C9C2F
        for <kvm@vger.kernel.org>; Wed,  8 Mar 2023 07:19:37 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328Dgwjt014777
        for <kvm@vger.kernel.org>; Wed, 8 Mar 2023 15:19:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=JlUM+CivsCsPh56v+2pjpT7IycrTHVdCo+fWOYyTpys=;
 b=hB+93m0iK01oC1mrJqGVi4IjYlz1J+/QSFObWfYHHAvQdoUZLxRKsHvtObqfRwrZQmBN
 ozPMfYb0mztymh9dpjLxK2eDNMFNdWpwbeyXX0sY4xxMTI7hTi0ABksKiMVQiaqAvr0n
 hfMtHH2yqHUUpQEGvgxZ1qsMQdRZrIRBfhxT2W3qHsqQkdwYppC5cNJMhiZ2Bxm8RggW
 8XvGFolvQPReGt0EAGBd+FGQ/mr+fGs5WgsiM4CLZfEJX0GAyfSX9fd0i8QefxG6mN14
 E7omy9BSOdY6GEKZzacOxqPOA+YMehXqveaHfkSqaI4QKBJB4CnyuSsTDnczjMBL4Wnq aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6ndubpch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 08 Mar 2023 15:19:36 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 328CviJD030241
        for <kvm@vger.kernel.org>; Wed, 8 Mar 2023 15:19:35 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p6ndubpb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 15:19:35 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 328Da5bY023163;
        Wed, 8 Mar 2023 15:19:34 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3p6fyss05h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Mar 2023 15:19:33 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 328FJUQD6947438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Mar 2023 15:19:30 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 467FD20043;
        Wed,  8 Mar 2023 15:19:30 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C93FA20040;
        Wed,  8 Mar 2023 15:19:29 +0000 (GMT)
Received: from p-imbrenda (unknown [9.179.29.172])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
        Wed,  8 Mar 2023 15:19:29 +0000 (GMT)
Date:   Wed, 8 Mar 2023 16:19:23 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 5/7] s390x: use preprocessor for
 linker script generation
Message-ID: <20230308161923.3e666e9a@p-imbrenda>
In-Reply-To: <20230307091051.13945-6-mhartmay@linux.ibm.com>
References: <20230307091051.13945-1-mhartmay@linux.ibm.com>
        <20230307091051.13945-6-mhartmay@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: b1lvVCQ_FBYsDTmD4cNST4CxTfgURjr5
X-Proofpoint-ORIG-GUID: beSmPJmYDv0BuBbzOVpSBNFpRXl6k2Il
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_08,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 clxscore=1015 priorityscore=1501 suspectscore=0 impostorscore=0
 spamscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080129
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Mar 2023 10:10:49 +0100
Marc Hartmayer <mhartmay@linux.ibm.com> wrote:

> The old `.lds` scripts are being renamed to `.lds.S` and the actual
> `.lds` scripts are being generated by the assembler preprocessor. This
> change allows us to use constants defined by macros in the `.lds.S`
> files.
> 
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  .gitignore                                  | 1 +
>  s390x/Makefile                              | 7 +++++--
>  s390x/{flat.lds => flat.lds.S}              | 0
>  s390x/snippets/asm/{flat.lds => flat.lds.S} | 0
>  s390x/snippets/c/{flat.lds => flat.lds.S}   | 0
>  5 files changed, 6 insertions(+), 2 deletions(-)
>  rename s390x/{flat.lds => flat.lds.S} (100%)
>  rename s390x/snippets/asm/{flat.lds => flat.lds.S} (100%)
>  rename s390x/snippets/c/{flat.lds => flat.lds.S} (100%)
> 
> diff --git a/.gitignore b/.gitignore
> index 601822d67325..29f352c5ceb6 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -31,3 +31,4 @@ cscope.*
>  /s390x/comm.key
>  /s390x/snippets/*/*.hdr
>  /s390x/snippets/*/*.*obj
> +/s390x/**/*.lds
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 8719f0c837cf..e13a04eecb3e 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -76,7 +76,7 @@ CFLAGS += -fno-delete-null-pointer-checks
>  LDFLAGS += -nostdlib -Wl,--build-id=none
>  
>  # We want to keep intermediate files
> -.PRECIOUS: %.o
> +.PRECIOUS: %.o %.lds
>  
>  asm-offsets = lib/$(ARCH)/asm-offsets.h
>  include $(SRCDIR)/scripts/asm-offsets.mak
> @@ -159,6 +159,9 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SNIPP
>  %.hdr.obj: %.hdr
>  	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
>  
> +lds-autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d -MT $@
> +%.lds: %.lds.S
> +	$(CPP) $(lds-autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<
>  
>  .SECONDEXPANSION:
>  %.elf: $(FLATLIBS) $(asmlib) $(SRCDIR)/s390x/flat.lds $$(snippets-obj) $$(snippet-hdr-obj) %.o
> @@ -211,7 +214,7 @@ $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
>  
>  
>  arch_clean: asm_offsets_clean
> -	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-key)
> +	$(RM) $(TEST_DIR)/*.{o,elf,bin,lds} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr,lds} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-key)
>  
>  generated-files = $(asm-offsets)
>  $(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)
> diff --git a/s390x/flat.lds b/s390x/flat.lds.S
> similarity index 100%
> rename from s390x/flat.lds
> rename to s390x/flat.lds.S
> diff --git a/s390x/snippets/asm/flat.lds b/s390x/snippets/asm/flat.lds.S
> similarity index 100%
> rename from s390x/snippets/asm/flat.lds
> rename to s390x/snippets/asm/flat.lds.S
> diff --git a/s390x/snippets/c/flat.lds b/s390x/snippets/c/flat.lds.S
> similarity index 100%
> rename from s390x/snippets/c/flat.lds
> rename to s390x/snippets/c/flat.lds.S


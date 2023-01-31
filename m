Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A190683462
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 18:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjAaR40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 12:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjAaR4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 12:56:25 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5302ED50
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 09:56:11 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30VG09xv009445
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 17:56:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=49cpiNVBdqJi09K6fISk42AJZs5VGISaK2MGKBnI1v4=;
 b=mXBRSmLnIY/idxEY4U9gXQ6CLoXZlnKgOiSMUnmTgn24904rsHHbtGlNUxWJzF2VJho7
 yd8cyxfZV5hk8UrReTlm73zJM34mEu3UW6vyD1T3Keyp29aBFsgPAz5qfnFOxyOxHRfA
 fa2M/HM1mpKVdXbuY4rgvBLMczlNSTKkE6w7DkcIr8S8jlcPk8eHR4ssTQGz69Jhkpzn
 LtfH4rLE5JUATBvZ8YEY6XKIYqNJGLNfI5DBwn/9NaeD4w+kmSVkTGoSXcqCtjmkZzS+
 Nulgivpxkz1wfmfoVgYWPomhZDeJRxLlEJ96bhpRwHHNhc16BzkBC2ux2lA0X7p8laTc TA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nf31ngr44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 17:56:10 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30VHcgQY024853
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 17:56:10 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nf31ngr3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Jan 2023 17:56:10 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30VDN0ce012873;
        Tue, 31 Jan 2023 17:56:07 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3ncvtybsyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Jan 2023 17:56:07 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30VHu4a241419128
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 17:56:04 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D64B2004B;
        Tue, 31 Jan 2023 17:56:04 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3FC420043;
        Tue, 31 Jan 2023 17:56:03 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.195.13])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 31 Jan 2023 17:56:03 +0000 (GMT)
Message-ID: <dc9617483f2dbd36c64972bde068fcbb9cca10a3.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 5/8] s390x: use C pre-processor for
 linker script generation
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Date:   Tue, 31 Jan 2023 18:56:03 +0100
In-Reply-To: <20230119114045.34553-6-mhartmay@linux.ibm.com>
References: <20230119114045.34553-1-mhartmay@linux.ibm.com>
         <20230119114045.34553-6-mhartmay@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 82Lrbcs79Hgn7JbgZpCvSdeisDlDGpgu
X-Proofpoint-GUID: nwJCVZ9LvsiLhj9cC-aTtqHILGLdDhU3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-31_08,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 phishscore=0 impostorscore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 mlxlogscore=865 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2301310155
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2023-01-19 at 12:40 +0100, Marc Hartmayer wrote:
> Use the C pre-processor for the linker script generation. For example,
> this enables us the use of constants in the "linker scripts" `*.lds.S`.
>=20
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>  .gitignore                                  | 1 +
>  s390x/Makefile                              | 6 ++++--
>  s390x/{flat.lds =3D> flat.lds.S}              | 0
>  s390x/snippets/asm/{flat.lds =3D> flat.lds.S} | 0
>  s390x/snippets/c/{flat.lds =3D> flat.lds.S}   | 0
>  5 files changed, 5 insertions(+), 2 deletions(-)
>  rename s390x/{flat.lds =3D> flat.lds.S} (100%)
>  rename s390x/snippets/asm/{flat.lds =3D> flat.lds.S} (100%)
>  rename s390x/snippets/c/{flat.lds =3D> flat.lds.S} (100%)
>=20
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
> index 8719f0c837cf..44ccca8102d6 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -76,7 +76,7 @@ CFLAGS +=3D -fno-delete-null-pointer-checks
>  LDFLAGS +=3D -nostdlib -Wl,--build-id=3Dnone
> =20
>  # We want to keep intermediate files
> -.PRECIOUS: %.o
> +.PRECIOUS: %.o %.lds
> =20
>  asm-offsets =3D lib/$(ARCH)/asm-offsets.h
>  include $(SRCDIR)/scripts/asm-offsets.mak
> @@ -159,6 +159,8 @@ $(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snipp=
et_lib) $(FLATLIBS) $(SNIPP
>  %.hdr.obj: %.hdr
>  	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
> =20
> +%.lds: %.lds.S
> +	$(CPP) $(autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<

Where is CPP defined?
Do you need the $(autodepend-flags)? It generates a rule with target flat.l=
ds.o.
I don't think that would be used anywhere.
In the next patch you add $(asm-offsets) as a prerequisite, if the generate=
d rule would
be effective, you wouldn't need that, would you?
> =20
>  .SECONDEXPANSION:
>  %.elf: $(FLATLIBS) $(asmlib) $(SRCDIR)/s390x/flat.lds $$(snippets-obj) $=
$(snippet-hdr-obj) %.o
> @@ -211,7 +213,7 @@ $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-off=
sets)
> =20
> =20
>  arch_clean: asm_offsets_clean
> -	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr=
} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-key)
> +	$(RM) $(TEST_DIR)/*.{o,elf,bin,lds} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj=
,hdr,lds} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-ke=
y)
> =20
>  generated-files =3D $(asm-offsets)
>  $(tests:.elf=3D.o) $(asmlib) $(cflatobjs): $(generated-files)
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


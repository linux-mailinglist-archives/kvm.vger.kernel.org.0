Return-Path: <kvm+bounces-22250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F19593C498
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 16:41:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 097FA1C2184C
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 14:41:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C88C719DF6E;
	Thu, 25 Jul 2024 14:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lqDMPi9i"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF0519D8BB;
	Thu, 25 Jul 2024 14:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918459; cv=none; b=tGLndejLMy/jzwxSmwRj5HpnSPo4PXORhATv6DowsS4xGRSnWmUU06a9k5Ec29SFOtC+jJIypW9/AQDB8isnSnUMSZhn4CkLQQh5zo6/er+pKGWg/1bAVNY3PtZCb9/ntI7DKNGLCbeG8Tqr6+EXocs9GyRn57d/K9RnXG2Z/5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918459; c=relaxed/simple;
	bh=Ld96hc7GEbvqoEsA43j0z9b2a9gx4LuclLQOoPlYVPU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g7/GdaYkvDPEYU5fJRlu8lsQRT2KOvyr6v+S/ss2f3WZuo5+y1uN5D7Gewjtm1KimfkY7PckOTTCSFayj0Cq9H2pZ5ftV3j0oEcCUS3d4cu1raJG09yJ1YsXx9Y5AgSrv4r19N0q3b4Oho1UZloAYpSmoTmhELL9JMvBbeCmuns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lqDMPi9i; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46PCRc20009280;
	Thu, 25 Jul 2024 14:40:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	HOSG4CF9MoAmwkFMrYwXVQtkI3oICDCLJuIfxpoffJU=; b=lqDMPi9iLqxPNnlv
	ISn7aBT9sgSsQNNxxWny/T3F/OIm4nJnKV6PCsyw+8mXZlNW5k0Rm6cFmHlXp8i6
	Afkwk+UgNZmQg1adhh3mIUJ4HGuwfZ97z2SY1E0GfI2XtL0TVUhBNd6h/Ev/i4UF
	i4OfHreZ8/v7PnY89VyG4oJ9cFvLw/501hib1IV4Ge7n4Yn0JJh9AVTn+I1IjuLX
	qB6AmdX9d3hLPzOkw+Jd4mraGN7bkGdp17it99D2e11BqGE1GBFWhxGLPu0JrbYK
	HI1dF7ClpyVy3hkR66mbSB0l8sFoRJpxs/0h8DGPG5FCLZFPte5y40SjnCv2FBEE
	MAZnCw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40kmm0gkv1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jul 2024 14:40:49 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46PEenMX015689;
	Thu, 25 Jul 2024 14:40:49 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40kmm0gkuy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jul 2024 14:40:49 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46PB0DHH006265;
	Thu, 25 Jul 2024 14:40:48 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 40gqjuqkuj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jul 2024 14:40:48 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46PEeh9t55116070
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Jul 2024 14:40:45 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1243520065;
	Thu, 25 Jul 2024 14:40:43 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 933132005A;
	Thu, 25 Jul 2024 14:40:42 +0000 (GMT)
Received: from p-imbrenda (unknown [9.179.15.236])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 25 Jul 2024 14:40:42 +0000 (GMT)
Date: Thu, 25 Jul 2024 16:35:14 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, nrb@linux.ibm.com,
        npiggin@gmail.com, nsg@linux.ibm.com, mhartmay@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 1/4] s390x: Split snippet makefile rules
 into new file
Message-ID: <20240725163514.7831c3d9@p-imbrenda>
In-Reply-To: <20240718105104.34154-2-frankja@linux.ibm.com>
References: <20240718105104.34154-1-frankja@linux.ibm.com>
	<20240718105104.34154-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Kbf6-2R-dYzDx8oRPLnf5AZwPjG5eZR5
X-Proofpoint-GUID: FT55b8vLcjtaEpd_zb9Lwb0gQ5cvVKFd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-25_12,2024-07-25_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 phishscore=0 spamscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 clxscore=1015 malwarescore=0
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2407110000 definitions=main-2407250095

On Thu, 18 Jul 2024 10:50:16 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> It's time to move the snippet related Makefile parts into a new file
> to make s390x/Makefile less busy.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/Makefile          | 34 ++++------------------------------
>  s390x/snippets/Makefile | 30 ++++++++++++++++++++++++++++++
>  2 files changed, 34 insertions(+), 30 deletions(-)
>  create mode 100644 s390x/snippets/Makefile
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index c5c6f92c..2933b452 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -120,9 +120,11 @@ asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o
>  
>  FLATLIBS = $(libcflat)
>  
> +# Snippets
>  SNIPPET_DIR = $(TEST_DIR)/snippets
>  snippet_asmlib = $(SNIPPET_DIR)/c/cstart.o
>  snippet_lib = $(snippet_asmlib) lib/auxinfo.o
> +include $(SNIPPET_DIR)/Makefile
>  
>  # perquisites (=guests) for the snippet hosts.
>  # $(TEST_DIR)/<snippet-host>.elf: snippets = $(SNIPPET_DIR)/<c/asm>/<snippet>.gbin
> @@ -148,34 +150,6 @@ else
>  snippet-hdr-obj =
>  endif
>  
> -# the asm/c snippets %.o have additional generated files as dependencies
> -$(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
> -	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
> -
> -$(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
> -	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
> -
> -$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(SNIPPET_DIR)/asm/flat.lds
> -	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/asm/flat.lds $<
> -	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
> -	truncate -s '%4096' $@
> -
> -$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SNIPPET_DIR)/c/flat.lds
> -	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds $< $(snippet_lib) $(FLATLIBS)
> -	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
> -	truncate -s '%4096' $@
> -
> -%.hdr: %.gbin $(HOST_KEY_DOCUMENT)
> -	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
> -
> -.SECONDARY:
> -%.gobj: %.gbin
> -	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
> -
> -.SECONDARY:
> -%.hdr.obj: %.hdr
> -	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
> -
>  lds-autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d -MT $@
>  %.lds: %.lds.S $(asm-offsets)
>  	$(CPP) $(lds-autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<
> @@ -229,8 +203,8 @@ $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
>  	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
>  
>  
> -arch_clean: asm_offsets_clean
> -	$(RM) $(TEST_DIR)/*.{o,elf,bin,lds} $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr,lds} $(SNIPPET_DIR)/asm/.*.d $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-key)
> +arch_clean: asm_offsets_clean snippet_clean
> +	$(RM) $(TEST_DIR)/*.{o,elf,bin,lds} $(TEST_DIR)/.*.d lib/s390x/.*.d $(comm-key)
>  
>  generated-files = $(asm-offsets)
>  $(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)
> diff --git a/s390x/snippets/Makefile b/s390x/snippets/Makefile
> new file mode 100644
> index 00000000..a1c479f6
> --- /dev/null
> +++ b/s390x/snippets/Makefile
> @@ -0,0 +1,30 @@
> +# the asm/c snippets %.o have additional generated files as dependencies
> +$(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
> +	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
> +
> +$(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
> +	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
> +
> +$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(SNIPPET_DIR)/asm/flat.lds
> +	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/asm/flat.lds $<
> +	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
> +	truncate -s '%4096' $@
> +
> +$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SNIPPET_DIR)/c/flat.lds
> +	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds $< $(snippet_lib) $(FLATLIBS)
> +	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $@ $@
> +	truncate -s '%4096' $@
> +
> +%.hdr: %.gbin $(HOST_KEY_DOCUMENT)
> +	$(GEN_SE_HEADER) -k $(HOST_KEY_DOCUMENT) -c $<,0x0,0x00000000000000420000000000000000 --psw-addr 0x4000 -o $@
> +
> +.SECONDARY:
> +%.gobj: %.gbin
> +	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
> +
> +.SECONDARY:
> +%.hdr.obj: %.hdr
> +	$(OBJCOPY) -I binary -O elf64-s390 -B "s390:64-bit" $< $@
> +
> +snippet_clean:
> +	$(RM) $(SNIPPET_DIR)/*/*.{o,elf,*bin,*obj,hdr,lds} $(SNIPPET_DIR)/asm/.*.d



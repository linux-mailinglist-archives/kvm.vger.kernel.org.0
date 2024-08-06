Return-Path: <kvm+bounces-23331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73B9E948BC9
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 10:57:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BB6CFB234F1
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 08:57:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A95DD1BD50B;
	Tue,  6 Aug 2024 08:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KGZDgRvt"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35D6165EE2;
	Tue,  6 Aug 2024 08:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722934637; cv=none; b=T72ovylRUKt5hL2IqxOVjiZE2pyFX6aNcNjnF/wAKlsPk0OsYHRj/39GAM9dJakIX7f6/GvpH6agebbmYKHxmr1bXYGHQwPEoeEIXkjcOEOh4dQ6yytoecVwtKzy3bKxQI7jB/pLwJsaM6uAw92tm9qAIaF2TgokCm7mYScoyPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722934637; c=relaxed/simple;
	bh=/nAk6nrW6N85SpY9gajWN90wwiX/22WBIPnsDfEXuBc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lR5T60aLGS2acYVv26encXsNZbvR9hNMT0DDpISNJXMNaZ+1e9vr4ynElVQ0JL7YJnnbUoKGCmRUzx/dPKA/QAKEFOhhYmVXsG7SnMwc+/kqLxdiwzflAYxCcWqJApEH6xvtOv23xsIRyUrIz40zKLXi98cctqK1hNdpiJeN0Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=KGZDgRvt; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4765wR1T004885;
	Tue, 6 Aug 2024 08:57:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	cH/CIPSh0p6guJ4qwrzvsiomKgWx5H0o3NguGU+9aO8=; b=KGZDgRvt2CQpt93p
	7XvoTGuGRUyq3CfHdwIDKpf64+m851QoiToAf3vp/5MEmn5E6QKI1Z68TZp1usjE
	5XFyQzIl400KIDWg41n85ba+7Vw5mF2Vugc2Mc53pHQiz5f5rjDuZ1axhd+fz7BT
	3bapT4wUJtnaASPSCsjn/O7fxhG92B5I1pDekcYLnFgO0sxI97d1aUOV3xo0lHeT
	5BR85qFUg/ZuMrJnLknDiXh8YVWKSyC/O49W4YkgW7PL2v6rYDScvHrmlxgxotHb
	TY72X9l4afOKYkft/7yMXdp9P4RCoAZ5N46M8eX7Q1EF770MApALrbHMRfZ2aDu4
	/UYREg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40ue5brbgc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Aug 2024 08:57:14 +0000 (GMT)
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4768vEin014814;
	Tue, 6 Aug 2024 08:57:14 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40ue5brbga-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Aug 2024 08:57:14 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4767s7b5024136;
	Tue, 6 Aug 2024 08:52:31 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 40syvpat10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Aug 2024 08:52:31 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4768qPfH41877822
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 6 Aug 2024 08:52:27 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7ED0F2004F;
	Tue,  6 Aug 2024 08:52:25 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4C22E20040;
	Tue,  6 Aug 2024 08:52:25 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  6 Aug 2024 08:52:25 +0000 (GMT)
Date: Tue, 6 Aug 2024 10:52:24 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, nrb@linux.ibm.com,
        schlameuss@linux.ibm.com, nsg@linux.ibm.com, npiggin@gmail.com,
        mhartmay@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 1/4] s390x/Makefile: Split snippet
 makefile rules into new file
Message-ID: <20240806105224.20ac5d7d@p-imbrenda.boeblingen.de.ibm.com>
In-Reply-To: <20240806084409.169039-2-frankja@linux.ibm.com>
References: <20240806084409.169039-1-frankja@linux.ibm.com>
	<20240806084409.169039-2-frankja@linux.ibm.com>
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
X-Proofpoint-GUID: qXUESEtLs4Qy5RadU9YT_3y7QGdR81bL
X-Proofpoint-ORIG-GUID: WFcTC6fgvgDHL8m_MxmHWihlU63-SUSw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-06_06,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 bulkscore=0 clxscore=1015 adultscore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 malwarescore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408060064

On Tue,  6 Aug 2024 08:42:27 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> It's time to move the snippet related Makefile parts into a new file
> to make s390x/Makefile less busy.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/Makefile          | 38 ++++----------------------------------
>  s390x/snippets/Makefile | 34 ++++++++++++++++++++++++++++++++++
>  2 files changed, 38 insertions(+), 34 deletions(-)
>  create mode 100644 s390x/snippets/Makefile
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 784818b2..aa55b470 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -119,9 +119,11 @@ asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o
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
> @@ -146,38 +148,6 @@ else
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
> -$(SNIPPET_DIR)/asm/%.elf: $(SNIPPET_DIR)/asm/%.o $(SNIPPET_DIR)/asm/flat.lds
> -	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/asm/flat.lds $<
> -
> -$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.elf
> -	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $< $@
> -	truncate -s '%4096' $@
> -
> -$(SNIPPET_DIR)/c/%.elf: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SNIPPET_DIR)/c/flat.lds
> -	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds $< $(snippet_lib) $(FLATLIBS)
> -
> -$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.elf
> -	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $< $@
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
> @@ -231,8 +201,8 @@ $(snippet_asmlib): $$(patsubst %.o,%.S,$$@) $(asm-offsets)
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
> index 00000000..8d79165e
> --- /dev/null
> +++ b/s390x/snippets/Makefile
> @@ -0,0 +1,34 @@
> +# the asm/c snippets %.o have additional generated files as dependencies
> +$(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(asm-offsets)
> +	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
> +
> +$(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
> +	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
> +
> +$(SNIPPET_DIR)/asm/%.elf: $(SNIPPET_DIR)/asm/%.o $(SNIPPET_DIR)/asm/flat.lds
> +	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/asm/flat.lds $<
> +
> +$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.elf
> +	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $< $@
> +	truncate -s '%4096' $@
> +
> +$(SNIPPET_DIR)/c/%.elf: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) $(SNIPPET_DIR)/c/flat.lds
> +	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds $< $(snippet_lib) $(FLATLIBS)
> +
> +$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.elf
> +	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -j ".bss" --set-section-flags .bss=alloc,load,contents $< $@
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



Return-Path: <kvm+bounces-23332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 36532948BDF
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 11:03:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59FFD1C239AD
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 09:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0F0C1BE233;
	Tue,  6 Aug 2024 09:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qwR8BWfm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BB816A943;
	Tue,  6 Aug 2024 09:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722934912; cv=none; b=ZIf3TerxbJlqZJbPTJesK12OW5u+TYXID0BgiPte0Y61lJpLKBjlWB4Xb9dp01CQFay7W7EHuXatcud1usHddykxco73LyGvq3NF7pONwYUiYlEckJyfpWohB5aRJqpkeJM6ksRbhJgvsqsnjyz77Ap+RSoC1XAuHo5PbjPJ6qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722934912; c=relaxed/simple;
	bh=US8jOZ2ug3dp+YSK5BHHRKWLhK+Wrqsce2Z6pO+p5Lk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZTQ6SXPE0WMnQ7NvMiL5X7cq25IuIOGCAwBwzsLD6AjZFdZ8v1e0u9NwIVxvrgbsmbdbLDl7GPYgkCN94jMvC2ui0c4zmwt08bLEIcPlInoPIVU0uyx4uU+mAZNVfgebhdHtNh3wRKFtJfkv/VteXm64V+E2HPpKNTO6F+mavng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qwR8BWfm; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4763K5CL015352;
	Tue, 6 Aug 2024 09:01:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	OSfPYWS9kGnmMIU0TFS0w0cJb3t6riWdUGB65bASUmI=; b=qwR8BWfmz8pKMtDa
	T/6tKTmpaIx2AdUIUYeXEfoMBcDiTkh6jAMIo6q8PGD3dIWngWeVLJX7F0w/q6Yr
	cs8orPDm+Dh4KQIejDipk9xKClMTdi1ua//umjup6b87Wl32aXOYvjjM/N4TvHne
	KaOJp3qPYCwdnZwz11xHdL8T4HLSgCpyzni+Q7/5zmqBlVrxYAyRNAINBj84qOiu
	r89UyQApSW/tqeoOKAmLVaNW0ASWeryjmxEC/+xl3/1SzAJ0VsxWn+iPyAw7TYdC
	TqOXFled0CCH2bBhmPjOQ5dLeE6Zz9uqbv3MY3SLwXHUaf4+A94dIH2UN32DLHTj
	D8nw/g==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40ub2x0pb4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Aug 2024 09:01:49 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 47691ncS000509;
	Tue, 6 Aug 2024 09:01:49 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40ub2x0pb2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Aug 2024 09:01:49 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 47689ToG024117;
	Tue, 6 Aug 2024 09:01:48 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 40syvpau56-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Aug 2024 09:01:48 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 47691gvp50856414
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 6 Aug 2024 09:01:44 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 044332004F;
	Tue,  6 Aug 2024 09:01:42 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6EF0A2004B;
	Tue,  6 Aug 2024 09:01:41 +0000 (GMT)
Received: from darkmoore (unknown [9.179.5.91])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue,  6 Aug 2024 09:01:41 +0000 (GMT)
Date: Tue, 6 Aug 2024 11:01:39 +0200
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        nrb@linux.ibm.com, nsg@linux.ibm.com, npiggin@gmail.com,
        mhartmay@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 1/4] s390x/Makefile: Split snippet
 makefile rules into new file
Message-ID: <20240806110139.2f9c080a.schlameuss@linux.ibm.com>
In-Reply-To: <20240806084409.169039-2-frankja@linux.ibm.com>
References: <20240806084409.169039-1-frankja@linux.ibm.com>
	<20240806084409.169039-2-frankja@linux.ibm.com>
Organization: IBM
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LeSL4bsBd7tokxNJAN7zYMcZ62ob_l93
X-Proofpoint-ORIG-GUID: rTAfSKD_Fwokf_N68eA0xoGnR9DinV2A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-06_06,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=994
 malwarescore=0 spamscore=0 mlxscore=0 impostorscore=0 suspectscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408060064

On Tue,  6 Aug 2024 08:42:27 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> It's time to move the snippet related Makefile parts into a new file
> to make s390x/Makefile less busy.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

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



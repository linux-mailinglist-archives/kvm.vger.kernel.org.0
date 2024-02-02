Return-Path: <kvm+bounces-7829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D484846BF9
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 10:31:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D52E81F2DE9C
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 09:31:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D32346166B;
	Fri,  2 Feb 2024 09:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="evlI9VZA"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B688265BA5
	for <kvm@vger.kernel.org>; Fri,  2 Feb 2024 09:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706866262; cv=none; b=eAxOU2WBsBTREiY0olvEfUYoPcu/RqxWfphDWXvi/srCjVjnopNsTOae2CS0bbPJGLo3Z1jEpba9/yRc3McAMzfx4z5yFxxKI4Gd2yHfIrL9DYM/nm1R1yVkIO9Cc628xiJJO6C1FpPWAeYsCgtJauOVhokZPcXWz2PDSjUBW08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706866262; c=relaxed/simple;
	bh=+cveynKtPc67KUyvZiYl0d4plxrvnOpuPmPIszjlAYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tcTH4bAL/w6WAPqkdyUwMU3j396UG5ID3iPeZWk/TImD1TZz4M5FNfIl0RI0T9YbvgVhDNE89pfktGF9pJb3iqIoQBFS7vvEfaW7sSqc/OW58nynBrCoK9SQtvaczyLeX5rz2Uf8TJwjIgY9d6d8i8kMkUg04lbRDJCqKyjx/+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=evlI9VZA; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 2 Feb 2024 10:30:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706866258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+e8g883f/GpUsUxGkhvVc+5AX3DgxX1o9yUjsrVR4F4=;
	b=evlI9VZAjia1/iXtCwCa9/DqNWD9130t2bEW3OBdtmPolS+c/WyvLG1i31fNKC8seNfn6s
	TVQCaiV0EeroRK+hyrW72UM8yCCWZm+UrdBAsYWSX7AYWDAVQzyZs7GoPCIaTocIqRmHIb
	HTcMmiXLzE0aXwhiC049O7+9Dzj3d5g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org, 
	Laurent Vivier <lvivier@redhat.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Nico Boehr <nrb@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Eric Auger <eric.auger@redhat.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	David Hildenbrand <david@redhat.com>, Marc Hartmayer <mhartmay@linux.ibm.com>, 
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH v2 1/9] (arm|powerpc|s390x): Makefile: Fix
 .aux.o generation
Message-ID: <20240202-2f93f59553cec386791f7629@orel>
References: <20240202065740.68643-1-npiggin@gmail.com>
 <20240202065740.68643-2-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240202065740.68643-2-npiggin@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 02, 2024 at 04:57:32PM +1000, Nicholas Piggin wrote:
> Using all prerequisites for the source file results in the build
> dying on the second time around with:
> 
> gcc: fatal error: cannot specify ‘-o’ with ‘-c’, ‘-S’ or ‘-E’ with multiple files
> 
> This is due to auxinfo.h becoming a prerequisite after the first
> build recorded the dependency.
> 
> Use the first prerequisite for this recipe.
> 
> Fixes: f2372f2d49135 ("(arm|powerpc|s390x): Makefile: add `%.aux.o` target")
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  arm/Makefile.common     | 2 +-
>  powerpc/Makefile.common | 2 +-
>  s390x/Makefile          | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index 54cb4a63..c2ee568c 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -71,7 +71,7 @@ FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libeabi)
>  
>  ifeq ($(CONFIG_EFI),y)
>  %.aux.o: $(SRCDIR)/lib/auxinfo.c
> -	$(CC) $(CFLAGS) -c -o $@ $^ \
> +	$(CC) $(CFLAGS) -c -o $@ $< \
>  		-DPROGNAME=\"$(@:.aux.o=.efi)\" -DAUXFLAGS=$(AUXFLAGS)

There are two instances of the %.aux.o target in arm/Makefile.common. We
need to fix both. We can actually pull the target out of the two arms of
the CONFIG_EFI if-else, though, by changing the .efi/.flat to .$(exe).

Thanks,
drew

>  
>  %.so: EFI_LDFLAGS += -defsym=EFI_SUBSYSTEM=0xa --no-undefined
> diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
> index 483ff648..eb88398d 100644
> --- a/powerpc/Makefile.common
> +++ b/powerpc/Makefile.common
> @@ -48,7 +48,7 @@ cflatobjs += lib/powerpc/smp.o
>  OBJDIRS += lib/powerpc
>  
>  %.aux.o: $(SRCDIR)/lib/auxinfo.c
> -	$(CC) $(CFLAGS) -c -o $@ $^ -DPROGNAME=\"$(@:.aux.o=.elf)\"
> +	$(CC) $(CFLAGS) -c -o $@ $< -DPROGNAME=\"$(@:.aux.o=.elf)\"
>  
>  FLATLIBS = $(libcflat) $(LIBFDT_archive)
>  %.elf: CFLAGS += $(arch_CFLAGS)
> diff --git a/s390x/Makefile b/s390x/Makefile
> index e64521e0..b72f7578 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -177,7 +177,7 @@ lds-autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d -MT $@
>  	$(CPP) $(lds-autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<
>  
>  %.aux.o: $(SRCDIR)/lib/auxinfo.c
> -	$(CC) $(CFLAGS) -c -o $@ $^ -DPROGNAME=\"$(@:.aux.o=.elf)\"
> +	$(CC) $(CFLAGS) -c -o $@ $< -DPROGNAME=\"$(@:.aux.o=.elf)\"
>  
>  .SECONDEXPANSION:
>  %.elf: $(FLATLIBS) $(asmlib) $(SRCDIR)/s390x/flat.lds $$(snippets-obj) $$(snippet-hdr-obj) %.o %.aux.o
> -- 
> 2.42.0
> 


Return-Path: <kvm+bounces-40912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E16AAA5F05A
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 11:11:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E62017DFA4
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 10:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CCFC264F9A;
	Thu, 13 Mar 2025 10:11:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FB39261583;
	Thu, 13 Mar 2025 10:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741860673; cv=none; b=O2VKiEpOnJi02P/xz1+GFvCQCcDdWz28e99C5J396lsSiLsKaWbkoI26C817wU+IKB/LSJH+DOhDmQWs1+bWGpM8vi2xM66LDro0eomtRGH4cZtoLTBadE8Wv213nJzye8YH0yV5VfjGOnihwqzzjsFb+VG0viWtdUcm1Nb/eWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741860673; c=relaxed/simple;
	bh=UYe2qQTQ9lBItsA3rokh/UNh0MMugdSzu7HPH94YTD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O1VyQkAsLjexA3gfkp4MUTyWGPqYFWNzSp1scF+DwzGme00nxdAuOGz937KdXYRRcGsIP2bOzNGRB8FFHMIJ9iM4Nbm+DBIX7EN7Uh9NTNdkOPxr/RMbdkvWOtKBdfyew4dOCbzmqiEvQBRFRN9m3IaXrlmF8Xm1biDXZR18hjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C44E41516;
	Thu, 13 Mar 2025 03:11:18 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6112F3F694;
	Thu, 13 Mar 2025 03:11:06 -0700 (PDT)
Date: Thu, 13 Mar 2025 10:11:03 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com,
	eric.auger@redhat.com, lvivier@redhat.com, frankja@linux.ibm.com,
	imbrenda@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2] Makefile: Use CFLAGS in cc-option
Message-ID: <Z9KvNzQnkFSTvmoE@raptor>
References: <20250307091828.57933-2-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250307091828.57933-2-andrew.jones@linux.dev>

Hi Drew,

Thank you for debugging this. I tested the patch by compiling the MTE test
from Vladimir with clang and it works now:

Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

On Fri, Mar 07, 2025 at 10:18:29AM +0100, Andrew Jones wrote:
> When cross compiling with clang we need to specify the target in
> CFLAGS and cc-option will fail to recognize target-specific options
> without it. Add CFLAGS to the CC invocation in cc-option.
> 
> The introduction of the realmode_bits variable is necessary to
> avoid make failing to build x86 due to CFLAGS referencing itself.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
> v2:
>  - Fixed x86 builds with the realmode_bits variable
> 
>  Makefile            | 2 +-
>  x86/Makefile.common | 3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 78352fced9d4..9dc5d2234e2a 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -21,7 +21,7 @@ DESTDIR := $(PREFIX)/share/kvm-unit-tests/
>  
>  # cc-option
>  # Usage: OP_CFLAGS+=$(call cc-option, -falign-functions=0, -malign-functions=0)
> -cc-option = $(shell if $(CC) -Werror $(1) -S -o /dev/null -xc /dev/null \
> +cc-option = $(shell if $(CC) $(CFLAGS) -Werror $(1) -S -o /dev/null -xc /dev/null \
>                > /dev/null 2>&1; then echo "$(1)"; else echo "$(2)"; fi ;)
>  
>  libcflat := lib/libcflat.a
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index 0b7f35c8de85..e97464912e28 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -98,6 +98,7 @@ tests-common = $(TEST_DIR)/vmexit.$(exe) $(TEST_DIR)/tsc.$(exe) \
>  ifneq ($(CONFIG_EFI),y)
>  tests-common += $(TEST_DIR)/realmode.$(exe) \
>  		$(TEST_DIR)/la57.$(exe)
> +realmode_bits := $(if $(call cc-option,-m16,""),16,32)
>  endif
>  
>  test_cases: $(tests-common) $(tests)
> @@ -108,7 +109,7 @@ $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
>  	$(LD) -m elf_i386 -nostdlib -o $@ \
>  	      -T $(SRCDIR)/$(TEST_DIR)/realmode.lds $^
>  
> -$(TEST_DIR)/realmode.o: bits = $(if $(call cc-option,-m16,""),16,32)
> +$(TEST_DIR)/realmode.o: bits = $(realmode_bits)
>  
>  $(TEST_DIR)/access_test.$(bin): $(TEST_DIR)/access.o
>  
> -- 
> 2.48.1
> 


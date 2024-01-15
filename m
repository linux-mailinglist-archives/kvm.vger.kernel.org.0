Return-Path: <kvm+bounces-6226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D191D82D8FD
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 13:44:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 054A11C2161A
	for <lists+kvm@lfdr.de>; Mon, 15 Jan 2024 12:44:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08CB9154B1;
	Mon, 15 Jan 2024 12:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qkSTBs3V"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE9EF4E6
	for <kvm@vger.kernel.org>; Mon, 15 Jan 2024 12:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 15 Jan 2024 13:44:17 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705322660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MwtEWLAXam/IycH3fliQdB9hc+Fa+3tIJSxCSLpGklg=;
	b=qkSTBs3VJnpyVeSfr53o+AUoEBfoa5dlIRd+6kIoAVDl8WIuSCQd77yD7dHnO6r3aksh+g
	OtddvsEWRILNOTNVjzpmeGn50EtxIftBx+29mCVpTVmGAxMBvvQQJrm1s9MV2LwKdIhhk5
	XxQ2ie+A3NvnwIF2Tfp5s7zyl1rQIV8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: kvmarm@lists.linux.dev, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Nikos Nikoleris <nikos.nikoleris@arm.com>, Eric Auger <eric.auger@redhat.com>, 
	Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>, Nico Boehr <nrb@linux.ibm.com>, 
	David Woodhouse <dwmw@amazon.co.uk>, Nadav Amit <namit@vmware.com>, kvm@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org
Subject: Re: [kvm-unit-tests PATCH v1 01/18] Makefile: Define __ASSEMBLY__
 for assembly files
Message-ID: <20240115-0c41f7d4aa09b7b82613faa8@orel>
References: <20231130090722.2897974-1-shahuang@redhat.com>
 <20231130090722.2897974-2-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130090722.2897974-2-shahuang@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 30, 2023 at 04:07:03AM -0500, Shaoqin Huang wrote:
> From: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> There are 25 header files today (found with grep -r "#ifndef __ASSEMBLY__)
> with functionality relies on the __ASSEMBLY__ prepocessor constant being
> correctly defined to work correctly. So far, kvm-unit-tests has relied on
> the assembly files to define the constant before including any header
> files which depend on it.
> 
> Let's make sure that nobody gets this wrong and define it as a compiler
> constant when compiling assembly files. __ASSEMBLY__ is now defined for all
> .S files, even those that didn't set it explicitely before.
> 
> Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>  Makefile           | 5 ++++-
>  arm/cstart.S       | 1 -
>  arm/cstart64.S     | 1 -
>  powerpc/cstart64.S | 1 -
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 602910dd..27ed14e6 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -92,6 +92,9 @@ CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
>  
>  autodepend-flags = -MMD -MP -MF $(dir $*).$(notdir $*).d
>  
> +AFLAGS  = $(CFLAGS)
> +AFLAGS += -D__ASSEMBLY__
> +
>  LDFLAGS += -nostdlib $(no_pie) -z noexecstack
>  
>  $(libcflat): $(cflatobjs)
> @@ -113,7 +116,7 @@ directories:
>  	@mkdir -p $(OBJDIRS)
>  
>  %.o: %.S
> -	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
> +	$(CC) $(AFLAGS) -c -nostdlib -o $@ $<

I think we can drop the two hunks above from this patch and just rely on
the compiler to add __ASSEMBLY__ for us when compiling assembly files.

Thanks,
drew

>  
>  -include */.*.d */*/.*.d
>  
> diff --git a/arm/cstart.S b/arm/cstart.S
> index 3dd71ed9..b24ecabc 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -5,7 +5,6 @@
>   *
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
> -#define __ASSEMBLY__
>  #include <auxinfo.h>
>  #include <asm/assembler.h>
>  #include <asm/thread_info.h>
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index bc2be45a..a8ad6dc8 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -5,7 +5,6 @@
>   *
>   * This work is licensed under the terms of the GNU GPL, version 2.
>   */
> -#define __ASSEMBLY__
>  #include <auxinfo.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/assembler.h>
> diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
> index 34e39341..fa32ef24 100644
> --- a/powerpc/cstart64.S
> +++ b/powerpc/cstart64.S
> @@ -5,7 +5,6 @@
>   *
>   * This work is licensed under the terms of the GNU LGPL, version 2.
>   */
> -#define __ASSEMBLY__
>  #include <asm/hcall.h>
>  #include <asm/ppc_asm.h>
>  #include <asm/rtas.h>
> -- 
> 2.40.1
> 


Return-Path: <kvm+bounces-45141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F2AA6AA6280
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 19:47:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C03B9C15BE
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:47:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29CD2219307;
	Thu,  1 May 2025 17:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V0eBjt97"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B331D54C0
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 17:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746121639; cv=none; b=psIkFkrpCJrPEUMQ8CPzz/fKiuEkC+ftCmGKcDqhzkojcHm2evaq0oBy0ECa1e6JVdl5UEFRHQgT2OJgOPx2/yyXtYigUWUtcADb/gNUjk/fW9fm4Xvo9QWg7agOPsYiDW68NQSkxx9XxLDvAojipDEOZ+HiHF6M3PhlZekONe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746121639; c=relaxed/simple;
	bh=8CYNr7jwQ4a4CMR5vuiV2x5yz24sN9o/69jVH3RA9AE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q/KThDhL91E9mhINEeBRFgGmBQqxySBYohK49ge6xsQgmCf/kFJMLtg13Icy5iPIDlTRSzzsjKssi7Ffp+BCCvCqdMRN8bWmUuWZDkHoo46xLNzFaqRS1XIl9JU+vdUqFDPD3xC67SRGyj/qjB1L8itgS2s5l24hHzhx0LP1yG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V0eBjt97; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-225477548e1so14413215ad.0
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 10:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746121637; x=1746726437; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0JgrpjyIVurw8ZnhExu0OpjTLOaTTcXOTASTKpgw31Y=;
        b=V0eBjt97aQscdJesMkhGTg1uXx9uuiyvK3XPFRn8k6pLmhdyvaosByy87mwk8i5dGM
         oAscIKJ9XxEjDSujal0LU3v44+UQ/5Krjz2/DhLJN/W2y//g1+SjTmMfglB73mnVaydx
         F0o9dVE7si7zRRx9pFu5pCRJoaJLa+fMM51sXvM6Bk+EkSHAo54tVE9+waCZqGO0kwoJ
         CtvVtFZwOw6/bHlhx6x/mFVhrAqdq0WsW07pVf5pVwrRIBvLg+5rN4O7cZcUyuMO3la7
         //DDJNlRx45XEDne/t+zb0iPAb7hbnkcpNS6BM7EcSNYGNpH1Zofyr3UkE0/Tvm2x6vG
         hHdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746121637; x=1746726437;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0JgrpjyIVurw8ZnhExu0OpjTLOaTTcXOTASTKpgw31Y=;
        b=ag/1w1OtWzpV5NI6mdiseCMEx210Qtrc46lZxVGeL9y+NWCfeQR+kVHZqHs7IkCc69
         2lGtpoVU4pxqvvkjQrLyyV8irn6gaJlYY8Soz/KGLxj/dZtISAXICPDZV7+fUT73fraK
         4zTn0iJghBgpDH4RLpxkt37yZcV9AX9RuWnrCh1ztq/4kCwtoyvMQH8S211LVb0Luspl
         24pcSXGm9XPXhM1uRbi1e1iWWYEXDE+4RzhuWjmjrP8cyl+JXHmof8HdHXBkUM7ODMhb
         Ke3giJqam4huIaPXVlYDAV3kIFIzI8XKl0w8LaLd3xI4qoeLE3OB20WR2o5gCGfqnO3C
         ZuRA==
X-Forwarded-Encrypted: i=1; AJvYcCWUqinEHMBiGySxCSbBUTfhW9FB4+I5F49p96VBcpxXgUmzpDHuq1WAgYcLkr4n8GMNhj0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXhHwndVyp5vVT9bzeYhRs19086HV0eHqdZ3OFuKRLY8GN5MvO
	3HWqpchAkCKgwQPVLivxAMbTwcRthvxq7+PZrhid85fFHj91K+qfZpAGvJt0uw==
X-Gm-Gg: ASbGncuDA798W4MpUQzRZsQEJ301u0cui33ECqh+nWWUULo/T0VAZ8kU+EWPrYp6EIK
	I+ePaBdKv4YXAkSzbfTlKhfp63K3+GuYHx0OUZ6mZakuWDQ4XcP49WruF6rdqn0x8sWH5LgEcPv
	6ajCHPsypVg5a1XKgasjRuK1qA8hApBUxxGMXSYTJTShtLYxjVjIpxtyYxao8qo9+VLntN+nITZ
	MaOH2hjSVYjhyxkT+/zlHcDwqbjG+58VKOwlBkYTm7DO5IXst8ilJODs7tyzyiFg3CRQnySkgvo
	d9bainbrezhdYfZGf/toNmO+Z7Vrb2LNMCM112u8Ue5FAivZHybTjaFjrt3wZKFDeyt9O+Z9Kdh
	rEoGn3Wo5PIq43Q==
X-Google-Smtp-Source: AGHT+IG3mPJyDPXGVidQgks96nF8i3OAf1xC+gtDnCesF+Inf4BO1ZhItOBTJP8wGyJkHDf9fzb1qA==
X-Received: by 2002:a17:903:1249:b0:22c:35c5:e30a with SMTP id d9443c01a7336-22e08424dcfmr54803565ad.16.1746121636607;
        Thu, 01 May 2025 10:47:16 -0700 (PDT)
Received: from google.com (30.240.118.34.bc.googleusercontent.com. [34.118.240.30])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e0bb0e158sm9676965ad.67.2025.05.01.10.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 10:47:15 -0700 (PDT)
Date: Thu, 1 May 2025 10:47:10 -0700
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Sean Christopherson <seanjc@google.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	kvm@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH] KVM: selftests: Use $(SRCARCH) instead of $(ARCH)
Message-ID: <aBOznhkrLZ0Z_3Xw@google.com>
References: <20250430224720.1882145-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430224720.1882145-1-dmatlack@google.com>

On 2025-04-30 03:47 PM, David Matlack wrote:
> Use $(SRCARCH) in Makefile.kvm instead of $(ARCH). The former may have
> been set on the command line and thus make will ignore the variable
> assignment to convert x86_64 to x86.
> 
> Introduce $(SRCARCH) rather than just reverting commit 9af04539d474
> ("KVM: selftests: Override ARCH for x86_64 instead of using ARCH_DIR")
> to keep KVM selftests consistent with the top-level kernel Makefile,
> which uses $(SRCARCH) for the exact same purpose.
> 
> While here, drop the comment about the top-level selftests allowing
> ARCH=x86_64. The kernel itself allows/expects ARCH=x86_64 so it's
> reasonable to expect the KVM selftests to handle it as well.
> 
> Fixes: 9af04539d474 ("KVM: selftests: Override ARCH for x86_64 instead of using ARCH_DIR")
> Signed-off-by: David Matlack <dmatlack@google.com>

If this approach seems reasonable I can also send another patch to share
the definitions of $(ARCH) and $(SRCARCH) with the top-level Makefile so
that we don't need any custom Makefile code in KVM selftests for this.

e.g.

From: David Matlack <dmatlack@google.com>
Date: Thu, 1 May 2025 10:30:26 -0700
Subject: [PATCH v2] kbuild: Share $(ARCH) and $(SRCARCH) with tools/

Pull out the definitions for $(ARCH), $(SRCARCH), and $(SUBARCH) into a
scripts/arch.include and use it to reduce duplication in Makefiles under
tools/.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 Makefile                                  | 28 +++--------------------
 scripts/{subarch.include => arch.include} | 24 +++++++++++++++++++
 tools/include/nolibc/Makefile             |  5 +---
 tools/testing/selftests/Makefile          |  3 +--
 tools/testing/selftests/kvm/Makefile      |  8 +------
 tools/testing/selftests/nolibc/Makefile   |  5 +---
 6 files changed, 31 insertions(+), 42 deletions(-)
 rename scripts/{subarch.include => arch.include} (61%)

diff --git a/Makefile b/Makefile
index c91afd55099e..7a10252ddbe1 100644
--- a/Makefile
+++ b/Makefile
@@ -380,8 +380,6 @@ KERNELRELEASE = $(call read-file, $(objtree)/include/config/kernel.release)
 KERNELVERSION = $(VERSION)$(if $(PATCHLEVEL),.$(PATCHLEVEL)$(if $(SUBLEVEL),.$(SUBLEVEL)))$(EXTRAVERSION)
 export VERSION PATCHLEVEL SUBLEVEL KERNELRELEASE KERNELVERSION
 
-include $(srctree)/scripts/subarch.include
-
 # Cross compiling and selecting different set of gcc/bin-utils
 # ---------------------------------------------------------------------------
 #
@@ -400,32 +398,12 @@ include $(srctree)/scripts/subarch.include
 # Alternatively CROSS_COMPILE can be set in the environment.
 # Default value for CROSS_COMPILE is not to prefix executables
 # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile
-ARCH		?= $(SUBARCH)
+
+# Import definitions for SUBARCH, ARCH, and SRCARCH.
+include $(srctree)/scripts/arch.include
 
 # Architecture as present in compile.h
 UTS_MACHINE 	:= $(ARCH)
-SRCARCH 	:= $(ARCH)
-
-# Additional ARCH settings for x86
-ifeq ($(ARCH),i386)
-        SRCARCH := x86
-endif
-ifeq ($(ARCH),x86_64)
-        SRCARCH := x86
-endif
-
-# Additional ARCH settings for sparc
-ifeq ($(ARCH),sparc32)
-       SRCARCH := sparc
-endif
-ifeq ($(ARCH),sparc64)
-       SRCARCH := sparc
-endif
-
-# Additional ARCH settings for parisc
-ifeq ($(ARCH),parisc64)
-       SRCARCH := parisc
-endif
 
 export cross_compiling :=
 ifneq ($(SRCARCH),$(SUBARCH))
diff --git a/scripts/subarch.include b/scripts/arch.include
similarity index 61%
rename from scripts/subarch.include
rename to scripts/arch.include
index c4592d59d69b..545f731140df 100644
--- a/scripts/subarch.include
+++ b/scripts/arch.include
@@ -11,3 +11,27 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
 				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
 				  -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ \
 				  -e s/riscv.*/riscv/ -e s/loongarch.*/loongarch/)
+
+ARCH		?= $(SUBARCH)
+SRCARCH 	:= $(ARCH)
+
+# Additional ARCH settings for x86
+ifeq ($(ARCH),i386)
+        SRCARCH := x86
+endif
+ifeq ($(ARCH),x86_64)
+        SRCARCH := x86
+endif
+
+# Additional ARCH settings for sparc
+ifeq ($(ARCH),sparc32)
+       SRCARCH := sparc
+endif
+ifeq ($(ARCH),sparc64)
+       SRCARCH := sparc
+endif
+
+# Additional ARCH settings for parisc
+ifeq ($(ARCH),parisc64)
+       SRCARCH := parisc
+endif
diff --git a/tools/include/nolibc/Makefile b/tools/include/nolibc/Makefile
index f9702877ac21..9a78fe77205f 100644
--- a/tools/include/nolibc/Makefile
+++ b/tools/include/nolibc/Makefile
@@ -8,10 +8,7 @@ srctree := $(patsubst %/tools/include/,%,$(dir $(CURDIR)))
 endif
 
 # when run as make -C tools/ nolibc_<foo> the arch is not set
-ifeq ($(ARCH),)
-include $(srctree)/scripts/subarch.include
-ARCH = $(SUBARCH)
-endif
+include $(srctree)/scripts/arch.include
 
 # OUTPUT is only set when run from the main makefile, otherwise
 # it defaults to this nolibc directory.
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index c77c8c8e3d9b..827ce9bf3e50 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -190,8 +190,7 @@ else
 endif
 
 # Prepare for headers install
-include $(top_srcdir)/scripts/subarch.include
-ARCH           ?= $(SUBARCH)
+include $(top_srcdir)/scripts/arch.include
 export BUILD
 export KHDR_INCLUDES
 
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 02bf061c51f8..503530d671e9 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -1,13 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 top_srcdir = ../../../..
 
-include $(top_srcdir)/scripts/subarch.include
-ARCH 	?= $(SUBARCH)
-SRCARCH := $(ARCH)
-
-ifeq ($(ARCH),x86_64)
-        SRCARCH := x86
-endif
+include $(top_srcdir)/scripts/arch.include
 
 ifeq ($(SRCARCH),$(filter $(SRCARCH),arm64 s390 riscv x86))
 include Makefile.kvm
diff --git a/tools/testing/selftests/nolibc/Makefile b/tools/testing/selftests/nolibc/Makefile
index 58bcbbd029bc..13555d418c78 100644
--- a/tools/testing/selftests/nolibc/Makefile
+++ b/tools/testing/selftests/nolibc/Makefile
@@ -18,10 +18,7 @@ else
 objtree ?= $(srctree)
 endif
 
-ifeq ($(ARCH),)
-include $(srctree)/scripts/subarch.include
-ARCH = $(SUBARCH)
-endif
+include $(srctree)/scripts/arch.include
 
 cc-option = $(call __cc-option, $(CC),$(CLANG_CROSS_FLAGS),$(1),$(2))
 

base-commit: 45eb29140e68ffe8e93a5471006858a018480a45
prerequisite-patch-id: 3bae97c9e1093148763235f47a84fa040b512d04
-- 
2.49.0.906.g1f30a19c02-goog



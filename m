Return-Path: <kvm+bounces-59454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 571ABBB5FCA
	for <lists+kvm@lfdr.de>; Fri, 03 Oct 2025 08:39:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 45E414E18C2
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 06:39:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB66B212F89;
	Fri,  3 Oct 2025 06:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zSQupMJu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B07F19258E
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 06:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759473579; cv=none; b=Ric2cMX12UVlL+XhWiKnRDYTTvLhPl3FwNtrQVoco5C8rSZff3dXxlgC8xuQh5twHsCVdYSx6AuY/PhjYP0uZjkCOXESZZ0ywAMRQAd2XQOg/Bsapu1MoOZhDkSEMANAOEwXW+A9+Bj1/Se/I/YGoRq0dHCg2QjAQLUXALOupNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759473579; c=relaxed/simple;
	bh=LX/Y9FMJvTjkJ9jsE2wR6/osViFePVkZkwtJLD4RsZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M0liQArpGcjymqa+9P8aWKq+B4h9GHHKYQqEC0EA3OmVL644fDFNGqCKc4hs7pctzi9b4xrAfOdY9KEJFPi082vPa6TsGIzdMmnAevwKadXqiZ2AzgYBRnuDJG7IQv0qaPJjCgJjy5cfzkP47JD+yqD6aXTfAYntwAxrQFnH3Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zSQupMJu; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-27d67abd215so147325ad.0
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 23:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759473577; x=1760078377; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7NUJR+0x4Extu7PhnW8nn0TsoPMkUfDkUjklFIsZ2dE=;
        b=zSQupMJudXgotq2lJXfnBjSUaTNfZqnjmWxQmYX7giUj5INoEKKxyb5NuAPEKVtMDW
         GIR9pXrlfS6JbNLSASUsYPuOl9XvLx6V7QKHO51cLHYcs52Q7IE/Q696it0GY1E4wsVO
         a61eswufM0B+1bH1B6k7Xn5dSmcSM6WacDQT8SA4H31P/XJQy7eeHNCHZry52Mx/NGF4
         JXr96wgRtX84EMtLERT3WJYRNWLElJadX5Y03C0XBP73goxufgIIX1S65ssGB/Dhhn1o
         f+OhpJzaFyQzV8QD+cyAzD/lgff3bfpmKi2G8r9RSgICezgaUjNZFa+pyCAuZ6Ig+gIf
         oLXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759473577; x=1760078377;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7NUJR+0x4Extu7PhnW8nn0TsoPMkUfDkUjklFIsZ2dE=;
        b=Bedj/T/5NdqX6FyZW6UKnlaKj6vwE2W8RGXTyh2W7Jck4bYGct5RwmJFL5cShjQaR1
         PHdyn8rtNIAfrWiMrxRY0/paHoGWGRUSFtXJEBYTJ7EmvIVF4t/pMjeS2LN4icb3sIQM
         n+4WXLnBVMG+bw+OJqRRjO7UkZgGZE6lXwW+jKINzI5x/CSBXcAPILF1ydtwYp29alDk
         pdYiSMl/2bE860ARpQxBPbZtdG96kY/LGoeJIdpdr7LYvoEbuJKMKxxWqOrj2Y1TLa5i
         P8HZUpII4ZeBZf3YGy3634pRMhcAhI/P1KfNow8DPyWZabRP9FF97NLRpLY4IL6ygKuq
         7R9g==
X-Gm-Message-State: AOJu0Yxu00m8k4V32kMFv9cc1+CSnfYDdH9vzNdygE/9FMTVvSPqByZV
	Geycv5DNCJQZ98+/2CMjkkL++tM1WO68ahV2HlpwwopiPu/PVLvtY09C1n5vkGAWNQ==
X-Gm-Gg: ASbGnctgJ2o1agWJmHnJYitQdd+Mob+fywEluzvjjebnCdm0P84qu1XJHV3w4M1vyVA
	KE2oI/WJ6ssMcJQlVm6yO3g1ZiarHB3NebVIqDCEHNoNJ/yLekO3pRAlXQSdysnH/QeqpaNI1yo
	LXO615u7bJR0PFcGcPcbne9O7ukCjxft6NdUg7w3or6eXPHo8Jffye9qnabIIPMX8HEC8KW8ccU
	ksdK7FhJaEC7LBrh5wAN0zNte7MxCeSXVuAMD2nkjzfcuucFkLeOBu6lEt6wmRN3gWO/lNB7e1V
	nIyaATG8kJoLHCqFkXE7hKKLf0NPLxoMio8GxN5FM/zbl3mQsOoWwF3xqGtQNgVAzBJ9l5UiDw0
	blj6hYawEtQPTBseHOTKRk366d1I+iFhH6t0L5/eyEFC9FiuN7pztJVd/GZ2PZpRhKV9vFSMGTl
	1mPJl3icSFDsC73A==
X-Google-Smtp-Source: AGHT+IF225ruxuMkKqMzIY2DU6axi9BegMmyzKVEb8CRf18y/aWsRDvWSU7iRPoYcjDxe3FPYwAwQQ==
X-Received: by 2002:a17:903:3c2e:b0:268:cc5:5e44 with SMTP id d9443c01a7336-28e9a558cd2mr2630335ad.6.1759473576553;
        Thu, 02 Oct 2025 23:39:36 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d1ba024sm39044885ad.68.2025.10.02.23.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Oct 2025 23:39:35 -0700 (PDT)
Date: Thu, 2 Oct 2025 23:39:31 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org, seanjc@google.com,
	pbonzini@redhat.com, borntraeger@linux.ibm.com,
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org,
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn,
	chenhuacai@kernel.org, oliver.upton@linux.dev,
	ajones@ventanamicro.com
Subject: Re: [PATCH v3 9/9] KVM: selftests: Provide README.rst for KVM
 selftests runner
Message-ID: <20251003063931.GA1130776.vipinsh@google.com>
References: <20250930163635.4035866-1-vipinsh@google.com>
 <20250930163635.4035866-10-vipinsh@google.com>
 <86qzvnypsp.wl-maz@kernel.org>
 <20251001173225.GA420255.vipinsh@google.com>
 <86a529z7qh.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86a529z7qh.wl-maz@kernel.org>

On 2025-10-02 15:41:26, Marc Zyngier wrote:
> On Wed, 01 Oct 2025 18:32:25 +0100,
> Vipin Sharma <vipinsh@google.com> wrote:
> > 
> > On 2025-10-01 09:44:22, Marc Zyngier wrote:
> > 
> > > > +in `default.test` files. Each KVM selftest will have a directory in  which
> > > > +`default.test` file will be created with executable path relative to KVM
> > > > +selftest root directory i.e. `/tools/testing/selftests/kvm`.
> > > 
> > > Shouldn't this honor the existing build output directives? If it
> > > actually does, then you want to call this out.
> > > 
> > 
> > To generate default test files in a specific directory one can use
> > "OUTPUT" in the make command
> 
> The standard way to do this is documented in the top level Makefile:
> 
> <quote>
> # This does not need to match to the root of the kernel source tree.
> #
> # For example, you can do this:
> #
> #  cd /dir/to/store/output/files; make -f /dir/to/kernel/source/Makefile
> #
> # If you want to save output files in a different location, there are
> # two syntaxes to specify it.
> #
> # 1) O=
> # Use "make O=dir/to/store/output/files/"
> #
> # 2) Set KBUILD_OUTPUT
> # Set the environment variable KBUILD_OUTPUT to point to the output directory.
> # export KBUILD_OUTPUT=dir/to/store/output/files/; make
> #
> # The O= assignment takes precedence over the KBUILD_OUTPUT environment
> # variable.
> </quote>
> 
> Your new infrastructure should support the existing mechanism (and
> avoid introducing a new one).
> 

Options "O" and "KBUILD_OUTPUT" are not supported by KVM makefile. I
tried running below commands in KVM selftest directory

  make O=~/some/dir
  make KBUILD_OUTPUT=~/some/dir

Both of the command generate output in the KVM selftest directory. So,
my new Makefile rule "tests_install" is behaving as per the current KVM
behavior.

However, building through kselftest Makefile do support "O" and
"KBUILD_OUTPUT". For example, if we are in kernel root directory,

  make O=~/some/dir -C tools/testing/selftests TARGETS=kvm

now output binaries will be generated in ~/some/dir. To make testcases
also be generated in the output directory below change is needed. 

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 6bb63f88c0e6..a2b5c064d3a3 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 include ../../../build/Build.include
 
-all:
+all: tests_install
 
 LIBKVM += lib/assert.c
 LIBKVM += lib/elf.c
@@ -358,4 +358,7 @@ tests_install:
        $(foreach tc, $(list_progs), \
                $(shell echo $(tc) > $(patsubst %,$(OUTPUT)/$(DEFAULT_TESTCASES)/%/default.test,$(tc))))
 
+       @if [ ! -d $(OUTPUT)/runner ]; then             \
+               cp -r $(selfdir)/kvm/runner $(OUTPUT);  \
+       fi
        @:

Since testcases by themselves will not be useful, I have updated the
rule in the above diff to copy runner code as well to the output directory.

I think this brings my changes to honor existing build output
directives. Let me know if this needs some fixes.


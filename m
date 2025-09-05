Return-Path: <kvm+bounces-56866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E56BB45153
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 10:27:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A3C0F1C213FF
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 08:27:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 707F03002D1;
	Fri,  5 Sep 2025 08:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fMTrjYKz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FEB2EBDC7
	for <kvm@vger.kernel.org>; Fri,  5 Sep 2025 08:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757060821; cv=none; b=hvH53sMUReFtDqAwHmL4BJMRo++zcdCFsFks2URMZ6B0Xra7NcidRp7GRP2DdmLO+lXf/rZMdN5Dxm20cqJJnD2PvRFDOBPWjZWjIe2qqXmaZC8j565Li3dKXyj3TdAYVWPJcIi9rxXkRVu5vlHHHG/MyK5Cq0KWGlwgNoYc3/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757060821; c=relaxed/simple;
	bh=lfd706inqHgUNkUv4cM1rwd+iMtrwbG7mvles237frA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UQaTVo27L271nao/G+66ocLZQJ+v9VdkCZafL565VYqOIWb6hm45FDPX0XlsETle/hSC0qj7yHfZPxuOzFK7ZvvxkdZCP4q+fozNHw1FD5ImOebAcwwWW3Wi/qv52N8EoQwIjkbNYdKP4qDqy+14OAKtyjSv/EfWVqjrArsvPzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fMTrjYKz; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b4f9d61e7deso1240029a12.2
        for <kvm@vger.kernel.org>; Fri, 05 Sep 2025 01:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757060819; x=1757665619; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nHK9iI85iqWO4V8vX9Oo3GoxZBQpdXBS4cUBp8iEWm8=;
        b=fMTrjYKzDm66Aj24sHjLyLqTA+8ro4oiz2BbERrZXMmeo2H3ix56vvP+GSgfdu1YRy
         3uov3avJSjJ6PUOiP9dYJUH3K9epkSPSGkyjinJwwQreRs+fCKuQTzjv/ov4Twrk0MXP
         kQT7YnJHgF498x7QFohdztn6f5oI/KzEq88gZrG9M+Vebc+6i/75OKyZOgBSOU4MS5VC
         nF0P3Dk6NqTIFGDnma9SIHW7vcfWuUM+i60TpCciiTYAQTJWUV5ZRi9J3r8OJq1EeX4d
         uwKiQCXGYepl7anO/P5NnLKB+NmvVMw3NoEHXq5R3H/ZW978HXK6aUAKoPLE+odOXjzr
         zYMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757060819; x=1757665619;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nHK9iI85iqWO4V8vX9Oo3GoxZBQpdXBS4cUBp8iEWm8=;
        b=rSqG5uSzQjD9MfoqH3W2R097WspvGTXgPUgIddQPrSr2DomLR0AHYu3PSs7ZDKpkmA
         SoH40DojJYoRcQ5cWkLkga9i4sslb/TWFBzsRIxj+W5CI61tq5/WveJpvbUWtgeUAZqr
         jte7f1UVrg2Pu1YlnpBzZ8dBW9UN40e+0i7YflTtpSjiA4BHm+xhlU1g62dRNJgcxlhh
         H/Z+GEuWPkQUohVsBSDoImWB79QOx2qNNQuPxf2fS6eDzG+hq6Ihx5xpJfLERRT3g+Kl
         ZiDrFTeXAAHLYoZL7nJETuc5c2abO3nS3QgZBz0gzgtWykLmX15fzUOwUdfpNTzuZR1B
         6vLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhe9Y1VkQIYnAZ/4zCuAiRGY5YrYTPeAl8xxrH4tzXW757U0mezZ8SqO08CQRGfP4O3cA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpfU3JYpxjN41WcYmMVVbaZKYPFIx3ddttTk/4LVhtuzqTUPpC
	VW4XojKMKfoG9JvIWFkvxF/CFJtVwqWCJJp7CZ76dyRNiKlTFGnG44P0eqiSME1a
X-Gm-Gg: ASbGncu1NTHhVmdQMUwBeBwnDRrX8s+xRd6HtLRTQFoBNHERd2d/FCEd/azhMAPLLdr
	mEHjqp0+pVIE5fd1gHNrOKSMw0IkRekBnJV/xA+XkrIX9QLyvjHe9JYm8aFOdiq/5Io9oThr9ot
	cd8sJOGXKfGsHYHrm4JX/w5D/f9LGmniOwJgyU0VzwJuatoGPl+AbqtthQzeoaAXrqxvbABv4/h
	qT4nr17FUxc25TqewbvAruP6+iMaLi2ArMBFIY3k9fAIOgH7+6si1yXQRs7Rajad6ezUWHPvV9k
	K0WX8qnPyPPpxzNL91eNVWKdTKluH6nFsjX/8xuRkSks9K2oYREGFzUzlzVMqAWnJGjIRgS273x
	qgBTiL/EL4Dkf9Ci+3TXRvZ8=
X-Google-Smtp-Source: AGHT+IHP1juca3+Y9QGg8ZDy2o9SXnqJ9FRyMR+yGWiDytyQnru5S55L09mGQxTToFAfMA1iFcloFg==
X-Received: by 2002:a17:903:ac8:b0:240:52c8:2552 with SMTP id d9443c01a7336-24944ae192cmr283713095ad.43.1757060819170;
        Fri, 05 Sep 2025 01:26:59 -0700 (PDT)
Received: from localhost ([1.146.99.18])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-249144837fcsm199812975ad.15.2025.09.05.01.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 01:26:58 -0700 (PDT)
Date: Fri, 5 Sep 2025 18:26:55 +1000
From: Nicholas Piggin <npiggin@gmail.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Joel Stanley <joel@jms.id.au>, kvm-riscv@lists.infradead.org, 
	Buildroot Mailing List <buildroot@buildroot.org>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests] riscv build failure
Message-ID: <csh2fzymze636erajmsu5d55id6fpfsnvypkz3at7anp5i35uw@fhn2qgz327vj>
References: <CACPK8XddfiKcS_-pYwG5b7i8pwh7ea-QDA=fwZgkP245Ad9ECQ@mail.gmail.com>
 <20250904-11ba6fa251f914016170c0e4@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904-11ba6fa251f914016170c0e4@orel>

On Thu, Sep 04, 2025 at 05:17:45PM -0500, Andrew Jones wrote:
> On Thu, Sep 04, 2025 at 08:57:54AM +0930, Joel Stanley wrote:
> > I'm building kvm-unit-tests as part of buildroot and hitting a build
> > failure. It looks like there's a missing dependency on
> > riscv/sbi-asm.S, as building that manually fixes the issue. Triggering
> > buildroot again (several times) doesn't resolve the issue so it
> > doesn't look like a race condition.
> > 
> > I can't reproduce with a normal cross compile on my machine. Buildroot
> > uses make -C, in case that makes a difference.
> > 
> > The build steps look like this:
> > 
> > bzcat /localdev/jms/buildroot/dl/kvm-unit-tests/kvm-unit-tests-v2025-06-05.tar.bz2
> > | /localdev/jms/buildroot/output-riscv-rvv/host/bin/tar
> > --strip-components=1 -C
> > /localdev/jms/buildroot/output-riscv-rvv/build/kvm-unit-tests-2025-06-05
> >   -xf -
> > cd /localdev/jms/buildroot/output-riscv-rvv/build/kvm-unit-tests-2025-06-05
> > && ./configure --disable-werror --arch="riscv64" --processor=""
> > --endian="little"
> > --cross-prefix="/localdev/jms/buildroot/output-riscv-rvv/host/bin/riscv64-buildroot-linux-gnu-"
> > GIT_DIR=. PATH="/localdev/jms/buildroot/output-riscv-rvv/host/bin:/localdev/jms/buildroot/output-riscv-rvv/host/sbin:/home/jms/.local/bin:/home/jms/bin:/home/jms/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
> > /usr/bin/make -j385  -C
> > /localdev/jms/buildroot/output-riscv-rvv/build/kvm-unit-tests-2025-06-05
> > standalone
> 
> I applied similar steps but couldn't reproduce this. It also looks like we
> have a dependency because configuring with '--cc=/path/to/mygcc', where
> mygcc is
> 
>    #!/bin/bash
>    for x in $@; do
>        if [[ $x =~ sbi-asm ]] && ! [[ $x =~ sbi-asm-offsets ]]; then
>            sleep 5
>            break
>        fi
>    done
>    /path/to/riscv64-linux-gnu-gcc $@
> 
> stalls the build 5 seconds when compiling sbi-asm.S but doesn't reproduce
> the issue. That said, running make with -d shows that riscv/sbi-asm.o is
> an implicit prerequisite, although so are other files. I'm using
> GNU Make 4.4.1. Which version are you using?
> 
> Also, while the steps above shouldn't cause problems, they are a bit odd
>  * '--endian' only applies to ppc64
>  * -j385 is quite large and specific. Typicall -j$(nproc) is recommended.
>  * No need for '-C "$PWD"'

Thanks for taking a look, it's Make 4.2.1 at least. I tracked it down
to second expansion barfing when the variable name has a / in it. It
looks like it can be fixed with the below, so I didn't look too closely
at whether that's a bug, in what versions, or not previously supported
because I was able to fix it like this.

Thanks,
Nick

    build: work around second expansion limitation with some Make versions
    
    GNU Make 4.2.1 as shipped in Ubuntu 20.04 has a problem with secondary
    expansion and variable names containing the '/' character. Make 4.3 and
    4.4 don't have the problem.
    
    Avoid putting the riscv/ directory name in the sbi-deps variable, and
    instead strip the directory off the target name when turning it into
    the dependency variable name.

diff --git a/riscv/Makefile b/riscv/Makefile
index beaeaefa..64720c38 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -18,12 +18,12 @@ tests += $(TEST_DIR)/isa-dbltrp.$(exe)
 
 all: $(tests)
 
-$(TEST_DIR)/sbi-deps += $(TEST_DIR)/sbi-asm.o
-$(TEST_DIR)/sbi-deps += $(TEST_DIR)/sbi-dbtr.o
-$(TEST_DIR)/sbi-deps += $(TEST_DIR)/sbi-fwft.o
-$(TEST_DIR)/sbi-deps += $(TEST_DIR)/sbi-sse.o
+sbi-deps += $(TEST_DIR)/sbi-asm.o
+sbi-deps += $(TEST_DIR)/sbi-dbtr.o
+sbi-deps += $(TEST_DIR)/sbi-fwft.o
+sbi-deps += $(TEST_DIR)/sbi-sse.o
 
-all_deps += $($(TEST_DIR)/sbi-deps)
+all_deps += $(sbi-deps)
 
 # When built for EFI sieve needs extra memory, run with e.g. '-m 256' on QEMU
 $(TEST_DIR)/sieve.$(exe): AUXFLAGS = 0x1
@@ -113,7 +113,7 @@ cflatobjs += lib/efi.o
 .PRECIOUS: %.so
 
 %.so: EFI_LDFLAGS += -defsym=EFI_SUBSYSTEM=0xa --no-undefined
-%.so: %.o $(FLATLIBS) $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds $(cstart.o) %.aux.o $$($$*-deps)
+%.so: %.o $(FLATLIBS) $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds $(cstart.o) %.aux.o $$($$(notdir $$*)-deps)
 	$(LD) $(EFI_LDFLAGS) -o $@ -T $(SRCDIR)/riscv/efi/elf_riscv64_efi.lds \
 		$(filter %.o, $^) $(FLATLIBS) $(EFI_LIBS)
 
@@ -129,7 +129,7 @@ cflatobjs += lib/efi.o
 		-O binary $^ $@
 else
 %.elf: LDFLAGS += -pie -n -z notext
-%.elf: %.o $(FLATLIBS) $(SRCDIR)/riscv/flat.lds $(cstart.o) %.aux.o $$($$*-deps)
+%.elf: %.o $(FLATLIBS) $(SRCDIR)/riscv/flat.lds $(cstart.o) %.aux.o $$($$(notdir $$*)-deps)
 	$(LD) $(LDFLAGS) -o $@ -T $(SRCDIR)/riscv/flat.lds \
 		$(filter %.o, $^) $(FLATLIBS)
 	@chmod a-x $@


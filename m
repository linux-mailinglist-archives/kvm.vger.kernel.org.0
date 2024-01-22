Return-Path: <kvm+bounces-6572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C392837617
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 23:29:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D85FE2871BE
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 22:29:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF4BB48CFA;
	Mon, 22 Jan 2024 22:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dMchy/Rf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D829E48CED
	for <kvm@vger.kernel.org>; Mon, 22 Jan 2024 22:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705962561; cv=none; b=rmgKiCS8gparDoNoQlqpkO7i975Vj5I4SQdVi/SS3x68lifAKHRvZtfAB3GUmYI+8EULVPdumGAQH7Mu97cY2fNhWQ+X0/I3Ss3ibB7ldKz1IWeyA3Q5fDtKcX4W4FT/qCxCc6gRt8vliKRqqKD5VSMJsx9LCvPojZAk2n1sNcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705962561; c=relaxed/simple;
	bh=SzMBFscYInjce3MfAW+sb2rLG2n6/of69bzdv5vOW14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5kAIUfCB97OeyK7+FTnTOXT0n5SDySr0fEMa/sfwdjhR+Agjiv2Zf8dMwMpO0mlUMKvOxzAtlwJI9ACEAVmSKjU+rnUFbN5k8D3/ZNP1j/aj/QlzdIHPfprRMLzW9RPV+ocXBHqjaRUu5Rh7Yc0MuYdLgr0/cq/bUWmUoWEG5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dMchy/Rf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865A6C433C7;
	Mon, 22 Jan 2024 22:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705962561;
	bh=SzMBFscYInjce3MfAW+sb2rLG2n6/of69bzdv5vOW14=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dMchy/Rf9B+AKr9VeXlzlsL6EuRsF8+t4y2i9zArOvInNAcNZGljBYCFS7seY+eOW
	 MvCWiN/QHRKLtotKn2o0Mz9KPjWnSeOzdOFrTNtEzcpFOQF/xt2/l8XSiV4dKKVGvQ
	 XABJJPzpg+A1KzpNUQQ5cDxdfklxdEyLIr+OfFEOjl/YWmJrBRy1+XOX2mLKF6qCW9
	 xQsUl+stWech7RSf7EgwYZYq7l5EPpV5GOsOVe/YmXyqRNAzcCyH/B8F369/SZP2i9
	 ANCDMDIUjAQ9FDQI1WsZ4ft0gO8WJYjbkcf2Swjj9IdItk9WtonCr/P6m5S1qIUBJE
	 J9UVr47FNvYow==
Date: Mon, 22 Jan 2024 15:29:18 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andy Chiu <andy.chiu@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>,
	Nelson Chu <nelson.chu@sifive.com>, linux-riscv@lists.infradead.org,
	anup@brainfault.org, atishp@atishpatra.org,
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
	Vineet Gupta <vineetg@rivosinc.com>, greentime.hu@sifive.com,
	guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
	aou@eecs.berkeley.edu, ndesaulniers@google.com, trix@redhat.com
Subject: Re: [PATCH -next v21 23/27] riscv: detect assembler support for
 .option arch
Message-ID: <20240122222918.GA141255@dev-fedora.aadp>
References: <20240121011341.GA97368@sol.localdomain>
 <mhng-e4b5de69-859d-43ea-b35d-b568e6a621ef@palmer-ri-x1c9>
 <CABgGipW0pZCESu7dyiUdta2JtrpeMsJ3EABNjj_0GO9fbbTwQg@mail.gmail.com>
 <20240121181009.GA1469@sol.localdomain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240121181009.GA1469@sol.localdomain>

On Sun, Jan 21, 2024 at 10:10:09AM -0800, Eric Biggers wrote:
> On Sun, Jan 21, 2024 at 10:32:59PM +0800, Andy Chiu wrote:
> > 
> > Maybe what we really should do is to upgrade the condition check to a
> > one liner shell script and grep if "Warning" is being printed. Sadly
> > this warning is not failing the compilation with -Werror.
> > 
> > I can try forming a patch on this if it feels alright to people.
> 
> What about -Wa,--fatal-warnings ?

I suspect that would work, the following diff appears to work for me
with a version of clang that does and does not support '.option arch',
(although I am not sure if adding -Wa,--fatal-warnings will have any
other consequences):

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index bffbd869a068..e3142ce531a0 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -315,7 +315,6 @@ config AS_HAS_OPTION_ARCH
 	# https://reviews.llvm.org/D123515
 	def_bool y
 	depends on $(as-instr, .option arch$(comma) +m)
-	depends on !$(as-instr, .option arch$(comma) -i)
 
 source "arch/riscv/Kconfig.socs"
 source "arch/riscv/Kconfig.errata"
diff --git a/scripts/Kconfig.include b/scripts/Kconfig.include
index 5a84b6443875..3ee8ecfb8c04 100644
--- a/scripts/Kconfig.include
+++ b/scripts/Kconfig.include
@@ -33,7 +33,7 @@ ld-option = $(success,$(LD) -v $(1))
 
 # $(as-instr,<instr>)
 # Return y if the assembler supports <instr>, n otherwise
-as-instr = $(success,printf "%b\n" "$(1)" | $(CC) $(CLANG_FLAGS) -c -x assembler-with-cpp -o /dev/null -)
+as-instr = $(success,printf "%b\n" "$(1)" | $(CC) $(CLANG_FLAGS) -Wa$(comma)--fatal-warnings -c -x assembler-with-cpp -o /dev/null -)
 
 # check if $(CC) and $(LD) exist
 $(error-if,$(failure,command -v $(CC)),C compiler '$(CC)' not found)


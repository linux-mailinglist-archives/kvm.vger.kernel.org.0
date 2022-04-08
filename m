Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6704F972E
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 15:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236460AbiDHNqk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 09:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiDHNqi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 09:46:38 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A15F60CEF;
        Fri,  8 Apr 2022 06:44:33 -0700 (PDT)
Received: from zn.tnic (p200300ea971561a9329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9715:61a9:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BAA7B1EC01E0;
        Fri,  8 Apr 2022 15:44:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1649425467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=mOnW2RJRODQeSBjSgnryRxY14AdVYsRQ+7sJhUa4YEU=;
        b=CdxTjfp4gAObW08TYs2ei2/MeVIJaSFerojf2AZ7txQYGu/1YyzeFTlIpDNVrbliDoowZr
        NgqFsTloOO/nKq6L714vO8e8qjNc4rXvY3XJPK7ZWCFR1doW/3BDZ9F24dmDF2FP1IsVBr
        OroCLYc4/TJD3g5txjemUxwBlbXlm2g=
Date:   Fri, 8 Apr 2022 15:44:26 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Vasant Karasulli <vkarasulli@suse.de>
Cc:     linux-kernel@vger.kernel.org, jroedel@suse.de, kvm@vger.kernel.org,
        x86@kernel.org, thomas.lendacky@amd.com, varad.gautam@suse.com
Subject: Re: [PATCH v6 1/4] x86/tests: Add tests for AMD SEV-ES #VC handling
Message-ID: <YlA8OiFKGT8wP2dZ@zn.tnic>
References: <20220318104646.8313-1-vkarasulli@suse.de>
 <20220318104646.8313-2-vkarasulli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220318104646.8313-2-vkarasulli@suse.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Subject: Re: [PATCH v6 1/4] x86/tests: Add tests for AMD SEV-ES #VC handling

Your subject need to summarize each patch and not be the same for each
patch.

On Fri, Mar 18, 2022 at 11:46:43AM +0100, Vasant Karasulli wrote:
>  Add Kconfig options for testing AMD SEV
>  related features.
> 
> Signed-off-by: Vasant Karasulli <vkarasulli@suse.de>
> ---
>  arch/x86/Kbuild          |  2 ++
>  arch/x86/Kconfig.debug   | 16 ++++++++++++++++
>  arch/x86/kernel/Makefile |  7 +++++++
>  arch/x86/tests/Makefile  |  1 +
>  4 files changed, 26 insertions(+)
>  create mode 100644 arch/x86/tests/Makefile
> 
> diff --git a/arch/x86/Kbuild b/arch/x86/Kbuild
> index f384cb1a4f7a..90470c76866a 100644
> --- a/arch/x86/Kbuild
> +++ b/arch/x86/Kbuild
> @@ -26,5 +26,7 @@ obj-y += net/
> 
>  obj-$(CONFIG_KEXEC_FILE) += purgatory/
> 
> +obj-y += tests/
> +
>  # for cleaning
>  subdir- += boot tools
> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index d3a6f74a94bd..e4f61af66816 100644
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -279,3 +279,19 @@ endchoice
>  config FRAME_POINTER
>  	depends on !UNWINDER_ORC && !UNWINDER_GUESS
>  	bool
> +
> +config X86_TESTS
> +	bool "Tests for x86"

"x86 unit tests"

or so.

> +	help
> +	    This enables building the tests under arch/x86/tests.

This needs to explain more what "the tests" are and how people should
run them or at least there should be a pointer to a doc how. Running
tests should be trivial to mount so that everyone can run them. You want
as many people testing stuff as possible so the testing infra needs to
be easy to use.

For example, I have no clue how to run those tests.

Also, I have no clue why those tests are in arch/x86/tests/ and not
somewhere in tools/testing/selftests/x86/ or so.

All this stuff needs to be explained in the commit message.

Also, you should read

Documentation/process/submitting-patches.rst

first as there it is explained at length how a patch should look like.

> +
> +if X86_TESTS
> +config AMD_SEV_TEST_VC
> +	bool "Test for AMD SEV VC exception handling"
> +	depends on AMD_MEM_ENCRYPT
> +	select FUNCTION_TRACER
> +	select KPROBES
> +	select KUNIT
> +	help
> +	  Enable KUnit-based testing for AMD SEV #VC exception handling.
> +endif # X86_TESTS
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 6aef9ee28a39..69472a576909 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -24,6 +24,13 @@ CFLAGS_REMOVE_sev.o = -pg
>  CFLAGS_REMOVE_cc_platform.o = -pg
>  endif
> 
> +# AMD_SEV_TEST_VC registers a kprobe by function name. IPA-SRA creates
> +# function copies and renames them to have an .isra suffix, which breaks kprobes'
> +# lookup. Build with -fno-ipa-sra for the test.
> +ifdef CONFIG_AMD_SEV_TEST_VC

Why ifdef?

I think you want this to be enabled unconditionally since the VC tests
select KRPOBES.

> +CFLAGS_sev.o	+= -fno-ipa-sra
> +endif
> +
>  KASAN_SANITIZE_head$(BITS).o				:= n
>  KASAN_SANITIZE_dumpstack.o				:= n
>  KASAN_SANITIZE_dumpstack_$(BITS).o			:= n
> diff --git a/arch/x86/tests/Makefile b/arch/x86/tests/Makefile
> new file mode 100644
> index 000000000000..f66554cd5c45
> --- /dev/null
> +++ b/arch/x86/tests/Makefile
> @@ -0,0 +1 @@
> +# SPDX-License-Identifier: GPL-2.0

Add that file with the next patch - this hunk is just silly as it is.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

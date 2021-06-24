Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E493B2C8B
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 12:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbhFXKil (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 06:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231983AbhFXKik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 06:38:40 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7472EC061574;
        Thu, 24 Jun 2021 03:36:21 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0c1e00ef5c88bd9860b940.dip0.t-ipconnect.de [IPv6:2003:ec:2f0c:1e00:ef5c:88bd:9860:b940])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 551CF1EC047F;
        Thu, 24 Jun 2021 12:36:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1624530979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=E2LvYmHUL9J1fv48LE5yfhRtvEXrYVPB7X6UxUbQiuo=;
        b=KuXUNtBy1pma0UjTqRiFI55mSKPF6NuwX2dEFPW3AZCYD5A/jIr0KUHQH38cvBA0d7tCdC
        /Ugt0rFZnDrXSz8ONkgx3zh+Zk5el/FmjN/DEnMyHuEaMRtQDr+ta0h6CQli4OH8qyws4n
        5VdjLFLJGrH7sOGBV6FFiMfHcdTuGn4=
Date:   Thu, 24 Jun 2021 12:36:13 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v4] x86: Add a test for AMD SEV-ES #VC handling
Message-ID: <YNRgHbPVGpLaByjH@zn.tnic>
References: <20210531125035.21105-1-varad.gautam@suse.com>
 <20210616091538.15321-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210616091538.15321-1-varad.gautam@suse.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 16, 2021 at 11:15:38AM +0200, Varad Gautam wrote:

Subject: Re: [PATCH v4] x86: Add a test for AMD SEV-ES #VC handling

Change your subject prefix to "x86/test: ... "

> Some vmexits on a SEV-ES guest need special handling within the guest
> before exiting to the hypervisor. This must happen within the guest's
> \#VC exception handler, triggered on every non automatic exit.
> 
> Add a KUnit based test to validate Linux's VC handling, and introduce
> a new CONFIG_X86_TESTS to cover such tests. The test:
> 1. installs a kretprobe on the #VC handler (sev_es_ghcb_hv_call, to
>    access GHCB before/after the resulting VMGEXIT).
> 2. tiggers an NAE.
> 3. checks that the kretprobe was hit with the right exit_code available
>    in GHCB.
> 
> Since relying on kprobes, the test does not cover NMI contexts.
> 
> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
> ---
> v4: Move this test to arch/x86/tests/, enabled by CONFIG_X86_TESTS.
> 
>  arch/x86/Kbuild                 |   2 +
>  arch/x86/Kconfig.debug          |  15 ++++
>  arch/x86/kernel/Makefile        |   7 ++
>  arch/x86/tests/Makefile         |   3 +
>  arch/x86/tests/sev-es-test-vc.c | 155 ++++++++++++++++++++++++++++++++
>  5 files changed, 182 insertions(+)
>  create mode 100644 arch/x86/tests/Makefile
>  create mode 100644 arch/x86/tests/sev-es-test-vc.c

Please integrate scripts/checkpatch.pl into your patch creation
workflow. Some of the warnings/errors *actually* make sense.

There's a bunch of things to fix I've pasted at the end of this mail.

> diff --git a/arch/x86/Kbuild b/arch/x86/Kbuild
> index 30dec019756b9..965cfcbd12f67 100644
> --- a/arch/x86/Kbuild
> +++ b/arch/x86/Kbuild
> @@ -25,3 +25,5 @@ obj-y += platform/
>  obj-y += net/
>  
>  obj-$(CONFIG_KEXEC_FILE) += purgatory/
> +
> +obj-$(CONFIG_X86_TESTS) += tests/
> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index 80b57e7f49477..6f63069fff972 100644
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -282,3 +282,18 @@ endchoice
>  config FRAME_POINTER
>  	depends on !UNWINDER_ORC && !UNWINDER_GUESS
>  	bool
> +
> +config X86_TESTS
> +	bool "Tests for x86"
> +	help
> +	    This enables building the tests under arch/x86/tests.
> +

All those tests should probably be in a

if X86_TESTS

> +config AMD_SEV_ES_TEST_VC
> +	bool "Test for AMD SEV-ES VC exception handling"
> +	depends on AMD_MEM_ENCRYPT
> +	depends on X86_TESTS
> +	select FUNCTION_TRACER
> +	select KPROBES
> +	select KUNIT
> +	help
> +	  Enable KUnit-based testing for AMD SEV-ES #VC exception handling.

endif # X86_TESTS

so that you don't have the X86_TESTS dependency in each test explicitly.

> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 0f66682ac02a6..bf1c4dc525ac6 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -23,6 +23,13 @@ CFLAGS_REMOVE_head64.o = -pg
>  CFLAGS_REMOVE_sev.o = -pg
>  endif
>  
> +# AMD_SEV_ES_TEST_VC registers a kprobe by function name. IPA-SRA creates
> +# function copies and renames them to have an .isra suffix, which breaks kprobes'
> +# lookup. Build with -fno-ipa-sra for the test.
> +ifdef CONFIG_AMD_SEV_ES_TEST_VC
> +CFLAGS_sev.o	+= -fno-ipa-sra
> +endif
> +
>  KASAN_SANITIZE_head$(BITS).o				:= n
>  KASAN_SANITIZE_dumpstack.o				:= n
>  KASAN_SANITIZE_dumpstack_$(BITS).o			:= n
> diff --git a/arch/x86/tests/Makefile b/arch/x86/tests/Makefile
> new file mode 100644
> index 0000000000000..fa79c435d7843
> --- /dev/null
> +++ b/arch/x86/tests/Makefile
> @@ -0,0 +1,3 @@
> +# SPDX-License-Identifier: GPL-2.0
> +
> +obj-$(CONFIG_AMD_SEV_ES_TEST_VC)	+= sev-es-test-vc.o
> diff --git a/arch/x86/tests/sev-es-test-vc.c b/arch/x86/tests/sev-es-test-vc.c
> new file mode 100644
> index 0000000000000..98dc38572ed5d
> --- /dev/null
> +++ b/arch/x86/tests/sev-es-test-vc.c

Can this be called sev-tests.c and simply collect all SEV-related tests
in it?

> @@ -0,0 +1,155 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2021 SUSE
> + *
> + * Author: Varad Gautam <varad.gautam@suse.com>
> + */
> +
> +#include <asm/cpufeature.h>
> +#include <asm/debugreg.h>
> +#include <asm/io.h>
> +#include <asm/sev-common.h>
> +#include <asm/svm.h>
> +#include <kunit/test.h>
> +#include <linux/kprobes.h>
> +
> +static struct kretprobe hv_call_krp;
> +
> +static int hv_call_krp_entry(struct kretprobe_instance *krpi,
> +			     struct pt_regs *regs)
> +{
> +	unsigned long ghcb_vaddr = regs_get_kernel_argument(regs, 0);
> +	*((unsigned long *) krpi->data) = ghcb_vaddr;
> +
> +	return 0;
> +}
> +
> +static int hv_call_krp_ret(struct kretprobe_instance *krpi,
> +			   struct pt_regs *regs)
> +{
> +	unsigned long ghcb_vaddr = *((unsigned long *) krpi->data);
> +	struct ghcb *ghcb = (struct ghcb *) ghcb_vaddr;
> +	struct kunit *test = current->kunit_test;
> +
> +	if (test && strstr(test->name, "sev_es_") && test->priv)
> +		cmpxchg((unsigned long *) test->priv, ghcb->save.sw_exit_code, 1);

Why is this needed? Normal assignment won't do?

Also, that "1" is magic as it is used in KUNIT_EXPECT_EQ below so maybe
have it defined with a nice telling name.

IOW, why are those memory barriers needed?

...

Some checkpatch issues:

WARNING: 'tiggers' may be misspelled - perhaps 'triggers'?
#74: 
2. tiggers an NAE.
   ^^^^^^^

WARNING: please write a paragraph that describes the config symbol fully
#112: FILE: arch/x86/Kconfig.debug:286:
+config X86_TESTS

WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
#145: 
new file mode 100644

WARNING: memory barrier without comment
#245: FILE: arch/x86/tests/sev-es-test-vc.c:87:
+	smp_store_release((typeof(ec) *) t->priv, ec);			\

WARNING: please, no space before tabs
#247: FILE: arch/x86/tests/sev-es-test-vc.c:89:
+^IKUNIT_EXPECT_EQ(t, (typeof(ec)) 1, ^I^I^I^I\$

WARNING: memory barrier without comment
#248: FILE: arch/x86/tests/sev-es-test-vc.c:90:
+		(typeof(ec)) smp_load_acquire((typeof(ec) *) t->priv));	\

ERROR: space required before the open parenthesis '('
#249: FILE: arch/x86/tests/sev-es-test-vc.c:91:
+} while(0)

WARNING: Prefer 'unsigned int' to bare use of 'unsigned'
#289: FILE: arch/x86/tests/sev-es-test-vc.c:131:
+	unsigned lapic_version = 0;

total: 1 errors, 7 warnings, 194 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

"[PATCH v4] x86: Add a test for AMD SEV-ES #VC handling" has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.
/tmp/varad.01 has problems, exiting...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

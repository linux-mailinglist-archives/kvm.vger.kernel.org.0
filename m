Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6226B65C100
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 14:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbjACNlF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 08:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbjACNk5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 08:40:57 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70706E19;
        Tue,  3 Jan 2023 05:40:53 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 82AA21EC034B;
        Tue,  3 Jan 2023 14:40:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1672753251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=7WZ2I/kePpaASy/qY+vLm4NwRwJ6Szd4KG46JRy26ow=;
        b=Cd3iHtUkCRfBCwEoy0QhT1+l1dGdwcDQG6hBwbnGP/lQOiIZYKzEes5LgYqJGNpEhFgPs2
        1qCwjW5inVX8Vtxd72WTULF82jle/+plZ1j/S4B2Y0im7H6C2907v7NpAFuL9MYPQ5vv/t
        5GSOnpLGNWkU7BAyw6A1UJV2M0nrCaM=
Date:   Tue, 3 Jan 2023 14:40:45 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Nikunj A Dadhania <nikunj@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
        michael.roth@amd.com, stable@kernel.org
Subject: Re: [PATCH v3] x86/sev: Add SEV-SNP guest feature negotiation support
Message-ID: <Y7QwXcAUmS3VZcbH@zn.tnic>
References: <20230102083810.71178-1-nikunj@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230102083810.71178-1-nikunj@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 02, 2023 at 02:08:10PM +0530, Nikunj A Dadhania wrote:
> The hypervisor can enable various new features (SEV_FEATURES[1:63])
> and start the SNP guest. Some of these features need guest side
> implementation. If any of these features are enabled without guest
> side implementation, the behavior of the SNP guest will be undefined.
> The SNP guest boot may fail in a non-obvious way making it difficult
> to debug.
> 
> Instead of allowing the guest to continue and have it fail randomly
> later, detect this early and fail gracefully.
> 
> SEV_STATUS MSR indicates features which hypervisor has enabled. While
					 ^
					 the

> booting, SNP guests should ascertain that all the enabled features
> have guest side implementation. In case any feature is not implemented
> in the guest, the guest terminates booting with SNP feature
> unsupported exit code.
> 
> More details in AMD64 APM[1] Vol 2: 15.34.10 SEV_STATUS MSR
> 
> [1] https://www.amd.com/system/files/TechDocs/40332_4.05.pdf
> 
> Fixes: cbd3d4f7c4e5 ("x86/sev: Check SEV-SNP features support")
> CC: Borislav Petkov <bp@alien8.de>
> CC: Michael Roth <michael.roth@amd.com>
> CC: Tom Lendacky <thomas.lendacky@amd.com>
> CC: <stable@kernel.org>
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

...

> diff --git a/Documentation/x86/amd-memory-encryption.rst b/Documentation/x86/amd-memory-encryption.rst
> index a1940ebe7be5..b8b6b87be995 100644
> --- a/Documentation/x86/amd-memory-encryption.rst
> +++ b/Documentation/x86/amd-memory-encryption.rst
> @@ -95,3 +95,38 @@ by supplying mem_encrypt=on on the kernel command line.  However, if BIOS does
>  not enable SME, then Linux will not be able to activate memory encryption, even
>  if configured to do so by default or the mem_encrypt=on command line parameter
>  is specified.
> +
> +Secure Nested Paging (SNP):

No ":"

> +===========================

<---- newline here.

> +SEV-SNP introduces new features (SEV_FEATURES[1:63]) which can be enabled
> +by the hypervisor for security enhancements. Some of these features need
> +guest side implementation to function correctly. The below table lists the
> +expected guest behavior with various possible scenarios of guest/hypervisor
> +SNP feature support.
> +
> ++---------------+---------------+---------------+---------------+
> +|Feature Enabled|  Guest needs  |   Guest has   |  Guest boot   |
> +|     by HV     |implementation |implementation |   behavior    |
> ++---------------+---------------+---------------+---------------+
> +|      No       |      No       |      No       |     Boot      |
> +|               |               |               |               |
> ++---------------+---------------+---------------+---------------+
> +|      No       |      Yes      |      No       |     Boot      |
> +|               |               |               |               |
> ++---------------+---------------+---------------+---------------+
> +|      No       |      Yes      |      Yes      |     Boot      |
> +|               |               |               |               |
> ++---------------+---------------+---------------+---------------+
> +|      Yes      |      No       |      No       |   Boot with   |
> +|               |               |               |feature enabled|
> ++---------------+---------------+---------------+---------------+
> +|      Yes      |      Yes      |      No       | Graceful Boot |
> +|               |               |               |    Failure    |
> ++---------------+---------------+---------------+---------------+
> +|      Yes      |      Yes      |      Yes      |   Boot with   |
> +|               |               |               |feature enabled|
> ++---------------+---------------+---------------+---------------+

sphinx is not happy about that table for some reason. I always find the error
messages cryptic though:

Documentation/x86/amd-memory-encryption.rst:110: WARNING: Block quote ends without a blank line; unexpected unindent.
Documentation/x86/amd-memory-encryption.rst:110: WARNING: Block quote ends without a blank line; unexpected unindent.
Documentation/x86/amd-memory-encryption.rst:122: WARNING: Block quote ends without a blank line; unexpected unindent.
Documentation/x86/amd-memory-encryption.rst:128: WARNING: Block quote ends without a blank line; unexpected unindent.

You can repro by doing "make htmldocs".

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

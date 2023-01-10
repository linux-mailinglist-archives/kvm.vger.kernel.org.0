Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3BF664CF5
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 21:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbjAJUEk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 15:04:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbjAJUEh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 15:04:37 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2932C2F78A;
        Tue, 10 Jan 2023 12:04:36 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D6CD01EC04AD;
        Tue, 10 Jan 2023 21:04:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1673381073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=M3tBW9qCJ3Mizim533mGhH5rYMqDrEy70kptqc1M+Ac=;
        b=b4Aa2IBjrRqDbJGbNnhz/liaC09snbvL0f09Lg7HQ+EmOsoJy/EpP+ZJKAIY9IYDZKJajF
        ouVZKd57Km9haBznL/JK374dQMx5B21UDzrMnzEKS9i139BkBJf1WZ74vEfBoqnZZyxrZy
        siGrxNLNeAuMPuyp7Zb20FD4ZQueAwo=
Date:   Tue, 10 Jan 2023 21:04:33 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Huang Rui <ray.huang@amd.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH kernel v2 3/3] x86/sev: Do not handle #VC for DR7
 read/write
Message-ID: <Y73E0aUFXkmQGDgX@zn.tnic>
References: <20221209043804.942352-1-aik@amd.com>
 <20221209043804.942352-4-aik@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221209043804.942352-4-aik@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 09, 2022 at 03:38:04PM +1100, Alexey Kardashevskiy wrote:
> With MSR_AMD64_SEV_DEBUG_SWAP enabled, the VM should not get #VC
> events for DR7 read/write which it rather avoided.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
> Changes:
> v2:
> * use new bit definition
> ---
>  arch/x86/include/asm/msr-index.h       | 1 +
>  tools/arch/x86/include/asm/msr-index.h | 1 +
>  arch/x86/kernel/sev.c                  | 6 ++++++
>  3 files changed, 8 insertions(+)

Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

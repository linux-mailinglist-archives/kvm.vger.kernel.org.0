Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84A047B7948
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 09:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241659AbjJDH7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 03:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241661AbjJDH7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 03:59:09 -0400
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487A9C9;
        Wed,  4 Oct 2023 00:59:06 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 45FE840E01A4;
        Wed,  4 Oct 2023 07:59:04 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
        header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
        by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id sr-s69_c3MXx; Wed,  4 Oct 2023 07:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
        t=1696406342; bh=PPjuHf+AhXSxFM9jDrJbk8Nu7BK+WooeaVjE0MSwi40=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T2qmtsTd7YtlFf7t3DXYmwHQ7SGwDf8ZQ1qBNz+9rxe/XxHJ4ZwiRXId654g+BzDw
         yIHUxPoc2hubwf0WO/Ul3yQJ7qcerj6TBKn9ssdcVdPRXU5OuH1ZwXGTvikGwn/lTQ
         v9A7CyrjcPbf73FAxgjxb77whgg1lHOHR3vXPR8R1zXe0mxbkDgy4sAEJUtwvqCBNU
         DH7gvCNXm3QUBKoSjDfZcBbvznn6b7q3fxEj0sIi92u6dTmsrbs64AsR2TqM8XtTxG
         5tfPG/h9+HJk5Y7Yz1QbPP2Gl9iI3tec5ExPdRKFNq4FY2MTXQW7ShXN5KO87xn8Dd
         Vk+EOHeSD/QC8fwjEJO4uy0VcnT/dmVcC0Q2bVgW5bI60MrFKHavmnQCCkUu37OscR
         9Y3WJGKaafE5DUEtowI0PhIS2Z5Tv+mDBd2YZ1IPUz3tvc4BpBa6ugqV28uRr+GBut
         3wMaTli5iMXIye9OQMKzsSnvze09BRuzMDl3iWEUKjtf/AzceJWNvPv6/P1i2bY+X7
         A2rYfJVWycY7Wc6AzJ1CgeXrEZP6uN4aTwYI8sXV3+fLZBkk7HNzy141q6shc8n7CS
         NirFcnILe3q0AKOCINNwAp7dDMouFDBJVwQVuUdQjfyBabIj4dbsbX+rKNGMZaMZRG
         lr4MMxLh3wDboLEdty2zq1Wk=
Received: from zn.tnic (pd953036a.dip0.t-ipconnect.de [217.83.3.106])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7890A40E0176;
        Wed,  4 Oct 2023 07:58:48 +0000 (UTC)
Date:   Wed, 4 Oct 2023 09:58:44 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jim Mattson <jmattson@google.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: KVM: Add feature flag for AMD's
 FsGsKernelGsBaseNonSerializing
Message-ID: <20231004075836.GBZR0bLC/Y09sSSYWw@fat_crate.local>
References: <20231004002038.907778-1-jmattson@google.com>
 <01009a2a-929e-ce16-6f44-1d314e6bcba5@intel.com>
 <CALMp9eR+Qudg++J_dmY_SGbM_kr=GQcRRcjuUxtm9rfaC_qeXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALMp9eR+Qudg++J_dmY_SGbM_kr=GQcRRcjuUxtm9rfaC_qeXQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 03, 2023 at 07:44:51PM -0700, Jim Mattson wrote:
> The business of declaring breaking changes to the architectural
> specification in a CPUID bit has never made much sense to me.

How else should they be expressed then?

In some flaky PDF which changes URLs whenever the new corporate CMS gets
installed?

Or we should do f/m/s matching which doesn't make any sense for VMs?

When you think about it, CPUID is the best thing we have.

> No one is likely to query CPUID.80000021H.EAX[bit 21] today, but if
> someone does query the bit in the future, they can reasonably expect
> that WRMSR({FS,GS,KERNELGS}_BASE) is a serializing operation whenever
> this bit is clear. Therefore, any hypervisor that doesn't pass the bit
> through is broken. Sadly, this also means that for a heterogenous
> migration pool, the hypervisor must set this bit in the guest CPUID if
> it is set on any host in the pool. Yes, that means that the legacy
> behavior may sometimes be present in a VM that enumerates the CPUID
> bit, but that's the best we can do.

Yes, add this to your commit message.

> I'm a little surprised at the pushback, TBH. Are you implying that
> there is some advantage to *not* passing this bit through?

We don't add stuff which is not worth adding. There has to be *at*
*least* some justification for it.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC14D78C7FF
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 16:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237040AbjH2OwD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 10:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjH2Ov3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 10:51:29 -0400
Received: from pandora.armlinux.org.uk (unknown [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E93B98;
        Tue, 29 Aug 2023 07:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zucveyWpJ8nh/whOJskv5u4rNtkAFo2YaIGg2aE8F/U=; b=Kqnb4BQFfO0OsxgTlaYOQmv61q
        BA2O78Gnus/v9Srs9hKh7CEsc17CnatOWi++HAqvxYRGbahQQbcMtwkRrzadnFZabQr5j546KzTJi
        V7bzhnxKiCLPU5LfBMF/+IXZgsQgto6iCN9q7a/pVpBde/tF4KoLNa+HgfSikcPYxiQpNZ+TgRkv4
        GAKADTpU1WWdiUJKUzRDZpEpmmQdnz70FP4cQAm9z5NBUK7/JeY9aJl2ImKX0vSAggm4leNEa2G8r
        6ib7/67QSYaMKJbmA57ryBR4ldDMNp2G8xJDm2YKGh+UzVTBPBIYdaV3zV1KdhH3RdpwZ66RJIyDZ
        mVKIt9qw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58232)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <linux@armlinux.org.uk>)
        id 1qb02f-0000cz-1o;
        Tue, 29 Aug 2023 15:50:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1qb02K-0004jk-Oo; Tue, 29 Aug 2023 15:49:44 +0100
Date:   Tue, 29 Aug 2023 15:49:44 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Mihai Carabas <mihai.carabas@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Juerg Haefliger <juerg.haefliger@canonical.com>,
        =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 5/7] arm64: Select ARCH_HAS_CPU_RELAX
Message-ID: <ZO4FiJpLSFISkK10@shell.armlinux.org.uk>
References: <1691581193-8416-1-git-send-email-mihai.carabas@oracle.com>
 <1691581193-8416-6-git-send-email-mihai.carabas@oracle.com>
 <20230809134941.GN212435@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809134941.GN212435@hirez.programming.kicks-ass.net>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 09, 2023 at 03:49:41PM +0200, Peter Zijlstra wrote:
> On Wed, Aug 09, 2023 at 02:39:39PM +0300, Mihai Carabas wrote:
> > From: Joao Martins <joao.m.martins@oracle.com>
> > 
> > cpu_relax() is necessary to allow cpuidle poll-state to be used,
> > so select it from ARM64 kconfig.
> > 
> > Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> > Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
> > ---
> >  arch/arm64/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index 87ade6549790..7c47617b5722 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -105,6 +105,7 @@ config ARM64
> >  	select ARCH_WANT_LD_ORPHAN_WARN
> >  	select ARCH_WANTS_NO_INSTR
> >  	select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES
> > +	select ARCH_HAS_CPU_RELAX
> >  	select ARCH_HAS_UBSAN_SANITIZE_ALL
> >  	select ARM_AMBA
> >  	select ARM_ARCH_TIMER
> 
> Uh what ?! cpu_relax() is assumed present on all archs, no?

I think you have x86 to blame for that!

That symbol is used in drivers/acpi/processor_idle.c to setup stuff
for the cpuidle polling, and also by cpuidle's Makefile to build
poll_state.o

It isn't to do with the presence of cpu_relax() or not.

It probably ought to be renamed to CPUIDLE_CPU_RELAX which would
better describe its modern purpose.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

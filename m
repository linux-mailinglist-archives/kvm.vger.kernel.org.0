Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01AB337309
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 13:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbhCKMuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 07:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233122AbhCKMue (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 07:50:34 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B52BC061574;
        Thu, 11 Mar 2021 04:50:34 -0800 (PST)
Received: from zn.tnic (p200300ec2f0e1f0084acfb80b2ea2480.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:1f00:84ac:fb80:b2ea:2480])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 570341EC04C0;
        Thu, 11 Mar 2021 13:50:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1615467030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=YQoMnM+JalduchtvnnRdDi537/sQjYe69dpZBUUIePI=;
        b=oOGUaSre4XzUs+lxkz7FD2kSZBN8NksBkfckW/+qTHl8JbaxYlJ6NN8Mbc1R2n11m55CFf
        P73fj+xpCfOCQDtCPXJIYK1D6MwZPiXIwvgaAfFGUGzDJZaZCXkLGAHUC5DtKeJD/Osqtp
        IAS+CcgMs7OmmLqg6Q3uUtquB4Svgws=
Date:   Thu, 11 Mar 2021 13:50:26 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, virtualization@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, clang-built-linux@googlegroups.com,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jason Baron <jbaron@akamai.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ard Biesheuvel <ardb@kernel.org>, Deep Shah <sdeep@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v6 00/12] x86: major paravirt cleanup
Message-ID: <20210311125026.GB5829@zn.tnic>
References: <20210309134813.23912-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210309134813.23912-1-jgross@suse.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021 at 02:48:01PM +0100, Juergen Gross wrote:
> This is a major cleanup of the paravirt infrastructure aiming at
> eliminating all custom code patching via paravirt patching.
> 
> This is achieved by using ALTERNATIVE instead, leading to the ability
> to give objtool access to the patched in instructions.
> 
> In order to remove most of the 32-bit special handling from pvops the
> time related operations are switched to use static_call() instead.
> 
> At the end of this series all paravirt patching has to do is to
> replace indirect calls with direct ones. In a further step this could
> be switched to static_call(), too.
> 
> Changes in V6:
> - switched back to "not" bit in feature value for "not feature"
> - other minor comments addressed

Ok, looks real good, the simplification is amazing! :)

Can you please redo with the minor nits addressed ontop of the
tip:x86/alternatives branch:

https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/log/?h=x86/alternatives

and move the cleanups patches 13 and 14 to the beginning of the set?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

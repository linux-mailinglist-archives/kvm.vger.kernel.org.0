Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA8A37AE96
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 20:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhEKSme (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 14:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbhEKSmd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 14:42:33 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758D8C061574;
        Tue, 11 May 2021 11:41:26 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0ec70091f309bcd5e4258d.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:c700:91f3:9bc:d5e4:258d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E80501EC0322;
        Tue, 11 May 2021 20:41:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1620758485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=7iqeAiXX3oBOgrn3cS8loTPFjOioHSqblU2lZee1pHM=;
        b=Z3/kcKdIMuK7/414DDAa96BZ6K8X0QgvO0anNDJZ4b+g/kBfx3yJG6shhheCjmWnTuG+5j
        yn3DGHE3aLxwkSB4EVedIW6qZHtalawBobMBqKetuMulnpYRDnl6K6RSR378vmNJVQN5PQ
        Abm21ZoyXus3+MnA/s18fULiFGXV6iE=
Date:   Tue, 11 May 2021 20:41:26 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 02/20] x86/sev: Save the negotiated GHCB
 version
Message-ID: <YJrP1vTXmtzXYapq@zn.tnic>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-3-brijesh.singh@amd.com>
 <YJpM+VZaEr68hTwZ@zn.tnic>
 <36add6ab-0115-d290-facd-2709e3c93fb9@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <36add6ab-0115-d290-facd-2709e3c93fb9@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021 at 01:29:00PM -0500, Brijesh Singh wrote:
> I ignored it, because I thought I still need to initialize the value to
> zero because it does not go into .bss section which gets initialized to
> zero by kernel on boot.
> 
> I guess I was wrong, maybe compiler or kernel build ensures that
> ghcb_version variable to be init'ed to zero because its marked static ?

Yes.

If in doubt, always look at the generated asm:

make arch/x86/kernel/sev.s

You can see the .zero 2 gas directive there, where the variable is
defined.

> In patch #4, you will see that I increase the GHCB max protocol version
> to 2, and then min_t() will choose the lower value. I didn't combine
> version bump and caching into same patch because I felt I will be asked
> to break them into two logical patches.

Hmm, what would be the reasoning to keep the version bump in a separate
patch?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

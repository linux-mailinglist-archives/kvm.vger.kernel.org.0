Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3CF7D6E19
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 16:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344516AbjJYNo6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 09:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234901AbjJYNoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 09:44:55 -0400
X-Greylist: delayed 11420 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 25 Oct 2023 06:44:52 PDT
Received: from mail.alien8.de (mail.alien8.de [IPv6:2a01:4f9:3051:3f93::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB47F19D;
        Wed, 25 Oct 2023 06:44:52 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8D95A40E00B3;
        Wed, 25 Oct 2023 13:44:50 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
        header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
        by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Fc0bnT_9t_Uq; Wed, 25 Oct 2023 13:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
        t=1698241488; bh=+ieImtZGj+VOp5ccDeztXRroa/BoBO+stfynN77x4s4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OMcAKbyUkyhuqj1UFc9ljgQxXx/4iDnowTXeq7KTMybgZzdM7S0yqlfMFwMNQogK+
         o7cds6WEPJevCOXRK3/plplccqOSImH8RhAjRDu+ivVcaAoc4+flNZBJ7P9p8ExOz9
         eE6xO9TRFbtCyPrNWN1aMmrvTXdra/rLEIhKFMcK+Z4FWklW+46Mr9NfRFTWdx442C
         vQf0ziYnpiAejiwLDVDqN/3skD2n8Z8VmLa5GFnLcfvXxT/EIk4OpvgDUK4Kw/5CU+
         2eZJh92QixzUyta0Vcn51qj3YFDBJbP1Qu2fLKY1Nqc3iTmCfvIZIa63Fmx8KRJAyb
         aGPCeBmtg5fkgb82mRF6wA3bM6IXyjEVs4QQm2Pare6nAha+WmH3QeCz+RSlhdN7iH
         cYkUWvfPzT8EspK1cwlTD6AHy7W2Zz0PYeC/aRQuiBN0ts4jvY6jpTRaJ+4Ak0MBBf
         dMe+r6HUKUPf5a8xS9nhwlgsmk7RaIIsNG35ykeiNGOJd8Ktxewx9K0xkXwYuSHMjR
         TGBdHsXswCUnMdLud8l56yK+te3+72BH2EL+90wue8aqWKUjRW+6AZDoIcsAvCPf0L
         L/HnqzY/x2fUdh7331lw3NQ5alr6ljA/L+9+f8+l5oeP3Xb7gR68t6Z+R0JI3jOSZr
         TgkiOe1BkQgz8i9OugTPbVGQ=
Received: from zn.tnic (pd95304da.dip0.t-ipconnect.de [217.83.4.218])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6C1F840E0187;
        Wed, 25 Oct 2023 13:44:30 +0000 (UTC)
Date:   Wed, 25 Oct 2023 15:44:25 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Juergen Gross <jgross@suse.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ajay Kaher <akaher@vmware.com>,
        Alexey Makhalov <amakhalov@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        xen-devel@lists.xenproject.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 1/5] x86/paravirt: move some functions and defines to
 alternative
Message-ID: <20231025134425.GEZTkbua5w0bI2GQlP@fat_crate.local>
References: <20231019091520.14540-1-jgross@suse.com>
 <20231019091520.14540-2-jgross@suse.com>
 <20231025103402.GBZTjvGse9c0utZGO0@fat_crate.local>
 <fde7ffdd-4d12-4821-ac51-e67e65637111@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fde7ffdd-4d12-4821-ac51-e67e65637111@suse.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 25, 2023 at 03:31:07PM +0200, Juergen Gross wrote:
> There is
> 
> #define nop() asm volatile ("nop")
> 
> in arch/x86/include/asm/special_insns.h already.

Then call it "nop_func" or so.

> It might not be needed now, but are you sure we won't need it in future?

No, I'm not.

What I'm sure of is: stuff should be added to the kernel only when
really needed. Not in the expectation that it might potentially be
needed at some point.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

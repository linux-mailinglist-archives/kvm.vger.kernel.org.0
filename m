Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E29064748B
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 17:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiLHQpp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 11:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiLHQpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 11:45:43 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7593CAD9B9;
        Thu,  8 Dec 2022 08:45:42 -0800 (PST)
Received: from zn.tnic (p200300ea9733e73d329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e73d:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CE3791EC0532;
        Thu,  8 Dec 2022 17:45:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1670517940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=7UYnb8saJRAMN8YyhSKWB2/pXVvKNhUnY19tP4EIqc4=;
        b=MLW+hETva1aD38npkjSHdN0aO1JtGCx+FpAksrJHLcZCUNy6re9YpMQwwIYlV9oCVjn0F1
        VZnSlLncg6iiga00hwXmV8Wv03cTk5rRSFZltQXBYt+GPlahbaPtdKsyRsX9gPvHvXoeey
        uoq+LcJruAfpMAtnOKNUK3psBTuTs/0=
Date:   Thu, 8 Dec 2022 17:45:36 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/3] x86/cpu: Process all CPUID dependencies after
 identifying CPU info
Message-ID: <Y5IUsB83PzHCJ+EY@zn.tnic>
References: <20221203003745.1475584-1-seanjc@google.com>
 <20221203003745.1475584-2-seanjc@google.com>
 <Y5INU3o+SFReGkLz@zn.tnic>
 <Y5IQNY/fZw2JFA0B@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y5IQNY/fZw2JFA0B@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 08, 2022 at 04:26:29PM +0000, Sean Christopherson wrote:
> But it's not really a hardware issue either.  More like an admin/user issue.
> 
> The problem is that if a kernel is built for subset of CPU types, e.g. just Intel
> or just Centaur, and then booted on an "unsupported" CPU type, init_ia32_feat_ctl()
> will never be invoked because ->c_init() will point a default_init(), and so the
> kernel never checks MSR_IA32_FEAT_CTL to see if VMX and/or SGX are fully enabled.

Yeah, you called it an "edge case". I'm wondering whether we should even
worry about that case...

I mean, the majority of Linuxes out there are allmodconfig-like kernels
and booting on unsupported CPU type doesn't happen.

Hell, I'd even say that if you attempt booting on unsupported CPU type,
we should simply fail that boot attempt.

I.e., what validate_cpu() does in some cases.

IOW, I don't mind what you're doing but I wonder whether we should even
go the trouble to do so or simply deny that by saying "Well, don't do
that then".

Hmmm.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

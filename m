Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F05202ADAD2
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 16:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731248AbgKJPuY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 10:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730850AbgKJPuX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 10:50:23 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94910C0613CF;
        Tue, 10 Nov 2020 07:50:23 -0800 (PST)
Received: from nazgul.tnic (unknown [78.130.214.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2C1BE1EC04CB;
        Tue, 10 Nov 2020 16:50:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1605023421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=cI7RO02QCOkBjAuvhcFoxA8dBO+HwAVNuJFq7/77EFY=;
        b=ZO2hbKvA/zIGi7eG/eEnoOQoiKSUo1uyGUVvGKFRtG6ArDoEJkJIdpqrk/zav+DOyauYac
        X1sJwXDJcN5WoVfOj75cVaBMpPIPvO3g5dns+kL5qDPZv2pt6Bh5zJQ+cg9nPBnfbieWxt
        a0GYnX3lr/LDn8rc8tBRD84P+CkRvi4=
Date:   Tue, 10 Nov 2020 16:50:13 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        Jim Mattson <jmattson@google.com>, Qian Cai <cai@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>, x86 <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] x86/mce: Check for hypervisor before enabling additional
 error logging
Message-ID: <20201110155013.GE9857@nazgul.tnic>
References: <160431588828.397.16468104725047768957.tip-bot2@tip-bot2>
 <3f863634cd75824907e8ccf8164548c2ef036f20.camel@redhat.com>
 <bfc274fc27724ea39ecac1e7ac834ed8@intel.com>
 <CALMp9eTFaiYkTnVe8xKzg40E4nZ3rAOii0O06bTy0+oLNjyKhA@mail.gmail.com>
 <a22b5468e1c94906b72c4d8bc83c0f64@intel.com>
 <20201109232402.GA25492@agluck-desk2.amr.corp.intel.com>
 <20201110063151.GB7290@nazgul.tnic>
 <094c2395-b1b3-d908-657c-9bd4144e40ac@redhat.com>
 <20201110095615.GB9450@nazgul.tnic>
 <b8de7f7b-7aa1-d98b-74be-62d7c055542b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b8de7f7b-7aa1-d98b-74be-62d7c055542b@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 10, 2020 at 11:40:34AM +0100, Paolo Bonzini wrote:
> However, f/m/s mean nothing when running virtualized.  First, trying to
> derive any non-architectural property from the f/m/s is going to fail.
> Second, even the host can be anything as long as it's newer than the f/m/s
> that the VM reports (i.e. you can get a Sandy Bridge model and model name
> even if running on Skylake).

Yah, that's why I said "then comes virt and throws all assumptions out."

> See above: how can the hypervisor know a safe value for all MSRs, possibly
> including the undocumented ones?

Not all - just the ones which belong to a model. I was thinking of
having a mapping between f/m/s and a list of MSRs which those models
have - even non-architectural ones - but that's a waste of energy. Why?
Because using the *msr_safe() variants will give you the same thing
without doing any of the MSR lists in KVM and any of that jumping thru
hoops.

Which means, the kernel MSR accessors should be doing _safe(), i.e.,
exception handling, by default. And the non-safe ones - rdmsrl, wrmsrl,
etc, should all be used only in very seldom cases. Hmm, yeah, that would
probably solve this class of problems once and for all.

> If it makes sense to emulate certain non-architectural MSRs we can add them.

See above - probably not worth the effort.

I'll take a look at how ugly it would become to make the majority of MSR
accesses safe.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

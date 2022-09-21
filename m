Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF225C0523
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 19:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiIURL5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 13:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiIURLy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 13:11:54 -0400
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4EC9C200;
        Wed, 21 Sep 2022 10:11:53 -0700 (PDT)
Received: from zn.tnic (p200300ea9733e77f329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e77f:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1E84D1EC058A;
        Wed, 21 Sep 2022 19:11:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1663780308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=zZihCniDI8tfhFO4vqwAEpD+8GtCUUxL/p4YLiWpZg8=;
        b=UoZZutyWNC3FkK5dRPhoALhO+RzO67cnT86qzhc66sA7G0/7VcD1vBJE18zEGNgOOkgHF4
        ekgJCTzq5m/vDM2gyqwoWg7KJd+wkJScFmkyvK2NP+o8k+fzvEwNuvF5eCekGBbAyt9+vJ
        vBqgju55puczFtlL8EIcLy1wkptYRno=
Date:   Wed, 21 Sep 2022 19:11:42 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/3] KVM: EFER.LMSLE cleanup
Message-ID: <YytFzvQx0BbSCT7m@zn.tnic>
References: <20220920205922.1564814-1-jmattson@google.com>
 <Yyot34LGkFR2/j5f@zn.tnic>
 <CALMp9eQijCKS-E_OWJkxdqAur3BthciOWEtEPH5YKd0-HJiQQA@mail.gmail.com>
 <YyrZOLq8z+lIORvP@zn.tnic>
 <CALMp9eRG6g-95zCxTD1NnxpZ+Vm6VMTA0_uaHV=b-hDkeOYSuA@mail.gmail.com>
 <YysXeXKY36yXj68q@zn.tnic>
 <CALMp9eTuO79+NfHxLi8FnqdOpzXO7eQUntvN23EfR+shg+wg2Q@mail.gmail.com>
 <Yys2ikzV73upzlEj@zn.tnic>
 <CALMp9eQ-qkjBm8qPhOaMzZLWeHJcrwksV+XLQ9DfOQ_i1aykqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALMp9eQ-qkjBm8qPhOaMzZLWeHJcrwksV+XLQ9DfOQ_i1aykqQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 21, 2022 at 09:23:40AM -0700, Jim Mattson wrote:
> AMD defined the 64-bit x86 extensions while Intel was distracted with
> their VLIW science fair project. In this space, Intel produces AMD64
> compatible CPUs.

Almost-compatible. And maybe, just maybe, because Intel were probably
and practically forced to implement AMD64 but then thought, oh well,
we'll do some things differently.

> The definitive specification comes from AMD (which is sad, because
> AMD's documentation is abysmal).

Just don't tell me the SDM is better...

But you and I are really talking past each other: there's nothing
definitive about a spec if, while implementing it, the other vendor is
doing some subtle, but very software visible things differently.

I.e., the theory vs reality point I'm trying to get across.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

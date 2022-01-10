Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3AC489C20
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 16:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236150AbiAJPZH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 10:25:07 -0500
Received: from mail.skyhub.de ([5.9.137.197]:38124 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236140AbiAJPZG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 10:25:06 -0500
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2EED21EC057F;
        Mon, 10 Jan 2022 16:25:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1641828301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=JcKyfT03HQRyetzAup8js7asR0ilVLmbmT8dYb/zGME=;
        b=eluuWklBiN7zb5uOfQCpiOUZz3jAv6b7bFEnh2xAWS8X1zgiapVDV7GDqhgW9dCFRQbVWq
        9tTVPIwFdo4STvQw4MJj0LBgMluj+im7bh9SaqZHDo6Zf5kzR3MchzvGuer2YbFrxE3mql
        jG8PX3bgfQxuHWOPF4DTHU5wF7YA8FM=
Date:   Mon, 10 Jan 2022 16:25:04 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Zeng, Guang" <guang.zeng@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>
Subject: Re: [PATCH v6 05/21] x86/fpu: Make XFD initialization in
 __fpstate_reset() a function argument
Message-ID: <YdxP0FVWEJa/vrPk@zn.tnic>
References: <20220107185512.25321-1-pbonzini@redhat.com>
 <20220107185512.25321-6-pbonzini@redhat.com>
 <YdiX5y4KxQ7GY7xn@zn.tnic>
 <BN9PR11MB527688406C0BDCF093C718858C509@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Ydvz0g+Bdys5JyS9@zn.tnic>
 <761a554a-d13f-f1fb-4faf-ca7ed28d4d3a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <761a554a-d13f-f1fb-4faf-ca7ed28d4d3a@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 10, 2022 at 03:18:26PM +0100, Paolo Bonzini wrote:
> Say a patch went A->B->C->A->D and all of {A,B,C} were involved in the
> development at different times.  The above text says "any further SoBs are
> from people not involved in its development", in other words it doesn't
> cover the case of multiple people handling different versions of a patch
> submission.

Well, if I'm reading Kevin's mail correctly, it sounds like Thomas
updated it (and I'm pretty sure he doesn't care about Co-developed-by)
and the rest of the folks simply handled it.

In the interest of remaining practical, I'd say one doesn't have to add
Co-developed-by when one is doing contextual changes or addressing minor
review feedback, or, of course, simply handling the patch as part of a
series.

> The only clear thing from the text would be "do not remove/move the
> author's Signed-off-by", but apart from that it's wild wild west and
> there are contradictions everywhere.

The main point in that paragraph is that the SOB chain needs to denote
how that patch went upstream and who handled it on the way. So you can't
simply shorten or reorder the SOBs.

What is more, even if you cherry-pick a patch which doesn't have your
SOB at the end - for example, tglx applies a patch and I cherry-pick it
into a different branch - I must add my SOB because, well, I handled it.

> For example:
> 
> 1) checkpatch.pl wants "Co-developed-by" to be immediately followed by
> "Signed-off-by".  Should we imply that all SoB entries preceded by
> Co-developed-by do not exactly reflect the route that the patch took (since
> there could be multiple back and forth)?

Co-developed-by is to express multiple-people's authorship. And that
rule checkpatch enforces is already in submitting-patches:

"Since Co-developed-by: denotes authorship, every Co-developed-by:
must be immediately followed by a Signed-off-by: of the associated
co-author."

> 
> 2) if the author sends the patches but has co-developers, should they be
> first (because they're the author) or last (because they're the one actually
> sending the patch out)?

That is also explained there:

"Standard sign-off procedure applies, i.e. the ordering of
Signed-off-by: tags should reflect the chronological history of
the patch insofar as possible, regardless of whether the author
is attributed via From: or Co-developed-by:. Notably, the last
Signed-off-by: must always be that of the developer submitting the
patch."

> Any consistent rules that I could come up with are too baroque to be
> practical:
> 
> 1) a sequence consisting of {SoB,Co-developed-by,SoB} does not necessarily
> reflect a chain from the first signoff to the second signoff

Right, if you want to attribute co-authorship too - at least I think
this is what you mean - then you can do that according to the last
snippet I pasted. IOW, you'd need to do:

Co-developed-by: A
SOB: A
Co-developed-by: B
SOB: B
SOB: C

etc.

Or remain practical and do only an SOB chain. But it all depends
on who has co-authored what and what kind of attribution the
co-authors/handlers prefer.

> 2) if you are a maintainer committing a patch so that it will go to Linus,
> just add your SoB line.

Ack.

> 3) if you pick up someone else's branch or posted series, and you are not in
> the existing SoB chain, you must add a Co-developed-by and SoB line for
> yourself.

Just SOB, as stated above. Because you handled the patch.

> The maintainers must already have a bad case of Stockholm syndrome for not
> having automated this kind of routine check, but it would be even worse if
> we were to inflict this on the developers.

Well, usually, the SOB chain is pretty simple and straight-forward.

In this particular case, I'd simply add my SOB when I've handled the
patch. If I've done big changes and I think I'd like to be listed as an
author, I'd do Co-developed but other than that, just the SOB.

> In the end, IMHO the real rules
> that matter are:
> 
> - there should be a SoB line for the author

Yap.

> - the submitter must always have the last SoB line

Yap.

> - SoB lines shall never be removed

And their order should be kept too as the path upstream is important,
obviously.

> - maintainers should prefer merge commits when moving commits from one tree
> to the other

It depends.

> - merge commits should have a SoB line too

Yap, we do that in the tip tree and document the reason for the merge
commit.

> Everything else, including the existence of Co-developed-by lines, is an
> unnecessary complication.

See above.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

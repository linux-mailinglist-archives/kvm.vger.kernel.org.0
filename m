Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D23305721
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 10:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbhA0Jkb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 04:40:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:46536 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234249AbhA0Ji5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 04:38:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4D04AAD78;
        Wed, 27 Jan 2021 09:38:16 +0000 (UTC)
Date:   Wed, 27 Jan 2021 10:38:10 +0100
From:   Borislav Petkov <bp@suse.de>
To:     "Bae, Chang Seok" <chang.seok.bae@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 06/21] x86/fpu/xstate: Calculate and remember dynamic
 xstate buffer sizes
Message-ID: <20210127093810.GA8115@zn.tnic>
References: <20201223155717.19556-1-chang.seok.bae@intel.com>
 <20201223155717.19556-7-chang.seok.bae@intel.com>
 <20210122114430.GB5123@zn.tnic>
 <6811FA0A-21A6-4519-82B8-C128C30127E0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6811FA0A-21A6-4519-82B8-C128C30127E0@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 27, 2021 at 01:23:35AM +0000, Bae, Chang Seok wrote:
> How about ‘embedded’?,
>     “The xstate buffer is currently embedded into struct fpu with static size."

Better.

> Okay. I will prepare a separate cleanup patch that can be applied at the end
> of the series. Will post the change in this thread at first.

No, this is not how this works. Imagine you pile up a patch at the end
for each review feedback you've gotten. No, this will be an insane churn
and an unreviewable mess.

What you do is you rework your patches like everyone else.

Also, thinking about this more, I'm wondering if all those
xstate-related attributes shouldn't be part of struct fpu instead of
being scattered around like that.

That thing - struct fpu * - gets passed in everywhere anyway so all that
min_size, max_size, ->xstate_ptr and whatever, looks like it wants to be
part of struct fpu. Then maybe you won't need the accessors...

> One of my drafts had some internal helper to be called in there. No reason
> prior to applying the get_xstate_buffer_attr() helper. But with it, better to
> move this out of this header file I think.

See above.

> 
> >> @@ -627,13 +627,18 @@ static void check_xstate_against_struct(int nr)
> >>  */
> > 
> > <-- There's a comment over this function that might need adjustment.
> 
> Do you mean an empty line? (Just want to clarify.)

No, I mean this comment:

 * Dynamic XSAVE features allocate their own buffers and are not
 * covered by these checks. Only the size of the buffer for task->fpu
 * is checked here.

That probably needs adjusting as you do set min and max size here now
for the dynamic buffer.

> Agreed. I will prepare a patch. At least will post the diff here.

You can send it separately from this patchset, ontop of current
tip/master, so that I can take it now.

> How about:
>     “Ensure the size fits in the statically-allocated buffer:"

Yep.

> No excuse, just pointing out the upstream code has “we” there [1].

Yeah, I know. :-\

But considering how many parties develop the kernel now, "we" becomes
really ambiguous.

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg

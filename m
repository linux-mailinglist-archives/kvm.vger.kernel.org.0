Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD87348D80
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 10:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhCYJ5E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 05:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhCYJ4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 05:56:33 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701FAC06174A;
        Thu, 25 Mar 2021 02:56:33 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0d5d00784c9f440731cfd1.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:5d00:784c:9f44:731:cfd1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 57DD71EC0402;
        Thu, 25 Mar 2021 10:56:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616666180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=vZugkItkHUxPGcT3QUZAnpg+cYnx/DrzW+0wDfNLiPw=;
        b=UF6icgnek4xGi8in1o07q1ka9DdlhnOqBGKmkXqdcrrulx0OwsDEVflxSjOkdZW/9KOe47
        Tjl68G+ZKPbAPGDOdsjUuiXm3rljUeybhO8iMS0W79NfMvzG4KmlAy5vAWH4PL46qcgMxs
        CA9fMH5T5ZSoSWr9EqhkAB/wFpWsPUU=
Date:   Thu, 25 Mar 2021 10:56:19 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Hugh Dickins <hughd@google.com>
Cc:     Babu Moger <babu.moger@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
Message-ID: <20210325095619.GC31322@zn.tnic>
References: <20210311203206.GF5829@zn.tnic>
 <2ca37e61-08db-3e47-f2b9-8a7de60757e6@amd.com>
 <20210311214013.GH5829@zn.tnic>
 <d3e9e091-0fc8-1e11-ab99-9c8be086f1dc@amd.com>
 <4a72f780-3797-229e-a938-6dc5b14bec8d@amd.com>
 <20210311235215.GI5829@zn.tnic>
 <ed590709-65c8-ca2f-013f-d2c63d5ee0b7@amd.com>
 <20210324212139.GN5010@zn.tnic>
 <alpine.LSU.2.11.2103241651280.9593@eggly.anvils>
 <alpine.LSU.2.11.2103241913190.10112@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.2103241913190.10112@eggly.anvils>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 24, 2021 at 07:43:29PM -0700, Hugh Dickins wrote:
> Right, after looking into it more, I completely agree with you:
> the Kaiser series (in both 4.4-stable and 4.9-stable) was simply
> wrong to lose that invlpg - fine in the kaiser case when we don't
> enable Globals at all, but plain wrong in the !kaiser_enabled case.
> One way or another, we have somehow got away with it for three years.

Yeah, because there were no boxes with kaiser_enabled=0 *and* PCID
which would set INVPCID_SINGLE. Before those, it would INVLPG in the
!INVPCID_SINGLE case.

Oh, btw, booting with "pci=on" "fixes" the issue too. And I tried
reproducing this on an Intel box with "pti=off" but it booted fine
so I'm probably missing some other aspect or triggering it there is
harder/different due to TLB differences or whatnot.

And Babu triggered the same issue on a AMD baremetal yesterday.

> I do agree with Paolo that the PCID_ASID_KERN flush would be better
> moved under the "if (kaiser_enabled)" now.

Ok.

> (And if this were ongoing development, I'd want to rewrite the
> function altogether: but no, these old stable trees are not the place
> for that.)

Bah, it brought some very mixed memories, wading through that code
after years. And yeah, people should stop using all these dead kernels
already! So yeah, no, you don't want to clean up stuff there - let
sleeping dogs lie.

> Boris, may I leave both -stable fixes to you?
> Let me know if you'd prefer me to clean up my mess.

No worries, I'll take care of it.

> Thanks a lot for tracking this down,

Thanks for double-checking me so quickly, lemme whip up a patch.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

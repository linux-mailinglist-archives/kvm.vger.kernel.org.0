Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977F33E1BE7
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 20:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242028AbhHES7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 14:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241659AbhHES7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 14:59:13 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA696C061765
        for <kvm@vger.kernel.org>; Thu,  5 Aug 2021 11:58:58 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id mt6so11183604pjb.1
        for <kvm@vger.kernel.org>; Thu, 05 Aug 2021 11:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AH1b17dDAm/qClYUiQkfkIc/DiudItItOitQI5OYb/U=;
        b=tmO87efnMKj/JrtHmZLrag/DnLynQgiK4FaL11paV2xYLHtaZwGo7krk+1DbL3+c+O
         eew7F8J5WjV+ZXv5wfbDO7tZz1u/mjeiCf2mQQrLfoFTSoPxJx/csidMWS1+IuProPY9
         vp0IC9IgmLNXf9FtWHsrIVV2Sht6bCHcHkBTUW/S20dcI9aFidqjlhz0OhcKfI4jU7gG
         dLCeOLuJlcrO1I1bIw8ELwkeoMqbI4wl4cnOS0oyoDra+pLER+ygs1Q/2rIlBSJACOsx
         G8iSXVt97Hf9Q5HwDGy075FZeSnJD2ZOKA5e/+tXw6gx/UE+MHwPH/Ta9q6eKvwtvwMg
         Ecfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AH1b17dDAm/qClYUiQkfkIc/DiudItItOitQI5OYb/U=;
        b=H82sYv/kHhKUBRkgpeXmePcfsyAPRatt8jjybVJiu5fX9ctIet+MxyBJkvuFVJKWWA
         0SlvPCWvxTMqFTma7dyqBWXoVFw/+TAvp2p1kNsyATxaA+MZm9kP706Z+W/RbzFJ2arV
         g7gLgD/ZbUZZXquqbb9JIksglYVqgCJKoiFlD2eyh1Fhqd3m8HkmZIQfM0oQLFwGqoI/
         2ncPjcsq7Y1mewRs7j+GHDEkdWHDK2bqiTeNeEEa34apJW5ALUyrX8/SXGbixRNy5FeV
         LNhHmTqVVzBw7jUcsVa1Sd3un9c4NjtW0ysozTisel8zIj9MOk+gd6IaiQ7pT5K+NeT8
         fVbg==
X-Gm-Message-State: AOAM533WgE+JVltEL/DbkYuV0UZisY9OxD8QfIaX+6HyFC6fNLcZl8Ue
        O/o2isEEHr8szT+WjXnbOjRqYw==
X-Google-Smtp-Source: ABdhPJzFehhn1rOCcmdBH4KiuYrRG8mStNCrpTEN/LDqbgfeiVL/Co6P+cULgf9dd9JshTOpqCNjjw==
X-Received: by 2002:a62:dd83:0:b029:30f:d69:895f with SMTP id w125-20020a62dd830000b029030f0d69895fmr846153pff.17.1628189938023;
        Thu, 05 Aug 2021 11:58:58 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g23sm8197040pfu.174.2021.08.05.11.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 11:58:57 -0700 (PDT)
Date:   Thu, 5 Aug 2021 18:58:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc:     "erdemaktas@google.com" <erdemaktas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "ckuehl@redhat.com" <ckuehl@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
Subject: Re: [RFC PATCH v2 41/69] KVM: x86: Add infrastructure for stolen GPA
 bits
Message-ID: <YQw07f/I72/b58pR@google.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <c958a131ded780808a687b0f25c02127ca14418a.1625186503.git.isaku.yamahata@intel.com>
 <20210805234424.d14386b79413845b990a18ac@intel.com>
 <YQwMkbBFUuNGnGFw@google.com>
 <78b802bbcf72a087bcf118340eae89f97024d09c.camel@intel.com>
 <YQwiPNRYHtnMA5AL@google.com>
 <7231028edae70dfaeab304d6206d4426b9233f41.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7231028edae70dfaeab304d6206d4426b9233f41.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 05, 2021, Edgecombe, Rick P wrote:
> On Thu, 2021-08-05 at 17:39 +0000, Sean Christopherson wrote:
> > If we really want to reduce the memory footprint for the common case (TDP
> > MMU), the crud that's used only by indirect shadow pages could be shoved
> > into a different struct by abusing the struct layout and and wrapping
> > accesses to the indirect-only fields with casts/container_of and helpers,
> > e.g.
> > 
> Wow, didn't realize classic MMU was that relegated already. Mostly an
> onlooker here, but does TDX actually need classic MMU support? Nice to
> have?

Gah, bad verbiage on my part.  I didn't me _the_ TDP MMU, I meant "MMU that uses
TDP".  The "TDP MMU" is being enabled by default in upstream, whether or not TDX
needs to support the classic/legacy MMU is an unanswered question.  From a
maintenance perspective, I'd love to say no, but from a "what does Google actually
want to use for TDX" perspective, I don't have a defininitive answer yet :-/

> > The role is already factored into the collision logic.
>
> I mean how aliases of the same gfn don't necessarily collide and the
> collisions counter is only incremented if the gfn/stolen matches, but
> not if the role is different.

Ah.  I still think it would Just Work.  The collisions tracking is purely for
stats, presumably used in the past to see if the hash size was effective.  If
a hash lookup collides then it should be accounted, _why_ it collided doesn't
factor in to the stats.

Your comments about the hash behavior being different still stand, though for
TDX they wouldn't matter in practice since KVM is hosed if it has both shared and
private versions of a shadow page.

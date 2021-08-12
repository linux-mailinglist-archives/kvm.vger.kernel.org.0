Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A574E3EA208
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 11:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbhHLJaI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 05:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234824AbhHLJ3w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 05:29:52 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F3AC0613D3
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 02:29:27 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id be20so9322353oib.8
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 02:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U79XFkLmbTn8yZV9qpDrY5ksUSwcFQWwCLlxy1S3ZCM=;
        b=XrAlKvRO3IhvRdo1OfWHbg5fICmE2y0uYSwhfVvs4rYQN5CsIicsYYx6Bs4fvQnjgZ
         1/hpL5TdfGpaLaNtdcGvPBeWvKk9rEqJGgPOYiuE8PeSQq/Bp+L6vzIUH7vP8RS5UiCD
         S446ike5fw0AnQivnWAK1804te/Ob8vIu1CzthWvfbYZVJMEOzyP8sKTFKNHq5j0HqpT
         a8El6dzjZNsuBOljCrPy+L/RGS8k7Uk+j+BCtfS+Nr5DfOg9ETkSRCRT42zKL+wSYKs+
         QZgYYQ+Q7DRIRJjmSg3t5RF45otrrW1S3LT5N++xJgdcQ9882GV8NuvDQdqM26arapJ9
         OXZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U79XFkLmbTn8yZV9qpDrY5ksUSwcFQWwCLlxy1S3ZCM=;
        b=EOFUYeeuxW9I+E/LX2tTVAvCpsjtA3QZAOfb3i6LjDgo04dN++GquMkP4jVqJ5z+3l
         IufVvBzdSPzEYwmZ2ypKJqIZDEjyVoHs5YtNEWG0BRMleB8TgIPbIuVKwPc0b4gcvtxM
         CZoAYrVyAo7l54yv6Is6J14ugXAt7qtRk9o8y9x7l5XdstxLc/Xi74kFI5Cc2vTKQGvx
         mjxTGHpLvMv4hh8XudvzPG85dLAiBF0KQseA1YSSnWFTznC66UGhsmx6pcQqKHyECTHc
         GyjKwFB/bD3yOBAq7Wg5dqOtWPVd9vylrwl++lGyH2rjEPt/E+1RwaUwFR4WrfZcQKwu
         jnnA==
X-Gm-Message-State: AOAM53053CrcOWSGHoAqCF3Q3E3FKX9uiFflB4OZqUD9u+gQTsx+mzN3
        mX2An6u0W/OCFDmgnS6m20/0SuakO+Po4VWfvzUPtw==
X-Google-Smtp-Source: ABdhPJy/aFf9zz0FkODqeQLUSWtM0BsR7RoSxRgsEV4qM8uv4EK7odLD7bTl7wQy0/py2mv9baEX0r2aaorTwAPxZfU=
X-Received: by 2002:aca:220a:: with SMTP id b10mr10630360oic.8.1628760566696;
 Thu, 12 Aug 2021 02:29:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com> <20210719160346.609914-7-tabba@google.com>
 <20210720145258.axhqog3abdvtpqhw@gator> <CA+EHjTweLPu+DQ8hR9kEW0LrawtaoAoXR_+HmSEZpP-XOEm2qg@mail.gmail.com>
 <20210812084600.GA5912@willie-the-truck>
In-Reply-To: <20210812084600.GA5912@willie-the-truck>
From:   Fuad Tabba <tabba@google.com>
Date:   Thu, 12 Aug 2021 11:28:50 +0200
Message-ID: <CA+EHjTx7q+DeR2dNL9X6jLcqtr=ZZ5YN4WsnnbOUPvtQZP1dSQ@mail.gmail.com>
Subject: Re: [PATCH v3 06/15] KVM: arm64: Restore mdcr_el2 from vcpu
To:     Will Deacon <will@kernel.org>
Cc:     Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu,
        maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com,
        christoffer.dall@arm.com, pbonzini@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Will,

On Thu, Aug 12, 2021 at 10:46 AM Will Deacon <will@kernel.org> wrote:
>
> On Wed, Jul 21, 2021 at 08:37:21AM +0100, Fuad Tabba wrote:
> > On Tue, Jul 20, 2021 at 3:53 PM Andrew Jones <drjones@redhat.com> wrote:
> > >
> > > On Mon, Jul 19, 2021 at 05:03:37PM +0100, Fuad Tabba wrote:
> > > > On deactivating traps, restore the value of mdcr_el2 from the
> > > > newly created and preserved host value vcpu context, rather than
> > > > directly reading the hardware register.
> > > >
> > > > Up until and including this patch the two values are the same,
> > > > i.e., the hardware register and the vcpu one. A future patch will
> > > > be changing the value of mdcr_el2 on activating traps, and this
> > > > ensures that its value will be restored.
> > > >
> > > > No functional change intended.
> > >
> > > I'm probably missing something, but I can't convince myself that the host
> > > will end up with the same mdcr_el2 value after deactivating traps after
> > > this patch as before. We clearly now restore whatever we had when
> > > activating traps (presumably whatever we configured at init_el2_state
> > > time), but is that equivalent to what we had before with the masking and
> > > ORing that this patch drops?
> >
> > You're right. I thought that these were actually being initialized to
> > the same values, but having a closer look at the code the mdcr values
> > are not the same as pre-patch. I will fix this.
>
> Can you elaborate on the issue here, please? I was just looking at this
> but aren't you now relying on __init_el2_debug to configure this, which
> should be fine?

I *think* that it should be fine, but as Drew pointed out, the host
does not end up with the same mdcr_el2 value after the deactivation in
this patch as it did after deactivation before this patch. In my v4
(not sent out yet), I have fixed it to ensure that the host does end
up with the same value as the one before this patch. That should make
it easier to check that there's no functional change.

I'll look into it further, and if I can convince myself that there
aren't any issues and that this patch makes the code cleaner, I will
add it as a separate patch instead to make reviewing easier.

Thanks,
/fuad

> Will

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40070460085
	for <lists+kvm@lfdr.de>; Sat, 27 Nov 2021 18:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355608AbhK0Rcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Nov 2021 12:32:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41564 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346414AbhK0Rak (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 27 Nov 2021 12:30:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638034045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zQkcR9i5clHeNsrtOztHmizggbBo17IKKNg3wYL/MF8=;
        b=huLJyfuhZeIF64faoUM8cwqvHbhXJh6/vNz7gFxfkzoNK/XzjkM/0Tbm/NC31xlf/NVixg
        wlmzfrstVTmNBqlT7V/R7u08Up2DhKIg6ht9gwCFKUcNKSP+q5QzTQRUQKqvdt1U9W689G
        rzwPfSGbdBTeF5yP4TUiqB/i9oNixao=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-4fIpZ-ZOMaaYRFyhgzjWnQ-1; Sat, 27 Nov 2021 12:27:24 -0500
X-MC-Unique: 4fIpZ-ZOMaaYRFyhgzjWnQ-1
Received: by mail-ed1-f72.google.com with SMTP id v10-20020aa7d9ca000000b003e7bed57968so10241615eds.23
        for <kvm@vger.kernel.org>; Sat, 27 Nov 2021 09:27:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zQkcR9i5clHeNsrtOztHmizggbBo17IKKNg3wYL/MF8=;
        b=bu+SJY5tRSdZbHR2WtKp3HE7285TryvanRHsAhInzW3Zpmo0I6bE2vo8vPff33ASNU
         M44xL9ApA9Ql7X3iZOGmN46qVnTjrEkTofvsc9R4djXOiPSIxTWTJM4zZo9H7HoaoA++
         eT+ATm6LpPKxfNzONt19V7w+yqUWkLoPaZ77gl4Wjp8/QYGE7lAm3qgj+06qvzHYP4Um
         zwW86M0EVfv959EdWjAeRi4OUTwzNus/HudfO0DokFUA1J+Viwk487HVrlVGDY6bBqj6
         OsLMhVTf1ZpNXvrGpRlYCpjvXuwBquPMi0239dVfdI6D1QeSaQZI6E9SUV663m6DOdRG
         H4LQ==
X-Gm-Message-State: AOAM531YPv2HZBHu2xX1DRjckVfm8cTV6/f36/rKg9Z7LJoEStHzk1nv
        iX1e8jxMxnWO5tPbACFubBdoEsK3cse3C7j4cfINSC383pgSISz81nsfJDTj+x/Ej79HxtoOnZC
        kOm9hgA0tgVTb
X-Received: by 2002:a05:6402:6d2:: with SMTP id n18mr57419253edy.210.1638034043027;
        Sat, 27 Nov 2021 09:27:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJytLtoKh7WUSMD7CfwDREP8JjUQlvCtlwQbJa6dQEbUdPHTgSMZDAvdxnXvttVwBzigk1UUmA==
X-Received: by 2002:a05:6402:6d2:: with SMTP id n18mr57419219edy.210.1638034042845;
        Sat, 27 Nov 2021 09:27:22 -0800 (PST)
Received: from gator.home (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
        by smtp.gmail.com with ESMTPSA id jg36sm5154065ejc.44.2021.11.27.09.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 09:27:22 -0800 (PST)
Date:   Sat, 27 Nov 2021 18:27:20 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH v2 04/11] KVM: arm64: Setup a framework for hypercall
 bitmap firmware registers
Message-ID: <20211127172720.zte6wfdguoyi3gd6@gator.home>
References: <20211113012234.1443009-1-rananta@google.com>
 <20211113012234.1443009-5-rananta@google.com>
 <87wnl0cdfn.wl-maz@kernel.org>
 <CAJHc60ydffBkqqb6xyObiK-66psaPODsOo0DpLFv7thx=zHjZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHc60ydffBkqqb6xyObiK-66psaPODsOo0DpLFv7thx=zHjZw@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 23, 2021 at 10:34:23AM -0800, Raghavendra Rao Ananta wrote:
> On Mon, Nov 22, 2021 at 9:23 AM Marc Zyngier <maz@kernel.org> wrote:
> > I keep being baffled by this. Why should we track the VMM accesses or
> > the VMM writeback? This logic doesn't seem to bring anything useful as
> > far as I can tell. All we need to ensure is that what is written to
> > the pseudo-register is an acceptable subset of the previous value, and
> > I cannot see why this can't be done at write-time.
> >
> > If you want to hide this behind a capability, fine (although my guts
> > feeling is that we don't need that either). But I really want to be
> > convinced about all this tracking.
> >
> The tracking of each owner register is necessary here to safe-guard
> the possibility that the user-space may not be aware of a newly
> introduced register, and hence, hasn't accessed it. If it had at least
> read the register, but not write-back, we assume that the user-space
> is happy with the configuration. But the fact that the register has
> not even been read would state that user-space is unaware of the
> existence of this new register. In such a case, if we don't sanitize
> (clear all the bits) this register, the features will be exposed
> unconditionally to the guest.
> 
> The capability is introduced here to make sure that this new
> infrastructure is backward compatible with old VMMs. If the VMMs don't
> enable this capability, they are probably unaware of this, and this
> will work as it always has- expose new services to the guest
> unconditionally as and when they are introduced.

Hi Raghavendra,

I don't think we need a CAP that has to be enabled or to make any
assumptions or policy decisions in the kernel. I think we just need to
provide a bit more information to the VMM when it checks if KVM has the
CAP. If KVM would tell the VMM how may pseudo registers there are, which
can be done with the return value of the CAP, then the VMM code could be
something like this

  r = check_cap(KVM_CAP_ARM_HVC_FW_REG_BMAP);
  if (r) {
    num_regs = r;

    for (idx = 0; idx < num_regs; ++idx) {
      reg = hvc_fw_reg(idx);

      if (idx > vmm_last_known_idx) {
        ...
      } else {
        ...
      }
    }
  }

With this, the VMM is free to decide if it wants to clear all registers
greater than the last index it was aware of or if it wants to let those
registers just get exposed to the guest without knowing what's getting
exposed. Along with documenting that by default everything gets exposed
by KVM, which is the backwards compatible thing to do, then the VMM has
been warned and given everything it needs to manage its guests.

Another thing that might be nice is giving userspace control of how many
pseudo registers show up in get-reg-list. In order to migrate from a host
with a more recent KVM to a host with an older KVM[*] we should only
expose the number of pseudo registers that the older host is aware of.
The VMM would zero these registers out anyway, in order to be compatible
for migration, but that's not enough when they also show up in the list
(at least not with QEMU that aborts migration when the destination
expects less registers than what get-reg-list provides)

[*] This isn't a great idea, but it'd be nice if we can make it work,
because users may want to rollback upgrades or, after migrating to a
host with a newer kernel, they may want to migrate back to where they
started.

Thanks,
drew


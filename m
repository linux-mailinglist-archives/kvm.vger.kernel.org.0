Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D7B3F8FA3
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 22:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243509AbhHZU2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 16:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbhHZU2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 16:28:45 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134ABC061757
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 13:27:58 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id b4so4560515ilr.11
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 13:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AwDm+mXSvlo5Neiekp0GAgNRqFQziU4+j890jb22XOk=;
        b=qeNfkkt3UntsGfR34EMyrGz6DwD4eZGa/xrYQ0kX3UP52yq2/1YyMxaDslK4Tsler8
         C2KD8TEdVVKz/jSaS3VS053Djd4dzRCkEnDC3fgmqMl4yaYJYs+NVu6DMqLRq+4ZIseZ
         BZmWyU+ILyFVViRWa33c/pp9kUAHe+mgq8P6S0Wh2gF68UquFTqVyWGSCjqMp/lR+SDi
         89KUDLXNZhKY92uHH6y/JBJZ0J4t6UoR7CiPWLJ2rspNHd7EG32Tbkb6gcZVpFyyIBg/
         gBTRY85POJ0UeKuKSUMhxLSO2aQRKW4CXZZk29uLFXndKYrQBwjUrz3cWVVlj+83olMy
         jF4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AwDm+mXSvlo5Neiekp0GAgNRqFQziU4+j890jb22XOk=;
        b=r9i0l76Ur/y6hgHKUTAs0LLuMh7cEMdH2NYepdH9ewXbdRnloHF0zSjDlrkbCrJ1iG
         N5nOpgHfyco4bF8VHHj8gUlotR4YQzURrU8oiI1lzoZHFVPqQyTcWrB3bHLo3sq9iyL2
         DFYABkMT+vxBhufkxaf4R6yDGk/AK74O1ywHowRVmKa9c2wr3iLG55sDkEK6Thfpo1wS
         xQuw6v8+7zEyZXiXCKKA1q6VCg5ohScbeNnly0XmMehbqTzKkCsX2S1j8H8HMcizwny3
         kphZPWKDjvA5XngEFZUAoXZZEPtpTyloP64JCdaBoadkz24y0C/hoj+kX6gJE1nHlWC2
         utBA==
X-Gm-Message-State: AOAM532uBpva9J9TWXjN3xg0FAS0cx/EIDFGdG2It80E6j6Y5fs3kclU
        HizC4ow21FiARGT+wIVeO0MRNw==
X-Google-Smtp-Source: ABdhPJxeTBH+DbI4bX1tRHeZzKIvT/4efUkT/jM1XYfogFV5usnZuUXcUrUYOTAvOqiM4kxoO07UxQ==
X-Received: by 2002:a05:6e02:128b:: with SMTP id y11mr3913467ilq.104.1630009677230;
        Thu, 26 Aug 2021 13:27:57 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id o2sm2359596ilg.47.2021.08.26.13.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 13:27:56 -0700 (PDT)
Date:   Thu, 26 Aug 2021 20:27:53 +0000
From:   Oliver Upton <oupton@google.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v7 6/6] KVM: x86: Expose TSC offset controls to userspace
Message-ID: <YSf5SV0AZMvfIEib@google.com>
References: <20210816001130.3059564-1-oupton@google.com>
 <20210816001130.3059564-7-oupton@google.com>
 <CAOQ_Qsj_MfRNRRSK1UswsfBw4c9ugSW6tKXNua=3O78sHEonvA@mail.gmail.com>
 <20210826124836.GA155749@fuller.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826124836.GA155749@fuller.cnet>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Marcelo,

On Thu, Aug 26, 2021 at 09:48:36AM -0300, Marcelo Tosatti wrote:
> On Mon, Aug 23, 2021 at 01:56:30PM -0700, Oliver Upton wrote:
> > Paolo,
> > 
> > On Sun, Aug 15, 2021 at 5:11 PM Oliver Upton <oupton@google.com> wrote:
> > >
> > > To date, VMM-directed TSC synchronization and migration has been a bit
> > > messy. KVM has some baked-in heuristics around TSC writes to infer if
> > > the VMM is attempting to synchronize. This is problematic, as it depends
> > > on host userspace writing to the guest's TSC within 1 second of the last
> > > write.
> > >
> > > A much cleaner approach to configuring the guest's views of the TSC is to
> > > simply migrate the TSC offset for every vCPU. Offsets are idempotent,
> > > and thus not subject to change depending on when the VMM actually
> > > reads/writes values from/to KVM. The VMM can then read the TSC once with
> > > KVM_GET_CLOCK to capture a (realtime, host_tsc) pair at the instant when
> > > the guest is paused.
> > >
> > > Cc: David Matlack <dmatlack@google.com>
> > > Cc: Sean Christopherson <seanjc@google.com>
> > > Signed-off-by: Oliver Upton <oupton@google.com>
> > 
> > Could you please squash the following into this patch? We need to
> > advertise KVM_CAP_VCPU_ATTRIBUTES to userspace. Otherwise, happy to
> > resend.
> > 
> > Thanks,
> > Oliver
> 
> Oliver,
> 
> Is there QEMU support for this, or are you using your own
> userspace with this?

Apologies for not getting back to you on your first mail. Sadly, I am
using our own userspace for this. That being said, adding support to
QEMU shouldn't be too challenging. I can take a stab at it if it makes
the series more amenable to upstream, with the giant disclaimer that I
haven't done work in QEMU before. Otherwise, happy to review someone
else's implementation.

--
Thanks,
Oliver

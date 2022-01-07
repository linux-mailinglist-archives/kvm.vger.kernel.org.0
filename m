Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A16487048
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 03:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345349AbiAGCV2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 21:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344508AbiAGCV1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 21:21:27 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF32C061201
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 18:21:27 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id m6so2424711ybc.9
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 18:21:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w70wbEdrZB71eZ7G5vu7np2TisVg/QSyUt9QnspenOc=;
        b=PJzY3wgh+mwzx/EdpWDTNd9qDUJSucxLoxDlCP73jyOvxKm+qXxPYA1o+dMHW2MdVO
         XI0G0g0Ml2Gv3hYdGaLawxZiY4/2rPyx4OdBV5vHL5nSb8/AGkvP6ZnU4ZX1nHR70mbl
         z4QtjCr0pgIwTgGF1JP2jZ9quepjPmmKr2sWI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w70wbEdrZB71eZ7G5vu7np2TisVg/QSyUt9QnspenOc=;
        b=8K/syjGmAN1fG4faWOzIxBcNVhMxzGg8QyzXpHR3tIIH3ZHbwSiABQmq/Zl/Agaaaq
         N7bsEKG47/v7WVSnwKkUYEoSuui0ua6GszGlNKAMC/2uvjp4mlzki5Pl8wtCrJMpXyJH
         C/gUKYrkaiGOpuCsnXk3S+4m174pUfVYzh87j+eUfvM1D77C4hApzVTvvx43oNuE8leM
         pk1X8fUmJyJOkv1j5mk3sOcIe7ly7oIM8HurrdCC7RpfaGgl+QZxNwy6a+trlDsOvua6
         Hpw8QhO8ctctIoAF+CTrlnTls2RBhxUkjL9dUZR/SB4k+XMiCcwMgrIQgf4HxFMLlMeV
         25yQ==
X-Gm-Message-State: AOAM530yZaPneNCDwZ0GiR9+n9lH+ShGdA5H58HiYQUtS7GkUV4CkE+3
        8GEmQszV/EWFZmEsejVyj2/pAvvkAFtPqxt1veGbPw==
X-Google-Smtp-Source: ABdhPJyuGGdU1B4YPxYw/nS3nAD5s2wMNZ+axp3cZ+2j8IbHcyK/rE3IBGrNqTjmYE1Q7yj1rCOt5p2M1WYW4AGGLcg=
X-Received: by 2002:a25:5ca:: with SMTP id 193mr70981373ybf.406.1641522086754;
 Thu, 06 Jan 2022 18:21:26 -0800 (PST)
MIME-Version: 1.0
References: <20211129034317.2964790-1-stevensd@google.com> <20211129034317.2964790-5-stevensd@google.com>
 <Yc4G23rrSxS59br5@google.com> <CAD=HUj5Q6rW8UyxAXUa3o93T0LBqGQb7ScPj07kvuM3txHMMrQ@mail.gmail.com>
 <YdXrURHO/R82puD4@google.com> <YdXvUaBUvaRPsv6m@google.com>
 <CAD=HUj736L5oxkzeL2JoPV8g1S6Rugy_TquW=PRt73YmFzP6Jw@mail.gmail.com> <YdcpIQgMZJrqswKU@google.com>
In-Reply-To: <YdcpIQgMZJrqswKU@google.com>
From:   David Stevens <stevensd@chromium.org>
Date:   Fri, 7 Jan 2022 11:21:15 +0900
Message-ID: <CAD=HUj5v37wZ9NuNC4QBDvCGO2SyNG2KAiTc9Jxfg=R7neCuTw@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] KVM: mmu: remove over-aggressive warnings
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Chia-I Wu <olv@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > These are the type of pages which KVM is currently rejecting. Is this
> > something that KVM can support?
>
> I'm not opposed to it.  My complaint is that this series is incomplete in that it
> allows mapping the memory into the guest, but doesn't support accessing the memory
> from KVM itself.  That means for things to work properly, KVM is relying on the
> guest to use the memory in a limited capacity, e.g. isn't using the memory as
> general purpose RAM.  That's not problematic for your use case, because presumably
> the memory is used only by the vGPU, but as is KVM can't enforce that behavior in
> any way.
>
> The really gross part is that failures are not strictly punted to userspace;
> the resulting error varies significantly depending on how the guest "illegally"
> uses the memory.
>
> My first choice would be to get the amdgpu driver "fixed", but that's likely an
> unreasonable request since it sounds like the non-KVM behavior is working as intended.
>
> One thought would be to require userspace to opt-in to mapping this type of memory
> by introducing a new memslot flag that explicitly states that the memslot cannot
> be accessed directly by KVM, i.e. can only be mapped into the guest.  That way,
> KVM has an explicit ABI with respect to how it handles this type of memory, even
> though the semantics of exactly what will happen if userspace/guest violates the
> ABI are not well-defined.  And internally, KVM would also have a clear touchpoint
> where it deliberately allows mapping such memslots, as opposed to the more implicit
> behavior of bypassing ensure_pfn_ref().

Is it well defined when KVM needs to directly access a memslot? At
least for x86, it looks like most of the use cases are related to
nested virtualization, except for the call in
emulator_cmpxchg_emulated. Without being able to specifically state
what should be avoided, a flag like that would be difficult for
userspace to use.

> If we're clever, we might even be able to share the flag with the "guest private
> memory"[*] concept being pursued for confidential VMs.
>
> [*] https://lore.kernel.org/all/20211223123011.41044-1-chao.p.peng@linux.intel.com

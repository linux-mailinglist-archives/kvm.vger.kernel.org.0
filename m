Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D118A242421
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 04:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgHLCpb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 22:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbgHLCpb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 22:45:31 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F18C06174A
        for <kvm@vger.kernel.org>; Tue, 11 Aug 2020 19:45:30 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id i80so335489lfi.13
        for <kvm@vger.kernel.org>; Tue, 11 Aug 2020 19:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I22D/ZyQ/Cv8F6i6caDXa3lR8DMfmSosGTv8PJQAON8=;
        b=tCemaJjW8more6GhNfyD71vs1dnRXEwzW1vp+KKVUsLJgwlAXfwMSH08ADWlTr5QfD
         mKea84zb6GSW6o3yBh2uKiaKQaSNa4oLdjfyqe0M3exA3CWRY58opiq5CVqlbv4b78GW
         pLlDJKkUG3Ffi3wwjDxorAxut00MCJ1iSEHCXMTIADa18a1tsL/gSx+VQ48befkn4/QF
         o5Rb3/pjaGor2xv01CPsMu7ktx3/k3vzv/SOwyrbUN15cyNSLPbISRUlszKeKTf6zjw1
         +XzMDjrCisGYzMAbcGwoFpNKbyKwVvmLuzIm+kh9WfJUpZz7m9CbCBTOJiDp9xzlApY1
         FEng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I22D/ZyQ/Cv8F6i6caDXa3lR8DMfmSosGTv8PJQAON8=;
        b=nv5E7VjJJyKnUEeakFzsjLijbd8JEVkiCLwvdhy/JwXG6NATiV61ENpjtUGn/ur91g
         pdEjOnFQkYNl2Nln+Ehl0AcWz2OFvfyKrhKvjo6hVcLnugIRmI6/STuIuuPvnzv/RD5t
         OFLa11gZSyORKg3QzaiuASIqdjrLZFvX6p01544grbe62TZITtzinCNnYNvFYukZ2CXf
         LBeA2JINFVp0JWRZqUMLUBF+QraQY65AaSHACM0c6TQCfFhAmBGvcpvs3PEUeuzKFeFc
         LsRNFZOKG5M+HeVxGD83TSaY3ascLHNHlPi6aXQXmJuPjY3QFkubGvyjgrOGRyocp0kj
         +30g==
X-Gm-Message-State: AOAM531xw0F2s/hFYjwlUWE+MfzUOECaNZ3IMScwm+9nCUzkk09arLZj
        VwzjHhaqaSzYkpYPqJ+Y/npkoZ+J/uIayFWqG0TxPA==
X-Google-Smtp-Source: ABdhPJwbdEOaWIsdZtq+d3ldlbRTdbN17gWjpC1a1/ZKIKomgldx+l6rOGYLfov4gTiPzMVkQD3HS+4e+RvRrrznwPE=
X-Received: by 2002:a19:418a:: with SMTP id o132mr4647733lfa.63.1597200328702;
 Tue, 11 Aug 2020 19:45:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200707223630.336700-1-jmattson@google.com> <20200811193437.286ba711@x1.home>
In-Reply-To: <20200811193437.286ba711@x1.home>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 11 Aug 2020 19:45:17 -0700
Message-ID: <CALMp9eSq-PenitkYiCJu3hXcYsWqi4FCpPnAA2TXfH_rmAxgAw@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: Read PDPTEs on CR0.CD and CR0.NW changes
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>,
        Laszlo Ersek <lersek@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 11, 2020 at 6:34 PM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> On Tue,  7 Jul 2020 15:36:30 -0700
> Jim Mattson <jmattson@google.com> wrote:
>
> > According to the SDM, when PAE paging would be in use following a
> > MOV-to-CR0 that modifies any of CR0.CD, CR0.NW, or CR0.PG, then the
> > PDPTEs are loaded from the address in CR3. Previously, kvm only loaded
> > the PDPTEs when PAE paging would be in use following a MOV-to-CR0 that
> > modified CR0.PG.
> >
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > Reviewed-by: Oliver Upton <oupton@google.com>
> > Reviewed-by: Peter Shier <pshier@google.com>
> > ---
>
> I can't even boot the simplest edk2 VM with this commit:

You'll probably want to apply Sean's [PATCH] KVM: x86: Don't attempt
to load PDPTRs when 64-bit mode is enabled.

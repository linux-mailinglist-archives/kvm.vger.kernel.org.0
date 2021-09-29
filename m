Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D2841CF78
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 00:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347343AbhI2WvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 18:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347173AbhI2WvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 18:51:21 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BC7C06161C
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 15:49:39 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id b5-20020a4ac285000000b0029038344c3dso1253664ooq.8
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 15:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e2OTP9/Iaal3kA6JcGQMsrbP+LXgzXaNrRHpdP8nXFo=;
        b=G28j7WE82ccu1R0Oh+3pL1ssp6lEJumdTGsQ3x7h/CpuqpyWf8R+WjqiopNkB1NB4/
         Zra/3R/RSSJZllQnqZu1Xj+YQ0FxpcgBvNwEkTau1kpz6b68svJZ50NRQ//U0PLJUdQR
         DkUQeMxkcoKtyVm2uxaqrjOAY9i3fC4SerMzZdZVZ9b0XAcmZpL1q6MC3nsv+g3i/jJs
         KUGbfDfWoHVGdrsjpnAkUfMu6i7V5EoF5AJ9nKytt9GVAuQ6+mCdlkFiRcjc4VXFL2Od
         WJfs3bsK32BycM4a0wL1xW5yBug97qJvppkZLkNMUAP6kdwie83+7r/nG3EqS7rGSwvI
         i4/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e2OTP9/Iaal3kA6JcGQMsrbP+LXgzXaNrRHpdP8nXFo=;
        b=0RIj3vi4HbKTMDdTnUWXxW6JD4JKzLoXakUdKEjWFY4G2qlMq+i2rn5jUOd5NBJ9mM
         Rj4HOpupd+iniAyttOzFTdX4/6mhSBI+sugSe4vOnqGVTDUeebWEcKVuZFlImQ3xLWKZ
         RQFBZalLYpkfLbegM0EFCgpoZ2ytFb+RcbZP0IMc/M7V9GnTs5yK+G+XhjDcolLeVQTl
         uGK248LIq8DSINZ/7GQy3CcLIVSX0YfoQOGiMz7AUjlexWd3Qu7TnF4E9f5hBUz5wsFl
         tdiXghnqd1Sx3FsoeLXv1BD8jbXgKMaQVnm74w+uhpEO27DjJASJgL1XMk28aTFmV9Sf
         zEdQ==
X-Gm-Message-State: AOAM533JDPHDNAMHuSDHJR+UWVGzTszKTXF+iQt8OY1wyQ4M+tWmj9UZ
        x/DTMt8fjozw89daoyrs1jQzBKeGlxSHZny9yD/Bgw==
X-Google-Smtp-Source: ABdhPJwfYZYVoJIZCIZZ0IzxjW4zfiQ4Yzrk0WBLtD+ahAtcf/rqByhKxVhje9lfN/nkWtK0vc3A9WW0Qv7Q8g8YFGM=
X-Received: by 2002:a4a:de57:: with SMTP id z23mr2042527oot.70.1632955778679;
 Wed, 29 Sep 2021 15:49:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210929222426.1855730-1-seanjc@google.com> <20210929222426.1855730-3-seanjc@google.com>
In-Reply-To: <20210929222426.1855730-3-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 29 Sep 2021 15:49:27 -0700
Message-ID: <CALMp9eQZH80_vWEz26OGr8cwhLEP4yoSt2UdSC_75Fy9sMxhhQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86: Manually retrieve CPUID.0x1 when getting
 FMS for RESET/INIT
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+f3985126b746b3d59c9d@syzkaller.appspotmail.com,
        Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 29, 2021 at 3:24 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Manually look for a CPUID.0x1 entry instead of bouncing through
> kvm_cpuid() when retrieving the Family-Model-Stepping information for
> vCPU RESET/INIT.  This fixes a potential undefined behavior bug due to
> kvm_cpuid() using the uninitialized "dummy" param as the ECX _input_,
> a.k.a. the index.
>
> A more minimal fix would be to simply zero "dummy", but the extra work in
> kvm_cpuid() is wasteful, and KVM should be treating the FMS retrieval as
> an out-of-band access, e.g. same as how KVM computes guest.MAXPHYADDR.
> Both Intel's SDM and AMD's APM describe the RDX value at RESET/INIT as
> holding the CPU's FMS information, not as holding CPUID.0x1.EAX.  KVM's
> usage of CPUID entries to get FMS is simply a pragmatic approach to avoid
> having yet another way for userspace to provide inconsistent data.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

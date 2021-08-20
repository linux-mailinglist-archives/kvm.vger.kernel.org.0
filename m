Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5A33F33A3
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 20:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238426AbhHTSZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 14:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239615AbhHTSY5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 14:24:57 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C44BC061154
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 11:22:51 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id f10so7554792lfv.6
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 11:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zDMz36x4yKQMykOmV38uNAmEx7fWvh5K0Ht5jE7INgk=;
        b=Y9OO0b8f19YmabyG92B9Kuy1+feyypMWz7BFCyCyfsyYJj+hx3l6T09vZ+qUzq4V5K
         2SlCFAhM4pTllTgtEzfCfFLmrUw/4hU17q70A6oqFWfiZEzOzLr6VHlYrHUlBIkiplJK
         H6pYwQvTQZZeGaGfuBXSErpKKnKEV0Q/U8pU3LnW29oU+SBnMuvJ3ucmaanMUsfWi6mF
         2Btm+e9FpjNvLxzYQZdJid2UhYdOCXlBrDFNbrtYzO3RImslr6lZWxq7FAJ0wrUgF9rn
         sBEa3hNIVj7+hTW2eR9TBuwb/rSH/bBPbKsehu91kbdDr6lEsZBbt/DmRuZI7yMQ9VRH
         iZzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zDMz36x4yKQMykOmV38uNAmEx7fWvh5K0Ht5jE7INgk=;
        b=F+7cJEWzymWf4i6cqUq8F383X5axQfurHYe+jwwOKc1aqce2JqA/7fI4dGTVNOvuTr
         KNKrU/xW9ixhNNhJULOQFyjdpvIjmUEV2nGu8cpNcapCxX/3LAtyXrxZ0sOeGoyb/a1I
         GLUgawx4VCkI97MRdVQTyfrLuG76Fo91wFc6STS1K46rPa6v9w9Zl0buo9EdkbOF1SBV
         mKU77dFSuLhyFXMa+2urwB+ouYpxkjQrxLvuRx+9G3uQcf/pJ1J3JEsBieTG7tixxd6L
         3EcvxgMzdUGM5FJQsDoyycFKzyK/r78PqUQwwOs6WZF6NemX+iLctWseYmmswoyib2a/
         o7hw==
X-Gm-Message-State: AOAM530NUIanw+6xmjfNnG8Fs0mj1QWUzNUnR2ulD6UKSg9jTciU+DmI
        8W94es9Eb/FnUAc8qtfHBmcw9pZ52dPvmbW3iYLDqaNjZRQ=
X-Google-Smtp-Source: ABdhPJzTvCiSF40hWim53AIx0O9SVmdquq5dpPkCWKWdqy+7H6yPirLretuTQkPUsSrtEbmbLIg+wMxDI3XaHyvGxDk=
X-Received: by 2002:ac2:5fc7:: with SMTP id q7mr15153411lfg.524.1629483769092;
 Fri, 20 Aug 2021 11:22:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210816001130.3059564-1-oupton@google.com> <20210816001130.3059564-2-oupton@google.com>
 <20210819182422.GA25923@fuller.cnet>
In-Reply-To: <20210819182422.GA25923@fuller.cnet>
From:   Oliver Upton <oupton@google.com>
Date:   Fri, 20 Aug 2021 11:22:38 -0700
Message-ID: <CAOQ_Qsin6YTUdbGaq3GChFWq_fzmXrKOUTQk7FarqL0b5GqC4g@mail.gmail.com>
Subject: Re: [PATCH v7 1/6] KVM: x86: Fix potential race in KVM_GET_CLOCK
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 19, 2021 at 11:43 AM Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> On Mon, Aug 16, 2021 at 12:11:25AM +0000, Oliver Upton wrote:
> > Sean noticed that KVM_GET_CLOCK was checking kvm_arch.use_master_clock
> > outside of the pvclock sync lock. This is problematic, as the clock
> > value written to the user may or may not actually correspond to a stable
> > TSC.
> >
> > Fix the race by populating the entire kvm_clock_data structure behind
> > the pvclock_gtod_sync_lock.
>
> Oliver,
>
> Can you please describe the race in more detail?
>
> Is it about host TSC going unstable VS parallel KVM_GET_CLOCK ?
>

Yeah, pretty much any event that causes us to set use_master_clock =
false could interleave with the KVM_GET_CLOCK ioctl. A guest could
kick its TSCs out of sync, for example, to cause this too. AFAICT, KVM
serializes the write side (pvclock_update_vm_gtod_copy()) with
pvclock_gtod_sync_lock, as it should.

--
Thanks,
Oliver

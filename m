Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3138E48A3E2
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 00:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245371AbiAJXsA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 18:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242645AbiAJXsA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 18:48:00 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1E1C06173F
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 15:48:00 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id h14so25185064ybe.12
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 15:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V7bvr9AT+ViYWBOgleDYjHyL3H3pc/v4pn7I6M0FLS4=;
        b=ej4Q05pKU/h4KDyI2NuIerKgxTlzLfgmgRTMDjGpIi04yviyVKEEzKlJjDLBIOhpov
         q8t7Q19UYQ4kIvlWeSaP1Rem1sm7GQxYmej8C0FcMpEZIPDIdcfUJorgTtsuo6e88FIu
         dvSWWPxKB+rpjda/P0xhUB/XYqm//hDLsvIaU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V7bvr9AT+ViYWBOgleDYjHyL3H3pc/v4pn7I6M0FLS4=;
        b=jEqITv3rHSFmVBJWEzvAHbEKOEfRlmhzjdalw4v6Tm4GNfcxMM20C8Sd9KvGvhEtrF
         mEjQuKZlxyvZ7vwNDaxDKNsBsT0OFEyrUbDdT0NjnOy7zeOI667bZIScjTNzr8rOAt1P
         MJZ4CwS4hwWXF/hSUrKbsnzjJ0iYaXJW/g+XzE9tsNkxcRVVPukra5sZDUyKyqkl+4Wc
         WBQ4qbNBm0OxeheBMQpNHvOCkRRPBAaYDGgdPJsXtt5wWgj0zJywP1OpPEG38PwZ8vyH
         7+FC0QWBlrGuw719BLqpGEEQ2TO6Gp3X18pErFjCi/ws9QI3qdozpQK6QbM4YsBABOnS
         c0AA==
X-Gm-Message-State: AOAM5306SeafQi8qSBI98Z4KxjGRB8+Y8SQSiEZ/A9HDB24MBF8rjSs+
        VF8myf4FIaM8lHlWWt9syAT05+xk9DfXXjCGa0Mc2tAR3eQ=
X-Google-Smtp-Source: ABdhPJyeO7YkijDBkX0qbEZ6iIfqz7iXNkTSDHSv0/OEgOpdNsr9nTuLp7gzWE192stbi9+nPkUxIl89P+qH+bTZv5Q=
X-Received: by 2002:a05:6902:723:: with SMTP id l3mr2986305ybt.378.1641858479154;
 Mon, 10 Jan 2022 15:47:59 -0800 (PST)
MIME-Version: 1.0
References: <20211129034317.2964790-1-stevensd@google.com> <20211129034317.2964790-5-stevensd@google.com>
 <Yc4G23rrSxS59br5@google.com> <CAD=HUj5Q6rW8UyxAXUa3o93T0LBqGQb7ScPj07kvuM3txHMMrQ@mail.gmail.com>
 <YdXrURHO/R82puD4@google.com> <YdXvUaBUvaRPsv6m@google.com>
 <CAD=HUj736L5oxkzeL2JoPV8g1S6Rugy_TquW=PRt73YmFzP6Jw@mail.gmail.com>
 <YdcpIQgMZJrqswKU@google.com> <CAD=HUj5v37wZ9NuNC4QBDvCGO2SyNG2KAiTc9Jxfg=R7neCuTw@mail.gmail.com>
 <Ydhq5aHW+JFo15UF@google.com>
In-Reply-To: <Ydhq5aHW+JFo15UF@google.com>
From:   David Stevens <stevensd@chromium.org>
Date:   Tue, 11 Jan 2022 08:47:47 +0900
Message-ID: <CAD=HUj62nanThBtAo2bnEh=xXp+AU0XmJeOCLb2cRkRW03pJbw@mail.gmail.com>
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

> The best thing to do is probably to wait for for kvm_vcpu_map() to be eliminated,
> as described in the changelogs for commits:
>
>   357a18ad230f ("KVM: Kill kvm_map_gfn() / kvm_unmap_gfn() and gfn_to_pfn_cache")
>   7e2175ebd695 ("KVM: x86: Fix recording of guest steal time / preempted status")
>
> Once that is done, everything in KVM will either access guest memory through the
> userspace hva, or via a mechanism that is tied into the mmu_notifier, at which
> point accessing non-refcounted struct pages is safe and just needs to worry about
> not corrupting _refcount.

That does sound like the best approach. I'll put this patch series on
hold until that work is done.

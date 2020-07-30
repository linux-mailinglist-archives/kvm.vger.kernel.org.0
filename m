Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A56233B7C
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 00:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730511AbgG3Wm2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 18:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730412AbgG3Wm2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 18:42:28 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9D7C06174A
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 15:42:27 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id z6so29971148iow.6
        for <kvm@vger.kernel.org>; Thu, 30 Jul 2020 15:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ivdl3YOfCMdluIFeWikDyj1ik6cuNw4EG6PO21GIuYU=;
        b=tW1Z+a4OlzVtJXWQ+szR1VfsjZG3Od+gHmlO718fMuSI9mwu5SkPkrUG2Shgha8Szg
         +WDVdzFhAxMKm7uI8bplil/AKC4XSXrC2Dgr2NtihW8MxEp/s59Ba1x7e1E5lSsxR3z0
         k42oaSO2YpLfmDMnTKasxTlCUGaZi7hFqdxx/nt825E3JsiV0cGsxpzsDfBBMfRjWOv0
         aQ0be9MhMhU+Z+aDeBQ6uSwK5X7r6vlbxBSiZSCNAxL3T+BdqMaI2btG/NpOKd6a+kED
         idjQG0E0KHD8nPlpPU0ic+yzbmpbIupSeIj/yaZrHmVb8eBPDBUMFsnbltEcO6oogTrW
         SceA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ivdl3YOfCMdluIFeWikDyj1ik6cuNw4EG6PO21GIuYU=;
        b=fE7AlN8wmq6n0Cl3UsaxC+44mZhac2e/VH8vRGLlF1SUxaSvNlQ1dmLySpHxtjEL2M
         sohaKw47sUcRveW1G4pzwmhWZRQsKXNHB73SbhDxAa84hBg07YCeTDYte4XKZestM1bw
         HKEcgQ6VyxlJk21l5W23JqTEUVpO2sa6snmfascfUEEgflnYteltGGsXo6E8M+KbeCse
         pQJovNAWBNxLHIVV1X6yf7EGlCWyw762sAi9cs3KwO0QEonKPTC8xXSAWG7BD3pylKZg
         N/y8F6H4gFvNxIsBsHz/mVDwyv2U1sa18nis5DCE6UGkDIT5fUSzetffpMn1vOQXg50O
         Ad0w==
X-Gm-Message-State: AOAM532geluPBwF/kqF9FqyK7mtZ04LB2MYa9zYnFG45FRNODShv5G+i
        bEhE2+zXMW/Wzngum4e884H6aImMk1CpF2F3TArl3g==
X-Google-Smtp-Source: ABdhPJwrC2hBaXzYNS1m0iZbF1QcdHhaFCxp4IlEDmHrqDOmJx0OjF+tSp+gdna2vwh2GdTd/U6cEdFdd4nUR2MzE+E=
X-Received: by 2002:a6b:b4d1:: with SMTP id d200mr844428iof.70.1596148946827;
 Thu, 30 Jul 2020 15:42:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200729235929.379-1-graf@amazon.com> <20200729235929.379-2-graf@amazon.com>
In-Reply-To: <20200729235929.379-2-graf@amazon.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 30 Jul 2020 15:42:15 -0700
Message-ID: <CALMp9eRq3QUG64BwSGLbehFr8k-OLSM3phcw7mhuZ9hVk_N2-A@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: Deflect unknown MSR accesses to user space
To:     Alexander Graf <graf@amazon.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        kvm list <kvm@vger.kernel.org>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 29, 2020 at 4:59 PM Alexander Graf <graf@amazon.com> wrote:
>
> MSRs are weird. Some of them are normal control registers, such as EFER.
> Some however are registers that really are model specific, not very
> interesting to virtualization workloads, and not performance critical.
> Others again are really just windows into package configuration.
>
> Out of these MSRs, only the first category is necessary to implement in
> kernel space. Rarely accessed MSRs, MSRs that should be fine tunes against
> certain CPU models and MSRs that contain information on the package level
> are much better suited for user space to process. However, over time we have
> accumulated a lot of MSRs that are not the first category, but still handled
> by in-kernel KVM code.
>
> This patch adds a generic interface to handle WRMSR and RDMSR from user
> space. With this, any future MSR that is part of the latter categories can
> be handled in user space.
>
> Furthermore, it allows us to replace the existing "ignore_msrs" logic with
> something that applies per-VM rather than on the full system. That way you
> can run productive VMs in parallel to experimental ones where you don't care
> about proper MSR handling.
>
> Signed-off-by: Alexander Graf <graf@amazon.com>

Can we just drop em_wrmsr and em_rdmsr? The in-kernel emulator is
already incomplete, and I don't think there is ever a good reason for
kvm to emulate RDMSR or WRMSR if the VM-exit was for some other reason
(and we shouldn't end up here if the VM-exit was for RDMSR or WRMSR).
Am I missing something?

You seem to be assuming that the instruction at CS:IP will still be
RDMSR (or WRMSR) after returning from userspace, and we will come
through kvm_{get,set}_msr_user_space again at the next KVM_RUN. That
isn't necessarily the case, for a variety of reasons. I think the
'completion' of the userspace instruction emulation should be done
with the complete_userspace_io [sic] mechanism instead.

I'd really like to see this mechanism apply only in the case of
invalid/unknown MSRs, and not for illegal reads/writes as well.

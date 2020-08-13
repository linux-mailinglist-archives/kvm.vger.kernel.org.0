Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF40243D9B
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 18:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgHMQlj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 12:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgHMQlj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Aug 2020 12:41:39 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C017BC061757
        for <kvm@vger.kernel.org>; Thu, 13 Aug 2020 09:41:38 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id f26so6895308ljc.8
        for <kvm@vger.kernel.org>; Thu, 13 Aug 2020 09:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JrCyBLUf2pVJTo2mrO5agYWCNNsHpIQg/y5QEzBhDAc=;
        b=u5dbHL199RL9b5RX3RnSkbWno03yG8Oorzcu2Xu6JRghwVIkfKPwxwy74n32oCvRVu
         88kYaxa9nJk4Nhz4GtNHGSHBkgHJFqxmVo/jXF9AEDnsWCzqEesSRl700ZohPUCZygKw
         9ffBPRp1vg2hwgjeMmDL30hHS4CE8TUBFGts0p8qe/CCynDjznY2TB7oG7Jxjds2MG8p
         1Tm/cyyDYfDNtpjU2UQt1vUTQQB1bmEXLX8GBb0WEFcahKSFKwRcSZz1dm/gbjole/Rm
         9Gp8aEh18DjBT/vMTrpE2cXiqHvykxNvLxJVJrAxRVTY8d0yqJP4adwGzK27JehgBslA
         OOkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JrCyBLUf2pVJTo2mrO5agYWCNNsHpIQg/y5QEzBhDAc=;
        b=ApQ57sCUTYCuUtkUoKH9oIjeJLc//QXQ2sKbscoQFbasIVhzIEDz44+87DB2gVhvLx
         kHqw+qqmozgEQt6klHdTD+gmxSHjCCQcDTElAhBaMLKF5ZP7/DrXR/TwCSFaWd354+LM
         Zn09rmPSikI4+BvbWmamBuN/ri5XAvTAw4r2Jn351OW+JOL+TckXYkUu8vO4CreaDb6z
         l6xOD/Fb6TiVz+ygmc14tevdSUyO8rBl0vHiG3cffpzW9vzsEBOO+RN9SChTIrTFJayx
         SZjkE1n8MWSTylBsF9ZZ2D37nn6k4ORW/lZfmMGBxmphu6J/YXU44vCIYERclDbmVqjV
         vyPA==
X-Gm-Message-State: AOAM530aKfuN+Ji/j8rKKgAKYsBHnAF3L405fvBO3d8E8udndpBrHb8B
        fqWoR0wCEzGYntiSOihjPIiO1tv5JS4JKmqGawwAlHb0
X-Google-Smtp-Source: ABdhPJxt2opJHjyu3PCQ9Ol1hmN+Rzz6NV1L9cUKh0Avgmo9omZVf0SdDHqDeq3rmpsh0OcC8g2+nsKdObrx1zpB2tg=
X-Received: by 2002:a2e:3001:: with SMTP id w1mr2379710ljw.147.1597336895522;
 Thu, 13 Aug 2020 09:41:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200806151433.2747952-1-oupton@google.com>
In-Reply-To: <20200806151433.2747952-1-oupton@google.com>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 13 Aug 2020 11:41:24 -0500
Message-ID: <CAOQ_Qshck2zudJsKBUFQnRrzW0uO+vrSuR+aXO__CGcP2nUXQA@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] Restrict PV features to only enabled guests
To:     kvm list <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 6, 2020 at 10:14 AM Oliver Upton <oupton@google.com> wrote:
>
> To date, KVM has allowed guests to use paravirtual interfaces regardless
> of the configured CPUID. While almost any guest will consult the
> KVM_CPUID_FEATURES leaf _before_ using PV features, it is still
> undesirable to have such interfaces silently present.
>
> This series aims to address the issue by adding explicit checks against
> the guest's CPUID when servicing any paravirtual feature. Since this
> effectively changes the guest/hypervisor ABI, a KVM_CAP is warranted to
> guard the new behavior.
>
> Patches 1-2 refactor some of the PV code in anticipation of the change.
> Patch 3 introduces the checks + KVM_CAP. Finally, patch 4 fixes some doc
> typos that were noticed when working on this series.
>
> v1 => v2:
>  - Strip Change-Id footers (checkpatch is your friend!)
>
> v2 => v3:
>  - Mark kvm_write_system_time() as static
>
> Parent commit: f3633c268354 ("Merge tag 'kvm-s390-next-5.9-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into kvm-next-5.6")
>
> Oliver Upton (4):
>   kvm: x86: encapsulate wrmsr(MSR_KVM_SYSTEM_TIME) emulation in helper
>     fn
>   kvm: x86: set wall_clock in kvm_write_wall_clock()
>   kvm: x86: only provide PV features if enabled in guest's CPUID
>   Documentation: kvm: fix some typos in cpuid.rst
>
>  Documentation/virt/kvm/api.rst   |  11 +++
>  Documentation/virt/kvm/cpuid.rst |  88 +++++++++++-----------
>  arch/x86/include/asm/kvm_host.h  |   6 ++
>  arch/x86/kvm/cpuid.h             |  16 ++++
>  arch/x86/kvm/x86.c               | 122 +++++++++++++++++++++++--------
>  include/uapi/linux/kvm.h         |   1 +
>  6 files changed, 171 insertions(+), 73 deletions(-)
>
> --
> 2.28.0.236.gb10cc79966-goog
>

Ping :)

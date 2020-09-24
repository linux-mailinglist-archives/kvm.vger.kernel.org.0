Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011E9277B00
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 23:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgIXVUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 17:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgIXVUp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 17:20:45 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D136C0613D3
        for <kvm@vger.kernel.org>; Thu, 24 Sep 2020 14:20:45 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id z1so236510ooj.3
        for <kvm@vger.kernel.org>; Thu, 24 Sep 2020 14:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BwiUYRS9W1C5pcKuYLLY/Mvk+3HUevzfSS92myNcc4U=;
        b=MLiKBzU7eG6u1Z/cGRcRTW/IvgE0Ugw6tA2RVdCNbCpRibsl54FbgQNGtPDO09KVWW
         laSauLqO5a3ly2kpMKGkHhrYAfe+eotJL4MKJBjaBMglmZ6kA4l1C6trSTQFEuonSTth
         YVEqqeDnCHiQ/+O+ovy1A1g2bmjqEPdMCm0qWjLv2eRT4BoXzRshtqzCH5k+C2B3jJeP
         SeaXFNV+IIsJth2SN44mbwvnL0Vvb1aMbHK2bmUMQXmtGMqUkFIY9SlWBxNdkTmPQwHz
         S30TODI2DIIR6puEOE0CaSAlxpAgrQ0/KG0iNmmkUiVMolMla08u0R0hWwMQH0EBZ8YZ
         an1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BwiUYRS9W1C5pcKuYLLY/Mvk+3HUevzfSS92myNcc4U=;
        b=MOVtEtJzNxziVbY6CPdG6KVUjpV+D/Ddmo1oxa+P5IExuAlt9gtZK3VIUPCeqd+V3a
         hNQb/J3BwHoUvkWtBvGJq1JBI1n/TS9doxZpxFyZcZIWEMTApTbiNi+5eAZu7R915TaY
         Sb12QVMVilJW8YUD2Uyjxr1l2vTr5tDkEJpwF8iJjEjUxTztTCMgzKjy1bA+lS03H4ti
         ZWHV2VUak0LqwxjzF3T/AwTovOx4AIuM0hcXPsi5awRf7520z8HffUdSlUCv0IZ3yYwH
         0ZtNS/W2GiJsSNWjN379sUQ57fWq8Yit6Da6blbUQnnxfZRmkUG/qXcIcrWrlk8MeMcU
         9MSA==
X-Gm-Message-State: AOAM533nwarPDJO1t1BfxgwS0gKnFltqgH90w5HVF/axLOYR75cj5Jof
        2c/U9WX7qRkMUhY/a+gcwpEuW1kWGEIhRLKb301gYw==
X-Google-Smtp-Source: ABdhPJxc6/CsfJJe80x2UiPvXGURYoMAvRyTh+3i8yuKipBwagzD0XQvTxmmLnmMmpryvrF9Y/dN+25KPc3vdZau89w=
X-Received: by 2002:a4a:9bde:: with SMTP id b30mr850198ook.82.1600982444597;
 Thu, 24 Sep 2020 14:20:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1600972918.git.thomas.lendacky@amd.com>
In-Reply-To: <cover.1600972918.git.thomas.lendacky@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 24 Sep 2020 14:20:33 -0700
Message-ID: <CALMp9eS2C398GUKm9FP6xdVLN=NYTO3y+EMKv0ptGJ_dzxkP+g@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] INVD intercept change to skip instruction
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 24, 2020 at 11:42 AM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> From: Tom Lendacky <thomas.lendacky@amd.com>
>
> This series updates the INVD intercept support for both SVM and VMX to
> skip the instruction rather than emulating it, since emulation of this
> instruction is just a NOP.

Isn't INVD a serializing instruction, whereas NOP isn't? IIRC, Intel
doesn't architect VM-entry or VM-exit as serializing, though they
probably are in practice. I'm not sure what AMD's stance on this is.

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F35F513193E
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 21:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgAFUUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 15:20:07 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:33868 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbgAFUUG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 15:20:06 -0500
Received: by mail-io1-f66.google.com with SMTP id z193so49946929iof.1
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2020 12:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TLp/ufTp0fYjzVGW4DuTeiICdn7BWt7SHYlnsorurds=;
        b=ZBuZ0lTtXh/HFFduyGbHQ9mz6qhkf8isglZMJ6rkGMDKlIz348zz+FJBrCXiecfNaM
         G9XU0aDZUJkspgvq3dFrptFOtCxw7/9q6e0oYnK4KIO+tN/R91Gho+qO1JCbvEKUAZ9B
         +DgRmsuBBUYTJ8icaKwHyadigaTDz5JFzR+Bo1+tsDQ0c0N2tI06q1X4Zz9aDcm0HIVR
         nTRaKaCZ91cXY6OTZ8kS7QNPWIxeMgLEwMscPMAiEggKYcabM9fBWnPCP9DCezGB+Fxa
         Mmws4V8umADBZPcQsWfcItQzOaa1cL8vCQopvUyD7PBZAt8gfpLwO1Y+ZF9DyQ43UM+Y
         Q+FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TLp/ufTp0fYjzVGW4DuTeiICdn7BWt7SHYlnsorurds=;
        b=PyJvtIShIPIvzkxwwUMAe+5Vz0fhiO2UM360fk+Im0r5AA1CKpi8KzPQO4/R7OEKzX
         tG7CH2SWeWtChJglWshtmZCdKR0ukpxvrzB6pUHb4eLjbwLtDCMJal9wjKQLdYtDPuV2
         J6df0fcXyKnPxQssbzyA91Xqee2knU//atnU+H4rfQZD1UJWW1POvDoPMXN5N4kIssXv
         mbZma5bfk7hPSWynISJ09X5O+3K7ifKhvFkRp3R0bRdWPwKmP6NNtPLj9AkuV+/6pGdq
         FEXQJP5u+sj6BrzpDfjr/XBBvoxPLaFMJGBJl29eE8CmRr8/ecfqQMcZnDrLdYZGN4Qa
         eVHg==
X-Gm-Message-State: APjAAAWOgtDT5bP9M1NCtAifcTYJsoHY4xgj/QoPgtAV8Ux/LoQFnuSD
        pTy98/u5G86WMibTtJh1N7OxI2lLGBr/P8bNYvsOZQ==
X-Google-Smtp-Source: APXvYqwumr0YiUR0oP6hMxgSGdJNExJQPdoLDRU2fDq+CxkJ0j2PVxuRSCVAbrGf9CGxXEwqGtmFfotDtPJwPjeEIiU=
X-Received: by 2002:a02:3312:: with SMTP id c18mr79437851jae.24.1578342005752;
 Mon, 06 Jan 2020 12:20:05 -0800 (PST)
MIME-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com> <20191211204753.242298-14-pomonis@google.com>
In-Reply-To: <20191211204753.242298-14-pomonis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Jan 2020 12:19:53 -0800
Message-ID: <CALMp9eSixcb+LMxNV6t-_FHzxPHDRV45R3FZ835xvpqk6hM1Gg@mail.gmail.com>
Subject: Re: [PATCH v2 13/13] KVM: x86: Protect pmu_intel.c from
 Spectre-v1/L1TF attacks
To:     Marios Pomonis <pomonis@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nick Finco <nifi@google.com>, Andrew Honig <ahonig@google.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 11, 2019 at 12:49 PM Marios Pomonis <pomonis@google.com> wrote:
>
> This fixes Spectre-v1/L1TF vulnerabilities in intel_find_fixed_event()
> and intel_rdpmc_ecx_to_pmc().
> kvm_rdpmc() (ancestor of intel_find_fixed_event()) and
> reprogram_fixed_counter() (ancestor of intel_rdpmc_ecx_to_pmc()) are
> exported symbols so KVM should treat them conservatively from a security
> perspective.
>
> Fixes: commit 25462f7f5295 ("KVM: x86/vPMU: Define kvm_pmu_ops to support vPMU function dispatch")
>
> Signed-off-by: Nick Finco <nifi@google.com>
> Signed-off-by: Marios Pomonis <pomonis@google.com>
> Reviewed-by: Andrew Honig <ahonig@google.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Jim Mattson <jmattson@google.com>

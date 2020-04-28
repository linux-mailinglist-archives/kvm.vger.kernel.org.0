Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2FED1BCD06
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 22:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgD1UHe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 16:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726440AbgD1UH3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 16:07:29 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521ADC03C1AB
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 13:07:29 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id f8so18001864lfe.12
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 13:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M1YtACLEe9IuTvLnjysZBZz/m54iNfZsObywrWlf7oE=;
        b=KjUGDWC9klYlMPXx4Q6IAmywWSeQcbXkwwzOYikFtW+g+kq2qFglZTMOdtK+hTolHm
         +95eYRT4IQPC9wQ25xEQ/SCOUpJdsiTcw+861799DwWHDH8vvPUt5+I8zdP/ZwSSeH/5
         0XK2fGAcqUzAOkqu5KGDML5Img3Muwp0A++uH/Ag53yiJmrlnrdZXJ6hy+swQVY/hK5b
         lX5Z2b32uNS/Kl8jNnNsH0ruVgDtGu05DBwQSZP/ZRdkBy79mMNYWR9dcS7CIocvNPLE
         70LzUAEHuv/zYF4Ta6uOT4gMGcsGp+FSRfsflhMFCSq0p3nPi0xpZkkNMdM23coeEnCB
         OXjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M1YtACLEe9IuTvLnjysZBZz/m54iNfZsObywrWlf7oE=;
        b=WBNtLoFXNpHPRe7cOMbwoMAoFGQXOyLs94xNN/apq3llyYTCH5ApznQTMCCkrOgsP/
         UvcyXnurgeDW/akJYqAF8tH8AJ+76z2EC6BUGe1NO1A+zRp5PQARtR+BUJ6yWX8WeQ3c
         dTY/tQvwYjC+2YJVzwxkiAysNLpxqzHXOOtWJnq7JyFYd57kUKYcsA868nq2Sn7r+VYV
         KaJ4i/VRem1uHoofJ2lprd/U7YxmNhlES1WcJ38X3NAEfyTEgHayHJj0V4ARWCl42POe
         vzx/x+DCedW44f849zK8uOaMnwPIioX+HpHEgl+Kdc4TM9HQLHcYU0y2wdZRG0GUg1hl
         1g7g==
X-Gm-Message-State: AGi0PuaFGWqZLK4kiB6/kLblhxG7A0Ba/jiriNM34v63rKxzUO4HfG5P
        5NB3qCAfYLoqJBF292aM+bn9cgHx4irehQ7OfFvHqg==
X-Google-Smtp-Source: APiQypI3iiSpP+vuFbfcMhuWh/HEF2kch9czpa3KxmqEEmwzMCc2dSPgMvj85MvOgPehFcfih9BZiBMwVu+AeS8e8lc=
X-Received: by 2002:ac2:4832:: with SMTP id 18mr20437133lft.162.1588104446347;
 Tue, 28 Apr 2020 13:07:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200423022550.15113-1-sean.j.christopherson@intel.com>
 <20200423022550.15113-2-sean.j.christopherson@intel.com> <CALMp9eRD9py=N9hDSon5GPzuiZw1Z+3xHv9umu1_qKzWczz0PA@mail.gmail.com>
In-Reply-To: <CALMp9eRD9py=N9hDSon5GPzuiZw1Z+3xHv9umu1_qKzWczz0PA@mail.gmail.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 28 Apr 2020 13:07:15 -0700
Message-ID: <CAOQ_Qsi62EL3WZWEnKVNT=9YFsZ3Gmsu3V-JeehGmxbvotiShg@mail.gmail.com>
Subject: Re: [PATCH 01/13] KVM: nVMX: Preserve exception priority irrespective
 of exiting behavior
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 11:54 AM Jim Mattson <jmattson@google.com> wrote:
>
> On Wed, Apr 22, 2020 at 7:26 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Short circuit vmx_check_nested_events() if an exception is pending and
> > needs to be injected into L2, priority between coincident events is not
> > dependent on exiting behavior.  This fixes a bug where a single-step #DB
> > that is not intercepted by L1 is incorrectly dropped due to servicing a
> > VMX Preemption Timer VM-Exit.
> >
> > Injected exceptions also need to be blocked if nested VM-Enter is
> > pending or an exception was already injected, otherwise injecting the
> > exception could overwrite an existing event injection from L1.
> > Technically, this scenario should be impossible, i.e. KVM shouldn't
> > inject its own exception during nested VM-Enter.  This will be addressed
> > in a future patch.
> >
> > Note, event priority between SMI, NMI and INTR is incorrect for L2, e.g.
> > SMI should take priority over VM-Exit on NMI/INTR, and NMI that is
> > injected into L2 should take priority over VM-Exit INTR.  This will also
> > be addressed in a future patch.
> >
> > Fixes: b6b8a1451fc4 ("KVM: nVMX: Rework interception of IRQs and NMIs")
> > Reported-by: Jim Mattson <jmattson@google.com>
> > Cc: Oliver Upton <oupton@google.com>
> > Cc: Peter Shier <pshier@google.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Oliver Upton <oupton@google.com>

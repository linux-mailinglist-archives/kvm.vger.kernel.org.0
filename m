Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3C8375983
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 19:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236286AbhEFRhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 13:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236224AbhEFRhg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 13:37:36 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EED8C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 10:36:38 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id r26-20020a056830121ab02902a5ff1c9b81so5563199otp.11
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 10:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lWhZpjAPuQwuNMsyguhTXOLkAXG55cG8QHtVVbMGsYw=;
        b=vTkJB0hxqPhHP3DR5scM38zn7U4uEB5gqa9C9zIDyxPYbtmx4dcOyh0dOGk3n8OuMt
         emnDp9wP68gDjzyhqG4w9QNDHCTg825H2G1t0wukVQP4XjOmZURljyQ88ovMkDuWWmHh
         +Q6bHIh44NMoDj0KHBd8q5cK7FEMieUqWExKRVzm6/joWcwmv3FI6ChKCTMkMEh49Kp/
         BxQo6Y4QH9r1l2JcZsL6kNj1nKqwFVuJ17vYJXMH+Zr7J0FRF4WxNW4qwnVhHPL4ZBEA
         gAKRMZhXjVYJ0A+43MnolRghHguq69DOSAD39GuveWyk8at5Bdw7C9ol0wd0ZaTbJzcZ
         U6kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lWhZpjAPuQwuNMsyguhTXOLkAXG55cG8QHtVVbMGsYw=;
        b=PTh6pTF4VOnQd4NGj6y4JYE6domEWDwXZSqBf9EFqbMeMJuUZR0sJXZSDXzIG+ADrK
         1ixkGC0+l9dfy4xuW0TY/1tdVJeoYtxmgm+RwBHhE4Yov9oqo1K5PqO6C3xsKifniOw6
         /sF0x6iemuq8TPUh2Rt3563apsff56n+Nk39JUOr32pghsoIgaw7llyFvEKpGkcQ1Qsa
         uLYP9aAoyB1goQSD3L0sHZre5g1QPfHWfEoTTbHw74xv3osCHj3+SxkVhqiTUbGkD1pA
         /Sr2gliAnFFXGO+LMLKSDqlp1eHnHNeZryFPebYWKIiBeH7/d1yaic4+Aq/7ifRpW5xs
         f3Bg==
X-Gm-Message-State: AOAM533fQuoNHw8lm4xDp8l42fdxccimo2xAhLsgONQYbVzDtxpJcOWL
        F895x4jjocTnvFN23+ER9VFT3qsDDrSXqe8g+frT7w==
X-Google-Smtp-Source: ABdhPJxn4UlOrJnyx3PZJLGqMsiZwJB8USKMD2ciLtlw2WwOfHBpA+RtUdwEZxt9h/vVbiE6W/B9w2kDjPids9+gih8=
X-Received: by 2002:a9d:684e:: with SMTP id c14mr4552853oto.295.1620322597176;
 Thu, 06 May 2021 10:36:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210506103228.67864-1-ilstam@mailbox.org> <20210506103228.67864-2-ilstam@mailbox.org>
In-Reply-To: <20210506103228.67864-2-ilstam@mailbox.org>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 6 May 2021 10:36:26 -0700
Message-ID: <CALMp9eQun7yDFz-BMeLoc4my15vi9OXKGnxAtzCZkDck_X+k_A@mail.gmail.com>
Subject: Re: [PATCH 1/8] KVM: VMX: Add a TSC multiplier field in VMCS12
To:     ilstam@mailbox.org
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, ilstam@amazon.com,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haozhong Zhang <haozhong.zhang@intel.com>, zamsden@gmail.com,
        mtosatti@redhat.com, Denis Plotnikov <dplotnikov@virtuozzo.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 6, 2021 at 3:34 AM <ilstam@mailbox.org> wrote:
>
> From: Ilias Stamatis <ilstam@amazon.com>
>
> This is required for supporting nested TSC scaling.
>
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

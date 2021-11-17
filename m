Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F20A453D18
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 01:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbhKQAYn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 19:24:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhKQAYn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 19:24:43 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8334CC061570
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 16:21:45 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id l22so2118332lfg.7
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 16:21:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZHLPtTju7FGYF9LvUTuvcAZL99FfkTcE5KcxoNAfROw=;
        b=i6NwVT28tHf7ymMv3mrsT39kcrbCg6agDnxbdCdPptIEYNKtGK3N42k9kvcW5n90PC
         pYxVxcWFJw4oU/fkaV8yHxO0PwDMTozzlweCcV+nraUNNqeRd0TL6sAE3GcXJmGjtyPp
         5BAsiG7crvYh47cWNDosqHrzG4vTHgPSt2NJsmHpWNXlG70j0UDSD2vB3hbGt0EVwvE1
         7iIKEFdHE/CDNUVdCwJBKfM7MlJeBr87JJ25TCqYyQfGTrKSUj4ZKozyrOErTOu30Meb
         HB8fL0qyI8sYRsOqnulZlBVv60Mr+hyvwS6cZ1ffXelCo0K5rNeUYClmWniqMglvQhJ+
         p6Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZHLPtTju7FGYF9LvUTuvcAZL99FfkTcE5KcxoNAfROw=;
        b=GPjzGmAs/Hkn1KW6Ag0qLsR9yGPLqfMkIBkNA440xi03cl9P3bYYeA1CLKiH1zZQD2
         cMVx97BskSlHkuH3t7FURiAC9rXW3qNEXmITF7wd1rs7rJ9qHYrKvVdmWmwpGsrjbOPA
         K619ADLhc5wxMqjuZ6rv1aj0RtS2YrYptBflqxr5pgJ24QHEiX0yPYwmlfmkNHWPIXn5
         xv/7NrsvRdrKYHRWoYX1dkHPdMZfDw6m+6yLS2drmcpvYJzd+nBpg1/lik1vzWGLnue2
         6q9a+cha5FgTqHNAP3fBIR+bf6Nrwy1Lwu+jYyovBQsHNdsAvDA3iDXPmtqSmtdeM5m9
         g2cg==
X-Gm-Message-State: AOAM530D1FXl3PlrgYWB5Nr7oWW2Qgfy4ucQ9VXzSXTOmlh9xRD2xqMH
        ZESwQltcrx5dOUDwwbE4dcIoUsuX+d/VnniqVK33zw==
X-Google-Smtp-Source: ABdhPJxdhtLGRBw7I060L9tymC5bpcO5vQkTmssBA9KEbkDx3vG0L0v4iC/JbL8JNVMjwJ+0gwxHjwn2DGewH5vbdHo=
X-Received: by 2002:ac2:4c15:: with SMTP id t21mr11175725lfq.518.1637108503703;
 Tue, 16 Nov 2021 16:21:43 -0800 (PST)
MIME-Version: 1.0
References: <20211111001257.1446428-1-dmatlack@google.com> <eb6fff8c-9548-6f51-bf80-88d4f164f4d6@redhat.com>
In-Reply-To: <eb6fff8c-9548-6f51-bf80-88d4f164f4d6@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 16 Nov 2021 16:21:17 -0800
Message-ID: <CALzav=e2B+6jiriiXfoQ69sadpYUoOrtJq5GMfTkpK9F_3u2hg@mail.gmail.com>
Subject: Re: [PATCH 0/4] KVM: selftests: Avoid mmap_sem contention during
 memory population
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16, 2021 at 3:13 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Queued, thanks.

I was planning to send a v2 to resolve the feedback on [PATCH 3/4]
from Sean and Ben. How should I proceed? The code should be functional
as is so I can send a follow-on or you can make the changes Sean
suggested (it's pretty straight forward).

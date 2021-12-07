Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BE046B1FE
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 05:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236316AbhLGEwo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 23:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236298AbhLGEwn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 23:52:43 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E3C9C061359
        for <kvm@vger.kernel.org>; Mon,  6 Dec 2021 20:49:14 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id n17-20020a9d64d1000000b00579cf677301so16525010otl.8
        for <kvm@vger.kernel.org>; Mon, 06 Dec 2021 20:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UTfE57hDt0Q1t21GfBm6n8K6yEgT14DAseiofTENeLw=;
        b=j/J9aSDToSml0nWZkGymGAw76ilWvQG3kd+IRYnv7bpqMrtq6H4EJJ6z2RiZGfm7ZB
         7IuYdd/4m6b5bYEpydg0OeMsYzYWyMRgyGb3MFeq9bSIj6Vg+sECRQkwueLsDRKRU3Kw
         4qomi7hTS8jaS1r8enAvLg9EEpzRFvPJuYIFUTfi877BLspYfMWq7U0R2Z0IFU4WCv8F
         uQmJ9Z8BHPBmzr//mD2UmMzGVIx+gSqX56TVmuME9awWtxK/VArm1mfgu7TPmw4z+oT2
         dsVIBRaQSl30NYbDnbIBy1h5caSxTwBXUCL2Yp1Ux34OW9kizi2Z8t4FQT6HNO4EIF8N
         H/rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UTfE57hDt0Q1t21GfBm6n8K6yEgT14DAseiofTENeLw=;
        b=Of7ZfdpQDYWpj8P9w7xEPGJz4HuUVGbdqHZxiHh/pEROpdjX23oLre6XxIfc0UWOy6
         0DyxdHJe2ido5NEXPms5OJ0PJ3lM4mkBuVTFcGp8PafFy/DhniWeUwe/fYB384D89DUf
         f9k7zssFGgn4TCSgnMY5rDSnRWSKfCXSlxulPyY3JcBQkAVtal+NFRrKRzOBsmvF/Nvm
         7M395Psgab/lGei1rum8vsrYLi4di6VYYHRlc05hGB73eav/xIimKkdXvaJf6hmKTSgE
         Nmam9Sq43CMTyp7CW59jCW1oxsDz5eHbWJOeZhMiytm80Gn3j2iO4pGGI/n8jn7s3z7q
         1iuA==
X-Gm-Message-State: AOAM532qNJVv4EGOkBtXNbDup00aHparBWuUKyVYg/MrKQNviCEIcPxM
        Lu5ch1fP7Q1r8KY1Eh5u/BNWaU+H531PzNPuwHxygQ==
X-Google-Smtp-Source: ABdhPJwEir1iDUP4omv+M30OPgzbw9/Of8I3CUUiyBZfZpFXmSQAQJYE84LCC9cuBLCI/LTjRsVtzO4yOJwoZrazxwY=
X-Received: by 2002:a05:6830:601:: with SMTP id w1mr32608951oti.267.1638852553110;
 Mon, 06 Dec 2021 20:49:13 -0800 (PST)
MIME-Version: 1.0
References: <20211207043100.3357474-1-marcorr@google.com>
In-Reply-To: <20211207043100.3357474-1-marcorr@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Dec 2021 20:49:02 -0800
Message-ID: <CALMp9eR6tORQsSm6fGYumY9QrQVHTo3BxempwYRyOEYrv+zHew@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Always set kvm_run->if_flag
To:     Marc Orr <marcorr@google.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, thomas.lendacky@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 6, 2021 at 8:31 PM Marc Orr <marcorr@google.com> wrote:
>
> The kvm_run struct's if_flag is apart of the userspace/kernel API. The

Typo: 'a part'.

> SEV-ES patches failed to set this flag because it's no longer needed by
> QEMU (according to the comment in the source code). However, other
> hypervisors may make use of this flag. Therefore, set the flag for
> guests with encrypted regiesters (i.e., with guest_state_protected set).

Typo: 'registers'.

> Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
> Signed-off-by: Marc Orr <marcorr@google.com>
> ---

> -       /*
> -        * if_flag is obsolete and useless, so do not bother
> -        * setting it for SEV-ES guests.  Userspace can just
> -        * use kvm_run->ready_for_interrupt_injection.
> -        */
> -       kvm_run->if_flag = !vcpu->arch.guest_state_protected
> -               && (kvm_get_rflags(vcpu) & X86_EFLAGS_IF) != 0;
> -
> +       kvm_run->if_flag = static_call(kvm_x86_get_if_flag)(vcpu);

I'm sorry that I missed that change when it first went by. Maintaining
backwards compatibility with existing userspace code is a fundamental
tenet of Linux kernel development.

Acked-by: Jim Mattson <jmattson@google.com>

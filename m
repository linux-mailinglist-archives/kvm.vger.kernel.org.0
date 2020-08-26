Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F43253925
	for <lists+kvm@lfdr.de>; Wed, 26 Aug 2020 22:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgHZUhv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Aug 2020 16:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbgHZUht (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Aug 2020 16:37:49 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE48BC061756
        for <kvm@vger.kernel.org>; Wed, 26 Aug 2020 13:37:48 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id t7so2650071otp.0
        for <kvm@vger.kernel.org>; Wed, 26 Aug 2020 13:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5ybWHrSMyDBrSdF5ECn3A4pj2aU4lAfHVUX9+2rwitU=;
        b=rPD/a9E6McwFRtU8JnYRGPiEXxyoUkU5X7thpuUru3IhxHyl/gXb4XWycdFgHi8mZ/
         IycTdhhBNnYcC4JIpn2FBab2HPWOrZA4HHvUGIh/KBvjrf3fLXkzmbnc+sALXrvr17VW
         NVM8x+ehJTH892ezv583w5OrPMzphz8XhW41oZPuDe2QC1Wt/xhudRxEU/uFs0MLOpPy
         1fPz57yTaS1qCFbuHRmK9l1ErYwscS7dgrn16LbM9NMs6SfeDc+yBidJ+W+YCPI0/8wf
         pyKAL34TDorvF+3Idaad3a7HxQa3l76+I4XwYwfK6QttsBV+I28sBO6xt40In1KXdboc
         927Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5ybWHrSMyDBrSdF5ECn3A4pj2aU4lAfHVUX9+2rwitU=;
        b=WcXBJrEEIxvEkiSEXrsb58IC5ebubdXVCuJyVYP0hpISf1wo1PvoqNvjkznVotG9Mk
         Xx6ArrK9gbcCXrX7GATJ6XRCtfKnE5FCf8GZQTrBcBe08aTord7KRnC0kX935cNQAmD6
         xu6o1oUoi4oFVJ0765uHt8yUDcc1zDnUr/z5g1AQsCdzJi8nn1+KjOzLmkdpOvz7RcZA
         jc9AC5zmtFmuE0o1930dQge1YrUMsN6giglsFcFfbrWBFS4Fjwwu5/5Iv9gnmjoElZv4
         sJ9pmlhZOwRhOD9Q0O8AKRuSnLGZgFw7TXdCdM288/ex9ONUIlvCtq4sXoRLQ6KjZz9P
         36tg==
X-Gm-Message-State: AOAM533tSxi2S+116H3xCm/aM7Etyh4Axlrby7qeOoqpHSfwE1eTfbm3
        qrUzUJ/B2bdRK/27CSWc67chG5WLMNBeJJte6Txn6w==
X-Google-Smtp-Source: ABdhPJxRAGKt3qz4Jm62WwzP/4jDfgRPDaUUEg4FpEBTM3Ti7SEKs6bIqi+bxY7lQte+tHM/uD8AwcCSWWcNfkoh1GA=
X-Received: by 2002:a9d:51c7:: with SMTP id d7mr8696668oth.56.1598474267398;
 Wed, 26 Aug 2020 13:37:47 -0700 (PDT)
MIME-Version: 1.0
References: <159846887637.18873.14677728679411578606.stgit@bmoger-ubuntu> <159846923148.18873.3524447445230117185.stgit@bmoger-ubuntu>
In-Reply-To: <159846923148.18873.3524447445230117185.stgit@bmoger-ubuntu>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 26 Aug 2020 13:37:36 -0700
Message-ID: <CALMp9eTGo91f=ZZ_tPp2C9GC8BN5g72YwWLX1+5p-MDL3nj4=Q@mail.gmail.com>
Subject: Re: [PATCH v5 01/12] KVM: SVM: Introduce vmcb_(set_intercept/clr_intercept/_is_intercept)
To:     Babu Moger <babu.moger@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 26, 2020 at 12:13 PM Babu Moger <babu.moger@amd.com> wrote:
>
> This is in preparation for the future intercept vector additions.
>
> Add new functions vmcb_set_intercept, vmcb_clr_intercept and vmcb_is_intercept
> using kernel APIs __set_bit, __clear_bit and test_bit espectively.
Nit: "respectively"
>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

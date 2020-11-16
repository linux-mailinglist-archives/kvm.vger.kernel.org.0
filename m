Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2654F2B5437
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 23:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbgKPWUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 17:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbgKPWUq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 17:20:46 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881E6C0613CF
        for <kvm@vger.kernel.org>; Mon, 16 Nov 2020 14:20:46 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id w188so20504844oib.1
        for <kvm@vger.kernel.org>; Mon, 16 Nov 2020 14:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DUgq39nfUV6cfcgfxfVRyyih0cIl6dnKtUhLRhxAR+8=;
        b=U/k3Myy9d4B9JeG1yp4ijBWOlH6ytTjS1YEOx4zdkJtETmgqKqNIPx6ZqFcFFJ9jRd
         c2L2mWUlTCFFepINyZ3ucBt3IZfTzyglFc3WgRNKApnVhzFLZKtRfctObxioosHL8q2u
         ImWhWOXgEwyzpS4tUSftvGsokGC+f8veDL7AER9uzzvJ5g8Q79eLC3PaSw9Lwf4jofmM
         TehjzoFP4TkqZE/fhHjOt+jXUTRHr61oSn5PZjvBsqo4DkHp/uDr8nHBk007+jCz72MO
         nArnZRh6/SG8S2cyBcrHH4pkmB0wW17tQB2Wmer/vmbL6tV0VXBb/mQJEqcM0txm1ipb
         FoWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DUgq39nfUV6cfcgfxfVRyyih0cIl6dnKtUhLRhxAR+8=;
        b=IBlIzol6ssxmKKfkQ6vpYn2swWmbr3GMSFnVhX0r2IVOElg+8KAmp7jgm9CP6pxYvk
         yRpIfk7ktEYM+jH0lYp3aDgiDScIrpqT6wQJM7Ct5cjAMOIm0jmMykHrIPYiW6ZLBALH
         AmWk3+L74+WqnfvoTfLHVlk0CV4f6xlgpuz+F1o5I5zdmbWbf4bUMW3ump7qlPfayL+X
         PF+tW2Cnx3YjsRuSW5nbMYpNBMw4rYgamX88sIgtqBUe4SJCaZKWGGK2ftZLi3yNYM7E
         tJzbApvd6HvaBgrZ4zslbCPYDyxNdt+RZwRHB493smchMGN+SCoAjXat4q1jyCPD4xql
         McRw==
X-Gm-Message-State: AOAM530V0N5xsBXiIASjR+t/h7Tsoh3foRiC9HM4eoKP3E0tiT2KuNbu
        AsHiyxqnZoI5sWrSetH4+k793PixD7XEiZB5FqOc4q0IY0k=
X-Google-Smtp-Source: ABdhPJyUjM+zLt2B3OGBnxsT7ATpDYYTApVyf7TUQUwSWiRBMbbX4VyNvQFc3N2VqTVdbNJhynBKyBHhukmOezD6aQ0=
X-Received: by 2002:aca:4fc7:: with SMTP id d190mr579597oib.13.1605565245760;
 Mon, 16 Nov 2020 14:20:45 -0800 (PST)
MIME-Version: 1.0
References: <20201116181126.2008838-1-pbonzini@redhat.com>
In-Reply-To: <20201116181126.2008838-1-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 16 Nov 2020 14:20:34 -0800
Message-ID: <CALMp9eTT64a7A+A+KLz04q9T0_GQ7EaytUZ6f+fkRRdfaQTnzQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: check CR4 changes against vcpu->arch
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 16, 2020 at 10:11 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Similarly to what vmx/vmx.c does, use vcpu->arch.cr4 to check if CR4
> bits PGE, PKE and OSXSAVE have changed.  When switching between VMCB01
> and VMCB02, CPUID has to be adjusted every time if CR4.PKE or CR4.OSXSAVE
> change; without this patch, instead, CR4 would be checked against the
> previous value for L2 on vmentry, and against the previous value for
> L1 on vmexit, and CPUID would not be updated.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

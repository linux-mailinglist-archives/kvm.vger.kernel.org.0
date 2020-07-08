Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97540218F95
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 20:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgGHSTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 14:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbgGHSTs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 14:19:48 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51565C061A0B
        for <kvm@vger.kernel.org>; Wed,  8 Jul 2020 11:19:47 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id i18so39916096ilk.10
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 11:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2AmuLZJMHQPQccZytV7kXET82/Y66cEHC380oWy4s+g=;
        b=HvTkT3Yzc+0sTy17VDvyFLHX9Wj+cV76L6dXw4jSkrFRuyw3gSp896FKevhO1L3c9R
         fHd36gJSizxoIEumauz8Wy3XzIsdXqsUbcdJZI5WkFVKo/cXMjDyF8/jSVuSsRB3nKbH
         6APHT/fZlZXTW2VneKfsRJ2kROoeMk2gGZPWyQCYP8sRmcl5SabIsQv7dVyxposgyuf0
         Obbkl92Nv+E1gH5NztzVcHLOxShYy+UxUJegvH0CLI0kNI8SW5RNSZzT9S+UXixj0Bep
         d6S6Ue4thjNfSVM7mM1NadWauaUT4GLq5mZv3q2c64MfGzdxqgXVG3UJAlm1CGVnqBIx
         2nDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2AmuLZJMHQPQccZytV7kXET82/Y66cEHC380oWy4s+g=;
        b=ZjlAAHF1wkKHqo+JzEHH+YEfUZ0l0RNlS7w5pBPqqqxlWWqoOXc4NL+otP3F10rcL3
         vYtKTpz/gZR3Zq1/+rsYJ9+BWmjwcq9cFamQfjsO0D0Rb/F/7pcgVqkD4YNGajbJtbmb
         B+GVmuYLoHCLIqXDoZNcjwDyQqmNTMJ3ssCiL2+duc+7ESqqwmYNCwSWP88k4PSOuZyo
         J80Dp9iA41s+ckRRqTxD43KMEE8pI7afKHLlw5aCWPW789yY96Obwp9yroC4tutJpkxT
         nnfXQU6FIXALHwRloQ04BGD4fu62C28N8taPOO/GambabnhhCGQlFvfarOSeSjFmcvgX
         19jQ==
X-Gm-Message-State: AOAM531sGqF64OYTIb5v2x61x6HCSjyYuxXuMPMcquFqxXM7z7HboJT7
        CqLqNHnqiNROHkuaLw6i1zLs+Bcz/F/woZV4zq9wdQ==
X-Google-Smtp-Source: ABdhPJyfCtMLGGsfTHzFRlVI1nhUOBxQmw2RuTyIuZQncCXntViBnqgrCAyRcBfK6wBySUQVUCLe5suQwBXZAhsHuJM=
X-Received: by 2002:a92:b685:: with SMTP id m5mr43222431ill.118.1594232386468;
 Wed, 08 Jul 2020 11:19:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200708110350.848997-1-pbonzini@redhat.com>
In-Reply-To: <20200708110350.848997-1-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 8 Jul 2020 11:19:35 -0700
Message-ID: <CALMp9eQGgDJE9kYA6vGM67iCdtfgYqPHxBXGSCGfEtqo858pmw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Make CR4.VMXE reserved for the guest
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 8, 2020 at 4:04 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> CR4.VMXE is reserved unless the VMX CPUID bit is set.  On Intel,
> it is also tested by vmx_set_cr4, but AMD relies on kvm_valid_cr4,
> so fix it.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

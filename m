Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 930C313193B
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 21:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgAFUTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 15:19:42 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:41132 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgAFUTm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 15:19:42 -0500
Received: by mail-io1-f68.google.com with SMTP id c16so46392268ioo.8
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2020 12:19:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8cEtudWCtdf6T3TMjKJwqF9jbkVULslZxeRKZ27Kc2s=;
        b=QtjcFB+DYa5pkgsRjodVAvu18u5iUIdjoDtsQfyPg0cR2KUvdk6NSqhCFic8jOgE8i
         +/atQtyFL2WCfmgZuTf8l1sdjJz4ad1dbppZzgdWM4JzY4jOr+oTqIY8jGd5pQBIL1Mx
         sAOhoZ4wnKAwncJdDWNTuHaq8q3S+jprxcKyvHnZSUFHERkZ2HW4lwVgfu5drNiPtk0m
         s9yGNQr32VnTU0zc3tX/3RIm2xxKtSX0p1u5O6RPGKYGaIk5GU6C9Vo4I+eBGp+42Cw1
         WYp4V5JGMW6YIAuyr9NTOmmOlJIVupTC5pDpOg/KpLc3wHzd/tAiJixszOZcFhEXI0jf
         MClA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8cEtudWCtdf6T3TMjKJwqF9jbkVULslZxeRKZ27Kc2s=;
        b=V2p0DNvu8tmydyojYSgF18GUNvluKC6iyI/QSQuXegE9U+ntJCWIbi44pmDrMJGaAE
         oZGVEjClqV7chtXo0ekgGSCoglGjO+xNjSTTsvQ4uJxcHcNQ4maWkqLqobYtjSxQuD61
         2LHG92q6AZl3LBh6j881sIz03AFLVRfzB9s1ogLkDExo0Aer7KwmdZyLmJIHkgmc10VL
         7NqU4Wrk1lvQBIVx6n8TG2+OYSc3uazj761Tqh+bz0WZNIxMMFrqzCE4B05p4IWZUxS+
         h1f5zOG0PVtzcoXgf/PuYxlTVACzLZLcbSFw95803Z3L+cTTYvPfmD0O0636huYhBWvj
         YEUQ==
X-Gm-Message-State: APjAAAUfQ91NO1Le/e4sqPszWDmWVkeBcUni8PrMvFgmEY6tuEQErBW2
        6EmF773gwGv+VqNzaijSpkjH/CCrfSUBCsbFQ7UhLw==
X-Google-Smtp-Source: APXvYqwB0MqyFY0NlYniQH2GAgfw3+4V5Y4bkxqU/VtEtdJT4o0YGAbxlFo4+429pMjJn1SvNXIHBzLCnfX1NSJTpLs=
X-Received: by 2002:a5d:9904:: with SMTP id x4mr68099509iol.119.1578341981709;
 Mon, 06 Jan 2020 12:19:41 -0800 (PST)
MIME-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com> <20191211204753.242298-13-pomonis@google.com>
In-Reply-To: <20191211204753.242298-13-pomonis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Jan 2020 12:19:30 -0800
Message-ID: <CALMp9eS+8kwmTyYDieNkhbRMBW-rkphKh4fmtV3X2d9XVh3U8Q@mail.gmail.com>
Subject: Re: [PATCH v2 12/13] KVM: x86: Protect DR-based index computations
 from Spectre-v1/L1TF attacks
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
> This fixes a Spectre-v1/L1TF vulnerability in __kvm_set_dr() and
> kvm_get_dr().
> Both kvm_get_dr() and kvm_set_dr() (a wrapper of __kvm_set_dr()) are
> exported symbols so KVM should tream them conservatively from a security
> perspective.
>
> Fixes: commit 020df0794f57 ("KVM: move DR register access handling into generic code")
>
> Signed-off-by: Nick Finco <nifi@google.com>
> Signed-off-by: Marios Pomonis <pomonis@google.com>
> Reviewed-by: Andrew Honig <ahonig@google.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Jim Mattson <jmattson@google.com>

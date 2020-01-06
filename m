Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32E2E131938
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 21:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgAFUTY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 15:19:24 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:40137 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgAFUTY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 15:19:24 -0500
Received: by mail-io1-f66.google.com with SMTP id x1so49945551iop.7
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2020 12:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZB6+nZpdQdrQFOUezOO+7mxpT7FzTcRrUIFGcgCSmbk=;
        b=i1+dxrn9BwWzBAeJV6afkXOmypBNmAdOB+MN0+uPEwO4tqMBko7kiVkXUabAiq/ryY
         scWsv83FexYHtha29B/rSOy2G6vr01E7gtVoQV9iKwaqofCJYPXWTm0elmL6mtpLgTho
         lRpgbEn8HhvfNgnScOhVlIVNFFnXdJsfyixF2JNW4I9eRGti+9UHcwY0+2nLtiZFBhZq
         NCRVgS4qd+LFAYtEBLVQRHVqJFQP6kgf5nU4jQ5icMM0keUykv268+d69Qtb+UgpH4ur
         fY/YrpuXoruqx1aEjWp30pWNrcxTpzDDu6MMwnEm860W41k4TzD4Wc+e46dLoHWdcj9x
         vn5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZB6+nZpdQdrQFOUezOO+7mxpT7FzTcRrUIFGcgCSmbk=;
        b=tE9XdAI7wljR0C3SOBJ8Edz9YBDeOCZz/DiOMeGvSohJV/a+ITZvcUrcm8n9NGbAGT
         mgaYcPHB2/WuAoXrTLwwqxKIv6zNSimkvn51TMZfLkhgw1g6kTOtBaFz0lJUWA/ETebl
         CB+SGT9+0rqH9Ekup8Njg3Wft26TZIV+lLjsyVdGzsSLXpoAySpgFoKC663eGCBK42sC
         MO0NQVjBoPYejI73xVlK/7nTUvJKKJCxNbwxQZrIrpUOLfPQHR5bBvweM43V96Beikio
         N80W1SnKhhA4hNYKjZVQ/SV6+E6parssN2xh6n9LWdrKuk21UkZeNSB6x4dc19mTagVd
         Nfeg==
X-Gm-Message-State: APjAAAVNMv92Cu5A5Fshw1A5nfo05qzHAu9aMuVA3k9UnCU23xynV2Gd
        /57oVPHImwBME9Bo/z1+cEbieuNEPnco9J/uKL5DRA==
X-Google-Smtp-Source: APXvYqz1ADI5pUttsTRFE4tG04m0tcxRUNOV6z/qiW+UMBRbGaQW2wU9EW1eJF1Qghs9D9XaNiAgZu7XxW6hZ4ZQb9Y=
X-Received: by 2002:a02:cd3b:: with SMTP id h27mr80920656jaq.18.1578341963368;
 Mon, 06 Jan 2020 12:19:23 -0800 (PST)
MIME-Version: 1.0
References: <20191211204753.242298-1-pomonis@google.com> <20191211204753.242298-11-pomonis@google.com>
In-Reply-To: <20191211204753.242298-11-pomonis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 6 Jan 2020 12:19:12 -0800
Message-ID: <CALMp9eT5HVhtCKOKaBxkaVUVs+uQ908Z2coM3n6j9aMU33=HGw@mail.gmail.com>
Subject: Re: [PATCH v2 10/13] KVM: x86: Protect memory accesses from
 Spectre-v1/L1TF attacks in x86.c
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
> This fixes Spectre-v1/L1TF vulnerabilities in
> vmx_read_guest_seg_selector(), vmx_read_guest_seg_base(),
> vmx_read_guest_seg_limit() and vmx_read_guest_seg_ar().
> These functions contain index computations based on the
> (attacker-influenced) segment value.
>
> Fixes: commit 2fb92db1ec08 ("KVM: VMX: Cache vmcs segment fields")
>
> Signed-off-by: Nick Finco <nifi@google.com>
> Signed-off-by: Marios Pomonis <pomonis@google.com>
> Reviewed-by: Andrew Honig <ahonig@google.com>
> Cc: stable@vger.kernel.org

Reviewed-by: Jim Mattson <jmattson@google.com>

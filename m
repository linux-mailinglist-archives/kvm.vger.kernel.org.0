Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F4423166D
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 01:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730252AbgG1XuT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 19:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729918AbgG1XuS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 19:50:18 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E4CC0619D2
        for <kvm@vger.kernel.org>; Tue, 28 Jul 2020 16:50:18 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id k23so22621850iom.10
        for <kvm@vger.kernel.org>; Tue, 28 Jul 2020 16:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jRxdAdAcHQnSvpTiqQgDtVDOtHSnq2LhAba7kclXwmw=;
        b=CLdorriLRZlh+3BoQMXxMwaWcWPavdGBwY5QQyfKxAA8388SW7TpF+RcKYp3UH8z8j
         TFA9xrNz6x9GOIfm3+uDe9vLt/3yxdKN3o4f1XkLdRbzEhiT8fY4MivoXSPjS+mKj+XX
         T2YaqUyn3rKQK4mlv4WSeVv/8yza4afEF6UVC7pecWB2puz14dxFfwZ2bUMVihlG568D
         xbKVLrWawCnrsJYAc3FmTbnDCXw3B70TpEC5zyhb+wwhg7U1Fvzwg4r/sJDyeQ7eUhLX
         zx3KtBrYWKgqPYYuf8ZegpOQ6TQIhvIS3pZ1cUUMHL0RCXO1aMP3bFbSnowYHsBuGFoD
         uZqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jRxdAdAcHQnSvpTiqQgDtVDOtHSnq2LhAba7kclXwmw=;
        b=B6vHONkuymCpyCDQnOUlEWN/vVYnZHss5o28kYoOABYH51qUjIf5lhhTleNZqH7LUa
         W/thiie1o5Uyur8+89bJVDKjE+T+KKLRIvattpqmYL9RFLmhucmfMbYGsd16knIq38ZC
         aKHg/6YC41m/0C6nks8NWOAkfZeX7vhQ9teV21AMp8v0BWBNoCraKR5k6NkgzARa59aN
         HejGvmqL77ggq0B4PC+uMfgl1FT8FlR/CGmSqWvlBEh/79vzqJvBFGubY4tk4BxH+e5v
         UsPkHZNfye1nfovNo/7BIByMGFDFfvtA+Bg8XZXAejABTd4mZrsOgSQgcntYraxj+qpK
         THVg==
X-Gm-Message-State: AOAM532+j7CbOiJuYnk727JnvPHBlazIZMOMt+Hp07LYjVgEqzTHqVf7
        GfdPbho810EO+lZcHKQS8Ayl4GUQrGx9XrweS8YsfA==
X-Google-Smtp-Source: ABdhPJytUIlbwggkeNor/HyEXSDWZhleuTFIsDfEol1n9HinAhHXVVF5rBK6e8v65tTRGFaJzdhp3zBOh9A+2sb847c=
X-Received: by 2002:a6b:c3cf:: with SMTP id t198mr30778184iof.164.1595980217386;
 Tue, 28 Jul 2020 16:50:17 -0700 (PDT)
MIME-Version: 1.0
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu> <159597947370.12744.8741858978174141331.stgit@bmoger-ubuntu>
In-Reply-To: <159597947370.12744.8741858978174141331.stgit@bmoger-ubuntu>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Jul 2020 16:50:06 -0700
Message-ID: <CALMp9eTqJHS2fwyRyUS8gRD+HzyEzP0yovok6rfbjb8mfZTejw@mail.gmail.com>
Subject: Re: [PATCH v3 01/11] KVM: SVM: Introduce __set_intercept,
 __clr_intercept and __is_intercept
To:     Babu Moger <babu.moger@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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

On Tue, Jul 28, 2020 at 4:37 PM Babu Moger <babu.moger@amd.com> wrote:
>
> This is in preparation for the future intercept vector additions.
>
> Add new functions __set_intercept, __clr_intercept and __is_intercept
> using kernel APIs __set_bit, __clear_bit and test_bit espectively.
>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
Sean will probably complain about introducing unused functions, but...

Reviewed-by: Jim Mattson <jmattson@google.com>

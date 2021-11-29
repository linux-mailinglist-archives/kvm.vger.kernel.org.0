Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C37460CD5
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 03:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243055AbhK2C4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Nov 2021 21:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240869AbhK2CyA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Nov 2021 21:54:00 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA82C06175D;
        Sun, 28 Nov 2021 18:49:36 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id i6so15798411ila.0;
        Sun, 28 Nov 2021 18:49:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DQheVeQwls1vmnHq2eNXrVLUaLkFaOJlio+fVKDeZQU=;
        b=dHm6ZVR+x9yQdn+x1jMrus/r4QnVZqYJqapSOByFxLWFz9prdV9vCqVhVRuOoDA3Ef
         qTu9qg5qjI6HcP7q/80y5aHbn75ci4goW9XmOhDnENBmgoZdj1G29cFXzkPdPjIAMoNU
         FbY1s59BJ36wmQgjH0JZrc7iPP1kLLd/LVXYg6QoKyw6wMCBObZ9K+uys9yJNLGi+My/
         hK/cvgElV/qUxdOnLIMR59XWZ6CI4vRNx2K21wA1bE+3yjU0Ei3LZ7C+rJF9RRcUk3Io
         V0egCwH2FWvWjV3B82YvFGALHeADFQBEijKhKJqUH3iH+tbDWY6H6h2AQI17kL+cyN7y
         m+fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DQheVeQwls1vmnHq2eNXrVLUaLkFaOJlio+fVKDeZQU=;
        b=Cl4+t+K50JlS6ZhLaTUzBI3XaQwtPQ8FF/s62Aq46ZWNDbxTqovTjb6qssFMsCPUtL
         U9QiWXJl1aYNxj5xh2gsVjkpwBZegyWETUqHeq+LI6yKwQ8lASRuRyP/38vGxovm1d9e
         rl8SsX8VPdoVCvd2P78xNAXS3cql2sRD1k68u/flGvXCKsYvatAjstVUeAlovaRP2hkM
         AOdlTvJNNkiNN09wtA8ZSdsItmtFJKpBN0IP4Il5HkTmTZnnkkW8i7JBdxbFrzAoAu7M
         D21sLCqeeroZhBHgDoV+emM0dXZUqGDMzl2Gs7s2GPErGxWj12vKsDveJ5iElU/lTkja
         85Gw==
X-Gm-Message-State: AOAM530NBTkcAV54LcWPHEzcmVo35awcAtgTBUhiXvqdiUHWMTDgSngU
        YCUO/5dAd3oPidmdtL+Iltj6nT5Ti6W68+m7Zf/jA6XWcjI=
X-Google-Smtp-Source: ABdhPJx3zhiQnSqPtOx1HQVS1Gc4qtfl1CbJYnwdk1/jZc/OmR56xGIE1RSfC0AZ2xEmUNaioLdAOv7nonIE8bmB/d4=
X-Received: by 2002:a05:6e02:15c9:: with SMTP id q9mr53633744ilu.28.1638154175459;
 Sun, 28 Nov 2021 18:49:35 -0800 (PST)
MIME-Version: 1.0
References: <cover.1637799475.git.isaku.yamahata@intel.com> <dbf8648ee18606a5a450bce32100771a3de5fd83.1637799475.git.isaku.yamahata@intel.com>
In-Reply-To: <dbf8648ee18606a5a450bce32100771a3de5fd83.1637799475.git.isaku.yamahata@intel.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Mon, 29 Nov 2021 10:49:23 +0800
Message-ID: <CAJhGHyDgPv==-H55GDuzXzQcioaw5xb-2skUbzDfyODaUVwimA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 16/59] KVM: x86: Add per-VM flag to disable direct
 IRQ injection
To:     isaku.yamahata@intel.com
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Erdem Aktas <erdemaktas@google.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 26, 2021 at 3:44 PM <isaku.yamahata@intel.com> wrote:

>  static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu)
>  {
>         return vcpu->run->request_interrupt_window &&
> +              !vcpu->kvm->arch.irq_injection_disallowed &&
>                 likely(!pic_in_kernel(vcpu->kvm));
>  }


Just judged superficially by the function names, it seems that the
logic is better to be put in kvm_cpu_accept_dm_intr() or some deeper
function nested in kvm_cpu_accept_dm_intr().

The function name will tell us that the interrupt is not injected
because the CPU doesn't accept it.  And it will also have an effect
that vcpu->run->ready_for_interrupt_injection will always be false
which I think is better to have for TDX.

>
> --
> 2.25.1
>

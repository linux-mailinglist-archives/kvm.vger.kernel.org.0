Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E01462BE0
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 05:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhK3FCS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 00:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhK3FCR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 00:02:17 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C34EC061574;
        Mon, 29 Nov 2021 20:58:59 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id w22so24512469ioa.1;
        Mon, 29 Nov 2021 20:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gtKz9hsBDu7Obb6zzumSNymu+cyQreT9aTnqVNXMp/I=;
        b=S9kTowrIayOMPGZVZh6Jos/AUNGX1yLqsDD4ynYktXEiNuOR5QWJpiS/gbEilaedUn
         CujOeUtBYCZrunm0zcUEPiJAqygbBU8vmoLQPq7ojAg8O295ClcD2DTODu/dujFM/pXw
         CZXfbqSIja/WY5jtozJIvlg0rOzbQTZ0jVnEl7LU4gblkezwIa7sout2zc9XLrvT62g4
         nUYkdPZ/aaCb+lDZ/9sU+nHCvRWd6pAhsWQncL/vbafP88spsDLzGPgM0R1tDgdwcoZc
         sQV+guSQL8/vwRkgCFMmYt1ZEKo592H8RsWXwK4lR8845Juknd4agiT6s91D65q7P7/3
         Vx4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gtKz9hsBDu7Obb6zzumSNymu+cyQreT9aTnqVNXMp/I=;
        b=7YuFDD/md9E6NY6ZwWu0keVp9ZXXtozWzJjrKKFsFGr8F0hL++MJVwXwizWfQEdL0a
         HOy1JgkfMiQFJcKfjIcHJ6HufRinDwBzR5lvCEQu3G4NM7pkdssfZw5xp4hHzd5GnDuV
         wwLRMyHc9YU167DMrqkYzsieZ6np61sSS7FjVSoGQZPZvReK54Jfczp8Mqf2m7/t+8hr
         KrmjWkWvpnTIyAZ+ahmw5mWoQWK5O6YjV8A09cktq/lNZ9700eEc0naxFgy+zo6SY48Q
         fXfSJrNbVvQ83H2MrPfb/VR7M6AjT5Npyr2fwvfOBqadc3FyU3RljhNz4yC+TMxauxlD
         IRlQ==
X-Gm-Message-State: AOAM532vKAQBwbjLiRM1VQNdGJCHMqQ/mAPGLy8+NPlY8tQKPsMYNA47
        SDo3OHQlRcdaWj4nY81m6n7Pm+kdBri/37zQS2E=
X-Google-Smtp-Source: ABdhPJx14joOukbs/npCKbBGVK8YQViVPXdjEWFILXvIEaMrSHCvRU9nw1tXRwPQjixMs7U2CA/Js/GXFIpzpFQctJ0=
X-Received: by 2002:a05:6602:3303:: with SMTP id b3mr60217026ioz.45.1638248338942;
 Mon, 29 Nov 2021 20:58:58 -0800 (PST)
MIME-Version: 1.0
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <4ede5c987a4ae938a37ab7fe70d5e1d561ee97d4.1637799475.git.isaku.yamahata@intel.com>
 <878rxcht3g.ffs@tglx> <20211126091913.GA11523@gao-cwp> <CAJhGHyAbBUyyVKL7=Cior_uat9rij1BB4iBwX+EDCAUVs1Npgg@mail.gmail.com>
 <20211129092605.GA30191@gao-cwp>
In-Reply-To: <20211129092605.GA30191@gao-cwp>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Tue, 30 Nov 2021 12:58:47 +0800
Message-ID: <CAJhGHyCiZn8ZwBbVepU+tfmTV6gcDhXxzvS39BwpgUj+6LCZ0g@mail.gmail.com>
Subject: Re: [RFC PATCH v3 53/59] KVM: x86: Add a helper function to restore 4
 host MSRs on exit to user space
To:     Chao Gao <chao.gao@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, isaku.yamahata@intel.com,
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
        isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021 at 5:16 PM Chao Gao <chao.gao@intel.com> wrote:

> >I did not find the information in intel-tdx-module-1eas.pdf nor
> >intel-tdx-cpu-architectural-specification.pdf.
> >
> >Maybe the version I downloaded is outdated.
>
> Hi Jiangshan,
>
> Please refer to Table 22.162 MSRs that may be Modified by TDH.VP.ENTER,
> in section 22.2.40 TDH.VP.ENTER leaf.

No file in this link:
https://www.intel.com/content/www/us/en/developer/articles/technical/intel-trust-domain-extensions.html
has chapter 22.

>
> >
> >I guess that the "lazy" restoration mode is not a valid optimization.
> >The SEAM module should restore it to the original value when it tries
> >to reset it to architectural INIT state on exit from TDX VM to KVM
> >since the SEAM module also does it via wrmsr (correct me if not).
>
> Correct.
>
> >
> >If the SEAM module doesn't know "the original value" of the these
> >MSRs, it would be mere an optimization to save an rdmsr in SEAM.
>
> Yes. Just a rdmsr is saved in TDX module at the cost of host's
> restoring a MSR. If restoration (wrmsr) can be done in a lazy fashion
> or even the MSR isn't used by host, some CPU cycles can be saved.

But it adds overall overhead because the wrmsr in TDX module
can't be skipped while the unneeded potential overhead of
wrmsr is added in user return path.

If TDX module restores the original MSR value, the host hypervisor
doesn't need to step in.

I think I'm reviewing the code without the code.  It is definitely
wrong design to (ab)use the host's user-return-msr mechanism.

>
> >But there are a lot of other ways for the host to share the values
> >to SEAM in zero overhead.
>
> I am not sure. Looks it requests a new interface between host and TDX
> module. I guess one problem is how/when to verify host's inputs in case
> they are invalid.
>

If the requirement of "lazy restoration" is being added (not seen in the
published document yet), you are changing the ABI between the host and
the TDX module.

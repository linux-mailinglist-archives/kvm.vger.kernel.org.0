Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DD5460F30
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 08:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbhK2HOP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 02:14:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235462AbhK2HMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 02:12:14 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F17C061758;
        Sun, 28 Nov 2021 23:08:51 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id h16so15495047ila.4;
        Sun, 28 Nov 2021 23:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C6dWNYHfNwwMDgVTMEboS2qGaBs9EpK0Y12B3cYYsgg=;
        b=C0tD1BqFaEplnOhJnFwDHJhyFgPbQFoN9FvL1JOLT5AdvrVJgWiUPpniceEW1cqDOH
         E19ZmdqGQi59jeH3EYMbSeNyCW3fbsb0U6ssN+8O8PqgJukh0rZoXSE9JHQV+31U7tp1
         B0pWiN9m0KVPR4STeIZqgMNnIslRpPBhpoengRyzTcTkE9Lctae+nfFIU6V0xxDBwqM2
         IvWoK1yxFBgxiDUiTlSGnNvr7m13eJ2kXEseOZiLKZOxyeA3okz8E1LzZsCvnyx+c62O
         UyNgkct8hZrvp4LrV99N8pguI9SKinyBmg1m/DkYXFRNdJHvn7hWpS3lrLPmhB4Bk75C
         lydA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C6dWNYHfNwwMDgVTMEboS2qGaBs9EpK0Y12B3cYYsgg=;
        b=lD3Gl67DmKPqCo/+qeyA63R2uziHc4UdYoYIRskz1jE551LfLgw8SdXaMVUO8xvK5v
         jRVlJnogcbDJGJcgyF3h2gVji6HMOaXzL5ZOZdhpMNuvvgM6nY9a0QXHhBtkF9smv4xy
         HCwFtZbxdsA5RCt0LsUmmXVksrJN21KYrKoSbCRuV52BcNVOsQ21qvsbVZz+BCmAymK4
         iqNMa7afYtbTSx/OtFtOWy4tAQ6YwiPGDW/kC2IeBrbUPz26w7FMBSo0le/rCNQ1wWWz
         2wkmt7yCZy1mVVVisBrqadjhFpfU50A7C6O3LgknDs4tCBBt0YtZt5eXRS4Q+Hqyrtj/
         ljnA==
X-Gm-Message-State: AOAM533Kk5WHwPoZKwoMbRFRhY6J9e8A8Zu1qnqJFvmUzsTOG55+MDmS
        h8+TWhznUo3667Sq5NMTdC7TFdFuQbjX+b5skWQ=
X-Google-Smtp-Source: ABdhPJwRzUi0ufVkIonkdgzoXFmfE5f5AFaR6B23puAjAUxq7OqWG6MpDlFr9lmrQVFYVIYDJ7iGkVuI34DBBVPzHNg=
X-Received: by 2002:a05:6e02:1a63:: with SMTP id w3mr47043107ilv.230.1638169731221;
 Sun, 28 Nov 2021 23:08:51 -0800 (PST)
MIME-Version: 1.0
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <4ede5c987a4ae938a37ab7fe70d5e1d561ee97d4.1637799475.git.isaku.yamahata@intel.com>
 <878rxcht3g.ffs@tglx> <20211126091913.GA11523@gao-cwp>
In-Reply-To: <20211126091913.GA11523@gao-cwp>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Mon, 29 Nov 2021 15:08:39 +0800
Message-ID: <CAJhGHyAbBUyyVKL7=Cior_uat9rij1BB4iBwX+EDCAUVs1Npgg@mail.gmail.com>
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

On Mon, Nov 29, 2021 at 2:00 AM Chao Gao <chao.gao@intel.com> wrote:
>
> On Thu, Nov 25, 2021 at 09:34:59PM +0100, Thomas Gleixner wrote:
> >On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
> >> From: Chao Gao <chao.gao@intel.com>
> >
> >> $Subject: KVM: x86: Add a helper function to restore 4 host MSRs on exit to user space
> >
> >Which user space are you talking about? This subject line is misleading
>
> Host Ring3.
>
> >at best. The unconditional reset is happening when a TDX VM exits
> >because the SEAM firmware enforces this to prevent unformation leaks.
>
> Yes.
>
> >
> >It also does not matter whether this are four or ten MSR.
>
> Indeed, the number of MSRs doesn't matter.
>
> >Fact is that
> >the SEAM firmware is buggy because it does not save/restore those MSRs.
>
> It is done deliberately. It gives host a chance to do "lazy" restoration.
> "lazy" means don't save/restore them on each TD entry/exit but defer
> restoration to when it is neccesary e.g., when vCPU is scheduled out or
> when kernel is about to return to Ring3.
>
> The TDX module unconditionally reset 4 host MSRs (MSR_SYSCALL_MASK,
> MSR_START, MSR_LSTAR, MSR_TSC_AUX) to architectural INIT state on exit from
> TDX VM to KVM.

I did not find the information in intel-tdx-module-1eas.pdf nor
intel-tdx-cpu-architectural-specification.pdf.

Maybe the version I downloaded is outdated.

I guess that the "lazy" restoration mode is not a valid optimization.
The SEAM module should restore it to the original value when it tries
to reset it to architectural INIT state on exit from TDX VM to KVM
since the SEAM module also does it via wrmsr (correct me if not).

If the SEAM module doesn't know "the original value" of the these
MSRs, it would be mere an optimization to save an rdmsr in SEAM.
But there are a lot of other ways for the host to share the values
to SEAM in zero overhead.

Could you provide more information?

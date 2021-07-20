Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F1E3CF370
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 06:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347488AbhGTD5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 23:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347030AbhGTD46 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 23:56:58 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B472CC061574
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 21:37:35 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id v18-20020a17090ac912b0290173b9578f1cso1229254pjt.0
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 21:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=46YiW0nFolbiSZgwAc3PrG6zYtjxfn1ha8Vdp9eDooo=;
        b=Ci/son6LKUEfJz7NbNrm9oP7xfe8wMZt5cdWShgSBEse1zHK8alLLyN3acSdmSFcYJ
         GRVbHiuZfFldnxhDp2I/QnEd+9K+BpIZdE8ScDx4yd9PVTQ8kNPqlD9NqvPKA+gtbCu/
         z90qvLhBbusOdk37sxI5f0obyE7TuEayqvZzTy8D1q5bD3deNiVAO87uJkg/0EthAo9z
         /NmiH4AMkfPA9FKG5R48l/NtLIj/aAnU46L3fBvL8Bi0GLfYFd9BFqB9Du5pB8ne86st
         FEGs+ouFyBFB2sTpiBRPqX5EQc5bN53NI+mzYjQeuuWcSM3EWPybsAPFU85zjX1jnykp
         NHLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=46YiW0nFolbiSZgwAc3PrG6zYtjxfn1ha8Vdp9eDooo=;
        b=crEXrnjYayXJmN7tFb5mETINOt4RzgpzHNXzQgFoaoVB+5NnZAoijvGcJd/v6COUiD
         GQ/QRpjd0QgRSuPG2jI8x4I8+DeCcReMnVGf15P50DVjk+OwpfAZvBHejlYVCK/fdT34
         98DC6ke06C5I7Xcm11Ii662/rjDL5LX2l7YBsqn6r8xA4FM3Qzw6vf0ER7eF5C1n9HRb
         xKlvbkrGlNde9E4Jo3cagwlHWCzWe8dn2ryz3FqFne1b28/HEpaqIO0zX8aP6W8gpVPk
         8KJ1gJWmj7jcJvEYvav7WpypVXSEheQP+DvUqE5XmeGtLFUvfuPMQ4iMVl27ynsDoJWW
         tVCw==
X-Gm-Message-State: AOAM532Yr/qKWPc2WpbJo1bw9YhQlKtvxPFmNTch7732894ITjtfSKsC
        AQVwxeQ5x1dM/aOm9cuCw8G9f/mefgZrJmQ0y/+Lbg==
X-Google-Smtp-Source: ABdhPJw+RvTs5nygHUL9AvkEFzczhJB6ea8NCydt9Rh5DZUTdWijbP6KbaHl7TSPmHUWBG0y4pZeLjG30Yd4I/x096E=
X-Received: by 2002:a17:90b:1b4d:: with SMTP id nv13mr28144573pjb.216.1626755855130;
 Mon, 19 Jul 2021 21:37:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com> <20210713163324.627647-47-seanjc@google.com>
In-Reply-To: <20210713163324.627647-47-seanjc@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 19 Jul 2021 21:37:19 -0700
Message-ID: <CAAeT=FzGDUr8MK5Uf3jyUxtf+2jCf=bgG760L0mjjM3vRsXKSg@mail.gmail.com>
Subject: Re: [PATCH v2 46/46] KVM: x86: Preserve guest's CR0.CD/NW on INIT
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 13, 2021 at 9:35 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Preserve CR0.CD and CR0.NW on INIT instead of forcing them to '1', as
> defined by both Intel's SDM and AMD's APM.
>
> Note, current versions of Intel's SDM are very poorly written with
> respect to INIT behavior.  Table 9-1. "IA-32 and Intel 64 Processor
> States Following Power-up, Reset, or INIT" quite clearly lists power-up,
> RESET, _and_ INIT as setting CR0=60000010H, i.e. CD/NW=1.  But the SDM
> then attempts to qualify CD/NW behavior in a footnote:
>
>   2. The CD and NW flags are unchanged, bit 4 is set to 1, all other bits
>      are cleared.
>
> Presumably that footnote is only meant for INIT, as the RESET case and
> especially the power-up case are rather non-sensical.  Another footnote
> all but confirms that:
>
>   6. Internal caches are invalid after power-up and RESET, but left
>      unchanged with an INIT.
>
> Bare metal testing shows that CD/NW are indeed preserved on INIT (someone
> else can hack their BIOS to check RESET and power-up :-D).
>
> Reported-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Thank you for the fix and checking the CD/NW with the bare metal testing.

Regards,
Reiji

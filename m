Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD3C332E42
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 19:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhCIS1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 13:27:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhCIS0u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 13:26:50 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAB9C06174A
        for <kvm@vger.kernel.org>; Tue,  9 Mar 2021 10:26:50 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id v192so8427191oia.5
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 10:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aA39NALH0TyAKu/mVeAb+Hf6XqKon/lgpyQHkCA2b/s=;
        b=Oj2xkiT3AZrHJGVbcWUElH9kYBD3g5/BxJeoEniFwxOzd9NsKyvfl78BWMj0qFw/vf
         HKyc6JZUU0BKNbo5d3AatS/wqGOdVWghthNo81J+TOUZbu5LWzrIfZJr6uqYPxrfBets
         iDBaf2+bTdC+V+e+Mn92heLFMoT9jo0bHAKKx+vH3NxRVBvjd4Z5epnMec/J8XwPDul+
         L8/MrWlTMM1bFyrNoK1AHlhwASTfnw+ooUjnOGLpCC4k8JFz1pzZM2gEnjAxdizXjv5O
         Yk8NV7p4w6YN7C38Znh/5zcpGY2Bj1wHkzfnGvKfX2zNiYUyJIFBFUlDqohXbsx3gNev
         v8Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aA39NALH0TyAKu/mVeAb+Hf6XqKon/lgpyQHkCA2b/s=;
        b=NodwbUEoI61gpCkQNEjdiXfIs54kzRZIWkIeFLxSQuXRPQtkiQBoGCc67QUorJfqSC
         cDHgs/HU7e8hMyjZKJmYQobWk4Hc7i3MWmYwg8cOeb9lkEbDLKIUMX+yk4s2Xk3OUTtm
         PPJ/IE1tOsJJN8vvPlVefpsxjvISlrhuGvrJahk7F8eMFOaiEehPfX3AWVhe7ZzzGMZ+
         h4kK/NKJzowQlsadLkWhB34LXZT7cUBMPAvypqaKwOW5QsZSlc4hadu/pYUan/VK5NCu
         +nvWHlB6eDJAlALG0cq6+nEIXPOjxOUdc3FpVIIsi1sAACN18JMauzjomKnrnpt7JvDv
         zT5Q==
X-Gm-Message-State: AOAM530BbeMD0IceSAUghuyT1hbDFPoT1s2NZtIqQzdG/DVTkCk22Q38
        b3fUvMp+7E0JxGqk0VkC1lTgK15yEOj8t7xzUqBL7Q==
X-Google-Smtp-Source: ABdhPJw56yVgQmF8+OzteYQZh54ZMqLc17XK6NQjBauRe6wk6irf/rtD1PTQqeTsb9QIJdjiT8BD5U6/Oq42vXHgCLI=
X-Received: by 2002:aca:acc2:: with SMTP id v185mr3774689oie.28.1615314409351;
 Tue, 09 Mar 2021 10:26:49 -0800 (PST)
MIME-Version: 1.0
References: <20210309171019.1125243-1-seanjc@google.com>
In-Reply-To: <20210309171019.1125243-1-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 9 Mar 2021 10:26:38 -0800
Message-ID: <CALMp9eRmxLTXdVoweUpZPaSyY7O4HK=KcLT243TbV4MpE8Dttg@mail.gmail.com>
Subject: Re: [PATCH v2] x86/perf: Use RET0 as default for guest_get_msrs to
 handle "no PMU" case
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Like Xu <like.xu@linux.intel.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzbot+cce9ef2dd25246f815ee@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 9, 2021 at 9:10 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Initialize x86_pmu.guest_get_msrs to return 0/NULL to handle the "nop"
> case.  Patching in perf_guest_get_msrs_nop() during setup does not work
> if there is no PMU, as setup bails before updating the static calls,
> leaving x86_pmu.guest_get_msrs NULL and thus a complete nop.  Ultimately,
> this causes VMX abort on VM-Exit due to KVM putting random garbage from
> the stack into the MSR load list.
>
> Add a comment in KVM to note that nr_msrs is valid if and only if the
> return value is non-NULL.
>
> Fixes: abd562df94d1 ("x86/perf: Use static_call for x86_pmu.guest_get_msrs")
> Cc: Like Xu <like.xu@linux.intel.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Jim Mattson <jmattson@google.com>
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Reported-by: syzbot+cce9ef2dd25246f815ee@syzkaller.appspotmail.com
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>
> v2:
>  - Use __static_call_return0 to return NULL instead of manually checking
>    the hook at invocation.  [Peter]
>  - Rebase to tip/sched/core, commit 4117cebf1a9f ("psi: Optimize task
>    switch inside shared cgroups").
>
...
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 50810d471462..32cf8287d4a7 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6580,8 +6580,8 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
>         int i, nr_msrs;
>         struct perf_guest_switch_msr *msrs;
>
> +       /* Note, nr_msrs may be garbage if perf_guest_get_msrs() returns NULL. */

You could drop the scary comment with a profligate initialization of
nr_msrs to 0.

[Apologies to those seeing this twice. I blame gmail.]

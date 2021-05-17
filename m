Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEEF386DE6
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 01:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344611AbhEQXwC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 19:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243685AbhEQXwC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 19:52:02 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A99C061573
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 16:50:45 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id b9-20020a17090a9909b029015cf9effaeaso488348pjp.5
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 16:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rri/ZUWebCAURWUdOsBuRJz+8kSWlPQMsU2NIL6PvoY=;
        b=FRMPueRDHgiD5iCfFvtD1s0ilAwmF/bus1HxUHlZsO4yO+Y4hKh9zMq4hstI9wA+yr
         Ns3pzVTPc0f4VwxvgvaiwPAcXYq5wTkTUnEcw5bxrcDTzD7zqgsfQ1MyutHQP97qzgIo
         ecMfPUCp/aKHEWCaIUKcnuTuMiSyd6R3+z64HVpN1n8fy5NIjhZggdtG6T8scxbMAYZi
         nthZhEZrnsytJUDMpXJmY2YmWXPWE0xdmWlUKf3ihhZXJbPVkSjul1zUJqJ6AYuIG5hn
         nJZdH4r8iXoMsNTCpb1NG+rMOvyOHBJQS8ZZnYa5EKDqIel5WoRnSevz3VAh/ZKh4bi1
         5JyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rri/ZUWebCAURWUdOsBuRJz+8kSWlPQMsU2NIL6PvoY=;
        b=MbwvM+AvqBVYxPlMFsfWINuLg/mJZpdSx+ewKSesT6huhk4zrMyyV5clKVbc6R03FE
         zDlFPnJaeNS7DYe+OsgObqmhh4WTsSoA6msiHl710oyQzmRKdXptXNmPbykFq8UXIKjD
         XzQ+lmcw8fx7GY5u7tT5UQzhX5LIsmz+9M/9DeK67wDoevH8LxB2t417sdmHC/KpobMT
         A5AKkjq5sI12i1B6+Q4IHuEVN2cu7mSS81/H8DNoA8UMZiJVl0zBC+QK4h6zbJuj+Enx
         +QXoKls64dEKH8XYRnqsHdAF15cDgLsPBsxMM1Qa5fycdyr6mlYT1Gj5TuUbyLe6TWq+
         s6hA==
X-Gm-Message-State: AOAM530H16wl0AMVlsmkoAlctIwWs5J4UyFcdOafRVxCv5dp5u4j4t9v
        dt9d7Kaa9ZYj4SZcISFQBFHW5lY6hCmk8Dfc6CkNZQ==
X-Google-Smtp-Source: ABdhPJyy7iz0pvj/Fs0u3ozhUqVj0td4iHAzKCmbTFdgNCXrudwdwNQEWknZydQnZmI8D3Vrap2sp+6pKzwu8PknRfw=
X-Received: by 2002:a17:90a:6f06:: with SMTP id d6mr2110560pjk.216.1621295444570;
 Mon, 17 May 2021 16:50:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com> <20210424004645.3950558-36-seanjc@google.com>
In-Reply-To: <20210424004645.3950558-36-seanjc@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 17 May 2021 16:50:28 -0700
Message-ID: <CAAeT=Fx08jBjXoduko_O3v+q67a2fx6byU6z6gM=fBmSWFkt8g@mail.gmail.com>
Subject: Re: [PATCH 35/43] KVM: x86: Move setting of sregs during vCPU
 RESET/INIT to common x86
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

> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1204,12 +1204,6 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>         init_sys_seg(&save->ldtr, SEG_TYPE_LDT);
>         init_sys_seg(&save->tr, SEG_TYPE_BUSY_TSS16);
>
> -       svm_set_cr0(vcpu, X86_CR0_NW | X86_CR0_CD | X86_CR0_ET);
> -       svm_set_cr4(vcpu, 0);
> -       svm_set_efer(vcpu, 0);
> -       kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
> -       vcpu->arch.regs[VCPU_REGS_RIP] = 0x0000fff0;

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Those your vCPU RESET/INIT changes look great.

I think the change in init_vmcb() basically assumes that the
function is called from kvm_vcpu_reset(via svm_vcpu_reset()).
Although shutdown_interception() directly calls init_mcb(),
I would think the change doesn't matter for the shutdown
interception case.

IMHO it would be a bit misleading that a function named 'init_vmcb',
which is called from other than kvm_vcpu_reset (svm_vcpu_reset()),
only partially resets the vmcb (probably just to me though).
So, I personally think it would be better if its name or comment
can give some more specific information about the assumption.

BTW, it looks like two lines of "vcpu->arch.hflags = 0;"
can be also removed from the init_vmcb() as well.

Thanks,
Reiji

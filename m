Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2822D665A
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 20:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392687AbgLJTYZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 14:24:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:45174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390143AbgLJTYM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 14:24:12 -0500
X-Gm-Message-State: AOAM531HAX1/fbupPH2NFXnsrABiOpBdJEg6pjUnYcSau6IESngsyYKx
        6kFtOub3nf65+I4gjtZtFnF5wS72hNLp3Vk0bWAqAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607628212;
        bh=eJMsI0+ccl0FL0VnPRYx2wbilnqvAbvifn0xrb0doJk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hcVeTSz8ybNxJNKCaqN7NeNd4d25X/70iSI32uFGoidnFGhhH53hT1mRfbLnRdb1u
         fy09qA1ff4+q+4rXVOLLCQ8w65psRuShL+w0hKFyXpICXFIsi1+Qv9ATs/g8jbnM6X
         /khxvIQogTXU/UhZJHYcqEUqCC0W1NUSgLPlOvVbyWPin384TNdhnEDpPS52SHzV/G
         liEtsnCwtTFmMzFGZiLVHlzhEzvY3PkxqPlY/RMYamhC9zl+eQUm32zgitV1x0B/tZ
         bkDOP3qA0GL/6ZupAM2vFlJ6dqhKQXhGR/0Eri4FBwJX0dKyCdKGkZu6lvbhTz3aRH
         w8g/DXYhrD9uw==
X-Google-Smtp-Source: ABdhPJwdrfYH1JpkWcUq49If+4LmYbjbjjudaPKF2D0Ft08usBxVCDcx4/CrFmaxvkvOuIsK89No6dR3kUklY4RNinw=
X-Received: by 2002:adf:e98c:: with SMTP id h12mr9856560wrm.75.1607628210100;
 Thu, 10 Dec 2020 11:23:30 -0800 (PST)
MIME-Version: 1.0
References: <20201210174814.1122585-1-michael.roth@amd.com>
In-Reply-To: <20201210174814.1122585-1-michael.roth@amd.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 10 Dec 2020 11:23:19 -0800
X-Gmail-Original-Message-ID: <CALCETrXo+2LjUt_ObxV+6u6719gTVaMR4-KCrgsjQVRe=xPo+g@mail.gmail.com>
Message-ID: <CALCETrXo+2LjUt_ObxV+6u6719gTVaMR4-KCrgsjQVRe=xPo+g@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: use vmsave/vmload for saving/restoring
 additional host state
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 10, 2020 at 9:52 AM Michael Roth <michael.roth@amd.com> wrote:
>   MSR_STAR, MSR_LSTAR, MSR_CSTAR,
>   MSR_SYSCALL_MASK, MSR_KERNEL_GS_BASE,
>   MSR_IA32_SYSENTER_CS,
>   MSR_IA32_SYSENTER_ESP,
>   MSR_IA32_SYSENTER_EIP,
>   MSR_FS_BASE, MSR_GS_BASE

Can you get rid of all the old FS/GS manipulation at the same time?

> +       for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++) {
> +               rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
> +       }
> +
> +       asm volatile(__ex("vmsave")
> +                    : : "a" (page_to_pfn(sd->save_area) << PAGE_SHIFT)
> +                    : "memory");
> +       /*
> +        * Host FS/GS segment registers might be restored soon after
> +        * vmexit, prior to vmload of host save area. Even though this
> +        * state is now saved in the host's save area, we cannot use
> +        * per-cpu accesses until these registers are restored, so we
> +        * store a copy in the VCPU struct to make sure they are
> +        * accessible.
> +        */
>  #ifdef CONFIG_X86_64
> -       rdmsrl(MSR_GS_BASE, to_svm(vcpu)->host.gs_base);
> +       svm->host.gs_base = hostsa->gs.base;
>  #endif

For example, this comment makes no sense to me.  Just let VMLOAD
restore FS/GS and be done with it.  Don't copy those gs_base and
gs.base fields -- just delete them please.  (Or are they needed for
nested virt for some reason?  If so, please document that.)

> -       savesegment(fs, svm->host.fs);
> -       savesegment(gs, svm->host.gs);
> -       svm->host.ldt = kvm_read_ldt();
> -
> -       for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
> -               rdmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
> +       svm->host.fs = hostsa->fs.selector;
> +       svm->host.gs = hostsa->gs.selector;

This too.  Why is the host code thinking about selectors at all?

> -       kvm_load_ldt(svm->host.ldt);

I have a patch that deletes this, too.  Don't worry about the conflict
-- I'll sort it out.

> @@ -120,7 +115,6 @@ struct vcpu_svm {
>         struct {
>                 u16 fs;
>                 u16 gs;
> -               u16 ldt;
>                 u64 gs_base;
>         } host;

Shouldn't you be about to delete fs, gs, and gs_base too?

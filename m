Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0794376974
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 19:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbhEGRXk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 13:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbhEGRXj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 13:23:39 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348AAC061574
        for <kvm@vger.kernel.org>; Fri,  7 May 2021 10:22:38 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id u19-20020a0568302493b02902d61b0d29adso7743159ots.10
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 10:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gQ3ipQxbX73bGU2SXA3y2Bzh59V5vke4f329EGQixvg=;
        b=KH8GL3iNV6Z/uD3TMYgD+CrCfLVaUDeAs0zqsk9jCpnDJJCpW0QyHmMSjWWmSLhvJ1
         FDtdqZsKLe2uoN2TDpAYLCOrimwhcklk1sSa42lMZ/jWzznAXKuD2WvTNhdBcUnJy88h
         Q+lub5DzGRR83dIb2AC9agASP4rw1QyRLhGkA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gQ3ipQxbX73bGU2SXA3y2Bzh59V5vke4f329EGQixvg=;
        b=d7o7Q3VFiL0NCmaiC0/m61SMISVVJKUEsnfH3E+/JQWyqGJ5pItMN1HODm7aEkPvBw
         /KV7uBxK+2BSck/pT6Z7oVjEWn+nvETixPAMiTAttxpptp2TcvOwoy5NJ7Xu6UrtdU3u
         z9wyDgjV4U7tyRr0kUFJ53qv5rn87rB+xwrnKo/Z5NxB1+Pl5LHmkJpasmdgkgtOXeWt
         iq3RDF38YlT/MBl8aD6m/Oq1mNh9zx6HuBnqY/xRGO1SIxmKR2ElpW7nMq8wU71RGdII
         /pK7KXLHQvlKijbZrKGzllU0xU7ABPlCGq8Oi5khp8dPJVj20RtiohbJkqQ6HC7Pv6M6
         GwEA==
X-Gm-Message-State: AOAM530+TTOus5ZTFz7zf0FbQS1RNrhHF7Ijrl9VzG+j6BZTG0sQd62N
        mEjVJdBw2tmrQUTkmkR/6QywZaY053KS87VZwGwTog==
X-Google-Smtp-Source: ABdhPJxDU02k2Jf2AhhsznQct+cAPyxL7BbEYKFvu6VMh4FAxQjvUIGiWjfmwnilcwXbYXtl5qcWmP5bc5q29/lz1jM=
X-Received: by 2002:a9d:764f:: with SMTP id o15mr9279052otl.164.1620408157620;
 Fri, 07 May 2021 10:22:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210507150636.94389-1-jon@nutanix.com>
In-Reply-To: <20210507150636.94389-1-jon@nutanix.com>
From:   Venkatesh Srinivas <venkateshs@chromium.org>
Date:   Fri, 7 May 2021 10:22:25 -0700
Message-ID: <CAA0tLEoyy_ogDc11r_1T907Rp5CwgM64hFwRt5SX40THp2+C3A@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: use X86_FEATURE_RSB_CTXSW for RSB stuffing in vmexit
To:     Jon Kohler <jon@nutanix.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 7, 2021 at 8:08 AM Jon Kohler <jon@nutanix.com> wrote:
>
> cpufeatures.h defines X86_FEATURE_RSB_CTXSW as "Fill RSB on context
> switches" which seems more accurate than using X86_FEATURE_RETPOLINE
> in the vmxexit path for RSB stuffing.
>
> X86_FEATURE_RSB_CTXSW is used for FILL_RETURN_BUFFER in
> arch/x86/entry/entry_{32|64}.S. This change makes KVM vmx and svm
> follow that same pattern. This pairs up nicely with the language in
> bugs.c, where this cpu_cap is enabled, which indicates that RSB
> stuffing should be unconditional with spectrev2 enabled.
>         /*
>          * If spectre v2 protection has been enabled, unconditionally fill
>          * RSB during a context switch; this protects against two independent
>          * issues:
>          *
>          *      - RSB underflow (and switch to BTB) on Skylake+
>          *      - SpectreRSB variant of spectre v2 on X86_BUG_SPECTRE_V2 CPUs
>          */
>         setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
>
> Furthermore, on X86_FEATURE_IBRS_ENHANCED CPUs && SPECTRE_V2_CMD_AUTO,
> we're bypassing setting X86_FEATURE_RETPOLINE, where as far as I could
> find, we should still be doing RSB stuffing no matter what when
> CONFIG_RETPOLINE is enabled and spectrev2 is set to auto.

If I'm reading https://software.intel.com/security-software-guidance/deep-dives/deep-dive-indirect-branch-restricted-speculation
correctly, I don't think an RSB fill sequence is required on VMExit on
processors w/ Enhanced IBRS. Specifically:
"""
On processors with enhanced IBRS, an RSB overwrite sequence may not
suffice to prevent the predicted target of a near return from using an
RSB entry created in a less privileged predictor mode.  Software can
prevent this by enabling SMEP (for transitions from user mode to
supervisor mode) and by having IA32_SPEC_CTRL.IBRS set during VM exits
"""
On Enhanced IBRS processors, it looks like SPEC_CTRL.IBRS is set
across all #VMExits via x86_virt_spec_ctrl in kvm.

So is this patch needed?

Thanks,
-- vs;

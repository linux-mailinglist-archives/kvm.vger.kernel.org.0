Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D81D1BCF60
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 00:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgD1WEO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 18:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726737AbgD1WEO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 18:04:14 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A7CC03C1AD
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 15:04:14 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id k6so50544iob.3
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 15:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hdye9Y+HN3Ay3k4lAQbTQjGJKjGjfhnRJ5ClLYqLI5Q=;
        b=EYfcSwBKoyf1yvsIqjslcUpr811ti1beomA8wAYjwTPxou14WZi54Y1DRkaCZUFbzS
         fod/drVFx08FoL743YYDcZt006b5fMlrKOhEBMc4mWuSCmaYYwZkmU3OnVT2w56YAGPt
         dwetTgWPn05l/H7Uw5Q2HAA94rrAsF8o3ibPAdUZJPCtvTuONOnkW2Iou8UMTPASDrh4
         VWBxlx9oC3tOZvW+Q7G3fRsF3AmnRSLqL0QMA0x+k9MI6P1D4E51Gs5ZhZqI+EKccIrZ
         0JtZZdKuZU3XbuJSvldJMMICbIXaSn86M3joweoUyWG+rjeODIhzGiQL4bfNphcwoJs2
         X47w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hdye9Y+HN3Ay3k4lAQbTQjGJKjGjfhnRJ5ClLYqLI5Q=;
        b=QmYI5fN1DNW8QDrDGZHcts7I3kv3ojhVMziSpkjp7Z6ebaJH3kGscOXfgsMsGIyQox
         +8+mw9UWQnU7/MTNgsIAsKp/s1pECsfyE46n8TAlxtb3OvxiIOnaAvMgW8aXJoqHTF//
         CCTcOCigwT0afAtKpcTTM8CO3Ylsys6QEUZOX17VE6eIhpZtzc0rB5Iv2o0FeI/QWLio
         WH+Zq+3vtP8cLweU36QI9AbDaR2kcVP4BE4essQDED6DfCwG0tENBp+WGBKiv9HHmEix
         sqkPct8nIt4/pDnF22SD5fko6ENujSNmmwbRJpCiGtnZP7+/4EQyiylKp8Wy0VZ10wKX
         4xcw==
X-Gm-Message-State: AGi0Pub1khv41HGhxVyUvR7/u2XRljfbe5nfBwaXcfRct48HQ9TFCcT5
        v0pm9shyeEoYtY3JDNlqkuvBlvXr0j4xZivOFQXkug==
X-Google-Smtp-Source: APiQypI9Nf6EOOBA5QVkfYCA6/jwvMsAYAzR0B14+Ay30XrCyHLqc0Nyb66cxDFd7jShKchKfrhAeQtEqRe90mQA/zU=
X-Received: by 2002:a6b:6318:: with SMTP id p24mr4129450iog.12.1588111453327;
 Tue, 28 Apr 2020 15:04:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200423022550.15113-1-sean.j.christopherson@intel.com> <20200423022550.15113-10-sean.j.christopherson@intel.com>
In-Reply-To: <20200423022550.15113-10-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 28 Apr 2020 15:04:02 -0700
Message-ID: <CALMp9eSuYqeVmWhb6q7T5DAW_Npbuin_N1+sbWjvcu0zTqiwsQ@mail.gmail.com>
Subject: Re: [PATCH 09/13] KVM: nVMX: Prioritize SMI over nested IRQ/NMI
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 22, 2020 at 7:26 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Check for an unblocked SMI in vmx_check_nested_events() so that pending
> SMIs are correctly prioritized over IRQs and NMIs when the latter events
> will trigger VM-Exit.  This also fixes an issue where an SMI that was
> marked pending while processing a nested VM-Enter wouldn't trigger an
> immediate exit, i.e. would be incorrectly delayed until L2 happened to
> take a VM-Exit.
>
> Fixes: 64d6067057d96 ("KVM: x86: stubs for SMM support")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 1fdaca5fd93d..8c16b190816b 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3750,6 +3750,12 @@ static int vmx_check_nested_events(struct kvm_vcpu=
 *vcpu)
>                 return 0;
>         }
>
> +       if (vcpu->arch.smi_pending && !is_smm(vcpu)) {
> +               if (block_nested_events)
> +                       return -EBUSY;
> +               goto no_vmexit;
> +       }
> +

From the SDM, volume 3:

=E2=80=A2 System-management interrupts (SMIs), INIT signals, and higher
priority events take priority over MTF VM exits.

I think this block needs to be moved up.

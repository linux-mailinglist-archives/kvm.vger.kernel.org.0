Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7BE1241FCA
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 20:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbgHKShQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 14:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgHKShQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 14:37:16 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD19C06174A
        for <kvm@vger.kernel.org>; Tue, 11 Aug 2020 11:37:16 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id t7so10921021otp.0
        for <kvm@vger.kernel.org>; Tue, 11 Aug 2020 11:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MPmEpV+S5XrRscOk/Eg/G08Q9/7/UfkmP68xdbi6YbQ=;
        b=AZT2FIJU70/HeZJuzY87k1o1sPM3mQmzAgSTl6XGTftXY6Jk2e3roKe0cYquAfr3he
         07UaT9NXAjzzkMJfMsQcg1N04EkcTe/36lHzufmrtQJYK9f7n4JOG5alsCEvhCdgqMDl
         wVKbqFiCXbOQrg+PGX+d7qNfYr2kdPivU1/fXZU0oqm1OEEbf4SsJtbcrpXPuxPWvb8Y
         alDE3Op/m693JJW+cW5R6BFqrSgmUq7FI2Egmd+hNrL19NPZSn8BIbZETuOWtt8lgFIt
         wcLC1lZQJUccO8msuajgS1kLBl9RIgJP9Wq4udC+HXT4Yvv4cW3c6197xa+/NO30/CMF
         N+/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MPmEpV+S5XrRscOk/Eg/G08Q9/7/UfkmP68xdbi6YbQ=;
        b=mMmH7gbDPl9UsDE6dZFKJNJOumTbHvHjEB/2yxBPEckCyoUJimyzlrHnHIumXwL2jf
         iH5j+eBCV3R7JLTLBIH2M1mwZwAtuawWTRojnyNIjBl681ApAmEZYm4Xke1O3ym2CHCr
         P1PpbWGi9wXIRpDghRetADj/UNR/nhJAvx4v69/6o8+svDbYZ5YdggN7EcVaIn2fPGZt
         D5d/Qd+vRSppba6Y9lH6PM7bweSOLu5uP468sZXjB2PA8+/cz9AQ7BtbjKdiRpFc4pX5
         u5ErLp5R5bdRyw2bDjvl0dUw6YEB162fwyGGAkQkYknAiHdWFYDUaNtIqMBnxSJfTeO5
         NaUg==
X-Gm-Message-State: AOAM531ckMPbpaeZMtMGDjC6kDGroIohf2HmUxu6vSRh8jgzSYBKRx5e
        Uxtd2+wiDTaaeIFYPeYGakzDIMGeRc8bXAtFvjhDIt2gQkw=
X-Google-Smtp-Source: ABdhPJztzYmIVx7/ggyd/alOg6bUZy5POSBVuJq6TTthKfjYO/oETjk/njtn6u+bj39nHA8hkMYR5d2siUx4IwMtnkc=
X-Received: by 2002:a9d:22ca:: with SMTP id y68mr6042291ota.56.1597171034934;
 Tue, 11 Aug 2020 11:37:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200810223927.82895-1-krish.sadhukhan@oracle.com>
In-Reply-To: <20200810223927.82895-1-krish.sadhukhan@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 11 Aug 2020 11:37:03 -0700
Message-ID: <CALMp9eT00_qO8NXnLjtMzHCUYOCV0pWQ2jWp4-EPu+Gc9XpNGg@mail.gmail.com>
Subject: Re: [PATCH] KVM: nSVM: Test combinations of EFER.LME, CR0.PG,
 CR4.PAE, CR0.PE and CS register on VMRUN of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 10, 2020 at 3:40 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
> According to section "Canonicalization and Consistency Checks" in APM vol. 2
> the following guest state combinations are illegal:
>
>         * EFER.LME and CR0.PG are both set and CR4.PAE is zero.
>         * EFER.LME and CR0.PG are both non-zero and CR0.PE is zero.
>         * EFER.LME, CR0.PG, CR4.PAE, CS.L, and CS.D are all non-zero
>
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> ---
>  x86/svm_tests.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
>
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 1908c7c..43208fd 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -1962,7 +1962,51 @@ static void test_efer(void)
>         SVM_TEST_REG_RESERVED_BITS(16, 63, 4, "EFER", vmcb->save.efer,
>             efer_saved, SVM_EFER_RESERVED_MASK);
>
> +       /*
> +        * EFER.LME and CR0.PG are both set and CR4.PAE is zero.
> +        */
> +       u64 cr0_saved = vmcb->save.cr0;
> +       u64 cr0;
> +       u64 cr4_saved = vmcb->save.cr4;
> +       u64 cr4;
> +
> +       efer = efer_saved | EFER_LME;
> +       vmcb->save.efer = efer;
> +       cr0 = cr0_saved | X86_CR0_PG;
> +       vmcb->save.cr0 = cr0;
> +       cr4 = cr4_saved & ~X86_CR4_PAE;
> +       vmcb->save.cr4 = cr4;
> +       report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
> +           "CR0.PG=1 (%lx) and CR4.PAE=0 (%lx)", efer, cr0, cr4);

This seems adequate, but you have to assume that CR0.PE is set, or you
could just be testing the second rule (below).

> +       /*
> +        * EFER.LME and CR0.PG are both set and CR0.PE is zero.
> +        */
> +       vmcb->save.cr4 = cr4_saved;
> +       cr0 &= ~X86_CR0_PE;
> +       vmcb->save.cr0 = cr0;
> +       report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
> +           "CR0.PG=1 and CR0.PE=0 (%lx)", efer, cr0);

This too, seems adequate, but you have to assume that CR4.PAE is set,
or you could just be testing the first rule (above).

> +       /*
> +        * EFER.LME, CR0.PG, CR4.PAE, CS.L, and CS.D are all non-zero.
> +        */
> +       u32 cs_attrib_saved = vmcb->save.cs.attrib;
> +       u32 cs_attrib;
> +
> +       cr4 = cr4_saved | X86_CR4_PAE;

Or'ing in X86_CR4_PAE seems superfluous, since you have to assume that
cr4_saved already has the bit set for the above test to be worthwhile.

> +       vmcb->save.cr4 = cr4;
> +       cs_attrib = cs_attrib_saved | SVM_SELECTOR_L_MASK |
> +           SVM_SELECTOR_DB_MASK;
> +       vmcb->save.cs.attrib = cs_attrib;

At this point, the second rule still applies (EFER.LME and CR0.PG are
both set and CR0.PE is zero), so this doesn't necessarily verify the
third rule at all.

> +       report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
> +           "CR0.PG=1 (%lx), CR4.PAE=1 (%lx), CS.L=1 and CS.D=1 (%x)",
> +           efer, cr0, cr4, cs_attrib);
> +
> +       vmcb->save.cr4 = cr4_saved;
> +       vmcb->save.cs.attrib = cs_attrib_saved;
>         vmcb->save.efer = efer_saved;
> +       vmcb->save.cr0 = cr0_saved;
>  }
>
>  static void test_cr0(void)
> --
> 2.18.4
>

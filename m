Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4061B4C9102
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 18:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbiCARAt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 12:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236145AbiCARAs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 12:00:48 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D901622B05
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 09:00:04 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id bk29so4229272wrb.4
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 09:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LsyfyDhQ1/rlt/tsv5J+IlS3KuEnhj9qY+plhX43rhg=;
        b=XlA1MAAdWvqErDbM5Uqbv9buI11wra326OgeQGMu1p+7TEVTGw87wAJzlrBk+AYo/w
         ILSzXG+q9Ii6Bq8Uc/AgrAWIn4qu2+5f/yRZtwHt/pxDr4pVNW3NnS1+35b/F5byIMpv
         F6NVyj++1K1f/mLDb0acyhrLIQK2zaWBumgYGsKl9TYGKozdKrT79Iii8Az53gF8qA6v
         7hKwCTdG8gXH92Nl8xSBo1OUAIHNzkWGAVKztWglOiAra1yJXTKpymbIEQNXo7DAnX04
         tplmv9wALKsLJ/AewynArvTw/ifA/aQCmhiTjRfR7KxvOD/hkKdIkYTVc35m5NppXCjh
         wAbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LsyfyDhQ1/rlt/tsv5J+IlS3KuEnhj9qY+plhX43rhg=;
        b=s6MrhUtZYVyUxDE2CHhyx2wprVQj4/Ax/T+AFXM7vcL+e86xRz7oXKOAU3vGNyAp/Y
         pVw9S7FqtZdSl2C6yC01i0fEeSDBegiRKfgB1CNaSSbvMnMa5FAP7sUAnkpf1aSXQ7CY
         wEC3lBkARjHwbJQoM4EUyMlNTadJHQFmugfUPK6rZMntVWH8ez00O1mJarrgkJtAJ0RM
         EnkJuV4uNkVoxMDMWZgrBVcqltzA3OKVJ/I+mf+8Vc8cWHGOKCZWc8bCQ0dneEk1yZqh
         YbHNvkudRYfZpsl3smwte778x4/6GuPSHQV9t3n/tCXz/JifkGF/VRbQQNx6ROKyFeJI
         l6yw==
X-Gm-Message-State: AOAM532C7VaU9icSdZLxLWJ0QsWZ0TljsC1feQvuAvPEgbhVzWhKvJnG
        B3bWw8FP5yB9Ylcrk8nmWQ6Ybu2sSTm6GwIQUhqODg==
X-Google-Smtp-Source: ABdhPJwo7ULVR3KFqEbE3GMLnQiSJip5K0UhvKhAF/wnTWAr58zqdIe9cxZRu8SxKfTiY7UhmZmqhGRlD4TJehiV19k=
X-Received: by 2002:a5d:6a41:0:b0:1ed:c1da:6c22 with SMTP id
 t1-20020a5d6a41000000b001edc1da6c22mr19527330wrw.473.1646154002761; Tue, 01
 Mar 2022 09:00:02 -0800 (PST)
MIME-Version: 1.0
References: <20220301060351.442881-1-oupton@google.com> <20220301060351.442881-8-oupton@google.com>
In-Reply-To: <20220301060351.442881-8-oupton@google.com>
From:   David Dunn <daviddunn@google.com>
Date:   Tue, 1 Mar 2022 08:59:51 -0800
Message-ID: <CABOYuvY4WrURGqwzco3zqr8kGjy=08do9R4XFc7Su8GLAGcQcg@mail.gmail.com>
Subject: Re: [PATCH v4 7/8] selftests: KVM: Add test for PERF_GLOBAL_CTRL VMX
 control MSR bits
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: David Dunn <daviddunn@google.com>

See below.

On Mon, Feb 28, 2022 at 10:04 PM Oliver Upton <oupton@google.com> wrote:
>
> +       /*
> +        * Re-enable vPMU in CPUID
> +        */
> +       vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
> +
> +       /*
> +        * Disable the quirk, giving userspace control of the VMX capability
> +        * MSRs.
> +        */
> +       cap.cap = KVM_CAP_DISABLE_QUIRKS2;
> +       cap.args[0] = KVM_X86_QUIRK_TWEAK_VMX_CTRL_MSRS;
> +       vm_enable_cap(vm, &cap);
> +
> +       /*
> +        * Test that userspace can clear these bits, even if it exposes a vPMU
> +        * that supports IA32_PERF_GLOBAL_CTRL.
> +        */
> +       test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_ENTRY_CTLS,
> +                            0,                                         /* set */
> +                            VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL,       /* clear */
> +                            0,                                         /* exp_set */
> +                            VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);      /* exp_clear */
> +       test_vmx_control_msr(vm, MSR_IA32_VMX_TRUE_EXIT_CTLS,
> +                            0,                                         /* set */
> +                            VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL,        /* clear */
> +                            0,                                         /* exp_set */
> +                            VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL);       /* exp_clear */
> +}

Appreciate the formatting change.   Can you also add a test for cpuid
clear while quirk is disabled?

Thanks,

Dave

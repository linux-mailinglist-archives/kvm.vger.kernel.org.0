Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5273E5696B0
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 02:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbiGGACy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 20:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234869AbiGGACv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 20:02:51 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2DD2DA86
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 17:02:50 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id u9so21621293oiv.12
        for <kvm@vger.kernel.org>; Wed, 06 Jul 2022 17:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YvovLjI+2MFhknyBlXTYiwgPOrfCleAGw/VeyGU9pVg=;
        b=fQY7+p+yzvcYYmjVxCnpGqFiI59iCeNjVPuGn81rBXqAFthBboOdzNrmhmh0ZssSdI
         BDHWke+HJ8/rysxVoMu9v+VveqkDbidRl89xhInhO2LUvL9UNf4tSeC+5Mmn1SkllCZm
         bJloHrRHvOtL9okB4Y/URnagnHLqbDVEMNE+Qvvn6EGT8YCBeRIu7B6tgP9vHSAPf/DL
         ft3SYNjzLN0slzmVINlXZbaGIVF8BI/pyWEIoXo1DRruxIB8Nd7gXD34CJoExiIdAXW6
         74af67E6ZMmGC3I8jdLxncgNCHivVgs2ZBfldgdYf1GCJ4uYzzNhS7vz/QDh5hkvajEH
         6Qig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YvovLjI+2MFhknyBlXTYiwgPOrfCleAGw/VeyGU9pVg=;
        b=XpX25zfKVBpTHP0/2HAm1SUjp4sSIo9rAkD7x2sMTdZxB4vy0AFF/Ez3DrX6ENpn+Z
         t/TK7qqmbgXIpjKmffaEzx2SSTCtlOvKpoEN7RbcrU231lB+kNJzf41tb0U8cJzx295w
         RxfuPqR80k6Lz7UdJCMvOJDGEtAG2QQEHbhdXQhxelX+raCTc2HCJ+WRLSePNxKRmrDy
         C53Z/pCKvDmQkOvL5YI/ZF7nu2L24yJAhdhmoQ2b5pFCsI+sXLeWM15kVKEvvbEgRg/8
         EiywUscbQzFRUfz9qrUgNYG0oWgdmjsKQMxtB8X0BuM1iVRakvJz1Uni6BST2azVT5k1
         5QzA==
X-Gm-Message-State: AJIora+KnC2gcXTejxv2siSaLvu5IsVcYf7VIFUUqh1YIfTy6O7ScJ4v
        KwyV+z6Q/G/9DJNtCD3qZqc9ysZo0tYNLcKCipEvqNdDeHs=
X-Google-Smtp-Source: AGRyM1uHK8wI3oqJV/+PFmbtFXWjysExSt41HSgpylcxbnG7188ZLKtNzV8/hGy0ZC20k0r3VUc71F1d4Gq06IJdWlE=
X-Received: by 2002:aca:5e05:0:b0:337:bd43:860b with SMTP id
 s5-20020aca5e05000000b00337bd43860bmr733279oib.181.1657152169444; Wed, 06 Jul
 2022 17:02:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220629025634.666085-1-jmattson@google.com> <CY4PR1101MB22304D870D366B8483E6C9FCEABA9@CY4PR1101MB2230.namprd11.prod.outlook.com>
In-Reply-To: <CY4PR1101MB22304D870D366B8483E6C9FCEABA9@CY4PR1101MB2230.namprd11.prod.outlook.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 6 Jul 2022 17:02:38 -0700
Message-ID: <CALMp9eQv6HKv4-gkpFOTw6A6k3awWcxgiQzyHH_6vLKxWAio8g@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: VMX: Fix the VMX-preemption timer
 expiration test
To:     "Yang, Lixiao" <lixiao.yang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "nadav.amit@gmail.com" <nadav.amit@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 29, 2022 at 7:37 PM Yang, Lixiao <lixiao.yang@intel.com> wrote:
>
> This patch can fix the bug. I tried kvm-unit-tests vmx with your patch ten times on Ice lake and Cooper lake and the failure didn't happen. Thanks Jim!
> -----Original Message-----
> From: Jim Mattson <jmattson@google.com>
> Sent: Wednesday, June 29, 2022 10:57 AM
> To: kvm@vger.kernel.org; pbonzini@redhat.com; Yang, Lixiao <lixiao.yang@intel.com>; nadav.amit@gmail.com
> Cc: Jim Mattson <jmattson@google.com>
> Subject: [kvm-unit-tests PATCH] x86: VMX: Fix the VMX-preemption timer expiration test
>
> When the VMX-preemption timer fires between the test for
> "vmx_get_test_stage() == 0" and the subsequent rdtsc instruction, the final VM-entry to finish the guest will inadvertently update vmx_preemption_timer_expiry_finish.
>
> Move the code to finish the guest until after the calculations involving vmx_preemption_timer_expiry_finish are done, so that it doesn't matter if vmx_preemption_timer_expiry_finish is clobbered.
>
> Signed-off-by: Jim Mattson <jmattson@google.com>

Reported-by: Nadav Amit <nadav.amit@gmail.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>

> Fixes: b49a1a6d4e23 ("x86: VMX: Add a VMX-preemption timer expiration test")
> ---
>  x86/vmx_tests.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c index 4d581e7085ea..8a1393668d93 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -9194,16 +9194,16 @@ static void vmx_preemption_timer_expiry_test(void)
>         reason = (u32)vmcs_read(EXI_REASON);
>         TEST_ASSERT(reason == VMX_PREEMPT);
>
> -       vmcs_clear_bits(PIN_CONTROLS, PIN_PREEMPT);
> -       vmx_set_test_stage(1);
> -       enter_guest();
> -
>         tsc_deadline = ((vmx_preemption_timer_expiry_start >> misc.pt_bit) <<
>                         misc.pt_bit) + (preemption_timer_value << misc.pt_bit);
>
>         report(vmx_preemption_timer_expiry_finish < tsc_deadline,
>                "Last stored guest TSC (%lu) < TSC deadline (%lu)",
>                vmx_preemption_timer_expiry_finish, tsc_deadline);
> +
> +       vmcs_clear_bits(PIN_CONTROLS, PIN_PREEMPT);
> +       vmx_set_test_stage(1);
> +       enter_guest();
>  }
>
>  static void vmx_db_test_guest(void)
> --
> 2.37.0.rc0.161.g10f37bed90-goog
>

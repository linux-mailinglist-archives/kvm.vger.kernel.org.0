Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 788EC5637D9
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 18:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbiGAQ0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 12:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbiGAQ0p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 12:26:45 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A312C4163E
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 09:26:43 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-1048b8a38bbso4122974fac.12
        for <kvm@vger.kernel.org>; Fri, 01 Jul 2022 09:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K26MwrAuUteiZyWEOzDvbm+FiqummBqIOV2xCXu76yM=;
        b=Ixmg3++rgJ8IUJE7we0mxCXtZMmmsiY6hst+fVyftGVwB60OGjmkQodnPu56rSx26x
         AzHgNxP6GiQdmczQ7Bp8/Zni0M9iKk6KvYkBtr8/Ur1zNzuArnrGSaZfQE7+ehh+AqGz
         O7VW/P4YJkz0y6i59iigxbpO10P9ogp7SYgzb7y8uZoZtvG2EQel/v4LgNCfsuAV/v4O
         O8afSWKTcvg0JsuU+fKaxZqdlnTIDaViI8MdxbHcDLUAdLHyneysHfldfmbXen1l8tI5
         o0WMlhmThr7f4GF3lf9xjsTeiEv3tx93rUY/C8Dk19cQ/1/Asy4Rsq/pcnLA6LEsjLNl
         azsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K26MwrAuUteiZyWEOzDvbm+FiqummBqIOV2xCXu76yM=;
        b=vGdqgYppUbnuyhD4/sFh/ukAJy+nL3iVKCaJjvab7Y3FCG506bz3AGdJpZ9BzaPRAk
         aCKjVp3SUE1c9xBckofAC1hSLD52vb4GIf5z5fUNhnEqrAu1aBTcAiEkfoRs9Oet4OVP
         8B6NgOsl6xgwV+3KFPL03aity/BmHKqHoH3yuD8vpIBvkZNBq6AOFHXrgLH+SJ632sHA
         FT8vLbnxaoMPhNRaV6Uv2AktHYTRQDcAJanM0B2pb9rCYGyv7gEfd+A49yJXaefZtltM
         JwYbU7brX/6M9X1hrQ1oV0NFayDNY35M9ybenEUQ9OIgMw4aW8G4Ha1PIUPFAvtXRBtG
         PjwA==
X-Gm-Message-State: AJIora/YRj46Lzo3kjGOqZ0v7xEUwUsFBwKfoHc6BZPIXPZDhtGSyw5p
        6RwS66e7ksiOCjmMSWNdgstagH+pnk0AjTHCsOg/Pw==
X-Google-Smtp-Source: AGRyM1v52Mm1Cwsg5w6e8h2FpdML7f7TtaQZ5JZagakdFptTcCoj3+hl7//M3/+nWSpUjkRcOmP69M304ybLd1p4xuM=
X-Received: by 2002:a05:6870:d3c7:b0:104:9120:8555 with SMTP id
 l7-20020a056870d3c700b0010491208555mr8825797oag.181.1656692802766; Fri, 01
 Jul 2022 09:26:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220629150625.238286-1-vkuznets@redhat.com> <20220629150625.238286-24-vkuznets@redhat.com>
In-Reply-To: <20220629150625.238286-24-vkuznets@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 1 Jul 2022 09:26:31 -0700
Message-ID: <CALMp9eTmRLHQej1a4bFtpmRxaLaEJfwpDdvcZGbR54PFRjx+6g@mail.gmail.com>
Subject: Re: [PATCH v2 23/28] KVM: VMX: Move LOAD_IA32_PERF_GLOBAL_CTRL errata
 handling out of setup_vmcs_config()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 29, 2022 at 8:07 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> As a preparation to reusing the result of setup_vmcs_config() for setting
> up nested VMX control MSRs, move LOAD_IA32_PERF_GLOBAL_CTRL errata handling
> to vmx_vmexit_ctrl()/vmx_vmentry_ctrl() and print the warning from
> hardware_setup(). While it seems reasonable to not expose
> LOAD_IA32_PERF_GLOBAL_CTRL controls to L1 hypervisor on buggy CPUs,
> such change would inevitably break live migration from older KVMs
> where the controls are exposed. Keep the status quo for know, L1 hypervisor
> itself is supposed to take care of the errata.

It can only do that if L1 doesn't lie about the model. This is why
F/M/S checks are, in general, evil.

> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 62 ++++++++++++++++++++++++++----------------
>  1 file changed, 38 insertions(+), 24 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index fb58b0be953d..5f7ef1f8d2c6 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2416,6 +2416,31 @@ static bool cpu_has_sgx(void)
>         return cpuid_eax(0) >= 0x12 && (cpuid_eax(0x12) & BIT(0));
>  }
>
> +/*
> + * Some cpus support VM_{ENTRY,EXIT}_IA32_PERF_GLOBAL_CTRL but they
> + * can't be used due to an errata where VM Exit may incorrectly clear

Nit: erratum (singular), or drop the 'an' to refer to errata (plural).

> + * IA32_PERF_GLOBAL_CTRL[34:32].  Workaround the errata by using the

Nit: workaround (one word) is a noun. The verb form is "work around."

> + * MSR load mechanism to switch IA32_PERF_GLOBAL_CTRL.
> + */
> +static bool cpu_has_perf_global_ctrl_bug(void)
> +{
> +       if (boot_cpu_data.x86 == 0x6) {
> +               switch (boot_cpu_data.x86_model) {
> +               case 26: /* AAK155 */
> +               case 30: /* AAP115 */
> +               case 37: /* AAT100 */
> +               case 44: /* BC86,AAY89,BD102 */
> +               case 46: /* BA97 */

Nit: Replace decimal model numbers with mnemonics. See
https://lore.kernel.org/kvm/20220629222221.986645-1-jmattson@google.com/.

> +                       return true;
> +               default:
> +                       break;
> +               }
> +       }
> +
> +       return false;
> +}

Is it worth either (a) memoizing the result, or (b) toggling a static
branch? Or am I prematurely optimizing?

> +
> +
>  static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
>                                       u32 msr, u32 *result)
>  {
> @@ -2572,30 +2597,6 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>                 _vmexit_control &= ~x_ctrl;
>         }
>
> -       /*
> -        * Some cpus support VM_{ENTRY,EXIT}_IA32_PERF_GLOBAL_CTRL but they
> -        * can't be used due to an errata where VM Exit may incorrectly clear
> -        * IA32_PERF_GLOBAL_CTRL[34:32].  Workaround the errata by using the
> -        * MSR load mechanism to switch IA32_PERF_GLOBAL_CTRL.
> -        */
> -       if (boot_cpu_data.x86 == 0x6) {
> -               switch (boot_cpu_data.x86_model) {
> -               case 26: /* AAK155 */
> -               case 30: /* AAP115 */
> -               case 37: /* AAT100 */
> -               case 44: /* BC86,AAY89,BD102 */
> -               case 46: /* BA97 */
> -                       _vmentry_control &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
> -                       _vmexit_control &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
> -                       pr_warn_once("kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL "
> -                                       "does not work properly. Using workaround\n");
> -                       break;
> -               default:
> -                       break;
> -               }
> -       }
> -
> -
>         rdmsr(MSR_IA32_VMX_BASIC, vmx_msr_low, vmx_msr_high);
>
>         /* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
> @@ -4188,6 +4189,10 @@ static u32 vmx_vmentry_ctrl(void)
>                           VM_ENTRY_LOAD_IA32_EFER |
>                           VM_ENTRY_IA32E_MODE);
>
> +
> +       if (cpu_has_perf_global_ctrl_bug())
> +               vmentry_ctrl &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
> +
>         return vmentry_ctrl;
>  }
>
> @@ -4202,6 +4207,10 @@ static u32 vmx_vmexit_ctrl(void)
>         if (vmx_pt_mode_is_system())
>                 vmexit_ctrl &= ~(VM_EXIT_PT_CONCEAL_PIP |
>                                  VM_EXIT_CLEAR_IA32_RTIT_CTL);
> +
> +       if (cpu_has_perf_global_ctrl_bug())
> +               vmexit_ctrl &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
> +
>         /* Loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically */
>         return vmexit_ctrl &
>                 ~(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | VM_EXIT_LOAD_IA32_EFER);
> @@ -8117,6 +8126,11 @@ static __init int hardware_setup(void)
>         if (setup_vmcs_config(&vmcs_config, &vmx_capability) < 0)
>                 return -EIO;
>
> +       if (cpu_has_perf_global_ctrl_bug()) {
> +               pr_warn_once("kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL "
> +                            "does not work properly. Using workaround\n");
> +       }
> +
>         if (boot_cpu_has(X86_FEATURE_NX))
>                 kvm_enable_efer_bits(EFER_NX);
>
> --
> 2.35.3
>

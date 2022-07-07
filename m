Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04E0A56A1BF
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 14:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235670AbiGGMHi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 08:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235547AbiGGMHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 08:07:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A461E59251
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 05:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657195649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jMnXIdRVj9xX5STOZn22YQuc1w+ikq3NveF4l3Jb/M4=;
        b=h1AMwnTE48sujr2jWOehzD0RA1jAeC5PKT6RbjbNTD7hc5VmOjq41CK5K8981advDXuIsE
        NrShOKrsJ3pwKYcL8onlSW2y4nJ8QzwGfT4fSx7J99cjhyXG0YhJTbkpbJ/Qqi0cYVfmLd
        4+9wtxBdw2nbcz/dJo08KAJBd25z/tc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-SaXITQxIO2mZH17giz0Asg-1; Thu, 07 Jul 2022 08:07:27 -0400
X-MC-Unique: SaXITQxIO2mZH17giz0Asg-1
Received: by mail-wr1-f71.google.com with SMTP id e6-20020adfc846000000b0021d2af9adb6so3228776wrh.18
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 05:07:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=jMnXIdRVj9xX5STOZn22YQuc1w+ikq3NveF4l3Jb/M4=;
        b=dZKOZb04Mo1qhu72JuvJxIcualEVXNgxKSC2sQp+rQcMdSDYER5GiB2rPzNYAEEbrr
         rQxqyJN6zQgDF/cgpwPR4yUXa8603DDvddFjG6XyXF/+hzH2yPadqVVP6k59cnqAqHht
         3stHdCO4CiFkA5sJyrGBtT7toU4rLR9KJuyLzdzRIgHPhlj+Fdb00ase60d1UzTCk40a
         WrK5I5HhQFwxUmUPQxsTRM4IcnBi8QaTycmoCgSr5fOOtAUXxS2W4f0wfHn/GgBuqp5J
         5jV5FrPCJwMbINZvJkI9RM2xsvonmZC7ttgK47/penRc6cWH2RrSOiQVZE21MoKzDECs
         VbUw==
X-Gm-Message-State: AJIora8RX/KG5j73wfNUc6SldxyJ5ukxoVxSORwdms5F4x2S1SXdKfgM
        txoQlfsMa/cZ+1ooWSCRYmrBdvoG0hehczHU3DiEvROiFiQXhejJJsYlx6OTEX4xLo6ZKNCXMzO
        MaB7RCM1emj5E
X-Received: by 2002:a5d:4a0c:0:b0:21d:78c9:c5d3 with SMTP id m12-20020a5d4a0c000000b0021d78c9c5d3mr10082810wrq.42.1657195646122;
        Thu, 07 Jul 2022 05:07:26 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sb6YR+AZvHPC1LZE6NOAnLCM5dwuK/Rh6oo+GJqoNIUt6jQDe9CiVQ3QNB9El7KfK4hqsubA==
X-Received: by 2002:a5d:4a0c:0:b0:21d:78c9:c5d3 with SMTP id m12-20020a5d4a0c000000b0021d78c9c5d3mr10082785wrq.42.1657195645809;
        Thu, 07 Jul 2022 05:07:25 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y10-20020adff6ca000000b0021d6e758752sm8847904wrp.24.2022.07.07.05.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 05:07:25 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 23/28] KVM: VMX: Move LOAD_IA32_PERF_GLOBAL_CTRL
 errata handling out of setup_vmcs_config()
In-Reply-To: <CALMp9eTmRLHQej1a4bFtpmRxaLaEJfwpDdvcZGbR54PFRjx+6g@mail.gmail.com>
References: <20220629150625.238286-1-vkuznets@redhat.com>
 <20220629150625.238286-24-vkuznets@redhat.com>
 <CALMp9eTmRLHQej1a4bFtpmRxaLaEJfwpDdvcZGbR54PFRjx+6g@mail.gmail.com>
Date:   Thu, 07 Jul 2022 14:07:24 +0200
Message-ID: <8735fdqg77.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> On Wed, Jun 29, 2022 at 8:07 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>
>> As a preparation to reusing the result of setup_vmcs_config() for setting
>> up nested VMX control MSRs, move LOAD_IA32_PERF_GLOBAL_CTRL errata handling
>> to vmx_vmexit_ctrl()/vmx_vmentry_ctrl() and print the warning from
>> hardware_setup(). While it seems reasonable to not expose
>> LOAD_IA32_PERF_GLOBAL_CTRL controls to L1 hypervisor on buggy CPUs,
>> such change would inevitably break live migration from older KVMs
>> where the controls are exposed. Keep the status quo for know, L1 hypervisor
>> itself is supposed to take care of the errata.
>
> It can only do that if L1 doesn't lie about the model. This is why
> F/M/S checks are, in general, evil.
>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/x86/kvm/vmx/vmx.c | 62 ++++++++++++++++++++++++++----------------
>>  1 file changed, 38 insertions(+), 24 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index fb58b0be953d..5f7ef1f8d2c6 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -2416,6 +2416,31 @@ static bool cpu_has_sgx(void)
>>         return cpuid_eax(0) >= 0x12 && (cpuid_eax(0x12) & BIT(0));
>>  }
>>
>> +/*
>> + * Some cpus support VM_{ENTRY,EXIT}_IA32_PERF_GLOBAL_CTRL but they
>> + * can't be used due to an errata where VM Exit may incorrectly clear
>
> Nit: erratum (singular), or drop the 'an' to refer to errata (plural).
>
>> + * IA32_PERF_GLOBAL_CTRL[34:32].  Workaround the errata by using the
>
> Nit: workaround (one word) is a noun. The verb form is "work around."
>

Sure, but I'm not exactly certain which commit to blame here as I have
options:

Fixes: 8bf00a529967 ("KVM: VMX: add support for switching of PERF_GLOBAL_CTRL")
where it was introduced or

Fixes: bb3541f175a9 ("KVM: x86: Fix typos")
Fixes: c73da3fcab43 ("KVM: VMX: Properly handle dynamic VM Entry/Exit controls")

where it was preserved :-)

>> + * MSR load mechanism to switch IA32_PERF_GLOBAL_CTRL.
>> + */
>> +static bool cpu_has_perf_global_ctrl_bug(void)
>> +{
>> +       if (boot_cpu_data.x86 == 0x6) {
>> +               switch (boot_cpu_data.x86_model) {
>> +               case 26: /* AAK155 */
>> +               case 30: /* AAP115 */
>> +               case 37: /* AAT100 */
>> +               case 44: /* BC86,AAY89,BD102 */
>> +               case 46: /* BA97 */
>
> Nit: Replace decimal model numbers with mnemonics. See
> https://lore.kernel.org/kvm/20220629222221.986645-1-jmattson@google.com/.
>

I'm going to steal your patch and put it to my series (as I don't see it
in kvm/queue yet).

>> +                       return true;
>> +               default:
>> +                       break;
>> +               }
>> +       }
>> +
>> +       return false;
>> +}
>
> Is it worth either (a) memoizing the result, or (b) toggling a static
> branch? Or am I prematurely optimizing?
>

(Unless I missed something) besides hardware_setup(),
cpu_has_perf_global_ctrl_bug() is only called (twice) from:

vmx_vcpu_reset()
	__vmx_vcpu_reset()
		init_vmcs()
			vmx_vmentry_ctrl()
			vmx_vmexit_ctrl()

this shouldn't happen very often so I guess we can leave it
un-optimized. Also, we're only reading boot_cpu_data.x86/
boot_cpu_data.x86_model here, this should be cheap).

>> +
>> +
>>  static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
>>                                       u32 msr, u32 *result)
>>  {
>> @@ -2572,30 +2597,6 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>>                 _vmexit_control &= ~x_ctrl;
>>         }
>>
>> -       /*
>> -        * Some cpus support VM_{ENTRY,EXIT}_IA32_PERF_GLOBAL_CTRL but they
>> -        * can't be used due to an errata where VM Exit may incorrectly clear
>> -        * IA32_PERF_GLOBAL_CTRL[34:32].  Workaround the errata by using the
>> -        * MSR load mechanism to switch IA32_PERF_GLOBAL_CTRL.
>> -        */
>> -       if (boot_cpu_data.x86 == 0x6) {
>> -               switch (boot_cpu_data.x86_model) {
>> -               case 26: /* AAK155 */
>> -               case 30: /* AAP115 */
>> -               case 37: /* AAT100 */
>> -               case 44: /* BC86,AAY89,BD102 */
>> -               case 46: /* BA97 */
>> -                       _vmentry_control &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
>> -                       _vmexit_control &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
>> -                       pr_warn_once("kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL "
>> -                                       "does not work properly. Using workaround\n");
>> -                       break;
>> -               default:
>> -                       break;
>> -               }
>> -       }
>> -
>> -
>>         rdmsr(MSR_IA32_VMX_BASIC, vmx_msr_low, vmx_msr_high);
>>
>>         /* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
>> @@ -4188,6 +4189,10 @@ static u32 vmx_vmentry_ctrl(void)
>>                           VM_ENTRY_LOAD_IA32_EFER |
>>                           VM_ENTRY_IA32E_MODE);
>>
>> +
>> +       if (cpu_has_perf_global_ctrl_bug())
>> +               vmentry_ctrl &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
>> +
>>         return vmentry_ctrl;
>>  }
>>
>> @@ -4202,6 +4207,10 @@ static u32 vmx_vmexit_ctrl(void)
>>         if (vmx_pt_mode_is_system())
>>                 vmexit_ctrl &= ~(VM_EXIT_PT_CONCEAL_PIP |
>>                                  VM_EXIT_CLEAR_IA32_RTIT_CTL);
>> +
>> +       if (cpu_has_perf_global_ctrl_bug())
>> +               vmexit_ctrl &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
>> +
>>         /* Loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically */
>>         return vmexit_ctrl &
>>                 ~(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | VM_EXIT_LOAD_IA32_EFER);
>> @@ -8117,6 +8126,11 @@ static __init int hardware_setup(void)
>>         if (setup_vmcs_config(&vmcs_config, &vmx_capability) < 0)
>>                 return -EIO;
>>
>> +       if (cpu_has_perf_global_ctrl_bug()) {
>> +               pr_warn_once("kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL "
>> +                            "does not work properly. Using workaround\n");
>> +       }
>> +
>>         if (boot_cpu_has(X86_FEATURE_NX))
>>                 kvm_enable_efer_bits(EFER_NX);
>>
>> --
>> 2.35.3
>>
>

-- 
Vitaly


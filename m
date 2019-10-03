Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0F6CAB61
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 19:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389572AbfJCRUv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 13:20:51 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45962 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391455AbfJCRUu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 13:20:50 -0400
Received: by mail-io1-f65.google.com with SMTP id c25so7289772iot.12
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2019 10:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ROjHpOzRZ1zg7WsRiQrsstI6c6vwOIlKKBBg25nDNqk=;
        b=D0335bC8HZS3gKgpq9/MbcCeRnChpkvTNsagSyEn+nX4Q66b/GjQa+jGa9VLRijhdp
         +4/K9Xg0Y7HYA9njZsMwMHuWibsQjQplH/6OqiU61hWQkDwovpFzOc3vX4RSV+onmoFU
         fuOmeep+KClIz8DgBwxcYEUZAADoyGsGTjAAJrTFOS2aDEfXnY6UeJUBwxB7pYvaKfuA
         ccIQNpadl8Bg6CmlpzaRIKH0JtcRMCYEfpaGnTi1mJEsfEVKeFJsahJ6HOyyiQLEMRYP
         S9sRthmJeuN/dM72n/06mzHCc/HGiDGvfjUK3EoE2KcEr53m4Wkf4JVgVjuxJAguKgqz
         HHDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ROjHpOzRZ1zg7WsRiQrsstI6c6vwOIlKKBBg25nDNqk=;
        b=P2LVOJat4FuHn6B8infp7Zrg0BVOnRzEX0VaoiZnxSjSnNatsHxJDI3G0/Xcsa/u8W
         v8irqe4sO09CYlN/cZ0hxTxwMLucaKhuK+patZMBCPkBzEf3Zj/EDzZil1l3V3JtP+Rc
         E+sHnJo46ZYWBM3tOHE5KvFWJaYE5ShXHKz8IWYAPBBpJurvFCynLvGnkp5bgeOqXSaS
         bDi0gJGkoDyPjJv0WOYcTNWjOPErAvpib7PcFkcaJegT2CitCtGCsHkeUnsHToXOJHyk
         6rbs6h8kFrJAHvyd3qvbxD1/BxcSeJzO3wEtvYyWteiLvS8z2kSUzagskKLwefNehs1S
         AwyA==
X-Gm-Message-State: APjAAAU/BUsThT/MPqUhkZ3UgFFZf2nWCTyln26FGQGnPIRfcE5hvIZL
        h8Sn9pFRMXdK67auNd0M+XpCJJ0XcjijihQ0nL0zbw==
X-Google-Smtp-Source: APXvYqzL90yczrm6KgnTH/j6j0Ki2GG5BtxT9O9oxONR7BoG3dTFpzTDIl8D91aHq8CRqKKtzfaEeKbF7TDeeU5YvrY=
X-Received: by 2002:a02:ba17:: with SMTP id z23mr10366196jan.24.1570123249112;
 Thu, 03 Oct 2019 10:20:49 -0700 (PDT)
MIME-Version: 1.0
References: <1570097418-42233-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1570097418-42233-1-git-send-email-pbonzini@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 3 Oct 2019 10:20:38 -0700
Message-ID: <CALMp9eRFUeSB035VEC61CzAg6PY=aApjyiQoSnRydH788COL4w@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: omit absent pmu MSRs from MSR list
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 3, 2019 at 3:10 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> INTEL_PMC_MAX_GENERIC is currently 32, which exceeds the 18 contiguous
> MSR indices reserved by Intel for event selectors.  Since some machines
> actually have MSRs past the reserved range, these may survive the
Not past, but *within* the reserved range.
> filtering of msrs_to_save array and would be rejected by KVM_GET/SET_MSR.
> To avoid this, cut the list to whatever CPUID reports for the host's
> architectural PMU.
>
> Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Jim Mattson <jmattson@google.com>
> Fixes: e2ada66ec418 ("kvm: x86: Add Intel PMU MSRs to msrs_to_save[]", 2019-08-21)
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8072acaaf028..31607174f442 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5105,13 +5105,14 @@ long kvm_arch_vm_ioctl(struct file *filp,
>
>  static void kvm_init_msr_list(void)
>  {
> +       struct x86_pmu_capability x86_pmu;
>         u32 dummy[2];
>         unsigned i, j;
>
>         BUILD_BUG_ON_MSG(INTEL_PMC_MAX_FIXED != 4,
>                          "Please update the fixed PMCs in msrs_to_save[]");
> -       BUILD_BUG_ON_MSG(INTEL_PMC_MAX_GENERIC != 32,
> -                        "Please update the generic perfctr/eventsel MSRs in msrs_to_save[]");
> +
> +       perf_get_x86_pmu_capability(&x86_pmu);
>
>         for (i = j = 0; i < ARRAY_SIZE(msrs_to_save); i++) {
>                 if (rdmsr_safe(msrs_to_save[i], &dummy[0], &dummy[1]) < 0)
> @@ -5153,6 +5154,15 @@ static void kvm_init_msr_list(void)
>                                 intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2)
>                                 continue;
>                         break;
> +               case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 31:
You've truncated the list I originally provided, so I think this need
only go to MSR_ARCH_PERFMON_PERFCTR0 + 17. Otherwise, we could lose
some valuable MSRs.
> +                       if (msrs_to_save[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
> +                           min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
Why involve INTEL_PMC_MAX_GENERIC here?
> +                               continue;
> +                       break;
> +               case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 31:
Same as the two comments above.
> +                       if (msrs_to_save[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
> +                           min(INTEL_PMC_MAX_GENERIC, x86_pmu.num_counters_gp))
> +                               continue;
>                 }
>                 default:
>                         break;
> --
> 1.8.3.1
>

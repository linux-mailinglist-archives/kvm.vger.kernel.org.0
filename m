Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A605C674738
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 00:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjASX20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 18:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjASX2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 18:28:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E981459CF
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 15:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674170854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lK46v5eAPXF/qW2eO/0FMKlUZTFHVcHNsRlI1j4r9bM=;
        b=VtIVZL/m0PtsuaT0Zz5ssb1VhHO9jiU8Ey2syc2FzSWyBSP96S2/+fXbYevuCgtv49i3Ch
        87+Jv5C8u1hRyTKq/gTLEylPyFjbrBa1LyMo2vFIHjZD4GsfmC329zh7F4R4f2Hc4DauKx
        mPOGhLpzfaCZCT/Zt3LHT1OCC9+xb2U=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-634-g6P0NYiZMSefI0-kffStiw-1; Thu, 19 Jan 2023 18:27:33 -0500
X-MC-Unique: g6P0NYiZMSefI0-kffStiw-1
Received: by mail-ua1-f72.google.com with SMTP id p44-20020a9f382f000000b0060ae73237b3so1033733uad.14
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 15:27:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lK46v5eAPXF/qW2eO/0FMKlUZTFHVcHNsRlI1j4r9bM=;
        b=zPXQpLvEwNsaen3KYVE4DaqiDm5SWy+N54pgeUFAwFnJLLjjJjpR2YXFa2L6W+0DyD
         QW3J6JgpiCCILlBpPg63VXo64AMd3Safa0yt/b5Rls3mrU6bOE+6c2FjmYu6ruJrdc9k
         PeySUbQu85Slb14ZIfkfCXoTqk8Z+cM5JUgBOKchSxddCMjUS7Pr7Vc7N6L8Xq4eiqyh
         jEXkW1x7RsbUZ67WzV3CPNvaDbCGO4n0qTvkOd8NiGgw2S21i4EYfWOFXQ3ZZUkKlIIT
         Q/0dZMzuLbOdPqNXPXwTQLzBiH1FosqhUDb1bwjC5+rNn6aJZI9CjsGEs9CEb7s3FsGJ
         VenA==
X-Gm-Message-State: AFqh2kob+x32jpSPanZc/xI1QLMRKNoc7vmhn2kShPQst5tIfs4N7jri
        u4bt4rpRp7UT+B35bNSf4B3OYrNGX/JqepJFg907/aBMCCZf4VmWWfGaUKcn2FXQjIJ0Xkn990E
        m0+5Cl6jI5kOL8ZsCyE62w9YFrDts
X-Received: by 2002:a05:6102:91c:b0:3b3:10b1:8e64 with SMTP id x28-20020a056102091c00b003b310b18e64mr1832066vsh.42.1674170851971;
        Thu, 19 Jan 2023 15:27:31 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvOBZUTj4ondgih/x9blxbKrAlZkKGp8d9qr2m0M8nsSjIAkKhYXamVL/vI87vMmm90QZ1ceUJIHgwVhwBxlu0=
X-Received: by 2002:a05:6102:91c:b0:3b3:10b1:8e64 with SMTP id
 x28-20020a056102091c00b003b310b18e64mr1832063vsh.42.1674170851674; Thu, 19
 Jan 2023 15:27:31 -0800 (PST)
MIME-Version: 1.0
References: <20230118142123.461247-1-aharivel@redhat.com>
In-Reply-To: <20230118142123.461247-1-aharivel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 20 Jan 2023 00:27:18 +0100
Message-ID: <CABgObfZdvd-=cqQ1aLVsJNuBd830=GJW+PMj1iaq7yMa2Za_7w@mail.gmail.com>
Subject: Re: [RFC] KVM: x86: Give host userspace control for
 MSR_RAPL_POWER_UNIT and MSR_PKG_POWER_STATUS
To:     Anthony Harivel <aharivel@redhat.com>
Cc:     kvm@vger.kernel.org, rjarry@redhat.com,
        Christophe Fontaine <cfontain@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 18, 2023 at 3:21 PM Anthony Harivel <aharivel@redhat.com> wrote=
:
>
> Allow userspace to update the MSR_RAPL_POWER_UNIT and
> MSR_PKG_POWER_STATUS powercap registers. By default, these MSRs still
> return 0.
>
> This enables VMMs running on top of KVM with access to energy metrics
> like /sys/devices/virtual/powercap/*/*/energy_uj to compute VMs power
> values in proportion with other metrics (e.g. CPU %guest, steal time,
> etc.) and periodically update the MSRs with ioctl KVM_SET_MSRS so that
> the guest OS can consume them using power metering tools.

Do you have a QEMU prototype patch? My gut feeling is that these MSRs
should be handled entirely within KVM using the sched_in and sched_out
notifiers. This would also allow exposing the values to the host using
the statistics subsystem.

Paolo

> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Christophe Fontaine <cfontain@redhat.com>
> Signed-off-by: Anthony Harivel <aharivel@redhat.com>
> ---
>
> Notes:
>     The main goal of this patch is to bring a first step to give energy
>     awareness to VMs.
>
>     As of today, KVM always report 0 in these MSRs since the entire host
>     power consumption needs to be hidden from the guests. However, there =
is
>     no fallback mechanism for VMs to measure their power usage.
>
>     The idea is to let the VMMs running on top of KVM periodically update
>     those MSRs with representative values of the VM's power consumption.
>
>     If this solution is accepted, VMMs like QEMU will need to be patched =
to
>     set proper values in these registers and enable power metering in
>     guests.
>
>     I am submitting this as an RFC to get input/feedback from a broader
>     audience who may be aware of potential side effects of such a mechani=
sm.
>
>     Regards,
>     Anthony
>
>     "If you can=E2=80=99t measure it, you can=E2=80=99t improve it." =E2=
=80=93 Lord Kelvin
>
>  arch/x86/include/asm/kvm_host.h |  4 ++++
>  arch/x86/kvm/x86.c              | 18 ++++++++++++++++--
>  2 files changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 6aaae18f1854..c6072915f229 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1006,6 +1006,10 @@ struct kvm_vcpu_arch {
>          */
>         bool pdptrs_from_userspace;
>
> +       /* Powercap related MSRs */
> +       u64 msr_rapl_power_unit;
> +       u64 msr_pkg_energy_status;
> +
>  #if IS_ENABLED(CONFIG_HYPERV)
>         hpa_t hv_root_tdp;
>  #endif
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index da4bbd043a7b..adc89144f84f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1528,6 +1528,10 @@ static const u32 emulated_msrs_all[] =3D {
>
>         MSR_K7_HWCR,
>         MSR_KVM_POLL_CONTROL,
> +
> +       /* The following MSRs can be updated by the userspace */
> +       MSR_RAPL_POWER_UNIT,
> +       MSR_PKG_ENERGY_STATUS,
>  };
>
>  static u32 emulated_msrs[ARRAY_SIZE(emulated_msrs_all)];
> @@ -3888,6 +3892,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, stru=
ct msr_data *msr_info)
>                  * as to-be-saved, even if an MSRs isn't fully supported.
>                  */
>                 return !msr_info->host_initiated || data;
> +       case MSR_RAPL_POWER_UNIT:
> +               vcpu->arch.msr_rapl_power_unit =3D data;
> +               break;
> +       case MSR_PKG_ENERGY_STATUS:
> +               vcpu->arch.msr_pkg_energy_status =3D data;
> +               break;
>         default:
>                 if (kvm_pmu_is_valid_msr(vcpu, msr))
>                         return kvm_pmu_set_msr(vcpu, msr_info);
> @@ -3973,13 +3983,17 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, str=
uct msr_data *msr_info)
>          * data here. Do not conditionalize this on CPUID, as KVM does no=
t do
>          * so for existing CPU-specific MSRs.
>          */
> -       case MSR_RAPL_POWER_UNIT:
>         case MSR_PP0_ENERGY_STATUS:     /* Power plane 0 (core) */
>         case MSR_PP1_ENERGY_STATUS:     /* Power plane 1 (graphics uncore=
) */
> -       case MSR_PKG_ENERGY_STATUS:     /* Total package */
>         case MSR_DRAM_ENERGY_STATUS:    /* DRAM controller */
>                 msr_info->data =3D 0;
>                 break;
> +       case MSR_RAPL_POWER_UNIT:
> +               msr_info->data =3D vcpu->arch.msr_rapl_power_unit;
> +               break;
> +       case MSR_PKG_ENERGY_STATUS:     /* Total package */
> +               msr_info->data =3D vcpu->arch.msr_pkg_energy_status;
> +               break;
>         case MSR_IA32_PEBS_ENABLE:
>         case MSR_IA32_DS_AREA:
>         case MSR_PEBS_DATA_CFG:
> --
> 2.39.0
>


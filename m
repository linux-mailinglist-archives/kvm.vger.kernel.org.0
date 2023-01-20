Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129CD675A68
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 17:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjATQsp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 11:48:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjATQso (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 11:48:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E41270297
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 08:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674233278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=deisCd2W8SFhmr3e9Cu0vdIsk723FC9FGGLHQN3cILw=;
        b=Zj6mtSZB56OY1IXWbKVutV0lqoeva7IaSPnaxjadCLweAtcNYlBJhMT1Ki9WYUCWf0Gsw9
        44CR44JLRJm+wALjWx70by9pUT2INHwLCaBWwGzBGgmcxImkXXSAlI0khyNCkhHu6clJjm
        nHScPKt/STXEMT+B2oVUQ8d35wTzOAU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-355-jDwI3jexNp2Wdlk7PH9tAA-1; Fri, 20 Jan 2023 11:47:56 -0500
X-MC-Unique: jDwI3jexNp2Wdlk7PH9tAA-1
Received: by mail-wr1-f69.google.com with SMTP id v12-20020a5d590c000000b002bf9614f379so127223wrd.4
        for <kvm@vger.kernel.org>; Fri, 20 Jan 2023 08:47:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=deisCd2W8SFhmr3e9Cu0vdIsk723FC9FGGLHQN3cILw=;
        b=XgrQwVes6x4dNg2HsKy9C4Is25uv8WwmIcI47GQBwXVj66dmdLEVf6/6idX+W/ZQXb
         HgK9xdSh2PT827IYGfEns/ksYWUwqgeVZ9ZtLM93nU3/ydWp9LqXAOCy0dwLyyhqTPeH
         FqghpBSiUu6e8BBfjogBDBy1IxUdgJGmG+pGpSgMPeRw3uP3HgBPDR09PWvoqt67fPt/
         tOCzKDg/PMCoyLtKOtsohTc4h0+Lz+xFkK8Qkjgln4BD/3kRfdvAqxK/jyJwtsRTPFXR
         qogqRuW32XUgAXcXMk85Lkj521eAVyZNYhmNdzwR7QPpwrO7njrZZ3jTjKZXwvRrWCD+
         JmjQ==
X-Gm-Message-State: AFqh2kqI4OGbOMxc8/ST4WfBDQBmaTMVkN+HsM5LIhBdF94qJ40NPvvR
        wz5cBfGAeDh1FoYhojyHPlPUzeHmj3uKXGinLp4FdSnZBhMuYQ2EMZsNgxDMmElO2WJ6jC2hfqw
        WenNSzbEzP6Zt
X-Received: by 2002:adf:f4ca:0:b0:250:779a:7391 with SMTP id h10-20020adff4ca000000b00250779a7391mr13598804wrp.47.1674233275284;
        Fri, 20 Jan 2023 08:47:55 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuj8jKgiqRuE1cMBQCB2JAUvAViz6HwxsVH4Ft4u0DgTPhgxiKy9bGqcSxlDWxtlnE1LNe+yg==
X-Received: by 2002:adf:f4ca:0:b0:250:779a:7391 with SMTP id h10-20020adff4ca000000b00250779a7391mr13598794wrp.47.1674233275040;
        Fri, 20 Jan 2023 08:47:55 -0800 (PST)
Received: from localhost ([2a01:e0a:a9a:c460:ada2:6df5:d1b0:21e])
        by smtp.gmail.com with ESMTPSA id q11-20020a05600000cb00b002be53aa2260sm2599479wrx.117.2023.01.20.08.47.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 08:47:54 -0800 (PST)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 20 Jan 2023 17:47:54 +0100
Message-Id: <CPX65W5M0LSW.17ZS900QMBZLL@fedora>
From:   "Anthony Harivel" <aharivel@redhat.com>
To:     "Paolo Bonzini" <pbonzini@redhat.com>
Cc:     <kvm@vger.kernel.org>, <rjarry@redhat.com>,
        "Christophe Fontaine" <cfontain@redhat.com>, <xiaoyao.li@intel.com>
Subject: Re: [RFC] KVM: x86: Give host userspace control for
 MSR_RAPL_POWER_UNIT and MSR_PKG_POWER_STATUS
X-Mailer: aerc 0.13.0-123-g2937830491b5
References: <20230118142123.461247-1-aharivel@redhat.com>
 <CABgObfZdvd-=cqQ1aLVsJNuBd830=GJW+PMj1iaq7yMa2Za_7w@mail.gmail.com>
In-Reply-To: <CABgObfZdvd-=cqQ1aLVsJNuBd830=GJW+PMj1iaq7yMa2Za_7w@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


After a second though and further tests with ftrace backend activated,
if we update those MSRs in VMM (Qemu in my context) with
a KVM_X86_SET_MSR_FILTER, each time we will read the value we will go
through the following KVM exit:

kvm_userspace_exit: reason KVM_EXIT_X86_RDMSR (29)

Because some various MSRs (i.e MSR_{PKG,PP0,PP1}_ENERGY_STATUS) being
counters (of uJoules), their values must be update regularly to make
sens for the Power tools.

So I'm wondering if the contexts switching (KVM->userpace->KVM) to
update all MSRs will cause performance issues?

> Do you have a QEMU prototype patch? My gut feeling is that these MSRs
> should be handled entirely within KVM using the sched_in and sched_out
> notifiers. This would also allow exposing the values to the host using
> the statistics subsystem.
>
> Paolo
>

I did some Qemu hack with Qtimer to update the values regularly but I'm
definitely not satisfied with the implementation.

What I'm pretty sure is that updating the values should be done
separately from the callback that consume the value. This would ensure
the consistency of the values.

In the hypothesis those MSRs are handled within KVM, we can read MSRs
with rdmsrl_safe() but how can we get the percentage of CPU used by Qemu
to get a proportional value of the counter?

Regards,
Anthony

> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Christophe Fontaine <cfontain@redhat.com>
> > Signed-off-by: Anthony Harivel <aharivel@redhat.com>
> > ---
> >
> > Notes:
> >     The main goal of this patch is to bring a first step to give energy
> >     awareness to VMs.
> >
> >     As of today, KVM always report 0 in these MSRs since the entire hos=
t
> >     power consumption needs to be hidden from the guests. However, ther=
e is
> >     no fallback mechanism for VMs to measure their power usage.
> >
> >     The idea is to let the VMMs running on top of KVM periodically upda=
te
> >     those MSRs with representative values of the VM's power consumption=
.
> >
> >     If this solution is accepted, VMMs like QEMU will need to be patche=
d to
> >     set proper values in these registers and enable power metering in
> >     guests.
> >
> >     I am submitting this as an RFC to get input/feedback from a broader
> >     audience who may be aware of potential side effects of such a mecha=
nism.
> >
> >     Regards,
> >     Anthony
> >
> >     "If you can=E2=80=99t measure it, you can=E2=80=99t improve it." =
=E2=80=93 Lord Kelvin
> >
> >  arch/x86/include/asm/kvm_host.h |  4 ++++
> >  arch/x86/kvm/x86.c              | 18 ++++++++++++++++--
> >  2 files changed, 20 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index 6aaae18f1854..c6072915f229 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1006,6 +1006,10 @@ struct kvm_vcpu_arch {
> >          */
> >         bool pdptrs_from_userspace;
> >
> > +       /* Powercap related MSRs */
> > +       u64 msr_rapl_power_unit;
> > +       u64 msr_pkg_energy_status;
> > +
> >  #if IS_ENABLED(CONFIG_HYPERV)
> >         hpa_t hv_root_tdp;
> >  #endif
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index da4bbd043a7b..adc89144f84f 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1528,6 +1528,10 @@ static const u32 emulated_msrs_all[] =3D {
> >
> >         MSR_K7_HWCR,
> >         MSR_KVM_POLL_CONTROL,
> > +
> > +       /* The following MSRs can be updated by the userspace */
> > +       MSR_RAPL_POWER_UNIT,
> > +       MSR_PKG_ENERGY_STATUS,
> >  };
> >
> >  static u32 emulated_msrs[ARRAY_SIZE(emulated_msrs_all)];
> > @@ -3888,6 +3892,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, st=
ruct msr_data *msr_info)
> >                  * as to-be-saved, even if an MSRs isn't fully supporte=
d.
> >                  */
> >                 return !msr_info->host_initiated || data;
> > +       case MSR_RAPL_POWER_UNIT:
> > +               vcpu->arch.msr_rapl_power_unit =3D data;
> > +               break;
> > +       case MSR_PKG_ENERGY_STATUS:
> > +               vcpu->arch.msr_pkg_energy_status =3D data;
> > +               break;
> >         default:
> >                 if (kvm_pmu_is_valid_msr(vcpu, msr))
> >                         return kvm_pmu_set_msr(vcpu, msr_info);
> > @@ -3973,13 +3983,17 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, s=
truct msr_data *msr_info)
> >          * data here. Do not conditionalize this on CPUID, as KVM does =
not do
> >          * so for existing CPU-specific MSRs.
> >          */
> > -       case MSR_RAPL_POWER_UNIT:
> >         case MSR_PP0_ENERGY_STATUS:     /* Power plane 0 (core) */
> >         case MSR_PP1_ENERGY_STATUS:     /* Power plane 1 (graphics unco=
re) */
> > -       case MSR_PKG_ENERGY_STATUS:     /* Total package */
> >         case MSR_DRAM_ENERGY_STATUS:    /* DRAM controller */
> >                 msr_info->data =3D 0;
> >                 break;
> > +       case MSR_RAPL_POWER_UNIT:
> > +               msr_info->data =3D vcpu->arch.msr_rapl_power_unit;
> > +               break;
> > +       case MSR_PKG_ENERGY_STATUS:     /* Total package */
> > +               msr_info->data =3D vcpu->arch.msr_pkg_energy_status;
> > +               break;
> >         case MSR_IA32_PEBS_ENABLE:
> >         case MSR_IA32_DS_AREA:
> >         case MSR_PEBS_DATA_CFG:
> > --
> > 2.39.0
> >


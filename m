Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D188C6F0DBC
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 23:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344100AbjD0V0C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 17:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjD0V0B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 17:26:01 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ABE4697
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 14:25:55 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-4f004cc54f4so3168720e87.3
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 14:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682630753; x=1685222753;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kJp5VSJPaTKMp0MaBwTc+rivL1MqjvF6384GC3egbSI=;
        b=URGlnWvEddERWlEl+FlRwubYR1WW28jEfjloursyZnByYi1folHnGcGqp5Kh4ObVgQ
         B69ksSbADkCo7LLWSSgS4ZU7tD1bGyVSNf6Au0HMClbt3Bv5oUYLXefKAW8SxZ/qtPm4
         9ZSu+u3PayjnSy872TK8r5vWqBeuSqqVbzZUVOvA9R0aZLICgX7stXszLqO0ztfAa7Al
         EyMNo5iaaNMXFz1JSt0RrBwmkyGl0WL0ih8uMiXHwSdxXySkUx+M/bvz1vBxQCk7qMud
         Qmg0C1NPqLBhldEQXTLGbs5Gr8hdcgV3cKFxRKLqP6Yu8uReUOcDyq3XMcn4WYE2bmQl
         ydrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682630753; x=1685222753;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kJp5VSJPaTKMp0MaBwTc+rivL1MqjvF6384GC3egbSI=;
        b=WdE+v2oSx++jNNvHSGubJ4BAqWydjGlGbATMlCexiRqi4n+xhkiPye8yMKduP+EN1h
         mYwEM9/BVYdhc+1uYytTG8eEnn16+eV2W6H3uDYcq153kYXherBaecFbo/lNyTxSYHTc
         bmsuRE1RjC0WtSzNO0mfCmq59SLtYj3w9fgnNo0GUQJ/lukBVy5eIrwVRvg/ZaCpwC6N
         XyJfPYeD9g2rPkEks8H+HgjOCuIUvp96ZN/ZangdvJP3oRc3N+xDtAs9M+C1hAE4Aqf2
         Shg5MPmFiGfBGwRUB07m6nIb9JfhpIF1kAKtT8xUbnauyoosoOkOiwrU3qNWPrHlThoi
         4GOA==
X-Gm-Message-State: AC+VfDyHReYssSUhdIS5EWJXn0gkIbehsVAc3bSrRf5NDn986kU9/sxD
        QG7G90LnxMQYu+dJvUkTXc93zxQWPNfdmStOs29poA==
X-Google-Smtp-Source: ACHHUZ4PVmKN0E9+o+i5yAVq3d1XbG3ZyZVN8o746h1AWh2Xy114YUJwUyybHsRONehTSeHUC2/lhb55VUGLSsgSeEQ=
X-Received: by 2002:a2e:8746:0:b0:2a7:80ee:fa78 with SMTP id
 q6-20020a2e8746000000b002a780eefa78mr954984ljj.51.1682630753399; Thu, 27 Apr
 2023 14:25:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230407201921.2703758-1-sagis@google.com> <20230407201921.2703758-4-sagis@google.com>
 <20230418092830.00001bff.zhi.wang.linux@gmail.com> <CAAhR5DFfgyGx9H-m4LE_L3zNmQZRyvmiWMYS1_sHxJihm3f0KA@mail.gmail.com>
 <20230419093400.00000fc2.zhi.wang.linux@gmail.com>
In-Reply-To: <20230419093400.00000fc2.zhi.wang.linux@gmail.com>
From:   Sagi Shahar <sagis@google.com>
Date:   Thu, 27 Apr 2023 14:25:41 -0700
Message-ID: <CAAhR5DEmQb-eVSkSg4tAFA4WV975Yz7PyCaG0C8M1oS6q4Kn3g@mail.gmail.com>
Subject: Re: [RFC PATCH 3/5] KVM: TDX: Add base implementation for tdx_vm_move_enc_context_from
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Tue, Apr 18, 2023 at 11:34=E2=80=AFPM Zhi Wang <zhi.wang.linux@gmail.com=
> wrote:
>
> On Tue, 18 Apr 2023 10:47:44 -0700
> Sagi Shahar <sagis@google.com> wrote:
>
> > On Mon, Apr 17, 2023 at 11:28=E2=80=AFPM Zhi Wang <zhi.wang.linux@gmail=
.com> wrote:
> > >
> > > On Fri,  7 Apr 2023 20:19:19 +0000
> > > Sagi Shahar <sagis@google.com> wrote:
> > >
> > > Is there any reaon that TDX doesn't need .vm_copy_enc_context_from? O=
r it is
> > > going to be deprecated? The patch comments needs to be refined accord=
ing to
> > > Sean's KVM x86 maintainer book.
> >
> > To clarify, there are 2 types of migrations. live migration (between
> > different hosts) and intra-host (between kvm instances in the same
> > host) migration. This patchset deals with intra-host migration and
> > doesn't add support for live migration.
> >
> > vm_copy_enc_context_from is currently used for setting up the
> > migration helper for SEV live migration and therefore it is currently
> > not needed in this patcheset.
>
> Out of curiosity, Is this the migration helper you mentioned here also
> a SEV VM?

I'm not that familiar with SEV migration but from what I understand
the answer is "not exactly".
It's a guest process that runs as part of the SEV VM firmware.

There's some public information about it here:
https://lpc.events/event/11/contributions/958/attachments/769/1448/Live%20m=
igration%20of%20confidential%20guests_LPC2021.pdf
> >
> > >
> > > > This should mostly match the logic in sev_vm_move_enc_context_from.
> > > >
> > > > Signed-off-by: Sagi Shahar <sagis@google.com>
> > > > ---
> > > >  arch/x86/kvm/vmx/main.c    | 10 +++++++
> > > >  arch/x86/kvm/vmx/tdx.c     | 56 ++++++++++++++++++++++++++++++++++=
++++
> > > >  arch/x86/kvm/vmx/tdx.h     |  2 ++
> > > >  arch/x86/kvm/vmx/x86_ops.h |  5 ++++
> > > >  4 files changed, 73 insertions(+)
> > > >
> > > > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > > > index 5b64fe5404958..9d5d0ac465bf6 100644
> > > > --- a/arch/x86/kvm/vmx/main.c
> > > > +++ b/arch/x86/kvm/vmx/main.c
> > > > @@ -979,6 +979,14 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vc=
pu *vcpu, void __user *argp)
> > > >       return tdx_vcpu_ioctl(vcpu, argp);
> > > >  }
> > > >
> > > > +static int vt_move_enc_context_from(struct kvm *kvm, unsigned int =
source_fd)
> > > > +{
> > > > +     if (!is_td(kvm))
> > > > +             return -ENOTTY;
> > > > +
> > > > +     return tdx_vm_move_enc_context_from(kvm, source_fd);
> > > > +}
> > > > +
> > > >  #define VMX_REQUIRED_APICV_INHIBITS                 \
> > > >  (                                                   \
> > > >         BIT(APICV_INHIBIT_REASON_DISABLE)|           \
> > > > @@ -1141,6 +1149,8 @@ struct kvm_x86_ops vt_x86_ops __initdata =3D =
{
> > > >       .dev_mem_enc_ioctl =3D tdx_dev_ioctl,
> > > >       .mem_enc_ioctl =3D vt_mem_enc_ioctl,
> > > >       .vcpu_mem_enc_ioctl =3D vt_vcpu_mem_enc_ioctl,
> > > > +
> > > > +     .vm_move_enc_context_from =3D vt_move_enc_context_from,
> > > >  };
> > > >
> > > >  struct kvm_x86_init_ops vt_init_ops __initdata =3D {
> > > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > > index 8af7e4e81c860..0999a6d827c99 100644
> > > > --- a/arch/x86/kvm/vmx/tdx.c
> > > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > > @@ -2826,3 +2826,59 @@ int __init tdx_init(void)
> > > >               INIT_LIST_HEAD(&per_cpu(associated_tdvcpus, cpu));
> > > >       return 0;
> > > >  }
> > > > +
> > > > +static __always_inline bool tdx_guest(struct kvm *kvm)
> > > > +{
> > > > +     struct kvm_tdx *tdx_kvm =3D to_kvm_tdx(kvm);
> > > > +
> > > > +     return tdx_kvm->finalized;
> > > > +}
> > > > +
> > > > +static int tdx_migrate_from(struct kvm *dst, struct kvm *src)
> > > > +{
> > > > +     return -EINVAL;
> > > > +}
> > > > +
> > > > +int tdx_vm_move_enc_context_from(struct kvm *kvm, unsigned int sou=
rce_fd)
> > > > +{
> > > > +     struct kvm_tdx *dst_tdx =3D to_kvm_tdx(kvm);
> > > > +     struct file *src_kvm_file;
> > > > +     struct kvm_tdx *src_tdx;
> > > > +     struct kvm *src_kvm;
> > > > +     int ret;
> > > > +
> > > > +     src_kvm_file =3D fget(source_fd);
> > > > +     if (!file_is_kvm(src_kvm_file)) {
> > > > +             ret =3D -EBADF;
> > > > +             goto out_fput;
> > > > +     }
> > > > +     src_kvm =3D src_kvm_file->private_data;
> > > > +     src_tdx =3D to_kvm_tdx(src_kvm);
> > > > +
> > > > +     ret =3D pre_move_enc_context_from(kvm, src_kvm,
> > > > +                                     &dst_tdx->migration_in_progre=
ss,
> > > > +                                     &src_tdx->migration_in_progre=
ss);
> > > > +     if (ret)
> > > > +             goto out_fput;
> > > > +
> > > > +     if (tdx_guest(kvm) || !tdx_guest(src_kvm)) {
> > > > +             ret =3D -EINVAL;
> > > > +             goto out_post;
> > > > +     }
> > > > +
> > > > +     ret =3D tdx_migrate_from(kvm, src_kvm);
> > > > +     if (ret)
> > > > +             goto out_post;
> > > > +
> > > > +     kvm_vm_dead(src_kvm);
> > > > +     ret =3D 0;
> > > > +
> > > > +out_post:
> > > > +     post_move_enc_context_from(kvm, src_kvm,
> > > > +                              &dst_tdx->migration_in_progress,
> > > > +                              &src_tdx->migration_in_progress);
> > > > +out_fput:
> > > > +     if (src_kvm_file)
> > > > +             fput(src_kvm_file);
> > > > +     return ret;
> > > > +}
> > > > diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> > > > index 71818c5001862..21b7e710be1fd 100644
> > > > --- a/arch/x86/kvm/vmx/tdx.h
> > > > +++ b/arch/x86/kvm/vmx/tdx.h
> > > > @@ -24,6 +24,8 @@ struct kvm_tdx {
> > > >       atomic_t tdh_mem_track;
> > > >
> > > >       u64 tsc_offset;
> > > > +
> > > > +     atomic_t migration_in_progress;
> > > >  };
> > > >
> > > >  union tdx_exit_reason {
> > > > diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.=
h
> > > > index d049e0c72ed0c..275f5d75e9bf1 100644
> > > > --- a/arch/x86/kvm/vmx/x86_ops.h
> > > > +++ b/arch/x86/kvm/vmx/x86_ops.h
> > > > @@ -187,6 +187,8 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void =
__user *argp);
> > > >  void tdx_flush_tlb(struct kvm_vcpu *vcpu);
> > > >  int tdx_sept_tlb_remote_flush(struct kvm *kvm);
> > > >  void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int r=
oot_level);
> > > > +
> > > > +int tdx_vm_move_enc_context_from(struct kvm *kvm, unsigned int sou=
rce_fd);
> > > >  #else
> > > >  static inline int tdx_init(void) { return 0; };
> > > >  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) =
{ return -ENOSYS; }
> > > > @@ -241,6 +243,9 @@ static inline int tdx_vcpu_ioctl(struct kvm_vcp=
u *vcpu, void __user *argp) { ret
> > > >  static inline void tdx_flush_tlb(struct kvm_vcpu *vcpu) {}
> > > >  static inline int tdx_sept_tlb_remote_flush(struct kvm *kvm) { ret=
urn 0; }
> > > >  static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t r=
oot_hpa, int root_level) {}
> > > > +
> > > > +static inline int tdx_vm_move_enc_context_from(struct kvm *kvm, u
> > > > +                                            nsigned int source_fd)=
 { return -EOPNOTSUPP; }
> > > >  #endif
> > > >
> > > >  #if defined(CONFIG_INTEL_TDX_HOST) && defined(CONFIG_KVM_SMM)
> > >
>

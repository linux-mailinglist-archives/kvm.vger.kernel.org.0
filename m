Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B946E7358
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 08:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbjDSGeP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 02:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbjDSGeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 02:34:14 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437A0198D;
        Tue, 18 Apr 2023 23:34:12 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-4eca9c8dd57so239401e87.1;
        Tue, 18 Apr 2023 23:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681886050; x=1684478050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yRID7qItWKTU8h1je4/rQQR0mexnfCZgsZLH/1Smeyc=;
        b=PbAPzIUiRxfDHfd2VkButs9u1JjLrVQZtvsdvBeOkBOZiasePQ5aQ6UjJjAzUF4f8/
         h95rUbvlYPpquuiEHzw7xyFeEB70ApA5LFUVl9HvcK/yNzEN4Y3B6id33GioqYTQIOLj
         RGnsTuPGgYId0ibYcZO6VjeEy56cfHOg0NuyItDTRpiiR9MsBar3h9W1i/BGdPAzzIf3
         zhF7O3nU4RqxT74ucVFNgjIbF/Jd+ROv6OAsT7kAoOyhltBSBA7GRmuw4KUAUlv1LtCD
         YKI4DVj1RCqf+DWTkxnqssjK8W6OGw/wtrfJsNyM1NOR6oiXTpGkOcSBY7bmvHaSwaBk
         71Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681886050; x=1684478050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yRID7qItWKTU8h1je4/rQQR0mexnfCZgsZLH/1Smeyc=;
        b=gF2CyhpQctJWW4L5pWAH0MWSB6dBRm2wLhHb6MXqtEgDWR3GTXKto5/XkdVWWU4pg7
         7wahS10lqKWffca86tl9bNXjdTs5i576r06O5eDwZt6PmAvk70ErkTmfaWGACMHfXklq
         3NP0tr1nAaE+rB+N7zD0vUfugx3KIB6Z2yljeRlPn+I3M0lGtlqwc7jjQwV/O8bUNntI
         4kPxiSf3fIY3wI92nxgxiO/OuvPQlCtBFWkXab13S4qMaY4ywfgW3P6PwOc0NZPWRo6A
         coHBDM1WkVNzzFBuknGRyGr02YihScA0i8cBqUhqKAmt/Dhg1ysC2zztyCpRDuVyvDHY
         3ajQ==
X-Gm-Message-State: AAQBX9dmKpWxbwvS2hzxPW5RhGj3BdgQY8ksNQyf+60nqq1LJ4TbhIYB
        G6y5OlNVLY34PMHlKsdZn+w=
X-Google-Smtp-Source: AKy350ZaP2QeeWQDN4o81wuLbez6m9LoI//mq7EYL2O7mb/sB6QP7t/a/ukVM2NWYdA9UylF9fJCEw==
X-Received: by 2002:ac2:443a:0:b0:4db:1e4a:749c with SMTP id w26-20020ac2443a000000b004db1e4a749cmr3737803lfl.0.1681886050294;
        Tue, 18 Apr 2023 23:34:10 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id r9-20020ac25a49000000b004edc585d6besm909978lfn.285.2023.04.18.23.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 23:34:10 -0700 (PDT)
Date:   Wed, 19 Apr 2023 09:34:00 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Sagi Shahar <sagis@google.com>
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
Subject: Re: [RFC PATCH 3/5] KVM: TDX: Add base implementation for
 tdx_vm_move_enc_context_from
Message-ID: <20230419093400.00000fc2.zhi.wang.linux@gmail.com>
In-Reply-To: <CAAhR5DFfgyGx9H-m4LE_L3zNmQZRyvmiWMYS1_sHxJihm3f0KA@mail.gmail.com>
References: <20230407201921.2703758-1-sagis@google.com>
        <20230407201921.2703758-4-sagis@google.com>
        <20230418092830.00001bff.zhi.wang.linux@gmail.com>
        <CAAhR5DFfgyGx9H-m4LE_L3zNmQZRyvmiWMYS1_sHxJihm3f0KA@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Apr 2023 10:47:44 -0700
Sagi Shahar <sagis@google.com> wrote:

> On Mon, Apr 17, 2023 at 11:28=E2=80=AFPM Zhi Wang <zhi.wang.linux@gmail.c=
om> wrote:
> >
> > On Fri,  7 Apr 2023 20:19:19 +0000
> > Sagi Shahar <sagis@google.com> wrote:
> >
> > Is there any reaon that TDX doesn't need .vm_copy_enc_context_from? Or =
it is
> > going to be deprecated? The patch comments needs to be refined accordin=
g to
> > Sean's KVM x86 maintainer book.
>=20
> To clarify, there are 2 types of migrations. live migration (between
> different hosts) and intra-host (between kvm instances in the same
> host) migration. This patchset deals with intra-host migration and
> doesn't add support for live migration.
>=20
> vm_copy_enc_context_from is currently used for setting up the
> migration helper for SEV live migration and therefore it is currently
> not needed in this patcheset.

Out of curiosity, Is this the migration helper you mentioned here also
a SEV VM?
>=20
> >
> > > This should mostly match the logic in sev_vm_move_enc_context_from.
> > >
> > > Signed-off-by: Sagi Shahar <sagis@google.com>
> > > ---
> > >  arch/x86/kvm/vmx/main.c    | 10 +++++++
> > >  arch/x86/kvm/vmx/tdx.c     | 56 ++++++++++++++++++++++++++++++++++++=
++
> > >  arch/x86/kvm/vmx/tdx.h     |  2 ++
> > >  arch/x86/kvm/vmx/x86_ops.h |  5 ++++
> > >  4 files changed, 73 insertions(+)
> > >
> > > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > > index 5b64fe5404958..9d5d0ac465bf6 100644
> > > --- a/arch/x86/kvm/vmx/main.c
> > > +++ b/arch/x86/kvm/vmx/main.c
> > > @@ -979,6 +979,14 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu=
 *vcpu, void __user *argp)
> > >       return tdx_vcpu_ioctl(vcpu, argp);
> > >  }
> > >
> > > +static int vt_move_enc_context_from(struct kvm *kvm, unsigned int so=
urce_fd)
> > > +{
> > > +     if (!is_td(kvm))
> > > +             return -ENOTTY;
> > > +
> > > +     return tdx_vm_move_enc_context_from(kvm, source_fd);
> > > +}
> > > +
> > >  #define VMX_REQUIRED_APICV_INHIBITS                 \
> > >  (                                                   \
> > >         BIT(APICV_INHIBIT_REASON_DISABLE)|           \
> > > @@ -1141,6 +1149,8 @@ struct kvm_x86_ops vt_x86_ops __initdata =3D {
> > >       .dev_mem_enc_ioctl =3D tdx_dev_ioctl,
> > >       .mem_enc_ioctl =3D vt_mem_enc_ioctl,
> > >       .vcpu_mem_enc_ioctl =3D vt_vcpu_mem_enc_ioctl,
> > > +
> > > +     .vm_move_enc_context_from =3D vt_move_enc_context_from,
> > >  };
> > >
> > >  struct kvm_x86_init_ops vt_init_ops __initdata =3D {
> > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > index 8af7e4e81c860..0999a6d827c99 100644
> > > --- a/arch/x86/kvm/vmx/tdx.c
> > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > @@ -2826,3 +2826,59 @@ int __init tdx_init(void)
> > >               INIT_LIST_HEAD(&per_cpu(associated_tdvcpus, cpu));
> > >       return 0;
> > >  }
> > > +
> > > +static __always_inline bool tdx_guest(struct kvm *kvm)
> > > +{
> > > +     struct kvm_tdx *tdx_kvm =3D to_kvm_tdx(kvm);
> > > +
> > > +     return tdx_kvm->finalized;
> > > +}
> > > +
> > > +static int tdx_migrate_from(struct kvm *dst, struct kvm *src)
> > > +{
> > > +     return -EINVAL;
> > > +}
> > > +
> > > +int tdx_vm_move_enc_context_from(struct kvm *kvm, unsigned int sourc=
e_fd)
> > > +{
> > > +     struct kvm_tdx *dst_tdx =3D to_kvm_tdx(kvm);
> > > +     struct file *src_kvm_file;
> > > +     struct kvm_tdx *src_tdx;
> > > +     struct kvm *src_kvm;
> > > +     int ret;
> > > +
> > > +     src_kvm_file =3D fget(source_fd);
> > > +     if (!file_is_kvm(src_kvm_file)) {
> > > +             ret =3D -EBADF;
> > > +             goto out_fput;
> > > +     }
> > > +     src_kvm =3D src_kvm_file->private_data;
> > > +     src_tdx =3D to_kvm_tdx(src_kvm);
> > > +
> > > +     ret =3D pre_move_enc_context_from(kvm, src_kvm,
> > > +                                     &dst_tdx->migration_in_progress,
> > > +                                     &src_tdx->migration_in_progress=
);
> > > +     if (ret)
> > > +             goto out_fput;
> > > +
> > > +     if (tdx_guest(kvm) || !tdx_guest(src_kvm)) {
> > > +             ret =3D -EINVAL;
> > > +             goto out_post;
> > > +     }
> > > +
> > > +     ret =3D tdx_migrate_from(kvm, src_kvm);
> > > +     if (ret)
> > > +             goto out_post;
> > > +
> > > +     kvm_vm_dead(src_kvm);
> > > +     ret =3D 0;
> > > +
> > > +out_post:
> > > +     post_move_enc_context_from(kvm, src_kvm,
> > > +                              &dst_tdx->migration_in_progress,
> > > +                              &src_tdx->migration_in_progress);
> > > +out_fput:
> > > +     if (src_kvm_file)
> > > +             fput(src_kvm_file);
> > > +     return ret;
> > > +}
> > > diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> > > index 71818c5001862..21b7e710be1fd 100644
> > > --- a/arch/x86/kvm/vmx/tdx.h
> > > +++ b/arch/x86/kvm/vmx/tdx.h
> > > @@ -24,6 +24,8 @@ struct kvm_tdx {
> > >       atomic_t tdh_mem_track;
> > >
> > >       u64 tsc_offset;
> > > +
> > > +     atomic_t migration_in_progress;
> > >  };
> > >
> > >  union tdx_exit_reason {
> > > diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> > > index d049e0c72ed0c..275f5d75e9bf1 100644
> > > --- a/arch/x86/kvm/vmx/x86_ops.h
> > > +++ b/arch/x86/kvm/vmx/x86_ops.h
> > > @@ -187,6 +187,8 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __=
user *argp);
> > >  void tdx_flush_tlb(struct kvm_vcpu *vcpu);
> > >  int tdx_sept_tlb_remote_flush(struct kvm *kvm);
> > >  void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int roo=
t_level);
> > > +
> > > +int tdx_vm_move_enc_context_from(struct kvm *kvm, unsigned int sourc=
e_fd);
> > >  #else
> > >  static inline int tdx_init(void) { return 0; };
> > >  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { =
return -ENOSYS; }
> > > @@ -241,6 +243,9 @@ static inline int tdx_vcpu_ioctl(struct kvm_vcpu =
*vcpu, void __user *argp) { ret
> > >  static inline void tdx_flush_tlb(struct kvm_vcpu *vcpu) {}
> > >  static inline int tdx_sept_tlb_remote_flush(struct kvm *kvm) { retur=
n 0; }
> > >  static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t roo=
t_hpa, int root_level) {}
> > > +
> > > +static inline int tdx_vm_move_enc_context_from(struct kvm *kvm, u
> > > +                                            nsigned int source_fd) {=
 return -EOPNOTSUPP; }
> > >  #endif
> > >
> > >  #if defined(CONFIG_INTEL_TDX_HOST) && defined(CONFIG_KVM_SMM)
> >


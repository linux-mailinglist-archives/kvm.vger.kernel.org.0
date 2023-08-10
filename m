Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0528D7783ED
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 01:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbjHJXEl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 19:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232715AbjHJXEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 19:04:40 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40AD72D44
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 16:04:39 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5655a2c868eso1186450a12.2
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 16:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691708679; x=1692313479;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A2HZ014dOId2hDwWOJ0bOX1N/o8JyjLLT0vxMFHcIcY=;
        b=zqOmZeBt8A5vjDuDwTJVhKh+bNGRe0VjF6JK/9WevOGuyks4aQUZjmMGT5jewTOPGO
         QNNXbfaZjRGIDjJbXqGA5uvVKLbd540bLxINUf9bbP2sR/lzKTDuuSAu9UifxFDBeqgw
         8ZCiTzCGbRSUDsV75zN5fg0b0bdDHBltXflB0Y1pDN9A5qroN68wOB8helk8tdcXtg/S
         q88I+xcuk/1Hru4Xlm8DyP4ZA0D6FgWJclfTevtUclAlc0FNNmY9CKGjRd5rB8k2w2Km
         rwPhsysDgjBGkQFjFRsB8HVLPOPutaEu3ax6kOraJ9EBeew1A6TDf7gnL772qKiuaqJg
         g37A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691708679; x=1692313479;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=A2HZ014dOId2hDwWOJ0bOX1N/o8JyjLLT0vxMFHcIcY=;
        b=dWQbbX3c3sTvObQuQq/0/nhA4XUUPE+EpFswa5TZ0POAFWm+W9A9usz3lQYWXyQXaJ
         R7fzzftd1K1otZGtAdRBsP+AL/DNT3lOLG/KYqH3DMdlT/415IA4bniEG8JUGPfQ2DW8
         qULWafzxbqFJqoa5diQAu4EGS7rzxrJCpqMszPVMn/tYT5CMUkE4IIl/qTn0c6YTosoQ
         LU6oeRIsi+lQiZ/sfOteuj0w7+B+ZNdypibJagj2GL4vT/kE82vIFP+3u7F1J3iIh3k0
         9Ul3rJRfaeZw9lxWoQLbGyOSnqG9B655GgLvAt9Gwxe6rLRWlZHfO8rD0ip023L0iHor
         QkMA==
X-Gm-Message-State: AOJu0YzrGcmjF8EwtqBzFQACb4PMWlcpWDCz7llgmg8iMMvriv1kAYIF
        SL8IrkdoLdWRB0YG3xiWYujuUH7z14E=
X-Google-Smtp-Source: AGHT+IEllgdOFrNBSktZ3B9czod0DT40RFdbG9IKB+P9/wA8Lbl3UGUkI/mcLGmHPzlm/kyI0BgShEUaX90=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:7e10:0:b0:563:e825:7f3a with SMTP id
 z16-20020a637e10000000b00563e8257f3amr14811pgc.11.1691708678622; Thu, 10 Aug
 2023 16:04:38 -0700 (PDT)
Date:   Thu, 10 Aug 2023 16:04:37 -0700
In-Reply-To: <CAJHc60w0By2Q+PCsfwReGXsN5zf5k1ww3Ov4m9Eb-pFH-UKBDg@mail.gmail.com>
Mime-Version: 1.0
References: <20230808231330.3855936-1-rananta@google.com> <20230808231330.3855936-3-rananta@google.com>
 <c33b0518-6e64-7acf-efa8-f404fce1ccac@redhat.com> <CAJHc60yCJANBQOizaoSPhEJH9e8a9C6n68x4qdVkOhVZiiWqkw@mail.gmail.com>
 <30e45ef3-309a-63de-e085-be1645c1be79@redhat.com> <CAJHc60x=bhXS3PahuRPwRVdqN4LeX-PBdjdEeCEomhf2YAJ1mw@mail.gmail.com>
 <ZNVfsxdYKu9Nt+j+@google.com> <CAJHc60w0By2Q+PCsfwReGXsN5zf5k1ww3Ov4m9Eb-pFH-UKBDg@mail.gmail.com>
Message-ID: <ZNVtBQvjM45tmbce@google.com>
Subject: Re: [PATCH v8 02/14] KVM: Declare kvm_arch_flush_remote_tlbs() globally
From:   Sean Christopherson <seanjc@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Shaoqin Huang <shahuang@redhat.com>, Gavin Shan <gshan@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        David Matlack <dmatlack@google.com>,
        Fuad Tabba <tabba@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 10, 2023, Raghavendra Rao Ananta wrote:
> On Thu, Aug 10, 2023 at 3:20=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > On Thu, Aug 10, 2023, Raghavendra Rao Ananta wrote:
> > > After doing some experiments, I think it works because of the order i=
n
> > > which the inline-definition and the declaration are laid out. If the
> > > 'inline' part of the function comes first and then the declaration, w=
e
> > > don't see any error. However if the positions were reversed, we would
> > > see an error. (I'm not sure what the technical reason for this is).
> > >
> > > Just to be safe, I can move the definition to arch/x86/kvm/mmu/mmu.c
> > > as a non-inline function.
> >
> > No need, asm/kvm_host.h _must_ be included before the declaration, othe=
rwise the
> > declaration wouldn't be made because __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS =
wouldn't
> > be defined.  I.e. we won't run into issues where the non-static declara=
tion comes
> > before the static inline definition.
> >
> > C99 explicitly covers this case:
> >
> >   6.2.2 Linkages of identifiers
> >
> >   ...
> >
> >   If the declaration of a file scope identifier for an object or a func=
tion contains the storage-
> >   class specifier static, the identifier has internal linkage.
> >
> >   For an identifier declared with the storage-class specifier extern in=
 a scope in which a
> >   prior declaration of that identifier is visible if the prior declarat=
ion specifies internal or
> >   external linkage, the linkage of the identifier at the later declarat=
ion is the same as the
> >   linkage specified at the prior declaration. If no prior declaration i=
s visible, or if the prior
> >   declaration specifies no linkage, then the identifier has external li=
nkage.
> >
> > In short, because the "static inline" declared internal linkage first, =
it wins.
> Thanks for sharing this! I can keep the 'static inline' definition as
> is then. However, since a later patch (patch-05/14) defines
> kvm_arch_flush_remote_tlbs_range() in arch/x86/kvm/mmu/mmu.c, do you
> think we can move this definition to the .c file as well for
> consistency?

We "can", but I don't see any reason to do so.  Trying to make helpers cons=
istently
inline or not is usually a fools errand.  And in this case, I'd actually ra=
ther go
the opposite direction and make the range variant an inline.

Ha!  And I can justify that with minimal effort.  The below makes the helpe=
r a
straight passthrough for CONFIG_HYPERV=3Dn builds, at which point I think i=
t makes
sense for it to be inline.

If it won't slow your series down even more, any objection to sliding the b=
elow
patch in somewhere before patch 5?  And then add a patch to inline the rang=
e-based
helper?

Disclaimer: compile tested only.

---
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Aug 2023 15:58:53 -0700
Subject: [PATCH] KVM: x86/mmu: Declare flush_remote_tlbs{_range}() hooks if=
f
 HYPERV!=3Dn

Declare the kvm_x86_ops hooks used to wire up paravirt TLB flushes when
running under Hyper-V if and only if CONFIG_HYPERV!=3Dn.  Wrapping yet more
code with IS_ENABLED(CONFIG_HYPERV) eliminates a handful of conditional
branches, and makes it super obvious why the hooks *might* be valid.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 2 ++
 arch/x86/include/asm/kvm_host.h    | 4 ++++
 arch/x86/kvm/mmu/mmu.c             | 6 ++++++
 3 files changed, 12 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-=
x86-ops.h
index 13bc212cd4bc..6bc1ab0627b7 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -54,8 +54,10 @@ KVM_X86_OP(set_rflags)
 KVM_X86_OP(get_if_flag)
 KVM_X86_OP(flush_tlb_all)
 KVM_X86_OP(flush_tlb_current)
+#if IS_ENABLED(CONFIG_HYPERV)
 KVM_X86_OP_OPTIONAL(flush_remote_tlbs)
 KVM_X86_OP_OPTIONAL(flush_remote_tlbs_range)
+#endif
 KVM_X86_OP(flush_tlb_gva)
 KVM_X86_OP(flush_tlb_guest)
 KVM_X86_OP(vcpu_pre_run)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index 60d430b4650f..04fc80112dfe 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1604,9 +1604,11 @@ struct kvm_x86_ops {
=20
 	void (*flush_tlb_all)(struct kvm_vcpu *vcpu);
 	void (*flush_tlb_current)(struct kvm_vcpu *vcpu);
+#if IS_ENABLED(CONFIG_HYPERV)
 	int  (*flush_remote_tlbs)(struct kvm *kvm);
 	int  (*flush_remote_tlbs_range)(struct kvm *kvm, gfn_t gfn,
 					gfn_t nr_pages);
+#endif
=20
 	/*
 	 * Flush any TLB entries associated with the given GVA.
@@ -1814,6 +1816,7 @@ static inline struct kvm *kvm_arch_alloc_vm(void)
 #define __KVM_HAVE_ARCH_VM_FREE
 void kvm_arch_free_vm(struct kvm *kvm);
=20
+#if IS_ENABLED(CONFIG_HYPERV)
 #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
 static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
 {
@@ -1823,6 +1826,7 @@ static inline int kvm_arch_flush_remote_tlb(struct kv=
m *kvm)
 	else
 		return -ENOTSUPP;
 }
+#endif
=20
 #define kvm_arch_pmi_in_guest(vcpu) \
 	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9e4cd8b4a202..0189dfecce1f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -271,18 +271,24 @@ static inline unsigned long kvm_mmu_get_guest_pgd(str=
uct kvm_vcpu *vcpu,
=20
 static inline bool kvm_available_flush_remote_tlbs_range(void)
 {
+#if IS_ENABLED(CONFIG_HYPERV)
 	return kvm_x86_ops.flush_remote_tlbs_range;
+#else
+	return false;
+#endif
 }
=20
 void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
 				 gfn_t nr_pages)
 {
+#if IS_ENABLED(CONFIG_HYPERV)
 	int ret =3D -EOPNOTSUPP;
=20
 	if (kvm_x86_ops.flush_remote_tlbs_range)
 		ret =3D static_call(kvm_x86_flush_remote_tlbs_range)(kvm, start_gfn,
 								   nr_pages);
 	if (ret)
+#endif
 		kvm_flush_remote_tlbs(kvm);
 }
=20

base-commit: bc9e68820274c025840d3056d63f938d74ca35bb
--=20


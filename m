Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335CB7BED53
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 23:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378682AbjJIV1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 17:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378236AbjJIV1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 17:27:19 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537AE92
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 14:27:18 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a1f12cf1ddso49477397b3.0
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 14:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696886837; x=1697491637; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HX+FtgwJVYx+bxFf8ahMX/YKyuKJ1/AGCli8NkEzPOc=;
        b=4zUiV2DlWNbcz90wLEeyA2LGOamm4EU2wYC2Jb2FZV1dXckv5cYLTi+gnNAz6mAB04
         Xih6ibHrDYHAQ6gJ+yzNYa3dda7h6uXHdqgMYei56Sph7pwwuB+JZ/k7FSA9/OMoc/QI
         i+xUak+s3SCS1ACfXV0apbByf8w+JuSfZVYpctxounW7qaAarMkTtHRmDXunvMy30Kcd
         xFij2HpJLRaIvRsdzP5sKlCVvyZAhEhMsXems/zq7tv+HhuPjyqHb+ZFRzLU6vsvNA0x
         JuxjhsSZBIUdJSjy27ZqWQZOSE4+iCGnSTivixkw3DEACdXfviJ4BrtgAPCXWl2Gh2+e
         IP+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696886837; x=1697491637;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HX+FtgwJVYx+bxFf8ahMX/YKyuKJ1/AGCli8NkEzPOc=;
        b=IlmEalkr3yjZtmqkltWyYvra8Pz7Yovj8g7QRaQK57VoIo2BAcysMYeda/3sluG3Vr
         t9Wj4DG72t+O8JoGQazl4dP+057QxayYf8WQOpQwcVSsJ0fzIz8GD/Lwj2YtCknzrU96
         O5RsYOW4aS+QlHQVt1cJ6wAofRK2Af0/yJt2uu03LpBxNyTi4Dcg5OF2MtFqoZG3exMV
         nbX7hDd1uAmwhpC6KHQzkZoSZi6LX+bUQv/7aXqPuG6mV4nph698AEWE3L6Cb8RbbjCe
         mlP49VproNQAO0A3D5rNeWA1MUYVetQG9Hvei17Ag6rmCW/uqBK+C9ioX4gl/U7UCiT0
         nrVQ==
X-Gm-Message-State: AOJu0YxtrvDaOpFlASQIkUHgSXlIMuUuZWFblxrNdWeIfbRagIjrnr1s
        5tf5pOgS97qK9YHlVeNi8hvy9ZmotTo=
X-Google-Smtp-Source: AGHT+IFWiTOfG0nHmJ/JJ8R7nO+qQuEsneRtuX/I/bdPUs1K6+cxxUjhWILYVmWKRNgJxMSb3cFDbJl5Rk8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2308:0:b0:d91:78b9:b807 with SMTP id
 j8-20020a252308000000b00d9178b9b807mr258474ybj.2.1696886837563; Mon, 09 Oct
 2023 14:27:17 -0700 (PDT)
Date:   Mon, 9 Oct 2023 14:27:16 -0700
In-Reply-To: <ZSRZ_y64UPXBG6lA@google.com>
Mime-Version: 1.0
References: <20230714064656.20147-1-yan.y.zhao@intel.com> <20230714065006.20201-1-yan.y.zhao@intel.com>
 <553e3a0f-156b-e5d2-037b-2d9acaf52329@gmail.com> <ZSRZ_y64UPXBG6lA@google.com>
Message-ID: <ZSRwNO4xWU6Dx1ne@google.com>
Subject: Re: [PATCH v4 01/12] KVM: x86/mmu: helpers to return if KVM honors
 guest MTRRs
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com,
        chao.gao@intel.com, kai.huang@intel.com,
        robert.hoo.linux@gmail.com, yuan.yao@linux.intel.com,
        kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 09, 2023, Sean Christopherson wrote:
> On Sat, Oct 07, 2023, Like Xu wrote:
> > On 14/7/2023 2:50=E2=80=AFpm, Yan Zhao wrote:
> > > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > > index 92d5a1924fc1..38bd449226f6 100644
> > > --- a/arch/x86/kvm/mmu.h
> > > +++ b/arch/x86/kvm/mmu.h
> > > @@ -235,6 +235,13 @@ static inline u8 permission_fault(struct kvm_vcp=
u *vcpu, struct kvm_mmu *mmu,
> > >   	return -(u32)fault & errcode;
> > >   }
> > > +bool __kvm_mmu_honors_guest_mtrrs(struct kvm *kvm, bool vm_has_nonco=
herent_dma);
> > > +
> > > +static inline bool kvm_mmu_honors_guest_mtrrs(struct kvm *kvm)
> > > +{
> > > +	return __kvm_mmu_honors_guest_mtrrs(kvm, kvm_arch_has_noncoherent_d=
ma(kvm));
> > > +}
> > > +
> > >   void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_=
end);
> > >   int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 1e5db621241f..b4f89f015c37 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -4516,6 +4516,21 @@ static int kvm_tdp_mmu_page_fault(struct kvm_v=
cpu *vcpu,
> > >   }
> > >   #endif
> > > +bool __kvm_mmu_honors_guest_mtrrs(struct kvm *kvm, bool vm_has_nonco=
herent_dma)
> >=20
> > According to the motivation provided in the comment, the function will =
no
> > longer need to be passed the parameter "struct kvm *kvm" but will rely =
on
> > the global parameters (plus vm_has_noncoherent_dma), removing "*kvm" ?
>=20
> Yeah, I'll fixup the commit to drop @kvm from the inner helper.  Thanks!

Gah, and I gave more bad advice when I suggested this idea.  There's no nee=
d to
explicitly check tdp_enabled, as shadow_memtype_mask is set to zero if TDP =
is
disabled.  And that must be the case, e.g. make_spte() would generate a cor=
rupt
shadow_memtype_mask were non-zero on Intel with shadow paging.

Yan, can you take a look at what I ended up with (see below) to make sure i=
t
looks sane/acceptable to you?

New hashes (assuming I didn't botch things and need even more fixup).

[1/5] KVM: x86/mmu: Add helpers to return if KVM honors guest MTRRs
      https://github.com/kvm-x86/linux/commit/ec1d8217d59b
[2/5] KVM: x86/mmu: Zap SPTEs when CR0.CD is toggled iff guest MTRRs are ho=
nored
      https://github.com/kvm-x86/linux/commit/40de16c10b9d
[3/5] KVM: x86/mmu: Zap SPTEs on MTRR update iff guest MTRRs are honored
      https://github.com/kvm-x86/linux/commit/defc3fae8d0f
[4/5] KVM: x86/mmu: Zap KVM TDP when noncoherent DMA assignment starts/stop=
s
      https://github.com/kvm-x86/linux/commit/b344d331adeb
[5/5] KVM: VMX: drop IPAT in memtype when CD=3D1 for KVM_X86_QUIRK_CD_NW_CL=
EARED
      https://github.com/kvm-x86/linux/commit/a4d14445c47d

commit ec1d8217d59bd7cb03ae4e80551fee987be98a4e
Author: Yan Zhao <yan.y.zhao@intel.com>
Date:   Fri Jul 14 14:50:06 2023 +0800

    KVM: x86/mmu: Add helpers to return if KVM honors guest MTRRs
   =20
    Add helpers to check if KVM honors guest MTRRs instead of open coding t=
he
    logic in kvm_tdp_page_fault().  Future fixes and cleanups will also nee=
d
    to determine if KVM should honor guest MTRRs, e.g. for CR0.CD toggling =
and
    and non-coherent DMA transitions.
   =20
    Provide an inner helper, __kvm_mmu_honors_guest_mtrrs(), so that KVM ca=
n
    if guest MTRRs were honored when stopping non-coherent DMA.
   =20
    Note, there is no need to explicitly check that TDP is enabled, KVM cle=
ars
    shadow_memtype_mask when TDP is disabled, i.e. it's non-zero if and onl=
y
    if EPT is enabled.
   =20
    Suggested-by: Sean Christopherson <seanjc@google.com>
    Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
    Link: https://lore.kernel.org/r/20230714065006.20201-1-yan.y.zhao@intel=
.com
    Link: https://lore.kernel.org/r/20230714065043.20258-1-yan.y.zhao@intel=
.com
    [sean: squash into a one patch, drop explicit TDP check massage changel=
og]
    Signed-off-by: Sean Christopherson <seanjc@google.com>

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 253fb2093d5d..bb8c86eefac0 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -237,6 +237,13 @@ static inline u8 permission_fault(struct kvm_vcpu *vcp=
u, struct kvm_mmu *mmu,
        return -(u32)fault & errcode;
 }
=20
+bool __kvm_mmu_honors_guest_mtrrs(bool vm_has_noncoherent_dma);
+
+static inline bool kvm_mmu_honors_guest_mtrrs(struct kvm *kvm)
+{
+       return __kvm_mmu_honors_guest_mtrrs(kvm_arch_has_noncoherent_dma(kv=
m));
+}
+
 void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
=20
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f7901cb4d2fa..5d3dc7119e57 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4479,21 +4479,28 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *=
vcpu,
 }
 #endif
=20
+bool __kvm_mmu_honors_guest_mtrrs(bool vm_has_noncoherent_dma)
+{
+       /*
+        * If host MTRRs are ignored (shadow_memtype_mask is non-zero), and=
 the
+        * VM has non-coherent DMA (DMA doesn't snoop CPU caches), KVM's AB=
I is
+        * to honor the memtype from the guest's MTRRs so that guest access=
es
+        * to memory that is DMA'd aren't cached against the guest's wishes=
.
+        *
+        * Note, KVM may still ultimately ignore guest MTRRs for certain PF=
Ns,
+        * e.g. KVM will force UC memtype for host MMIO.
+        */
+       return vm_has_noncoherent_dma && shadow_memtype_mask;
+}
+
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault=
)
 {
        /*
         * If the guest's MTRRs may be used to compute the "real" memtype,
         * restrict the mapping level to ensure KVM uses a consistent memty=
pe
-        * across the entire mapping.  If the host MTRRs are ignored by TDP
-        * (shadow_memtype_mask is non-zero), and the VM has non-coherent D=
MA
-        * (DMA doesn't snoop CPU caches), KVM's ABI is to honor the memtyp=
e
-        * from the guest's MTRRs so that guest accesses to memory that is
-        * DMA'd aren't cached against the guest's wishes.
-        *
-        * Note, KVM may still ultimately ignore guest MTRRs for certain PF=
Ns,
-        * e.g. KVM will force UC memtype for host MMIO.
+        * across the entire mapping.
         */
-       if (shadow_memtype_mask && kvm_arch_has_noncoherent_dma(vcpu->kvm))=
 {
+       if (kvm_mmu_honors_guest_mtrrs(vcpu->kvm)) {
                for ( ; fault->max_level > PG_LEVEL_4K; --fault->max_level)=
 {
                        int page_num =3D KVM_PAGES_PER_HPAGE(fault->max_lev=
el);
                        gfn_t base =3D gfn_round_for_level(fault->gfn,


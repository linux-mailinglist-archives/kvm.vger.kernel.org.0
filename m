Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB35373DFAA
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 14:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjFZMq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 08:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbjFZMqS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 08:46:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8032968;
        Mon, 26 Jun 2023 05:45:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 394C260E93;
        Mon, 26 Jun 2023 12:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EF7C433CA;
        Mon, 26 Jun 2023 12:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687783496;
        bh=Ncy57+N6zeJbovgyXnpNkb/XFLwOt2/y94yAtCpi6yM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Yo1nR0+ev7gE/gE0BUOPevn0aSgxI6LgC9r9hm8SvFEPBt50IBaWlRugA9+o3UfEi
         MvzBYzp+fGklxTeY9xgBjAsG1VKfa81vKt1TGFQH2GAvfVk5TZKe8oQSMxpjEF7zki
         NSip/mMY4RrtRMsB4kcmmbBdV14MekZ32q1k82BDD4yaUkYOpjhQA/Ahs19dYcLq1m
         XNL8u/QzS92qwhAaVn8HlgUbZONRyMYn2E/SPP02NjFwXWz0mA9KIRHDqsffIZrXDf
         3MsOUxlFYgCywd3lLy7Ac3qMno3WevwklhCcmTstaEOn95GFgJB6vnCEjmTP1E1Wk8
         Xk/SJx1uIk9SA==
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-4f4b2bc1565so4284456e87.2;
        Mon, 26 Jun 2023 05:44:56 -0700 (PDT)
X-Gm-Message-State: AC+VfDxGKv0C55rvjv61tADRjx+NXF8sAd1Zjs9qbf+2VjeK8cMu8Bu+
        SEvy0wxGYzC7DIP+vau5+lIGBni6mkJFYJNSaG4=
X-Google-Smtp-Source: ACHHUZ4Lb77dT9iX7qpB7oF6cCgcyq9t2ROwt0AhEU7DbpW7HtbWDHWQvHZ8JP2I/s0OzPlSkbpfPkuIvnFxV/9HkFQ=
X-Received: by 2002:ac2:4d8e:0:b0:4f8:f4d8:c8d1 with SMTP id
 g14-20020ac24d8e000000b004f8f4d8c8d1mr10840480lfe.2.1687783494352; Mon, 26
 Jun 2023 05:44:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230626074919.1871944-1-chenhuacai@loongson.cn> <CABgObfYLnhW0qrPvFnMW_B9xZzLF6Ysn2uL4w9B815fUNVKK5A@mail.gmail.com>
In-Reply-To: <CABgObfYLnhW0qrPvFnMW_B9xZzLF6Ysn2uL4w9B815fUNVKK5A@mail.gmail.com>
From:   Huacai Chen <chenhuacai@kernel.org>
Date:   Mon, 26 Jun 2023 20:44:41 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5N9YFqkDcHwb6q0XC+i2E=1qXgAKARCdPfCFTrD++aBQ@mail.gmail.com>
Message-ID: <CAAhV-H5N9YFqkDcHwb6q0XC+i2E=1qXgAKARCdPfCFTrD++aBQ@mail.gmail.com>
Subject: Re: [PATCH] MIPS: KVM: Fix NULL pointer dereference
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@loongson.cn>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Paolo,

On Mon, Jun 26, 2023 at 6:33=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> On Mon, Jun 26, 2023 at 9:59=E2=80=AFAM Huacai Chen <chenhuacai@loongson.=
cn> wrote:
> >
> > After commit 45c7e8af4a5e3f0bea4ac209 ("MIPS: Remove KVM_TE support") w=
e
> > get a NULL pointer dereference when creating a KVM guest:
>
> To be honest, a bug that needed 2 years to be reproduced is probably a
> sign that KVM/MIPS has no users. Any objections to removing it
> altogether?
I'm very sorry for that, in the past two years I have built MIPS
kernels with KVM daily, but only tested in QEMU TCG because I cross
compiled on a x86 machine. Meanwhile, Loongson distros are still using
the old LTS kernels so nearly no one sees the bug...

But anyway, I want to keep it at present. Sorry for that again.

Huacai
>
> Paolo
>
> >
> > [  146.243409] Starting KVM with MIPS VZ extensions
> > [  149.849151] CPU 3 Unable to handle kernel paging request at virtual =
address 0000000000000300, epc =3D=3D ffffffffc06356ec, ra =3D=3D ffffffffc0=
63568c
> > [  149.849177] Oops[#1]:
> > [  149.849182] CPU: 3 PID: 2265 Comm: qemu-system-mip Not tainted 6.4.0=
-rc3+ #1671
> > [  149.849188] Hardware name: THTF CX TL630 Series/THTF-LS3A4000-7A1000=
-ML4A, BIOS KL4.1F.TF.D.166.201225.R 12/25/2020
> > [  149.849192] $ 0   : 0000000000000000 000000007400cce0 00000000004000=
04 ffffffff8119c740
> > [  149.849209] $ 4   : 000000007400cce1 000000007400cce1 00000000000000=
00 0000000000000000
> > [  149.849221] $ 8   : 000000240058bb36 ffffffff81421ac0 00000000000000=
00 0000000000400dc0
> > [  149.849233] $12   : 9800000102a07cc8 ffffffff80e40e38 00000000000000=
01 0000000000400dc0
> > [  149.849245] $16   : 0000000000000000 9800000106cd0000 9800000106cd00=
00 9800000100cce000
> > [  149.849257] $20   : ffffffffc0632b28 ffffffffc05b31b0 9800000100ccca=
00 0000000000400000
> > [  149.849269] $24   : 9800000106cd09ce ffffffff802f69d0
> > [  149.849281] $28   : 9800000102a04000 9800000102a07cd0 98000001106a80=
00 ffffffffc063568c
> > [  149.849293] Hi    : 00000335b2111e66
> > [  149.849295] Lo    : 6668d90061ae0ae9
> > [  149.849298] epc   : ffffffffc06356ec kvm_vz_vcpu_setup+0xc4/0x328 [k=
vm]
> > [  149.849324] ra    : ffffffffc063568c kvm_vz_vcpu_setup+0x64/0x328 [k=
vm]
> > [  149.849336] Status: 7400cce3 KX SX UX KERNEL EXL IE
> > [  149.849351] Cause : 1000000c (ExcCode 03)
> > [  149.849354] BadVA : 0000000000000300
> > [  149.849357] PrId  : 0014c004 (ICT Loongson-3)
> > [  149.849360] Modules linked in: kvm nfnetlink_queue nfnetlink_log nfn=
etlink fuse sha256_generic libsha256 cfg80211 rfkill binfmt_misc vfat fat s=
nd_hda_codec_hdmi input_leds led_class snd_hda_intel snd_intel_dspcfg snd_h=
da_codec snd_hda_core snd_pcm snd_timer snd serio_raw xhci_pci radeon drm_s=
uballoc_helper drm_display_helper xhci_hcd ip_tables x_tables
> > [  149.849432] Process qemu-system-mip (pid: 2265, threadinfo=3D0000000=
0ae2982d2, task=3D0000000038e09ad4, tls=3D000000ffeba16030)
> > [  149.849439] Stack : 9800000000000003 9800000100ccca00 9800000100ccc0=
00 ffffffffc062cef4
> > [  149.849453]         9800000102a07d18 c89b63a7ab338e00 00000000000000=
00 ffffffff811a0000
> > [  149.849465]         0000000000000000 9800000106cd0000 ffffffff80e599=
38 98000001106a8920
> > [  149.849476]         ffffffff80e57f30 ffffffffc062854c ffffffff811a00=
00 9800000102bf4240
> > [  149.849488]         ffffffffc05b0000 ffffffff80e3a798 000000ff780000=
00 000000ff78000010
> > [  149.849500]         0000000000000255 98000001021f7de0 98000001023f00=
78 ffffffff81434000
> > [  149.849511]         0000000000000000 0000000000000000 9800000102ae00=
00 980000025e92ae28
> > [  149.849523]         0000000000000000 c89b63a7ab338e00 00000000000000=
01 ffffffff8119dce0
> > [  149.849535]         000000ff78000010 ffffffff804f3d3c 9800000102a07e=
b0 0000000000000255
> > [  149.849546]         0000000000000000 ffffffff8049460c 000000ff780000=
10 0000000000000255
> > [  149.849558]         ...
> > [  149.849565] Call Trace:
> > [  149.849567] [<ffffffffc06356ec>] kvm_vz_vcpu_setup+0xc4/0x328 [kvm]
> > [  149.849586] [<ffffffffc062cef4>] kvm_arch_vcpu_create+0x184/0x228 [k=
vm]
> > [  149.849605] [<ffffffffc062854c>] kvm_vm_ioctl+0x64c/0xf28 [kvm]
> > [  149.849623] [<ffffffff805209c0>] sys_ioctl+0xc8/0x118
> > [  149.849631] [<ffffffff80219eb0>] syscall_common+0x34/0x58
> >
> > The root cause is the deletion of kvm_mips_commpage_init() leaves vcpu-=
>
> > arch.cop0 NULL. So fix it by make cop0 from a pointer to an embed objec=
t.
> >
> > Fixes: 45c7e8af4a5e3f0bea4ac209 ("MIPS: Remove KVM_TE support")
> > Cc: stable@vger.kernel.org
> > Suggested-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> > ---
> >  arch/mips/include/asm/kvm_host.h |  6 +++---
> >  arch/mips/kvm/emulate.c          | 22 +++++++++++-----------
> >  arch/mips/kvm/mips.c             | 16 ++++++++--------
> >  arch/mips/kvm/trace.h            |  8 ++++----
> >  arch/mips/kvm/vz.c               | 20 ++++++++++----------
> >  5 files changed, 36 insertions(+), 36 deletions(-)
> >
> > diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/k=
vm_host.h
> > index 957121a495f0..04cedf9f8811 100644
> > --- a/arch/mips/include/asm/kvm_host.h
> > +++ b/arch/mips/include/asm/kvm_host.h
> > @@ -317,7 +317,7 @@ struct kvm_vcpu_arch {
> >         unsigned int aux_inuse;
> >
> >         /* COP0 State */
> > -       struct mips_coproc *cop0;
> > +       struct mips_coproc cop0;
> >
> >         /* Resume PC after MMIO completion */
> >         unsigned long io_pc;
> > @@ -698,7 +698,7 @@ static inline bool kvm_mips_guest_can_have_fpu(stru=
ct kvm_vcpu_arch *vcpu)
> >  static inline bool kvm_mips_guest_has_fpu(struct kvm_vcpu_arch *vcpu)
> >  {
> >         return kvm_mips_guest_can_have_fpu(vcpu) &&
> > -               kvm_read_c0_guest_config1(vcpu->cop0) & MIPS_CONF1_FP;
> > +               kvm_read_c0_guest_config1(&vcpu->cop0) & MIPS_CONF1_FP;
> >  }
> >
> >  static inline bool kvm_mips_guest_can_have_msa(struct kvm_vcpu_arch *v=
cpu)
> > @@ -710,7 +710,7 @@ static inline bool kvm_mips_guest_can_have_msa(stru=
ct kvm_vcpu_arch *vcpu)
> >  static inline bool kvm_mips_guest_has_msa(struct kvm_vcpu_arch *vcpu)
> >  {
> >         return kvm_mips_guest_can_have_msa(vcpu) &&
> > -               kvm_read_c0_guest_config3(vcpu->cop0) & MIPS_CONF3_MSA;
> > +               kvm_read_c0_guest_config3(&vcpu->cop0) & MIPS_CONF3_MSA=
;
> >  }
> >
> >  struct kvm_mips_callbacks {
> > diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
> > index edaec93a1a1f..e64372b8f66a 100644
> > --- a/arch/mips/kvm/emulate.c
> > +++ b/arch/mips/kvm/emulate.c
> > @@ -312,7 +312,7 @@ int kvm_get_badinstrp(u32 *opc, struct kvm_vcpu *vc=
pu, u32 *out)
> >   */
> >  int kvm_mips_count_disabled(struct kvm_vcpu *vcpu)
> >  {
> > -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> > +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
> >
> >         return  (vcpu->arch.count_ctl & KVM_REG_MIPS_COUNT_CTL_DC) ||
> >                 (kvm_read_c0_guest_cause(cop0) & CAUSEF_DC);
> > @@ -384,7 +384,7 @@ static inline ktime_t kvm_mips_count_time(struct kv=
m_vcpu *vcpu)
> >   */
> >  static u32 kvm_mips_read_count_running(struct kvm_vcpu *vcpu, ktime_t =
now)
> >  {
> > -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> > +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
> >         ktime_t expires, threshold;
> >         u32 count, compare;
> >         int running;
> > @@ -444,7 +444,7 @@ static u32 kvm_mips_read_count_running(struct kvm_v=
cpu *vcpu, ktime_t now)
> >   */
> >  u32 kvm_mips_read_count(struct kvm_vcpu *vcpu)
> >  {
> > -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> > +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
> >
> >         /* If count disabled just read static copy of count */
> >         if (kvm_mips_count_disabled(vcpu))
> > @@ -502,7 +502,7 @@ ktime_t kvm_mips_freeze_hrtimer(struct kvm_vcpu *vc=
pu, u32 *count)
> >  static void kvm_mips_resume_hrtimer(struct kvm_vcpu *vcpu,
> >                                     ktime_t now, u32 count)
> >  {
> > -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> > +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
> >         u32 compare;
> >         u64 delta;
> >         ktime_t expire;
> > @@ -603,7 +603,7 @@ int kvm_mips_restore_hrtimer(struct kvm_vcpu *vcpu,=
 ktime_t before,
> >   */
> >  void kvm_mips_write_count(struct kvm_vcpu *vcpu, u32 count)
> >  {
> > -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> > +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
> >         ktime_t now;
> >
> >         /* Calculate bias */
> > @@ -649,7 +649,7 @@ void kvm_mips_init_count(struct kvm_vcpu *vcpu, uns=
igned long count_hz)
> >   */
> >  int kvm_mips_set_count_hz(struct kvm_vcpu *vcpu, s64 count_hz)
> >  {
> > -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> > +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
> >         int dc;
> >         ktime_t now;
> >         u32 count;
> > @@ -696,7 +696,7 @@ int kvm_mips_set_count_hz(struct kvm_vcpu *vcpu, s6=
4 count_hz)
> >   */
> >  void kvm_mips_write_compare(struct kvm_vcpu *vcpu, u32 compare, bool a=
ck)
> >  {
> > -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> > +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
> >         int dc;
> >         u32 old_compare =3D kvm_read_c0_guest_compare(cop0);
> >         s32 delta =3D compare - old_compare;
> > @@ -779,7 +779,7 @@ void kvm_mips_write_compare(struct kvm_vcpu *vcpu, =
u32 compare, bool ack)
> >   */
> >  static ktime_t kvm_mips_count_disable(struct kvm_vcpu *vcpu)
> >  {
> > -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> > +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
> >         u32 count;
> >         ktime_t now;
> >
> > @@ -806,7 +806,7 @@ static ktime_t kvm_mips_count_disable(struct kvm_vc=
pu *vcpu)
> >   */
> >  void kvm_mips_count_disable_cause(struct kvm_vcpu *vcpu)
> >  {
> > -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> > +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
> >
> >         kvm_set_c0_guest_cause(cop0, CAUSEF_DC);
> >         if (!(vcpu->arch.count_ctl & KVM_REG_MIPS_COUNT_CTL_DC))
> > @@ -826,7 +826,7 @@ void kvm_mips_count_disable_cause(struct kvm_vcpu *=
vcpu)
> >   */
> >  void kvm_mips_count_enable_cause(struct kvm_vcpu *vcpu)
> >  {
> > -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> > +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
> >         u32 count;
> >
> >         kvm_clear_c0_guest_cause(cop0, CAUSEF_DC);
> > @@ -852,7 +852,7 @@ void kvm_mips_count_enable_cause(struct kvm_vcpu *v=
cpu)
> >   */
> >  int kvm_mips_set_count_ctl(struct kvm_vcpu *vcpu, s64 count_ctl)
> >  {
> > -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> > +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
> >         s64 changed =3D count_ctl ^ vcpu->arch.count_ctl;
> >         s64 delta;
> >         ktime_t expire, now;
> > diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> > index 884be4ef99dc..aa5583a7b05b 100644
> > --- a/arch/mips/kvm/mips.c
> > +++ b/arch/mips/kvm/mips.c
> > @@ -649,7 +649,7 @@ static int kvm_mips_copy_reg_indices(struct kvm_vcp=
u *vcpu, u64 __user *indices)
> >  static int kvm_mips_get_reg(struct kvm_vcpu *vcpu,
> >                             const struct kvm_one_reg *reg)
> >  {
> > -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> > +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
> >         struct mips_fpu_struct *fpu =3D &vcpu->arch.fpu;
> >         int ret;
> >         s64 v;
> > @@ -761,7 +761,7 @@ static int kvm_mips_get_reg(struct kvm_vcpu *vcpu,
> >  static int kvm_mips_set_reg(struct kvm_vcpu *vcpu,
> >                             const struct kvm_one_reg *reg)
> >  {
> > -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> > +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
> >         struct mips_fpu_struct *fpu =3D &vcpu->arch.fpu;
> >         s64 v;
> >         s64 vs[2];
> > @@ -1086,7 +1086,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,=
 long ext)
> >  int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
> >  {
> >         return kvm_mips_pending_timer(vcpu) ||
> > -               kvm_read_c0_guest_cause(vcpu->arch.cop0) & C_TI;
> > +               kvm_read_c0_guest_cause(&vcpu->arch.cop0) & C_TI;
> >  }
> >
> >  int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu)
> > @@ -1110,7 +1110,7 @@ int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu=
)
> >         kvm_debug("\thi: 0x%08lx\n", vcpu->arch.hi);
> >         kvm_debug("\tlo: 0x%08lx\n", vcpu->arch.lo);
> >
> > -       cop0 =3D vcpu->arch.cop0;
> > +       cop0 =3D &vcpu->arch.cop0;
> >         kvm_debug("\tStatus: 0x%08x, Cause: 0x%08x\n",
> >                   kvm_read_c0_guest_status(cop0),
> >                   kvm_read_c0_guest_cause(cop0));
> > @@ -1232,7 +1232,7 @@ static int __kvm_mips_handle_exit(struct kvm_vcpu=
 *vcpu)
> >
> >         case EXCCODE_TLBS:
> >                 kvm_debug("TLB ST fault:  cause %#x, status %#x, PC: %p=
, BadVaddr: %#lx\n",
> > -                         cause, kvm_read_c0_guest_status(vcpu->arch.co=
p0), opc,
> > +                         cause, kvm_read_c0_guest_status(&vcpu->arch.c=
op0), opc,
> >                           badvaddr);
> >
> >                 ++vcpu->stat.tlbmiss_st_exits;
> > @@ -1304,7 +1304,7 @@ static int __kvm_mips_handle_exit(struct kvm_vcpu=
 *vcpu)
> >                 kvm_get_badinstr(opc, vcpu, &inst);
> >                 kvm_err("Exception Code: %d, not yet handled, @ PC: %p,=
 inst: 0x%08x  BadVaddr: %#lx Status: %#x\n",
> >                         exccode, opc, inst, badvaddr,
> > -                       kvm_read_c0_guest_status(vcpu->arch.cop0));
> > +                       kvm_read_c0_guest_status(&vcpu->arch.cop0));
> >                 kvm_arch_vcpu_dump_regs(vcpu);
> >                 run->exit_reason =3D KVM_EXIT_INTERNAL_ERROR;
> >                 ret =3D RESUME_HOST;
> > @@ -1377,7 +1377,7 @@ int noinstr kvm_mips_handle_exit(struct kvm_vcpu =
*vcpu)
> >  /* Enable FPU for guest and restore context */
> >  void kvm_own_fpu(struct kvm_vcpu *vcpu)
> >  {
> > -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> > +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
> >         unsigned int sr, cfg5;
> >
> >         preempt_disable();
> > @@ -1421,7 +1421,7 @@ void kvm_own_fpu(struct kvm_vcpu *vcpu)
> >  /* Enable MSA for guest and restore context */
> >  void kvm_own_msa(struct kvm_vcpu *vcpu)
> >  {
> > -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> > +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
> >         unsigned int sr, cfg5;
> >
> >         preempt_disable();
> > diff --git a/arch/mips/kvm/trace.h b/arch/mips/kvm/trace.h
> > index a8c7fd7bf6d2..136c3535a1cb 100644
> > --- a/arch/mips/kvm/trace.h
> > +++ b/arch/mips/kvm/trace.h
> > @@ -322,11 +322,11 @@ TRACE_EVENT_FN(kvm_guest_mode_change,
> >             ),
> >
> >             TP_fast_assign(
> > -                       __entry->epc =3D kvm_read_c0_guest_epc(vcpu->ar=
ch.cop0);
> > +                       __entry->epc =3D kvm_read_c0_guest_epc(&vcpu->a=
rch.cop0);
> >                         __entry->pc =3D vcpu->arch.pc;
> > -                       __entry->badvaddr =3D kvm_read_c0_guest_badvadd=
r(vcpu->arch.cop0);
> > -                       __entry->status =3D kvm_read_c0_guest_status(vc=
pu->arch.cop0);
> > -                       __entry->cause =3D kvm_read_c0_guest_cause(vcpu=
->arch.cop0);
> > +                       __entry->badvaddr =3D kvm_read_c0_guest_badvadd=
r(&vcpu->arch.cop0);
> > +                       __entry->status =3D kvm_read_c0_guest_status(&v=
cpu->arch.cop0);
> > +                       __entry->cause =3D kvm_read_c0_guest_cause(&vcp=
u->arch.cop0);
> >             ),
> >
> >             TP_printk("EPC: 0x%08lx PC: 0x%08lx Status: 0x%08x Cause: 0=
x%08x BadVAddr: 0x%08lx",
> > diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
> > index 3d21cbfa7443..99d5a71e4300 100644
> > --- a/arch/mips/kvm/vz.c
> > +++ b/arch/mips/kvm/vz.c
> > @@ -422,7 +422,7 @@ static void _kvm_vz_restore_htimer(struct kvm_vcpu =
*vcpu,
> >   */
> >  static void kvm_vz_restore_timer(struct kvm_vcpu *vcpu)
> >  {
> > -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> > +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
> >         u32 cause, compare;
> >
> >         compare =3D kvm_read_sw_gc0_compare(cop0);
> > @@ -517,7 +517,7 @@ static void _kvm_vz_save_htimer(struct kvm_vcpu *vc=
pu,
> >   */
> >  static void kvm_vz_save_timer(struct kvm_vcpu *vcpu)
> >  {
> > -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> > +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
> >         u32 gctl0, compare, cause;
> >
> >         gctl0 =3D read_c0_guestctl0();
> > @@ -863,7 +863,7 @@ static unsigned long mips_process_maar(unsigned int=
 op, unsigned long val)
> >
> >  static void kvm_write_maari(struct kvm_vcpu *vcpu, unsigned long val)
> >  {
> > -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> > +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
> >
> >         val &=3D MIPS_MAARI_INDEX;
> >         if (val =3D=3D MIPS_MAARI_INDEX)
> > @@ -876,7 +876,7 @@ static enum emulation_result kvm_vz_gpsi_cop0(union=
 mips_instruction inst,
> >                                               u32 *opc, u32 cause,
> >                                               struct kvm_vcpu *vcpu)
> >  {
> > -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> > +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
> >         enum emulation_result er =3D EMULATE_DONE;
> >         u32 rt, rd, sel;
> >         unsigned long curr_pc;
> > @@ -1911,7 +1911,7 @@ static int kvm_vz_get_one_reg(struct kvm_vcpu *vc=
pu,
> >                               const struct kvm_one_reg *reg,
> >                               s64 *v)
> >  {
> > -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> > +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
> >         unsigned int idx;
> >
> >         switch (reg->id) {
> > @@ -2081,7 +2081,7 @@ static int kvm_vz_get_one_reg(struct kvm_vcpu *vc=
pu,
> >         case KVM_REG_MIPS_CP0_MAARI:
> >                 if (!cpu_guest_has_maar || cpu_guest_has_dyn_maar)
> >                         return -EINVAL;
> > -               *v =3D kvm_read_sw_gc0_maari(vcpu->arch.cop0);
> > +               *v =3D kvm_read_sw_gc0_maari(&vcpu->arch.cop0);
> >                 break;
> >  #ifdef CONFIG_64BIT
> >         case KVM_REG_MIPS_CP0_XCONTEXT:
> > @@ -2135,7 +2135,7 @@ static int kvm_vz_set_one_reg(struct kvm_vcpu *vc=
pu,
> >                               const struct kvm_one_reg *reg,
> >                               s64 v)
> >  {
> > -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> > +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
> >         unsigned int idx;
> >         int ret =3D 0;
> >         unsigned int cur, change;
> > @@ -2562,7 +2562,7 @@ static void kvm_vz_vcpu_load_tlb(struct kvm_vcpu =
*vcpu, int cpu)
> >
> >  static int kvm_vz_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >  {
> > -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> > +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
> >         bool migrated, all;
> >
> >         /*
> > @@ -2704,7 +2704,7 @@ static int kvm_vz_vcpu_load(struct kvm_vcpu *vcpu=
, int cpu)
> >
> >  static int kvm_vz_vcpu_put(struct kvm_vcpu *vcpu, int cpu)
> >  {
> > -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> > +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
> >
> >         if (current->flags & PF_VCPU)
> >                 kvm_vz_vcpu_save_wired(vcpu);
> > @@ -3076,7 +3076,7 @@ static void kvm_vz_vcpu_uninit(struct kvm_vcpu *v=
cpu)
> >
> >  static int kvm_vz_vcpu_setup(struct kvm_vcpu *vcpu)
> >  {
> > -       struct mips_coproc *cop0 =3D vcpu->arch.cop0;
> > +       struct mips_coproc *cop0 =3D &vcpu->arch.cop0;
> >         unsigned long count_hz =3D 100*1000*1000; /* default to 100 MHz=
 */
> >
> >         /*
> > --
> > 2.39.3
> >
>

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2951B7329AE
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 10:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245258AbjFPIXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 04:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240654AbjFPIXn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 04:23:43 -0400
Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D6C5A2D58;
        Fri, 16 Jun 2023 01:23:41 -0700 (PDT)
Received: from uucp by elvis.franken.de with local-rmail (Exim 3.36 #1)
        id 1qA4k5-0006tF-00; Fri, 16 Jun 2023 10:23:37 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 2F265C02FD; Fri, 16 Jun 2023 10:23:22 +0200 (CEST)
Date:   Fri, 16 Jun 2023 10:23:22 +0200
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Yu Zhao <yuzhao@google.com>
Cc:     chenhuacai@kernel.org, aleksandar.qemu.devel@gmail.com,
        jiaxun.yang@flygoat.com, kvm@vger.kernel.org,
        linux-mips@vger.kernel.org, pbonzini@redhat.com,
        robh+dt@kernel.org, zhangfx@lemote.com
Subject: Re: [PATCH 5/5] MAINTAINERS: Update KVM/MIPS maintainers
Message-ID: <20230616082322.GA7323@alpha.franken.de>
References: <1596005919-29365-5-git-send-email-chenhc@lemote.com>
 <20230616071831.1452507-1-yuzhao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616071831.1452507-1-yuzhao@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 16, 2023 at 01:18:31AM -0600, Yu Zhao wrote:
> On Tue, Jul 28, 2020 at 23:58:20PM -0700, Huacai Chen wrote:
> > James Hogan has become inactive for a long time and leaves KVM for MIPS
> > orphan. I'm working on KVM/Loongson and attempt to make it upstream both
> > in kernel and QEMU, while Aleksandar Markovic is already a maintainer of
> > QEMU/MIPS. We are both interested in QEMU/KVM/MIPS, and we have already
> > made some contributions in kernel and QEMU. If possible, we want to take
> > the KVM/MIPS maintainership.
> >
> > Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> > Signed-off-by: Huacai Chen <chenhc@lemote.com>
> > ---
> >  MAINTAINERS | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index bddc79a..5f9c2fd 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -9441,9 +9441,11 @@ F:	arch/arm64/kvm/
> >  F:	include/kvm/arm_*
> >
> >  KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)
> > +M:	Huacai Chen <chenhc@lemote.com>
> > +M:	Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
> >  L:	linux-mips@vger.kernel.org
> >  L:	kvm@vger.kernel.org
> > -S:	Orphan
> > +S:	Maintained
> >  F:	arch/mips/include/asm/kvm*
> >  F:	arch/mips/include/uapi/asm/kvm*
> >  F:	arch/mips/kvm/
> 
> Hi,
> 
> Is kvm/mips still maintained? Thanks.
> 
> I tried v6.4-rc6 and hit the following crash. It seems it has been broken since
> 
>   commit 45c7e8af4a5e3f0bea4ac209eea34118dd57ac64
>   Author: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
>   Date:   Mon Mar 1 16:29:57 2021 +0100
>   
>       MIPS: Remove KVM_TE support

ok, I see what I missed when removing TE support, d'oh. Does the patch
below fix the issue for you ?

Thomas.

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 957121a495f0..04cedf9f8811 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -317,7 +317,7 @@ struct kvm_vcpu_arch {
 	unsigned int aux_inuse;
 
 	/* COP0 State */
-	struct mips_coproc *cop0;
+	struct mips_coproc cop0;
 
 	/* Resume PC after MMIO completion */
 	unsigned long io_pc;
@@ -698,7 +698,7 @@ static inline bool kvm_mips_guest_can_have_fpu(struct kvm_vcpu_arch *vcpu)
 static inline bool kvm_mips_guest_has_fpu(struct kvm_vcpu_arch *vcpu)
 {
 	return kvm_mips_guest_can_have_fpu(vcpu) &&
-		kvm_read_c0_guest_config1(vcpu->cop0) & MIPS_CONF1_FP;
+		kvm_read_c0_guest_config1(&vcpu->cop0) & MIPS_CONF1_FP;
 }
 
 static inline bool kvm_mips_guest_can_have_msa(struct kvm_vcpu_arch *vcpu)
@@ -710,7 +710,7 @@ static inline bool kvm_mips_guest_can_have_msa(struct kvm_vcpu_arch *vcpu)
 static inline bool kvm_mips_guest_has_msa(struct kvm_vcpu_arch *vcpu)
 {
 	return kvm_mips_guest_can_have_msa(vcpu) &&
-		kvm_read_c0_guest_config3(vcpu->cop0) & MIPS_CONF3_MSA;
+		kvm_read_c0_guest_config3(&vcpu->cop0) & MIPS_CONF3_MSA;
 }
 
 struct kvm_mips_callbacks {
diff --git a/arch/mips/kvm/emulate.c b/arch/mips/kvm/emulate.c
index edaec93a1a1f..e64372b8f66a 100644
--- a/arch/mips/kvm/emulate.c
+++ b/arch/mips/kvm/emulate.c
@@ -312,7 +312,7 @@ int kvm_get_badinstrp(u32 *opc, struct kvm_vcpu *vcpu, u32 *out)
  */
 int kvm_mips_count_disabled(struct kvm_vcpu *vcpu)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct mips_coproc *cop0 = &vcpu->arch.cop0;
 
 	return	(vcpu->arch.count_ctl & KVM_REG_MIPS_COUNT_CTL_DC) ||
 		(kvm_read_c0_guest_cause(cop0) & CAUSEF_DC);
@@ -384,7 +384,7 @@ static inline ktime_t kvm_mips_count_time(struct kvm_vcpu *vcpu)
  */
 static u32 kvm_mips_read_count_running(struct kvm_vcpu *vcpu, ktime_t now)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct mips_coproc *cop0 = &vcpu->arch.cop0;
 	ktime_t expires, threshold;
 	u32 count, compare;
 	int running;
@@ -444,7 +444,7 @@ static u32 kvm_mips_read_count_running(struct kvm_vcpu *vcpu, ktime_t now)
  */
 u32 kvm_mips_read_count(struct kvm_vcpu *vcpu)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct mips_coproc *cop0 = &vcpu->arch.cop0;
 
 	/* If count disabled just read static copy of count */
 	if (kvm_mips_count_disabled(vcpu))
@@ -502,7 +502,7 @@ ktime_t kvm_mips_freeze_hrtimer(struct kvm_vcpu *vcpu, u32 *count)
 static void kvm_mips_resume_hrtimer(struct kvm_vcpu *vcpu,
 				    ktime_t now, u32 count)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct mips_coproc *cop0 = &vcpu->arch.cop0;
 	u32 compare;
 	u64 delta;
 	ktime_t expire;
@@ -603,7 +603,7 @@ int kvm_mips_restore_hrtimer(struct kvm_vcpu *vcpu, ktime_t before,
  */
 void kvm_mips_write_count(struct kvm_vcpu *vcpu, u32 count)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct mips_coproc *cop0 = &vcpu->arch.cop0;
 	ktime_t now;
 
 	/* Calculate bias */
@@ -649,7 +649,7 @@ void kvm_mips_init_count(struct kvm_vcpu *vcpu, unsigned long count_hz)
  */
 int kvm_mips_set_count_hz(struct kvm_vcpu *vcpu, s64 count_hz)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct mips_coproc *cop0 = &vcpu->arch.cop0;
 	int dc;
 	ktime_t now;
 	u32 count;
@@ -696,7 +696,7 @@ int kvm_mips_set_count_hz(struct kvm_vcpu *vcpu, s64 count_hz)
  */
 void kvm_mips_write_compare(struct kvm_vcpu *vcpu, u32 compare, bool ack)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct mips_coproc *cop0 = &vcpu->arch.cop0;
 	int dc;
 	u32 old_compare = kvm_read_c0_guest_compare(cop0);
 	s32 delta = compare - old_compare;
@@ -779,7 +779,7 @@ void kvm_mips_write_compare(struct kvm_vcpu *vcpu, u32 compare, bool ack)
  */
 static ktime_t kvm_mips_count_disable(struct kvm_vcpu *vcpu)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct mips_coproc *cop0 = &vcpu->arch.cop0;
 	u32 count;
 	ktime_t now;
 
@@ -806,7 +806,7 @@ static ktime_t kvm_mips_count_disable(struct kvm_vcpu *vcpu)
  */
 void kvm_mips_count_disable_cause(struct kvm_vcpu *vcpu)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct mips_coproc *cop0 = &vcpu->arch.cop0;
 
 	kvm_set_c0_guest_cause(cop0, CAUSEF_DC);
 	if (!(vcpu->arch.count_ctl & KVM_REG_MIPS_COUNT_CTL_DC))
@@ -826,7 +826,7 @@ void kvm_mips_count_disable_cause(struct kvm_vcpu *vcpu)
  */
 void kvm_mips_count_enable_cause(struct kvm_vcpu *vcpu)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct mips_coproc *cop0 = &vcpu->arch.cop0;
 	u32 count;
 
 	kvm_clear_c0_guest_cause(cop0, CAUSEF_DC);
@@ -852,7 +852,7 @@ void kvm_mips_count_enable_cause(struct kvm_vcpu *vcpu)
  */
 int kvm_mips_set_count_ctl(struct kvm_vcpu *vcpu, s64 count_ctl)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct mips_coproc *cop0 = &vcpu->arch.cop0;
 	s64 changed = count_ctl ^ vcpu->arch.count_ctl;
 	s64 delta;
 	ktime_t expire, now;
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 884be4ef99dc..aa5583a7b05b 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -649,7 +649,7 @@ static int kvm_mips_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices)
 static int kvm_mips_get_reg(struct kvm_vcpu *vcpu,
 			    const struct kvm_one_reg *reg)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct mips_coproc *cop0 = &vcpu->arch.cop0;
 	struct mips_fpu_struct *fpu = &vcpu->arch.fpu;
 	int ret;
 	s64 v;
@@ -761,7 +761,7 @@ static int kvm_mips_get_reg(struct kvm_vcpu *vcpu,
 static int kvm_mips_set_reg(struct kvm_vcpu *vcpu,
 			    const struct kvm_one_reg *reg)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct mips_coproc *cop0 = &vcpu->arch.cop0;
 	struct mips_fpu_struct *fpu = &vcpu->arch.fpu;
 	s64 v;
 	s64 vs[2];
@@ -1086,7 +1086,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
 	return kvm_mips_pending_timer(vcpu) ||
-		kvm_read_c0_guest_cause(vcpu->arch.cop0) & C_TI;
+		kvm_read_c0_guest_cause(&vcpu->arch.cop0) & C_TI;
 }
 
 int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu)
@@ -1110,7 +1110,7 @@ int kvm_arch_vcpu_dump_regs(struct kvm_vcpu *vcpu)
 	kvm_debug("\thi: 0x%08lx\n", vcpu->arch.hi);
 	kvm_debug("\tlo: 0x%08lx\n", vcpu->arch.lo);
 
-	cop0 = vcpu->arch.cop0;
+	cop0 = &vcpu->arch.cop0;
 	kvm_debug("\tStatus: 0x%08x, Cause: 0x%08x\n",
 		  kvm_read_c0_guest_status(cop0),
 		  kvm_read_c0_guest_cause(cop0));
@@ -1232,7 +1232,7 @@ static int __kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
 
 	case EXCCODE_TLBS:
 		kvm_debug("TLB ST fault:  cause %#x, status %#x, PC: %p, BadVaddr: %#lx\n",
-			  cause, kvm_read_c0_guest_status(vcpu->arch.cop0), opc,
+			  cause, kvm_read_c0_guest_status(&vcpu->arch.cop0), opc,
 			  badvaddr);
 
 		++vcpu->stat.tlbmiss_st_exits;
@@ -1304,7 +1304,7 @@ static int __kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
 		kvm_get_badinstr(opc, vcpu, &inst);
 		kvm_err("Exception Code: %d, not yet handled, @ PC: %p, inst: 0x%08x  BadVaddr: %#lx Status: %#x\n",
 			exccode, opc, inst, badvaddr,
-			kvm_read_c0_guest_status(vcpu->arch.cop0));
+			kvm_read_c0_guest_status(&vcpu->arch.cop0));
 		kvm_arch_vcpu_dump_regs(vcpu);
 		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		ret = RESUME_HOST;
@@ -1377,7 +1377,7 @@ int noinstr kvm_mips_handle_exit(struct kvm_vcpu *vcpu)
 /* Enable FPU for guest and restore context */
 void kvm_own_fpu(struct kvm_vcpu *vcpu)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct mips_coproc *cop0 = &vcpu->arch.cop0;
 	unsigned int sr, cfg5;
 
 	preempt_disable();
@@ -1421,7 +1421,7 @@ void kvm_own_fpu(struct kvm_vcpu *vcpu)
 /* Enable MSA for guest and restore context */
 void kvm_own_msa(struct kvm_vcpu *vcpu)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct mips_coproc *cop0 = &vcpu->arch.cop0;
 	unsigned int sr, cfg5;
 
 	preempt_disable();
diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
index 3d21cbfa7443..99d5a71e4300 100644
--- a/arch/mips/kvm/vz.c
+++ b/arch/mips/kvm/vz.c
@@ -422,7 +422,7 @@ static void _kvm_vz_restore_htimer(struct kvm_vcpu *vcpu,
  */
 static void kvm_vz_restore_timer(struct kvm_vcpu *vcpu)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct mips_coproc *cop0 = &vcpu->arch.cop0;
 	u32 cause, compare;
 
 	compare = kvm_read_sw_gc0_compare(cop0);
@@ -517,7 +517,7 @@ static void _kvm_vz_save_htimer(struct kvm_vcpu *vcpu,
  */
 static void kvm_vz_save_timer(struct kvm_vcpu *vcpu)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct mips_coproc *cop0 = &vcpu->arch.cop0;
 	u32 gctl0, compare, cause;
 
 	gctl0 = read_c0_guestctl0();
@@ -863,7 +863,7 @@ static unsigned long mips_process_maar(unsigned int op, unsigned long val)
 
 static void kvm_write_maari(struct kvm_vcpu *vcpu, unsigned long val)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct mips_coproc *cop0 = &vcpu->arch.cop0;
 
 	val &= MIPS_MAARI_INDEX;
 	if (val == MIPS_MAARI_INDEX)
@@ -876,7 +876,7 @@ static enum emulation_result kvm_vz_gpsi_cop0(union mips_instruction inst,
 					      u32 *opc, u32 cause,
 					      struct kvm_vcpu *vcpu)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct mips_coproc *cop0 = &vcpu->arch.cop0;
 	enum emulation_result er = EMULATE_DONE;
 	u32 rt, rd, sel;
 	unsigned long curr_pc;
@@ -1911,7 +1911,7 @@ static int kvm_vz_get_one_reg(struct kvm_vcpu *vcpu,
 			      const struct kvm_one_reg *reg,
 			      s64 *v)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct mips_coproc *cop0 = &vcpu->arch.cop0;
 	unsigned int idx;
 
 	switch (reg->id) {
@@ -2081,7 +2081,7 @@ static int kvm_vz_get_one_reg(struct kvm_vcpu *vcpu,
 	case KVM_REG_MIPS_CP0_MAARI:
 		if (!cpu_guest_has_maar || cpu_guest_has_dyn_maar)
 			return -EINVAL;
-		*v = kvm_read_sw_gc0_maari(vcpu->arch.cop0);
+		*v = kvm_read_sw_gc0_maari(&vcpu->arch.cop0);
 		break;
 #ifdef CONFIG_64BIT
 	case KVM_REG_MIPS_CP0_XCONTEXT:
@@ -2135,7 +2135,7 @@ static int kvm_vz_set_one_reg(struct kvm_vcpu *vcpu,
 			      const struct kvm_one_reg *reg,
 			      s64 v)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct mips_coproc *cop0 = &vcpu->arch.cop0;
 	unsigned int idx;
 	int ret = 0;
 	unsigned int cur, change;
@@ -2562,7 +2562,7 @@ static void kvm_vz_vcpu_load_tlb(struct kvm_vcpu *vcpu, int cpu)
 
 static int kvm_vz_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct mips_coproc *cop0 = &vcpu->arch.cop0;
 	bool migrated, all;
 
 	/*
@@ -2704,7 +2704,7 @@ static int kvm_vz_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 static int kvm_vz_vcpu_put(struct kvm_vcpu *vcpu, int cpu)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct mips_coproc *cop0 = &vcpu->arch.cop0;
 
 	if (current->flags & PF_VCPU)
 		kvm_vz_vcpu_save_wired(vcpu);
@@ -3076,7 +3076,7 @@ static void kvm_vz_vcpu_uninit(struct kvm_vcpu *vcpu)
 
 static int kvm_vz_vcpu_setup(struct kvm_vcpu *vcpu)
 {
-	struct mips_coproc *cop0 = vcpu->arch.cop0;
+	struct mips_coproc *cop0 = &vcpu->arch.cop0;
 	unsigned long count_hz = 100*1000*1000; /* default to 100 MHz */
 
 	/*

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]

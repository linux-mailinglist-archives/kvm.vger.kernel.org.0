Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA62A995A3
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 15:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731911AbfHVN4L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 09:56:11 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42300 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfHVN4K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 09:56:10 -0400
Received: by mail-wr1-f67.google.com with SMTP id b16so5510755wrq.9
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2019 06:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uYYk+VSWs9B+t21aWspakKLUywF9Fl0vAMFkw3Q8uEw=;
        b=MrTrr3IgiLWKpURbAsdC5kpxZUNMXR8sFUaMTKo0GgP8WEx5bhqaCr/gJIEFAtn75f
         Q6D0+ODyrqGK5W55o+H44PXrBWmPj1+Izy+CN18yxghXnR/fSlNPGIGhSkb0hq4MvyRu
         bICm+pYr+p1DlqOtHsP8EDhD8DYlRaj6CqasJpBz67oGk6eCQJmN/kEkJ3Nnp3YBmmBz
         8yUrvxAiOZCLO1QCD3ggdnPwNTgcboPOeg6UfihyrLqKTdELkgahRXoUqVGBAZ2ovesW
         mc4Z4EuODlyuwHMnFjsPkGkfkGR5iZxY2XOlPeF3hQWklaT91OOLxpdVdmNNk85cMCMw
         4yLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uYYk+VSWs9B+t21aWspakKLUywF9Fl0vAMFkw3Q8uEw=;
        b=KqP37lG4sMcgTttMTxXQcUgMrmncq7y5vn2g9C/paSeLvo8Yi2s2h5Ebvjetunltoq
         Pc252kMsGCdFdYnZfH/uvt/iBSYNDFavsyTUO4w4fEFAmvpZzSd3cpxsRSVFmLg797CE
         3ReWDacBfLp54wZdQmzM/qn1cIzRc+9VBc6La/QogZGZFKPMEq+U+m2dpvRfds3+TBOU
         F5PuWszoBplLb0Hf5tlQJLoSdwL/zaVtoYCAltfER+1vWK8ulTpIVbzQg1CPqcrkCQLY
         Wo8B6GD8aGLVq0CJk4ileVzCvzeWUJKWW4YLWC2KkNrcJ4Tecq+v6+ulfpN8D3gw5N5K
         hSVA==
X-Gm-Message-State: APjAAAUJSLgPDKOtUjmzxkVqNve88MDcz2wou58yFOrtjuA2Brg32XU4
        cckO0Bm+rPxbzgNTmkqRNc+GqCSY/PNxLH3iTl69TA==
X-Google-Smtp-Source: APXvYqx/84zRL29uUqNeBCV+cfJeS+/Ld1vw57jcfIZYTMt2iOtHDEDLSp2wrHazVnRKAtCnBpaA/dyXQM+isSBaLZM=
X-Received: by 2002:a05:6000:10cf:: with SMTP id b15mr4508377wrx.180.1566482166147;
 Thu, 22 Aug 2019 06:56:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190822084131.114764-1-anup.patel@wdc.com> <20190822084131.114764-11-anup.patel@wdc.com>
 <917cea87-42c0-e50a-6508-d5b577c8b702@amazon.com> <CAAhSdy2QtZRKvs0Hr-mZuVsb7sVkweeW-RpvhObZR009UbA7KA@mail.gmail.com>
 <4fe83f28-3a55-e74c-0d40-1cd556015fea@amazon.com>
In-Reply-To: <4fe83f28-3a55-e74c-0d40-1cd556015fea@amazon.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Thu, 22 Aug 2019 19:25:54 +0530
Message-ID: <CAAhSdy1DWVcJO0piYxCOcSGXw6Niwm_6=ki91UDbiRCdu-HRkQ@mail.gmail.com>
Subject: Re: [PATCH v5 10/20] RISC-V: KVM: Handle MMIO exits for VCPU
To:     Alexander Graf <graf@amazon.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 22, 2019 at 6:55 PM Alexander Graf <graf@amazon.com> wrote:
>
>
>
> On 22.08.19 14:33, Anup Patel wrote:
> > On Thu, Aug 22, 2019 at 5:44 PM Alexander Graf <graf@amazon.com> wrote:
> >>
> >> On 22.08.19 10:44, Anup Patel wrote:
> >>> We will get stage2 page faults whenever Guest/VM access SW emulated
> >>> MMIO device or unmapped Guest RAM.
> >>>
> >>> This patch implements MMIO read/write emulation by extracting MMIO
> >>> details from the trapped load/store instruction and forwarding the
> >>> MMIO read/write to user-space. The actual MMIO emulation will happen
> >>> in user-space and KVM kernel module will only take care of register
> >>> updates before resuming the trapped VCPU.
> >>>
> >>> The handling for stage2 page faults for unmapped Guest RAM will be
> >>> implemeted by a separate patch later.
> >>>
> >>> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> >>> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> >>> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> >>> ---
> >>>    arch/riscv/include/asm/kvm_host.h |  11 +
> >>>    arch/riscv/kvm/mmu.c              |   7 +
> >>>    arch/riscv/kvm/vcpu_exit.c        | 436 +++++++++++++++++++++++++++++-
> >>>    3 files changed, 451 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> >>> index 18f1097f1d8d..4388bace6d70 100644
> >>> --- a/arch/riscv/include/asm/kvm_host.h
> >>> +++ b/arch/riscv/include/asm/kvm_host.h
> >>> @@ -53,6 +53,12 @@ struct kvm_arch {
> >>>        phys_addr_t pgd_phys;
> >>>    };
> >>>
> >>> +struct kvm_mmio_decode {
> >>> +     unsigned long insn;
> >>> +     int len;
> >>> +     int shift;
> >>> +};
> >>> +
> >>>    struct kvm_cpu_context {
> >>>        unsigned long zero;
> >>>        unsigned long ra;
> >>> @@ -141,6 +147,9 @@ struct kvm_vcpu_arch {
> >>>        unsigned long irqs_pending;
> >>>        unsigned long irqs_pending_mask;
> >>>
> >>> +     /* MMIO instruction details */
> >>> +     struct kvm_mmio_decode mmio_decode;
> >>> +
> >>>        /* VCPU power-off state */
> >>>        bool power_off;
> >>>
> >>> @@ -160,6 +169,8 @@ static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
> >>>    int kvm_riscv_setup_vsip(void);
> >>>    void kvm_riscv_cleanup_vsip(void);
> >>>
> >>> +int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long hva,
> >>> +                      bool is_write);
> >>>    void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu);
> >>>    int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm);
> >>>    void kvm_riscv_stage2_free_pgd(struct kvm *kvm);
> >>> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> >>> index 04dd089b86ff..2b965f9aac07 100644
> >>> --- a/arch/riscv/kvm/mmu.c
> >>> +++ b/arch/riscv/kvm/mmu.c
> >>> @@ -61,6 +61,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
> >>>        return 0;
> >>>    }
> >>>
> >>> +int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu, gpa_t gpa, unsigned long hva,
> >>> +                      bool is_write)
> >>> +{
> >>> +     /* TODO: */
> >>> +     return 0;
> >>> +}
> >>> +
> >>>    void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu)
> >>>    {
> >>>        /* TODO: */
> >>> diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
> >>> index e4d7c8f0807a..efc06198c259 100644
> >>> --- a/arch/riscv/kvm/vcpu_exit.c
> >>> +++ b/arch/riscv/kvm/vcpu_exit.c
> >>> @@ -6,9 +6,371 @@
> >>>     *     Anup Patel <anup.patel@wdc.com>
> >>>     */
> >>>
> >>> +#include <linux/bitops.h>
> >>>    #include <linux/errno.h>
> >>>    #include <linux/err.h>
> >>>    #include <linux/kvm_host.h>
> >>> +#include <asm/csr.h>
> >>> +
> >>> +#define INSN_MATCH_LB                0x3
> >>> +#define INSN_MASK_LB         0x707f
> >>> +#define INSN_MATCH_LH                0x1003
> >>> +#define INSN_MASK_LH         0x707f
> >>> +#define INSN_MATCH_LW                0x2003
> >>> +#define INSN_MASK_LW         0x707f
> >>> +#define INSN_MATCH_LD                0x3003
> >>> +#define INSN_MASK_LD         0x707f
> >>> +#define INSN_MATCH_LBU               0x4003
> >>> +#define INSN_MASK_LBU                0x707f
> >>> +#define INSN_MATCH_LHU               0x5003
> >>> +#define INSN_MASK_LHU                0x707f
> >>> +#define INSN_MATCH_LWU               0x6003
> >>> +#define INSN_MASK_LWU                0x707f
> >>> +#define INSN_MATCH_SB                0x23
> >>> +#define INSN_MASK_SB         0x707f
> >>> +#define INSN_MATCH_SH                0x1023
> >>> +#define INSN_MASK_SH         0x707f
> >>> +#define INSN_MATCH_SW                0x2023
> >>> +#define INSN_MASK_SW         0x707f
> >>> +#define INSN_MATCH_SD                0x3023
> >>> +#define INSN_MASK_SD         0x707f
> >>> +
> >>> +#define INSN_MATCH_C_LD              0x6000
> >>> +#define INSN_MASK_C_LD               0xe003
> >>> +#define INSN_MATCH_C_SD              0xe000
> >>> +#define INSN_MASK_C_SD               0xe003
> >>> +#define INSN_MATCH_C_LW              0x4000
> >>> +#define INSN_MASK_C_LW               0xe003
> >>> +#define INSN_MATCH_C_SW              0xc000
> >>> +#define INSN_MASK_C_SW               0xe003
> >>> +#define INSN_MATCH_C_LDSP    0x6002
> >>> +#define INSN_MASK_C_LDSP     0xe003
> >>> +#define INSN_MATCH_C_SDSP    0xe002
> >>> +#define INSN_MASK_C_SDSP     0xe003
> >>> +#define INSN_MATCH_C_LWSP    0x4002
> >>> +#define INSN_MASK_C_LWSP     0xe003
> >>> +#define INSN_MATCH_C_SWSP    0xc002
> >>> +#define INSN_MASK_C_SWSP     0xe003
> >>> +
> >>> +#define INSN_LEN(insn)               ((((insn) & 0x3) < 0x3) ? 2 : 4)
> >>> +
> >>> +#ifdef CONFIG_64BIT
> >>> +#define LOG_REGBYTES         3
> >>> +#else
> >>> +#define LOG_REGBYTES         2
> >>> +#endif
> >>> +#define REGBYTES             (1 << LOG_REGBYTES)
> >>> +
> >>> +#define SH_RD                        7
> >>> +#define SH_RS1                       15
> >>> +#define SH_RS2                       20
> >>> +#define SH_RS2C                      2
> >>> +
> >>> +#define RV_X(x, s, n)                (((x) >> (s)) & ((1 << (n)) - 1))
> >>> +#define RVC_LW_IMM(x)                ((RV_X(x, 6, 1) << 2) | \
> >>> +                              (RV_X(x, 10, 3) << 3) | \
> >>> +                              (RV_X(x, 5, 1) << 6))
> >>> +#define RVC_LD_IMM(x)                ((RV_X(x, 10, 3) << 3) | \
> >>> +                              (RV_X(x, 5, 2) << 6))
> >>> +#define RVC_LWSP_IMM(x)              ((RV_X(x, 4, 3) << 2) | \
> >>> +                              (RV_X(x, 12, 1) << 5) | \
> >>> +                              (RV_X(x, 2, 2) << 6))
> >>> +#define RVC_LDSP_IMM(x)              ((RV_X(x, 5, 2) << 3) | \
> >>> +                              (RV_X(x, 12, 1) << 5) | \
> >>> +                              (RV_X(x, 2, 3) << 6))
> >>> +#define RVC_SWSP_IMM(x)              ((RV_X(x, 9, 4) << 2) | \
> >>> +                              (RV_X(x, 7, 2) << 6))
> >>> +#define RVC_SDSP_IMM(x)              ((RV_X(x, 10, 3) << 3) | \
> >>> +                              (RV_X(x, 7, 3) << 6))
> >>> +#define RVC_RS1S(insn)               (8 + RV_X(insn, SH_RD, 3))
> >>> +#define RVC_RS2S(insn)               (8 + RV_X(insn, SH_RS2C, 3))
> >>> +#define RVC_RS2(insn)                RV_X(insn, SH_RS2C, 5)
> >>> +
> >>> +#define SHIFT_RIGHT(x, y)            \
> >>> +     ((y) < 0 ? ((x) << -(y)) : ((x) >> (y)))
> >>> +
> >>> +#define REG_MASK                     \
> >>> +     ((1 << (5 + LOG_REGBYTES)) - (1 << LOG_REGBYTES))
> >>> +
> >>> +#define REG_OFFSET(insn, pos)                \
> >>> +     (SHIFT_RIGHT((insn), (pos) - LOG_REGBYTES) & REG_MASK)
> >>> +
> >>> +#define REG_PTR(insn, pos, regs)     \
> >>> +     (ulong *)((ulong)(regs) + REG_OFFSET(insn, pos))
> >>> +
> >>> +#define GET_RM(insn)         (((insn) >> 12) & 7)
> >>> +
> >>> +#define GET_RS1(insn, regs)  (*REG_PTR(insn, SH_RS1, regs))
> >>> +#define GET_RS2(insn, regs)  (*REG_PTR(insn, SH_RS2, regs))
> >>> +#define GET_RS1S(insn, regs) (*REG_PTR(RVC_RS1S(insn), 0, regs))
> >>> +#define GET_RS2S(insn, regs) (*REG_PTR(RVC_RS2S(insn), 0, regs))
> >>> +#define GET_RS2C(insn, regs) (*REG_PTR(insn, SH_RS2C, regs))
> >>> +#define GET_SP(regs)         (*REG_PTR(2, 0, regs))
> >>> +#define SET_RD(insn, regs, val)      (*REG_PTR(insn, SH_RD, regs) = (val))
> >>> +#define IMM_I(insn)          ((s32)(insn) >> 20)
> >>> +#define IMM_S(insn)          (((s32)(insn) >> 25 << 5) | \
> >>> +                              (s32)(((insn) >> 7) & 0x1f))
> >>> +#define MASK_FUNCT3          0x7000
> >>> +
> >>> +#define STR(x)                       XSTR(x)
> >>> +#define XSTR(x)                      #x
> >>> +
> >>> +/* TODO: Handle traps due to unpriv load and redirect it back to VS-mode */
> >>> +static ulong get_insn(struct kvm_vcpu *vcpu)
> >>> +{
> >>> +     ulong __sepc = vcpu->arch.guest_context.sepc;
> >>> +     ulong __hstatus, __sstatus, __vsstatus;
> >>> +#ifdef CONFIG_RISCV_ISA_C
> >>> +     ulong rvc_mask = 3, tmp;
> >>> +#endif
> >>> +     ulong flags, val;
> >>> +
> >>> +     local_irq_save(flags);
> >>> +
> >>> +     __vsstatus = csr_read(CSR_VSSTATUS);
> >>> +     __sstatus = csr_read(CSR_SSTATUS);
> >>> +     __hstatus = csr_read(CSR_HSTATUS);
> >>> +
> >>> +     csr_write(CSR_VSSTATUS, __vsstatus | SR_MXR);
> >>> +     csr_write(CSR_SSTATUS, vcpu->arch.guest_context.sstatus | SR_MXR);
> >>> +     csr_write(CSR_HSTATUS, vcpu->arch.guest_context.hstatus | HSTATUS_SPRV);
> >>
> >> What happens when the insn load triggers a page fault, maybe because the
> >> guest was malicious and did
> >>
> >>     1) Run on page 0x1000
> >>     2) Remove map for 0x1000, do *not* flush TLB
> >>     3) Trigger MMIO
> >>
> >> That would DOS the host here, as the host kernel would continue running
> >> in guest address space, right?
> >
> > Yes, we can certainly fault while accessing Guest instruction. We will
> > be fixing this issue in a followup series. We have mentioned this in cover
> > letter as well.
>
> I don't think the cover letter is the right place for such a comment.
> Please definitely put it into the code as well, pointing out that this
> is a known bug. Or even better yet: Fix it up properly :).
>
> In fact, with a bug that dramatic, I'm not even sure we can safely
> include the code. We're consciously allowing user space to DOS the kernel.

There is already a TODO comment above get_insn() function.

>
> >
> > BTW, RISC-V spec is going to further improve to provide easy
> > access of faulting instruction to Hypervisor.
> > (Refer, https://github.com/riscv/riscv-isa-manual/issues/431)
>
> Yes, we have similar extensions on other archs. Is this going to be an
> optional addition or a mandatory bit of the hypervisor spec? If it's not
> mandatory, we can not rely on it, so the current path has to be safe.

Yes, it's going to be optional so we are certainly going to fix this issue
here.

This issue discussed in previous patch reviews. We have already
agreed to fix this in next revision.

Regards,
Anup

>
>
> Alex

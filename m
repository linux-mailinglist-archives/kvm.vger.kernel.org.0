Return-Path: <kvm+bounces-52535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00E1EB066AC
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 21:17:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7CD517AA6D
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 19:17:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0966E2BEC42;
	Tue, 15 Jul 2025 19:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MJVbk+vA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B237B2BE7DF
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 19:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752606844; cv=none; b=j6/p4CJV6VGPM2LEdECHfC698DDik1G/0oVPXuNkkGthTzFGPJzhFRoCFHlWnnsupFAx86afCUS348UagiSmlr4O7qaPuquEVgO0zUBTG9DD7BjhMj/3Y4EaPOkmFZSgTAo5olI93cClvk2PxjdrachcQBsoKfCpGgcTxO9Baic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752606844; c=relaxed/simple;
	bh=g4EY3GcQ4ex3GhicME9ny7ZupfQzKGhC6znyjvt+ukQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=tLzd513kk0YzqpmRGJ3Fz0LYVQNX3ZGo657AgD6GHmNkskZZYZtLjT2vFCa+NXYILER7THryb+JXp6TDxJV0+HAs55kxRJ/nKAEpFj7F7k0QEvLfzjv9pgHP00xwYSOFtYGYlsoYqtK4NSLZMLhugb1p3vnrh95H2Xvaq8HOTm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MJVbk+vA; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b31cc625817so129113a12.0
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 12:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752606839; x=1753211639; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I96M5BONDvYa94oI9AR46CqkJnLsQvQIOmBThkoD6nk=;
        b=MJVbk+vAz+LEur3ru8zNMGqdXBV0Ksx3iYfwTzJCT84aEIDtw2vHeS+do80k3J+FM2
         uzunLMLiW+/yB5M3zmeKenL6TwfyCU6GkRteux+FT/GDSjA530aKU1FexeYUQNUif9Ne
         /LVlJUG1ql3J1WtSa0Gmj3gCsHnqPIzNVq62TiuVBm+5Tp/WQJHMlqUowSmxDBX7OeJt
         ORfnY1YgCII10V+dGarMg30wxo3jaChmHkmbr9NrBf9C/RH46LGZm2Tz+L/YwdRydb8M
         cbaw3fvuhJlsA/aEoiDfygJm6kh8VJ+RzoVHFPLaSw5IJEeAe0cnmdadeMJzAp3Iah3N
         w1Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752606839; x=1753211639;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I96M5BONDvYa94oI9AR46CqkJnLsQvQIOmBThkoD6nk=;
        b=wzwMxkurANs9Xbeoaah36y5wzaksMIyFw879SbT+nhjzcrAoO84++A9I61VK+8GHko
         Fs9uwNk795R8Pu4ay96BAwshnXnIha4zWPghYpkM5y60LhQDlKoIivImn98PmymUsDsg
         k4H1+5GblhI6tDvxEk1Gxnjl40XzzB59cokpJK4ez08X1PMZGHv77xntKKaIH4dYcc23
         yscvE0yxzfciizFNgikWoBlvzQNSkXnxfvHa/q0hU2SdKy7auyrfZTIKNT3C9g0ap5LK
         QbOFusYi/bt0wmWe5NDcLOlfXnO/PBFfqTDXEDdYs3QPBAwRAJ/pHPWAfIgFPkvDqWft
         /Ynw==
X-Forwarded-Encrypted: i=1; AJvYcCV97WnJ3JbQz4Tb1FZ4k/MAkgQWb7zySNPiCPw17WRJ+eoBn0QGX6YVOfyGzMrfPkrP2Dw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzN3uEoT6VtnhQ+27vkigEumcucBqzKOGYNvqFuHCnhrY20mgz1
	a97vSMjjzpYDHsLokkhxUp6PXXafrB2fd2EGQvsmW2t/uyKLL9M7q9SvEsOqRtvFW77ex08uCGv
	OX6Q0uQ==
X-Google-Smtp-Source: AGHT+IHTSLpmAcDR/KHTlQxkGg8zbphK5QuneIKG/sp5LkJJLM8hcwjvNv2rLVV0WF1zPenHlQAnIGtKCy4=
X-Received: from pjboh11.prod.google.com ([2002:a17:90b:3a4b:b0:312:e914:4548])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3d0e:b0:23c:6d5e:db4e
 with SMTP id d9443c01a7336-23e1a43ad36mr76182785ad.8.1752606838933; Tue, 15
 Jul 2025 12:13:58 -0700 (PDT)
Date: Tue, 15 Jul 2025 12:13:57 -0700
In-Reply-To: <20250715190638.1899116-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250715190638.1899116-1-seanjc@google.com>
Message-ID: <aHaodQ0NuP68I9fI@google.com>
Subject: Re: [PATCH] KVM: x86: Don't (re)check L1 intercepts when completing
 userspace I/O
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 15, 2025, Sean Christopherson wrote:
> When completing emulation of instruction that generated a userspace exit
> for I/O, don't recheck L1 intercepts as KVM has already finished that
> phase of instruction execution, i.e. has already committed to allowing L2
> to perform I/O.  If L1 (or host userspace) modifies the I/O permission
> bitmaps during the exit to userspace,  KVM will treat the access as being
> intercepted despite already having emulated the I/O access.
> 
> Pivot on EMULTYPE_NO_DECODE to detect that KVM is completing emulation.
> Of the three users of EMULTYPE_NO_DECODE, only complete_emulated_io() (the
> intended "recipient") can reach the code in question.  gp_interception()'s
> use is mutually exclusive with is_guest_mode(), and
> complete_emulated_insn_gp() unconditionally pairs EMULTYPE_NO_DECODE with
> EMULTYPE_SKIP.
> 
> The bad behavior was detected by a syzkaller program that toggles port I/O
> interception during the userspace I/O exit, ultimately resulting in a WARN
> on vcpu->arch.pio.count being non-zero due to KVM no completing emulation
> of the I/O instruction.
> 
>   WARNING: CPU: 23 PID: 1083 at arch/x86/kvm/x86.c:8039 emulator_pio_in_out+0x154/0x170 [kvm]
>   Modules linked in: kvm_intel kvm irqbypass
>   CPU: 23 UID: 1000 PID: 1083 Comm: repro Not tainted 6.16.0-rc5-c1610d2d66b1-next-vm #74 NONE
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
>   RIP: 0010:emulator_pio_in_out+0x154/0x170 [kvm]
>   PKRU: 55555554
>   Call Trace:
>    <TASK>
>    kvm_fast_pio+0xd6/0x1d0 [kvm]
>    vmx_handle_exit+0x149/0x610 [kvm_intel]
>    kvm_arch_vcpu_ioctl_run+0xda8/0x1ac0 [kvm]
>    kvm_vcpu_ioctl+0x244/0x8c0 [kvm]
>    __x64_sys_ioctl+0x8a/0xd0
>    do_syscall_64+0x5d/0xc60
>    entry_SYSCALL_64_after_hwframe+0x4b/0x53
>    </TASK>
> 
> Fixes: 8a76d7f25f8f ("KVM: x86: Add x86 callback for intercept check")
> Cc: stable@vger.kernel.org
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Here's the syzkaller C reproducer.  The splat was originally hit on a Google-internal
kernel.  To repro on an upstream kernel, commit 79a14afc6090 ("KVM: nVMX: Synthesize
nested VM-Exit for supported emulation intercepts") needs to be reverted due to
the reproducer generating the port I/O accesses only in L2, i.e. synthesizing an
exit to L1 effectively hides the bug.

// autogenerated by syzkaller (https://github.com/google/syzkaller)

#define _GNU_SOURCE

#include <endian.h>
#include <errno.h>
#include <fcntl.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>

#include <linux/kvm.h>

#define BITMASK(bf_off, bf_len) (((1ull << (bf_len)) - 1) << (bf_off))
#define STORE_BY_BITMASK(type, htobe, addr, val, bf_off, bf_len)               \
  *(type*)(addr) =                                                             \
      htobe((htobe(*(type*)(addr)) & ~BITMASK((bf_off), (bf_len))) |           \
            (((type)(val) << (bf_off)) & BITMASK((bf_off), (bf_len))))

#define X86_ADDR_TEXT 0x0000
#define X86_ADDR_PD_IOAPIC 0x0000
#define X86_ADDR_GDT 0x1000
#define X86_ADDR_LDT 0x1800
#define X86_ADDR_PML4 0x2000
#define X86_ADDR_PDP 0x3000
#define X86_ADDR_PD 0x4000
#define X86_ADDR_STACK0 0x0f80
#define X86_ADDR_VAR_HLT 0x2800
#define X86_ADDR_VAR_SYSRET 0x2808
#define X86_ADDR_VAR_SYSEXIT 0x2810
#define X86_ADDR_VAR_IDT 0x3800
#define X86_ADDR_VAR_TSS64 0x3a00
#define X86_ADDR_VAR_TSS64_CPL3 0x3c00
#define X86_ADDR_VAR_TSS16 0x3d00
#define X86_ADDR_VAR_TSS16_2 0x3e00
#define X86_ADDR_VAR_TSS16_CPL3 0x3f00
#define X86_ADDR_VAR_TSS32 0x4800
#define X86_ADDR_VAR_TSS32_2 0x4a00
#define X86_ADDR_VAR_TSS32_CPL3 0x4c00
#define X86_ADDR_VAR_TSS32_VM86 0x4e00
#define X86_ADDR_VAR_VMXON_PTR 0x5f00
#define X86_ADDR_VAR_VMCS_PTR 0x5f08
#define X86_ADDR_VAR_VMEXIT_PTR 0x5f10
#define X86_ADDR_VAR_VMWRITE_FLD 0x5f18
#define X86_ADDR_VAR_VMWRITE_VAL 0x5f20
#define X86_ADDR_VAR_VMXON 0x6000
#define X86_ADDR_VAR_VMCS 0x7000
#define X86_ADDR_VAR_VMEXIT_CODE 0x9000
#define X86_ADDR_VAR_USER_CODE 0x9100
#define X86_ADDR_VAR_USER_CODE2 0x9120
#define X86_ADDR_SMRAM 0x30000
#define X86_ADDR_EXIT 0x40000
#define X86_ADDR_UEXIT (X86_ADDR_EXIT + 256)
#define X86_ADDR_DIRTY_PAGES 0x41000
#define X86_ADDR_USER_CODE 0x50000
#define X86_ADDR_EXECUTOR_CODE 0x54000
#define X86_ADDR_SCRATCH_CODE 0x58000
#define X86_ADDR_UNUSED 0x200000
#define X86_ADDR_IOAPIC 0xfec00000

#define X86_CR0_PE 1ULL
#define X86_CR0_MP (1ULL << 1)
#define X86_CR0_EM (1ULL << 2)
#define X86_CR0_TS (1ULL << 3)
#define X86_CR0_ET (1ULL << 4)
#define X86_CR0_NE (1ULL << 5)
#define X86_CR0_WP (1ULL << 16)
#define X86_CR0_AM (1ULL << 18)
#define X86_CR0_NW (1ULL << 29)
#define X86_CR0_CD (1ULL << 30)
#define X86_CR0_PG (1ULL << 31)

#define X86_CR4_VME 1ULL
#define X86_CR4_PVI (1ULL << 1)
#define X86_CR4_TSD (1ULL << 2)
#define X86_CR4_DE (1ULL << 3)
#define X86_CR4_PSE (1ULL << 4)
#define X86_CR4_PAE (1ULL << 5)
#define X86_CR4_MCE (1ULL << 6)
#define X86_CR4_PGE (1ULL << 7)
#define X86_CR4_PCE (1ULL << 8)
#define X86_CR4_OSFXSR (1ULL << 8)
#define X86_CR4_OSXMMEXCPT (1ULL << 10)
#define X86_CR4_UMIP (1ULL << 11)
#define X86_CR4_VMXE (1ULL << 13)
#define X86_CR4_SMXE (1ULL << 14)
#define X86_CR4_FSGSBASE (1ULL << 16)
#define X86_CR4_PCIDE (1ULL << 17)
#define X86_CR4_OSXSAVE (1ULL << 18)
#define X86_CR4_SMEP (1ULL << 20)
#define X86_CR4_SMAP (1ULL << 21)
#define X86_CR4_PKE (1ULL << 22)

#define X86_EFER_SCE 1ULL
#define X86_EFER_LME (1ULL << 8)
#define X86_EFER_LMA (1ULL << 10)
#define X86_EFER_NXE (1ULL << 11)
#define X86_EFER_SVME (1ULL << 12)
#define X86_EFER_LMSLE (1ULL << 13)
#define X86_EFER_FFXSR (1ULL << 14)
#define X86_EFER_TCE (1ULL << 15)
#define X86_PDE32_PRESENT 1UL
#define X86_PDE32_RW (1UL << 1)
#define X86_PDE32_USER (1UL << 2)
#define X86_PDE32_PS (1UL << 7)
#define X86_PDE64_PRESENT 1
#define X86_PDE64_RW (1ULL << 1)
#define X86_PDE64_USER (1ULL << 2)
#define X86_PDE64_ACCESSED (1ULL << 5)
#define X86_PDE64_DIRTY (1ULL << 6)
#define X86_PDE64_PS (1ULL << 7)
#define X86_PDE64_G (1ULL << 8)

#define X86_SEL_LDT (1 << 3)
#define X86_SEL_CS16 (2 << 3)
#define X86_SEL_DS16 (3 << 3)
#define X86_SEL_CS16_CPL3 ((4 << 3) + 3)
#define X86_SEL_DS16_CPL3 ((5 << 3) + 3)
#define X86_SEL_CS32 (6 << 3)
#define X86_SEL_DS32 (7 << 3)
#define X86_SEL_CS32_CPL3 ((8 << 3) + 3)
#define X86_SEL_DS32_CPL3 ((9 << 3) + 3)
#define X86_SEL_CS64 (10 << 3)
#define X86_SEL_DS64 (11 << 3)
#define X86_SEL_CS64_CPL3 ((12 << 3) + 3)
#define X86_SEL_DS64_CPL3 ((13 << 3) + 3)
#define X86_SEL_CGATE16 (14 << 3)
#define X86_SEL_TGATE16 (15 << 3)
#define X86_SEL_CGATE32 (16 << 3)
#define X86_SEL_TGATE32 (17 << 3)
#define X86_SEL_CGATE64 (18 << 3)
#define X86_SEL_CGATE64_HI (19 << 3)
#define X86_SEL_TSS16 (20 << 3)
#define X86_SEL_TSS16_2 (21 << 3)
#define X86_SEL_TSS16_CPL3 ((22 << 3) + 3)
#define X86_SEL_TSS32 (23 << 3)
#define X86_SEL_TSS32_2 (24 << 3)
#define X86_SEL_TSS32_CPL3 ((25 << 3) + 3)
#define X86_SEL_TSS32_VM86 (26 << 3)
#define X86_SEL_TSS64 (27 << 3)
#define X86_SEL_TSS64_HI (28 << 3)
#define X86_SEL_TSS64_CPL3 ((29 << 3) + 3)
#define X86_SEL_TSS64_CPL3_HI (30 << 3)

#define X86_MSR_IA32_FEATURE_CONTROL 0x3a
#define X86_MSR_IA32_VMX_BASIC 0x480
#define X86_MSR_IA32_SMBASE 0x9e
#define X86_MSR_IA32_SYSENTER_CS 0x174
#define X86_MSR_IA32_SYSENTER_ESP 0x175
#define X86_MSR_IA32_SYSENTER_EIP 0x176
#define X86_MSR_IA32_STAR 0xC0000081
#define X86_MSR_IA32_LSTAR 0xC0000082
#define X86_MSR_IA32_VMX_PROCBASED_CTLS2 0x48B

#define X86_NEXT_INSN $0xbadc0de
#define X86_PREFIX_SIZE 0xba1d

#define KVM_MAX_VCPU 4
#define KVM_PAGE_SIZE (1 << 12)
#define KVM_GUEST_MEM_SIZE (1024 * KVM_PAGE_SIZE)
#define SZ_4K 0x00001000
#define SZ_64K 0x00010000
#define GENMASK_ULL(h, l)                                                      \
  (((~0ULL) - (1ULL << (l)) + 1ULL) & (~0ULL >> (63 - (h))))
#define ARM64_ADDR_GICD_BASE 0x08000000
#define ARM64_ADDR_GITS_BASE 0x08080000
#define ARM64_ADDR_GICR_BASE 0x080a0000
#define ARM64_ADDR_ITS_TABLES 0xc0000000
#define ARM64_ADDR_EXIT 0xdddd0000
#define ARM64_ADDR_UEXIT (ARM64_ADDR_EXIT + 256)
#define ARM64_ADDR_DIRTY_PAGES 0xdddd1000
#define ARM64_ADDR_USER_CODE 0xeeee0000
#define ARM64_ADDR_EXECUTOR_CODE 0xeeee8000
#define ARM64_ADDR_SCRATCH_CODE 0xeeef0000
#define ARM64_ADDR_EL1_STACK_BOTTOM 0xffff1000
#define ITS_MAX_DEVICES 16
#define ARM64_ADDR_ITS_DEVICE_TABLE (ARM64_ADDR_ITS_TABLES)
#define ARM64_ADDR_ITS_COLL_TABLE (ARM64_ADDR_ITS_DEVICE_TABLE + SZ_64K)
#define ARM64_ADDR_ITS_CMDQ_BASE (ARM64_ADDR_ITS_COLL_TABLE + SZ_64K)
#define ARM64_ADDR_ITS_ITT_TABLES (ARM64_ADDR_ITS_CMDQ_BASE + SZ_64K)
#define ARM64_ADDR_ITS_PROP_TABLE                                              \
  (ARM64_ADDR_ITS_ITT_TABLES + SZ_64K * ITS_MAX_DEVICES)
#define ARM64_ADDR_ITS_PEND_TABLES (ARM64_ADDR_ITS_PROP_TABLE + SZ_64K)

#define GUEST_CODE __attribute__((section("guest")))
#define noinline __attribute__((noinline))
extern char *__start_guest, *__stop_guest;

typedef enum {
  SYZOS_API_UEXIT,
  SYZOS_API_CODE,
  SYZOS_API_CPUID,
  SYZOS_API_STOP,
} syzos_api_id;

struct api_call_header {
  uint64_t call;
  uint64_t size;
};

struct api_call_uexit {
  struct api_call_header header;
  uint64_t exit_code;
};

struct api_call_code {
  struct api_call_header header;
  uint8_t insns[];
};

struct api_call_cpuid {
  struct api_call_header header;
  uint32_t eax;
  uint32_t ecx;
};

static void guest_uexit(uint64_t exit_code);
static void guest_execute_code(uint8_t* insns, uint64_t size);
static void guest_cpuid(uint32_t eax, uint32_t ecx);

typedef enum {
  UEXIT_END = (uint64_t)-1,
  UEXIT_IRQ = (uint64_t)-2,
  UEXIT_ASSERT = (uint64_t)-3,
} uexit_code;
__attribute__((used)) GUEST_CODE static void guest_main(uint64_t size,
                                                        uint64_t cpu)
{
  uint64_t addr = X86_ADDR_USER_CODE + cpu * KVM_PAGE_SIZE;
  while (size >= sizeof(struct api_call_header)) {
    struct api_call_header* cmd = (struct api_call_header*)addr;
    if (cmd->call >= SYZOS_API_STOP)
      return;
    if (cmd->size > size)
      return;
    switch (cmd->call) {
    case SYZOS_API_UEXIT: {
      struct api_call_uexit* ucmd = (struct api_call_uexit*)cmd;
      guest_uexit(ucmd->exit_code);
      break;
    }
    case SYZOS_API_CODE: {
      struct api_call_code* ccmd = (struct api_call_code*)cmd;
      guest_execute_code(ccmd->insns,
                         cmd->size - sizeof(struct api_call_header));
      break;
    }
    case SYZOS_API_CPUID: {
      struct api_call_cpuid* ccmd = (struct api_call_cpuid*)cmd;
      guest_cpuid(ccmd->eax, ccmd->ecx);
    }
    }
    addr += cmd->size;
    size -= cmd->size;
  };
  guest_uexit((uint64_t)-1);
}

GUEST_CODE static noinline void guest_execute_code(uint8_t* insns,
                                                   uint64_t size)
{
  volatile void (*fn)() = (volatile void (*)())insns;
  fn();
}
GUEST_CODE static noinline void guest_uexit(uint64_t exit_code)
{
  volatile uint64_t* ptr = (volatile uint64_t*)X86_ADDR_UEXIT;
  *ptr = exit_code;
}

GUEST_CODE static noinline void guest_cpuid(uint32_t eax, uint32_t ecx)
{
  asm volatile("cpuid\n" : : "a"(eax), "c"(ecx) : "rbx", "rdx");
}

#define X86_ADDR_TEXT 0x0000
#define X86_ADDR_PD_IOAPIC 0x0000
#define X86_ADDR_GDT 0x1000
#define X86_ADDR_LDT 0x1800
#define X86_ADDR_PML4 0x2000
#define X86_ADDR_PDP 0x3000
#define X86_ADDR_PD 0x4000
#define X86_ADDR_STACK0 0x0f80
#define X86_ADDR_VAR_HLT 0x2800
#define X86_ADDR_VAR_SYSRET 0x2808
#define X86_ADDR_VAR_SYSEXIT 0x2810
#define X86_ADDR_VAR_IDT 0x3800
#define X86_ADDR_VAR_TSS64 0x3a00
#define X86_ADDR_VAR_TSS64_CPL3 0x3c00
#define X86_ADDR_VAR_TSS16 0x3d00
#define X86_ADDR_VAR_TSS16_2 0x3e00
#define X86_ADDR_VAR_TSS16_CPL3 0x3f00
#define X86_ADDR_VAR_TSS32 0x4800
#define X86_ADDR_VAR_TSS32_2 0x4a00
#define X86_ADDR_VAR_TSS32_CPL3 0x4c00
#define X86_ADDR_VAR_TSS32_VM86 0x4e00
#define X86_ADDR_VAR_VMXON_PTR 0x5f00
#define X86_ADDR_VAR_VMCS_PTR 0x5f08
#define X86_ADDR_VAR_VMEXIT_PTR 0x5f10
#define X86_ADDR_VAR_VMWRITE_FLD 0x5f18
#define X86_ADDR_VAR_VMWRITE_VAL 0x5f20
#define X86_ADDR_VAR_VMXON 0x6000
#define X86_ADDR_VAR_VMCS 0x7000
#define X86_ADDR_VAR_VMEXIT_CODE 0x9000
#define X86_ADDR_VAR_USER_CODE 0x9100
#define X86_ADDR_VAR_USER_CODE2 0x9120
#define X86_ADDR_SMRAM 0x30000
#define X86_ADDR_EXIT 0x40000
#define X86_ADDR_UEXIT (X86_ADDR_EXIT + 256)
#define X86_ADDR_DIRTY_PAGES 0x41000
#define X86_ADDR_USER_CODE 0x50000
#define X86_ADDR_EXECUTOR_CODE 0x54000
#define X86_ADDR_SCRATCH_CODE 0x58000
#define X86_ADDR_UNUSED 0x200000
#define X86_ADDR_IOAPIC 0xfec00000

#define X86_CR0_PE 1ULL
#define X86_CR0_MP (1ULL << 1)
#define X86_CR0_EM (1ULL << 2)
#define X86_CR0_TS (1ULL << 3)
#define X86_CR0_ET (1ULL << 4)
#define X86_CR0_NE (1ULL << 5)
#define X86_CR0_WP (1ULL << 16)
#define X86_CR0_AM (1ULL << 18)
#define X86_CR0_NW (1ULL << 29)
#define X86_CR0_CD (1ULL << 30)
#define X86_CR0_PG (1ULL << 31)

#define X86_CR4_VME 1ULL
#define X86_CR4_PVI (1ULL << 1)
#define X86_CR4_TSD (1ULL << 2)
#define X86_CR4_DE (1ULL << 3)
#define X86_CR4_PSE (1ULL << 4)
#define X86_CR4_PAE (1ULL << 5)
#define X86_CR4_MCE (1ULL << 6)
#define X86_CR4_PGE (1ULL << 7)
#define X86_CR4_PCE (1ULL << 8)
#define X86_CR4_OSFXSR (1ULL << 8)
#define X86_CR4_OSXMMEXCPT (1ULL << 10)
#define X86_CR4_UMIP (1ULL << 11)
#define X86_CR4_VMXE (1ULL << 13)
#define X86_CR4_SMXE (1ULL << 14)
#define X86_CR4_FSGSBASE (1ULL << 16)
#define X86_CR4_PCIDE (1ULL << 17)
#define X86_CR4_OSXSAVE (1ULL << 18)
#define X86_CR4_SMEP (1ULL << 20)
#define X86_CR4_SMAP (1ULL << 21)
#define X86_CR4_PKE (1ULL << 22)

#define X86_EFER_SCE 1ULL
#define X86_EFER_LME (1ULL << 8)
#define X86_EFER_LMA (1ULL << 10)
#define X86_EFER_NXE (1ULL << 11)
#define X86_EFER_SVME (1ULL << 12)
#define X86_EFER_LMSLE (1ULL << 13)
#define X86_EFER_FFXSR (1ULL << 14)
#define X86_EFER_TCE (1ULL << 15)
#define X86_PDE32_PRESENT 1UL
#define X86_PDE32_RW (1UL << 1)
#define X86_PDE32_USER (1UL << 2)
#define X86_PDE32_PS (1UL << 7)
#define X86_PDE64_PRESENT 1
#define X86_PDE64_RW (1ULL << 1)
#define X86_PDE64_USER (1ULL << 2)
#define X86_PDE64_ACCESSED (1ULL << 5)
#define X86_PDE64_DIRTY (1ULL << 6)
#define X86_PDE64_PS (1ULL << 7)
#define X86_PDE64_G (1ULL << 8)

#define X86_SEL_LDT (1 << 3)
#define X86_SEL_CS16 (2 << 3)
#define X86_SEL_DS16 (3 << 3)
#define X86_SEL_CS16_CPL3 ((4 << 3) + 3)
#define X86_SEL_DS16_CPL3 ((5 << 3) + 3)
#define X86_SEL_CS32 (6 << 3)
#define X86_SEL_DS32 (7 << 3)
#define X86_SEL_CS32_CPL3 ((8 << 3) + 3)
#define X86_SEL_DS32_CPL3 ((9 << 3) + 3)
#define X86_SEL_CS64 (10 << 3)
#define X86_SEL_DS64 (11 << 3)
#define X86_SEL_CS64_CPL3 ((12 << 3) + 3)
#define X86_SEL_DS64_CPL3 ((13 << 3) + 3)
#define X86_SEL_CGATE16 (14 << 3)
#define X86_SEL_TGATE16 (15 << 3)
#define X86_SEL_CGATE32 (16 << 3)
#define X86_SEL_TGATE32 (17 << 3)
#define X86_SEL_CGATE64 (18 << 3)
#define X86_SEL_CGATE64_HI (19 << 3)
#define X86_SEL_TSS16 (20 << 3)
#define X86_SEL_TSS16_2 (21 << 3)
#define X86_SEL_TSS16_CPL3 ((22 << 3) + 3)
#define X86_SEL_TSS32 (23 << 3)
#define X86_SEL_TSS32_2 (24 << 3)
#define X86_SEL_TSS32_CPL3 ((25 << 3) + 3)
#define X86_SEL_TSS32_VM86 (26 << 3)
#define X86_SEL_TSS64 (27 << 3)
#define X86_SEL_TSS64_HI (28 << 3)
#define X86_SEL_TSS64_CPL3 ((29 << 3) + 3)
#define X86_SEL_TSS64_CPL3_HI (30 << 3)

#define X86_MSR_IA32_FEATURE_CONTROL 0x3a
#define X86_MSR_IA32_VMX_BASIC 0x480
#define X86_MSR_IA32_SMBASE 0x9e
#define X86_MSR_IA32_SYSENTER_CS 0x174
#define X86_MSR_IA32_SYSENTER_ESP 0x175
#define X86_MSR_IA32_SYSENTER_EIP 0x176
#define X86_MSR_IA32_STAR 0xC0000081
#define X86_MSR_IA32_LSTAR 0xC0000082
#define X86_MSR_IA32_VMX_PROCBASED_CTLS2 0x48B

#define X86_NEXT_INSN $0xbadc0de
#define X86_PREFIX_SIZE 0xba1d

#define KVM_MAX_VCPU 4
#define KVM_PAGE_SIZE (1 << 12)
#define KVM_GUEST_MEM_SIZE (1024 * KVM_PAGE_SIZE)
#define SZ_4K 0x00001000
#define SZ_64K 0x00010000
#define GENMASK_ULL(h, l)                                                      \
  (((~0ULL) - (1ULL << (l)) + 1ULL) & (~0ULL >> (63 - (h))))
#define ARM64_ADDR_GICD_BASE 0x08000000
#define ARM64_ADDR_GITS_BASE 0x08080000
#define ARM64_ADDR_GICR_BASE 0x080a0000
#define ARM64_ADDR_ITS_TABLES 0xc0000000
#define ARM64_ADDR_EXIT 0xdddd0000
#define ARM64_ADDR_UEXIT (ARM64_ADDR_EXIT + 256)
#define ARM64_ADDR_DIRTY_PAGES 0xdddd1000
#define ARM64_ADDR_USER_CODE 0xeeee0000
#define ARM64_ADDR_EXECUTOR_CODE 0xeeee8000
#define ARM64_ADDR_SCRATCH_CODE 0xeeef0000
#define ARM64_ADDR_EL1_STACK_BOTTOM 0xffff1000
#define ITS_MAX_DEVICES 16
#define ARM64_ADDR_ITS_DEVICE_TABLE (ARM64_ADDR_ITS_TABLES)
#define ARM64_ADDR_ITS_COLL_TABLE (ARM64_ADDR_ITS_DEVICE_TABLE + SZ_64K)
#define ARM64_ADDR_ITS_CMDQ_BASE (ARM64_ADDR_ITS_COLL_TABLE + SZ_64K)
#define ARM64_ADDR_ITS_ITT_TABLES (ARM64_ADDR_ITS_CMDQ_BASE + SZ_64K)
#define ARM64_ADDR_ITS_PROP_TABLE                                              \
  (ARM64_ADDR_ITS_ITT_TABLES + SZ_64K * ITS_MAX_DEVICES)
#define ARM64_ADDR_ITS_PEND_TABLES (ARM64_ADDR_ITS_PROP_TABLE + SZ_64K)
const char kvm_asm16_cpl3[] =
    "\x0f\x20\xc0\x66\x83\xc8\x01\x0f\x22\xc0\xb8\xa0\x00\x0f\x00\xd8\xb8\x2b"
    "\x00\x8e\xd8\x8e\xc0\x8e\xe0\x8e\xe8\xbc\x00\x01\xc7\x06\x00\x01\x1d\xba"
    "\xc7\x06\x02\x01\x23\x00\xc7\x06\x04\x01\x00\x01\xc7\x06\x06\x01\x2b\x00"
    "\xcb";
const char kvm_asm32_paged[] = "\x0f\x20\xc0\x0d\x00\x00\x00\x80\x0f\x22\xc0";
const char kvm_asm32_vm86[] =
    "\x66\xb8\xb8\x00\x0f\x00\xd8\xea\x00\x00\x00\x00\xd0\x00";
const char kvm_asm32_paged_vm86[] =
    "\x0f\x20\xc0\x0d\x00\x00\x00\x80\x0f\x22\xc0\x66\xb8\xb8\x00\x0f\x00\xd8"
    "\xea\x00\x00\x00\x00\xd0\x00";
const char kvm_asm64_enable_long[] =
    "\x0f\x20\xc0\x0d\x00\x00\x00\x80\x0f\x22\xc0\xea\xde\xc0\xad\x0b\x50\x00"
    "\x48\xc7\xc0\xd8\x00\x00\x00\x0f\x00\xd8";
const char kvm_asm64_init_vm[] =
    "\x0f\x20\xc0\x0d\x00\x00\x00\x80\x0f\x22\xc0\xea\xde\xc0\xad\x0b\x50\x00"
    "\x48\xc7\xc0\xd8\x00\x00\x00\x0f\x00\xd8\x48\xc7\xc1\x3a\x00\x00\x00\x0f"
    "\x32\x48\x83\xc8\x05\x0f\x30\x0f\x20\xe0\x48\x0d\x00\x20\x00\x00\x0f\x22"
    "\xe0\x48\xc7\xc1\x80\x04\x00\x00\x0f\x32\x48\xc7\xc2\x00\x60\x00\x00\x89"
    "\x02\x48\xc7\xc2\x00\x70\x00\x00\x89\x02\x48\xc7\xc0\x00\x5f\x00\x00\xf3"
    "\x0f\xc7\x30\x48\xc7\xc0\x08\x5f\x00\x00\x66\x0f\xc7\x30\x0f\xc7\x30\x48"
    "\xc7\xc1\x81\x04\x00\x00\x0f\x32\x48\x83\xc8\x00\x48\x21\xd0\x48\xc7\xc2"
    "\x00\x40\x00\x00\x0f\x79\xd0\x48\xc7\xc1\x82\x04\x00\x00\x0f\x32\x48\x83"
    "\xc8\x00\x48\x21\xd0\x48\xc7\xc2\x02\x40\x00\x00\x0f\x79\xd0\x48\xc7\xc2"
    "\x1e\x40\x00\x00\x48\xc7\xc0\x81\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc1\x83"
    "\x04\x00\x00\x0f\x32\x48\x0d\xff\x6f\x03\x00\x48\x21\xd0\x48\xc7\xc2\x0c"
    "\x40\x00\x00\x0f\x79\xd0\x48\xc7\xc1\x84\x04\x00\x00\x0f\x32\x48\x0d\xff"
    "\x17\x00\x00\x48\x21\xd0\x48\xc7\xc2\x12\x40\x00\x00\x0f\x79\xd0\x48\xc7"
    "\xc2\x04\x2c\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2"
    "\x00\x28\x00\x00\x48\xc7\xc0\xff\xff\xff\xff\x0f\x79\xd0\x48\xc7\xc2\x02"
    "\x0c\x00\x00\x48\xc7\xc0\x50\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc0\x58\x00"
    "\x00\x00\x48\xc7\xc2\x00\x0c\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x04\x0c\x00"
    "\x00\x0f\x79\xd0\x48\xc7\xc2\x06\x0c\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x08"
    "\x0c\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x0a\x0c\x00\x00\x0f\x79\xd0\x48\xc7"
    "\xc0\xd8\x00\x00\x00\x48\xc7\xc2\x0c\x0c\x00\x00\x0f\x79\xd0\x48\xc7\xc2"
    "\x02\x2c\x00\x00\x48\xc7\xc0\x00\x05\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x00"
    "\x4c\x00\x00\x48\xc7\xc0\x50\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x10\x6c"
    "\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x12\x6c\x00"
    "\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x0f\x20\xc0\x48\xc7\xc2\x00"
    "\x6c\x00\x00\x48\x89\xc0\x0f\x79\xd0\x0f\x20\xd8\x48\xc7\xc2\x02\x6c\x00"
    "\x00\x48\x89\xc0\x0f\x79\xd0\x0f\x20\xe0\x48\xc7\xc2\x04\x6c\x00\x00\x48"
    "\x89\xc0\x0f\x79\xd0\x48\xc7\xc2\x06\x6c\x00\x00\x48\xc7\xc0\x00\x00\x00"
    "\x00\x0f\x79\xd0\x48\xc7\xc2\x08\x6c\x00\x00\x48\xc7\xc0\x00\x00\x00\x00"
    "\x0f\x79\xd0\x48\xc7\xc2\x0a\x6c\x00\x00\x48\xc7\xc0\x00\x3a\x00\x00\x0f"
    "\x79\xd0\x48\xc7\xc2\x0c\x6c\x00\x00\x48\xc7\xc0\x00\x10\x00\x00\x0f\x79"
    "\xd0\x48\xc7\xc2\x0e\x6c\x00\x00\x48\xc7\xc0\x00\x38\x00\x00\x0f\x79\xd0"
    "\x48\xc7\xc2\x14\x6c\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48"
    "\xc7\xc2\x16\x6c\x00\x00\x48\x8b\x04\x25\x10\x5f\x00\x00\x0f\x79\xd0\x48"
    "\xc7\xc2\x00\x00\x00\x00\x48\xc7\xc0\x01\x00\x00\x00\x0f\x79\xd0\x48\xc7"
    "\xc2\x02\x00\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2"
    "\x00\x20\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x02"
    "\x20\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x04\x20"
    "\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x06\x20\x00"
    "\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc1\x77\x02\x00\x00"
    "\x0f\x32\x48\xc1\xe2\x20\x48\x09\xd0\x48\xc7\xc2\x00\x2c\x00\x00\x48\x89"
    "\xc0\x0f\x79\xd0\x48\xc7\xc2\x04\x40\x00\x00\x48\xc7\xc0\x00\x00\x00\x00"
    "\x0f\x79\xd0\x48\xc7\xc2\x0a\x40\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f"
    "\x79\xd0\x48\xc7\xc2\x0e\x40\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79"
    "\xd0\x48\xc7\xc2\x10\x40\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0"
    "\x48\xc7\xc2\x16\x40\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48"
    "\xc7\xc2\x14\x40\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7"
    "\xc2\x00\x60\x00\x00\x48\xc7\xc0\xff\xff\xff\xff\x0f\x79\xd0\x48\xc7\xc2"
    "\x02\x60\x00\x00\x48\xc7\xc0\xff\xff\xff\xff\x0f\x79\xd0\x48\xc7\xc2\x1c"
    "\x20\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x1e\x20"
    "\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x20\x20\x00"
    "\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x22\x20\x00\x00"
    "\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x00\x08\x00\x00\x48"
    "\xc7\xc0\x58\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x02\x08\x00\x00\x48\xc7"
    "\xc0\x50\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x04\x08\x00\x00\x48\xc7\xc0"
    "\x58\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x06\x08\x00\x00\x48\xc7\xc0\x58"
    "\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x08\x08\x00\x00\x48\xc7\xc0\x58\x00"
    "\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x0a\x08\x00\x00\x48\xc7\xc0\x58\x00\x00"
    "\x00\x0f\x79\xd0\x48\xc7\xc2\x0c\x08\x00\x00\x48\xc7\xc0\x00\x00\x00\x00"
    "\x0f\x79\xd0\x48\xc7\xc2\x0e\x08\x00\x00\x48\xc7\xc0\xd8\x00\x00\x00\x0f"
    "\x79\xd0\x48\xc7\xc2\x12\x68\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79"
    "\xd0\x48\xc7\xc2\x14\x68\x00\x00\x48\xc7\xc0\x00\x3a\x00\x00\x0f\x79\xd0"
    "\x48\xc7\xc2\x16\x68\x00\x00\x48\xc7\xc0\x00\x10\x00\x00\x0f\x79\xd0\x48"
    "\xc7\xc2\x18\x68\x00\x00\x48\xc7\xc0\x00\x38\x00\x00\x0f\x79\xd0\x48\xc7"
    "\xc2\x00\x48\x00\x00\x48\xc7\xc0\xff\xff\x0f\x00\x0f\x79\xd0\x48\xc7\xc2"
    "\x02\x48\x00\x00\x48\xc7\xc0\xff\xff\x0f\x00\x0f\x79\xd0\x48\xc7\xc2\x04"
    "\x48\x00\x00\x48\xc7\xc0\xff\xff\x0f\x00\x0f\x79\xd0\x48\xc7\xc2\x06\x48"
    "\x00\x00\x48\xc7\xc0\xff\xff\x0f\x00\x0f\x79\xd0\x48\xc7\xc2\x08\x48\x00"
    "\x00\x48\xc7\xc0\xff\xff\x0f\x00\x0f\x79\xd0\x48\xc7\xc2\x0a\x48\x00\x00"
    "\x48\xc7\xc0\xff\xff\x0f\x00\x0f\x79\xd0\x48\xc7\xc2\x0c\x48\x00\x00\x48"
    "\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x0e\x48\x00\x00\x48\xc7"
    "\xc0\xff\x1f\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x10\x48\x00\x00\x48\xc7\xc0"
    "\xff\x1f\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x12\x48\x00\x00\x48\xc7\xc0\xff"
    "\x1f\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x14\x48\x00\x00\x48\xc7\xc0\x93\x40"
    "\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x16\x48\x00\x00\x48\xc7\xc0\x9b\x20\x00"
    "\x00\x0f\x79\xd0\x48\xc7\xc2\x18\x48\x00\x00\x48\xc7\xc0\x93\x40\x00\x00"
    "\x0f\x79\xd0\x48\xc7\xc2\x1a\x48\x00\x00\x48\xc7\xc0\x93\x40\x00\x00\x0f"
    "\x79\xd0\x48\xc7\xc2\x1c\x48\x00\x00\x48\xc7\xc0\x93\x40\x00\x00\x0f\x79"
    "\xd0\x48\xc7\xc2\x1e\x48\x00\x00\x48\xc7\xc0\x93\x40\x00\x00\x0f\x79\xd0"
    "\x48\xc7\xc2\x20\x48\x00\x00\x48\xc7\xc0\x82\x00\x00\x00\x0f\x79\xd0\x48"
    "\xc7\xc2\x22\x48\x00\x00\x48\xc7\xc0\x8b\x00\x00\x00\x0f\x79\xd0\x48\xc7"
    "\xc2\x1c\x68\x00\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2"
    "\x1e\x68\x00\x00\x48\xc7\xc0\x00\x91\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x20"
    "\x68\x00\x00\x48\xc7\xc0\x02\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x06\x28"
    "\x00\x00\x48\xc7\xc0\x00\x05\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x0a\x28\x00"
    "\x00\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x0c\x28\x00\x00"
    "\x48\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x0e\x28\x00\x00\x48"
    "\xc7\xc0\x00\x00\x00\x00\x0f\x79\xd0\x48\xc7\xc2\x10\x28\x00\x00\x48\xc7"
    "\xc0\x00\x00\x00\x00\x0f\x79\xd0\x0f\x20\xc0\x48\xc7\xc2\x00\x68\x00\x00"
    "\x48\x89\xc0\x0f\x79\xd0\x0f\x20\xd8\x48\xc7\xc2\x02\x68\x00\x00\x48\x89"
    "\xc0\x0f\x79\xd0\x0f\x20\xe0\x48\xc7\xc2\x04\x68\x00\x00\x48\x89\xc0\x0f"
    "\x79\xd0\x48\xc7\xc0\x18\x5f\x00\x00\x48\x8b\x10\x48\xc7\xc0\x20\x5f\x00"
    "\x00\x48\x8b\x08\x48\x31\xc0\x0f\x78\xd0\x48\x31\xc8\x0f\x79\xd0\x0f\x01"
    "\xc2\x48\xc7\xc2\x00\x44\x00\x00\x0f\x78\xd0\xf4";
const char kvm_asm64_vm_exit[] =
    "\x48\xc7\xc3\x00\x44\x00\x00\x0f\x78\xda\x48\xc7\xc3\x02\x44\x00\x00\x0f"
    "\x78\xd9\x48\xc7\xc0\x00\x64\x00\x00\x0f\x78\xc0\x48\xc7\xc3\x1e\x68\x00"
    "\x00\x0f\x78\xdb\xf4";
const char kvm_asm64_cpl3[] =
    "\x0f\x20\xc0\x0d\x00\x00\x00\x80\x0f\x22\xc0\xea\xde\xc0\xad\x0b\x50\x00"
    "\x48\xc7\xc0\xd8\x00\x00\x00\x0f\x00\xd8\x48\xc7\xc0\x6b\x00\x00\x00\x8e"
    "\xd8\x8e\xc0\x8e\xe0\x8e\xe8\x48\xc7\xc4\x80\x0f\x00\x00\x48\xc7\x04\x24"
    "\x1d\xba\x00\x00\x48\xc7\x44\x24\x04\x63\x00\x00\x00\x48\xc7\x44\x24\x08"
    "\x80\x0f\x00\x00\x48\xc7\x44\x24\x0c\x6b\x00\x00\x00\xcb";

#define KVM_SMI _IO(KVMIO, 0xb7)

struct tss16 {
  uint16_t prev;
  uint16_t sp0;
  uint16_t ss0;
  uint16_t sp1;
  uint16_t ss1;
  uint16_t sp2;
  uint16_t ss2;
  uint16_t ip;
  uint16_t flags;
  uint16_t ax;
  uint16_t cx;
  uint16_t dx;
  uint16_t bx;
  uint16_t sp;
  uint16_t bp;
  uint16_t si;
  uint16_t di;
  uint16_t es;
  uint16_t cs;
  uint16_t ss;
  uint16_t ds;
  uint16_t ldt;
} __attribute__((packed));

struct tss32 {
  uint16_t prev, prevh;
  uint32_t sp0;
  uint16_t ss0, ss0h;
  uint32_t sp1;
  uint16_t ss1, ss1h;
  uint32_t sp2;
  uint16_t ss2, ss2h;
  uint32_t cr3;
  uint32_t ip;
  uint32_t flags;
  uint32_t ax;
  uint32_t cx;
  uint32_t dx;
  uint32_t bx;
  uint32_t sp;
  uint32_t bp;
  uint32_t si;
  uint32_t di;
  uint16_t es, esh;
  uint16_t cs, csh;
  uint16_t ss, ssh;
  uint16_t ds, dsh;
  uint16_t fs, fsh;
  uint16_t gs, gsh;
  uint16_t ldt, ldth;
  uint16_t trace;
  uint16_t io_bitmap;
} __attribute__((packed));

struct tss64 {
  uint32_t reserved0;
  uint64_t rsp[3];
  uint64_t reserved1;
  uint64_t ist[7];
  uint64_t reserved2;
  uint32_t reserved3;
  uint32_t io_bitmap;
} __attribute__((packed));

static void fill_segment_descriptor(uint64_t* dt, uint64_t* lt,
                                    struct kvm_segment* seg)
{
  uint16_t index = seg->selector >> 3;
  uint64_t limit = seg->g ? seg->limit >> 12 : seg->limit;
  uint64_t sd = (limit & 0xffff) | (seg->base & 0xffffff) << 16 |
                (uint64_t)seg->type << 40 | (uint64_t)seg->s << 44 |
                (uint64_t)seg->dpl << 45 | (uint64_t)seg->present << 47 |
                (limit & 0xf0000ULL) << 48 | (uint64_t)seg->avl << 52 |
                (uint64_t)seg->l << 53 | (uint64_t)seg->db << 54 |
                (uint64_t)seg->g << 55 | (seg->base & 0xff000000ULL) << 56;
  dt[index] = sd;
  lt[index] = sd;
}

static void fill_segment_descriptor_dword(uint64_t* dt, uint64_t* lt,
                                          struct kvm_segment* seg)
{
  fill_segment_descriptor(dt, lt, seg);
  uint16_t index = seg->selector >> 3;
  dt[index + 1] = 0;
  lt[index + 1] = 0;
}

static void setup_syscall_msrs(int cpufd, uint16_t sel_cs, uint16_t sel_cs_cpl3)
{
  char buf[sizeof(struct kvm_msrs) + 5 * sizeof(struct kvm_msr_entry)];
  memset(buf, 0, sizeof(buf));
  struct kvm_msrs* msrs = (struct kvm_msrs*)buf;
  struct kvm_msr_entry* entries = msrs->entries;
  msrs->nmsrs = 5;
  entries[0].index = X86_MSR_IA32_SYSENTER_CS;
  entries[0].data = sel_cs;
  entries[1].index = X86_MSR_IA32_SYSENTER_ESP;
  entries[1].data = X86_ADDR_STACK0;
  entries[2].index = X86_MSR_IA32_SYSENTER_EIP;
  entries[2].data = X86_ADDR_VAR_SYSEXIT;
  entries[3].index = X86_MSR_IA32_STAR;
  entries[3].data = ((uint64_t)sel_cs << 32) | ((uint64_t)sel_cs_cpl3 << 48);
  entries[4].index = X86_MSR_IA32_LSTAR;
  entries[4].data = X86_ADDR_VAR_SYSRET;
  ioctl(cpufd, KVM_SET_MSRS, msrs);
}

static void setup_32bit_idt(struct kvm_sregs* sregs, char* host_mem,
                            uintptr_t guest_mem)
{
  sregs->idt.base = guest_mem + X86_ADDR_VAR_IDT;
  sregs->idt.limit = 0x1ff;
  uint64_t* idt = (uint64_t*)(host_mem + sregs->idt.base);
  for (int i = 0; i < 32; i++) {
    struct kvm_segment gate;
    gate.selector = i << 3;
    switch (i % 6) {
    case 0:
      gate.type = 6;
      gate.base = X86_SEL_CS16;
      break;
    case 1:
      gate.type = 7;
      gate.base = X86_SEL_CS16;
      break;
    case 2:
      gate.type = 3;
      gate.base = X86_SEL_TGATE16;
      break;
    case 3:
      gate.type = 14;
      gate.base = X86_SEL_CS32;
      break;
    case 4:
      gate.type = 15;
      gate.base = X86_SEL_CS32;
      break;
    case 5:
      gate.type = 11;
      gate.base = X86_SEL_TGATE32;
      break;
    }
    gate.limit = guest_mem + X86_ADDR_VAR_USER_CODE2;
    gate.present = 1;
    gate.dpl = 0;
    gate.s = 0;
    gate.g = 0;
    gate.db = 0;
    gate.l = 0;
    gate.avl = 0;
    fill_segment_descriptor(idt, idt, &gate);
  }
}

static void setup_64bit_idt(struct kvm_sregs* sregs, char* host_mem,
                            uintptr_t guest_mem)
{
  sregs->idt.base = guest_mem + X86_ADDR_VAR_IDT;
  sregs->idt.limit = 0x1ff;
  uint64_t* idt = (uint64_t*)(host_mem + sregs->idt.base);
  for (int i = 0; i < 32; i++) {
    struct kvm_segment gate;
    gate.selector = (i * 2) << 3;
    gate.type = (i & 1) ? 14 : 15;
    gate.base = X86_SEL_CS64;
    gate.limit = guest_mem + X86_ADDR_VAR_USER_CODE2;
    gate.present = 1;
    gate.dpl = 0;
    gate.s = 0;
    gate.g = 0;
    gate.db = 0;
    gate.l = 0;
    gate.avl = 0;
    fill_segment_descriptor_dword(idt, idt, &gate);
  }
}

struct kvm_text {
  uintptr_t typ;
  const void* text;
  uintptr_t size;
};

struct kvm_opt {
  uint64_t typ;
  uint64_t val;
};

#define PAGE_MASK GENMASK_ULL(51, 12)
static void setup_pg_table(void* host_mem)
{
  uint64_t* pml4 = (uint64_t*)((uint64_t)host_mem + X86_ADDR_PML4);
  uint64_t* pdp = (uint64_t*)((uint64_t)host_mem + X86_ADDR_PDP);
  uint64_t* pd = (uint64_t*)((uint64_t)host_mem + X86_ADDR_PD);
  uint64_t* pd_ioapic = (uint64_t*)((uint64_t)host_mem + X86_ADDR_PD_IOAPIC);
  pml4[0] = X86_PDE64_PRESENT | X86_PDE64_RW | (X86_ADDR_PDP & PAGE_MASK);
  pdp[0] = X86_PDE64_PRESENT | X86_PDE64_RW | (X86_ADDR_PD & PAGE_MASK);
  pdp[3] = X86_PDE64_PRESENT | X86_PDE64_RW | (X86_ADDR_PD_IOAPIC & PAGE_MASK);
  pd[0] = X86_PDE64_PRESENT | X86_PDE64_RW | X86_PDE64_PS;
  pd_ioapic[502] = X86_PDE64_PRESENT | X86_PDE64_RW | X86_PDE64_PS;
}
static void setup_gdt_ldt_pg(int cpufd, void* host_mem)
{
  struct kvm_sregs sregs;
  ioctl(cpufd, KVM_GET_SREGS, &sregs);
  sregs.gdt.base = X86_ADDR_GDT;
  sregs.gdt.limit = 256 * sizeof(uint64_t) - 1;
  uint64_t* gdt = (uint64_t*)((uint64_t)host_mem + sregs.gdt.base);
  struct kvm_segment seg_ldt;
  memset(&seg_ldt, 0, sizeof(seg_ldt));
  seg_ldt.selector = X86_SEL_LDT;
  seg_ldt.type = 2;
  seg_ldt.base = X86_ADDR_LDT;
  seg_ldt.limit = 256 * sizeof(uint64_t) - 1;
  seg_ldt.present = 1;
  seg_ldt.dpl = 0;
  seg_ldt.s = 0;
  seg_ldt.g = 0;
  seg_ldt.db = 1;
  seg_ldt.l = 0;
  sregs.ldt = seg_ldt;
  uint64_t* ldt = (uint64_t*)((uint64_t)host_mem + sregs.ldt.base);
  struct kvm_segment seg_cs64;
  memset(&seg_cs64, 0, sizeof(seg_cs64));
  seg_cs64.selector = X86_SEL_CS64;
  seg_cs64.type = 11;
  seg_cs64.base = 0;
  seg_cs64.limit = 0xFFFFFFFFu;
  seg_cs64.present = 1;
  seg_cs64.s = 1;
  seg_cs64.g = 1;
  seg_cs64.l = 1;
  sregs.cs = seg_cs64;
  struct kvm_segment seg_ds64;
  memset(&seg_ds64, 0, sizeof(struct kvm_segment));
  seg_ds64.selector = X86_SEL_DS64;
  seg_ds64.type = 3;
  seg_ds64.limit = 0xFFFFFFFFu;
  seg_ds64.present = 1;
  seg_ds64.s = 1;
  seg_ds64.g = 1;
  sregs.ds = seg_ds64;
  sregs.es = seg_ds64;
  struct kvm_segment seg_tss64;
  memset(&seg_tss64, 0, sizeof(seg_tss64));
  seg_tss64.selector = X86_SEL_TSS64;
  seg_tss64.base = X86_ADDR_VAR_TSS64;
  seg_tss64.limit = 0x1ff;
  seg_tss64.type = 9;
  seg_tss64.present = 1;
  struct tss64 tss64;
  memset(&tss64, 0, sizeof(tss64));
  tss64.rsp[0] = X86_ADDR_STACK0;
  tss64.rsp[1] = X86_ADDR_STACK0;
  tss64.rsp[2] = X86_ADDR_STACK0;
  tss64.io_bitmap = offsetof(struct tss64, io_bitmap);
  struct tss64* tss64_addr =
      (struct tss64*)((uint64_t)host_mem + seg_tss64.base);
  memcpy(tss64_addr, &tss64, sizeof(tss64));
  fill_segment_descriptor(gdt, ldt, &seg_ldt);
  fill_segment_descriptor(gdt, ldt, &seg_cs64);
  fill_segment_descriptor(gdt, ldt, &seg_ds64);
  fill_segment_descriptor_dword(gdt, ldt, &seg_tss64);
  setup_pg_table(host_mem);
  sregs.cr0 = X86_CR0_PE | X86_CR0_NE | X86_CR0_PG;
  sregs.cr4 |= X86_CR4_PAE | X86_CR4_OSFXSR;
  sregs.efer |= (X86_EFER_LME | X86_EFER_LMA | X86_EFER_NXE);
  sregs.cr3 = X86_ADDR_PML4;
  ioctl(cpufd, KVM_SET_SREGS, &sregs);
}

static void setup_cpuid(int cpufd)
{
  int kvmfd = open("/dev/kvm", O_RDWR);
  char buf[sizeof(struct kvm_cpuid2) + 128 * sizeof(struct kvm_cpuid_entry2)];
  memset(buf, 0, sizeof(buf));
  struct kvm_cpuid2* cpuid = (struct kvm_cpuid2*)buf;
  cpuid->nent = 128;
  ioctl(kvmfd, KVM_GET_SUPPORTED_CPUID, cpuid);
  ioctl(cpufd, KVM_SET_CPUID2, cpuid);
  close(kvmfd);
}

#define KVM_SETUP_PAGING (1 << 0)
#define KVM_SETUP_PAE (1 << 1)
#define KVM_SETUP_PROTECTED (1 << 2)
#define KVM_SETUP_CPL3 (1 << 3)
#define KVM_SETUP_VIRT86 (1 << 4)
#define KVM_SETUP_SMM (1 << 5)
#define KVM_SETUP_VM (1 << 6)
static volatile long syz_kvm_setup_cpu(volatile long a0, volatile long a1,
                                       volatile long a2, volatile long a3,
                                       volatile long a4, volatile long a5,
                                       volatile long a6, volatile long a7)
{
  const int vmfd = a0;
  const int cpufd = a1;
  char* const host_mem = (char*)a2;
  const struct kvm_text* const text_array_ptr = (struct kvm_text*)a3;
  const uintptr_t text_count = a4;
  const uintptr_t flags = a5;
  const struct kvm_opt* const opt_array_ptr = (struct kvm_opt*)a6;
  uintptr_t opt_count = a7;
  const uintptr_t page_size = 4 << 10;
  const uintptr_t ioapic_page = 10;
  const uintptr_t guest_mem_size = 24 * page_size;
  const uintptr_t guest_mem = 0;
  (void)text_count;
  int text_type = text_array_ptr[0].typ;
  const void* text = text_array_ptr[0].text;
  uintptr_t text_size = text_array_ptr[0].size;
  for (uintptr_t i = 0; i < guest_mem_size / page_size; i++) {
    struct kvm_userspace_memory_region memreg;
    memreg.slot = i;
    memreg.flags = 0;
    memreg.guest_phys_addr = guest_mem + i * page_size;
    if (i == ioapic_page)
      memreg.guest_phys_addr = 0xfec00000;
    memreg.memory_size = page_size;
    memreg.userspace_addr = (uintptr_t)host_mem + i * page_size;
    ioctl(vmfd, KVM_SET_USER_MEMORY_REGION, &memreg);
  }
  struct kvm_userspace_memory_region memreg;
  memreg.slot = 1 + (1 << 16);
  memreg.flags = 0;
  memreg.guest_phys_addr = 0x30000;
  memreg.memory_size = 64 << 10;
  memreg.userspace_addr = (uintptr_t)host_mem;
  ioctl(vmfd, KVM_SET_USER_MEMORY_REGION, &memreg);
  struct kvm_sregs sregs;
  if (ioctl(cpufd, KVM_GET_SREGS, &sregs))
    return -1;
  struct kvm_regs regs;
  memset(&regs, 0, sizeof(regs));
  regs.rip = guest_mem + X86_ADDR_TEXT;
  regs.rsp = X86_ADDR_STACK0;
  sregs.gdt.base = guest_mem + X86_ADDR_GDT;
  sregs.gdt.limit = 256 * sizeof(uint64_t) - 1;
  uint64_t* gdt = (uint64_t*)(host_mem + sregs.gdt.base);
  struct kvm_segment seg_ldt;
  memset(&seg_ldt, 0, sizeof(seg_ldt));
  seg_ldt.selector = X86_SEL_LDT;
  seg_ldt.type = 2;
  seg_ldt.base = guest_mem + X86_ADDR_LDT;
  seg_ldt.limit = 256 * sizeof(uint64_t) - 1;
  seg_ldt.present = 1;
  seg_ldt.dpl = 0;
  seg_ldt.s = 0;
  seg_ldt.g = 0;
  seg_ldt.db = 1;
  seg_ldt.l = 0;
  sregs.ldt = seg_ldt;
  uint64_t* ldt = (uint64_t*)(host_mem + sregs.ldt.base);
  struct kvm_segment seg_cs16;
  memset(&seg_cs16, 0, sizeof(seg_cs16));
  seg_cs16.selector = X86_SEL_CS16;
  seg_cs16.type = 11;
  seg_cs16.base = 0;
  seg_cs16.limit = 0xfffff;
  seg_cs16.present = 1;
  seg_cs16.dpl = 0;
  seg_cs16.s = 1;
  seg_cs16.g = 0;
  seg_cs16.db = 0;
  seg_cs16.l = 0;
  struct kvm_segment seg_ds16 = seg_cs16;
  seg_ds16.selector = X86_SEL_DS16;
  seg_ds16.type = 3;
  struct kvm_segment seg_cs16_cpl3 = seg_cs16;
  seg_cs16_cpl3.selector = X86_SEL_CS16_CPL3;
  seg_cs16_cpl3.dpl = 3;
  struct kvm_segment seg_ds16_cpl3 = seg_ds16;
  seg_ds16_cpl3.selector = X86_SEL_DS16_CPL3;
  seg_ds16_cpl3.dpl = 3;
  struct kvm_segment seg_cs32 = seg_cs16;
  seg_cs32.selector = X86_SEL_CS32;
  seg_cs32.db = 1;
  struct kvm_segment seg_ds32 = seg_ds16;
  seg_ds32.selector = X86_SEL_DS32;
  seg_ds32.db = 1;
  struct kvm_segment seg_cs32_cpl3 = seg_cs32;
  seg_cs32_cpl3.selector = X86_SEL_CS32_CPL3;
  seg_cs32_cpl3.dpl = 3;
  struct kvm_segment seg_ds32_cpl3 = seg_ds32;
  seg_ds32_cpl3.selector = X86_SEL_DS32_CPL3;
  seg_ds32_cpl3.dpl = 3;
  struct kvm_segment seg_cs64 = seg_cs16;
  seg_cs64.selector = X86_SEL_CS64;
  seg_cs64.l = 1;
  struct kvm_segment seg_ds64 = seg_ds32;
  seg_ds64.selector = X86_SEL_DS64;
  struct kvm_segment seg_cs64_cpl3 = seg_cs64;
  seg_cs64_cpl3.selector = X86_SEL_CS64_CPL3;
  seg_cs64_cpl3.dpl = 3;
  struct kvm_segment seg_ds64_cpl3 = seg_ds64;
  seg_ds64_cpl3.selector = X86_SEL_DS64_CPL3;
  seg_ds64_cpl3.dpl = 3;
  struct kvm_segment seg_tss32;
  memset(&seg_tss32, 0, sizeof(seg_tss32));
  seg_tss32.selector = X86_SEL_TSS32;
  seg_tss32.type = 9;
  seg_tss32.base = X86_ADDR_VAR_TSS32;
  seg_tss32.limit = 0x1ff;
  seg_tss32.present = 1;
  seg_tss32.dpl = 0;
  seg_tss32.s = 0;
  seg_tss32.g = 0;
  seg_tss32.db = 0;
  seg_tss32.l = 0;
  struct kvm_segment seg_tss32_2 = seg_tss32;
  seg_tss32_2.selector = X86_SEL_TSS32_2;
  seg_tss32_2.base = X86_ADDR_VAR_TSS32_2;
  struct kvm_segment seg_tss32_cpl3 = seg_tss32;
  seg_tss32_cpl3.selector = X86_SEL_TSS32_CPL3;
  seg_tss32_cpl3.base = X86_ADDR_VAR_TSS32_CPL3;
  struct kvm_segment seg_tss32_vm86 = seg_tss32;
  seg_tss32_vm86.selector = X86_SEL_TSS32_VM86;
  seg_tss32_vm86.base = X86_ADDR_VAR_TSS32_VM86;
  struct kvm_segment seg_tss16 = seg_tss32;
  seg_tss16.selector = X86_SEL_TSS16;
  seg_tss16.base = X86_ADDR_VAR_TSS16;
  seg_tss16.limit = 0xff;
  seg_tss16.type = 1;
  struct kvm_segment seg_tss16_2 = seg_tss16;
  seg_tss16_2.selector = X86_SEL_TSS16_2;
  seg_tss16_2.base = X86_ADDR_VAR_TSS16_2;
  seg_tss16_2.dpl = 0;
  struct kvm_segment seg_tss16_cpl3 = seg_tss16;
  seg_tss16_cpl3.selector = X86_SEL_TSS16_CPL3;
  seg_tss16_cpl3.base = X86_ADDR_VAR_TSS16_CPL3;
  seg_tss16_cpl3.dpl = 3;
  struct kvm_segment seg_tss64 = seg_tss32;
  seg_tss64.selector = X86_SEL_TSS64;
  seg_tss64.base = X86_ADDR_VAR_TSS64;
  seg_tss64.limit = 0x1ff;
  struct kvm_segment seg_tss64_cpl3 = seg_tss64;
  seg_tss64_cpl3.selector = X86_SEL_TSS64_CPL3;
  seg_tss64_cpl3.base = X86_ADDR_VAR_TSS64_CPL3;
  seg_tss64_cpl3.dpl = 3;
  struct kvm_segment seg_cgate16;
  memset(&seg_cgate16, 0, sizeof(seg_cgate16));
  seg_cgate16.selector = X86_SEL_CGATE16;
  seg_cgate16.type = 4;
  seg_cgate16.base = X86_SEL_CS16 | (2 << 16);
  seg_cgate16.limit = X86_ADDR_VAR_USER_CODE2;
  seg_cgate16.present = 1;
  seg_cgate16.dpl = 0;
  seg_cgate16.s = 0;
  seg_cgate16.g = 0;
  seg_cgate16.db = 0;
  seg_cgate16.l = 0;
  seg_cgate16.avl = 0;
  struct kvm_segment seg_tgate16 = seg_cgate16;
  seg_tgate16.selector = X86_SEL_TGATE16;
  seg_tgate16.type = 3;
  seg_cgate16.base = X86_SEL_TSS16_2;
  seg_tgate16.limit = 0;
  struct kvm_segment seg_cgate32 = seg_cgate16;
  seg_cgate32.selector = X86_SEL_CGATE32;
  seg_cgate32.type = 12;
  seg_cgate32.base = X86_SEL_CS32 | (2 << 16);
  struct kvm_segment seg_tgate32 = seg_cgate32;
  seg_tgate32.selector = X86_SEL_TGATE32;
  seg_tgate32.type = 11;
  seg_tgate32.base = X86_SEL_TSS32_2;
  seg_tgate32.limit = 0;
  struct kvm_segment seg_cgate64 = seg_cgate16;
  seg_cgate64.selector = X86_SEL_CGATE64;
  seg_cgate64.type = 12;
  seg_cgate64.base = X86_SEL_CS64;
  int kvmfd = open("/dev/kvm", O_RDWR);
  char buf[sizeof(struct kvm_cpuid2) + 128 * sizeof(struct kvm_cpuid_entry2)];
  memset(buf, 0, sizeof(buf));
  struct kvm_cpuid2* cpuid = (struct kvm_cpuid2*)buf;
  cpuid->nent = 128;
  ioctl(kvmfd, KVM_GET_SUPPORTED_CPUID, cpuid);
  ioctl(cpufd, KVM_SET_CPUID2, cpuid);
  close(kvmfd);
  const char* text_prefix = 0;
  int text_prefix_size = 0;
  char* host_text = host_mem + X86_ADDR_TEXT;
  if (text_type == 8) {
    if (flags & KVM_SETUP_SMM) {
      if (flags & KVM_SETUP_PROTECTED) {
        sregs.cs = seg_cs16;
        sregs.ds = sregs.es = sregs.fs = sregs.gs = sregs.ss = seg_ds16;
        sregs.cr0 |= X86_CR0_PE;
      } else {
        sregs.cs.selector = 0;
        sregs.cs.base = 0;
      }
      *(host_mem + X86_ADDR_TEXT) = 0xf4;
      host_text = host_mem + 0x8000;
      ioctl(cpufd, KVM_SMI, 0);
    } else if (flags & KVM_SETUP_VIRT86) {
      sregs.cs = seg_cs32;
      sregs.ds = sregs.es = sregs.fs = sregs.gs = sregs.ss = seg_ds32;
      sregs.cr0 |= X86_CR0_PE;
      sregs.efer |= X86_EFER_SCE;
      setup_syscall_msrs(cpufd, X86_SEL_CS32, X86_SEL_CS32_CPL3);
      setup_32bit_idt(&sregs, host_mem, guest_mem);
      if (flags & KVM_SETUP_PAGING) {
        uint64_t pd_addr = guest_mem + X86_ADDR_PD;
        uint64_t* pd = (uint64_t*)(host_mem + X86_ADDR_PD);
        pd[0] =
            X86_PDE32_PRESENT | X86_PDE32_RW | X86_PDE32_USER | X86_PDE32_PS;
        sregs.cr3 = pd_addr;
        sregs.cr4 |= X86_CR4_PSE;
        text_prefix = kvm_asm32_paged_vm86;
        text_prefix_size = sizeof(kvm_asm32_paged_vm86) - 1;
      } else {
        text_prefix = kvm_asm32_vm86;
        text_prefix_size = sizeof(kvm_asm32_vm86) - 1;
      }
    } else {
      sregs.cs.selector = 0;
      sregs.cs.base = 0;
    }
  } else if (text_type == 16) {
    if (flags & KVM_SETUP_CPL3) {
      sregs.cs = seg_cs16;
      sregs.ds = sregs.es = sregs.fs = sregs.gs = sregs.ss = seg_ds16;
      text_prefix = kvm_asm16_cpl3;
      text_prefix_size = sizeof(kvm_asm16_cpl3) - 1;
    } else {
      sregs.cr0 |= X86_CR0_PE;
      sregs.cs = seg_cs16;
      sregs.ds = sregs.es = sregs.fs = sregs.gs = sregs.ss = seg_ds16;
    }
  } else if (text_type == 32) {
    sregs.cr0 |= X86_CR0_PE;
    sregs.efer |= X86_EFER_SCE;
    setup_syscall_msrs(cpufd, X86_SEL_CS32, X86_SEL_CS32_CPL3);
    setup_32bit_idt(&sregs, host_mem, guest_mem);
    if (flags & KVM_SETUP_SMM) {
      sregs.cs = seg_cs32;
      sregs.ds = sregs.es = sregs.fs = sregs.gs = sregs.ss = seg_ds32;
      *(host_mem + X86_ADDR_TEXT) = 0xf4;
      host_text = host_mem + 0x8000;
      ioctl(cpufd, KVM_SMI, 0);
    } else if (flags & KVM_SETUP_PAGING) {
      sregs.cs = seg_cs32;
      sregs.ds = sregs.es = sregs.fs = sregs.gs = sregs.ss = seg_ds32;
      uint64_t pd_addr = guest_mem + X86_ADDR_PD;
      uint64_t* pd = (uint64_t*)(host_mem + X86_ADDR_PD);
      pd[0] = X86_PDE32_PRESENT | X86_PDE32_RW | X86_PDE32_USER | X86_PDE32_PS;
      sregs.cr3 = pd_addr;
      sregs.cr4 |= X86_CR4_PSE;
      text_prefix = kvm_asm32_paged;
      text_prefix_size = sizeof(kvm_asm32_paged) - 1;
    } else if (flags & KVM_SETUP_CPL3) {
      sregs.cs = seg_cs32_cpl3;
      sregs.ds = sregs.es = sregs.fs = sregs.gs = sregs.ss = seg_ds32_cpl3;
    } else {
      sregs.cs = seg_cs32;
      sregs.ds = sregs.es = sregs.fs = sregs.gs = sregs.ss = seg_ds32;
    }
  } else {
    sregs.efer |= X86_EFER_LME | X86_EFER_SCE;
    sregs.cr0 |= X86_CR0_PE;
    setup_syscall_msrs(cpufd, X86_SEL_CS64, X86_SEL_CS64_CPL3);
    setup_64bit_idt(&sregs, host_mem, guest_mem);
    sregs.cs = seg_cs32;
    sregs.ds = sregs.es = sregs.fs = sregs.gs = sregs.ss = seg_ds32;
    uint64_t pml4_addr = guest_mem + X86_ADDR_PML4;
    uint64_t* pml4 = (uint64_t*)(host_mem + X86_ADDR_PML4);
    uint64_t pdpt_addr = guest_mem + X86_ADDR_PDP;
    uint64_t* pdpt = (uint64_t*)(host_mem + X86_ADDR_PDP);
    uint64_t pd_addr = guest_mem + X86_ADDR_PD;
    uint64_t* pd = (uint64_t*)(host_mem + X86_ADDR_PD);
    pml4[0] = X86_PDE64_PRESENT | X86_PDE64_RW | X86_PDE64_USER | pdpt_addr;
    pdpt[0] = X86_PDE64_PRESENT | X86_PDE64_RW | X86_PDE64_USER | pd_addr;
    pd[0] = X86_PDE64_PRESENT | X86_PDE64_RW | X86_PDE64_USER | X86_PDE64_PS;
    sregs.cr3 = pml4_addr;
    sregs.cr4 |= X86_CR4_PAE;
    if (flags & KVM_SETUP_VM) {
      sregs.cr0 |= X86_CR0_NE;
      *((uint64_t*)(host_mem + X86_ADDR_VAR_VMXON_PTR)) = X86_ADDR_VAR_VMXON;
      *((uint64_t*)(host_mem + X86_ADDR_VAR_VMCS_PTR)) = X86_ADDR_VAR_VMCS;
      memcpy(host_mem + X86_ADDR_VAR_VMEXIT_CODE, kvm_asm64_vm_exit,
             sizeof(kvm_asm64_vm_exit) - 1);
      *((uint64_t*)(host_mem + X86_ADDR_VAR_VMEXIT_PTR)) =
          X86_ADDR_VAR_VMEXIT_CODE;
      text_prefix = kvm_asm64_init_vm;
      text_prefix_size = sizeof(kvm_asm64_init_vm) - 1;
    } else if (flags & KVM_SETUP_CPL3) {
      text_prefix = kvm_asm64_cpl3;
      text_prefix_size = sizeof(kvm_asm64_cpl3) - 1;
    } else {
      text_prefix = kvm_asm64_enable_long;
      text_prefix_size = sizeof(kvm_asm64_enable_long) - 1;
    }
  }
  struct tss16 tss16;
  memset(&tss16, 0, sizeof(tss16));
  tss16.ss0 = tss16.ss1 = tss16.ss2 = X86_SEL_DS16;
  tss16.sp0 = tss16.sp1 = tss16.sp2 = X86_ADDR_STACK0;
  tss16.ip = X86_ADDR_VAR_USER_CODE2;
  tss16.flags = (1 << 1);
  tss16.cs = X86_SEL_CS16;
  tss16.es = tss16.ds = tss16.ss = X86_SEL_DS16;
  tss16.ldt = X86_SEL_LDT;
  struct tss16* tss16_addr = (struct tss16*)(host_mem + seg_tss16_2.base);
  memcpy(tss16_addr, &tss16, sizeof(tss16));
  memset(&tss16, 0, sizeof(tss16));
  tss16.ss0 = tss16.ss1 = tss16.ss2 = X86_SEL_DS16;
  tss16.sp0 = tss16.sp1 = tss16.sp2 = X86_ADDR_STACK0;
  tss16.ip = X86_ADDR_VAR_USER_CODE2;
  tss16.flags = (1 << 1);
  tss16.cs = X86_SEL_CS16_CPL3;
  tss16.es = tss16.ds = tss16.ss = X86_SEL_DS16_CPL3;
  tss16.ldt = X86_SEL_LDT;
  struct tss16* tss16_cpl3_addr =
      (struct tss16*)(host_mem + seg_tss16_cpl3.base);
  memcpy(tss16_cpl3_addr, &tss16, sizeof(tss16));
  struct tss32 tss32;
  memset(&tss32, 0, sizeof(tss32));
  tss32.ss0 = tss32.ss1 = tss32.ss2 = X86_SEL_DS32;
  tss32.sp0 = tss32.sp1 = tss32.sp2 = X86_ADDR_STACK0;
  tss32.ip = X86_ADDR_VAR_USER_CODE;
  tss32.flags = (1 << 1) | (1 << 17);
  tss32.ldt = X86_SEL_LDT;
  tss32.cr3 = sregs.cr3;
  tss32.io_bitmap = offsetof(struct tss32, io_bitmap);
  struct tss32* tss32_addr = (struct tss32*)(host_mem + seg_tss32_vm86.base);
  memcpy(tss32_addr, &tss32, sizeof(tss32));
  memset(&tss32, 0, sizeof(tss32));
  tss32.ss0 = tss32.ss1 = tss32.ss2 = X86_SEL_DS32;
  tss32.sp0 = tss32.sp1 = tss32.sp2 = X86_ADDR_STACK0;
  tss32.ip = X86_ADDR_VAR_USER_CODE;
  tss32.flags = (1 << 1);
  tss32.cr3 = sregs.cr3;
  tss32.es = tss32.ds = tss32.ss = tss32.gs = tss32.fs = X86_SEL_DS32;
  tss32.cs = X86_SEL_CS32;
  tss32.ldt = X86_SEL_LDT;
  tss32.cr3 = sregs.cr3;
  tss32.io_bitmap = offsetof(struct tss32, io_bitmap);
  struct tss32* tss32_cpl3_addr = (struct tss32*)(host_mem + seg_tss32_2.base);
  memcpy(tss32_cpl3_addr, &tss32, sizeof(tss32));
  struct tss64 tss64;
  memset(&tss64, 0, sizeof(tss64));
  tss64.rsp[0] = X86_ADDR_STACK0;
  tss64.rsp[1] = X86_ADDR_STACK0;
  tss64.rsp[2] = X86_ADDR_STACK0;
  tss64.io_bitmap = offsetof(struct tss64, io_bitmap);
  struct tss64* tss64_addr = (struct tss64*)(host_mem + seg_tss64.base);
  memcpy(tss64_addr, &tss64, sizeof(tss64));
  memset(&tss64, 0, sizeof(tss64));
  tss64.rsp[0] = X86_ADDR_STACK0;
  tss64.rsp[1] = X86_ADDR_STACK0;
  tss64.rsp[2] = X86_ADDR_STACK0;
  tss64.io_bitmap = offsetof(struct tss64, io_bitmap);
  struct tss64* tss64_cpl3_addr =
      (struct tss64*)(host_mem + seg_tss64_cpl3.base);
  memcpy(tss64_cpl3_addr, &tss64, sizeof(tss64));
  if (text_size > 1000)
    text_size = 1000;
  if (text_prefix) {
    memcpy(host_text, text_prefix, text_prefix_size);
    void* patch = memmem(host_text, text_prefix_size, "\xde\xc0\xad\x0b", 4);
    if (patch)
      *((uint32_t*)patch) =
          guest_mem + X86_ADDR_TEXT + ((char*)patch - host_text) + 6;
    uint16_t magic = X86_PREFIX_SIZE;
    patch = memmem(host_text, text_prefix_size, &magic, sizeof(magic));
    if (patch)
      *((uint16_t*)patch) = guest_mem + X86_ADDR_TEXT + text_prefix_size;
  }
  memcpy((void*)(host_text + text_prefix_size), text, text_size);
  *(host_text + text_prefix_size + text_size) = 0xf4;
  memcpy(host_mem + X86_ADDR_VAR_USER_CODE, text, text_size);
  *(host_mem + X86_ADDR_VAR_USER_CODE + text_size) = 0xf4;
  *(host_mem + X86_ADDR_VAR_HLT) = 0xf4;
  memcpy(host_mem + X86_ADDR_VAR_SYSRET, "\x0f\x07\xf4", 3);
  memcpy(host_mem + X86_ADDR_VAR_SYSEXIT, "\x0f\x35\xf4", 3);
  *(uint64_t*)(host_mem + X86_ADDR_VAR_VMWRITE_FLD) = 0;
  *(uint64_t*)(host_mem + X86_ADDR_VAR_VMWRITE_VAL) = 0;
  if (opt_count > 2)
    opt_count = 2;
  for (uintptr_t i = 0; i < opt_count; i++) {
    uint64_t typ = opt_array_ptr[i].typ;
    uint64_t val = opt_array_ptr[i].val;
    switch (typ % 9) {
    case 0:
      sregs.cr0 ^= val & (X86_CR0_MP | X86_CR0_EM | X86_CR0_ET | X86_CR0_NE |
                          X86_CR0_WP | X86_CR0_AM | X86_CR0_NW | X86_CR0_CD);
      break;
    case 1:
      sregs.cr4 ^=
          val & (X86_CR4_VME | X86_CR4_PVI | X86_CR4_TSD | X86_CR4_DE |
                 X86_CR4_MCE | X86_CR4_PGE | X86_CR4_PCE | X86_CR4_OSFXSR |
                 X86_CR4_OSXMMEXCPT | X86_CR4_UMIP | X86_CR4_VMXE |
                 X86_CR4_SMXE | X86_CR4_FSGSBASE | X86_CR4_PCIDE |
                 X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE);
      break;
    case 2:
      sregs.efer ^= val & (X86_EFER_SCE | X86_EFER_NXE | X86_EFER_SVME |
                           X86_EFER_LMSLE | X86_EFER_FFXSR | X86_EFER_TCE);
      break;
    case 3:
      val &=
          ((1 << 8) | (1 << 9) | (1 << 10) | (1 << 12) | (1 << 13) | (1 << 14) |
           (1 << 15) | (1 << 18) | (1 << 19) | (1 << 20) | (1 << 21));
      regs.rflags ^= val;
      tss16_addr->flags ^= val;
      tss16_cpl3_addr->flags ^= val;
      tss32_addr->flags ^= val;
      tss32_cpl3_addr->flags ^= val;
      break;
    case 4:
      seg_cs16.type = val & 0xf;
      seg_cs32.type = val & 0xf;
      seg_cs64.type = val & 0xf;
      break;
    case 5:
      seg_cs16_cpl3.type = val & 0xf;
      seg_cs32_cpl3.type = val & 0xf;
      seg_cs64_cpl3.type = val & 0xf;
      break;
    case 6:
      seg_ds16.type = val & 0xf;
      seg_ds32.type = val & 0xf;
      seg_ds64.type = val & 0xf;
      break;
    case 7:
      seg_ds16_cpl3.type = val & 0xf;
      seg_ds32_cpl3.type = val & 0xf;
      seg_ds64_cpl3.type = val & 0xf;
      break;
    case 8:
      *(uint64_t*)(host_mem + X86_ADDR_VAR_VMWRITE_FLD) = (val & 0xffff);
      *(uint64_t*)(host_mem + X86_ADDR_VAR_VMWRITE_VAL) = (val >> 16);
      break;
    default:
      exit(1);
    }
  }
  regs.rflags |= 2;
  fill_segment_descriptor(gdt, ldt, &seg_ldt);
  fill_segment_descriptor(gdt, ldt, &seg_cs16);
  fill_segment_descriptor(gdt, ldt, &seg_ds16);
  fill_segment_descriptor(gdt, ldt, &seg_cs16_cpl3);
  fill_segment_descriptor(gdt, ldt, &seg_ds16_cpl3);
  fill_segment_descriptor(gdt, ldt, &seg_cs32);
  fill_segment_descriptor(gdt, ldt, &seg_ds32);
  fill_segment_descriptor(gdt, ldt, &seg_cs32_cpl3);
  fill_segment_descriptor(gdt, ldt, &seg_ds32_cpl3);
  fill_segment_descriptor(gdt, ldt, &seg_cs64);
  fill_segment_descriptor(gdt, ldt, &seg_ds64);
  fill_segment_descriptor(gdt, ldt, &seg_cs64_cpl3);
  fill_segment_descriptor(gdt, ldt, &seg_ds64_cpl3);
  fill_segment_descriptor(gdt, ldt, &seg_tss32);
  fill_segment_descriptor(gdt, ldt, &seg_tss32_2);
  fill_segment_descriptor(gdt, ldt, &seg_tss32_cpl3);
  fill_segment_descriptor(gdt, ldt, &seg_tss32_vm86);
  fill_segment_descriptor(gdt, ldt, &seg_tss16);
  fill_segment_descriptor(gdt, ldt, &seg_tss16_2);
  fill_segment_descriptor(gdt, ldt, &seg_tss16_cpl3);
  fill_segment_descriptor_dword(gdt, ldt, &seg_tss64);
  fill_segment_descriptor_dword(gdt, ldt, &seg_tss64_cpl3);
  fill_segment_descriptor(gdt, ldt, &seg_cgate16);
  fill_segment_descriptor(gdt, ldt, &seg_tgate16);
  fill_segment_descriptor(gdt, ldt, &seg_cgate32);
  fill_segment_descriptor(gdt, ldt, &seg_tgate32);
  fill_segment_descriptor_dword(gdt, ldt, &seg_cgate64);
  if (ioctl(cpufd, KVM_SET_SREGS, &sregs))
    return -1;
  if (ioctl(cpufd, KVM_SET_REGS, &regs))
    return -1;
  return 0;
}

void enable_zswap()
{
  int fd =
      open("/syzcgroup/cpu/memory.compression_enabled", O_WRONLY | O_CLOEXEC);
  if (fd == -1) {
    return;
  }
  if (write(fd, "1", 1) != 1)
    exit(1);
  close(fd);
}

void setup_ext()
{
  mkdir("/sys/fs/ghost", 0777);
  mount(NULL, "/sys/fs/ghost", "ghost", 0, NULL);
  enable_zswap();
}

uint64_t r[3] = {0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff};

int main(void)
{
  syscall(__NR_mmap, /*addr=*/0x1ffffffff000ul, /*len=*/0x1000ul, /*prot=*/0ul,
          /*flags=MAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/ 0x32ul,
          /*fd=*/(intptr_t)-1, /*offset=*/0ul);
  syscall(__NR_mmap, /*addr=*/0x200000000000ul, /*len=*/0x1000000ul,
          /*prot=PROT_WRITE|PROT_READ|PROT_EXEC*/ 7ul,
          /*flags=MAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/ 0x32ul,
          /*fd=*/(intptr_t)-1, /*offset=*/0ul);
  syscall(__NR_mmap, /*addr=*/0x200001000000ul, /*len=*/0x1000ul, /*prot=*/0ul,
          /*flags=MAP_FIXED|MAP_ANONYMOUS|MAP_PRIVATE*/ 0x32ul,
          /*fd=*/(intptr_t)-1, /*offset=*/0ul);
  const char* reason;
  (void)reason;
  setup_ext();
  intptr_t res = 0;
  if (write(1, "executing program\n", sizeof("executing program\n") - 1)) {
  }
  memcpy((void*)0x200000000180, "/dev/kvm\000", 9);
  res = syscall(__NR_openat, /*fd=*/0xffffffffffffff9cul,
                /*file=*/0x200000000180ul, /*flags=O_RDWR*/ 2, /*mode=*/0);
  if (res != -1)
    r[0] = res;
  res = syscall(__NR_ioctl, /*fd=*/r[0], /*cmd=*/0xae01, /*type=*/0ul);
  if (res != -1)
    r[1] = res;
  res = syscall(__NR_ioctl, /*fd=*/r[1], /*cmd=*/0xae41, /*id=*/3ul);
  if (res != -1)
    r[2] = res;
  *(uint64_t*)0x200000000080 = 0x40;
  *(uint64_t*)0x200000000088 = 0x200000000000;
  memcpy(
      (void*)0x200000000000,
      "\x2e\xf3\x66\x44\xf7\xe6\x2e\x3e\x67\x2e\x45\x0f\x07\x8f\x29\xd0\x95\xab"
      "\xaa\x96\x00\x00\xb8\x90\xa4\xf0\x84\xef\x66\xba\xfc\x0c\x6d\x8f\x29\x78"
      "\x12\xcf\x66\xba\x41\x00\x66\xef\x48\xb8\x00\x10\x00\x00\x00\x00\x00\x00"
      "\x0f\x23\xd0\x0f\x21\xf8\x35\x10\x00\x00\x08\x0f\x23\xf8\x66\xba\xf8\x0c"
      "\xb8\x8e\xf0\x14\x80\xef\x66\xba\xfc\x0c\x66\xb8\x0c\x00\x66\xef\xc7\x44"
      "\x24\x02\xd8\x65\x00\x00\xc7\x44\x24\x06\x00\x00\x00\x00\x0f\x01\x1c\x24"
      "\x66\xba\x42\x00\xec\x2e\x64\xf3\x0f\x5a\x8e\x6c\x00\x00\x00",
      123);
  *(uint64_t*)0x200000000090 = 0x7b;
  *(uint64_t*)0x200000000200 = 8;
  STORE_BY_BITMASK(uint64_t, , 0x200000000208, 0, 0, 1);
  STORE_BY_BITMASK(uint64_t, , 0x200000000208, 1, 1, 5);
  STORE_BY_BITMASK(uint64_t, , 0x200000000208, 0, 6, 4);
  STORE_BY_BITMASK(uint64_t, , 0x200000000208, 0, 10, 2);
  STORE_BY_BITMASK(uint64_t, , 0x200000000208, 0, 12, 1);
  STORE_BY_BITMASK(uint64_t, , 0x200000000208, 2, 13, 2);
  STORE_BY_BITMASK(uint64_t, , 0x200000000208, 0, 15, 1);
  STORE_BY_BITMASK(uint64_t, , 0x200000000208, 0x85200000c, 16, 48);
  syz_kvm_setup_cpu(/*fd=*/r[1], /*cpufd=*/r[2], /*usermem=*/0x200000fe8000,
                    /*text=*/0x200000000080, /*ntext=*/1,
                    /*flags=KVM_SETUP_VM|KVM_SETUP_VIRT86|KVM_SETUP_PAE*/ 0x52,
                    /*opts=*/0x200000000200, /*nopt=*/1);
  *(uint64_t*)0x200000000240 = 3;
  *(uint64_t*)0x200000000248 = 0xec;
  *(uint64_t*)0x200000000250 = 0x401;
  *(uint64_t*)0x200000000258 = 3;
  *(uint64_t*)0x200000000260 = 7;
  *(uint64_t*)0x200000000268 = 4;
  *(uint64_t*)0x200000000270 = 0x8000000000000001;
  *(uint64_t*)0x200000000278 = 0x80000001;
  *(uint64_t*)0x200000000280 = 1;
  *(uint64_t*)0x200000000288 = 0x200;
  *(uint64_t*)0x200000000290 = 4;
  *(uint64_t*)0x200000000298 = 6;
  *(uint64_t*)0x2000000002a0 = 0xfffffffffffffffe;
  *(uint64_t*)0x2000000002a8 = 0x10000000003a;
  *(uint64_t*)0x2000000002b0 = 9;
  *(uint64_t*)0x2000000002b8 = 9;
  *(uint64_t*)0x2000000002c0 = 0;
  *(uint64_t*)0x2000000002c8 = 0x2280;
  syscall(__NR_ioctl, /*fd=*/r[2], /*cmd=*/0x4090ae82,
          /*arg=*/0x200000000240ul);
  syscall(__NR_ioctl, /*fd=*/r[2], /*cmd=*/0xae80, /*arg=*/0ul);
  *(uint64_t*)0x200000000140 = 8;
  *(uint64_t*)0x200000000148 = 0x2000000000c0;
  memcpy((void*)0x2000000000c0,
         "\xde\x61\x2a\x0f\x06\x66\xb9\xad\x02\x00\x00\x0f\x32\xf2\xf0\x10\x60"
         "\x5e\x0f\x20\x58\x66\xf0\x30\x73\xfc\xba\xd0\x04\x66\xb8\x00\x50\x00"
         "\x00\x66\xef\x3e\x0f\xc7\xa9\x00\x00\x3e\x65\x0f\x01\xca\xa3\x82\xb1",
         51);
  *(uint64_t*)0x200000000150 = 0x33;
  syz_kvm_setup_cpu(/*fd=*/r[1], /*cpufd=*/r[2], /*usermem=*/0x200000fe8000,
                    /*text=*/0x200000000140, /*ntext=*/1,
                    /*flags=KVM_SETUP_VM|KVM_SETUP_SMM|KVM_SETUP_PAGING*/ 0x61,
                    /*opts=*/0, /*nopt=*/0);
  syscall(__NR_ioctl, /*fd=*/r[2], /*cmd=*/0xae80, /*arg=*/0ul);
  return 0;
}



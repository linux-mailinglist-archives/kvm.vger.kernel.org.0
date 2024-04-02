Return-Path: <kvm+bounces-13330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BEDF7894A38
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 05:59:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 748401F243EB
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 03:59:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B9FA175A6;
	Tue,  2 Apr 2024 03:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="Ti281wdc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B76F15E85
	for <kvm@vger.kernel.org>; Tue,  2 Apr 2024 03:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712030336; cv=none; b=bAndCtZC7BYsRh5F+CWOz7ZC+68PZ/0MqpYcK6x47130+xs56ksjFmz7VEb2A8tbRGXm1sK9bbyTTDfiYbPB1NuJwgwMVA2utywB7uDNoblzB8cmx2n+lqUuGZJmK8pGZXac1dmC0bklrOW+dG6Qw+/fEVAOD9tXCXnIQ9yV4nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712030336; c=relaxed/simple;
	bh=ywvXNzTSFM0+RwoIQB3eo5N6AtGr3mdDxpmz8RcBuA8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zn68oGqBBbqhCEon7/aLA3EmMqPM/zmChPwK0tBcC/e3EQlY+Ef6cq5zad4nIl5XZ176lsSQhin23rs/TpTLEEHjkuA509bgGuEsapU8ryWnlJ69Zzxnx7dy17euc00eTwi+hzemUevq0MvXTpNph61chmyEmpeBQeZm4kqsDOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=Ti281wdc; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-368b9400e51so28206475ab.2
        for <kvm@vger.kernel.org>; Mon, 01 Apr 2024 20:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1712030334; x=1712635134; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9bxpt1Z3lVJ3TpGTCsuEJ8/rFaYKCKYvHpj+f0zHxL4=;
        b=Ti281wdct0GB40Hg7U8M2RREj9JVxsL5vj2Om3NSFYj5BGwAaswKW3tGklUMQj378l
         CiWk9+Ix5VS4qAk7+dzCXPEkrDIXPAnFPW+hkKkKAuMi25nhLAOOagWUOyqrSJhyuusd
         SMTs2tGoFbED+2TwfECVVSv0zKqWvK6tHK0hNnNZCLcz2nevpM+V9QTENTbBO0y2wkJ1
         rudCFyybeyvkzl+sJl+dGRaMUW+oPdqsFxoOD36gqyNusYAJubUoHrNegD4CxN+5bqtH
         CBCnj+lTswRK/zii67vqehTxj7eX6FE+zilUzGC26k5adGPw5B/1xouzEEOIjGbeKD3A
         a4EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712030334; x=1712635134;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9bxpt1Z3lVJ3TpGTCsuEJ8/rFaYKCKYvHpj+f0zHxL4=;
        b=d4FPneg7akWlEbFTge1jA/D3mo3ejqgfjB73TJZERbuftfTdH5MPYEnr2lzFLEq/5C
         nYm8+Jx7BCpwOeyBpibRu8ieiQLmhmdyhkVZVcpniDg/WA5sbgXymJmtHfXPT2ZTGNG5
         mD9NJkwSBeUqHbbvyugX6pcS3LxQn4eiFQtjrQlcmAqLfHMdqrRiPwrFPr44b5418fDu
         XkdYpbPyrULMlY5BIvW3xxyG72/UtZkUnOMWDFXWmmdx2UuibvzbV9JDMXq5E4VinoFX
         m2lSkMr9hqJeJIy2HmmwylyO3S4lXIG10ANqQdJb1ed++lC8iafqgL/YaZxepkZmbrCy
         Jgcw==
X-Gm-Message-State: AOJu0YzeSOkTtryoawo6KLt5Y305/SrQqbwF9QxSR5q9/kxN4Dgr4U94
	vCRS/RXbwrZwtiqf2d55WjXksZd/kgjxAUU27jt9jUvS/0sb4TVZR/vIaHAN5uJgohVVor4dJbO
	x2IOr7YJloxe1GPA84OWUKw3LBo6zUo9IKgqJEg==
X-Google-Smtp-Source: AGHT+IE/6+y8EEGe8ADutVzcbosZs3EgTtwEt4Xa4e+6ZfQfa1t6F08knGFoGJt5eCCTft/wUaKMU7ek4AeqOB81Mdc=
X-Received: by 2002:a05:6e02:1c23:b0:368:a502:14e0 with SMTP id
 m3-20020a056e021c2300b00368a50214e0mr10685689ilh.31.1712030334602; Mon, 01
 Apr 2024 20:58:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240327075526.31855-1-duchao@eswincomputing.com>
In-Reply-To: <20240327075526.31855-1-duchao@eswincomputing.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 2 Apr 2024 09:28:43 +0530
Message-ID: <CAAhSdy0vokWZopwdrFbY0XyVwNe98YeuQpCGKBP1Uxj-+v18ZA@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] RISC-V: KVM: Guest Debug Support - Software
 Breakpoint Part
To: Chao Du <duchao@eswincomputing.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, atishp@atishpatra.org, 
	pbonzini@redhat.com, shuah@kernel.org, dbarboza@ventanamicro.com, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	haibo1.xu@intel.com, duchao713@qq.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 27, 2024 at 1:29=E2=80=AFPM Chao Du <duchao@eswincomputing.com>=
 wrote:
>
> This series implements the "KVM Guset Debug" feature on RISC-V. This is
> an existing feature which is already supported by some other arches.
> It allows us to debug a RISC-V KVM guest from GDB in host side.
>
> As the first stage, the software breakpoints (ebreak instruction) is
> implemented. HW breakpoints support will come later after a synthetically
> consideration with the SBI debug trigger extension.
>
> A selftest case was added in this series. Manual test was done on QEMU
> RISC-V hypervisor emulator. (add '-s' to enable the gdbserver in QEMU)
>
> This series is based on Linux 6.9-rc1 and also available at:
> https://github.com/Du-Chao/kvm-riscv/tree/guest_debug_sw_v3_6.9-rc1
>
> The matched QEMU is available at:
> https://github.com/Du-Chao/qemu/tree/riscv_gd_sw
>
>
> Changes from v2->v3:
> - Rebased on Linux 6.9-rc1.
> - Use BIT() in the macro definition.
> - set/clear the bit EXC_BREAKPOINT explicitly.
> - change the testcase name to ebreak_test.
> - test the scenario without GUEST_DEBUG. vm_install_exception_handler() i=
s used
>   thanks to Haibo's patch.
>
> Changes from v1->v2:
> - Rebased on Linux 6.8-rc6.
> - Maintain a hedeleg in "struct kvm_vcpu_config" for each VCPU.
> - Update the HEDELEG csr in kvm_arch_vcpu_load().
>
> Changes from RFC->v1:
> - Rebased on Linux 6.8-rc2.
> - Merge PATCH1 and PATCH2 into one patch.
> - kselftest case added.
>
> v2 link:
> https://lore.kernel.org/kvm/20240301013545.10403-1-duchao@eswincomputing.=
com
> v1 link:
> https://lore.kernel.org/kvm/20240206074931.22930-1-duchao@eswincomputing.=
com
> RFC link:
> https://lore.kernel.org/kvm/20231221095002.7404-1-duchao@eswincomputing.c=
om
>
> Chao Du (3):
>   RISC-V: KVM: Implement kvm_arch_vcpu_ioctl_set_guest_debug()
>   RISC-V: KVM: Handle breakpoint exits for VCPU
>   RISC-V: KVM: selftests: Add ebreak test support

Please address Drew's comments on PATCH3 and send v4 so that I
can test this series at my end.

Regards,
Anup

>
>  arch/riscv/include/asm/kvm_host.h             | 12 +++
>  arch/riscv/kvm/main.c                         | 18 +---
>  arch/riscv/kvm/vcpu.c                         | 16 +++-
>  arch/riscv/kvm/vcpu_exit.c                    |  4 +
>  arch/riscv/kvm/vm.c                           |  1 +
>  tools/testing/selftests/kvm/Makefile          |  1 +
>  .../testing/selftests/kvm/riscv/ebreak_test.c | 84 +++++++++++++++++++
>  7 files changed, 118 insertions(+), 18 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/riscv/ebreak_test.c
>
> --
> 2.17.1
>


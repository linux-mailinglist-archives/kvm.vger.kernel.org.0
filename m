Return-Path: <kvm+bounces-10575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 477A986DABC
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 05:38:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F13BB22749
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 04:38:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0662C4F88B;
	Fri,  1 Mar 2024 04:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="nPhPizUK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C401E405DB
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 04:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709267905; cv=none; b=cSliStFOnS705LW6JOALJjNyIDM2DaGqMlyzRCYfhdBWwqL0Z+6KAut9TBNGKYCEccynhr83vbVBxPfoGJPC4/9YHwdugdfJavMXbYMWeyW5TCeIefA3GYQ9QQIKJVSr+ZTw7nUXFiLAnyRYBVi4cODdoseZ475WbWdsbqngXdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709267905; c=relaxed/simple;
	bh=KelcGq4IL6ezG4GiQZL0d1IXEUVFUvOtlBu7LT1nezw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rri1qcJb7WDJ+tsnwoMV5rdeeXFePf1mTSdti52ZBQc1OAmJ9ZC+IVBTCAWVIOFZe46WQLVavbaukvludb5vbytUATUXZQngyYr6o/Cq4YHbDUGOilcZB0c0GFn+iNehLc5TSGUHKdMjIA0qIbgHorIFblzSo3OgZLwER5i1SNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=nPhPizUK; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-365253c52aaso6179235ab.2
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 20:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1709267903; x=1709872703; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1olqrgkLOw515MKaZdUily4vC1k4vfwUPhwNHGA5LOk=;
        b=nPhPizUKmCLgDSeG9kPGSnTOtHKV4H42SoRR2Z3e8Mdb8q9hC1EhQot1Vav9IHNh+f
         71+9k6s4j0dwG8/UUFgc36tZRJ21TqrsRryazvLnuyZSLn4vmysBtM0KEMTw1q4ATYcB
         5fwjp9mzSBfcthRO62e7YM7pMSs5kG5EtYzXlrMPmFO9oD3E/WytU8V/YMZ9tsckDojY
         jRyDxDQ1l0UFfQNZGOhkJXNAY6Jx3f94DtGSZWCcKwDJEXUPqaW1vpkUeMFPFLY+OkN4
         IPufAoUIqZcawPIMgw+iy0AhUGklF2SUSAThbhgZMutIo1d/rDbU/wpmVK6UYsi5IrA7
         LYlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709267903; x=1709872703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1olqrgkLOw515MKaZdUily4vC1k4vfwUPhwNHGA5LOk=;
        b=RaCPKUzyiUiKeq5b0YVbLVr9Efj5VC1gCzUsiRXiwzceL/vdwE4YI0H3wsONLLHw/Z
         3ihZ7ZitaPxX1WiZDz/8Ywhvv7nOmCwEKdUk09KH71i4Q3e5yAxTMbJ0uvK27krvr3KZ
         X2o1lg1JnaMbDbFe/3eC7gNn65vt8zSt8VHbtFmRx1eVoYSgFS1AWY09p61kIN4oxaVW
         asIpXhec1lj1tHpkAIZjCk99Pcjr89uvywvtem9kq0FYRJA0EGMV1Ea7lanLGw8RbJYE
         8ZNvyFw8YXmM+v1T0FlhN95UOShDFJG4Hz/yzO701Be5/1mwrmtfMT8HIbRmMe38BaKn
         atCw==
X-Gm-Message-State: AOJu0Yyld/KC4yScN+ViX5iVyJYX9QQ0WEoajPu6PwbZIS89ao5TwqUc
	2ZZgEEYaIi0cG9AVwnZ2l/ohP4rCl0a+x0g8XaGz7CSJWzkL39QbEIE3HGm0DrqHdH4Q6K7xVt9
	Ya31A8aqICHgSzmNSIUeNU9eHc+kAwwG8h3XJKQ==
X-Google-Smtp-Source: AGHT+IH7Jg6cX9o2jsyDBFgc2qsJeqlVDD+J+N8+PQa7gEkpsHY+/RKmlB4xh/lgk/6ZpWTM3t3IawiS2XVcDyd3Mf0=
X-Received: by 2002:a05:6e02:160a:b0:365:2624:30b0 with SMTP id
 t10-20020a056e02160a00b00365262430b0mr833668ilu.24.1709267902877; Thu, 29 Feb
 2024 20:38:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240301013545.10403-1-duchao@eswincomputing.com> <20240301013545.10403-4-duchao@eswincomputing.com>
In-Reply-To: <20240301013545.10403-4-duchao@eswincomputing.com>
From: Anup Patel <anup@brainfault.org>
Date: Fri, 1 Mar 2024 10:08:12 +0530
Message-ID: <CAAhSdy3JaPqYp2O15WFDdenCA6k-pLPEeYVc3KrKjrSkHAQzZA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] RISC-V: KVM: selftests: Add breakpoints test support
To: Chao Du <duchao@eswincomputing.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, atishp@atishpatra.org, 
	pbonzini@redhat.com, shuah@kernel.org, dbarboza@ventanamicro.com, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	duchao713@qq.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This is actually a ebreak test so subject should be:
"RISC-V: KVM: selftests: Add ebreak test support"

On Fri, Mar 1, 2024 at 7:08=E2=80=AFAM Chao Du <duchao@eswincomputing.com> =
wrote:
>
> Initial support for RISC-V KVM breakpoint test. Check the exit reason
> and the PC when guest debug is enabled.

s/breakpoint/ebreak/

>
> Signed-off-by: Chao Du <duchao@eswincomputing.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |  1 +
>  .../testing/selftests/kvm/riscv/breakpoints.c | 49 +++++++++++++++++++

Rename riscv/breakpoints.c to riscv/ebreak_test.c

>  2 files changed, 50 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/riscv/breakpoints.c
>
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftes=
ts/kvm/Makefile
> index 492e937fab00..5f9048a740b0 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -184,6 +184,7 @@ TEST_GEN_PROGS_s390x +=3D rseq_test
>  TEST_GEN_PROGS_s390x +=3D set_memory_region_test
>  TEST_GEN_PROGS_s390x +=3D kvm_binary_stats_test
>
> +TEST_GEN_PROGS_riscv +=3D riscv/breakpoints
>  TEST_GEN_PROGS_riscv +=3D demand_paging_test
>  TEST_GEN_PROGS_riscv +=3D dirty_log_test
>  TEST_GEN_PROGS_riscv +=3D get-reg-list
> diff --git a/tools/testing/selftests/kvm/riscv/breakpoints.c b/tools/test=
ing/selftests/kvm/riscv/breakpoints.c
> new file mode 100644
> index 000000000000..be2d94837c83
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/riscv/breakpoints.c
> @@ -0,0 +1,49 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * RISC-V KVM breakpoint tests.

s/breakpoint tests/ebreak test/

> + *
> + * Copyright 2024 Beijing ESWIN Computing Technology Co., Ltd.
> + *
> + */
> +#include "kvm_util.h"
> +
> +#define PC(v) ((uint64_t)&(v))
> +
> +extern unsigned char sw_bp;
> +
> +static void guest_code(void)
> +{
> +       asm volatile("sw_bp: ebreak");
> +       asm volatile("nop");
> +       asm volatile("nop");
> +       asm volatile("nop");
> +
> +       GUEST_DONE();
> +}
> +
> +int main(void)
> +{
> +       struct kvm_vm *vm;
> +       struct kvm_vcpu *vcpu;
> +       struct kvm_guest_debug debug;
> +       uint64_t pc;
> +
> +       TEST_REQUIRE(kvm_has_cap(KVM_CAP_SET_GUEST_DEBUG));
> +
> +       vm =3D vm_create_with_one_vcpu(&vcpu, guest_code);
> +
> +       memset(&debug, 0, sizeof(debug));
> +       debug.control =3D KVM_GUESTDBG_ENABLE;
> +       vcpu_guest_debug_set(vcpu, &debug);
> +       vcpu_run(vcpu);
> +
> +       TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_DEBUG);

This is only testing the case where KVM_GUESTDBG_ENABLE is set.

This test should be enhanced to:
1) First test "ebreak" executed by Guest when KVM_GUESTDBG_ENABLE
    is not set. Here, we would expect main() to receive KVM_EXIT_DEBUG.
2) Second test "ebreak" executed by Guest when KVM_GUESTDBG_ENABLE
   is set. Here, we would expect main() will not receive KVM_EXIT_DEBUG.

> +
> +       vcpu_get_reg(vcpu, RISCV_CORE_REG(regs.pc), &pc);
> +
> +       TEST_ASSERT_EQ(pc, PC(sw_bp));
> +
> +       kvm_vm_free(vm);
> +
> +       return 0;
> +}
> --
> 2.17.1
>

Regards,
Anup


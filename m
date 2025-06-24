Return-Path: <kvm+bounces-50498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F6F8AE67EA
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 16:12:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 723731894F6B
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 14:10:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59CC42D1925;
	Tue, 24 Jun 2025 14:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Xi27Plsy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F9F296147
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 14:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750774210; cv=none; b=jXHGnAbzhMQ+ZI4CiGtSfH2OTnR+BlwgWpNkfRwdg2vqc5J3gUi42P7TLEb8L3d60ZUvdYKyfqk2tx1RV55tPHTzVsYJEqgeu908XLsTfXrjeoahFDx5mTTBCkmnLdATpSHRgYUo79/OuNcHwnK7czUv0QnBysWQNVhChdIk3w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750774210; c=relaxed/simple;
	bh=qj/CWqHLyhMEEnGdAVi2FKgDX7NQhEFCDAoqdAeRp2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T7IlbxcRN1b7PuuOB1Zq640D2bjNJf6IMntBZqnmvqiBWs+qdFti3bShMQlXIiRKnyr5cSGnBBNi9PsrThbqY/BXFOp0VbVNzzzvo20k7Y+vKkqFkUSLfUsGUCt7DnFOlIUhvKfeOUuN0DdqHbVj1Qi21r1fpIn1W3YZ6iHD4a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Xi27Plsy; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-450cfb79177so3088135e9.0
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 07:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1750774207; x=1751379007; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MQ7CvyZIlkZs87gjY0NM1qz59baVwPwR/W8k37uo164=;
        b=Xi27PlsyZzSlZ1Hm5UeBtd4XfHF2eUXlrtvOhE/GTof2j8pvV7qU+ulra0manN8uhx
         SxgEXA1rUtksBTYFws/XJZxJ77ccb0I5fFvOxi7DJLciG6036XIpeYiO0FoSc3W04W6j
         BgXwyal62Tkb2ouuNDFpJAh2omVWlBw2iLk/7qa/fna46KUZm1t5l0UqvUsPuSL2Gzrf
         ltiTPj4uRrkL3DABeWm7whb2Sztia4kDmPPZwj6/sbnQbv6cU/2qcJ4QXoRz/Qc/fC5R
         QgzEfVymKOklYE1rPbn9ynPS7g7Xg6ID6NnCLAuC7oM7q69Wei256jJuOe6Ugr5OEZMB
         UUAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750774207; x=1751379007;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MQ7CvyZIlkZs87gjY0NM1qz59baVwPwR/W8k37uo164=;
        b=a9tnNtptiZw6Ek2ImGW1se+dg9iZsAnztFm2EhfQjQhCE9vtvQnJpq0XJVn2vBacf0
         qLgFZWix/lhmqErq6uvjbd71GLdC4Ra8iPyuvUx3G7TE3yn9YQYgs+Gh0yY+XfWPc1mM
         gr+tJbZ+801RDXbnZUiWx70ZyDsrYPOKHCAmPJnR0ZjqIyug069/Od/8UVTe6CSxEzP1
         l1QuHozsVFBQt25YI/BJVXVe5AWuOM1YtwOlAqYQU4F7OBU3rtJoUIIFtG9WCqAf0/5t
         k5KMVYXTjsgHh9giwUrvGrlJmQlU4SE3Z0Cs4kcKB26HRPM60JNwfiHnW2Ga1UT/KdEh
         MP1A==
X-Forwarded-Encrypted: i=1; AJvYcCWbuyzKj4ubDroMX0zG2jMpJXOBV+x4atu85C3bLiIeFXAOYoS20NS2cn5pCFoUlv6Mook=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3IsGd6F31JuJaThTu0zkuOXrN9ZPwDYqZNzogKz3tBDJs40Zt
	N6gH7gyh9fUyCmhSQ7mXtYPJ1IGGj5LNhSWJyAMtC1GyjxcOAHUEFlnVmnaUveE8N8E=
X-Gm-Gg: ASbGncuvYx9h+iJDv6R8BAMAhrKp41XHv2MsZFwMAvimQjB+8//+07embwO++F/ZilM
	G8LLMZ+T3dikVP719cHF8ZTJKGC2hn8D0nCw/PeN0x37a4/jdSxp+oe4rqxpy+dRuLW4MGsMS6Z
	OtZvDFRKevQD3v9V1tsgCErEDGJYMUCLe9pAifqlxu+X0N3SGBDYoKAjbNY8vaIIBevyuYVkc1y
	jZAC3165b6R3MtigdW2wnHxp5GhhjsJ6PMSU1TMnd7ELUn7rhysFPGXwMcn8zlplbctsZz/LMaj
	+9CNqNuVXu9eCp2lXbL4KxvkSey571D5kqBYPhOdx1ikhlxJHQ==
X-Google-Smtp-Source: AGHT+IEJeX4diRkZ29kEnrmPsfhU9TcNr2AZ9X1Thlmc1YkCR6UEhFhLrNxHaOV0+h9u10fRDQFJlw==
X-Received: by 2002:a05:600c:3b24:b0:453:c39:d0a7 with SMTP id 5b1f17b1804b1-453653cf416mr150568745e9.5.1750774206936;
        Tue, 24 Jun 2025 07:10:06 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200::5485])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e81106b8sm2090841f8f.91.2025.06.24.07.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 07:10:05 -0700 (PDT)
Date: Tue, 24 Jun 2025 16:10:04 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: zhouquan@iscas.ac.cn
Cc: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH 2/2] KVM: riscv: selftests: Add common supported test
 cases
Message-ID: <20250624-d7b4b9ba702fcaf2f42695b1@orel>
References: <cover.1749810735.git.zhouquan@iscas.ac.cn>
 <7e8f1272337e8d03851fd3bb7f6fc739e604309e.1749810736.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e8f1272337e8d03851fd3bb7f6fc739e604309e.1749810736.git.zhouquan@iscas.ac.cn>

On Fri, Jun 13, 2025 at 07:30:13PM +0800, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
> 
> Some common KVM test cases are supported on riscv now as following:
> 
>     access_tracking_perf_test
>     demand_paging_test
>     dirty_log_perf_test
>     dirty_log_test
>     guest_print_test
>     kvm_binary_stats_test
>     kvm_create_max_vcpus
>     kvm_page_table_test
>     memslot_modification_stress_test
>     memslot_perf_test
>     rseq_test
>     set_memory_region_test

Half this list is already build for riscv since they're common. See
TEST_GEN_PROGS_COMMON. If the other half can be built and run then
please send a separate patch, not something tacked onto this series,
since they're all unrelated to the series.

> 
> Add missing headers for tests and fix RISCV_FENCE redefinition
> in `rseq-riscv.h` by using the existing macro from <asm/fence.h>.
> 
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>  tools/testing/selftests/kvm/Makefile.kvm             | 12 ++++++++++++
>  .../testing/selftests/kvm/include/riscv/processor.h  |  2 ++
>  tools/testing/selftests/rseq/rseq-riscv.h            |  3 +--
>  3 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index 38b95998e1e6..565e191e99c8 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -197,6 +197,18 @@ TEST_GEN_PROGS_riscv += arch_timer
>  TEST_GEN_PROGS_riscv += coalesced_io_test
>  TEST_GEN_PROGS_riscv += get-reg-list
>  TEST_GEN_PROGS_riscv += steal_time
> +TEST_GEN_PROGS_riscv += access_tracking_perf_test
> +TEST_GEN_PROGS_riscv += demand_paging_test
> +TEST_GEN_PROGS_riscv += dirty_log_perf_test
> +TEST_GEN_PROGS_riscv += dirty_log_test
> +TEST_GEN_PROGS_riscv += guest_print_test
> +TEST_GEN_PROGS_riscv += kvm_binary_stats_test
> +TEST_GEN_PROGS_riscv += kvm_create_max_vcpus
> +TEST_GEN_PROGS_riscv += kvm_page_table_test
> +TEST_GEN_PROGS_riscv += memslot_modification_stress_test
> +TEST_GEN_PROGS_riscv += memslot_perf_test
> +TEST_GEN_PROGS_riscv += rseq_test
> +TEST_GEN_PROGS_riscv += set_memory_region_test
>  
>  TEST_GEN_PROGS_loongarch += coalesced_io_test
>  TEST_GEN_PROGS_loongarch += demand_paging_test
> diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/tools/testing/selftests/kvm/include/riscv/processor.h
> index 162f303d9daa..4cf5ae11760f 100644
> --- a/tools/testing/selftests/kvm/include/riscv/processor.h
> +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
> @@ -9,7 +9,9 @@
>  
>  #include <linux/stringify.h>
>  #include <asm/csr.h>
> +#include <asm/vdso/processor.h>
>  #include "kvm_util.h"
> +#include "ucall_common.h"

These should be included directly from the tests that need them.

>  
>  #define INSN_OPCODE_MASK	0x007c
>  #define INSN_OPCODE_SHIFT	2
> diff --git a/tools/testing/selftests/rseq/rseq-riscv.h b/tools/testing/selftests/rseq/rseq-riscv.h
> index 67d544aaa9a3..06c840e81c8b 100644
> --- a/tools/testing/selftests/rseq/rseq-riscv.h
> +++ b/tools/testing/selftests/rseq/rseq-riscv.h
> @@ -8,6 +8,7 @@
>   * exception when executed in all modes.
>   */
>  #include <endian.h>
> +#include <asm/fence.h>
>  
>  #if defined(__BYTE_ORDER) ? (__BYTE_ORDER == __LITTLE_ENDIAN) : defined(__LITTLE_ENDIAN)
>  #define RSEQ_SIG   0xf1401073  /* csrr mhartid, x0 */
> @@ -24,8 +25,6 @@
>  #define REG_L	__REG_SEL("ld ", "lw ")
>  #define REG_S	__REG_SEL("sd ", "sw ")
>  
> -#define RISCV_FENCE(p, s) \
> -	__asm__ __volatile__ ("fence " #p "," #s : : : "memory")
>  #define rseq_smp_mb()	RISCV_FENCE(rw, rw)
>  #define rseq_smp_rmb()	RISCV_FENCE(r, r)
>  #define rseq_smp_wmb()	RISCV_FENCE(w, w)
> -- 
> 2.34.1

tools/testing/selftests/rseq isn't under KVM's purview, so this should be
a separate patch CC'ing the appropriate people and lists.

Thanks,
drew


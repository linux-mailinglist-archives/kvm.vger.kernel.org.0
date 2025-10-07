Return-Path: <kvm+bounces-59570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 86A98BC17E5
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 15:30:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BD4E834F518
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 13:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75CC22D3EDF;
	Tue,  7 Oct 2025 13:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ngvNWPWq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9F12E0B60
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 13:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759843806; cv=none; b=EBF8Vg5ZHHtO4sDqY4NWBt+mQ7UcF9XcaL5bWdI7B68sMjvI34zIxqvauY0yCkVwvIrCzsvxyfN8u4lE7ycNJYKxPWf0lYvm+c4Bbuhdukh9Lww013ubxNe/qni/OpZiT/Kxs/Xh6yo3Whz/XHvWozrLoNoyVxXwcdEMb80hGBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759843806; c=relaxed/simple;
	bh=TwwiogZc8xo1YJUpuNs1zi62sRqGOq6ansMy0lbQ4TE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K+2scR8haob8POu5l/1kbo8S/JEQGPi5PJHjtfvzeSdr8RjszOX2TD1fiaOTLNHqrTNavxPFEabPDxB/mGW/36CWYaurV7GegbFYeCFXVPhrJbJf2CH5DO2E6oalvTaldp9whQrKJSYzJyC0ixtGBpuiXkrid1eWXqMVTLHYqp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ngvNWPWq; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-4291359714eso55367985ab.1
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 06:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1759843803; x=1760448603; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5u6Ur4oT6s0jXoCTIiLRdpi+SLDQablwl5SIadoUr04=;
        b=ngvNWPWqyLOBQpijCn1+fKoX+CJMpbXXVUHwJmWQ3MmMPqLagRnq/cqarjqQ5igC2d
         cLneUd43yPhTLbnAgp7jgslGc9RweLmvjBYxT2enX5C6OOIYMvYZmKkDyAm8a3oqr7bg
         kLPe/IL23BbPUJTRGJPVt2Njrx7XI5nqBXglhhZp76HhEOLM5OBPfhrDjKiCDr2dVanW
         gpsGOPp2zODMNBNQ3bEoIz617t8trB+Cw7fokdpbtUdvVPSO//ikURmRrR/MW02h1eIo
         4fDs8MQs71cLx2Fv3WdrASVGUrS3Ds6RL6PZWWBKNaea7DY+eC4B7aX+Hwry1n5Qz3Zh
         sJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759843803; x=1760448603;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5u6Ur4oT6s0jXoCTIiLRdpi+SLDQablwl5SIadoUr04=;
        b=DFjXZAuQz8ouEKiE0GZcbrFfk7eiqlz36pEyoLbSZxvdlbF1teFGr8OYfzDvQW+2rl
         ssVQbi0Dm7/MHUcmtiUjwGhx3eAbxVxINql4CeTN1owjpwHc4MTqVkkQmtfIR0tzkIlR
         VdVfg02fOPYh93MLr00tCsB2xATmtxwZ09w4LhLrDv8p84cxIVMjNc5TdolUTd0pFHrb
         YR4zNt2mHR/v8j+BTwgdvuQ4v/4M3Bd8x6nSZ0ij01i/hk75MCHHsDqgRK3vYlnyPQsn
         Y3ar3dwAEQCL8U6YaqTXbLPd31QRNsBTZqksWYwYDm8q8Ok5SsOZOLs6tN9HWZQP0WCQ
         Kg8w==
X-Forwarded-Encrypted: i=1; AJvYcCVSLEZ80kJuM5IFJ5sxKcli0uPDTXJDCsKucg74vvWg5B+K6KINsQGb6/9x1JVMY7E66fA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUCVEIEUNQu9XMUianKG5c4ZcKtR0JKzS4OvunahqqY3tw6uoJ
	neR+7SVOwcox3N+tUf5s+ibR85eNYQOfpxD0epj1TUnysaQHdDsJCAz+7uX1nVkwnKk=
X-Gm-Gg: ASbGncucPZ+ZSJ6AnEytpN0Y/3BzfA3twManWlmZQjApduoDk4S8DD7vxRqlTUQ4aKF
	Y7w+0zbTQefQVdiN3hRDxSMwkZ8HZbxBGmi54+O14bqtvloO9N8ZeaAfMb9ptPFTkCcSEM0M6wJ
	4QnxVamCK1ggdqAHCwyWoQJzTDnXwMYJnHE87RxNWbZLiEab9BYx2/Ji3z3PiUQ6t79xXzqO7CV
	27PafeGzMMLgY+uNezhaqZGMNxWQpqOfezYrdUO6cz3KLDMdaXYRge4YdLjbg4/5+vrzq8ZhZUB
	ufGLWEkzJmKmB63+hvvi4uPSS1QgPsaFn4097MuTCn91u42RhoK9HoF8GsRiOoAZsV93xjF8Lot
	ZwVcE8oVNWpz8WGIokWV7N9eVlKLH/OVA0uU5Kr38jKZFJ4/V
X-Google-Smtp-Source: AGHT+IH4v0smDXGJoO2/bNfPuuXziacLVjQ6SQwubdaf2LC1SFVxIjbd2i4GmNAZcFHgw8u2RhgIHw==
X-Received: by 2002:a05:6e02:168e:b0:424:14a4:5064 with SMTP id e9e14a558f8ab-42e7ac437a1mr208082325ab.0.1759843802699;
        Tue, 07 Oct 2025 06:30:02 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-57b5ec0b026sm6035706173.59.2025.10.07.06.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 06:30:02 -0700 (PDT)
Date: Tue, 7 Oct 2025 08:30:01 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Weiwei Li <liwei1518@gmail.com>, 
	David Hildenbrand <david@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>, qemu-s390x@nongnu.org, Song Gao <gaosong@loongson.cn>, 
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, Matthew Rosato <mjrosato@linux.ibm.com>, 
	Eric Farman <farman@linux.ibm.com>, Richard Henderson <richard.henderson@linaro.org>, 
	Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org, Aurelien Jarno <aurelien@aurel32.net>, 
	Aleksandar Rikalo <arikalo@gmail.com>, Marcelo Tosatti <mtosatti@redhat.com>, 
	Huacai Chen <chenhuacai@kernel.org>, qemu-riscv@nongnu.org, Nicholas Piggin <npiggin@gmail.com>, 
	Harsh Prateek Bora <harshpb@linux.ibm.com>, Chinmay Rath <rathc@linux.ibm.com>, 
	Ilya Leoshkevich <iii@linux.ibm.com>, Thomas Huth <thuth@redhat.com>, qemu-ppc@nongnu.org, 
	Alistair Francis <alistair.francis@wdc.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: Re: [PATCH 3/3] accel/kvm: Factor kvm_cpu_synchronize_put() out
Message-ID: <20251007-650e7ef70cc4591d1ef647f1@orel>
References: <20251007081616.68442-1-philmd@linaro.org>
 <20251007081616.68442-4-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251007081616.68442-4-philmd@linaro.org>

On Tue, Oct 07, 2025 at 10:16:16AM +0200, Philippe Mathieu-Daudé wrote:
> The same code is duplicated 3 times: factor a common method.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  accel/kvm/kvm-all.c | 47 ++++++++++++++++++---------------------------
>  1 file changed, 19 insertions(+), 28 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 9060599cd73..de79f4ca099 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -2935,22 +2935,32 @@ void kvm_cpu_synchronize_state(CPUState *cpu)
>      }
>  }
>  
> -static void do_kvm_cpu_synchronize_post_reset(CPUState *cpu, run_on_cpu_data arg)
> +static bool kvm_cpu_synchronize_put(CPUState *cpu, KvmPutState state,
> +                                    const char *desc)
>  {
>      Error *err = NULL;
> -    int ret = kvm_arch_put_registers(cpu, KVM_PUT_RESET_STATE, &err);
> +    int ret = kvm_arch_put_registers(cpu, state, &err);
>      if (ret) {
>          if (err) {
> -            error_reportf_err(err, "Restoring resisters after reset: ");
> +            error_reportf_err(err, "Restoring resisters %s: ", desc);
>          } else {
> -            error_report("Failed to put registers after reset: %s",
> +            error_report("Failed to put registers %s: %s", desc,
>                           strerror(-ret));
>          }
> -        cpu_dump_state(cpu, stderr, CPU_DUMP_CODE);
> -        vm_stop(RUN_STATE_INTERNAL_ERROR);
> +        return false;
>      }
>  
>      cpu->vcpu_dirty = false;
> +
> +    return true;
> +}
> +
> +static void do_kvm_cpu_synchronize_post_reset(CPUState *cpu, run_on_cpu_data arg)
> +{
> +    if (kvm_cpu_synchronize_put(cpu, KVM_PUT_RESET_STATE, "after reset")) {

This should be !kvm_cpu_synchronize_put() and same comment for the other
calls below.

Thanks,
drew

> +        cpu_dump_state(cpu, stderr, CPU_DUMP_CODE);
> +        vm_stop(RUN_STATE_INTERNAL_ERROR);
> +    }
>  }
>  
>  void kvm_cpu_synchronize_post_reset(CPUState *cpu)
> @@ -2964,19 +2974,9 @@ void kvm_cpu_synchronize_post_reset(CPUState *cpu)
>  
>  static void do_kvm_cpu_synchronize_post_init(CPUState *cpu, run_on_cpu_data arg)
>  {
> -    Error *err = NULL;
> -    int ret = kvm_arch_put_registers(cpu, KVM_PUT_FULL_STATE, &err);
> -    if (ret) {
> -        if (err) {
> -            error_reportf_err(err, "Putting registers after init: ");
> -        } else {
> -            error_report("Failed to put registers after init: %s",
> -                         strerror(-ret));
> -        }
> +    if (kvm_cpu_synchronize_put(cpu, KVM_PUT_FULL_STATE, "after init")) {
>          exit(1);
>      }
> -
> -    cpu->vcpu_dirty = false;
>  }
>  
>  void kvm_cpu_synchronize_post_init(CPUState *cpu)
> @@ -3166,20 +3166,11 @@ int kvm_cpu_exec(CPUState *cpu)
>          MemTxAttrs attrs;
>  
>          if (cpu->vcpu_dirty) {
> -            Error *err = NULL;
> -            ret = kvm_arch_put_registers(cpu, KVM_PUT_RUNTIME_STATE, &err);
> -            if (ret) {
> -                if (err) {
> -                    error_reportf_err(err, "Putting registers after init: ");
> -                } else {
> -                    error_report("Failed to put registers after init: %s",
> -                                 strerror(-ret));
> -                }
> +            if (kvm_cpu_synchronize_put(cpu, KVM_PUT_RUNTIME_STATE,
> +                                        "at runtime")) {
>                  ret = -1;
>                  break;
>              }
> -
> -            cpu->vcpu_dirty = false;
>          }
>  
>          kvm_arch_pre_run(cpu, run);
> -- 
> 2.51.0
> 
> 


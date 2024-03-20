Return-Path: <kvm+bounces-12308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7A7F881325
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 15:15:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E0D9289BB9
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 14:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB6D74AEC1;
	Wed, 20 Mar 2024 14:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BT9v+W6U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B44942073;
	Wed, 20 Mar 2024 14:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710944109; cv=none; b=u6/jYh2zH4MSsLojtLk0W1O87Sto63oFClJpVTjPKsVgfRmZazDWJWhBqsxkSsGjtkkTNbmuS7ob9a7f2z/i/39Yd1/XssHPQKJyYp1LFqNMZ9QLRDogH+9uZCZgdsd0buUwGRdeyugf3trj06R4NJqol1K1CrGzE7lMcEaHNV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710944109; c=relaxed/simple;
	bh=UMYuPLOrQ5QFAar/1uhGdEWKpj3OE4Mi7ol0aibRfxA=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=SDeT8504u1Y1wFv3T8jeU4ArZ8ZANRG3sjVSwGycZztNc2ow4qHF8NMdrp8a19O3wQxbVinvhUuBVXtGcsUWc6YYwwrVnb6KhYXpZ34r6DA1MFimyrCBXUGM97AjAh/JjpJPKEhjfJUosL6bgAAP+jO2JlCtfqp0x7CVWJmyjVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BT9v+W6U; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6e6f6d782e4so4608592b3a.0;
        Wed, 20 Mar 2024 07:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710944107; x=1711548907; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cyMQ+8dkMkvcjrYhj/YbvYKdLMOP0zpLYG0B4M+Jlis=;
        b=BT9v+W6UUsNMWV7VfsAxak6yFMlKNrSgWkb/iSiCsIcJ8PmOFSUr39MPYFYuRMwfcE
         7x6abV82vUrA6Nsh+FJTbeGFKZiHhe/Po2jVmHvsAPi3qlSpsz1yOzL9Wc5cnVXe3FBd
         dhZwTuo0VtBJn/famCkQpqBalpAiLQ3HSS5xPk7pU1yyb94X1sSQnjH2Y/3h4327zJPv
         ANe6fF0sEyUiH3XDZ7K7dttIW+0CujdESsOQ1IJmtrzmylv6DBOVp9VADrYx/GZJ6jn8
         bVImeouaLtuLgfGN6FJanCd80tm05+Ulsp84b6DlqeBoXvBMwTR7ULeX1lr/zSdn5RV6
         IX7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710944107; x=1711548907;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cyMQ+8dkMkvcjrYhj/YbvYKdLMOP0zpLYG0B4M+Jlis=;
        b=kRn450RMvh5jlGVnqEu7Gcw8rGJ1IIFcuXEj77CvMN8lm0CefJeoJ9dNTaYphlkVdH
         QaadqXT9DEYPuak82zV2vadOJFQkp83SPMUnNyF4s4pPsRL5nEuMgv/RWLJZwRkcew2p
         Pn9pQUlIUnSXYYt66Ott9c15A2jrF5h1JdfJrmkysgABBgcyTS0Goe7LoUdRvZosMhM3
         qWjlvVZbJW2XuMndKPD9PeeZq6tlzTFU5FvfvYbQ9LViW1LIjYRNDR2Gl6yRehmAAk2w
         6mFLTz3S3z6uLyyq9amq0jeFlkebdoZTaG8GN099/6ndjZ67ePK2p0vKFbpuG4As9rea
         4NLw==
X-Forwarded-Encrypted: i=1; AJvYcCW+Zy6P8v4V67TAUJ2+jXqmwqvwOTi6PwmNjp3YrxB0v8nvCBsAOQA9iQmTG+uKhhUqovQfD95fGmzFe7q0yG0gYLGWdPXhoQLTIlKK2RMSIJAuQGM3UtWYSAa1gBuhlQcI
X-Gm-Message-State: AOJu0YzuYrG4/XiQXwKbl1LzAK5h6NGNKpDo15Oslnk4vfYITx9mA5mW
	EVFuZNUCOgm8ssyVW8PVL2B8Rci9p7rWIuYQEAFYhAApEKSGnxFH
X-Google-Smtp-Source: AGHT+IEBoSbM9cPtFd7ZC+s4hE1kj4RJvDY5Pf8+BlYELGhMMMflFhnxv7spDETq1/cWJeznnbL6PQ==
X-Received: by 2002:a05:6a00:2d8f:b0:6e7:8218:e75 with SMTP id fb15-20020a056a002d8f00b006e782180e75mr2504299pfb.7.1710944107582;
        Wed, 20 Mar 2024 07:15:07 -0700 (PDT)
Received: from localhost (193-116-208-39.tpgi.com.au. [193.116.208.39])
        by smtp.gmail.com with ESMTPSA id gu25-20020a056a004e5900b006e7040519a1sm8260357pfb.216.2024.03.20.07.15.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Mar 2024 07:15:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 21 Mar 2024 00:15:01 +1000
Message-Id: <CZYN2DBLH8Q2.U5H1A6VDAUY7@wheely>
Cc: <linuxppc-dev@lists.ozlabs.org>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, "Vaibhav Jain" <vaibhav@linux.ibm.com>
Subject: Re: [PATCH] arch/powerpc/kvm: Add support for reading VPA counters
 for pseries guests
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Gautam Menghani" <gautam@linux.ibm.com>, <mpe@ellerman.id.au>,
 <christophe.leroy@csgroup.eu>, <aneesh.kumar@kernel.org>,
 <naveen.n.rao@linux.ibm.com>
X-Mailer: aerc 0.15.2
References: <20240319142807.95547-1-gautam@linux.ibm.com>
In-Reply-To: <20240319142807.95547-1-gautam@linux.ibm.com>

On Wed Mar 20, 2024 at 12:28 AM AEST, Gautam Menghani wrote:
> PAPR hypervisor has introduced three new counters in the VPA area of
> LPAR CPUs for KVM L2 guest (see [1] for terminology) observability - 2
> for context switches from host to guest and vice versa, and 1 counter
> for getting the total time spent inside the KVM guest. Add a tracepoint
> that enables reading the counters for use by ftrace/perf. Note that this
> tracepoint is only available for nestedv2 API (i.e, KVM on PowerVM).
>
> [1] Terminology:
> a. L1 refers to the VM (LPAR) booted on top of PAPR hypervisor
> b. L2 refers to the KVM guest booted on top of L1.
>
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
> ---
>  arch/powerpc/include/asm/kvm_host.h |  5 +++++
>  arch/powerpc/include/asm/lppaca.h   | 11 ++++++++---
>  arch/powerpc/kvm/book3s_hv.c        | 20 ++++++++++++++++++++
>  arch/powerpc/kvm/trace_hv.h         | 24 ++++++++++++++++++++++++
>  4 files changed, 57 insertions(+), 3 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/a=
sm/kvm_host.h
> index 8abac5321..26d7bb4b9 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -847,6 +847,11 @@ struct kvm_vcpu_arch {
>  	gpa_t nested_io_gpr;
>  	/* For nested APIv2 guests*/
>  	struct kvmhv_nestedv2_io nestedv2_io;
> +
> +	/* For VPA counters having context switch and guest run time info (in n=
s) */
> +	u64 l1_to_l2_cs;
> +	u64 l2_to_l1_cs;
> +	u64 l2_runtime;
>  #endif
> =20
>  #ifdef CONFIG_KVM_BOOK3S_HV_EXIT_TIMING

These aren't required here if it's just used for tracing over
a single run vcpu call are they?

> diff --git a/arch/powerpc/include/asm/lppaca.h b/arch/powerpc/include/asm=
/lppaca.h
> index 61ec2447d..bda6b86b9 100644
> --- a/arch/powerpc/include/asm/lppaca.h
> +++ b/arch/powerpc/include/asm/lppaca.h
> @@ -62,7 +62,8 @@ struct lppaca {
>  	u8	donate_dedicated_cpu;	/* Donate dedicated CPU cycles */
>  	u8	fpregs_in_use;
>  	u8	pmcregs_in_use;
> -	u8	reserved8[28];
> +	u8	l2_accumul_cntrs_enable;  /* Enable usage of counters for KVM guest =
*/
> +	u8	reserved8[27];
>  	__be64	wait_state_cycles;	/* Wait cycles for this proc */
>  	u8	reserved9[28];
>  	__be16	slb_count;		/* # of SLBs to maintain */
> @@ -92,9 +93,13 @@ struct lppaca {
>  	/* cacheline 4-5 */
> =20
>  	__be32	page_ins;		/* CMO Hint - # page ins by OS */
> -	u8	reserved12[148];
> +	u8	reserved12[28];
> +	volatile __be64 l1_to_l2_cs_tb;
> +	volatile __be64 l2_to_l1_cs_tb;
> +	volatile __be64 l2_runtime_tb;
> +	u8 reserved13[96];
>  	volatile __be64 dtl_idx;	/* Dispatch Trace Log head index */
> -	u8	reserved13[96];
> +	u8	reserved14[96];
>  } ____cacheline_aligned;
> =20
>  #define lppaca_of(cpu)	(*paca_ptrs[cpu]->lppaca_ptr)
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 2b04eba90..b94461b5f 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -4092,6 +4092,7 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vcp=
u *vcpu, u64 time_limit,
>  	unsigned long msr, i;
>  	int trap;
>  	long rc;
> +	struct lppaca *lp =3D get_lppaca();

Does get_lppaca() emit some inline asm that can't be optimised?
Could move it under the unlikely branches if so.

> =20
>  	io =3D &vcpu->arch.nestedv2_io;
> =20

KVM L0 could in theory provide this for v1 L1s too, so could this
be done at a higher level to cover both?

> @@ -4107,6 +4108,17 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vc=
pu *vcpu, u64 time_limit,
>  	kvmppc_gse_put_u64(io->vcpu_run_input, KVMPPC_GSID_LPCR, lpcr);
> =20
>  	accumulate_time(vcpu, &vcpu->arch.in_guest);
> +
> +	/* Reset the guest host context switch timing */
> +	if (unlikely(trace_kvmppc_vcpu_exit_cs_time_enabled())) {
> +		lp->l2_accumul_cntrs_enable =3D 1;
> +		lp->l1_to_l2_cs_tb =3D 0;
> +		lp->l2_to_l1_cs_tb =3D 0;
> +		lp->l2_runtime_tb =3D 0;
> +	} else {
> +		lp->l2_accumul_cntrs_enable =3D 0;
> +	}

Instead of zeroing here zero after the exit, which avoids the
else branch and possibly avoids an obscure race with the counters.
What if trace_kvmppc_vcpu_exit_cs_time_enabled() is false here...

> +
>  	rc =3D plpar_guest_run_vcpu(0, vcpu->kvm->arch.lpid, vcpu->vcpu_id,
>  				  &trap, &i);
> =20
> @@ -4133,6 +4145,14 @@ static int kvmhv_vcpu_entry_nestedv2(struct kvm_vc=
pu *vcpu, u64 time_limit,
> =20
>  	timer_rearm_host_dec(*tb);
> =20
> +	/* Record context switch and guest_run_time data */
> +	if (unlikely(trace_kvmppc_vcpu_exit_cs_time_enabled())) {
> +		vcpu->arch.l1_to_l2_cs =3D tb_to_ns(be64_to_cpu(lp->l1_to_l2_cs_tb));
> +		vcpu->arch.l2_to_l1_cs =3D tb_to_ns(be64_to_cpu(lp->l2_to_l1_cs_tb));
> +		vcpu->arch.l2_runtime =3D tb_to_ns(be64_to_cpu(lp->l2_runtime_tb));
> +		trace_kvmppc_vcpu_exit_cs_time(vcpu);
> +	}

... and true here. If it had been previously true then it would trace
stale values I think?

Would something like this work?

  if (unlikely(trace_kvmppc_vcpu_exit_cs_time_enabled()))
    get_lppaca()->l2_accumul_cntrs_enable =3D 1;

  [run vcpu ; ...]

  if (unlikely(trace_kvmppc_vcpu_exit_cs_time_enabled()))
    do_trace_nested_cs_time(vcpu);=20

 ...

static void do_trace_nested_cs_time(struct vcpu *vcpu)
{
    struct lppaca *lp =3D get_lppaca();
    u64 l1_to_l2, l2_to_l1, l2_runtime;

    if (!lp->l2_accumul_cntrs_enable)
      return;

    l1_to_l2 =3D tb_to_ns(be64_to_cpu(lp->l1_to_l2_cs_tb));
    l2_to_l1 =3D tb_to_ns(be64_to_cpu(lp->l2_to_l1_cs_tb));
    l2_runtime =3D tb_to_ns(be64_to_cpu(lp->l2_runtime_tb));
    trace_kvmppc_vcpu_exit_cs_time(vcpu->cpu_id, l1_to_l2,
                                   l2_to_l1, l2_runtime);
    lp->l1_to_l2_cs_tb =3D 0;
    lp->l2_to_l1_cs_tb =3D 0;
    lp->l2_runtime_tb =3D 0;
    lp->l2_accumul_cntrs_enable =3D 0;
}



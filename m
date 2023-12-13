Return-Path: <kvm+bounces-4405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 61E258121A4
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 23:41:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 632BA1C21157
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 22:41:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 044618183D;
	Wed, 13 Dec 2023 22:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bHdgQ+PZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876A0DC
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 14:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702507278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f2+gANqYaaLdYYgveblRGTM3hibzzgFDQkJzNX9XmDo=;
	b=bHdgQ+PZNDTqqAIqfDBiF3DtkIRwujfFaLG4kcSv6fJZf2ZB5mb+k0crzp+o79M10FijVZ
	WDE+i+w7TpX5yNc/qpNdzLMUBRi3e5SeLX/iPNsdBD90iKtF5s6KS93gumMLzUIYZmQECV
	kU+wb80NRPyHZeTxN56PSw0WDS/Chwo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-322-stNsPZPjPqqFLiS9yn2-jg-1; Wed, 13 Dec 2023 17:41:17 -0500
X-MC-Unique: stNsPZPjPqqFLiS9yn2-jg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-40c58a71b7cso11586225e9.2
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 14:41:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702507276; x=1703112076;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f2+gANqYaaLdYYgveblRGTM3hibzzgFDQkJzNX9XmDo=;
        b=e0aLz32UvHbeKnxxdQtyESELoldqkKQ1hjXdfbnIqAfseaygL29rwWscvIWmz6TScd
         EcvQLzH+RgHXXnDTYMkZoDevPcH6K77mLmDGb6TXBueDfuFZfs3BCTSlTi2t+2F8+DK7
         OloTJ9WYG7We15kY9Y2VTqBMhckmrYQDxz1lDelR8jVVP9TCxhGEfYf7Y4Fn2CLaainS
         Jxyq/fr3u2aFZVrpX2FJWt4x1HS3mu0hmXm7YH+Ot0X4THmuYnv8n3/QkCtXJNki+qZE
         JJVKwOnkfeYL/X6Xbo9AT/r1Uy7bb1YpusT2AMUSDEzbdiXmKiIDJNeP9pImH7H4JlSe
         W4KA==
X-Gm-Message-State: AOJu0YxG4vU1SdX0xqQ1xBaArAvRVFNJpct0bcf35EV04K4TVfTujJqq
	jRllNWJzi+AL3tEsS9u80I8IKKLL2QiSbP7pezjil8Pv0EK9S1phrAdo1FaRh+8vhEn7BXAT5Fg
	Nbrq58YTr3cf3329FqYTy
X-Received: by 2002:a05:600c:3657:b0:405:3dbc:8823 with SMTP id y23-20020a05600c365700b004053dbc8823mr4565039wmq.12.1702507275905;
        Wed, 13 Dec 2023 14:41:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEPeoXgJ1m5loGo8b/MSpc0RprvLai9peGkQgwRld1gJiMso4rhJuv4FejExGomAKeO4B7mYQ==
X-Received: by 2002:a05:600c:3657:b0:405:3dbc:8823 with SMTP id y23-20020a05600c365700b004053dbc8823mr4565036wmq.12.1702507275552;
        Wed, 13 Dec 2023 14:41:15 -0800 (PST)
Received: from starship ([77.137.131.62])
        by smtp.gmail.com with ESMTPSA id g10-20020a05600c4eca00b0040c11fbe581sm21912565wmq.27.2023.12.13.14.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 14:41:15 -0800 (PST)
Message-ID: <e837b1964e5615e5a1e5a0113889b507a3d4970d.camel@redhat.com>
Subject: Re: [PATCH v2 3/3] KVM: selftests: Add test case for x86
 apic_bus_clock_frequency
From: Maxim Levitsky <mlevitsk@redhat.com>
To: isaku.yamahata@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>, 
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>, Vishal
 Annapurve <vannapurve@google.com>, Jim Mattson <jmattson@google.com>
Date: Thu, 14 Dec 2023 00:41:13 +0200
In-Reply-To: <232d64219c6df684f99f9072d41e8783f1a4fe46.1699936040.git.isaku.yamahata@intel.com>
References: <cover.1699936040.git.isaku.yamahata@intel.com>
	 <232d64219c6df684f99f9072d41e8783f1a4fe46.1699936040.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2023-11-13 at 20:35 -0800, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Test if the apic bus clock frequency is exptected to the configured value.
> Set APIC TMICT to the maximum value and busy wait for 100 msec (any value
> is okay) with tsc value, and read TMCCT. Calculate apic bus clock frequency
> based on TSC frequency.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> Changes v2:
> - Newly added
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/include/x86_64/apic.h       |   7 +
>  .../kvm/x86_64/apic_bus_clock_test.c          | 132 ++++++++++++++++++
>  3 files changed, 140 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index a5963ab9215b..74ed3f71b6e8 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -115,6 +115,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/vmx_invalid_nested_guest_state
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_tsc_adjust_test
>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_nested_tsc_scaling_test
> +TEST_GEN_PROGS_x86_64 += x86_64/apic_bus_clock_test
>  TEST_GEN_PROGS_x86_64 += x86_64/xapic_ipi_test
>  TEST_GEN_PROGS_x86_64 += x86_64/xapic_state_test
>  TEST_GEN_PROGS_x86_64 += x86_64/xcr0_cpuid_test
> diff --git a/tools/testing/selftests/kvm/include/x86_64/apic.h b/tools/testing/selftests/kvm/include/x86_64/apic.h
> index bed316fdecd5..866a58d5fa11 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/apic.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/apic.h
> @@ -60,6 +60,13 @@
>  #define		APIC_VECTOR_MASK	0x000FF
>  #define	APIC_ICR2	0x310
>  #define		SET_APIC_DEST_FIELD(x)	((x) << 24)
> +#define APIC_LVT0       0x350
> +#define         APIC_LVT_TIMER_ONESHOT          (0 << 17)
> +#define         APIC_LVT_TIMER_PERIODIC         (1 << 17)
> +#define         APIC_LVT_TIMER_TSCDEADLINE      (2 << 17)
> +#define APIC_TMICT	0x380
> +#define APIC_TMCCT	0x390
> +#define APIC_TDCR	0x3E0
>  
>  void apic_disable(void);
>  void xapic_enable(void);
> diff --git a/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
> new file mode 100644
> index 000000000000..91f558d7c624
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
> @@ -0,0 +1,132 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#define _GNU_SOURCE /* for program_invocation_short_name */
> +
> +#include "apic.h"
> +#include "test_util.h"
> +
> +/* Pick one convenient value, 1Ghz.  No special meaning. */
Tiny nitpick: to be 100% honest, 1Ghz does have a special meaning, it's the default APIC bus frequency.
It might be slightly better to use say 1.5Ghz or something like that.

> +#define TSC_HZ			(1 * 1000 * 1000 * 1000ULL)
> +
> +/* Wait for 100 msec, not too long, not too short value. */
> +#define LOOP_MSEC		100ULL
> +#define TSC_WAIT_DELTA		(TSC_HZ / 1000 * LOOP_MSEC)
> +
> +/* Pick up typical value.  Different enough from the default value, 1GHz.  */
> +#define APIC_BUS_CLOCK_FREQ	(25 * 1000 * 1000ULL)
> +
> +static void guest_code(void)
> +{
> +	/* Possible tdcr values and its divide count. */
> +	struct {
> +		u32 tdcr;
> +		u32 divide_count;
> +	} tdcrs[] = {
> +		{0x0, 2},
> +		{0x1, 4},
> +		{0x2, 8},
> +		{0x3, 16},
> +		{0x8, 32},
> +		{0x9, 64},
> +		{0xa, 128},
> +		{0xb, 1},
> +	};
> +
> +	u32 tmict, tmcct;
> +	u64 tsc0, tsc1;
> +	int i;
> +
> +	asm volatile("cli");
> +
> +	xapic_enable();
> +
> +	/*
> +	 * Setup one-shot timer.  Because we don't fire the interrupt, the
> +	 * vector doesn't matter.
> +	 */
> +	xapic_write_reg(APIC_LVT0, APIC_LVT_TIMER_ONESHOT);
> +
> +	for (i = 0; i < ARRAY_SIZE(tdcrs); i++) {
> +		xapic_write_reg(APIC_TDCR, tdcrs[i].tdcr);
> +
> +		/* Set the largest value to not trigger the interrupt. */
> +		tmict = ~0;
> +		xapic_write_reg(APIC_TMICT, tmict);
> +
> +		/* Busy wait for LOOP_MSEC */
> +		tsc0 = rdtsc();
> +		tsc1 = tsc0;
> +		while (tsc1 - tsc0 < TSC_WAIT_DELTA)
> +			tsc1 = rdtsc();
> +
> +		/* Read apic timer and tsc */
> +		tmcct = xapic_read_reg(APIC_TMCCT);
> +		tsc1 = rdtsc();
> +
> +		/* Stop timer */
> +		xapic_write_reg(APIC_TMICT, 0);
> +
> +		/* Report it. */
> +		GUEST_SYNC_ARGS(tdcrs[i].divide_count, tmict - tmcct,
> +				tsc1 - tsc0, 0, 0);
> +	}
> +
> +	GUEST_DONE();
> +}
> +
> +void test_apic_bus_clock(struct kvm_vcpu *vcpu)
> +{
> +	bool done = false;
> +	struct ucall uc;
> +
> +	while (!done) {
> +		vcpu_run(vcpu);
> +		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
> +
> +		switch (get_ucall(vcpu, &uc)) {
> +		case UCALL_DONE:
> +			done = true;
> +			break;
> +		case UCALL_ABORT:
> +			REPORT_GUEST_ASSERT(uc);
> +			break;
> +		case UCALL_SYNC: {
> +			u32 divide_counter = uc.args[1];
> +			u32 apic_cycles = uc.args[2];
> +			u64 tsc_cycles = uc.args[3];
> +			u64 freq;
> +
> +			TEST_ASSERT(tsc_cycles > 0,
> +				    "tsc cycles must not be zero.");
> +
> +			/* Allow 1% slack. */
> +			freq = apic_cycles * divide_counter * TSC_HZ / tsc_cycles;
> +			TEST_ASSERT(freq < APIC_BUS_CLOCK_FREQ * 101 / 100,
> +				    "APIC bus clock frequency is too large");
> +			TEST_ASSERT(freq > APIC_BUS_CLOCK_FREQ * 99 / 100,
> +				    "APIC bus clock frequency is too small");
> +			break;
> +		}
> +		default:
> +			TEST_FAIL("Unknown ucall %lu", uc.cmd);
> +			break;
> +		}
> +	}
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	struct kvm_vm *vm;
> +	struct kvm_vcpu *vcpu;
> +
> +	vm = __vm_create(VM_MODE_DEFAULT, 1, 0);
> +	vm_ioctl(vm, KVM_SET_TSC_KHZ, (void *) (TSC_HZ / 1000));
> +	/*  KVM_CAP_X86_BUS_FREQUENCY_CONTROL requires that no vcpu is created. */
> +	vm_enable_cap(vm, KVM_CAP_X86_BUS_FREQUENCY_CONTROL,
> +		      APIC_BUS_CLOCK_FREQ);
> +	vcpu = vm_vcpu_add(vm, 0, guest_code);
> +
> +	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
> +
> +	test_apic_bus_clock(vcpu);
> +	kvm_vm_free(vm);
> +}

Looks good overall.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




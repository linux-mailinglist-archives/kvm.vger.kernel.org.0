Return-Path: <kvm+bounces-13929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DDE6589CED9
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 01:18:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DE862867DE
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 23:18:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B99A3148FFB;
	Mon,  8 Apr 2024 23:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fKNkEU3D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319E114BF8F
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 23:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712618274; cv=none; b=prk+thpARi1UFc1iO3bREk3fwVd0Zu5oKENSVxXM4uduOBRgQ5WHfyAVX1s7v26FXOIJQa5EJiMhXrTL+Upr+nE0W7KPcTs7R8pJC5Meq7RijO1L1zemn/Q9ibDQbRXRTtXnKUh4atda37xaqS9m8a5zgp6r+3S6ZTfZR1h26F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712618274; c=relaxed/simple;
	bh=LbQqWDbu9Tx23Uw2ZJ+WJ1lu0DuCpxR3GBbGZYWp6zE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mgvc2pAunP4LAYmPk57qY6/BS25R1PCxcHEg+OpRIuVowZIcD652ZhjtYR9gf1QMO03g0w/evD6USVT633kreWfpe3fzGmoKLgyyn5R3utYDDK3Sk+0R8JnracyDpFt5qkJOMuxHIsKtFDVOYW01qhn5qqxSPxpiMzR56KAa7Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fKNkEU3D; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6ecec796323so4650249b3a.3
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 16:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712618271; x=1713223071; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hzXGD5oeSQZVBAunOhKRzguEzfpXP3gPaAL9WkfEbao=;
        b=fKNkEU3DVvbei8GaqIK/zrF99nJ8qUgspGIQewrmlOdnCQrvfrWWfLUfUOFdcEIYFY
         Ik1reXMHBYgcOASRw0Abj1OgTalmgDLJaYIlcpb/oSrUwLtdRPNjYU8ToM0I/n2majgQ
         1bk2G98iu0YY2hyQYsOdxFXFDxnMXXTrI+zROhV9rzDo43j10QXTzrtT7iIYDeLQkdrI
         6rzxwlDxycgI2hpc9aYenw6l/2KXfA4CeLpba/IaSuBR9EyMmz14daIMvAnC3Q9tbIvr
         I7PMCWP5Ddoz3VcUzlmTn2rXxZ6/7R3FFLLDMrTWYnJ3R9kziORVZw2Orypne4PBbjgo
         vePg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712618271; x=1713223071;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hzXGD5oeSQZVBAunOhKRzguEzfpXP3gPaAL9WkfEbao=;
        b=vuQipBDZWD3DVEZCz7ycYv32zEATNtCIkmQp3PIkchZGzMsZ7SCPr0prJhGuWtN3Vb
         cKUAsf3U7kykm+IQjq8Hpb73j8+lB9FKlVgfK61C7rW/l9d9FENX70B2xgDagBLPOKIN
         asK30WRbomoAtEJDvGwYBHlXqXj+K6ETvkze3NnqtYqt0D45zDA51RlBZLjy2incLDP4
         KYBwS1xD1xOO4lQtIyWLLMKdlcNoa0z7mn+CzV8+txdcB78zAN6w2zDvKNDv4AlxtwHO
         yw9Od0trXSncubtIiYk9XaMoa+Lxlngi4v2hi0URLzXttFmZpvVcMVFCKktWxn1apjN0
         zFSg==
X-Forwarded-Encrypted: i=1; AJvYcCXOxbV4jXwxrjskZ0tAntFQ1f8PSv1g/edtyiN5zYKkLy3TtExJLROMDbNr7d4FDFCV3vVuYci9PLEzX8Eu0Lel21LV
X-Gm-Message-State: AOJu0YyTZIAnYjjs86DCJJ5UEkSgHoKRofBCVNUlkjELJZbAtLmG/EJO
	0zXGW9cZYKc9GvRQw9kaQTg5kHqUVlGItiOW6DGde26vYClj86/gHXD+HzQI5g==
X-Google-Smtp-Source: AGHT+IEKXSf0nqigZnP+patDhG0682RNOOmDpooO5fg456YG55OviiD3AjDfC4vLubpad7IgDEZQww==
X-Received: by 2002:a05:6a00:3c91:b0:6ea:c4e5:a252 with SMTP id lm17-20020a056a003c9100b006eac4e5a252mr13765276pfb.5.1712618271221;
        Mon, 08 Apr 2024 16:17:51 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id r18-20020aa79892000000b006ecc858b67fsm7354120pfl.175.2024.04.08.16.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 16:17:50 -0700 (PDT)
Date: Mon, 8 Apr 2024 23:17:47 +0000
From: Mingwei Zhang <mizhang@google.com>
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhang Xiong <xiong.y.zhang@intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>
Subject: Re: [kvm-unit-tests Patch v3 07/11] x86: pmu: Enable and disable
 PMCs in loop() asm blob
Message-ID: <ZhR7G25FX_osy8X5@google.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
 <20240103031409.2504051-8-dapeng1.mi@linux.intel.com>
 <ZgO3vWIeC3sk_B5N@google.com>
 <c509996d-fdda-4a57-b6ac-597c811f7786@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c509996d-fdda-4a57-b6ac-597c811f7786@linux.intel.com>

On Wed, Mar 27, 2024, Mi, Dapeng wrote:
> 
> On 3/27/2024 2:07 PM, Mingwei Zhang wrote:
> > On Wed, Jan 03, 2024, Dapeng Mi wrote:
> > > Currently enabling PMCs, executing loop() and disabling PMCs are divided
> > > 3 separated functions. So there could be other instructions executed
> > > between enabling PMCS and running loop() or running loop() and disabling
> > > PMCs, e.g. if there are multiple counters enabled in measure_many()
> > > function, the instructions which enabling the 2nd and more counters
> > > would be counted in by the 1st counter.
> > > 
> > > So current implementation can only verify the correctness of count by an
> > > rough range rather than a precise count even for instructions and
> > > branches events. Strictly speaking, this verification is meaningless as
> > > the test could still pass even though KVM vPMU has something wrong and
> > > reports an incorrect instructions or branches count which is in the rough
> > > range.
> > > 
> > > Thus, move the PMCs enabling and disabling into the loop() asm blob and
> > > ensure only the loop asm instructions would be counted, then the
> > > instructions or branches events can be verified with an precise count
> > > instead of an rough range.
> > > 
> > > Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> > > ---
> > >   x86/pmu.c | 83 +++++++++++++++++++++++++++++++++++++++++++++----------
> > >   1 file changed, 69 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/x86/pmu.c b/x86/pmu.c
> > > index 46bed66c5c9f..88b89ad889b9 100644
> > > --- a/x86/pmu.c
> > > +++ b/x86/pmu.c
> > > @@ -18,6 +18,20 @@
> > >   #define EXPECTED_INSTR 17
> > >   #define EXPECTED_BRNCH 5
> > > +// Instrustion number of LOOP_ASM code
> > > +#define LOOP_INSTRNS	10
> > > +#define LOOP_ASM					\
> > > +	"1: mov (%1), %2; add $64, %1;\n\t"		\
> > > +	"nop; nop; nop; nop; nop; nop; nop;\n\t"	\
> > > +	"loop 1b;\n\t"
> > > +
> > > +#define PRECISE_LOOP_ASM						\
> > > +	"wrmsr;\n\t"							\
> > > +	"mov %%ecx, %%edi; mov %%ebx, %%ecx;\n\t"			\
> > > +	LOOP_ASM							\
> > > +	"mov %%edi, %%ecx; xor %%eax, %%eax; xor %%edx, %%edx;\n\t"	\
> > > +	"wrmsr;\n\t"
> > Can we add "FEP" prefix into the above blob? This way, we can expand the
> > testing for emulated instructions.
Dapeng,

Sorry, did not clarify that this is not a hard request. I am not
pushing that this need to be done in your next version if it takes
time to do so. (FEP is of couse nice to have :), but this test already
supports it in somewhere else.).

Once your next version is ready, please send it out as soon as you can
and I am happy to give my reviews until it is merged.

Thanks.
-Mingwei
>
> 
> Yeah, that sounds like a new feature request. I would add it in next
> version.
> 
> 
> > > +
> > >   typedef struct {
> > >   	uint32_t ctr;
> > >   	uint64_t config;
> > > @@ -54,13 +68,43 @@ char *buf;
> > >   static struct pmu_event *gp_events;
> > >   static unsigned int gp_events_size;
> > > -static inline void loop(void)
> > > +
> > > +static inline void __loop(void)
> > > +{
> > > +	unsigned long tmp, tmp2, tmp3;
> > > +
> > > +	asm volatile(LOOP_ASM
> > > +		     : "=c"(tmp), "=r"(tmp2), "=r"(tmp3)
> > > +		     : "0"(N), "1"(buf));
> > > +}
> > > +
> > > +/*
> > > + * Enable and disable counters in a whole asm blob to ensure
> > > + * no other instructions are counted in the time slot between
> > > + * counters enabling and really LOOP_ASM code executing.
> > > + * Thus counters can verify instructions and branches events
> > > + * against precise counts instead of a rough valid count range.
> > > + */
> > > +static inline void __precise_count_loop(u64 cntrs)
> > >   {
> > >   	unsigned long tmp, tmp2, tmp3;
> > > +	unsigned int global_ctl = pmu.msr_global_ctl;
> > > +	u32 eax = cntrs & (BIT_ULL(32) - 1);
> > > +	u32 edx = cntrs >> 32;
> > > -	asm volatile("1: mov (%1), %2; add $64, %1; nop; nop; nop; nop; nop; nop; nop; loop 1b"
> > > -			: "=c"(tmp), "=r"(tmp2), "=r"(tmp3): "0"(N), "1"(buf));
> > > +	asm volatile(PRECISE_LOOP_ASM
> > > +		     : "=b"(tmp), "=r"(tmp2), "=r"(tmp3)
> > > +		     : "a"(eax), "d"(edx), "c"(global_ctl),
> > > +		       "0"(N), "1"(buf)
> > > +		     : "edi");
> > > +}
> > > +static inline void loop(u64 cntrs)
> > > +{
> > > +	if (!this_cpu_has_perf_global_ctrl())
> > > +		__loop();
> > > +	else
> > > +		__precise_count_loop(cntrs);
> > >   }
> > >   volatile uint64_t irq_received;
> > > @@ -159,18 +203,17 @@ static void __start_event(pmu_counter_t *evt, uint64_t count)
> > >   	    ctrl = (ctrl & ~(0xf << shift)) | (usrospmi << shift);
> > >   	    wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, ctrl);
> > >       }
> > > -    global_enable(evt);
> > >       apic_write(APIC_LVTPC, PMI_VECTOR);
> > >   }
> > >   static void start_event(pmu_counter_t *evt)
> > >   {
> > >   	__start_event(evt, 0);
> > > +	global_enable(evt);
> > >   }
> > > -static void stop_event(pmu_counter_t *evt)
> > > +static void __stop_event(pmu_counter_t *evt)
> > >   {
> > > -	global_disable(evt);
> > >   	if (is_gp(evt)) {
> > >   		wrmsr(MSR_GP_EVENT_SELECTx(event_to_global_idx(evt)),
> > >   		      evt->config & ~EVNTSEL_EN);
> > > @@ -182,14 +225,24 @@ static void stop_event(pmu_counter_t *evt)
> > >   	evt->count = rdmsr(evt->ctr);
> > >   }
> > > +static void stop_event(pmu_counter_t *evt)
> > > +{
> > > +	global_disable(evt);
> > > +	__stop_event(evt);
> > > +}
> > > +
> > >   static noinline void measure_many(pmu_counter_t *evt, int count)
> > >   {
> > >   	int i;
> > > +	u64 cntrs = 0;
> > > +
> > > +	for (i = 0; i < count; i++) {
> > > +		__start_event(&evt[i], 0);
> > > +		cntrs |= BIT_ULL(event_to_global_idx(&evt[i]));
> > > +	}
> > > +	loop(cntrs);
> > >   	for (i = 0; i < count; i++)
> > > -		start_event(&evt[i]);
> > > -	loop();
> > > -	for (i = 0; i < count; i++)
> > > -		stop_event(&evt[i]);
> > > +		__stop_event(&evt[i]);
> > >   }
> > >   static void measure_one(pmu_counter_t *evt)
> > > @@ -199,9 +252,11 @@ static void measure_one(pmu_counter_t *evt)
> > >   static noinline void __measure(pmu_counter_t *evt, uint64_t count)
> > >   {
> > > +	u64 cntrs = BIT_ULL(event_to_global_idx(evt));
> > > +
> > >   	__start_event(evt, count);
> > > -	loop();
> > > -	stop_event(evt);
> > > +	loop(cntrs);
> > > +	__stop_event(evt);
> > >   }
> > >   static bool verify_event(uint64_t count, struct pmu_event *e)
> > > @@ -451,7 +506,7 @@ static void check_running_counter_wrmsr(void)
> > >   	report_prefix_push("running counter wrmsr");
> > >   	start_event(&evt);
> > > -	loop();
> > > +	__loop();
> > >   	wrmsr(MSR_GP_COUNTERx(0), 0);
> > >   	stop_event(&evt);
> > >   	report(evt.count < gp_events[0].min, "cntr");
> > > @@ -468,7 +523,7 @@ static void check_running_counter_wrmsr(void)
> > >   	wrmsr(MSR_GP_COUNTERx(0), count);
> > > -	loop();
> > > +	__loop();
> > >   	stop_event(&evt);
> > >   	if (this_cpu_has_perf_global_status()) {
> > > -- 
> > > 2.34.1
> > > 


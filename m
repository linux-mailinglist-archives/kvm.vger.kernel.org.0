Return-Path: <kvm+bounces-12759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0562D88D643
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 07:15:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 870BA1F29D56
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 06:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 222D217BB9;
	Wed, 27 Mar 2024 06:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t3ikXKdl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5A914A85
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 06:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711520105; cv=none; b=VC2UDeSa9/Eig915RG7AWgq23tVDRiI6yOBFBO1/+0KN8TIk8u9jv3FsU+AJxB2Wbd85+uWxt9Rn+4iUdozloptiUBCIgwbuF8rHbh67BbCwUjiyaNvm2KYTB4D91no2CGGvhUyefuA6TI7HYWjQF2eRJedKE9MZGXxwDbRwf70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711520105; c=relaxed/simple;
	bh=J2BJtojvQkJ+6K5PJ2z4Aam76n7xsKoBVu+R0cBeaAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hM56sOLP7jShkHoxnCkLXyfnYkBk67qfyvEhEUvAUxZH6B/6d0+Miq35n3/2kp6stwEB9LXbyd3KaPH0wuqQcUqq0EwoTmyTgVJR2oSsjZ1aTCK4brWibpoahA5J4QlKn66mvKxJkDhHEPthEfl48kZEmBqhpOL4g9jbV4tx9UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t3ikXKdl; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6ea8a0d1a05so354346b3a.1
        for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 23:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711520103; x=1712124903; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3zSvCpHNkEmDai+8k3O5scNJEZaTblGXa5PFziCkb4I=;
        b=t3ikXKdlhf6LkY3Cc/ntnlPu6W8vxAIzaozC5M9sEiJY6FtUejtjEmpouzAwg1EROT
         iGSxU7+lm+mLASXrb9T7R8abkWK8J6d3xByR4l3XBSo3il2mUXD4/9tO61ONn4Xucdgc
         s3g1u5QZpqgl7eVlFXBJigstlr8e7JP/GOaerZ+EUsku7i83xEfva36wOAfgpvlhX0YW
         0rOFNWq6tKgXDvfA8SnPhYo0A6KxcbU4r9BsjoLNtjrqnQp1WoL8NAlKWYHamk4XnvOC
         gzc/uLpoS1Tc2OyG3NAyMSQhWcNe6+COer/afnnYYFAB2AiZBKrDJvQOSIUOFpx9VqaU
         YUnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711520103; x=1712124903;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3zSvCpHNkEmDai+8k3O5scNJEZaTblGXa5PFziCkb4I=;
        b=Zl9hL0NZe3lRawUSufGw7RmjVAK6o8VAMlaIgocUsO5U5Qs+n88lVkLUNxciREF1aS
         4TttuGCuzsH9fE7OeguNY+OyfIEgAqOeA7dzcMvoJvqQaj+ECyPPYEeym28PU0pptXLA
         wAiClE8bd63xzZztzTxH7bWF/1RE2EtauI2wBNv/Btk1OP6BTFP7yoSZyb0IU+jOQTo+
         d00Z04oOouFsTRDrfBQcQPrKbOFSi8Y8oWsc8qJHWp14bazqEamUUc6n4Y4Jjmtu/Uul
         E/0g+2RChIhguuteuKMEozLmasvrimHBFPI5cOM21DLNLeG9LGNVoAypUAQBz+0bKGxN
         QV+w==
X-Forwarded-Encrypted: i=1; AJvYcCVaFYlf2lTT/nOFbvdJe3zWtWzG3OkMXjyavmnH10S/5WdPJMT1b8IiI+r3QlDGs5NOiOWFZiw6fP8RXR6ceCS1qrO0
X-Gm-Message-State: AOJu0YynsRBACcvfNTY1tQP7KlgKA+ooVwkSYwPPKVDnDWJg46nw9E+u
	3XPdiC4cj48q+MM3MM1xMTJOlFC85XLpuXfWKgQERfSui8fLXs54xx4rHwBTtQ==
X-Google-Smtp-Source: AGHT+IFdZyWI1zzEwuxEMp1TKIQnIJC9/j+leN82StL7P7CR9C2RWMYmsQwpipPLa8u9I5npcADwmw==
X-Received: by 2002:a05:6a21:a59c:b0:1a3:4fcd:7a18 with SMTP id gd28-20020a056a21a59c00b001a34fcd7a18mr5304825pzc.10.1711520102917;
        Tue, 26 Mar 2024 23:15:02 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id ei46-20020a056a0080ee00b006e6fd17069fsm7026163pfb.37.2024.03.26.23.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 23:15:02 -0700 (PDT)
Date: Wed, 27 Mar 2024 06:14:58 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
	Zhang Xiong <xiong.y.zhang@intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Jinrong Liang <cloudliang@tencent.com>,
	Dapeng Mi <dapeng1.mi@intel.com>
Subject: Re: [kvm-unit-tests Patch v3 08/11] x86: pmu: Improve instruction
 and branches events verification
Message-ID: <ZgO5YgWK3eX-zlgc@google.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
 <20240103031409.2504051-9-dapeng1.mi@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103031409.2504051-9-dapeng1.mi@linux.intel.com>

On Wed, Jan 03, 2024, Dapeng Mi wrote:
> If HW supports GLOBAL_CTRL MSR, enabling and disabling PMCs are moved in
> __precise_count_loop(). Thus, instructions and branches events can be
> verified against a precise count instead of a rough range.
> 
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  x86/pmu.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 88b89ad889b9..b764827c1c3d 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -25,6 +25,10 @@
>  	"nop; nop; nop; nop; nop; nop; nop;\n\t"	\
>  	"loop 1b;\n\t"
>  
> +/*Enable GLOBAL_CTRL + disable GLOBAL_CTRL instructions */
> +#define PRECISE_EXTRA_INSTRNS  (2 + 4)
> +#define PRECISE_LOOP_INSTRNS   (N * LOOP_INSTRNS + PRECISE_EXTRA_INSTRNS)
> +#define PRECISE_LOOP_BRANCHES  (N)
>  #define PRECISE_LOOP_ASM						\
>  	"wrmsr;\n\t"							\
>  	"mov %%ecx, %%edi; mov %%ebx, %%ecx;\n\t"			\
> @@ -107,6 +111,24 @@ static inline void loop(u64 cntrs)
>  		__precise_count_loop(cntrs);
>  }
>  
> +static void adjust_events_range(struct pmu_event *gp_events, int branch_idx)
> +{
> +	/*
> +	 * If HW supports GLOBAL_CTRL MSR, enabling and disabling PMCs are
> +	 * moved in __precise_count_loop(). Thus, instructions and branches
> +	 * events can be verified against a precise count instead of a rough
> +	 * range.
> +	 */
> +	if (this_cpu_has_perf_global_ctrl()) {
> +		/* instructions event */
> +		gp_events[0].min = PRECISE_LOOP_INSTRNS;
> +		gp_events[0].max = PRECISE_LOOP_INSTRNS;
> +		/* branches event */
> +		gp_events[branch_idx].min = PRECISE_LOOP_BRANCHES;
> +		gp_events[branch_idx].max = PRECISE_LOOP_BRANCHES;
> +	}
> +}
> +
>  volatile uint64_t irq_received;
>  
>  static void cnt_overflow(isr_regs_t *regs)
> @@ -771,6 +793,7 @@ static void check_invalid_rdpmc_gp(void)
>  
>  int main(int ac, char **av)
>  {
> +	int branch_idx;
>  	setup_vm();
>  	handle_irq(PMI_VECTOR, cnt_overflow);
>  	buf = malloc(N*64);
> @@ -784,13 +807,16 @@ int main(int ac, char **av)
>  		}
>  		gp_events = (struct pmu_event *)intel_gp_events;
>  		gp_events_size = sizeof(intel_gp_events)/sizeof(intel_gp_events[0]);
> +		branch_idx = 5;

This (and the follow up one) hardcoded index is hacky and more
importantly, error prone especially when code get refactored later.
Please use a proper way via macro? Eg., checking
INTEL_ARCH_BRANCHES_RETIRED_INDEX in pmu_counters_test.c might be a good
one.
>  		report_prefix_push("Intel");
>  		set_ref_cycle_expectations();
>  	} else {
>  		gp_events_size = sizeof(amd_gp_events)/sizeof(amd_gp_events[0]);
>  		gp_events = (struct pmu_event *)amd_gp_events;
> +		branch_idx = 2;
>  		report_prefix_push("AMD");
>  	}
> +	adjust_events_range(gp_events, branch_idx);
>  
>  	printf("PMU version:         %d\n", pmu.version);
>  	printf("GP counters:         %d\n", pmu.nr_gp_counters);
> -- 
> 2.34.1
> 


Return-Path: <kvm+bounces-47607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 918BDAC2912
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 19:49:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45EB14E21C1
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 17:49:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA1E9298988;
	Fri, 23 May 2025 17:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oyWkBaZ6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3668294A0B
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 17:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748022539; cv=none; b=HFNTxs21Ay1mb90yuAo6Iq2BA5U1jNMMXrgKPTVT/6ZBSqlByRyHVamvuVro6xjhslGRVXUJwzcJrdJAJL0eKXnvi9Ci6ZI1vUwFygT4dhVxUYhfzKudAYglymEpxOgT2fxyuLGhYHBLz48EOcv4h/3Wa9so2d+3ZUILGu14Lss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748022539; c=relaxed/simple;
	bh=YdxTLRyayHOS5UpkeNQKmvSD0XC3jAg8KZ9fVAPOWLI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TsNZQh4viaPwVTSEnekq363TPYKX7Uzy54LllchvIEs0yhwcoxQAewxyOPTiN3qvz75W2ytle5PUZ9InKxO8yJPfte/4tePsnXUFHZX0Qu1KurBOA2i4KClV7SnkqubsLBTi5TXjRmh7cWbPWzdYqai+euG5ZCGGb+CIIKQMI+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oyWkBaZ6; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b26fa2cac30so51780a12.2
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 10:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748022537; x=1748627337; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mo5bMDbHVSJazQ1e/pcH3/N64EdMqiQcACWP47NA950=;
        b=oyWkBaZ6QsMkpr3qdkezuv1/iiQZsg9UOmCJOTlJbbpR/dTGM0Q9VBWkWeaJKLwDNE
         Dtas65zlVu+ARgU2upM0wk0ENHxcDfw/mBOLXFOH1KBlGRR8TpvUQkhVUGWZmCpMDrli
         VAx9xlVw5XI105jle/H5QzMoQf88DiPSznM2cMlNbf3f9w7uFr7cTVf3E0wVuPBH9flR
         EhyHbsh0L1QeXMO1SqxRtBWVfzVSWfaGBXVvjv9lvFamUEWsDffi3UT2qeiEEZfXzJ9m
         JQvCsBicRyTzw4nMB6kUXPuld9DyjMfgP01SZWkHm3Go9SVJE1IB7EvaH2guzN13ew5W
         uoRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748022537; x=1748627337;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mo5bMDbHVSJazQ1e/pcH3/N64EdMqiQcACWP47NA950=;
        b=UjehCISEuC67m7elIvGt5ioE/UvTRnqtGELQ/r+gYEiu0quS4JwOzLuhDy0hrQ3y2c
         pPi6Oz6Zu++KmTG7MotyjGJ2gQ3LGxLOEGJ2EX+Dj3PEyINbAvO5QznJpPif2u/FT/2M
         5zmB1krwG6JrrbaK8BGRDF8+cqoI4fTdfMEN7Bu9hMKOVR8lZhn2dqFossWNXRiw2Ws0
         3t2AyWRJwux4kBbl9Lp+QjeqylkQ18r2Imp8bwvIKItLIqlRaslaXQOtoV2tKP655OpF
         a/GlBUHLPAoBYVAwwcUEAR7I7Y4cR0WmLDMj3c/UI60higczEvHXgCxl/lDrSFQKnRVc
         lM2Q==
X-Forwarded-Encrypted: i=1; AJvYcCVQU3Z5dmNE13Y3GLc1zdChcx/ToEjzRfn6sGe7meyyWG88ZW8/THS0zpTiTNSoTGwMQ6I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4+60FiCKtLI74qI9SerjMN2RXWggFX/P+ZOvXc5TD6GUCZxm3
	zG7v6/JnjUntU0EJY+A/7cJACOEUd5N51PQiJZhnQ3Bj2RmDH14wDFONdXNxacTZ/lVn0sXa6sB
	GDsd2nQ==
X-Google-Smtp-Source: AGHT+IGx2i+SqkzSF8nq3OQu87/rV+LA/G68zm9ksb1Iva+HscegTRNIOUK9OkttU2BD53WwIKsXNAjwyTA=
X-Received: from plbay9.prod.google.com ([2002:a17:902:8b89:b0:234:11ef:3a93])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:19f0:b0:224:10a2:cae7
 with SMTP id d9443c01a7336-23414fb2509mr4395795ad.40.1748022536950; Fri, 23
 May 2025 10:48:56 -0700 (PDT)
Date: Fri, 23 May 2025 10:48:55 -0700
In-Reply-To: <f575567b-0d1f-4631-ad48-1ef5aaca1f75@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250522151031.426788-1-chao.gao@intel.com> <aDCo_SczQOUaB2rS@google.com>
 <f575567b-0d1f-4631-ad48-1ef5aaca1f75@intel.com>
Message-ID: <aDC1B-ngse3HGh-7@google.com>
Subject: Re: [PATCH v8 0/6] Introduce CET supervisor state support
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Chao Gao <chao.gao@intel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, tglx@linutronix.de, pbonzini@redhat.com, 
	peterz@infradead.org, rick.p.edgecombe@intel.com, weijiang.yang@intel.com, 
	john.allen@amd.com, bp@alien8.de, chang.seok.bae@intel.com, xin3.li@intel.com, 
	Dave Hansen <dave.hansen@linux.intel.com>, Eric Biggers <ebiggers@google.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Kees Cook <kees@kernel.org>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Mitchell Levy <levymitchell0@gmail.com>, 
	Nikolay Borisov <nik.borisov@suse.com>, Oleg Nesterov <oleg@redhat.com>, 
	Sohil Mehta <sohil.mehta@intel.com>, Stanislav Spassov <stanspas@amazon.de>, 
	Vignesh Balasubramanian <vigbalas@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, May 23, 2025, Dave Hansen wrote:
> On 5/23/25 09:57, Sean Christopherson wrote:
> > Side topic, and *probably* unrelated to this series, I tripped the following
> > WARN when running it through the KVM tests (though I don't think it has anything
> > to do with KVM?).  The WARN is the version of xfd_validate_state() that's guarded
> > by CONFIG_X86_DEBUG_FPU=y.
> > 
> >    WARNING: CPU: 232 PID: 15391 at arch/x86/kernel/fpu/xstate.c:1543 xfd_validate_state+0x65/0x70
> 
> Huh, and the two processes getting hit by it:
> 
>    CPU: 232 UID: 0 PID: 15391 Comm: DefaultEventMan ...
>    CPU: 77  UID: 0 PID: 14821 Comm: futex-default-S ...
> 
> don't _look_ like KVM test processes.

Yeah, that's why I haven't dug into it, I don't really know where to start, and
I don't even really know what triggered it.

> My guess would be it's some mixture of KVM and a signal handler fighting with
> XFD state.
> 
> I take it this is a Sapphire Rapids system?

Emerald Rapids

> Is there anything interesting about the config other than CONFIG_X86_DEBUG_FPU?

The only thing I can think of that's remotely interesting is CONFIG_PROVE_LOCKING=y.
Other than that, it's a pretty vanilla config.


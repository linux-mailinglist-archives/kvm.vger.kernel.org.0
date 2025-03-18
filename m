Return-Path: <kvm+bounces-41377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B1B2A66FC4
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 10:28:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AC261708D0
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 09:28:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45ED52080EE;
	Tue, 18 Mar 2025 09:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="j7gzxPYh";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="+k0f4imd"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00947204F81;
	Tue, 18 Mar 2025 09:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742290047; cv=none; b=K5TSQi6h4TelenE7aeP2d5b7ofo/Rd9j3M7s22AzlwFK1bPRyFfx9Rx/OpkwQN8doLEkbpEV8/ejOFHoSlJAWnVo4aBhwu3DeoR+4V0sLu6p/A5MLIFCB6a3IJfdUz9RrJp1klFlllXAn/xjALOLTUF/aP4R5H7PbxwzKobiOi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742290047; c=relaxed/simple;
	bh=RalQ88AMLmSdmBCJsV0jUmVQtsCPHgy2ed85ZIvGaDQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lRv/F9poaglSbV3hQWnh7m66y7PrKiI0Akp68R1q94vcIf9N6XIygA+blK1GUiWb78a51MopkIfbRUjVHsmuYSYf1TJrlF4BggPKZSSROSJKvr111iAd3qQYmZYlbjLR4wML17iRLq42mhe5X5O78Gm6b1QYAr+zNeu0IEKLyLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=j7gzxPYh; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=+k0f4imd; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1742290044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j++bzcEvaYwRrjRxXaAZJwDNo/oOMG8yVeVAKGP3DoE=;
	b=j7gzxPYhSkE9goF0jf6BMSBhyZU/0+uUVDQd4+h1CFhhVwSDgZmkoYF8Rmd6UeaFqMEq84
	JnlsVGWumYkM9Ep/p34JtXhPyeGFBKVclWgoN0yyPukdmsqjtv49dSyYgAGb8rctYFlzzj
	RCbI6NLgCASToa+J5SSCHbwSxkk5t5qlDdtalLkfEFUA1TM03txcsAaElb9nNopVagTN5U
	AOqXKromMgiueAFVnLIygFy/mhD2VXI5Rx25y54TxK6SmmmuYdfccWb8r1vXf7i6MKGsMo
	kw4cYb8vjUjEWB/sYm4dUSqS0e6BPqsf/SWthGTNOImcceGltK4yQLal/yA3EA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1742290044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j++bzcEvaYwRrjRxXaAZJwDNo/oOMG8yVeVAKGP3DoE=;
	b=+k0f4imdGLRoOXK4Cn1FQ6war57gEmw5v9P1tDrRxXOFx1H0QjsvntOcTsZ22DoSZ46DHT
	sYBVkX3kh3ttUtBg==
To: Sean Christopherson <seanjc@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave
 Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Paolo Bonzini
 <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Jacob Pan <jacob.jun.pan@linux.intel.com>, Jim Mattson
 <jmattson@google.com>
Subject: Re: [PATCH 2/8] x86/irq: Track if IRQ was found in PIR during
 initial loop (to load PIR vals)
In-Reply-To: <Z9hThFNFrrbXjkjc@google.com>
References: <20250315030630.2371712-1-seanjc@google.com>
 <20250315030630.2371712-3-seanjc@google.com> <87wmcn4x78.ffs@tglx>
 <Z9hThFNFrrbXjkjc@google.com>
Date: Tue, 18 Mar 2025 10:27:23 +0100
Message-ID: <87ldt24rk4.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Mar 17 2025 at 09:53, Sean Christopherson wrote:
> On Mon, Mar 17, 2025, Thomas Gleixner wrote:
>> > -	for (i = 0; i < 4; i++)
>> > +	for (i = 0; i < 4; i++) {
>> >  		pir_copy[i] = READ_ONCE(pir[i]);
>> > +		if (pir_copy[i])
>> > +			found_irq = true;
>> > +	}
>> 
>> That's four extra conditional branches. You can avoid them completely. See
>> delta patch below.
>
> Huh.  gcc elides the conditional branches when computing found_irq regardless of
> the approach; the JEs in the changelog are from skipping the XCHG.
>
> But clang-14 does not.  I'll slot this in.

Neither does GCC 12. That's why I noticed.



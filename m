Return-Path: <kvm+bounces-41227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 910A4A65066
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 14:13:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA5E21888F2C
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 13:13:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E531623E320;
	Mon, 17 Mar 2025 13:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="I0SC8sOL";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="TmU8ZwIB"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E3BE56F;
	Mon, 17 Mar 2025 13:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742217199; cv=none; b=NRjnboLoNNzlZM1CyLpm+KOAP9zIgqRa009CIzOmBw8N4zMYZ3jpyjYUiZ3aJznDX1T46S9euDMoI1BC4Lk9rRZWQvcqoyq31kaugRtVjvjdJyWXL1YcmzHPF6+Ug/b3OCJHh+47Iuk40ZOEExExLRA4D0WGr7Mf5Gm3xeaiUr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742217199; c=relaxed/simple;
	bh=HrQ1t1lZWKkN411EmfUJK1mObU5Vz+PQvyjN3wj4dEk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=OKNptK2IA8urlOl5eP/JnIjk2ldNJOxrRxuII0aIaUZR5VyxjDm6/cke1gAabFLkgKoGyeeAf1ETMiyAV7OAHOg496zVjamwVW0wcqFrZE8YV4Ym6e8jsszbEEPZU0BnRKitSMce5PyEmRW9bQxsdrPh8N32v49s7y/TcqqykCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=I0SC8sOL; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=TmU8ZwIB; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1742217195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=elqP/dUEnChhUjOELroRy5eKXIUAe/WjjQGOV3HaO7E=;
	b=I0SC8sOLs+AxSv01xAJVjtiE24Zb1dXlw4LvNT6lz1AQU1YuIGyh3ivRHFRxCZn1NHXVsT
	Fo/xjNBSEIE2iN0/w8fGdYCvS6+8z7vBw7TN92oBiWu2nZFAwqQvrclovyKoHQUuN+UUyw
	XYQnTaX+Fo+8LtVrNe0C2weV18dqq2eYBA1M/pnQzGJg2JI5MICVloK6e/VNK3eirnF8vU
	3jRuMoMcA+Qj04aOy52gE1X4HDNaHWEw8io7+63l+FoNhcPojw9dhL7Nw2tGjxJ3zSTs+p
	ptabCjrOAZ+J88B4XOqdNtIWKg0RMVcjvpejQXXrcscnYZm+uY6gMaiAAP96uw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1742217195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=elqP/dUEnChhUjOELroRy5eKXIUAe/WjjQGOV3HaO7E=;
	b=TmU8ZwIBDgFSXy4f9Hkvc7e3MUDHrgOMWgcCHBnxX1G/So9RTTrqHB7Z7chCDGoB5lWjeD
	x4G4jNs//SoM48Dg==
To: Sean Christopherson <seanjc@google.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Jacob Pan
 <jacob.jun.pan@linux.intel.com>, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 2/8] x86/irq: Track if IRQ was found in PIR during
 initial loop (to load PIR vals)
In-Reply-To: <20250315030630.2371712-3-seanjc@google.com>
References: <20250315030630.2371712-1-seanjc@google.com>
 <20250315030630.2371712-3-seanjc@google.com>
Date: Mon, 17 Mar 2025 14:13:15 +0100
Message-ID: <87wmcn4x78.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Mar 14 2025 at 20:06, Sean Christopherson wrote:
> @@ -409,25 +409,28 @@ static __always_inline bool handle_pending_pir(u64 *pir, struct pt_regs *regs)
>  {
>  	int i, vec = FIRST_EXTERNAL_VECTOR;
>  	unsigned long pir_copy[4];
> -	bool handled = false;
> +	bool found_irq = false;
>  
> -	for (i = 0; i < 4; i++)
> +	for (i = 0; i < 4; i++) {
>  		pir_copy[i] = READ_ONCE(pir[i]);
> +		if (pir_copy[i])
> +			found_irq = true;
> +	}

That's four extra conditional branches. You can avoid them completely. See
delta patch below.

Thanks,

        tglx
---        
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -407,17 +407,15 @@ void intel_posted_msi_init(void)
  */
 static __always_inline bool handle_pending_pir(u64 *pir, struct pt_regs *regs)
 {
+	unsigned long pir_copy[4], pend = 0;
 	int i, vec = FIRST_EXTERNAL_VECTOR;
-	unsigned long pir_copy[4];
-	bool found_irq = false;
 
 	for (i = 0; i < 4; i++) {
 		pir_copy[i] = READ_ONCE(pir[i]);
-		if (pir_copy[i])
-			found_irq = true;
+		pend |= pir_copy[i];
 	}
 
-	if (!found_irq)
+	if (!pend)
 		return false;
 
 	for (i = 0; i < 4; i++) {


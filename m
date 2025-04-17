Return-Path: <kvm+bounces-43558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B946A919CD
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 12:51:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C595C5A6FDE
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 10:50:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7836E22AE74;
	Thu, 17 Apr 2025 10:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="kYGADsBq";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="hYZ1aIn3"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43102356AE;
	Thu, 17 Apr 2025 10:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744887008; cv=none; b=fJ9CS2/pAaxFSG9H9j4NrLFv2RvrcOldDVqQsxCTJhIRODWNwcwteK7hNPEZjdvVnIiTSLnz5fcU51qcGUR4qurcH65FCQx6Lo2128if7vj6wQpobPk9Pwv40HdfklqySGcFSZPzLwsPl879n6oHmsnPdk8bIjFr0ciA9AZHHWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744887008; c=relaxed/simple;
	bh=fHt9v11xJay+tpSZs3Zlbur4bEkB+EmQhHNI8b/cImA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=cnbYetyVIzbgAyhI+32/EHYo4gI5xXlls7FuP3uv9rkF7Xv495wf/Gc0aASst+gPWWmgBGvCN3+YBm9K/1+5EB9rkNKR342nMYZoFzk38BLuiFEXgNcn6mC7BEc1KIgGdRcCG7iP8zh7/2O01KJnQTLuY7JNPYpH7cWHA4vvg/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=kYGADsBq; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=hYZ1aIn3; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1744887004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jUgP7QIAkoCQuc95oiAM2VFsr+DSEvrjzzdDoEmLzAk=;
	b=kYGADsBqFf8IlDrezSa3zIJ+BT4RNlAnd3iH+5GTw+BKrObB1f8EluY48Qe6s+cltv3JhD
	VaLaR3a+Qc/Zj8dJr8s55MAZ9Fel6sMPkivRYKWJrKkwiSJewORSL9Oq/FTTCeHsLDSz6i
	Zz85DqgV10It7a0zjffVTw/VtF/HW7yXOopczfeIcgep0k5QQBocltWnY4vzwXJ8GeeWJy
	b6QgY7Vuic0JTDuSgFF9Z+CUiHR7luoEWOdlswpDjIeUZ+gvk8U7/mKI9yYTixDnMJYDZl
	OvscdGLXiqmWIMHUqUXqscOY5XarNuycFUeStTBrvo9F3e0qXNj9IHoMboNyWA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1744887004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jUgP7QIAkoCQuc95oiAM2VFsr+DSEvrjzzdDoEmLzAk=;
	b=hYZ1aIn3APfPnc9HM9Z3FojJjQszJXZ2FgdFK4s/By++uUr+h0rARMU8MfKbv3ceJRtiEr
	LFejf3luJhdMG3Ag==
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com, francescolavra.fl@gmail.com
Subject: Re: [PATCH v4 06/18] x86/apic: Add update_vector callback for
 Secure AVIC
In-Reply-To: <20250417091708.215826-7-Neeraj.Upadhyay@amd.com>
References: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
 <20250417091708.215826-7-Neeraj.Upadhyay@amd.com>
Date: Thu, 17 Apr 2025 12:50:04 +0200
Message-ID: <87a58frrj7.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Apr 17 2025 at 14:46, Neeraj Upadhyay wrote:
> Add update_vector callback to set/clear ALLOWED_IRR field in
> a vCPU's APIC backing page for external vectors. The ALLOWED_IRR
> field indicates the interrupt vectors which the guest allows the
> hypervisor to send (typically for emulated devices). Interrupt
> vectors used exclusively by the guest itself and the vectors which
> are not emulated by the hypervisor, such as IPI vectors, are part
> of system vectors and are not set in the ALLOWED_IRR.

Please structure changelogs properly in paragraphs:

  https://www.kernel.org/doc/html/latest/process/maintainer-tip.html#changelog

>  arch/x86/include/asm/apic.h         |  9 +++++
>  arch/x86/kernel/apic/vector.c       | 53 ++++++++++++++++++++++-------
>  arch/x86/kernel/apic/x2apic_savic.c | 35 +++++++++++++++++++

And split this patch up into two:

  1) Do the modifications in vector.c which is what the $Subject line
     says

  2) Add the SAVIC specific bits

> @@ -471,6 +473,12 @@ static __always_inline bool apic_id_valid(u32 apic_id)
>  	return apic_id <= apic->max_apic_id;
>  }
>  
> +static __always_inline void apic_update_vector(unsigned int cpu, unsigned int vector, bool set)
> +{
> +	if (apic->update_vector)
> +		apic->update_vector(cpu, vector, set);
> +}

This is in the public header because it can?
  
> -static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
> -			       unsigned int newcpu)
> +static int irq_alloc_vector(const struct cpumask *dest, bool resvd, unsigned int *cpu)
> +{
> +	int vector;
> +
> +	vector = irq_matrix_alloc(vector_matrix, dest, resvd, cpu);

        int vector = irq_matrix_alloc(...);

> +
> +	if (vector >= 0)
> +		apic_update_vector(*cpu, vector, true);
> +
> +	return vector;
> +}
> +
> +static int irq_alloc_managed_vector(unsigned int *cpu)
> +{
> +	int vector;
> +
> +	vector = irq_matrix_alloc_managed(vector_matrix, vector_searchmask, cpu);
> +
> +	if (vector >= 0)
> +		apic_update_vector(*cpu, vector, true);
> +
> +	return vector;
> +}

I completely fail to see the value of these two functions. Each of them
has exactly _ONE_ call site and both sites invoke apic_update_vector()
when the allocation succeeded. Why can't you just do the obvious and
leave the existing code alone and add

      if (apic->update_vector)
      		apic->update_vector();

into apic_update_vector()? But then you have another place where you
need the update, which does not invoke apic_update_vector().

Now if you look deeper, then you notice that all places which invoke
apic_update_vector() invoke apic_update_irq_cfg(), which is also called
at this other place, no?

> +static void irq_free_vector(unsigned int cpu, unsigned int vector, bool managed)
> +{
> +	apic_update_vector(cpu, vector, false);
> +	irq_matrix_free(vector_matrix, cpu, vector, managed);
> +}

This one makes sense, but please name it: apic_free_vector()

Something like the uncompiled below, no?

Thanks,

        tglx
---
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -134,9 +134,19 @@ static void apic_update_irq_cfg(struct i
 
 	apicd->hw_irq_cfg.vector = vector;
 	apicd->hw_irq_cfg.dest_apicid = apic->calc_dest_apicid(cpu);
+
+	if (apic->update_vector)
+		apic->update_vector(cpu, vector, true);
+
 	irq_data_update_effective_affinity(irqd, cpumask_of(cpu));
-	trace_vector_config(irqd->irq, vector, cpu,
-			    apicd->hw_irq_cfg.dest_apicid);
+	trace_vector_config(irqd->irq, vector, cpu, apicd->hw_irq_cfg.dest_apicid);
+}
+
+static void apic_free_vector(unsigned int cpu, unsigned int vector, bool managed)
+{
+	if (apic->update_vector)
+		apic->update_vector(cpu, vector, false);
+	irq_matrix_free(vector_matrix, cpu, vector, managed);
 }
 
 static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
@@ -174,8 +184,7 @@ static void apic_update_vector(struct ir
 		apicd->prev_cpu = apicd->cpu;
 		WARN_ON_ONCE(apicd->cpu == newcpu);
 	} else {
-		irq_matrix_free(vector_matrix, apicd->cpu, apicd->vector,
-				managed);
+		apic_free_vector(apicd->cpu, apicd->vector, managed);
 	}
 
 setnew:
@@ -183,6 +192,7 @@ static void apic_update_vector(struct ir
 	apicd->cpu = newcpu;
 	BUG_ON(!IS_ERR_OR_NULL(per_cpu(vector_irq, newcpu)[newvec]));
 	per_cpu(vector_irq, newcpu)[newvec] = desc;
+	apic_update_irq_cfg(irqd, newvec, newcpu);
 }
 
 static void vector_assign_managed_shutdown(struct irq_data *irqd)
@@ -261,8 +271,6 @@ assign_vector_locked(struct irq_data *ir
 	if (vector < 0)
 		return vector;
 	apic_update_vector(irqd, vector, cpu);
-	apic_update_irq_cfg(irqd, vector, cpu);
-
 	return 0;
 }
 
@@ -338,7 +346,6 @@ assign_managed_vector(struct irq_data *i
 	if (vector < 0)
 		return vector;
 	apic_update_vector(irqd, vector, cpu);
-	apic_update_irq_cfg(irqd, vector, cpu);
 	return 0;
 }
 
@@ -357,7 +364,7 @@ static void clear_irq_vector(struct irq_
 			   apicd->prev_cpu);
 
 	per_cpu(vector_irq, apicd->cpu)[vector] = VECTOR_SHUTDOWN;
-	irq_matrix_free(vector_matrix, apicd->cpu, vector, managed);
+	apic_free_vector(apicd->cpu, vector, managed);
 	apicd->vector = 0;
 
 	/* Clean up move in progress */
@@ -366,7 +373,7 @@ static void clear_irq_vector(struct irq_
 		return;
 
 	per_cpu(vector_irq, apicd->prev_cpu)[vector] = VECTOR_SHUTDOWN;
-	irq_matrix_free(vector_matrix, apicd->prev_cpu, vector, managed);
+	apic_free_vector(apicd->prev_cpu, vector, managed);
 	apicd->prev_vector = 0;
 	apicd->move_in_progress = 0;
 	hlist_del_init(&apicd->clist);
@@ -905,7 +912,7 @@ static void free_moved_vector(struct api
 	 *    affinity mask comes online.
 	 */
 	trace_vector_free_moved(apicd->irq, cpu, vector, managed);
-	irq_matrix_free(vector_matrix, cpu, vector, managed);
+	apic_free_vector(cpu, vector, managed);
 	per_cpu(vector_irq, cpu)[vector] = VECTOR_UNUSED;
 	hlist_del_init(&apicd->clist);
 	apicd->prev_vector = 0;


Return-Path: <kvm+bounces-8593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 260C7852AEE
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 09:23:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2C86281C68
	for <lists+kvm@lfdr.de>; Tue, 13 Feb 2024 08:23:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E34721104;
	Tue, 13 Feb 2024 08:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Jgi+hOLa";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="3Oqp1suo"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDAB1DFE5;
	Tue, 13 Feb 2024 08:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707812511; cv=none; b=dqVFkp3qDY6Lw9PgYtnOSuY9uiXqWFhcQU29FJD7Ew8kaxYRZ26o3NVKTSpNXnouRcj5C67BFd9hRIeTl86pSg8Ei6UIuBkFXKisd1tN0tebXiyPY4nlb62mMMZIOwHSbB+KN9x2uUTwK9UflSZSJNB56/qxftiT6IJlVpSambc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707812511; c=relaxed/simple;
	bh=ZYN3fgZ1tGHxq6qadPhlItMQrukownl7I8z2psyXd50=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=GbXB4bcvFQvVup+UwK23EBbp/oQ5pbciHLOHuEnftZA/Jr63iyydACQBwFC6pFrQN7WcfKXeoyVefgoghv89KLmO9sHar7lUZ80ZlEPZvpGQwXDQjUNIpCsnR0KNOocOE4nr7lrk+WilNr3bASL+NWwcDay1Rj1Kww4MGrsos0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Jgi+hOLa; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=3Oqp1suo; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1707812507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uNP018TzEdyi2awCaDDsbZbsgpQqF7Eu571Tlmw7Oro=;
	b=Jgi+hOLaQsr/UGFvcL5OIaoAo00LqK+tQ1fuJFUzA9wBnjsA4xbszrZYGy803tdheNSPGM
	zr883ldWnjRSzLeyQcIw2nmLk8s+w94aUew8D2hn5IF51Bq8BNrbSVtFXicpLBLE4yn7WZ
	ZfNcEzdKS6ANDhFp1NdSLoCCOqnBACdTHGWJgWEADDJgy1M0OMKls+dMmEYnkEx5VQwVFu
	fF5Cb+g1bcRVGQMN5jjJa+934B9iHLiWmylGP83jdQuQ0hsOoGNFuZgMyU9Wcxce0/VNsY
	zqSJ6yabMu+PEdtFO/c9rPEgWfBUTSGBA/KXOHEfsLlRShX+YrQXSkM7qW9IcQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1707812507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uNP018TzEdyi2awCaDDsbZbsgpQqF7Eu571Tlmw7Oro=;
	b=3Oqp1suoZ6wKVGQaFsmcPpdmcAAxud3CbvcTrk1PhzLGEQYHHO6TEDTa8nhmEnA8N6GRbF
	y12ONlpFeQ90J5CQ==
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>,
 iommu@lists.linux.dev, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>, Joerg Roedel
 <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov
 <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, Raj Ashok
 <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, peterz@infradead.org, seanjc@google.com, Robin Murphy
 <robin.murphy@arm.com>, jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH RFC 12/13] iommu/vt-d: Add a helper to retrieve PID address
In-Reply-To: <20240126153047.5e42e5d0@jacob-builder>
References: <20231112041643.2868316-1-jacob.jun.pan@linux.intel.com>
 <20231112041643.2868316-13-jacob.jun.pan@linux.intel.com>
 <874jgvuls0.ffs@tglx> <20240126153047.5e42e5d0@jacob-builder>
Date: Tue, 13 Feb 2024 09:21:47 +0100
Message-ID: <87le7oixk4.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Jan 26 2024 at 15:30, Jacob Pan wrote:
> On Wed, 06 Dec 2023 21:19:11 +0100, Thomas Gleixner <tglx@linutronix.de>
> wrote:
>> > +static u64 get_pi_desc_addr(struct irq_data *irqd)
>> > +{
>> > +	int cpu =
>> > cpumask_first(irq_data_get_effective_affinity_mask(irqd));  
>> 
>> The effective affinity mask is magically correct when this is called?
>> 
> My understanding is that remappable device MSIs have the following
> hierarchy,e.g.

SNIP

> Here the parent APIC chip does apic_set_affinity() which will set up
> effective mask before posted MSI affinity change.
>
> Maybe I missed some cases?

The function is only used in intel_ir_reconfigure_irte_posted() in the
next patch, but it's generally available. So I asked that question
because if it's called in some other context then it's going to be not
guaranteed.

That also begs the question why this function exists in the first
place. This really can be part of intel_ir_reconfigure_irte_posted(),
which makes it clear what the context is, no?

Thanks,

        tglx


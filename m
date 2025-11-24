Return-Path: <kvm+bounces-64340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 27D9DC7FFC4
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 11:49:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 76A9C4E477E
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 10:48:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FF152777E0;
	Mon, 24 Nov 2025 10:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="advJ2CZM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2EB2550D5
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 10:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763981323; cv=none; b=MKuHJVZGGw9zUN4aTVryIkOcNAEP2RHAwfOf9wwnh+iQVSeuHjubj0QKwbkys+DfpzM+IP6L2zOS3nitrIuIg8iETWFuMlvtF2w/4XQ8YR/GYZxt6yg10BiVmvbnSEtyurkAdAdplNcIYl0Gu212X01vpyOL4aIoeDv7TRmXUp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763981323; c=relaxed/simple;
	bh=MHYfe8bGDtNpXB2soBddZZBCJYpkG+5RTuO0JL8Lr+Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=acy4gZXwkuDdLn9cn6vUZfMTGKr9w2BHxJNWiMt4bfEFrjjOMhXQQtnIL4e66EgLV1S0eyGe4s/60ZfkK2YdDOIOZFtffMZuPCZojg5Q9650kx/65QvJ/5d1LymyJK0F0CcGZ+KNAYo7ymaVTFk7kQzeCfy4H5lHuYbWIctuNFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=advJ2CZM; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--lrizzo.bounces.google.com
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b73599315adso309485566b.2
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 02:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763981320; x=1764586120; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lX+jdToFx/xjPzdH2tpm4CYF/HvbIMVX0oD+xboE4lA=;
        b=advJ2CZMK1kRBc7lW56l7CBWnUPsK3J/OH98bZrDZB21cs2vCF+Uqx/sHiZ64lt9sZ
         moQSt2/ALt9kM63TL/dd8YE3PiBkEwY0yoh1+Y+K7Orkyn+dBoFpPlO0Hp8QFD69WdPm
         enkTCDieWfaNOJblCwtUdeb5YPBoWGzRZszeQhxc3vfRoxFt3CzReD9nwQDHfiQKBSDe
         k55+Za/LcWb9wHokjFneQnMI+wZ3Bky9NFmWlgCL5sb03YA9mf13pcIPe4yZd8bnbAhS
         1Kfkw6skkZvldLp1b/FCTez3Ce2W1MC27BT82kKNbDBqqdducia9yM3gifdoaTFKhyln
         HWNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763981320; x=1764586120;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lX+jdToFx/xjPzdH2tpm4CYF/HvbIMVX0oD+xboE4lA=;
        b=m9Q2/nC2RfCMCjO5k5FdmR2qef+VHPBB9GGj1h+uN5twc5kwmlIZCc4SkylPMLw70M
         mCOVGEgFMJEh803pOLg9EsQytLHyeE8Y2nF8pXP/5NOWu6/kXYqEbySuFOVl8ouHbCpR
         +WheFkaapPSGtdtY38MGwKAnQBQsZE21xX3XetbBmR7ECvZABnGX9fzltD73wy0StFJA
         XddlIJw4qCBYdNphrGxT4vu6ZExZSs4DTBCrC6ufdhQpMJcVJnAB67tlgSnN9hUU0jYz
         aIHCXwNpzE/tjHgRo1WGp1ZpSk1LgKnwdAOGhTY/HFSyz4r8FRlorSfL0wcRcT8Af0g9
         sowQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7t5HxLRQ2vgKS5XWzHtvMK1oaDWewlG3chVR/TEKMf7yDfp3hmHMHvdT/g1ZVRW0WY/k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwktJpM+YnXeUqaoWncdPuJ2Zhl+jI0lco2d5J3VP+Br9V+3bJl
	FySOxRmt7wUsb/MmYFkKzpE6PG/rYvmk7E863unE+GpTdffY9EaAHDZhMmatQam7mouLUmReAUg
	ZfXkUdw==
X-Google-Smtp-Source: AGHT+IFoktae1A0BdrqpkwJD+MWHUxshGOT+nbpyXrTVzweW/1e+RqyV/RiSfy7EG3W/P8GjNhl7vPPfcAk=
X-Received: from ejcst14.prod.google.com ([2002:a17:907:c08e:b0:b73:724e:575e])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:4fce:b0:b73:a319:e8be
 with SMTP id a640c23a62f3a-b7671a221cfmr1351585866b.57.1763981320135; Mon, 24
 Nov 2025 02:48:40 -0800 (PST)
Date: Mon, 24 Nov 2025 10:48:36 +0000
In-Reply-To: <20240423174114.526704-1-jacob.jun.pan@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240423174114.526704-1-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <20251124104836.3685533-1-lrizzo@google.com>
Subject: Re: [PATCH v3  00/12] Coalesced Interrupt Delivery with posted MSI
From: Luigi Rizzo <lrizzo@google.com>
To: jacob.jun.pan@linux.intel.com, lrizzo@google.com, rizzo.unipi@gmail.com, 
	seanjc@google.com, tglx@linutronix.de
Cc: a.manzanares@samsung.com, acme@kernel.org, ashok.raj@intel.com, 
	axboe@kernel.dk, baolu.lu@linux.intel.com, bp@alien8.de, 
	dan.j.williams@intel.com, dave.hansen@intel.com, guang.zeng@intel.com, 
	helgaas@kernel.org, hpa@zytor.com, iommu@lists.linux.dev, 
	jim.harris@samsung.com, joro@8bytes.org, kevin.tian@intel.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org, 
	mingo@redhat.com, oliver.sang@intel.com, paul.e.luse@intel.com, 
	peterz@infradead.org, robert.hoo.linux@gmail.com, robin.murphy@arm.com, 
	x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

I think there is an inherent race condition when intremap=posted_msi
and the IRQ subsystem resends pending interrupts via __apic_send_IPI().

In detail:
intremap=posted_msi does not process vectors for which the
corresponding bit in the PIR register is set.

Now say that, for whatever reason, the IRQ infrastructure intercepts
an interrupt marking it as PENDING. . handle_edge_irq() and many other
places in kernel/irq have sections of code like this:

    if (!irq_may_run(desc)) {
        desc->istate |= IRQS_PENDING;
	mask_ack_irq(desc);
	goto out_unlock;
    }

Then eventually check_irq_resend() will try to resend pending interrupts

    desc->istate &= ~IRQS_PENDING;
    if (!try_retrigger(desc))
        err = irq_sw_resend(desc);

try_retrigger() on x86 eventually calls apic_retrigger_irq() which
uses __apic_send_IPI(). Unfortunately the latter does not seem to
set the 'vector' bit in the PIR (nor sends the POSTED_MSI interrupt)
thus potentially causing a lost interrupt unless there is some other
spontaneous interrupt coming from the device.

I could verify the stall (forcing the path that sets IRQS_PENDING),
and could verify that the patch below fixes the problem

 static int apic_retrigger_irq(struct irq_data *irqd)
 {
        struct apic_chip_data *apicd = apic_chip_data(irqd);
        unsigned long flags;
+       uint vec;

        raw_spin_lock_irqsave(&vector_lock, flags);
+       vec = apicd->vector;
+       if (posted_msi_supported() &&
+           vec >= FIRST_EXTERNAL_VECTOR && vec < FIRST_SYSTEM_VECTOR) {
+               struct pi_desc *pid = per_cpu_ptr(&posted_msi_pi_desc, apicd->cpu);

+               set_bit(vec, (unsigned long *)pid->pir64);
+               __apic_send_IPI(apicd->cpu, POSTED_MSI_NOTIFICATION_VECTOR);
+       } else {
                __apic_send_IPI(apicd->cpu, apicd->vector);
+       }
        raw_spin_unlock_irqrestore(&vector_lock, flags);

        return 1;
}

Am I missing something ? any better fix ?

cheers
luigi


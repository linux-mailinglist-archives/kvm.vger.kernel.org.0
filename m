Return-Path: <kvm+bounces-36188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 10C05A18650
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 22:00:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CFBC81889EC3
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 21:00:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 208361F76D3;
	Tue, 21 Jan 2025 20:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fJYF95Jd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E611AF0A6
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 20:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737493197; cv=none; b=IH1ldtkZRNPVC+sGHf0sjgSiVYEctecpsUnCGqvTxJEW+C86Aw12cYx93wdlP+1jyLdUan34zthO/tQqv0vZURx9dSaoEs3JylYCIxPnh0BSMOmmFDbraPsyAaUr37T1eDd/tqJa/kjtxD68iexZ71sJ1vtz83RGRk1J7eFg8to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737493197; c=relaxed/simple;
	bh=RSJ2jNH2a0MQIQoYiFMyHb3AyOc07mKg8rE2aqyvfqw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OYNHCIYXdgPKV4APY4ubUGuJP7zWN5mhb0COBeKqShQCybyMhCYV3/9WcQj5xRohcUkdh93B2OUDxG3i6OcHbg7xCkeNW4GLvlKLEuOb9qVz09PEW56JNQA9AYIE+mYoBJ3tU/8C25ewizAIY/WpzG74hy6e2sKhDrrtVwn+IHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fJYF95Jd; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f780a3d6e5so8531519a91.0
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 12:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737493195; x=1738097995; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Im/FOdhXlQQwLZxJNctfvsJTmb5xZBqKT77VsroFJb8=;
        b=fJYF95JdWW+3TFVEqpF80Z0AQj9HTZEEKpjepEaUCa+SvMjE5L0ea+9VG5oyIFdRiz
         Zqjr4B1jq0seiZpaXD5uX1v+wCfkKyrFrgLXeyOMH2jXIWE12T3vRhxwb+MoDX3GzBh4
         VD9uO3HOpeceWnrkM3w0bDX8xtwcIFCHuU6mWO/CmwlDTG6T6+tik9CzYr1SQXP47/Pc
         DAQP66MlBSPD02lDhtbZ8nPDjVmPojMlwmuyeIVFvB9I1Ye05z6fjkf3BxjU9SH/c21l
         vJNoU6Ba++hA4uhuuW1wOuEOT+jI6lgCGBAJI521bVNSy60BHnd+qG72zqUyZva1xwfb
         Mj+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737493195; x=1738097995;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Im/FOdhXlQQwLZxJNctfvsJTmb5xZBqKT77VsroFJb8=;
        b=uEEONoHh4gTcSJxHUfbmo94vHGX9g7b1hvpOkpQTn09T/rRiD3Rr7/6jz0h6A8K0Lp
         JZdfK3VwXxAOIvLrBvdlB6uHu6W3YYgv0z7E9TQtaCOY8uqNV4vYuj208VEEyzOa98bn
         f3sY0fKxRYKojsNqYQg989Lmpvkg/Kez0f1ASsO3UK8Jh17j/Scn3Ye7OTg38rdtdQu9
         RUlq6m9xc/DTf0IjstFS0LRUL0devf0Ps9Cc+RNQIhX1qLPWmduH9/YpsipYcHR8F/UB
         ZZ+k3Vt5DSXFNdU6SUgCwlEAv8k/J+4+F+ayih169TZJKUtdMwrTGMwVyaP/h+nFuM4X
         /XmA==
X-Forwarded-Encrypted: i=1; AJvYcCU4neKHdqmtANCgOJWcElJ1Fz9eaLPUJCmbFDI02Epg+2s+QKYPidhyXeCHqVnr3Q0tA30=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBJG69lUuS3M4dtFYkKazfaz0JjRun7zPsyvWwyhLfjqxPaKAH
	uHi2KjSAZwCtBAw3VO78FoMXnrop08GZud0c5QH98r2OWtfQ0p6WvlrankQkQrCMETKKW099g0u
	OtA==
X-Google-Smtp-Source: AGHT+IE0WEQ1HbyrNa9QwgA1eLbu9Bad3RgEPgNdFBtCisMjil/J3jYFk3ITHYWwWAza5LJWZWmmQvJGbHE=
X-Received: from pjbqi11.prod.google.com ([2002:a17:90b:274b:b0:2ef:973a:3caf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d887:b0:2ea:3f34:f194
 with SMTP id 98e67ed59e1d1-2f782c90219mr30311411a91.10.1737493195186; Tue, 21
 Jan 2025 12:59:55 -0800 (PST)
Date: Tue, 21 Jan 2025 12:59:54 -0800
In-Reply-To: <Z43n5J+a3BPqTBsP@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250106155652.484001-1-kentaishiguro@sslab.ics.keio.ac.jp> <Z43n5J+a3BPqTBsP@intel.com>
Message-ID: <Z5AKygcUcmnEtm0d@google.com>
Subject: Re: [RFC] Para-virtualized TLB flush for PV-waiting vCPUs
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Kenta Ishiguro <kentaishiguro@sslab.ics.keio.ac.jp>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, vkuznets@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 20, 2025, Chao Gao wrote:
> On Tue, Jan 07, 2025 at 12:56:52AM +0900, Kenta Ishiguro wrote:
> >In oversubscribed environments, the latency of flushing the remote TLB can
> >become significant when the destination virtual CPU (vCPU) is the waiter
> >of a para-virtualized queued spinlock that halts with interrupts disabled.
> >This occurs because the waiter does not respond to remote function call
> >requests until it releases the spinlock. As a result, the source vCPU
> >wastes CPU time performing busy-waiting for a response from the
> >destination vCPU.
> >
> >To mitigate this issue, this patch extends the target of the PV TLB flush
> >to include vCPUs that are halting to wait on the PV qspinlock. Since the
> >PV qspinlock waiters voluntarily yield before being preempted by KVM,
> >their state does not get preempted, and the current PV TLB flush overlooks
> >them. This change allows vCPUs to bypass waiting for PV qspinlock waiters
> >during TLB shootdowns.
> 
> This doesn't seem to be a KVM-specific problem; other hypervisors should
> have the same problem. So, I think we can implement a more generic solution
> w/o involving the hypervisor. e.g., the guest can track which vCPUs are
> waiting on PV qspinlock, delay TLB flush on them and have those vCPUs
> perform TLB flush after they complete their wait (e.g., right after the
> halt() in kvm_wait()).

I don't think that works though.  E.g. what if the vCPU takes an NMI (guest NMI)
while waiting on the spinlock, and the NMI handler accesses the virtual address
that was supposed to be flushed?

The PV approach works because the hypervisor can guarantee the flush will occur
before the vCPU can run *any* code.


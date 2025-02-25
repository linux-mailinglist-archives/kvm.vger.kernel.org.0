Return-Path: <kvm+bounces-39076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FD0CA43262
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 02:21:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE5B516FC0B
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 01:21:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF6381CD1F;
	Tue, 25 Feb 2025 01:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tSANY1kL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7BE440C
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 01:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740446461; cv=none; b=CHg+ZTmP0bWYeNXDH5pXXPR4Bvb1pjLuge6bSEm7PHu65FgR5kAl7B7RRZFGDmovvUtuLqxLDQ4JQH+g1QUC/zL1K83ioHWyF0HuMVqnI6BPBIWUCmrpEcuYadp7BXbg8KzTv0H5+M1xpy+772zce8ssw2k3vBqBtd3lu7ZMLK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740446461; c=relaxed/simple;
	bh=Wugmkt5xJmRsguvq0RzJRXa2tvO6acVPUzsogtyMuy4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HuPVn9KZ36mZuXKIuF2oNIY3jwrMsLiSkTJrl6xYh5C2Hzk9xLMFbwErwUuM8UdZ4dOHQHDXOF0/Be84Xe98K9vs6g4YykLMVTgdDF7ZpV7gFw0edBYUHH/9efiOpS3a8/jWRLxekI4t9c43ehHK5KcBshZBzQcZHFrnsWem+9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tSANY1kL; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2f816a85facso10431826a91.3
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 17:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740446460; x=1741051260; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KhuCDTOw0Us5BVcKF1+QFSBZ4UEVmSiB8kBnJMAvdzs=;
        b=tSANY1kLM8aFytNFaxboCWzTRk/b/uUVLKiqOKNTiu5vuPtuImA3louIX6vKKOAQ+J
         JK5cNwKxOQzCzkngf4snP5+Gy30v+cR0t2G7WGzs69KIzNkmyf1VeKqfOySvQF3uzMQZ
         WFliM0cpE5PL7Ioopuhzin2Fdayv23yAii4ksy6QgMz83EIMDl9rgnH5Vg6dHXY1mik1
         dB52xj0+W65xcKg14QePKWNRqJxPAe7qieKl2nl/Ujp9xTx6GFq4tD7zvYfqj6QbGpWm
         HZc2UCskQreTxCQw864b/viOSSzkzrvbX/duj+P/Ts1YhYCHNV/4zv3YaQcP0N+z3rJH
         tJfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740446460; x=1741051260;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KhuCDTOw0Us5BVcKF1+QFSBZ4UEVmSiB8kBnJMAvdzs=;
        b=oJv/j2ss9J3FoyOWdtfoB6ox28cPBoQO6WeWjaUJYdxduQ/gb3OYSdXD8+M2ndtOBK
         hNL7w351bW+FtOgeOpttD6fKfI1clniaBq+CiQX1ADkbzBnSkLEtyeKEmZknq81L/2ua
         TgiddRMCXarbhF7t1fejhHKjLuRNs3Oo7LVsCAiHOujrLL9pj0oh7wUqppT6ZR7txCTa
         QH9NCuE0K9XbH/QxIk2NlXRzzxXlTcNCBR6BSRzGFLMJ7xiuElaWISVPPiRHOyfJe5Ef
         zJmpRYyVrWG3sLTCuBK9Y8M0iG7Z3APb8lisjDFbrWcXPJSle2Mxn8O8i0RrwAirKmo1
         HiLw==
X-Forwarded-Encrypted: i=1; AJvYcCVw8xiTWkGZ23O9Wv0vRWkmTji8XWp10edLoEYeQYmTApaViFb/7ecENYpcR1lOWOuoRGA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAHwC8Er3N0uNq9lBx0GVrI9KJVhcDhfliCEqjFEL733vtV6Rl
	GzjzK9WGFxGD6PnHk1BEWuBfRUGuYjh9tp7+Ef5Mjar3OVb+IQUK8AY/U6rzOx3jTbKkaUJggsu
	0mQ==
X-Google-Smtp-Source: AGHT+IF6Ov5mbVPeDXrS1O6XppXRH2vWLamGDPeoTJOvPQfHNZqX54rGl64V5M/gncTKJUFIIi2qh6tM+Bk=
X-Received: from pjbee14.prod.google.com ([2002:a17:90a:fc4e:b0:2ef:82c0:cb8d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2d87:b0:2ee:f076:20fb
 with SMTP id 98e67ed59e1d1-2fce86cf0b7mr28771165a91.17.1740446459818; Mon, 24
 Feb 2025 17:20:59 -0800 (PST)
Date: Mon, 24 Feb 2025 17:20:58 -0800
In-Reply-To: <Z70UsI0kgcZu844d@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250219012705.1495231-1-seanjc@google.com> <20250219012705.1495231-4-seanjc@google.com>
 <4e762d94-97d4-2822-4935-2f5ab409ab29@amd.com> <Z7z43JVe2C4a7ElJ@google.com>
 <f9050ee1-3f82-7ae0-68b0-eccae6059fde@amd.com> <Z70UsI0kgcZu844d@google.com>
Message-ID: <Z70a-hi6HDvjx2qg@google.com>
Subject: Re: [PATCH 03/10] KVM: SVM: Terminate the VM if a SEV-ES+ guest is
 run with an invalid VMSA
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>, 
	Alexey Kardashevskiy <aik@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 24, 2025, Sean Christopherson wrote:
> On Mon, Feb 24, 2025, Tom Lendacky wrote:
> > On 2/24/25 16:55, Sean Christopherson wrote:
> > > On Mon, Feb 24, 2025, Tom Lendacky wrote:
> > >> On 2/18/25 19:26, Sean Christopherson wrote:
> > >>> -void pre_sev_run(struct vcpu_svm *svm, int cpu)
> > >>> +int pre_sev_run(struct vcpu_svm *svm, int cpu)
> > >>>  {
> > >>>  	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
> > >>> -	unsigned int asid = sev_get_asid(svm->vcpu.kvm);
> > >>> +	struct kvm *kvm = svm->vcpu.kvm;
> > >>> +	unsigned int asid = sev_get_asid(kvm);
> > >>> +
> > >>> +	/*
> > >>> +	 * Terminate the VM if userspace attempts to run the vCPU with an
> > >>> +	 * invalid VMSA, e.g. if userspace forces the vCPU to be RUNNABLE after
> > >>> +	 * an SNP AP Destroy event.
> > >>> +	 */
> > >>> +	if (sev_es_guest(kvm) && !VALID_PAGE(svm->vmcb->control.vmsa_pa)) {
> > >>> +		kvm_vm_dead(kvm);
> > >>> +		return -EIO;
> > >>> +	}
> > >>
> > >> If a VMRUN is performed with the vmsa_pa value set to INVALID_PAGE, the
> > >> VMRUN will fail and KVM will dump the VMCB and exit back to userspace
> > > 
> > > I haven't tested, but based on what the APM says, I'm pretty sure this would crash
> > > the host due to a #GP on VMRUN, i.e. due to the resulting kvm_spurious_fault().
> > > 
> > >   IF (rAX contains an unsupported physical address)
> > >     EXCEPTION [#GP]
> > 
> > Well that's for the VMCB, the VMSA is pointed to by the VMCB and results
> > in a VMEXIT code of -1 if you don't supply a proper page-aligned,
> > physical address.
> 
> Ah, good to know (and somewhat of a relief :-) ).

If anyone else was wondering, the behavior is described in the "VMRUN Page Checks"
table, which "Table 15-4" in the March 2024 version of the APM.

FWIW, knowing that VMRUN is supposed to handle this scenario does make me somewhat
tempted to skip this patch entirely.  But I still don't like the idea of doing
VMRUN with a known bad address.


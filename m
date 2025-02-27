Return-Path: <kvm+bounces-39583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D1F7A481B0
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 15:40:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EC2419C0201
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 14:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ACF6236A9F;
	Thu, 27 Feb 2025 14:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lv0RQDPs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA53823315F
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 14:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740666573; cv=none; b=DsiUfgq6Vulk0f8HruKG0t8aOGw129XyAY29IEsYFrmuV9jxP/ANUUi+uo9MIrmeR4AJwon51N/vUX5IgpIJhdeoxYmV3qytSmusU2LqUJHdpSk3moN35CdjPpCxD4U6och74tLXqPhWQpnIgrGB5Ftd25MeF5LcI9GOzgsCgIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740666573; c=relaxed/simple;
	bh=I4G5WWsVQdvWS78lZFUoa2OjVza2pMq7jbWJO+cz79k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g41BYUvWgLBNTpbfkC9AKOeWjY248MZMYgofta81BHJP6tl1yNqkZWMRBkp8Vgst9mOawsjucPPfkMhwcteL1wRowNRGXr0lsUHno5ck/bDvBP/GhwlooucSn4E0N5TI80nCGva5oP5ff6NpU0/IPTpe0kHqhCwj53UqkKtB69E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lv0RQDPs; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc1e7efdffso3362755a91.0
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 06:29:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740666571; x=1741271371; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8VqRNloE9v7R57Ow21OrBuM+9dpJSn1YgM0w2inRn2I=;
        b=Lv0RQDPs0krCui70kRg6by2tid+/N5LPU+qhevj5QyaVh/w33Vyl612uS6c1jc9uak
         0rolOntxfNjylsMEvsYnwebEZudCelA1qdTAb/Y5OYlwz2PeHhGX0O14tW0vdTYBejck
         0FKZYdu0jGBD2rvj2vidjXTZD/E2WWPDntVLXfxLX7hi/q8xmJ/J3KT9fWNBZ8+VS+cu
         DjhR+d1rIZrovxVYCtCX169AfkVgggV5ugNCnkOyUwssMpna56GauoppUKTiuSJ/EUdA
         z6Ab/nm/75AxpAGeyxZthSPHRr+BW/vR9KWFg2wmki0+tdOm7cHHyPucysCrFdc0GQ+3
         SCIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740666571; x=1741271371;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8VqRNloE9v7R57Ow21OrBuM+9dpJSn1YgM0w2inRn2I=;
        b=rQbLC//myL96IAqPGXtYyOX3SEUImAQBBbA51LbFEqbnA03PdTLQLLBu02RORHVxtt
         EzdlE2u71QNhX5PLPBEuQs9VZC+om2kgsNZZrADpRPKHnndgfUNo12i9TvU+RuHBlP7U
         Urm3WFtBmptTfUdD1Ol3eHiuV6mZkjL5Ek+3wfYhhcXa7ZRcOPJ/ua33HwZv9ABL113k
         7KqfXcjUleHRoVdudMJ4unPpXAsLV7LrhavuoUk8TWFLw98i17l/zm2J4lLc5Z5O0DMN
         tIkIFttL48/DWHMxmHEZ6wO34KNCnwutXSyyzyX1NnIWKMLEFGKaFbj2vDIFAoZ+yBuG
         CxHg==
X-Forwarded-Encrypted: i=1; AJvYcCW7quscCELSCGP9tnkIK0+yzu5ynZX0d3mAa63GZ+/u/+rj1XdQ1s8HV+g36pP7dnueD3c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjDYehJi+ZGff9H3T73EhWlVZYVnZBL7PAWCiUJkYIHnesmgKf
	VmccT0KbdZ43lAiIooEujT8l/OdehVN6IoleRHTEGgGaJnULHHH0GOrOaX7pxo5knDrPRGTQVnK
	JrQ==
X-Google-Smtp-Source: AGHT+IFNogE8ezxTaFArKz665dl+t5hqEN86uMsxb65BmgdxJlo/veEPvc6FXfY7QGi4xlS4t2omej/ExUk=
X-Received: from pjbov6.prod.google.com ([2002:a17:90b:2586:b0:2fa:a30a:3382])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5688:b0:2ee:d63f:d77
 with SMTP id 98e67ed59e1d1-2fe68adec61mr19840711a91.9.1740666571158; Thu, 27
 Feb 2025 06:29:31 -0800 (PST)
Date: Thu, 27 Feb 2025 06:29:29 -0800
In-Reply-To: <095fe2d0-5ce4-4e0f-8f1b-6f7d14a20342@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227011321.3229622-1-seanjc@google.com> <20250227011321.3229622-4-seanjc@google.com>
 <095fe2d0-5ce4-4e0f-8f1b-6f7d14a20342@amd.com>
Message-ID: <Z8B2yWTva-B2Lfqt@google.com>
Subject: Re: [PATCH v2 3/5] KVM: SVM: Manually context switch DEBUGCTL if LBR
 virtualization is disabled
From: Sean Christopherson <seanjc@google.com>
To: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, rangemachine@gmail.com, whanos@sergal.fun
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 27, 2025, Ravi Bangoria wrote:
> Hi Sean,
> 
> > @@ -4265,6 +4265,16 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
> >  	clgi();
> >  	kvm_load_guest_xsave_state(vcpu);
> >  
> > +	/*
> > +	 * Hardware only context switches DEBUGCTL if LBR virtualization is
> > +	 * enabled.  Manually load DEBUGCTL if necessary (and restore it after
> > +	 * VM-Exit), as running with the host's DEBUGCTL can negatively affect
> > +	 * guest state and can even be fatal, e.g. due to Bus Lock Detect.
> > +	 */
> > +	if (!(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK) &&
> > +	    vcpu->arch.host_debugctl != svm->vmcb->save.dbgctl)
> > +		update_debugctlmsr(0);
> 
>                 ^^^^^^^^^^^^^^^^^^^^^
> You mean:
>                 update_debugctlmsr(svm->vmcb->save.dbgctl);
> ?

Argh, yes.

> Somewhat related but independent: CPU automatically clears DEBUGCTL[BTF]
> on #DB exception. So, when DEBUGCTL is save/restored by KVM (i.e. when
> LBR virtualization is disabled), it's KVM's responsibility to clear
> DEBUGCTL[BTF].
> ---
> @@ -2090,6 +2090,14 @@ static int db_interception(struct kvm_vcpu *vcpu)
>  	      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP)) &&
>  		!svm->nmi_singlestep) {
>  		u32 payload = svm->vmcb->save.dr6 ^ DR6_ACTIVE_LOW;
> +
> +		/*
> +		 * CPU automatically clears DEBUGCTL[BTF] on #DB exception.
> +		 * Simulate it when DEBUGCTL isn't auto save/restored.
> +		 */
> +		if (!(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK))
> +			svm->vmcb->save.dbgctl &= ~0x2;

Any reason not to clear is unconditionally?

		svm->vmcb->save.dbgctl &= ~DEBUGCTLMSR_BTF;

>  		kvm_queue_exception_p(vcpu, DB_VECTOR, payload);
>  		return 1;
>  	}
> ---
> 
> Thanks,
> Ravi


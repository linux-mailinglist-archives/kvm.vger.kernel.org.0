Return-Path: <kvm+bounces-18702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 754968FA6E0
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 02:17:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B5F1286986
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 00:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEFBB8C1F;
	Tue,  4 Jun 2024 00:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YOtUEOUs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14F24A11
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 00:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717460195; cv=none; b=cFJq/WaMlTx/FQV36TQJqn8zdZ5++Du2U+XYwQ1/8Nud3yIxECEj+ni8ZgaKn8u2pZ6fo7eME0m92nt4r0reoPpdG2F45Dbx+7oluxXAwGltcP7JDR3L+HU6WVaReLibUGO/JAuuq2smn9FmwONSSXIXlnoBPfc5VDtZgugo+28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717460195; c=relaxed/simple;
	bh=nwUxXuGO/V+qs74FXe4f9EFw4ZB9RigLc/DpnKdr0IQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C5eByLCcGpOtV1g4BukK0GucsqDktE459kx8R7aAFRYia9B8+bWCTItFlud2kaSwTnuaJ2L8Yn6uEGMGqG7zSFRHAIeAi9H9bLDUVIcPrmNrCrpzZi9CsybVEIIqMirFRmsi2Hp9+n6cBQj3JaEBILExLwt7Ttx4RRKB9fUCGDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YOtUEOUs; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70243d69117so3636179b3a.3
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 17:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717460193; x=1718064993; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G/TfS4/60UepRstkKEdbSidSYhzWazLDql3xTTEsWh4=;
        b=YOtUEOUs+eu1Cfex72x1qvNEl0TRqacvHAxUdT/ssuKZ4v1OBk37LmCGDjnt6BROfw
         r4SJBnEBw0Pkdo/ocMS9ehi2Taq2oA5hVTynI72yIlyx2btF6R34clqT5TS56RYHSLqQ
         4rkS7nUpddBVM+1cKbxKE8gT5JVmnfySHhEGVsT+jKFKnLYpy22zTL7cSoXK2EQ7ZQFl
         3YwOAZSyi6CkInPVA0c7yvUVkeKwir7NyAkzLjL4HxvAWey1qAyLXMfWOoXDrq3bVFFl
         bUMoecTJ8n1f0vtVRcTi+z79aun+5KHvWojHk8o/wpGIGPklAeeUEvpUI1w+TkN/w7rB
         nupg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717460193; x=1718064993;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G/TfS4/60UepRstkKEdbSidSYhzWazLDql3xTTEsWh4=;
        b=blFI+hyZS901kruLV0qcj8/xrhGQBrkIrI2sBdJHRvR1ppbKeN/2xERvqRqdNJ/mvI
         K7y2lWU8HrH+xAu8vSxgKgjggDbHyte5062N4PuFyUK9rEy4wnP4WhM378zUumk6/JjQ
         jYo6tUizZIAY2eDJdi9OVaWazyY+UsEMTnqAFYcdmIoIK7iKva0Wb/6xDp5dhPQA0D40
         1+W4kHxhkq5olzLrdOPc85yS3zrL5IUGJnzPLL8MqYtzUqH6OkGdjugzfDSxtt0Poop1
         m8iWWT4GAZVJhpiTYLpNWnn0WFFySZX8XXFme54/d7W2td3o3FKrU+PqZ+rKASd79xvp
         OG6A==
X-Gm-Message-State: AOJu0YygqG0IzADtbJjgqBFZHfsKoHefxhS3QJKPBWhIEtAIbE1W12d4
	c9b5xOqcH1PWkzTd63kx6feFzWyqtMlzSX3+oM5Q9SBaeaiuAxHJxgS2B8XsQC0lhiPGOxBlzPA
	m+g==
X-Google-Smtp-Source: AGHT+IGTSMZYKIH0TeYtxNg3xOg8cg5cbWdRWnDwg6Z5X5N6kUWscY0EAB1d+worwMMhTZexh5N31tzrjdk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d15:b0:6f3:ea4b:d232 with SMTP id
 d2e1a72fcca58-7024765c8f2mr419284b3a.0.1717460193037; Mon, 03 Jun 2024
 17:16:33 -0700 (PDT)
Date: Mon, 3 Jun 2024 17:16:31 -0700
In-Reply-To: <20240429155738.990025-2-alejandro.j.jimenez@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240429155738.990025-1-alejandro.j.jimenez@oracle.com> <20240429155738.990025-2-alejandro.j.jimenez@oracle.com>
Message-ID: <Zl5c3-k0-a7Vvlo5@google.com>
Subject: Re: [PATCH 1/4] KVM: x86: Expose per-vCPU APICv status
From: Sean Christopherson <seanjc@google.com>
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org, 
	suravee.suthikulpanit@amd.com, vashegde@amd.com, mlevitsk@redhat.com, 
	joao.m.martins@oracle.com, boris.ostrovsky@oracle.com, mark.kanda@oracle.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 29, 2024, Alejandro Jimenez wrote:
> Expose the APICv activation status of individual vCPUs via the stats
> subsystem. In special cases a vCPU's APICv can be deactivated/disabled
> even though there are no VM-wide inhibition reasons. The only current
> example of this is AVIC for a vCPU running in nested mode. This type of
> inhibition is not recorded in the VM inhibit reasons or visible in
> current tracepoints.
> 
> Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/lapic.c            | 1 +
>  arch/x86/kvm/x86.c              | 2 ++
>  3 files changed, 4 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1d13e3cd1dc5..12f30cb5c842 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1573,6 +1573,7 @@ struct kvm_vcpu_stat {
>  	u64 preemption_other;
>  	u64 guest_mode;
>  	u64 notify_window_exits;
> +	u64 apicv_active;

Hrm, do we really have no way to effectively symlink stats to internal state?
That seems like a flaw.  It's obviously not the end of the world, but having to
burn 8 bytes per vCPU for boolean stats that are 1:1 reflections of KVM state is
going to be a deterrent for future stats.

>  };
>  
>  struct x86_instruction_info;
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index cf37586f0466..37fe75a5db8c 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2872,6 +2872,7 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
>  	 */
>  	if (enable_apicv) {
>  		apic->apicv_active = true;
> +		vcpu->stat.apicv_active = apic->apicv_active;
>  		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
>  	}
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e9ef1fa4b90b..0451c4c8d731 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -304,6 +304,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>  	STATS_DESC_COUNTER(VCPU, preemption_other),
>  	STATS_DESC_IBOOLEAN(VCPU, guest_mode),
>  	STATS_DESC_COUNTER(VCPU, notify_window_exits),
> +	STATS_DESC_IBOOLEAN(VCPU, apicv_active),
>  };
>  
>  const struct kvm_stats_header kvm_vcpu_stats_header = {
> @@ -10625,6 +10626,7 @@ void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
>  		goto out;
>  
>  	apic->apicv_active = activate;
> +	vcpu->stat.apicv_active = apic->apicv_active;
>  	kvm_apic_update_apicv(vcpu);
>  	static_call(kvm_x86_refresh_apicv_exec_ctrl)(vcpu);
>  
> -- 
> 2.39.3
> 


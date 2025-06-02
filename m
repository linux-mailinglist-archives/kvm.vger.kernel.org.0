Return-Path: <kvm+bounces-48232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B3BEACBDC2
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 01:45:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15F4C1704E9
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 23:45:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A72C1E885A;
	Mon,  2 Jun 2025 23:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="swVWxGjS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A4513D2B2
	for <kvm@vger.kernel.org>; Mon,  2 Jun 2025 23:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748907917; cv=none; b=CKBe1o5/CZjGkQPlRQEXspJt4yFbNgvzzQiG7zM+Lnjzc/wRrUAaZwWBJQSOgolV+oxYvA4jxK6Caaa5NnP/8OBN3eoJiEItNQBuTZZmsyt8R/fykw1eryknNwPBP54Li92O9ano3K9soznW99R8Fb4jSo1WFiYiJMxawAwD+to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748907917; c=relaxed/simple;
	bh=/bWJ2fGp0Et7U/W2JVN+6U5ujNjjLBDXeMSAu0EFhbE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cCNnRRYb3pZj4SNozJ/gK8JiLfse3aRBjaXeJzuXqsijmHajmobl/nlB9uwWy38EeJHsUVaonBEIc0Vc8Wma16W/cjBVUj/C7IP1u6MqsRdoa6tukDqiTM+YOJX8hyaBB4VYgXm1WrWNmTRYvfBbZ/mB59sLyz3aJB9NqgXP+Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=swVWxGjS; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-747d125bb9eso948480b3a.1
        for <kvm@vger.kernel.org>; Mon, 02 Jun 2025 16:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748907915; x=1749512715; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GkQR60PQIrxeQGEctk2O7uEeUdi3LKrDj0MxkXt3OGQ=;
        b=swVWxGjS2pzkKi15+O6ADFSzLBhCHiAVr5JB9c+GW9yqIfb8i+jLgHfTHAaM3vVobH
         OYKXKiCYopBiqjwUTXE0y3cVnhvpAwKp/nkEjcD+5l/U7o1jSjQwwWS2TKBUp2tJqFRK
         P+pkQqIMRdoQ6WBILt9MUNnB7P2VLDd0blk05FC2uyJPvYya48sJjtK3emoLbVyWwh20
         6AnPOHTyuGEwtQgzXSmUCqadYNbmm6zIhYgDNau2Tt11U/tGLEx/EX4N/WEFfBbqRVe6
         a8BeTC7FMftyETw/kBSAiHw/8Eu6mTcgD16eOgsY6tBpvcKrKHQ3K8qhZtc5kYnm3iOG
         v+8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748907915; x=1749512715;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GkQR60PQIrxeQGEctk2O7uEeUdi3LKrDj0MxkXt3OGQ=;
        b=Ze57Zz7zKrVbuQ16h5WuUDmm9HzDi/dKL2IA0r+tvFPd5J0k8aIUW80gS2nk8r9SOp
         SGTJO1rPW46rq9wwVvqaLYWQbG4sSNnvnh93pmttQudMhbyWSDQiMj3inMOaEpa6Vg+a
         lxyL1UOr6RlAtDA4cb5vLpcE514FOfuz+rG3ImKBWWSU8j31dWouWM1bxZEx2l+Yp7yI
         bklgyNqvnsXntUxWt8HiO7Rz6u0v0U2hSJANy8d3IIVBSailnifThsqRlfm8IEg+KoYM
         RAWPxnOM1Pnl/DLa9xWPboco5CeFtd6wJp0xpLrxnhhC7eA77cHvLnUSvlmcICHhtl2R
         /1Vw==
X-Forwarded-Encrypted: i=1; AJvYcCVn08J8Y0pH8cRg5pRK9B0/rkvC0Ep5WxPPLSKfj5ZTZgogfI2aXzl26Q9+mQi8839bRUM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8WEIt0wFw+05ZqRyDgpX3eXP+sT2lyXbZk19m9z76U0XYV8zt
	Zef4wwGYfJcjgIlFiZ+52Sc7oie+K3TSz1s9a3OqfwG82pLDkOgII4i7uRSiDoMikIIwqlhdMZF
	9Bnv3jw==
X-Google-Smtp-Source: AGHT+IEbM7rkSZXQh/W0Dm0Y3uOmV7bU4LP2HEoAjHJ2xpVVJGKMsen91jAMHkuzTnZiPUaHiCrdtEUnDkY=
X-Received: from pfhx4.prod.google.com ([2002:a05:6a00:1884:b0:746:22b3:4c0d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:885:b0:736:54c9:df2c
 with SMTP id d2e1a72fcca58-747c1bfacf3mr16034894b3a.15.1748907915213; Mon, 02
 Jun 2025 16:45:15 -0700 (PDT)
Date: Mon, 2 Jun 2025 16:45:13 -0700
In-Reply-To: <20250529234013.fbxruxq44wpfh5w4@desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523011756.3243624-1-seanjc@google.com> <20250523011756.3243624-4-seanjc@google.com>
 <20250529042710.crjcc76dqpiak4pn@desk> <aDjdagbqcesTcnhc@google.com> <20250529234013.fbxruxq44wpfh5w4@desk>
Message-ID: <aD43icQolCvESIpc@google.com>
Subject: Re: [PATCH 3/5] KVM: VMX: Apply MMIO Stale Data mitigation if KVM
 maps MMIO into the guest
From: Sean Christopherson <seanjc@google.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, May 29, 2025, Pawan Gupta wrote:
> On Thu, May 29, 2025 at 03:19:22PM -0700, Sean Christopherson wrote:
> > On Wed, May 28, 2025, Pawan Gupta wrote:
> > > On Thu, May 22, 2025 at 06:17:54PM -0700, Sean Christopherson wrote:
> > > > @@ -7282,7 +7288,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
> > > >  	if (static_branch_unlikely(&vmx_l1d_should_flush))
> > > >  		vmx_l1d_flush(vcpu);
> > > >  	else if (static_branch_unlikely(&mmio_stale_data_clear) &&
> > > > -		 kvm_arch_has_assigned_device(vcpu->kvm))
> > > > +		 (flags & VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO))
> > > >  		mds_clear_cpu_buffers();
> > > 
> > > I think this also paves way for buffer clear for MDS and MMIO to be done at
> > > a single place. Please let me know if below is feasible:
> > 
> > It's definitely feasible (this thought crossed my mind as well), but because
> > CLEAR_CPU_BUFFERS emits VERW iff X86_FEATURE_CLEAR_CPU_BUF is enabled, the below
> > would do nothing for the MMIO case (either that, or I'm missing something).
> 
> Thats right, CLEAR_CPU_BUFFERS needs rework too.
> 
> > We could obviously rework CLEAR_CPU_BUFFERS, I'm just not sure that's worth the
> > effort at this point.  I'm definitely not opposed to it though.
> 
> My goal with this is to have 2 separate controls for user-kernel and
> guest-host. Such that MDS/TAA/RFDS gets finer controls to only enable
> user-kernel or guest-host mitigation. This would play well with the Attack
> vector series by David:
> 
> https://lore.kernel.org/lkml/20250509162839.3057217-1-david.kaplan@amd.com/
> 
> For now this patch is fine as is. I will send update separately including
> the CLEAR_CPU_BUFFERS rework.

Sounds good.

Ah, and the s/mmio_stale_data_clear/cpu_buf_vm_clear rename already landed for
6.16-rc1, so we don't have to overthink about the ordering with respect to that
change. :-)


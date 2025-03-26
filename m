Return-Path: <kvm+bounces-42081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64C8BA725BC
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 23:42:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C7FE3B2DCC
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 22:42:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AECA264A69;
	Wed, 26 Mar 2025 22:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ka/SXI/x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394CC24EF90
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 22:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743028924; cv=none; b=OXwM/59ZU0zmDn2rB7MoxP3CFjHGzZO8ifDCspc8JcNt6qMoZ3e8TZ9M7t46ndmbsYBZlQssqnj7FNItAvnhHXZRImGPG0GvYv0XMAobRl2bDLG3noHgqd/OWbi61EF+PiK7RSVT1FSvNSEO1met/VSV/SBFPqknabwW0rWcLww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743028924; c=relaxed/simple;
	bh=AbWkigPd0QkLkTgXoysYAH5asAePIGZGp7Nv9IKt5Tg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H6ij1EJVKAXk5l7NnjXPh8kslbzJyQeVEbow7isg3Hr7IdqNHguDdic2TAITIzMCECMpLwPW17VYZd/Fmq9NRUzs4onjTx7zSN2/nxfs7LscD8ayb6Rg246Xvd0ViSIg+gvI95kAbHG6sZMnzOioFtdKcr+lM4cZZ9fTQ1FsQ4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ka/SXI/x; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-225429696a9so9385535ad.1
        for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 15:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743028922; x=1743633722; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KqH3Q2jgpouZEVkOO8Bb1Ojl5Go4pZMng8lP/lx7p2Y=;
        b=Ka/SXI/xn/viMb8FWyvig0p5njgN6FQz+ke7I0cm67nSBfUOcMXXhv6M/KfM7dQb/s
         UCKAdjvG/PxCOKyV6YTJooiuiOIPdv+34wh3T0hLeg8J4u9tHz/8UlYQIzFSYqJH7h6B
         v/TYJAyswFUn1rQXopgeljjkR4ViqcExpLnJ/WJjJ1yjqyNTJr8Qoi2W/SnRYni0huU8
         ylm9MWnV2A0VBWoRsWg4X9SPAPEwArvtvo63EcrQt3dkBUyAG31+1ZD5/vJ/8OPPPSRc
         vghMygky2grJthgjg4VIsz8wx795UI9MGndxEdhv+8fjNtSifE0E1P3+GT9uIA5t9/sG
         hNew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743028922; x=1743633722;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KqH3Q2jgpouZEVkOO8Bb1Ojl5Go4pZMng8lP/lx7p2Y=;
        b=eFQWINAT8jws/CqqlLT6j0wb+LGHuQEkJdkZIsDX9x4X9ybvn9oyVy0tRxjpVfEiXw
         Dw/JB0jffPDI0AV0v3IuiVhyy1PJPxmcOoY5BsZ42szGAAfqZI5sZfd3kJAISIOThq61
         QfHLIRmEDSG+HmIp8NCkgj5LsELvtptzkLjz/hWWzsSeUArRx6aVV+bSAwKPEQayI6pm
         /zyQdWug2iob8ylgGbdIJgJl/x4FQ46LOwJyWLFiqKXdsxY4Dt+u7oNsJI5SMpoa8DF0
         qq/9QnEGb2aieCwRMGXeUny8qGf3OFLCAgiQUpLBlOJBTIsx9XxSW1ZP88XRnA62wCek
         S1hQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJgiogTxq2LsyURUbZBpXVwb04zbTo+j0Gl+6j+Ntg2bkCjtBuGn2U8EtNiK8TLv1AdvQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUBn7SR+jhzVs2duPfNYQMjuFXOMYdHmkKUlDPlLEhGhGFYBqC
	U3ROMv+OKGtOT9QdUHPN7tuNFScMrOa5eUn4FUU/ZeTQS5fwISKvrsrEdikTAB2SgszWul4p4kL
	r+Q==
X-Google-Smtp-Source: AGHT+IE7jpn3hz0DvE2VgEstnENVTCX8dh1jBNBDLDNRPJuJX01TLo3BnVQahHmZrbhz36uFKjKUTDhpYUk=
X-Received: from pfbfa14.prod.google.com ([2002:a05:6a00:2d0e:b0:730:7485:6b59])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce02:b0:224:1acc:14db
 with SMTP id d9443c01a7336-22804882b2fmr22534895ad.29.1743028922455; Wed, 26
 Mar 2025 15:42:02 -0700 (PDT)
Date: Wed, 26 Mar 2025 15:42:00 -0700
In-Reply-To: <Z-R8xRbsjv4lalAX@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250320013759.3965869-1-yosry.ahmed@linux.dev>
 <Z-RnjKsXPwNWKsKU@google.com> <Z-R8xRbsjv4lalAX@google.com>
Message-ID: <Z-SCuESxIaOR0bCw@google.com>
Subject: Re: [PATCH] KVM: x86: Unify cross-vCPU IBPB
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Mar 26, 2025, Yosry Ahmed wrote:
> On Wed, Mar 26, 2025 at 01:46:04PM -0700, Sean Christopherson wrote:
> > > @@ -12367,10 +12381,13 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
> > >  
> > >  void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
> > >  {
> > > -	int idx;
> > > +	int idx, cpu;
> > >  
> > >  	kvmclock_reset(vcpu);
> > >  
> > > +	for_each_possible_cpu(cpu)
> > > +		cmpxchg(per_cpu_ptr(&last_vcpu, cpu), vcpu, NULL);
> > 
> > It's definitely worth keeping a version of SVM's comment to explaining the cross-CPU
> > nullification.
> 
> Good idea. Should I send a new version or will you take care of this as
> well while applying?

I'll fixup when applying.


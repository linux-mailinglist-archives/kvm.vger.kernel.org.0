Return-Path: <kvm+bounces-49910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6856CADF8B7
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 23:24:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10D5C177708
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 21:24:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 941FD27E065;
	Wed, 18 Jun 2025 21:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KpfQHxvS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C7E27AC36
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 21:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750281851; cv=none; b=gwXXyZNdK7HCNB67JBe/2jHt3c6f+BVq9F8aWSXRceoT0mQ8KemRh712Z4u9vkzJ/QJZFVRhwT8Zk29KkWaGncIqh38LNi58SiqyAgz6s9RCv4Ysqa7+VPIq9js1sstXq8RA/7I8Jl+IJvFulI9EAUPZkJHHuV5sKSLjnrCDtcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750281851; c=relaxed/simple;
	bh=daJuqZ6CPc2F4BEIINq8WQRI1vxk2F7eTh7TD4lJ1IM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=docVNmiWN/llmPHRO6gYrW02mO+zTQbe1541odMdl3TyMUr9M7DfSRWMyDNpIzDbpna2Ea+K2U9xqtHgcpwwVPxFJ5b8nKeY8xMOxGrZ50WhOAK1J0+U3faBDr0yD2q6LkgfPwLXMPOTE43kWcQWEvpovz1A2Rumxq8HFKdPI4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KpfQHxvS; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-234dbbc4899so2067655ad.2
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 14:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750281849; x=1750886649; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gmjcv+c3SYJdbUPkQIE63QBOpY1Ll5uaHYh2Mm3xcqk=;
        b=KpfQHxvS2KWBwwQGxvVwN91DcOQnTcce2kjHFgDZFN5Q7xbRGtmJbkxiqYqxcOzgNO
         ZkPjqdEgeK+qwGVPrqnlXo8VgAoaORtVHmsB9ZFx5qUpWVOwGoxdm3jai0Op1sZ6WK4a
         yrVuWnnle3ZcGsqQUPWKw2/52jSK3yLjkqOkX6z3Qv/aEIwy1+wkGZNkP1kfSs0VARU5
         4xKbKC4Rw289ZZW/61RwoOIZkWm2xwY4ZLdeeu6uGryCGeJ+fDBZCdAWsT5wxZsPX7+Y
         PivyautqylevIFmfYjFLhyi3piTUuv+XRVu/E9lOsi3kd9PAYgj5n9FTCMxrqoMTVxyw
         42XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750281849; x=1750886649;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gmjcv+c3SYJdbUPkQIE63QBOpY1Ll5uaHYh2Mm3xcqk=;
        b=vE5CG/1aNNpuTycbMC4yNmPSvqh1JobwF7jkS3cZ+jRTIS0O+tMaQ2KTf5Q5GsAX+T
         gcWPovHKP7oNNtdhr4wKo2kYWIAsXppWxj7CyhTE512/6+8wMpe3DaxKtOyIyksRpDOQ
         ZTOLfXRJwe1qKzztOLg1VB30VmNf36LfSz99MNDwMwPLjtfY/zJ/EgyAy9RTjTmt6GQb
         06i6NL2FmiNR8THZTraAD8daTw86cgxxJjl18kInhtDQVd7VLSxnGIyJbKZJRFJdD4O9
         xj8LWOcTlw1Li6y1dShsZkisBa4owbsyY97GFwK36erX8mgCu4m7ucXwwcI0aMyoU7Jm
         hqrg==
X-Forwarded-Encrypted: i=1; AJvYcCUsOCO5eRxcvPKCe2Hs0r7kbpqLWsca8xs8Wts2U4PRiojZ5NyN2CEw/q9jdmjKSpzYKP4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzp9SU9D0Wg2zY47hoqW4/BwpPtSMMJsJ2IHNKmU39m4gCzIdZk
	u4NmbfvXhK7LN36VneTJi/sAuulEA5HMrrYtyethCbRoSvS5H5+/B7vEmalr9uJ8oeUzvwKdmae
	NtRsD2A==
X-Google-Smtp-Source: AGHT+IHYIRVe1M5MEtH4NPGJJPhQYabXBPFOaU9D4Tvr+HcI9dmkyP50P9RhAXSp4MSHU2XdPzmLxQcHX2E=
X-Received: from plgk10.prod.google.com ([2002:a17:902:ce0a:b0:234:8c63:ac2b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:708a:b0:236:6f43:7051
 with SMTP id d9443c01a7336-2366f4372d9mr206207245ad.23.1750281848728; Wed, 18
 Jun 2025 14:24:08 -0700 (PDT)
Date: Wed, 18 Jun 2025 14:24:07 -0700
In-Reply-To: <25896236-de8d-4bd9-8a27-da407c0e5a38@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250617073234.1020644-1-xin@zytor.com> <20250617073234.1020644-2-xin@zytor.com>
 <fa32b6e9-b087-495a-acf1-a28cfed7e28a@intel.com> <aFHUZh6koJyVi3p-@google.com>
 <25896236-de8d-4bd9-8a27-da407c0e5a38@zytor.com>
Message-ID: <aFMudwy2uO5V8vM5@google.com>
Subject: Re: [PATCH v2 1/2] x86/traps: Initialize DR6 by writing its
 architectural reset value
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: Sohil Mehta <sohil.mehta@intel.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	pbonzini@redhat.com, peterz@infradead.org, brgerst@gmail.com, 
	tony.luck@intel.com, fenghuay@nvidia.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 17, 2025, Xin Li wrote:
> On 6/17/2025 1:47 PM, Sean Christopherson wrote:
> > On Tue, Jun 17, 2025, Sohil Mehta wrote:
> > Note, DR6_VOLATILE and DR6_FIXED_1 aren't necessarily aligned with the current
> > architectural definitions (I haven't actually checked),
> 
> I'm not sure what do you mean by "architectural definitions" here.

I was trying to say that there may be bits that have been defined in the SDM,
but are not yet makred as "supported" in DR6_VOLATILE, i.e. that are "incorrectly"
marked as DR6_FIXED_1 (in quotes, because from KVM's perspective, the bits *are*
fixed-1, for the guest).
 
> However because zeroing DR6 leads to different DR6 values depending on
> whether the CPU supports BLD:
> 
>   1) On CPUs with BLD support, DR6 becomes 0xFFFF07F0 (bit 11, DR6.BLD,
>      is cleared).
> 
>   2) On CPUs without BLD, DR6 becomes 0xFFFF0FF0.
> 
> DR6_FIXED_1, if it is still defined to include all bits that can't be
> cleared, is a constant value only on a *specific* CPU architecture,
> i.e., it is not a constant value on all CPU implementations.
> 
> 
> > rather they are KVM's
> > view of the world, i.e. what KVM supports from a virtualization perspective.
> 
> So KVM probably should expose the fixed 1s in DR6 to the guest depending on
> which features, such as BLD or RTM, are enabled and visible to the
> guest or not?
> 
> (Sorry I haven't looked into how the macro DR6_FIXED_1 is used in KVM,
> maybe it's already used in such a way)

Yep, that's exactly what KVM does.  DR6_FIXED_1 is the set of bits that KVM
doesn't yet support for *any* guest.  The per-vCPU set of a fixed-1 bits starts
with DR6_FIXED_1, and adds in bits for features that aren't supported/exposed
to the guest. 

static u64 kvm_dr6_fixed(struct kvm_vcpu *vcpu)
{
	u64 fixed = DR6_FIXED_1;

	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_RTM))
		fixed |= DR6_RTM;

	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
		fixed |= DR6_BUS_LOCK;
	return fixed;
}


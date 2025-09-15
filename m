Return-Path: <kvm+bounces-57596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A8C8B58224
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 18:33:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4FEA91B237E5
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 16:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B88902820BA;
	Mon, 15 Sep 2025 16:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fqOfP2ao"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E41F25DD0C
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 16:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757953837; cv=none; b=QhUqj4oVccMUF/pidUFmm3uzz57s8h543EUyaW2VX9VvncB3Y6chhxtUbssocp4mz91aqo0Yk89Gkqqby9RW/aIRkiTmtwUcXsnVa10qrDfCMGtiOWSOGDm7vNyo9om34KwW4uyWFnu7TnLopeeO3+/EwfYEEsSvZlrMT2tu19Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757953837; c=relaxed/simple;
	bh=CFuk7p0gYmvjheDBaCcBj5JW9s9VfhRn+FBRgAKCg80=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EElFMEISjB2khiOHw4yRM/bZq0Is4/q/8L2hyj36HVIDFifxedfHD+RTKMz04SsB0EErKybsOrej5kBLVz/qYV4BMIBlb7QIW4gFWxumReB9PiTDxvzWNgwZ7+g5ECRngN4pynsh/DAVjl3KsL1kyqpATV7iLdpzUxRyOeMZRQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fqOfP2ao; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32e0b0014d9so1926639a91.1
        for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 09:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757953836; x=1758558636; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xf+MJbtji9F8Tz6GB0t2vzLknwLGaxjinPqLZ43Jkxc=;
        b=fqOfP2aoDsSSBysqN48AMz/RhLY0/289WrCf/xlHtWrDy8jIB+esV0X1SIf8OEut1y
         lXRdboa4glIM1WscdajyUmTaqcH/F8kev8hYDV4/C4jCxbpqinc+h1OwovLR4lMG88BU
         ob9RlqMvXQ4vKZfedVE2Tyn3siG4N/yTFQA7FcUCXyl2+965OK70pybIsyrk/un+HbAa
         Rn+AEiwUm38X3YRkxwbV8RWZCHL90B25KYSEjNE0yMLIBL5D3klpW/wO/9lNiMpRJRhY
         JRu/Bu0U8+Ajl6A/8DwzS28PQe4Ne7aUbTEzG84iwRFu9VOgP4M6961fvfmsNDSdaF0A
         r88Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757953836; x=1758558636;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xf+MJbtji9F8Tz6GB0t2vzLknwLGaxjinPqLZ43Jkxc=;
        b=jgdKkhodvUU6Im8JduXm7VPOy4iQW5+aeXlDDIQW0IbON7NEc2Xm5DkfG0up+zaNbO
         vmcHkxm9e9PXuYRxuahIj06Pw3j00XMzYmJ469bH/SxD6Paa57psYW7DkzM3cM2u/gTv
         vD3DHSpHlgvwakkzmZcwRk+0kBAHLskLArQGosLlwSs4Un+r/HrPO5igohCzDDmYdpJh
         yY89I5kHOVM+kpLkoGtnbXhPLfqrVXdKoea3XWZ3jfB3hdLv4Nt98C4+hy1tr5ka+gR3
         GVQeA3CGxoJ59e/o0CGx9l1zYRWGSXyYEGIYlVcIRYUaZ8b2uDD9ZXQrOLFrsvksio5E
         /GCg==
X-Forwarded-Encrypted: i=1; AJvYcCXWrmEkdzivNWlYH/0036cbv/FcOoJZxuXvldjKhBzEQxJ7ovirV5AshEhR63V5E0tZDMo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDQ4haW0SQVaXDiW/L9m+mJgFLV7+HvFt8NT0Wqz/UsqyBUfne
	oRKgaLGbDhKCggkQIITD9Oqxq0n+vpoC9KdR0p3/PqNAZ6ymswZt9SadSw+XQNRjls9spZnTSHX
	svbTtWA==
X-Google-Smtp-Source: AGHT+IGhlRWQoda3fzV/RX3qXsjvU1RPv/NIgSnh5mqzrKEW4awlCudfKDQb1DLquUci59qND0BWZWg+/FE=
X-Received: from pjbsi2.prod.google.com ([2002:a17:90b:5282:b0:32b:61c4:e48b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b4c:b0:32e:3c57:8a9d
 with SMTP id 98e67ed59e1d1-32e3c57a4afmr5948385a91.30.1757953835624; Mon, 15
 Sep 2025 09:30:35 -0700 (PDT)
Date: Mon, 15 Sep 2025 09:30:34 -0700
In-Reply-To: <72a65866-fecd-5106-17bc-115ba60e67ae@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com> <20250912232319.429659-2-seanjc@google.com>
 <72a65866-fecd-5106-17bc-115ba60e67ae@amd.com>
Message-ID: <aMg_KownKheaKeCZ@google.com>
Subject: Re: [PATCH v15 01/41] KVM: SEV: Rename kvm_ghcb_get_sw_exit_code() to kvm_get_cached_sw_exit_code()
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 15, 2025, Tom Lendacky wrote:
> On 9/12/25 18:22, Sean Christopherson wrote:
> > Rename kvm_ghcb_get_sw_exit_code() to kvm_get_cached_sw_exit_code() to make
> > it clear that KVM is getting the cached value, not reading directly from
> > the guest-controlled GHCB.  More importantly, vacating
> > kvm_ghcb_get_sw_exit_code() will allow adding a KVM-specific macro-built
> > kvm_ghcb_get_##field() helper to read values from the GHCB.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Makes me wonder if we want to create kvm_get_cached_sw_exit_info_{1,2}
> routines rather than referencing control->exit_info_{1,2} directly?

I think I'd prefer to avoid creating more wrappers?  I generally don't like having
wrappers for accessing a single field, especially an architecturally defined field,
because I don't like having to bounce through extra layers to understand what's
going on.

But for the GHCB wrappers, they're a necessary evil due to the associated valid
bits and the volatility (guest-writable) of the fields.  For the "cached" fields,
I don't think we need a wrappers; providing a helper to splice the two exit code
fields together is helpful, but accessing the control area directly for "simple"
cases feels very natural to me since that's how KVM works for "normal" VMs.


Return-Path: <kvm+bounces-58572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE9C7B96CF5
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 18:24:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BA4C446348
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DF3A326D58;
	Tue, 23 Sep 2025 16:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P4plPh5U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440FA322C9C
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 16:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758644645; cv=none; b=RzW9Vhgan2cSR5KIeey7uBGpAupLENl2LN5r8nlSHw7bnUrytRVY9EelWfKD1+9j/SzJp+rYi+WKekl8R6tGV4BTnl16MdWntUy1kcGYcDG206cmMWqEIiRBI9uF9MiybU3rjP1SphCc4z20OafobwbFhyPDQDaOp/FnbMVMjC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758644645; c=relaxed/simple;
	bh=agu8t+GtnRdTt7ziIGD3+jvwpGAKVQuk0ov+fLZVyEU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cnOHYtypv9VjgFazcF6vmpfswABKz6FUQtmUsEdtUZP03TbWo6dZ/0zN0yR2nYqxI7JfO67mf3vHbZWCCdHlJxf68OUiFUAUPXqc54l+CKYsq+03sWnT8H2W/AT+1M91d0ZxEePSbUU+5SekZgNi4nzxPVqxQu9LnUyKm4j/puM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P4plPh5U; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2698b5fbe5bso70795405ad.0
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 09:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758644644; x=1759249444; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6ct6l4fU3rAG1+iOUtrDMwT6jHIL6tdfk6HjiAM8alg=;
        b=P4plPh5Uw0e+SMFwnpm/PlDtg1fkG+n4tWPgLDKrVbTVmPeqmtIw4rqHwcDIyl3LxA
         lA6j3QpZPjCPxzLjMr3EecfVucXGuxvIhYRrjqIsuDzR3a7oEbR7fsTTr9oJmwOyaUcN
         2QsTl+y7OLnZTtXtQWv+47tnUTmaBsRpLZThOAYcG3LPtlku95xhYX3AehoHRJu3p6dB
         XjrAvSyL2I6HoiR7eRKTDivHC66Rk9ozycrk/DOJ4GidO/yyS0Fwg79wkJm0F0/Ww/VU
         n/kMJ28L/FpZOjujIx7jaeJzJxd8vveHS6GRAynbPfp/kfbEq8tYvD6tgpQy5kdoAvTI
         CqBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758644644; x=1759249444;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6ct6l4fU3rAG1+iOUtrDMwT6jHIL6tdfk6HjiAM8alg=;
        b=FCIQ2OFT7rYD9Rs0uiIcQVOXmZ9GGPrpjulqCN3ZjRa0PGV/mnj1mPYhaFU/yTBohO
         F+OGXVoIqodF5OnyZpEuV10GrSelRKlwB2VcRFWE79u6Dbooc8Z8q2GrkkqdINSQA6si
         rsgkOuHrXZr/AzN3D9KaA44JoNdpA56JGj6s1X9UWWzlp7L2sUtX9qStIq1YMpnvE4/Y
         277poilqI5McQK/60rI5UXhWgeHs3gXTY3784YCtaeF7FLjs2XZwH56hmhQq2/YkquTw
         Ry/dReZKBpgpIbnQIEIvRBxscqUciR+/gsgqn/RIwRwe1Vnsu9Ax6pO5MshtqdTjXOQT
         jItw==
X-Forwarded-Encrypted: i=1; AJvYcCVpRahxj9hW9kUO/y57aAVFV+ulaY7+5tj4jnVL8qUtoPUFniAk186rKWse+0/RUiVVEM4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMlInGMjifoNNIA5VAovyaUIx6+iaZKcukNtxxtaKC4P/oVKmU
	f/+C0ic6BJAAmjsuqlFVdP6xcksG+iufZWyq2AE5kLMwQ+nQd6CwTtkAU64PrXMxKgVOhdrXfXb
	IcAMt4Q==
X-Google-Smtp-Source: AGHT+IEHue5KcLk/QqnBm3y2Ig9Ta51qNFW7n2QuwkMnly9TqOobukS1vav1nBv/4Yz6svZXoVmoDEzQJWA=
X-Received: from plbkf5.prod.google.com ([2002:a17:903:5c5:b0:269:b2a5:8823])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c94d:b0:268:1623:f8ce
 with SMTP id d9443c01a7336-27cc1572011mr36976535ad.10.1758644643566; Tue, 23
 Sep 2025 09:24:03 -0700 (PDT)
Date: Tue, 23 Sep 2025 09:24:02 -0700
In-Reply-To: <aNIH/ozYmopOuCui@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com> <20250919223258.1604852-30-seanjc@google.com>
 <aNIH/ozYmopOuCui@intel.com>
Message-ID: <aNLJosN_1gZ7z4VF@google.com>
Subject: Re: [PATCH v16 29/51] KVM: VMX: Configure nested capabilities after
 CPU capabilities
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 23, 2025, Chao Gao wrote:
> On Fri, Sep 19, 2025 at 03:32:36PM -0700, Sean Christopherson wrote:
> >Swap the order between configuring nested VMX capabilities and base CPU
> >capabilities, so that nested VMX support can be conditioned on core KVM
> >support, e.g. to allow conditioning support for LOAD_CET_STATE on the
> >presence of IBT or SHSTK.  Because the sanity checks on nested VMX config
> >performed by vmx_check_processor_compat() run _after_ vmx_hardware_setup(),
> >any use of kvm_cpu_cap_has() when configuring nested VMX support will lead
> >to failures in vmx_check_processor_compat().
> >
> >While swapping the order of two (or more) configuration flows can lead to
> >a game of whack-a-mole, in this case nested support inarguably should be
> >done after base support.  KVM should never condition base support on nested
> >support, because nested support is fully optional, while obviously it's
> >desirable to condition nested support on base support.  And there's zero
> >evidence the current ordering was intentional, e.g. commit 66a6950f9995
> >("KVM: x86: Introduce kvm_cpu_caps to replace runtime CPUID masking")
> >likely placed the call to kvm_set_cpu_caps() after nested setup because it
> >looked pretty.
> >
> >Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> 
> I had a feeling I'd seen this patch before :). After some searching in lore, I
> tracked it down:
> https://lore.kernel.org/kvm/20241001050110.3643764-22-xin@zytor.com/

Gah, sorry Xin :-/


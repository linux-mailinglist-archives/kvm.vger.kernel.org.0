Return-Path: <kvm+bounces-34004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D41D29F5A48
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 00:19:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC0C2170390
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 23:18:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6D881FA15E;
	Tue, 17 Dec 2024 23:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BY7DqVLu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740C51E009A
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 23:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734477485; cv=none; b=ZrYGJ35sgy3bGmVOZ0wxPME0tk7ZiSlrreE+ld1tyv6R3jDyn6eUjtSgVJKqdkluoAlT0tRg+pmDF3uMIIL9ebrhN3qCDfrKubCbYY7QrYNFKOmQ3wS10n3ASRetPbIX8nM1rKDXajzWmBdbOMhFsR4rgSs/4PsiZYUS5+D1PkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734477485; c=relaxed/simple;
	bh=M5k3Exlvy+Z9IXu7g56nb3TsziUT9WlV7DCz/NejfSY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cBlotbcQEH4fAtbgp66JryV0UJe9Lk/nJRsICD5+UmqP/VZnYPLXZZ/VJYq1VVgT2F71SsE4kGPuEOY8y2UZTbo05h54is6vDPTVz1zL38teo088zoWlokn0VvxP1u51LgmeLWDO+J8lxcfB7wjcgeH6w9CDPGuC+bXBK4vAC1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BY7DqVLu; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7f3e30a441aso3451026a12.2
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 15:18:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734477484; x=1735082284; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=naA0GS7O9MRP2hOdk2vwqVHkMvuTHqJo1r7836lObN8=;
        b=BY7DqVLuQS/e7u4oGULwch/2Wp/U/JNPZRE07g6/54zzKC/HKcBKXFQQgVV0Nnyw9i
         NOT9FLSqi6PCUt+czs4dy7rLswYexqYkor+YLxc8u5PNNwg4NLv2DnuuJxy8dreqwtm2
         g/C2/EOpu4mHU+/s7pwn2fJVgKlbOfmx98DGlIQlzNFYJIlt26pB0DlB24BQF3Tgo29L
         f4U1NfUN2s5JQch+2zSwJSyz47OHYgo/H+WaadnGEkNEV2HaxkAsseFi/niLkng5+0ld
         1SbVeuy/5ZgKcJEri2vg9jG4lIiObOHXE/kl6LHfO4nhr1ri0bV0H3/agL4AswEO3rj1
         K5PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734477484; x=1735082284;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=naA0GS7O9MRP2hOdk2vwqVHkMvuTHqJo1r7836lObN8=;
        b=Mzm9bdMqOjdeqsifhyGR8Dd1xAewELa+o1IAdlUU25mFdFgbK4jB6/LeOltAklY+Nx
         sZlk+x2A0xNU7O/Bg8P2ncWpaD+oonX5vSf6rVWL/be4if+CqO8qpZo5/Z1C8d1bed0S
         ABG3uCRIIDPw8sHyijPc0y/30ZyTgiKOAEcfl8C7sljWh7ZVC52h0m5v2e7We7Yps0Pc
         6hbr6lLHs5AAV3NN/6yIdxcvnazcpUL31hGRhN+u9+RGqdmtnvEukXLNQjQqIN+GGagE
         97ID6WxIraLju/7V1joLgPTAAUIWT9hYOSQFWgzNYrQhGRtgvvHE03CV+kI5sBn0uSAr
         ESmg==
X-Gm-Message-State: AOJu0YyIyB3Y+lUnYD7wLiuQvN0H/Z3l7oo/uz44tBiWfXbQ9LQH4Jok
	p3x9CfhMFRjkZARzt4YGsBeTmdoR6mAgzaTqhA6etr+jFNRImpPDcyN8JY5d0b7mEZU0zLcf/AJ
	jfQ==
X-Google-Smtp-Source: AGHT+IErV2J5PTEoSyi0d0E7MOnq9fBwjJIGDBkNFHzQboTvZJtvLQ1vXvJn5Z7f9ymcQ3Ib2PGYukmFjHs=
X-Received: from pgmp26.prod.google.com ([2002:a63:1e5a:0:b0:7fd:4c8f:e6a1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:1013:b0:1dc:c19c:b7b0
 with SMTP id adf61e73a8af0-1e5b487dfbbmr1410079637.33.1734477483759; Tue, 17
 Dec 2024 15:18:03 -0800 (PST)
Date: Tue, 17 Dec 2024 15:18:02 -0800
In-Reply-To: <de7bc23ec1e40ad880c053f884200b4870e18986.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241112073327.21979-1-yan.y.zhao@intel.com> <20241121115139.26338-1-yan.y.zhao@intel.com>
 <de7bc23ec1e40ad880c053f884200b4870e18986.camel@intel.com>
Message-ID: <Z2IGaW6q520PxWo-@google.com>
Subject: Re: [RFC PATCH 0/2] SEPT SEAMCALL retry proposal
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "x86@kernel.org" <x86@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Tony Lindgren <tony.lindgren@intel.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Kai Huang <kai.huang@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Dec 17, 2024, Rick P Edgecombe wrote:
> On Thu, 2024-11-21 at 19:51 +0800, Yan Zhao wrote:
> > This SEPT SEAMCALL retry proposal aims to remove patch
> > "[HACK] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with operand SEPT"
> > [1] at the tail of v2 series "TDX MMU Part 2".
> 
> We discussed this on the PUCK call. A couple alternatives were considered:
>  - Avoiding 0-step. To handle signals kicking to userspace we could try to add
> code to generate synthetic EPT violations if KVM thinks the 0-step mitigation
> might be active (i.e. the fault was not resolved). The consensus was that this
> would be continuing battle and possibly impossible due normal guest behavior
> triggering the mitigation. 

Specifically, the TDX Module takes its write-lock if the guest takes EPT
violations exits on the same RIP 6 times, i.e. detects forward progress based
purely on the RIP at entry vs. exit.  So a guest that is touching memory in a
loop could trigger zero-step checking even if KVM promptly fixes every EPT
violation.

>  - Pre-faulting all S-EPT, such that contention with AUG won't happen. The
> discussion was that this would only be a temporary solution as the MMU
> operations get more complicated (huge pages, etc). Also there is also
> private/shared conversions and memory hotplug already.
> 
> So we will proceed with this kick+lock+retry solution. The reasoning is to
> optimize for the normal non-contention path, without having an overly
> complicated solution for KVM.
> 
> In all the branch commotion recently, these patches fell out of our dev branch.
> So we just recently integrated then into a 6.13 kvm-coco-queue based branch. We
> need to perform some regression tests based on 6.13 TDP MMU changes. Assuming no
> issues, we can post the 6.13 rebase to included in kvm-coco-queue with
> instructions on which patches to remove from kvm-coco-queue (i.e. the 16
> retries).
> 
> 
> We also briefly touched on the TDX module behavior where guest operations can
> lock NP PTEs. The kick solution doesn't require changing this functionally, but
> it should still be done to help with debugging issues related to KVM's
> contention solution.

And so that KVM developers don't have to deal with customer escalations due to
performance issues caused by known flaws in the TDX module.

> 
> Thanks all for the discussion!


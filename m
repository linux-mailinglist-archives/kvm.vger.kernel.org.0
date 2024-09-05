Return-Path: <kvm+bounces-25917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 18DDA96CBDF
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 02:38:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C187F1F24020
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 00:38:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2093B661;
	Thu,  5 Sep 2024 00:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lh835aTQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A723F4C80
	for <kvm@vger.kernel.org>; Thu,  5 Sep 2024 00:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725496661; cv=none; b=E6/KmOWqCuk/EMxZcQCL7zO9YMpprJCjs9f8GV1Tn8BKziZTdldeOISK4Oyg0hrgkamuXkm9AVyn0ra/Xp6rzgShnlHtA1s750sK8P8Evtwe7shj3A7/iBkvDh3LO3ZdL+Dw0wSODeO3eE25Ri5Ehnh1z81kmMtXPAlfdazWQ1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725496661; c=relaxed/simple;
	bh=1mR/XizSAffZYNSQEEdkk+e/3GZP2oBbIepU2NDLsOk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KMHvWPSEIigxrsYed/9RCpNK3h/fVHJbJjbeTX3Jb1lQB9moMZZ6Vtur3F3LzTt+Xd2fWX7dzqXIls9Kg0RXiXdrRZTn2x5yb1ENmWK9OeaT4hBJ6mO5fx+2T5kwqugjYRVlWwTaY4YC9qnNzf906RMdeMnFGCRE3RChfpAg26c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lh835aTQ; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6d34c57a88eso4514717b3.0
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2024 17:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725496658; x=1726101458; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rITaPZ6UiIfPp2fHeRO7mrGcOK1zaJwQGYZJffIWCQM=;
        b=lh835aTQLVYnfooRvnZGnhUBQOwedxO3yPMBfuIksJsxdFjlEsrFi+3TL2F8etkHWP
         sekHPQ1UWJl5ZgSCFyKUFTvrazchEb/myRUVq/AlwNMSOWzTqMOwuTFREnonElQO9CIT
         nk5H9wqXGCzawS+3wUHxPZBejBdWPHe1fWEtIiq2G6l8DYRxACzLbacFoxXBrV5Lcd6E
         kZxe7AHrvg7ZiTItiXNrEIsddFHSRypaMN/b/eHypj819TW8ZfxAVZaArWx7l2F6tjsW
         m46X+v9WwrPgvYHjhqs7yJ8WTUuxhriSbPaFgzOt9YwvTdn5wK2ieC494tArcXzVIpyD
         oeYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725496658; x=1726101458;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rITaPZ6UiIfPp2fHeRO7mrGcOK1zaJwQGYZJffIWCQM=;
        b=Rr7Cf7tjbNZiLi6BVK1R6sCpJ/ENL0jh9QTqsHQTfMWKZQFheRGu/XpOl1n+QxXd5n
         J5X8CLj5SiHchh7Fq+3WwAOCnFwGnst2JBfPwa/IVYPyO9phkjWywTD2iAJ88Eyj9clu
         rqVyVDPv30NlEnxC63YXSnVCWuOV/TDhsM2WkJt3PxbJ76/iBSUdm2pph5ZIRpj+hrpu
         zljr0Q4tXtEe7SP34OytiIu6KqvnZ1dFLtQzhEu3LTNK7TxZ/ngAaDBmu0BpINeEWVkp
         2M5PwdHg6zVKOVBSxRrEsW9dbJne5zpRlwGT584JLbwcWxyllIUD8hp09DQhgTLIeADW
         xdPA==
X-Forwarded-Encrypted: i=1; AJvYcCUVesEuqrHeRmdFQlAbfSRhD9O1wea16urD/ZcPKfTdSVoFTYiEEH6QoO09AxOVpzHN0ys=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmOOj1cVgWVCRCe+oX2t3Db3bUxeYvtwNOTj60SnnvwEAn1DT3
	yUlzwzs9/3Vc00H90BvPsicenciC84NkmEMBRkvz9wbUYxDBbxz9bM32/z0n1hIRh95b4B+EQ4l
	62A==
X-Google-Smtp-Source: AGHT+IHZC2XEUb4ioXVclZSCIgL52vTvgN4+uCKL3WqleD2oGabBDGzuOf4WyNZ3NKKyBu2IMNs8Km12CZs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:8:0:b0:e11:584c:76e2 with SMTP id
 3f1490d57ef6-e1a79fdbf1cmr88878276.2.1725496658533; Wed, 04 Sep 2024 17:37:38
 -0700 (PDT)
Date: Wed, 4 Sep 2024 17:37:37 -0700
In-Reply-To: <Ztjj8xrWMzzrlbtM@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240720000138.3027780-1-seanjc@google.com> <20240720000138.3027780-2-seanjc@google.com>
 <20240904210830.GA1229985@thelio-3990X> <Ztjj8xrWMzzrlbtM@google.com>
Message-ID: <Ztj9UWc_K5qRTiUy@google.com>
Subject: Re: [PATCH 1/6] KVM: nVMX: Get to-be-acknowledge IRQ for nested
 VM-Exit at injection site
From: Sean Christopherson <seanjc@google.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Zeng Guang <guang.zeng@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Sep 04, 2024, Sean Christopherson wrote:
> On Wed, Sep 04, 2024, Nathan Chancellor wrote:
> > I bisected (log below) an issue with starting a nested guest that
> > appears on two of my newer Intel test machines (but not a somewhat old
> > laptop) when this change as commit 6f373f4d941b ("KVM: nVMX: Get
> > to-be-acknowledge IRQ for nested VM-Exit at injection site") in -next is
> > present in the host kernel.
> > 
> > I start a virtual machine with a full distribution using QEMU then start
> > a nested virtual machine using QEMU with the same kernel and a much
> > simpler Buildroot initrd, just to test the ability to run a nested
> > guest. After this change, starting a nested guest results in no output
> > from the nested guest and eventually the first guest restarts, sometimes
> > printing a lockup message that appears to be caused from qemu-system-x86
> 
> *sigh*
> 
> It's not you, it's me.
> 
> I just bisected hangs in my nested setup to this same commit.  Apparently, I
> completely and utterly failed at testing.
> 
> There isn't that much going on here, so knock wood, getting a root cause shouldn't
> be terribly difficult.

Well fudge.  My attempt to avoid splitting kvm_get_apic_interrupt() and exposing
more lapic.c internals to nested VMX failed spectaculary.

Hiding down in apic_set_isr() is a call to hwapic_isr_update(), which updates
vmcs.GUEST_INTERRUPT_STATUS.SVI to mirror the highest vector in the virtual APIC's
ISR.  On a nested VM-Exit due to a IRQ, that update is supposed to hit vmcs01.
By moving the call to kvm_get_apic_interrupt() out of nested_vmx_vmexit(), that
update hits vmcs02 instead, and things go downhill from there.

The obvious/easy solution is to split kvm_get_apic_interrupt() so that nVMX can
find an interrupt, emulate nested VM-Exit or posted interrupt processing as
appropriate, and _then_ ACK the IRQ (if a VM-Exit was synthesized).  It's not
really any harder than what I did here, as above I just didn't want to split
kvm_get_apic_interrupt().  But I don't see any sane alternative, and in the end
it's not any worse than plumbing the notification vector into kvm_get_apic_interrupt();
either way, we're bleeding implementation details between common x86 code and
nVMX.

Luckily, this series is sitting at the top of `kvm-x86 vmx` (yay, topic branches!),
so I'll just drop the entire series and post a full v2.  Unless I botched this
new version too (haven't tested yet), I should get v2 posted tomorrow.

Sorry for pushing garbage, this should never have been posted, let alone gotten
applied to -next.


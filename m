Return-Path: <kvm+bounces-35298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E43DA0BC58
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 16:44:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 143F516581F
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 15:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3894214B08E;
	Mon, 13 Jan 2025 15:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pU1+WiSs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD2224023E
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 15:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736783072; cv=none; b=FK12koYK+zkJ8TVXTL/nlc8xWFu+8EB6uxaCD4gFcyTrnZk+VW6PnpQ7iqYCrYwa7+swVCavFNnuVG+w0hLlk1nWgpTfbyTpKrg9G0+oMqZdksfaEE4ug7aGSok9F79CUDVG93U06cBYgDqgZw7TN1Uf+p4CnYDTGCiChBRUhYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736783072; c=relaxed/simple;
	bh=84zIr5M6ISgHg97pFPOGD6Qiet1HFyiciIYEmNWPsFs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Kk3cxm0SHQR+04g9eAdQaivfVmrux2Q7pH+hypkF43u5m0AdM7sM5h5bIVNs3P8FXpeOsYfy5RZAXnFUvMutsCc/vxUsQYYACcUx3vHbxzYRTibynwDoTAXBdYgC8x3eozxwmqde3/oSDLpUmx3KS9zRvFrhFN8Wdlma1UPToeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pU1+WiSs; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2163dc0f689so114251195ad.1
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 07:44:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736783070; x=1737387870; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f9GN/9Nt3vZP1g4PXg+O1YxepiT+zT9oJT9rhlVkhGw=;
        b=pU1+WiSsyqPWa5ly5upG+r/5xcY8MfG3fr42fsXkRXuP+HD2nO9ZwIPqe4oMUs6XxY
         M1pBPw5QmxVZKFwjnPcHVHEPVOQOphAu6XJxuL9Ft2YO/UeRtA4KRnTnJVP/J1o06tfO
         Q15emJ5C3EQPgXHj6AgtzKPtY7HSyP9bPaEtIDT2pVq2gOVI4rzz4xqInQafP8T05ZlL
         urUHduNzs5qF6cljTJQpTsIK1ePAr/2oFzPEGalKSFIiPpEuMwYK0fTdpfmsblr+WElz
         TRsBrZ+RFE43TDJCdLERnsPrs6IrvYWSFg26hGzldL0V5xdQuFg+e/OeFiiVE44xAvz+
         VxsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736783070; x=1737387870;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f9GN/9Nt3vZP1g4PXg+O1YxepiT+zT9oJT9rhlVkhGw=;
        b=SarSLCG3WABMD5Y75JgLJibVviRx5picw7fwQ00PtqIjXaXkaKyxWQ4ZnkIHaFU7Pl
         MaxOZYKFHspf7S0aHCTL/t+Ucd57yHN/0T2LbbA9pcH3CssV/7LkB6tlwJTKXagRRJ21
         QSVnP1zGrr2Q130IC4lmkpQqE3oh62jcX5ZXS36LYjUnRA4NyK1BuDabOgMmuSUU6Ugd
         5msfkKOSc79YbMpuanHIG0KYLSXd1kZlrGEEZZ/JQTJZrPbziuqn+vy229FC7+IfyZgn
         X+DzdA+u3Ikp7f71Ss7Z6q1wyJJ15eUrMVBZx+CJUPTAgay+cSXmz9kVOP9rAo65Hy+H
         iRHg==
X-Forwarded-Encrypted: i=1; AJvYcCV2PXkAAmZD5h2qHTI9vEmmbUpWKcJNWrI5XNpaZpqtutqaCvo+Pxg6L4YYP7Vn/iE1GG8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx963W+Ho+RswTzA8msiIDIt9Xk8L072jkD6mjpknrQVreM+ju
	G2GFoPzIhR3rPTsVWzFZG1aihkmvK4Ow4T5XqxoZ44XXSbARk5QFy4Iz7CbOLhcis6w7dvWDLrW
	CWA==
X-Google-Smtp-Source: AGHT+IHIQyazhiyyUpnFFe5650540BmH10WSCzq7nQUkxQTSPWj6gISntiQcqyGsVty8NrTJi6F4Z/IpKIc=
X-Received: from pfbfh41.prod.google.com ([2002:a05:6a00:3929:b0:72a:bc54:8507])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3993:b0:1e1:adb9:d1a6
 with SMTP id adf61e73a8af0-1e88d0f000fmr33694244637.41.1736783070268; Mon, 13
 Jan 2025 07:44:30 -0800 (PST)
Date: Mon, 13 Jan 2025 07:44:28 -0800
In-Reply-To: <87ikqlr4vo.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111012450.1262638-1-seanjc@google.com> <20250111012450.1262638-4-seanjc@google.com>
 <87ikqlr4vo.wl-maz@kernel.org>
Message-ID: <Z4U03KRYy2DVEgJR@google.com>
Subject: Re: [PATCH 3/5] KVM: Add a common kvm_run flag to communicate an exit
 needs completion
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Michael Ellerman <mpe@ellerman.id.au>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Sat, Jan 11, 2025, Marc Zyngier wrote:
> On Sat, 11 Jan 2025 01:24:48 +0000,
> Sean Christopherson <seanjc@google.com> wrote:
> > 
> > Add a kvm_run flag, KVM_RUN_NEEDS_COMPLETION, to communicate to userspace
> > that KVM_RUN needs to be re-executed prior to save/restore in order to
> > complete the instruction/operation that triggered the userspace exit.
> > 
> > KVM's current approach of adding notes in the Documentation is beyond
> > brittle, e.g. there is at least one known case where a KVM developer added
> > a new userspace exit type, and then that same developer forgot to handle
> > completion when adding userspace support.
> 
> Is this going to fix anything? If they couldn't be bothered to read
> the documentation, let alone update it, how is that going to be
> improved by extra rules and regulations?
> 
> I don't see how someone ignoring the documented behaviour of a given
> exit reason is, all of a sudden, have an epiphany and take a *new*
> flag into account.

The idea is to reduce the probability of introducing bugs, in KVM or userspace,
every time KVM attaches a completion callback.  Yes, userspace would need to be
updated to handle KVM_RUN_NEEDS_COMPLETION, but once that flag is merged, neither
KVM's documentation nor userspace would never need to be updated again.  And if
all architectures took an approach of handling completion via function callback,
I'm pretty sure we'd never need to manually update KVM itself either.

> > +7.37 KVM_CAP_NEEDS_COMPLETION
> > +-----------------------------
> > +
> > +:Architectures: all
> > +:Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
> > +
> > +The presence of this capability indicates that KVM_RUN will set
> > +KVM_RUN_NEEDS_COMPLETION in kvm_run.flags if KVM requires userspace to re-enter
> > +the kernel KVM_RUN to complete the exit.
> > +
> > +For select exits, userspace must re-enter the kernel with KVM_RUN to complete
> > +the corresponding operation, only after which is guest state guaranteed to be
> > +consistent.  On such a KVM_RUN, the kernel side will first finish incomplete
> > +operations and then check for pending signals.
> > +
> > +The pending state of the operation for such exits is not preserved in state
> > +which is visible to userspace, thus userspace should ensure that the operation
> > +is completed before performing state save/restore, e.g. for live migration.
> > +Userspace can re-enter the guest with an unmasked signal pending or with the
> > +immediate_exit field set to complete pending operations without allowing any
> > +further instructions to be executed.
> > +
> > +Without KVM_CAP_NEEDS_COMPLETION, KVM_RUN_NEEDS_COMPLETION will never be set
> > +and userspace must assume that exits of type KVM_EXIT_IO, KVM_EXIT_MMIO,
> > +KVM_EXIT_OSI, KVM_EXIT_PAPR, KVM_EXIT_XEN, KVM_EXIT_EPR, KVM_EXIT_X86_RDMSR,
> > +KVM_EXIT_X86_WRMSR, and KVM_EXIT_HYPERCALL require completion.
> 
> So once you advertise KVM_CAP_NEEDS_COMPLETION, the completion flag
> must be present for all of these exits, right? And from what I can
> tell, this capability is unconditionally advertised.
> 
> Yet, you don't amend arm64 to publish that flag. Not that I think this
> causes any issue (even if you save the state at that point without
> reentering the guest, it will be still be consistent), but that
> directly contradicts the documentation (isn't that ironic? ;-).

It does cause issues, I missed this code in kvm_arch_vcpu_ioctl_run():

	if (run->exit_reason == KVM_EXIT_MMIO) {
		ret = kvm_handle_mmio_return(vcpu);
		if (ret <= 0)
			return ret;
	}

> Or is your intent to *relax* the requirements on arm64 (and anything
> else but x86 and POWER)?


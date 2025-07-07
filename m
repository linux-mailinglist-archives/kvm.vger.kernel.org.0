Return-Path: <kvm+bounces-51697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FE0FAFBBA7
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 21:20:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7733A16C3B9
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 19:20:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0EB1266582;
	Mon,  7 Jul 2025 19:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="g4DZ1X0b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0DB224B0E
	for <kvm@vger.kernel.org>; Mon,  7 Jul 2025 19:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751916005; cv=none; b=EsynePib9o5lH/iAqjNEvYVhlCTK8tYqgOiEeNgWdAM2da1JsmgqMTxD+umJu3ISLtOXCbvoDNNAV1J/91wN9dSuhF0mykxnx7WhCryNCUSUhqyz2tST5/ij38RUHPpFRt5jJ19nvWEN1cqCO9JyNIYgiwFd8BWBRGyjDNoquBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751916005; c=relaxed/simple;
	bh=LdO/4LQkEbwgGecFMMdG8I/H4U+/hzTm0h1PFiuavQI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kga43i/a26STD7Z1be5Frgz9FRHetbbFxBFkTdK2SIWCXM679uQtfL+wBASYOSx/srPiNMWkOH42JDuP6YLyCeKXMbln0c5DTRQcwu5pVeVcTUNXEO0aBqwQ1Tk8ZcYo3dbyS6+0jCx8JXFoyIFEBC61hUyL5DLkxTTaFeiUcFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=g4DZ1X0b; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3132c8437ffso5193794a91.1
        for <kvm@vger.kernel.org>; Mon, 07 Jul 2025 12:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751916004; x=1752520804; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oRPungLhCMbFT17gwpSiJyBFIFmaCnbMT4a01H3rmSk=;
        b=g4DZ1X0baR7HhY2a55J9scQ0n0mv5wZ+GhHeRcsmycD6G6V5leORWiWZW0HwW7ru8/
         v1f1MgoQL0tOWqDbeIaHQ4re6UsI1Kt6Ewv48vc0tb4lG4RNLwWWJg911xILbFKElAax
         +WhLyGpgc425rQTziwrmYrQUVX/ZwQ9ElYXUcKPbyN/KNOmb/i0Tt55GkTsmFGtdp4LD
         UxRUZe/eUE42OvV/8gp8P2+EuQ5EwHAHzGZE/Tra/LrKRKfOuiwO2T/ngp0zThzOjzFh
         It2NNE+caafP9ePxLkNCGE0r4n14sBiYrhbagXWWrUeV2JUbZ+ArF9ywwVue0HGwA109
         l99Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751916004; x=1752520804;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oRPungLhCMbFT17gwpSiJyBFIFmaCnbMT4a01H3rmSk=;
        b=HZdhR8CemhjqnX2vw63y+PdlxSAjNmvYPwww0ulXCzNNSKU2DbMCnCdOupB5iQTw8V
         CiD0tg08uy4D719Lt9RTFjA5IdoB2xBEDkaeoY6X71VzO+nUQ1vgeAqMa1vkCxXZ86sm
         sdr0WCFIdEFlMfDhDPq2R1xdeDr6D601nDkWtxTZz4Odc22oXANdUvL/+9KqR3nElZpQ
         QM5mbSAWKXXgYtD6zqtCAQs67zkj5K4u6UAVjo5QTMrJXCUmrtosaJPkAzbvyGKQnnBC
         qUiM3mzcTbWIhcHI39qAYVU80Q7Ss1zzaB5yVi045kA82T9pxE/xs+6eQBdEzO4i9W3L
         r/Kg==
X-Forwarded-Encrypted: i=1; AJvYcCVLeY1TK1JeYCYKNeWnvjl4F5mFoWXvvNidHJaA6cgEFMmtL0WmKRvK0QSKXYaE4Qb2f8w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwZK6GTNrWqE9VvZMlk9cZ5HXj/2pX7ZLunol//Ddje0RlC8Nw
	vZRGvrQ6pJkGj+8pVe3bzbReeeHJIUMq9oBHaHIGB0jJlGE5inFQwaY/Clj/yYHPWNT3aJNqy5X
	BsynREg==
X-Google-Smtp-Source: AGHT+IHuZExtBi8nkRDLNH/gGrIUwAHBNEsHmAJ1owCt4iggl3WIus4SV7ghwVoHaOOok8bL/o5LhDmMIuA=
X-Received: from pjbpq12.prod.google.com ([2002:a17:90b:3d8c:b0:30e:7783:edb6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a81:b0:312:e279:9ccf
 with SMTP id 98e67ed59e1d1-31aac432867mr18709895a91.5.1751916003788; Mon, 07
 Jul 2025 12:20:03 -0700 (PDT)
Date: Mon, 7 Jul 2025 12:20:02 -0700
In-Reply-To: <aGTvFbqLKcG1wLqO@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250630133025.4189544-1-alexandre.chartre@oracle.com>
 <aGO3vOfHUfjgvBQ9@intel.com> <c6a79077-024f-4d2f-897c-118ac8bb9b58@intel.com>
 <aGPWW/joFfohy05y@intel.com> <20250701150500.3a4001e9@fedora>
 <aGQ-ke-pZhzLnr8t@char.us.oracle.com> <aGS9E6pT0I57gn+e@intel.com>
 <f1d53417-4dce-43e8-a647-74fbc5c378cb@intel.com> <aGTvFbqLKcG1wLqO@intel.com>
Message-ID: <aGwd4uVrAGzka95_@google.com>
Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised on AMD
From: Sean Christopherson <seanjc@google.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Igor Mammedov <imammedo@redhat.com>, 
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Alexandre Chartre <alexandre.chartre@oracle.com>, 
	qemu-devel@nongnu.org, pbonzini@redhat.com, qemu-stable@nongnu.org, 
	boris.ostrovsky@oracle.com, maciej.szmigiero@oracle.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 02, 2025, Zhao Liu wrote:
> > I think we need firstly aligned on what the behavior of the Windows that hit
> > "unsupported processor" is.
> > 
> > My understanding is, the Windows is doing something like
> > 
> > 	if (is_AMD && CPUID(arch_capabilities))
> > 		error(unsupported processor)
> 
> This is just a guess; it's also possible that Windows checked this MSR
> and found the necessary feature missing. Windows 11 has very strict
> hardware support requirements.
> 
> > And I think this behavior is not correct.

It's not really a matter of correct versus incorrect in this case.  Software is
well within its rights to refuse to run on unsupported hardware.  E.g. many
hypervisors now require EPT/NPT and other modern features.  Even KVM requires a
minimum set of features; KVM just happens to have a *very* low minimum, and KVM
tries to be gentle and friendly when unsupported or incompatible hardware is
encountered.

Windows' behavior is arguably flawed, misguided, and user hostile, but we can't
say it's wrong.  E.g. even if the argument is that AMD could ship a future CPU
that supports ARCH_CAPABILITIES, it's not a violation of AMD's architecture for
Windows to not support such a processor.


Return-Path: <kvm+bounces-16514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5389C8BAE0B
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 15:50:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FE9A1C229A6
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 13:50:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B9EC15442B;
	Fri,  3 May 2024 13:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qoK9pR0V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C14153BD4
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 13:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714744191; cv=none; b=Vp0dxKR/Jkot0BKB3EzemNIyOViga0AafXws9TMS2I9goZQxktV4w5zcpBkdki/4yjNIV88vTQlUM6bmOiXR3GdO9me0HvCL01sKt9hMgKw2ACrUxOKaF7D05B1ANqShi85vuu9KeILEi37OQo/DrI6exW2fkCmy+cKfzriU/js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714744191; c=relaxed/simple;
	bh=j07SrBcbxR5dXX5FuZ1/lpjovjv+PAI0Ty3nUmrfPsk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=a0MxwG6WjJuvYV3RgCunM1RGuRv61uyGsUCNzT/b7saCIGtGo9NNtILAziJ5pkx+qc03msDpwXVr4tx0Fh2t4fB7+2oGDzi0h/YnfmC1cwHdma9wm5FnZy5DmOkk6kGSQQkaBJdovPWjRwFjwFXMYuvt2LJb31CEK56cte15QrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qoK9pR0V; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6f446a1ec59so1008737b3a.1
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 06:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714744189; x=1715348989; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rQGv5UfxS6jX/aTPX2JQQkA4rH0rnz4JsGbkCfvMiug=;
        b=qoK9pR0VX+7yhK5foV7UyI7xzgxVCafNPWDfgEv1EYfsASd7/3RTz2J6u0EQ/QBhkw
         otBXrvIMWr1t9rTLYIfWfzPrQeZ2DTen8ejGl8V4A4BJSpaATMSUE5J0cn9LhNt2Nol7
         uDBwYWai7AFD3W3Va47EnJZfo6tG1I9ezJDPPgKLCIRYaXqkRaFJszt5k9e9RlKkqko2
         dMGXiQ/k0sGDw17do6A24w9Ncme6LERJqMpxW6rAH8niwA+L0k1+QoI95AtE1KVBsNrk
         c7hcGDcxVwOhHBX5HO7wR0maJRNsmmBrgq221iGCSj8ltZw6ctVaMTC3as/5j0HfKmL9
         SItg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714744189; x=1715348989;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rQGv5UfxS6jX/aTPX2JQQkA4rH0rnz4JsGbkCfvMiug=;
        b=pntMGHd6c7oyzbrEHRnQ4SHHXVjhYE2iOUxyucDIqsNi18YrK2m4l8QURXGzPKpNG/
         9D30b1Efmb9yAepnpdQYx0vqpf+4lv8DnL3kdbmeZs4JpkGR4K81Uvo0AyfMQEt8Un/M
         4QRZ0h8ljrno6B1XxnQ5NVToM8wMZur0hoeK6oCi7eoAAV5vAopNBM5zM2nAT3MIDvjL
         THVp4jqgm413Mo4CxFuE8xJVcYb11cpbefZd8FarJomT2LGcffc6vXuG+Xf3Osk3gHdp
         MAArJ38dSYmNyLb8NvVRdoCjrzVkl7w/FsEuH6kXo430mGBpgajXs9/N2y1N4iQR9xdY
         TZAg==
X-Forwarded-Encrypted: i=1; AJvYcCWz3Los8ottYsnoDmtu/Q+7WZV1Cx8hm2qkDy5pytHdYJUD24dZ9AX3QjSaWzh9xd1l+yqVRBtk2GFi7knRmtmIsqWb
X-Gm-Message-State: AOJu0Yylm9MeGVH2Q7U01c2IWQUT/joemWvJgFYcipNZDSQnThrGQFXE
	NdAhB8rYUxeomGG5k0g+DKvcme7W6O7c0PhqSpaNGc42StRAZW6Lch0qlt853bI5v8RQMJhHDy0
	rkw==
X-Google-Smtp-Source: AGHT+IGc0eGZplb+oZL3dkGKqelUQj57uqxGLcLhw0noqTEVy1iaqZaCu7zCqnCr5z1/yKblcKIpSFxnXkk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2e07:b0:6ea:baf6:57a3 with SMTP id
 fc7-20020a056a002e0700b006eabaf657a3mr154355pfb.6.1714744189252; Fri, 03 May
 2024 06:49:49 -0700 (PDT)
Date: Fri, 3 May 2024 06:49:47 -0700
In-Reply-To: <20240503131910.307630-1-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240503131910.307630-1-mic@digikod.net>
Message-ID: <ZjTre6BYRpkI_H4o@google.com>
Subject: Re: [RFC PATCH v3 0/5] Hypervisor-Enforced Kernel Integrity - CR pinning
From: Sean Christopherson <seanjc@google.com>
To: "=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>
Cc: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, Alexander Graf <graf@amazon.com>, 
	Angelina Vu <angelinavu@linux.microsoft.com>, 
	Anna Trikalinou <atrikalinou@microsoft.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Forrest Yuan Yu <yuanyu@google.com>, James Gowans <jgowans@amazon.com>, 
	James Morris <jamorris@linux.microsoft.com>, John Andersen <john.s.andersen@intel.com>, 
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, Marian Rotariu <marian.c.rotariu@gmail.com>, 
	"Mihai =?utf-8?B?RG9uyJt1?=" <mdontu@bitdefender.com>, 
	"=?utf-8?B?TmljdciZb3IgQ8OuyJt1?=" <nicu.citu@icloud.com>, Thara Gopinath <tgopinath@microsoft.com>, 
	Trilok Soni <quic_tsoni@quicinc.com>, Wei Liu <wei.liu@kernel.org>, 
	Will Deacon <will@kernel.org>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	"=?utf-8?Q?=C8=98tefan_=C8=98icleru?=" <ssicleru@bitdefender.com>, dev@lists.cloudhypervisor.org, 
	kvm@vger.kernel.org, linux-hardening@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, qemu-devel@nongnu.org, 
	virtualization@lists.linux-foundation.org, x86@kernel.org, 
	xen-devel@lists.xenproject.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 03, 2024, Micka=C3=ABl Sala=C3=BCn wrote:
> Hi,
>=20
> This patch series implements control-register (CR) pinning for KVM and
> provides an hypervisor-agnostic API to protect guests.  It includes the
> guest interface, the host interface, and the KVM implementation.
>=20
> It's not ready for mainline yet (see the current limitations), but we
> think the overall design and interfaces are good and we'd like to have
> some feedback on that.

...

> # Current limitations
>=20
> This patch series doesn't handle VM reboot, kexec, nor hybernate yet.
> We'd like to leverage the realated feature from KVM CR-pinning patch
> series [3].  Help appreciated!

Until you have a story for those scenarios, I don't expect you'll get a lot=
 of
valuable feedback, or much feedback at all.  They were the hot topic for KV=
M CR
pinning, and they'll likely be the hot topic now.


Return-Path: <kvm+bounces-63407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EF5C6C65BB9
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 19:35:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id E9A2E29323
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 18:35:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5C83313526;
	Mon, 17 Nov 2025 18:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pqUvZRa4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A173C262FD0
	for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 18:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763404504; cv=none; b=YEpRRjNLLhhhwAPXHfGDGATY/kkTEwOQzF0BBXlcQIeLjg3arG+87rAOY+qz1NqDIi7OxJ3SF8Ki/EdEYLW9TuGDMfOuIz+iGfPWSUTKp5/m3qxd22taNL/dicrodoJBc7VOlEcjK0xqOg6DY9QsgZo8v/+tCumHJMkhDmFHbZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763404504; c=relaxed/simple;
	bh=vUii/Zjd0EOYd9XofJayFPbD87AGj7mAEd1nALCQxkc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tWSQaQmjj5Yn95U1ExxFtCuHVrG9BJ0Jk2X4IH7wxKPwzO5Q7mX/EyWLrchfQzPHVjCPYRrdG91j/WsAJD3Z+61DP96HX91/6RTzU5Zn08xPADpQj11Xgb3BaC6MmQDdhNdaUo0hxY7z7JSAtr4rY+lbhe7SUBE4jQpcUFczm4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pqUvZRa4; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2956cdcdc17so55099735ad.3
        for <kvm@vger.kernel.org>; Mon, 17 Nov 2025 10:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763404502; x=1764009302; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+tWsc2Xr4SAZkzREfxWG5yQF2KiQKxMP5ZVYXfBNuLo=;
        b=pqUvZRa48F2Ykze+od3CSf+wa0zjsZD+PRcTe/s6dm5NzoTqhCg9RjiyCl8A3HfGXT
         DIuKaqy1hDuM0sfPYa0RtoG7ZyaqCH5dHb8zFPU+nSbXsEaSiWKhcss/XAtiguFpW2pM
         LgRFxq6Posm22RukSRbHnlb3pOSnO3ytnwuml7hE6sBLoz/LSDlFX4n+NNy8KirqJAjo
         2ByjmSEw7LP9nxIrq5XwsX9NJlKOqO0KGRY74XeJl4Hpre+1BDlpdSt+urh38CYpp54Z
         KjDpZxwdXhCsRe/3llLfcmabwzC6KB8F84o2tbuqbQJtjl+5N1x1KMSVCfIaZ5v9bG3f
         mpKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763404502; x=1764009302;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+tWsc2Xr4SAZkzREfxWG5yQF2KiQKxMP5ZVYXfBNuLo=;
        b=H8KTGN9fF5/ILocS722zSM+eih2mB2GZ25eeHrAcDlZzT0+OJdlymwrlgPE67Oib1B
         hnC7ZcZv4E+bSbT1x5rNcI95wU/wVirHK2LcK4vzKf8k3E7KnTsxred8165n8jnze5om
         vvCWlo12GtZ7OXupAnF9VAmACqlM88XutZFai3+YZbHpTaRSI/SyMayAIMJtlVlsFe/n
         KheKZZPlY2I8DjkY0tJGiuZkNpHlQChsJEjBzqAa/uFk1S9rzXHjIPprQbxdDt9Akjxb
         N0esbPjf5T7JqSm68UB72TcP5XOkwoIAGSQ/DD1vkwkIVSuRrcCaP5GAkWa4V1qLANeM
         fQBA==
X-Gm-Message-State: AOJu0YxQ8lMSuHCDSu0J7tCQ6DvKDgmGHwLRHyMoA9JY/ERhSb7LD1I+
	jipKuN7mxe22Kl6g2Y5ajUDKh3167DFOd7WjKFeeqIV48MDaFa5VRsOULg6J2gWY0GuA51BbR8o
	OmpXOsQ==
X-Google-Smtp-Source: AGHT+IEVPv++CcNWV2sW0QiDjD2p2AvLdb5RBh0+M72kaH92cSzSHfGJK9aCnIfjTTtPv8O3gsPnENjpCNc=
X-Received: from plkq3.prod.google.com ([2002:a17:902:edc3:b0:298:321b:1fa8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d60d:b0:27d:c542:fe25
 with SMTP id d9443c01a7336-2986a7509eamr129818835ad.41.1763404501920; Mon, 17
 Nov 2025 10:35:01 -0800 (PST)
Date: Mon, 17 Nov 2025 10:35:00 -0800
In-Reply-To: <176254658743.821204.2042588290407024138.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030224246.3456492-1-seanjc@google.com> <176254658743.821204.2042588290407024138.b4-ty@google.com>
Message-ID: <aRtq1BUthxWcAYLT@google.com>
Subject: Re: [PATCH 0/4] KVM: x86: Cleanup #MC and XCR0/XSS/PKRU handling
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jon Kohler <jon@nutanix.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Nov 10, 2025, Sean Christopherson wrote:
> On Thu, 30 Oct 2025 15:42:42 -0700, Sean Christopherson wrote:
> > This series is the result of the recent PUCK discussion[*] on optimizing the
> > XCR0/XSS loads that are currently done on every VM-Enter and VM-Exit.  My
> > initial thought that swapping XCR0/XSS outside of the fastpath was spot on;
> > turns out the only reason they're swapped in the fastpath is because of a
> > hack-a-fix that papered over an egregious #MC handling bug where the kernel #MC
> > handler would call schedule() from an atomic context.  The resulting #GP due to
> > trying to swap FPU state with a guest XCR0/XSS was "fixed" by loading the host
> > values before handling #MCs from the guest.
> > 
> > [...]
> 
> Applied to kvm-x86 misc, thanks!
> 
> [1/4] KVM: SVM: Handle #MCs in guest outside of fastpath
>       https://github.com/kvm-x86/linux/commit/6e640bb5caab
> [2/4] KVM: VMX: Handle #MCs on VM-Enter/TD-Enter outside of the fastpath
>       https://github.com/kvm-x86/linux/commit/8934c592bcbf
> [3/4] KVM: x86: Load guest/host XCR0 and XSS outside of the fastpath run loop
>       https://github.com/kvm-x86/linux/commit/3377a9233d30
> [4/4] KVM: x86: Load guest/host PKRU outside of the fastpath run loop
>       https://github.com/kvm-x86/linux/commit/7df3021b622f

I've dropped these for now as patch 2 broke TDX.  I'll send a v2 shortly.


Return-Path: <kvm+bounces-67089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 030BCCF63F0
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 02:26:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3D778301145D
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 01:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B109329C79;
	Tue,  6 Jan 2026 01:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s4ZgWj3o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022EC32939F
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 01:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767662307; cv=none; b=SwS1p0gNYaF4+kNXa36TTBQznW8mS0o2LBj8CxJWKNSaxVurWHoINCjm9D8eeSm7qooi51ZIlxIUmyiyqj9bj/uKxC2gXReMlOdpsecW9vuy5kUL2Rcp1mZf244IV3zRvUXc31TMjp7HxBzTLGoAoAK1yJ2lz+f9xClt7N6Iq1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767662307; c=relaxed/simple;
	bh=d5IlxFkfN09wI9xdAxsZH7A7xLpV8LkH9G9w1QVkSWc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uVsvdxrSzAOlq7b/Sbr/rCyh2e+jSDGa3ZQGIodGrnYhmraCMPf57/7jMivsqoB+09pAPEhNHB3s7umlSZhi0hHl0uzX8VP3X7KbXmmUEPXiX8EVuyFTYI8tUqqEIn1p2A4YJLPaq6tgqG973tfbzGqk4SpIT83USK6ZrORsZCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s4ZgWj3o; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29f25e494c2so4779675ad.0
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 17:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767662305; x=1768267105; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MoZ2DynlAQ5onpvyivPK6vUeSnjXP5L/1wR/DXHXUdM=;
        b=s4ZgWj3oHKbl08/PtN12LyvI3qvgD2/Off42rxFy1RXIshnDu5/suuZDBi/ZcB4o+X
         gZASPsiOFH4CYeiOnMdUMdO8Z71N1RYhEAbgNHwfmhpdZe3fMkgcgdDpjSLe9usVbMSx
         t8CSC5O/2XcEd7fkhLrEJrtSt2ir4mkskRPsKUYbslhUWfRIoxMc+us3rpQ4fG2uhwY1
         ZOEO9iFiPzdJOeggahhh7U6OAksNsVtYpLvwOws6zI9boBNBfW8CbfUnbHGo7YjN/CVX
         R5fI9OQKj4KB7ALWhGN3GqmJ35mpYM+ZWTxDo8RjDw5foRtz1b8J/Tdd9f78iTkuUPNs
         sb6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767662305; x=1768267105;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MoZ2DynlAQ5onpvyivPK6vUeSnjXP5L/1wR/DXHXUdM=;
        b=FDaOFfHd4u0p7+R1qEUXmuRsnZ6uWpz1/xxJfHmjrjhjJIseKsC47KTM2bTy3VChfp
         ihovinuYQWtG12UMjBtXLOEcY1KC9ycsJWt3YXpRM3xRZfmimbxO4QbvWER1PbCk5hbm
         mOzk/c5j0nt2+EUdeg3TgXwMDLBOzYYuPSb+fTgsSF9wrNJs2YxKWLOPAVKQHQmSO4FZ
         gp8a4TKc1644O0UefywgqORnElGP6kAiyLGkKd4Qrqvd62ZjdxPppo1C73wSWXDVxrau
         0oqAEQSRNvk3fXUXIDrAUzj4ktoVOPPVALGqCscaTgiZW5I00X/8cJACwHJmpvUp8zOt
         0beQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNYEsVr8YCBmHkfyAQerVghR1Of5Qv2g2nxsgxQAcgFWNPyNCfgrwm52khsiLIUBragXE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4mLY0eTM4K2KdJNe4El+EumuDJ2QpP8ocGQmZKxD9P45nhJ+g
	BnI/TeyJbZCEAVmas0Qo9gmUhnPI4DbqYyEJUUL0DARa506KKDYcNYN/FvD4hN8l+gcq6IrQfH0
	D9SNwag==
X-Google-Smtp-Source: AGHT+IHfRqhJfcx52UpRHQWejPVEL0xaYjN183Xb9LYnoZgPn6znNyRa2AbSZizadcT25F6+OJhZ/IZcKtI=
X-Received: from pjb14.prod.google.com ([2002:a17:90b:2f0e:b0:340:d583:8694])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3847:b0:2a0:d0ae:454d
 with SMTP id d9443c01a7336-2a3e39e58e9mr8362175ad.22.1767662305362; Mon, 05
 Jan 2026 17:18:25 -0800 (PST)
Date: Mon, 5 Jan 2026 17:18:23 -0800
In-Reply-To: <20260101090516.316883-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260101090516.316883-1-pbonzini@redhat.com>
Message-ID: <aVxi32EbgNwMVsK-@google.com>
Subject: Re: [PATCH v2 0/4] x86, fpu/kvm: fix crash with AMX
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 01, 2026, Paolo Bonzini wrote:
> Fix a possible host panic, due to an unexpected #NM, when a KVM guest
> is using AMX features.
> 
> The guest's XFD value, which is stored in fpstate->xfd, is used for both
> guest execution and host XSAVE operations.  However, the guest-configured
> XFD setting can disable features that were enabled when the guest executed
> XSAVE, and this causes a #NM when executing XRSTOR on the guest FPU state.
> 
> This can happen in two cases: due to a KVM_SET_XSAVE that includes a
> disabled component, or if an interrupt causes XSAVE to be executed
> before the call to fpu_update_guest_xfd().
> 
> The first patch fixes both cases, the rest is improvements to selftests
> in order to cover this test and also verify that #NM faults are injected
> corectly.
> 
> v1 had extra patches to export higher-level functions for KVM in place
> of switch_fpu_return() and fpregs_assert_state_consistent().  Those
> were part of refactoring how KVM loaded guest state when KVM_RUN is
> issued, but are not needed anymore with this v2 fix and I will submit
> them separately.
> 
> Tested on a Sapphire Rapids machine, reviews and acks are welcome so
> that I can submit it to Linus via the KVM tree.

Tested on EMR with with my simulated IRQ hack.  Other than ongoing complaints
about the prints in the selftest, LGTM :-)


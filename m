Return-Path: <kvm+bounces-8380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D01384EE58
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 01:23:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B4A691F26340
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 00:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5E2A23B1;
	Fri,  9 Feb 2024 00:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wVxRmnGU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D214184F
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 00:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707438190; cv=none; b=s9USwhNgWif8S8YpxDDVS8RnA51mqtwdU51/Pg7+tBips67RWK0RQxPfFdV5TD5MXwlXkYHlkQ/GMgd6EO+XNtsifkMKSqlDmL4hnEewqekikVq/P0tOLhdoD3YdmYUgeByJYQ7XW5mu1xBiKwiboeNpM4xjZ5kcz00tJk50Wso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707438190; c=relaxed/simple;
	bh=b9LBD3SzdzjTdTsgPpA3dbIQFJXNZZ9G4M6Su8Fgp5Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g3cl+/RYgb63cyXDy+fFGSTbsGh5sBc3Qrkoc2V5PvVS2bdgdS0oHeeWjcx8VuZdq6HhyooiEQOxM91HqqNOKHwYtcV2mCu3D2vWsUJvddwBlNVB9LP3wBCqiPxLY7GQH/CdFmDwzlGYADOPoAVPnZCOJF16iriCjHaBh9IJDFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wVxRmnGU; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc746fb535eso700142276.3
        for <kvm@vger.kernel.org>; Thu, 08 Feb 2024 16:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707438187; x=1708042987; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UH+g3qEUJZAlImoFuBdFiY+nZlSyfmnl7qGyQ8nitY4=;
        b=wVxRmnGU9Uryghp5G35SvHbKmc3MRv2+7lywGg+/9wz9772iMdonf6CutG4e5/Cec1
         Py3szzghiFR02ugU1/cpGbBSTclRK960mPSG6g98Du2gxRH+VR6ASk9FZQDBeIxZtFjf
         A8Abnt01hhF6et5+ND9rxaQu8gdNspylkt39FetokYJ05O349rpcl/w3F2m/8iSYCDgu
         5HQwQrAay51VW0iJFyAcx76+V4WcAFxRPicAh15bQSc6tdyF7kPtOS69D7/QeYjAKgrY
         y5CkmBXHojthAYIRFMPagd9x2o/SGJqmNTM9swQDB7miMo1uQjanxjQE9MkPgyoAz21a
         RRwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707438187; x=1708042987;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UH+g3qEUJZAlImoFuBdFiY+nZlSyfmnl7qGyQ8nitY4=;
        b=VaVeaB+NRaaxhO1sBn16V0IQ/bII6xun2F3qe+ZOR+tRsWwlGa8bzo3jP2N9Te4vu0
         ilJTFrEVwR2g2FKncTZtNDtntzyzcuBkp4Oy0AhdXa3vvM58SQ/9P0gWQoLX+5ds3Ecj
         NFxvPbCM8tgQhIR7A4aELWj4WHasVZN86txChXNY373yO+cB30mZL6J0MdyGZ41NswNU
         LJaif0PFpfmSfbcgs9XYfrvJ4TOvaV5GYeAWjcnQqoomk5ReGQhcnGTCtuwMP7M/xBAp
         UNgVY1wpqvBaKE8LWW+g3OpUXe56tre+GhPzsO5eAopmUk8sqVQwjHKI3dEI2FCfQS1w
         DGpw==
X-Gm-Message-State: AOJu0Yy4I8zEIN+vJd1D0KP6QDuOQeCWfnpIwjm7X49FWUuhR0xauXSy
	bZSRt3Xj+d2/2Z9zrTZTbcBqyFkJpTABmzGwUZHdnna9QFdRg7PLl43GLNw9Mo4w2mPRr6tY8LS
	y7Q==
X-Google-Smtp-Source: AGHT+IHwVRKJ41KsV2QGjN2W8YCEY1g61kAuyb2k6AMMLR0Xpg5dI/8LroMKujPE1IpSfovaE5Tmjc/Jt2g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:f11:b0:dc6:af9a:8cfa with SMTP id
 et17-20020a0569020f1100b00dc6af9a8cfamr277411ybb.6.1707438187615; Thu, 08 Feb
 2024 16:23:07 -0800 (PST)
Date: Thu,  8 Feb 2024 16:22:45 -0800
In-Reply-To: <20231009092054.556935-1-julian.stecklina@cyberus-technology.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231004133827.107-1-julian.stecklina@cyberus-technology.de> <20231009092054.556935-1-julian.stecklina@cyberus-technology.de>
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
Message-ID: <170743804541.201306.3426133149771301470.b4-ty@google.com>
Subject: Re: [PATCH v2 1/2] KVM: x86: Fix partially uninitialized integer in emulate_pop
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Julian Stecklina <julian.stecklina@cyberus-technology.de>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, 09 Oct 2023 11:20:53 +0200, Julian Stecklina wrote:
> Most code gives a pointer to an uninitialized unsigned long as dest in
> emulate_pop. len is usually the word width of the guest.
> 
> If the guest runs in 16-bit or 32-bit modes, len will not cover the
> whole unsigned long and we end up with uninitialized data in dest.
> 
> Looking through the callers of this function, the issue seems
> harmless, but given that none of this is performance critical, there
> should be no issue with just always initializing the whole value.
> 
> [...]

Applied to kvm-x86 misc.  I massaged the changelog to make it clear that
uninitialized tweaks aren't actually a fix.  I also omitted the change from
a u32=>unsigned long.  The odds of someone copy+pasting em_popa() are lower
than the odds of an unnecessary size change causing some goofy error.

[1/2] KVM: x86: Clean up partially uninitialized integer in emulate_pop()
      https://github.com/kvm-x86/linux/commit/6fd1e3963f20
[2/2] KVM: x86: rename push to emulate_push for consistency
      https://github.com/kvm-x86/linux/commit/64435aaa4a6a

--
https://github.com/kvm-x86/linux/tree/next


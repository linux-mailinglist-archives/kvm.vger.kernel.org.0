Return-Path: <kvm+bounces-63605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 90474C6BDD6
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:28:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AD9F84EC0DC
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 22:27:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E45F32FABEE;
	Tue, 18 Nov 2025 22:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4Vai/k3v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0042DC774
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 22:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763504825; cv=none; b=AZBaa2hSxAy3X/JinkM5IDlTZiHTxIxPgrd8OPw8e9duNrXIvL+N7eJGcMR6uB9TGXUvw+mNpFGUMsNyF2pTxhFdYw5no0sgbzqlvW7wCfcG+aqdUeg70OVpnu5fHR/yO8h6jCaez/i6zFEhHTtjUk/NHbnJQwfy+OjlllIeL4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763504825; c=relaxed/simple;
	bh=KrHQQv+zUECEQxbHLQhixzohmgdjIRyjJktB1mDjqyc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RdB6WBClNWdDQWs88qNbhp0KK/AedCI7ncmd6Lk2kkRZ9gXLZ8fSHSMsO7ISNJ4uF/edAi+QeaV/XQKHZ2oEtvfPLSA2tej1XcOZrQVhsbmY92Ayk+IO6m9bG1OT4aPK+l5kXBvw0vPotuPElIfeGgBblVQxdZwXOEzPdHBo2+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4Vai/k3v; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-340ad9349b3so14976831a91.1
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 14:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763504823; x=1764109623; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TXaTcBoElt2xSkz4aQrYGSyiRPLODYJmIxU96prgAJA=;
        b=4Vai/k3v38VaaGvyBXVCS9NfjEg596jGsvCIeh8/yAUbOiGs0vClFGU52NNl2vpIXD
         FyHwPYNWOEWjSIxduWNs9655eN+f9rYUl40S0lF+qBhLODfCnB6+JkBrvNb7J7wxsGwk
         S9iHyz5puPp6pNsx6NjQ3bkUlaiF6S5gJwJUiC+PGbP01vW4LkMO4fMx95vMEOjTN3bk
         7KpgArtL/qHW6X5lddILNuLqnc3wJG9Pk5AkfnNjaor4p2KA6prrYc0lY+S/Y0J4JT01
         p29jEPHey4oz80DNU/GZaimlmnTFlCA9dVzGBsTyZkMvN/ipVF6NOiOo6xLxQee5Y0eP
         KZmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763504823; x=1764109623;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TXaTcBoElt2xSkz4aQrYGSyiRPLODYJmIxU96prgAJA=;
        b=Ys7CDfCPDE9CLzoqVPzDXNRe1/F0B8oCyexK0H/5rGFrjFee6UULEQryofKROoIbwm
         nUf0hsKLBCLYuJgRF8xG9gIYuItzxhzuc/vjZLVYTnNd6XTYLWouYMQEn4qssA9KN2PI
         5U4LjFvj+yWMjPIXSbIr5ht8arCiyWSkouVjFegVIW3FIPB8k9lX/PIGPLyN7JHFFCW4
         d6+4IPoX20+UV8VQt70GHqRlhnZi/NuEMU4S4NKU9Zqy/NtleTS8vdwtXuO4izugIxbE
         qsiClVvUwZ18/8H1I52Btecu5BBec905tgfFMjII1zQHLPvZY546M8WY5mr8NcbYE68N
         P1iw==
X-Gm-Message-State: AOJu0YzwHoMyH0r0FXMofpLXf5nskJiYxofXOnkLXoAYD7nm10RKWKlR
	u2KoT6PhbGXoBTTkrIndC+OypNTrVnEOnJuK4OChIvzFp7SLMM27iW7uYoW+YTdFTDDshdNz8vv
	lYL8Gew==
X-Google-Smtp-Source: AGHT+IFkUcdrfiK1F/sHcOIiVjP4BtUdviA5SPGy0bgwKKjDLTFSAAmlrgBstzBZom8xTr8SEWWmcWbdYaA=
X-Received: from pjua17.prod.google.com ([2002:a17:90a:cb91:b0:343:5259:2292])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2dc6:b0:33b:c9b6:1cd
 with SMTP id 98e67ed59e1d1-343fa739bbemr20522979a91.19.1763504822985; Tue, 18
 Nov 2025 14:27:02 -0800 (PST)
Date: Tue, 18 Nov 2025 14:26:42 -0800
In-Reply-To: <20251113235946.1710922-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113235946.1710922-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <176350466174.2266226.9705773210624467195.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86/vmexit: Add WBINVD and INVD VM-Exit
 latency testcases
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 13 Nov 2025 15:59:46 -0800, Sean Christopherson wrote:
> Add WBINVD and INVD testcase to the VM-Exit performance/latency test so
> that it's easy to measure latency of VM-Exits that are handled in KVM's
> fastpath on both Intel and AMD (INVD), and so that a direct comparison can
> be made to an exit with no meaningful emulation (WBINVD).
> 
> Don't create entries in x86/unittests.cfg, as running the INVD test on
> bare metal (or a hypervisor that emulates INVD) would likely corrupt
> memory (and similarly, WBINVD can have a massively negative impact on the
> system).
> 
> [...]

Applied to kvm-x86 next, thanks!

[1/1] x86/vmexit: Add WBINVD and INVD VM-Exit latency testcases
      https://github.com/kvm-x86/kvm-unit-tests/commit/70e7bc408e10

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next


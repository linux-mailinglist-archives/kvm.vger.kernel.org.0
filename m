Return-Path: <kvm+bounces-45993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 63438AB0655
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 01:04:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6AA451B67EC7
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 23:05:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6A05231A3F;
	Thu,  8 May 2025 23:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="smqmNsFy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A651DD525
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 23:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746745470; cv=none; b=IyBhhD7EZcH1h3kKzxixlyXGFITQDuA5y9OoV4/TN5CUfDVP0qPysReI7/772izwU+dmekRmxwoOGoe8BERvB4RkEWNQFCQYlumRdv+hci2UblOV38+YBWkxaF+91c7fcUZ2gjWEEZ7mwAREVFR91WlqhKLwZtmw8DUUBr7p9hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746745470; c=relaxed/simple;
	bh=JzRxuCHHEoe0xm2svplJV/PWpn9/fOwK048vkaL1MgA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UXiRa4Bu6B4n6AIpeX6+AJODK0orzsu4BLzHba/CKOk2e4qSvYOCSG6P15F2OCIDfeS6Iktnb+YDgtmd02y4UFU3n4t0wplOsPsp9kbN9gKNMahmghnvNzFHNYNX/NI7nq477uoJ60yelTTRCMaYPsOyl7I6rooaDCsN+tiE5RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=smqmNsFy; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30c371c34e7so477734a91.1
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 16:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746745468; x=1747350268; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2TEJVC9pdMWAaVUNB7HuRZMfxNu+J4vzTlXLSvKGeMY=;
        b=smqmNsFyVcu04Iij/mGffHqHmixk/4X0jJ90rJtbku8MZ2c/yo6KhXfpkC8drKhdcj
         ZXJdlyWSSxKLpUAfwhP2P/LDJRIrQYlXZYKMUfVBHgZZdUDSAoGIxFlhiw93qbi3NdvQ
         1F4tZQXVGjk7nBS+RDpsgskXLoMrkKQFrlW16YZBRp5RHjiMFN/oVL5XEvtvYZIqyO3A
         mHJjpVPqU4AQ1t5S07LApWAGOC6jp3KiaB6go05yPQz80+wUNUQsji27aB90ICWkBuIO
         3vqaY0c8IjoYWayyV6hnuPQt3gW7trOW/GidDoi2UGZ3wrvC0zVz8LP8lqWIhbrNMErA
         p4gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746745468; x=1747350268;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2TEJVC9pdMWAaVUNB7HuRZMfxNu+J4vzTlXLSvKGeMY=;
        b=gb6BrLX18y/2DZZbADYycndHcRazjovLhDXbRKx9cJxzroQzA70a8o8du8KAf/PdoG
         egXsb3IiBCRCyxYcxGW7+I7T3m+G6el+R6HhmqLXPMj0KbqO6aQ3xPs0ZMnERfi+vCQx
         sOw4V6DsV8WF4rqEITi35EuhOh8Vp/G+5q1XDMNsyFEKIc42yhQc9wos84CUWeHdx9ST
         p7ZdPlXf/lOanGyzZf5hi8QGrDt8gkZxT9sCgIeg2OuP0FtTgtTc+BAuj9kXI8zfeqNY
         39INAv2yishvQNFatwrjM8cvv6FUgCCGOaccBzVHXwfomh639/w92EIXcygCLnBohfeO
         4Dmg==
X-Gm-Message-State: AOJu0Yy+W7KhptnLYM8IAmUCxosr2e2mwYLl8TiswucSYNcPwshA3Sux
	s1SPDw/tEPQ1MyNfKob/CUSL8C0dE3CtDRWEBM6INVmfaRMxSkdcp+KMHGvGGQlPzgtPGmjeebv
	Y3A==
X-Google-Smtp-Source: AGHT+IH6CyLxRoG5aV2vlGLPfd+CFf1M+609PaVUlqb+8J1uGMaanS7q1+sS7ACFHR15KEXEFz+dfgO4qO0=
X-Received: from pjp12.prod.google.com ([2002:a17:90b:55cc:b0:301:2a0f:b03d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:52cf:b0:30a:4700:ca91
 with SMTP id 98e67ed59e1d1-30c3cb174bbmr1795676a91.1.1746745467893; Thu, 08
 May 2025 16:04:27 -0700 (PDT)
Date: Thu,  8 May 2025 16:04:11 -0700
In-Reply-To: <20250506011250.1089254-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250506011250.1089254-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1015.ga840276032-goog
Message-ID: <174674524889.1512631.9502586158459413855.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Add a test for x86's fastops emulation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, 05 May 2025 18:12:50 -0700, Sean Christopherson wrote:
> Add a test to verify KVM's fastops emulation via forced emulation.  KVM's
> so called "fastop" infrastructure executes the to-be-emulated instruction
> directly on hardware instead of manually emulating the instruction in
> software, using various shenanigans to glue together the emulator context
> and CPU state, e.g. to get RFLAGS fed into the instruction and back out
> for the emulator.
> 
> [...]

Applied quickly to kvm-x86 selftests to make it easier to test's PeterZ's
fastops changes, and to get early test coverage on more hardware (in case
my assertion that undefined arithmetic flags are deterministic proves to
be wrong).

[1/1] KVM: selftests: Add a test for x86's fastops emulation
      https://github.com/kvm-x86/linux/commit/5e9ac644c40f

--
https://github.com/kvm-x86/linux/tree/next


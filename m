Return-Path: <kvm+bounces-48864-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 09E20AD4318
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:44:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18BD4165AA8
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:44:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73961264A74;
	Tue, 10 Jun 2025 19:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qA3HfeyX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E681264634
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749584648; cv=none; b=Gtv8nigGo3cm5axzWXdtXkoRVfnV5CRwXzHhurHMspX+ua1SM903vEJZBOU/YmimBEjzaqxiLf0t72v5N/L1suk/ZjteQsQPCMigfOyNKePEpT7YHJ1cj3vY8Fb8y4LlZR2nxHxl0GN8OA+9bI0P/k/iCtm1P3VSI63pektweck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749584648; c=relaxed/simple;
	bh=VGWKlanZEm73R3J9LZhOzt/1BYmAINHMvy259hzONGg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tCle2V6NZOqhWwruMrBKqtuw3dOtf5wtbeGXI0NMBekQzL/WtNjvcKLZ11PZ4oSLIdfIzhFwEDtJkG6wWKfcOsYiXRdF4MX/9n8ZMZyJouUxCOTU9byPFUzB1uWjJzGrEoX1YXD+2y+PosN3IU7lVXIv2HOi9RGuVR83KNdH+yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qA3HfeyX; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3122368d82bso8959558a91.0
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749584646; x=1750189446; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=42KN7nIhC2HgWww3BJaZ3cPcrXeobLuEYaCG7DOTGdA=;
        b=qA3HfeyXdskjM1l3jsSiyEtEahbq4YS40AcfL29mEYcxaaQJHvRICPsISbt88tvXtk
         5htMdLpe097+dFiWospN31kRo28UvkXwemcpe5ox9USR7tr3+GLYyTJKndddqpuaDKd+
         B0Ol85AWXnY1cxBZGODOpc4n4H3wYS51Kr0vAALLq3vERxYTUOhEOpDpmn5uR3MmI88k
         4+5R08vTyZoWaHbW5t5qA0+cPpVFco8dyqZkuoU1P6YoIPADDzIdq6SmpGMkXnsMjnxu
         n814nKJePt5qTYA1979iEMwdLrDDWM3fL3fJwHSxjurZDMtV5CDORt2PCyKbCK47pcAC
         dTwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749584646; x=1750189446;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=42KN7nIhC2HgWww3BJaZ3cPcrXeobLuEYaCG7DOTGdA=;
        b=MJ00L+ia1JGl3koXnjWdD+VvKrqH+I6BWp8PmjdrfsBJCCrVu9q46xnFoHCiO1MQsF
         s0n7m4wKFT8CoCP2UUjtg0+XGj4+fsNP9nY6sdB7uZV/Umj4P5dWu662oaYdedpQGlzS
         1UQb+FqeLdO4UKjosaEFS/S1vb0MXghgfik5eIW3ECVRv3h21ETlvbdD5AZcFeQdLmrU
         T40Qr7fJxOqqvLZBVR6+Hekdt601o2yDYXPGGBWUgz3Et429YxEeS+bDikEIqI5lOf20
         wj71s7v3RDcQhphcdu/oQ4HbmiRiXMtqZNh3ajc3K9cRuFcMxY1cnj8uBB+vjSvyzRX4
         doMw==
X-Gm-Message-State: AOJu0YwUPoQ2vgPZrs4TqhLNdblkoXVEdUaV6jJKgmfw2yU0Np8xECAg
	AvgL/kSmkPwM/cjzKbjPX33TIUJf9fNPFcYgJ2qr+UzHUCJUlpoO4vQiHxSwZ7VZTO50A/PJ6v/
	aCqKvtg==
X-Google-Smtp-Source: AGHT+IHVKK2FzbrnSFXqlPb7xjqrtlw1oNTnUYAsoLkp5iOhnIAFSO8UqYiyRs1C+oaZEcSNHcuxGcdeyCE=
X-Received: from pjblt2.prod.google.com ([2002:a17:90b:3542:b0:312:4274:c4ce])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:48ce:b0:313:2b30:e7bb
 with SMTP id 98e67ed59e1d1-313af10cf02mr1193416a91.15.1749584646582; Tue, 10
 Jun 2025 12:44:06 -0700 (PDT)
Date: Tue, 10 Jun 2025 12:42:36 -0700
In-Reply-To: <20250529210157.3791397-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529210157.3791397-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <174958166078.103169.15373214943244950213.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86/pmu: Explicitly zero PERF_GLOBAL_CTRL
 at start of PMU test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 29 May 2025 14:01:57 -0700, Sean Christopherson wrote:
> Explicitly zero PERF_GLOBAL_CTRL at the start of the PMU test as the
> architectural RESET value of PERF_GLOBAL_CTRL is to set all enable bits
> for general purpose counters (for backwards compatibility with software
> that was written for v1 PMUs).  Leaving PERF_GLOBAL_CTRL set can result in
> false failures due to counters unexpectedly being left active.
> 
> 
> [...]

Applied to kvm-x86 next, thanks!

[1/1] x86/pmu: Explicitly zero PERF_GLOBAL_CTRL at start of PMU test
      https://github.com/kvm-x86/kvm-unit-tests/commit/0bd5a078d1d1

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next


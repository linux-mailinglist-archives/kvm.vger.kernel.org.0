Return-Path: <kvm+bounces-3043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1829800148
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 02:55:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6AE4028161B
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 01:55:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CC0817F3;
	Fri,  1 Dec 2023 01:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YJiGLROR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25FAF2
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:54:55 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5aaae6f46e1so63889a12.3
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:54:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701395695; x=1702000495; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tecn6AmyR5k2Qu/H4+MjzFtOIKWQJZkWQJnuQ75piAk=;
        b=YJiGLROREVnKrvzffhGG0TC/x+Z5OY0i5IjYPrn0z4jVzeACfg+xNoDfKpg7lrvOBe
         cq7be5UIaMa6OhhDADV/FoD3vYsbVOj+e4ISVA8ji596oftR5F7OpE/NrmkbmOo3Ywye
         2f4WO7wZcVXhz4k66H9sKRXrtiosJd0FzGO+Y7BzI3K49qA9tz7fnn3gl6gfnBisq3Ah
         8lLQM8YhbDB36lDMRUUQAAHn1CQx6VB18T0sbceMgOMn967WVghJbwUhfQXcy399aheK
         qnorEsmGVRzl1xroIXKb96JRA2PHfAApR74KeY0QX9x6RzhGRycZRAHBH48kR7FBl21j
         n7iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701395695; x=1702000495;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tecn6AmyR5k2Qu/H4+MjzFtOIKWQJZkWQJnuQ75piAk=;
        b=jRQ1ccVkNCbZNfAASGCTIUV6K4fLG5N0AdaQBRCwfOPNsMVRHe5Lv/9th8sctMFmW0
         S74TyH2JBzAqeJ3QBa8DnxdoAipc2s2mtADCvqoOpEVTt2doqOZ2meqkSSJV3f9IQv8D
         9amrOCn1En6xGNRYgU1pPiomz0pItWNZ1pfinuT/mKnBWDaJmB+5IXm2I5u+mcI1kCjR
         bAsHDj4f0Y1ij6onU+Ylf4De+N+IFdl5voOwYsjVnf92L7MC4Sd+cQwpdYZFYRU9CanR
         mWRTMfpTx+qF8ufSZ5YSCj33gD9pkqjjA/rol/6mLD99sv36RU07Jg4ydG5KIglUDY5D
         kEiw==
X-Gm-Message-State: AOJu0YyjeGXq6od6yayonoiUCm7xtAPZImi+T5OS3pz49Q8eEilk0TD9
	NLWhREZ2X9EJnEyd2z2jaN4JCmKkMvs=
X-Google-Smtp-Source: AGHT+IFO2twNqlDkXK8VLOVlFLjUse1fmfI8xeu/1k50/w5ETgOYlbPmxVQzKInvfkp6xlTRxN2MwHOfCTU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:1220:0:b0:5c2:2f9:c374 with SMTP id
 h32-20020a631220000000b005c202f9c374mr3894156pgl.9.1701395695116; Thu, 30 Nov
 2023 17:54:55 -0800 (PST)
Date: Thu, 30 Nov 2023 17:52:12 -0800
In-Reply-To: <20231018195638.1898375-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231018195638.1898375-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <170137723293.662627.9568255433684903794.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Don't unnecessarily force masterclock update on
 vCPU hotplug
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongli Zhang <dongli.zhang@oracle.com>, David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="utf-8"

On Wed, 18 Oct 2023 12:56:38 -0700, Sean Christopherson wrote:
> Don't force a masterclock update when a vCPU synchronizes to the current
> TSC generation, e.g. when userspace hotplugs a pre-created vCPU into the
> VM.  Unnecessarily updating the masterclock is undesirable as it can cause
> kvmclock's time to jump, which is particularly painful on systems with a
> stable TSC as kvmclock _should_ be fully reliable on such systems.
> 
> The unexpected time jumps are due to differences in the TSC=>nanoseconds
> conversion algorithms between kvmclock and the host's CLOCK_MONOTONIC_RAW
> (the pvclock algorithm is inherently lossy).  When updating the
> masterclock, KVM refreshes the "base", i.e. moves the elapsed time since
> the last update from the kvmclock/pvclock algorithm to the
> CLOCK_MONOTONIC_RAW algorithm.  Synchronizing kvmclock with
> CLOCK_MONOTONIC_RAW is the lesser of evils when the TSC is unstable, but
> adds no real value when the TSC is stable.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Don't unnecessarily force masterclock update on vCPU hotplug
      https://github.com/kvm-x86/linux/commit/c52ffadc65e2

--
https://github.com/kvm-x86/linux/tree/next


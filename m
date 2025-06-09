Return-Path: <kvm+bounces-48749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DF1FCAD2592
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 20:26:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99AC518915D5
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 18:26:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B65B21CC49;
	Mon,  9 Jun 2025 18:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LjxB/eb6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6AA18DB1E
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 18:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749493559; cv=none; b=PZLM6/hfdOYsm+qrzQDYHduo2E3rrHsZjgLJbSUd/QKlbKyOpu67TNmYDdcTUzYsT+vyWXf37OEfOsB/lx4yNO96Xuy7XQTie4aYAZxQxn99g4IiGEmyZCME5qfpCS+/p+MHmMJDOaX3kvI+0qNXPxR5AIOeLLZo8T9xqtJlIL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749493559; c=relaxed/simple;
	bh=Ah0pHsQHnY1XGuWE/3SKFr3T7GQgAVkrfklDfLiassI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mwvB7koTCHT0Ylvre5tagFKJ14YET6PvWiw28j8JjCbCCniXpHrYJjYacFtrNJPVT0SX0xBWtayAXoivzTPgvWpPaalZS0vEIXc8b/xJyVjHM46WSenIvUIAkmGkz5vYzBS12Hai75fpyrAkG3LyGPJigPFKcdKpifhiQ+J30rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LjxB/eb6; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311cc665661so3931524a91.2
        for <kvm@vger.kernel.org>; Mon, 09 Jun 2025 11:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749493554; x=1750098354; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z9qcsdHcsSJ5C6VTefgwjQ8viEabDJHufEh6SESIfaQ=;
        b=LjxB/eb6bfEa7l5+elWXyU6aCNKlQcSP6yWsFhm/XJE2NScHUHHp0PMqH57VB+C+v/
         rwV0eo3jD3H7OMNSVXobE5o8SqA+g2Thb8E9Z+Irk0viJ7ZNnW/CJtzss9qm4LZoISIp
         4k6AbayZA8Ktg4URRdDobYk6pLJjBj7cs55KsFaf6M3AwMQi8CVxdRB/wM2WdFJYrDCV
         CS/cR50x26zbpJGWewErnd5dQ+ApKHOlsITSfqtpI8U5IS0bTKLlbStbAQqpJvprzWZR
         +dGCs4xISe6kYi10YyXa50sY7M3J3NSKcTJLIOz7YUF+XN5P1Pu0jphJvRMiqxHwEq0s
         X1sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749493554; x=1750098354;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z9qcsdHcsSJ5C6VTefgwjQ8viEabDJHufEh6SESIfaQ=;
        b=FykGzLiKkwQ03dMWQRR2wulYeJu66Gk4t6KbFpqITvPm+AflGUET7qBnVC8udx4lEb
         ZcxrBU62hTD1c+zOo1lOG0IWiDY/GRYN3+w5MTtRlGxHgTo85FbeMcpuTPHMmcotWh9e
         nqufqVHbnWZNYvHa0+3RcCKhl2oJBXFHoKcvUGXuCke+jTodaj703lhdBUW/OOGUbZMH
         8jv11jO0AhJ6an/zmdwTKBuG7g2QJr9FLNB2pqojtBQNxeF1M1fIiXXTozG6142BbmGn
         b6T2G7N3UqtSiXChAj+q5Rw0zFN8JGwhEc1M3J+9j3j5ojWTSa6LANvqTj4GyeEfdzWY
         qysw==
X-Forwarded-Encrypted: i=1; AJvYcCXQKVOcgb0Fkhbi18NllYN5Sj28oTsaG2XR9mYWkcGIOzcl5xK9TJQArifc2fhYGwhDgiE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcCnEhOxmZqjhSDbCP24hCu5DB7VdEBFshXJKsyAYbhj38GhJ5
	jZarKvSV5nJWRQVO/k57A9kNeIDlx6EdIA9XEqRcbF4pysIJz3oJ27YhF/1RNQFQnAdObEp9T1R
	4Kzmw9Q==
X-Google-Smtp-Source: AGHT+IHwUDbgPx1C4OZ9+5MSRmLvBlj6RD8esNnLDwkHpfWEmmt9w7lnjOzBIl0+4tvkc8ZFnU35qEABdKU=
X-Received: from pjbqn15.prod.google.com ([2002:a17:90b:3d4f:b0:311:ff0f:6962])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2252:b0:312:25dd:1c86
 with SMTP id 98e67ed59e1d1-3134730af09mr22498660a91.18.1749493554444; Mon, 09
 Jun 2025 11:25:54 -0700 (PDT)
Date: Mon, 9 Jun 2025 11:25:52 -0700
In-Reply-To: <203f24da-fce0-4646-abed-c6ca657828d1@virtuozzo.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250609132347.3254285-2-andrey.zhadchenko@virtuozzo.com>
 <7ce603ad-33c7-4dcd-9c63-1f724db9978e@redhat.com> <4f19c78f-a843-49c9-8d19-f1dc1e2c4468@virtuozzo.com>
 <aEcOSd-KBjOW61Rt@google.com> <203f24da-fce0-4646-abed-c6ca657828d1@virtuozzo.com>
Message-ID: <aEcnMFzh-X7Aofbl@google.com>
Subject: Re: [PATCH] target/i386: KVM: add hack for Windows vCPU hotplug with SGX
From: Sean Christopherson <seanjc@google.com>
To: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, zhao1.liu@intel.com, mtosatti@redhat.com, 
	qemu-devel@nongnu.org, kvm@vger.kernel.org, andrey.drobyshev@virtuozzo.com, 
	"Denis V. Lunev" <den@virtuozzo.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jun 09, 2025, Andrey Zhadchenko wrote:
> On 6/9/25 18:39, Sean Christopherson wrote:
> > On Mon, Jun 09, 2025, Denis V. Lunev wrote:
> > > > Does anything in edk2 run during the hotplug process (on real hardware
> > > > it does, because the whole hotplug is managed via SMM)? If so maybe that
> > > > could be a better place to write the value.
> > 
> > Yeah, I would expect firmware to write and lock IA32_FEATURE_CONTROL.
> > 
> > > > So many questions, but I'd really prefer to avoid this hack if the only
> > > > reason for it is SGX...
> > 
> > Does your setup actually support SGX?  I.e. expose EPC sections to the guest?
> > If not, can't you simply disable SGX in CPUID?
> 
> We do not have any TYPE_MEMORY_BACKEND_EPC objects in our default config,
> but have the following:
> sgx=on,sgx1=on,sgx-debug=on,sgx-mode64=on,sgx-provisionkey=on,sgx-tokenkey=on
> We found this during testing, and it can be disabled on our testing setup
> without any worries indeed.
> I have no data whether someone actually sets it properly in the wild, which
> may still be possible.

The reason I ask is because on bare metal, I'm pretty sure SGX is incompatible
with true CPU hotplug.  It can work for the virtualization case, but I wouldn't
be all that surprised if the answer here is "don't do that".

> > > Linux by itself handles this well and assigns MSRs properly (we observe
> > > corresponding set_msr on the hotplugged CPU).
> 
> I think Linux, at least old 4.4, does not write msr on hotplug.

Yeah, it's a newer thing.  5.6+ should initialize IA32_FEATURE_CONTROL if it's
left unlocked (commit 1db2a6e1e29f ("x86/intel: Initialize IA32_FEAT_CTL MSR at boot").

> Anyway it hotplugs fine and tolerates different value unlike Windows

Heh, probably only because the VM isn't actively using KVM at the time of hotplug.
In pre-5.6 kernels, i.e. without the aforementioned handling, KVM (in the guest)
would refuse to load (though the hotplug would still work).  But if the guest is
actively running (nested) VMs at the time of hotplug, the hotplugged vCPUs would
hit a #GP when attempting to do VMXON, and would likely crash the kernel.

> > Linux is much more tolerant of oddities, and quite a bit of effort went into
> > making sure that IA32_FEATURE_CONTROL was initialized if firmware left it unlocked.
> 
> Thanks everyone for the ideas. I focused on Windows too much and did not
> investigate into firmware, so perhaps this is rather a firmware problem?
> I think by default we are using seaBIOS, not ovmf/edk2. I will update after
> some testing with different configurations.

Generally speaking, firmware is expected to set and lock IA32_FEATURE_CONTROL.
But of course firmware doesn't always behave as expected, hence the hardening that
was added by commit 1db2a6e1e29f to avoid blowing up when running on weird/buggy
firmware.



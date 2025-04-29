Return-Path: <kvm+bounces-44781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D8F5AA0E29
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 16:05:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87A40461F62
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 14:05:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CB7A2C2AA6;
	Tue, 29 Apr 2025 14:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gX5PRhX1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE22721A457
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 14:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745935539; cv=none; b=mQhfzZ0bXFQIQKsOdHcRv1H0M5bNrnPycvLa36Js/mRAFaJxzrDAp23PiNk1wrlVm0cibTjlAn2V5d6CUJBRpw7mcjTr0AiVwWlrUs8V+vPAqU0CyW4REe+9pzHwO7OEjQQXFTgu8DDScAJyC0lYnT1usLUSFO427/7ULyIyEhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745935539; c=relaxed/simple;
	bh=KXkWYlsKpNS7N/qD4ZVXK0LUxaL12ArIUs7VrBlL4YE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pc1SCfZPeiWSyaTXRPEiO+eE+KKodFuOvz5FEbVoSsjgcIhfe+L3qN9BkYJEjTcLRClYabqNTJQqDjQT/bgK1wnBTUcsnnExXAyKkKpTZ5OSdf+HVKDabIGVSfWdPChrX4S3COhr8RT+93OHodQffuT48wnHeOUz5C+H3sNc7R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gX5PRhX1; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-736cb72efd5so4497195b3a.3
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 07:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745935537; x=1746540337; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e3iRogAF7jMgKnBN33JdvjDUDJ4zwxPn8g8eIzFTGjk=;
        b=gX5PRhX1YoS7a2WlhZXTf6DIeoTRjNLsiV6nrF0Wry6tcLheIt5W4tYOeqAxM+B0ob
         SNR6TfVfn9ti8GVV52OTR3gDfXgTX1scN6nhnK97vbVHSdVvhOR8po416MYxmQpqGPy3
         uVcci5Og8ERFeyblLtEn9pqr5xTf6dlp2uitBBtABEUwGfU+gcroXWenhYTUD3DNKSAU
         Mq8fhMVMMW2NA3G7S2jKlzOw42ugWUImB5y8G0qQsfpl8cklIWazJi03FNqoTe1F18IJ
         6t5EFUQLVRLtxvQmQvUvBfEcm5zOOu0JEOZikfUmfHP6ilCkIGx1mRMLe7JCmgXR4mTd
         uo+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745935537; x=1746540337;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e3iRogAF7jMgKnBN33JdvjDUDJ4zwxPn8g8eIzFTGjk=;
        b=AWGr0C5WqnUg+QcnHCyM6G/ie3KpSVuVwOaA+wiFcJ5TQ0fstBVCJ24HI7CQDJ4U6I
         f0I5jO/XXYkUhxhWBYr4yDRQdAAWAl6IoIwJx9wL85s4XLP8Ct49evbzlo4Smm/bVzTT
         y0qbLzX/d+qSPnCVWKindSi8Hkw9SmNCojDfdw1kzcShrKV4AZgW7TbsfeZjMRA2JrTC
         CaB2Jmnz0iuYZHvAOFB5IDuNbFO+bxzmwwWged7NgicofRygLyJ/ALCHWBXEKSBxUfFi
         KIvuX2Gjp6YaVNmhCbjD/G2pWiMoye3OguZA2EkiEuYHU4WdKG+BD/TvqhWk2/LSRdwb
         5x6A==
X-Forwarded-Encrypted: i=1; AJvYcCUKrH5CjrOAgDQor4A1MwmONfuoIOsdJVXMyXKeIvE+V/jndp5lU0vnbyI0Ru88izl2Kwo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxU7ym5mjYtSV55VDF9wl5WyxxSAfGSY5qgYW5eyAuAjtexdfG
	jDX4daUo9TOszz6W3KadNCDzI3hWGg+7e1zaM4Om+5V6AG+hyQLGUou0OJ9YdzvujbopeiI2ls9
	Prg==
X-Google-Smtp-Source: AGHT+IHPyWKc1pFYiTsLltKjh9fqoRS9IPxep5Tbp0bhwmCfOvbTbBn36Xk8y6s9Kw1UL81V/oIiaLfCk1c=
X-Received: from pfbb10.prod.google.com ([2002:a05:6a00:ac8a:b0:730:7485:6b59])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2e9b:b0:736:4ebd:e5a
 with SMTP id d2e1a72fcca58-74027231530mr5583562b3a.20.1745935536957; Tue, 29
 Apr 2025 07:05:36 -0700 (PDT)
Date: Tue, 29 Apr 2025 07:05:35 -0700
In-Reply-To: <20250429100919.GH4198@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250414111140.586315004@infradead.org> <20250414113754.172767741@infradead.org>
 <7vfbchsyhlsvdl4hszdtmapdghw32nrj2qd652f3pjzg3yb6vn@po3bsa54b6ta>
 <20250415074421.GI5600@noisy.programming.kicks-ass.net> <zgsycf7arbsadpphod643qljqqsk5rbmidrhhrnm2j7qie4gu2@g7pzud43yj4q>
 <20250416083859.GH4031@noisy.programming.kicks-ass.net> <20250426100134.GB4198@noisy.programming.kicks-ass.net>
 <aA-3OwNum9gzHLH1@google.com> <20250429100919.GH4198@noisy.programming.kicks-ass.net>
Message-ID: <aBDcr49ez9B8u9qa@google.com>
Subject: Re: [PATCH 3/6] x86/kvm/emulate: Avoid RET for fastops
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org, kys@microsoft.com, 
	haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, hpa@zytor.com, pawan.kumar.gupta@linux.intel.com, 
	pbonzini@redhat.com, ardb@kernel.org, kees@kernel.org, 
	Arnd Bergmann <arnd@arndb.de>, gregkh@linuxfoundation.org, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-efi@vger.kernel.org, 
	samitolvanen@google.com, ojeda@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 29, 2025, Peter Zijlstra wrote:
> On Mon, Apr 28, 2025 at 10:13:31AM -0700, Sean Christopherson wrote:
> > On Sat, Apr 26, 2025, Peter Zijlstra wrote:
> > > On Wed, Apr 16, 2025 at 10:38:59AM +0200, Peter Zijlstra wrote:
> > > 
> > > > Yeah, I finally got there. I'll go cook up something else.
> > > 
> > > Sean, Paolo, can I once again ask how best to test this fastop crud?
> > 
> > Apply the below, build KVM selftests, 
> 
> Patch applied, my own hackery applied, host kernel built and booted,
> foce_emulation_prefix set, but now I'm stuck at this seemingly simple
> step..
> 
> $ cd tools/testing/selftests/kvm/
> $ make
> ... metric ton of fail ...
> 
> Clearly I'm doing something wrong :/

Did you install headers in the top level directory?  I.e. make headers_install.
The selftests build system was change a while back to require users to manually
install headers (I forget why, but it is indeed annoying).


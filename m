Return-Path: <kvm+bounces-50538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 91460AE6FC6
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 21:37:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D3C6188C55A
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 19:37:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E01EA2EA145;
	Tue, 24 Jun 2025 19:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gbikuS0l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991E32E92CC
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 19:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750793816; cv=none; b=tGvf8UAL7WaxEGvr7mV+aG9CjAxeVXHbp1FL6jifi4D2DViz6MYbodtPTZbW10xcP1uRG0trTjACKjR0Clnh7RFQBqI4s9u4ICL82N2xVP21Iw9aPz3D9rB+prso/WuMNoLoDCtLqALGXx3ntkKPuZaA5FpftqKQ1J5PuTl54o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750793816; c=relaxed/simple;
	bh=j/dlt5NY1sEevXbFRYWQdOfVqrxkNincuVvtIcU8akk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=T1XDdXxGAluNFvP9jJ9wrNBUB6WtRqUtrW9pTBv1DY+2itDbjyNEbtcXD7QWBrmspa/6hvU0LRH8s6lvo34DxfkubnQCH4iMFcMcCWPBiIZqoy76DzQ/tR+inkuYn9HqvqNpGD5PcWTFa3Y8rOcqiJglmwTD3D3Zk7LyMsQK4IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gbikuS0l; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3132c1942a1so7830877a91.2
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 12:36:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750793814; x=1751398614; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=viMSycPBqiPur3+TWdDYuhle0MIOLpvl/Uol+qz3flA=;
        b=gbikuS0lFtr1wo0YL/0s0z7eAtK96pusWYNJslLiW4wn0YyA5yUx6br1rLR6pop9Hq
         oTNGUpTec4KgeTucQtQwVpLvG30dRv/IbFGxv+5o7FHeTSRiM3clfY0OHhc+AV1fswYb
         1A8nq1SSNoyxjOpSxpDW6R6pg+Ktvcg8PaVuijOxkXBVbDAK0js9dy0JSjX6/WlCVhol
         AGvCWik7yddSaBpfuVpEj+pvIoHKSAYpyeYtR8dEaTMNrteUAkb52F5TpX+Ra4mCKJnF
         udenBOvBDF6hwKFzYffTncMwEJlapN/0BRercnJmHOrsHxqZVkYlnLJ5kbCO2ztIVK9x
         dktg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750793814; x=1751398614;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=viMSycPBqiPur3+TWdDYuhle0MIOLpvl/Uol+qz3flA=;
        b=u3ojVAEEXBbNi0eMOZbR3kkzfNyNGj/pcQSsAr7RKOxkWbvLkQ5SDHgMFTS3YzNgci
         +NfjcZOXvZhZVEJnBP6DKT/3p2zZPyzOgmQvTBXPhfEFO/vgsAxxsKH9pqf1x/ELJtsS
         fAAoL+ZdJ7QAJmZmMO4nQHqoD4CWKL2P0NesjnLksUiqnRY8pnhp+1C84i6zfpYXxNmI
         BlJq09XWZV6EFl8KeGB+EKU7xugV75i6DZc/T041rLx9zUpgNayIFpvSZwBMXqH8jkjs
         I0UTVrUE6uh9pYDr2aQJ5TXNZnrde2ub7JjBJYmNe0kCv2v1tLkNjhBqLOcGKPhEwx/k
         kUwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhurBRnh+Qn/64Pmq5XB3tDrw2VLtAuNkl2cS1at0Y1E9HtYjS01lD/e1Lj9HeVZU0NVo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEiJ2Gxmp+cbxSZNI+qWG4FlC+1CT9RUexksYTK6u1mpQ4ENLY
	5O/yUYdyk7P7KP8xxHcEHq26eZhOWSFjPbhBHugp5xugD0Ho7MSJr7KasoshfLm8f+gKZalSiAf
	EFsH0Lw==
X-Google-Smtp-Source: AGHT+IFRkQQ2myYZZnKFJSslcKWO07YibtuViIOb3x6ZN/PHZPWcw4jA+Uawc7SEfK6LvysgQOH01TybSVA=
X-Received: from pjvf5.prod.google.com ([2002:a17:90a:da85:b0:2fc:e37d:85dc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e87:b0:315:6f2b:ce5a
 with SMTP id 98e67ed59e1d1-315f2623ca2mr171587a91.11.1750793813797; Tue, 24
 Jun 2025 12:36:53 -0700 (PDT)
Date: Tue, 24 Jun 2025 12:36:26 -0700
In-Reply-To: <aEylI-O8kFnFHrOH@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aEylI-O8kFnFHrOH@google.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <175079250757.516293.17591190576479567167.b4-ty@google.com>
Subject: Re: [RFC PATCH] KVM: x86: Dynamically allocate bitmap to fix
 -Wframe-larger-than error
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	avinashlalotra <abinashlalotra@gmail.com>
Cc: linux-kernel@vger.kernel.org, vkuznets@redhat.com, pbonzini@redhat.com, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	avinashlalotra <abinashsinghlalotra@gmail.com>
Content-Type: text/plain; charset="utf-8"

On Fri, Jun 13, 2025, Sean Christopherson wrote:                                
> Use a preallocated per-vCPU bitmap for tracking the unpacked set of vCPUs     
> being targeted for Hyper-V's paravirt TLB flushing.  If KVM_MAX_NR_VCPUS      
> is set to 4096 (which is allowed even for MAXSMP=n builds), putting the       
> vCPU mask on-stack pushes kvm_hv_flush_tlb() past the default FRAME_WARN      
> limit.
> 
> [...]

Applied my version to kvm-x86 fixes, thanks!

[1/1] KVM: x86/hyper-v: Use preallocated per-vCPU buffer for de-sparsified vCPU masks
      https://github.com/kvm-x86/linux/commit/4bbcc07a56e6

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next


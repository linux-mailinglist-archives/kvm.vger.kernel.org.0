Return-Path: <kvm+bounces-39619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7067CA4871B
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 18:55:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD4DC3A124A
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 17:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 842411EB5FE;
	Thu, 27 Feb 2025 17:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="138PmLX9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609C81D5CD3
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 17:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740678914; cv=none; b=BUyS2rDolnroTbK7tezth5IEGSGM8kmxAfeSiRZo8Ys7jAXHwL5tsp+260AtplE0zfbec7F7k9h8c+tIOZOBG8+lB97ubqY1Y0mm7FxFc8PO87g/tGDcrv1a9oDx+Ax6I8GXjyvvj05tg4IaAr4FWlq5WOIOA2PcTTghbSNsDOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740678914; c=relaxed/simple;
	bh=cYSnkHE+wx9t6OWYiWa1tes0wC6c/Dx8X16yrnsQETE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V12x/Ed35tPvkFFdn7KnHmpcXyvPtrZQC2y3RKk0RhEdlmHU+dZIzMiP5aKqzk00x2lFbgzTaL3pMVn29SxULmI/itOJIAz0FycGzvP4pHPXkdW/28/HyG6bXO+sZszIk5IDuPwSP2pkznNNbj92ivQxcRVDuWW6XroOZjc7R2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=138PmLX9; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fe98fad333so2786427a91.2
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 09:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740678913; x=1741283713; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/U4ADhpQSLxaAX/mw7MLAznup0G/P2ItfXuoeuEvIFY=;
        b=138PmLX9ln+0h+yIW7KB9Cp12R38wl8zZIsKmOErasztqclPwtIq0b4DZrQZ0+DZTQ
         Ms3C8jEz3r669faaO9jfx4LfaJA3kjMPx9ag6ykD9Ok93FGj3LCdJfA/IoGckDeB4tXY
         DR0PcZP1u9r/vptPLffWU2rQTUYq7gE2zuhO86OHsQptYC51Wjm22jaiSV7E2+CPkuSj
         iWDVwf/baXGZncrfB64QBwEP/dqg5nUI9Emn6935oukAw4MqWrJ1SA+hGltX6uiuh0Re
         YZfi5/HEiZd3YFs+lRzZQNRC9RCARNwncnaapjap++4Nx6xL5u7iEnS5aG2qm5c4V2HB
         V/LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740678913; x=1741283713;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/U4ADhpQSLxaAX/mw7MLAznup0G/P2ItfXuoeuEvIFY=;
        b=jHSHtwWgpUpD2Gcgu6PLRFCJnFWAvWtNjhChlk7Mh5tV1R74a663TidqVBeNl+rigD
         i+X7cei7XzcGPZcMisVPpvYfpRx/zZaaJjM1DX1/2naoon+z/DaHUm0lEO4W9gI83A3P
         Wv4e9pIHoVllzHZfNbYSS9wUmzL1t1ablH64DALRsLq80wGl7PGtTgefsMx+HwzsY0TD
         GGBqayy2WCrzivRlPYMuJL3JJoYv4k2Lr+7Bp+4QXwBnJHPeEFXw2hyZ70S5pJoXYBzK
         ngQTKxcLC5xPYVb55ulw5E4WhKzsMYD/ToSS5X082nWZPyGFSO0OhllFfslil08W+XxT
         hW0w==
X-Forwarded-Encrypted: i=1; AJvYcCXGETfZjGhWBq0mfVOlvNyRPd7P3jizlRrVP3uGFORYCopUED/8ExbKHkXvVDIHyUYh5RA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9N3KX6hgmbZSteis8Y7nq58ekQGZj5FOPKwA5pwvxhi93Io00
	KWBOnh76kV+SPHwa7784PFPXkc3tydBIBjehgspiNxkiU+3F2whLdqSqplAzH9uwcfGic5Kqysz
	8Hw==
X-Google-Smtp-Source: AGHT+IHGTbrTn1tn2R1W7Q6/8wDfj86EBdyHlBInyb5ZX3gia9p6YPhCxbDSD+sJY5zmNZzSFX/f2zbnEow=
X-Received: from pjbqb4.prod.google.com ([2002:a17:90b:2804:b0:2ef:7af4:5e8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:52ce:b0:2fe:a8b1:7d8
 with SMTP id 98e67ed59e1d1-2febabc84d9mr303232a91.25.1740678912677; Thu, 27
 Feb 2025 09:55:12 -0800 (PST)
Date: Thu, 27 Feb 2025 09:55:11 -0800
In-Reply-To: <Z8CezusUHEzOCYBF@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227011321.3229622-1-seanjc@google.com> <20250227011321.3229622-4-seanjc@google.com>
 <095fe2d0-5ce4-4e0f-8f1b-6f7d14a20342@amd.com> <1fe17606-d696-43f3-b80d-253b6aa80da7@amd.com>
 <Z8CezusUHEzOCYBF@google.com>
Message-ID: <Z8Cm_68F16TGQeZd@google.com>
Subject: Re: [PATCH v2 3/5] KVM: SVM: Manually context switch DEBUGCTL if LBR
 virtualization is disabled
From: Sean Christopherson <seanjc@google.com>
To: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, rangemachine@gmail.com, whanos@sergal.fun
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 27, 2025, Sean Christopherson wrote:
> On Thu, Feb 27, 2025, Ravi Bangoria wrote:
> > > Somewhat related but independent: CPU automatically clears DEBUGCTL[BTF]
> > > on #DB exception. So, when DEBUGCTL is save/restored by KVM (i.e. when
> > > LBR virtualization is disabled), it's KVM's responsibility to clear
> > > DEBUGCTL[BTF].
> > 
> > Found this with below KUT test.
> > 
> > (I wasn't sure whether I should send a separate series for kernel fix + KUT
> > patch, or you can squash kernel fix in your patch and I shall send only KUT
> > patch. So for now, sending it as a reply here.)
> 
> Actualy, I'll post this along with some other cleanups to the test, and a fix
> for Intel if needed (it _should_ pass on Intel). 

*sigh*

I forgot that KVM doesn't actually support DEBUGCTL_BTF.  VMX drops the flag
entirely, SVM doesn't clear BTF on #DB, the emulator doesn't honor it, it doesn't
play nice KVM_GUESTDBG_SINGLESTEP, and who knows what else.

I could hack in enough support to get it limping, but I most definitely don't want
to do that for an LTS backport.  The only way it has worked in any capacity on AMD
is if the guest happened to enable LBRs at the same time.  So rather than trying
to go straight to a half-baked implementation, I think the least awful option is
to give SVM the same treatment and explicitly squash BTF.  And then bribe someone
to put in the effort to get it fully functional (or at least, as close to fully
functional as we can get it).


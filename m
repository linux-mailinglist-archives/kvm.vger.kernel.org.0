Return-Path: <kvm+bounces-67067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E648CF5190
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 18:54:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D604B3008F25
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 17:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0B0433DEE9;
	Mon,  5 Jan 2026 17:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jrCvvefU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B65339876
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 17:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767635657; cv=none; b=UGs2uOmseX4kwd8PsElN+hG0yaPx8pXkTbPfop+d8bHgSTA5WNmWD1T061aIAFl+QlNR3fehLc6/E+71sOHIeoa+Bl+0WQcc2zK2/0F1Vk+DBHmWlhjDkCUgU7HTUcMTV3RSz8yMFBhy3nzhZ38MYKjGlDpeK+tGl6D//jujEx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767635657; c=relaxed/simple;
	bh=bSbkeUWgwu7cYUEuUD8U62HywlGnY3V/Xr6WNWm9eFQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MvRHQryGkhMQmTajT5BFQOuqPm09n0N5b8xutth20XDOEOULcabZg2CB4VwuOSqreMul52KYh98lpWZv+LnuIw6XgiH4NuNyxVOOEXVygKfG/mTCyBH03SETRnPXAAkOeTpTq0ztP8qcjtjIT12B1O2AYenU/qNUCvNG4msLPEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jrCvvefU; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c1d27c65670so1147681a12.1
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 09:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767635655; x=1768240455; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hrafoT0BmM0wX8jyuTgnCU261S6XUOaNpJc+AaYSvdg=;
        b=jrCvvefUpOTklkb1wbkMk1TusUMFMfDRVdjh5jLjvSNUwRrZF7EIFO9D82Du6GMKI+
         +fQts2ueKY0hcqA2CNpwI2LSSch3JtczZw7VommjY1BJ3Sg99WBevOxoUwq5rdMCKoE1
         9WSJRnnLOhncaqldUTnmovvJ0EejJmApjpqGwjBVm2opBUeiLPejIEVCaUEaMQwnwhER
         0ZHNvWMJyMtGSu1VEbMPMxTYwm8/cBJPqF+ZucURoeoVTqxLAGlLrGERQOdULAql8Es1
         lT4rfwFqgNDXfRtGsUmrlQaGbrTe0lNXde82pVoj82dvXa29eg8Td1tai3Hm1I5Le2lG
         heAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767635655; x=1768240455;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hrafoT0BmM0wX8jyuTgnCU261S6XUOaNpJc+AaYSvdg=;
        b=Ne5pKAbRpc7MqVVpCxY2ONYoVJ3zgDrUKv7mP2MzrEMxtg/MyFaT++qBCsz5xnUjtJ
         vhj/fLqstp1fzYzpLmfj4GVjj59mIyyncGVrz//UIG/De5WUGP405ABWWJwzlCkjMgQW
         1xe7kLLPTVhq4W+D1RdqQAS3GmO13aMocIb4XibvgcZxzZUCctv70NQ8KnJjnrUzTrkS
         mDG1cPFX0Uw5HUbjdleMmHDffBjlFmGrM26How0jpjUBGd4RkHfb1B/2diWkw7hBBZF8
         QQFx9RN8zSdwnhDk9VN8B0aTxw/J0YClVTlGvLc972sYYRFkg2wMiFJiQ3CW4MPjoBqW
         ihHg==
X-Forwarded-Encrypted: i=1; AJvYcCWmF6R/kWz7SJ0Wbqv27B09nYI0QKpn+YpRz/MOaquuaNCogGdvB/u22kX9nus3dloUHT8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRM6BFA9v2wCrak8r+CE7c/K7A5LyDw3p5Zu9/IvMtE+fgZxtJ
	u6R0sNkhwBIAiGxrgcQb87MdbOGCdVtKXXezHKyyHiXvrxVjOdlU4q6hwOr1oAw2DhVbUH1dHjg
	mZM3fFg==
X-Google-Smtp-Source: AGHT+IGm5GQ3p2VH7GV9NtI1hi9ql4IRTFpSvrLeG/EMXIQ5JDDy5n479z4dICVovuOFYA+bBntc9/mPIHY=
X-Received: from pjg15.prod.google.com ([2002:a17:90b:3f4f:b0:34c:2953:cc24])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2dca:b0:34c:2f01:2262
 with SMTP id 98e67ed59e1d1-34f5f831c80mr5812a91.3.1767635654993; Mon, 05 Jan
 2026 09:54:14 -0800 (PST)
Date: Mon, 5 Jan 2026 09:54:13 -0800
In-Reply-To: <20260102183039.496725-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260102183039.496725-1-yosry.ahmed@linux.dev>
Message-ID: <aVv6xaI0hYwgB0ce@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Increase the timeout for vmx_pf_{vpid/no_vpid/invvpid}_test
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 02, 2026, Yosry Ahmed wrote:
> When running the tests on some older CPUs (e.g. Skylake) on a kernel
> with some debug config options enabled (e.g. CONFIG_DEBUG_VM,
> CONFIG_PROVE_LOCKING, ..), the tests timeout. In this specific setup,
> the tests take between 4 and 5 minutes, so pump the timeout from 4 to 6
> minutes.

Ugh.  Can anyone think of a not-insane way to skip these tests when running in
an environment that is going to be sloooooow?  Because (a) a 6 minute timeout
could very well hide _real_ KVM bugs, e.g. if is being too aggressive with TLB
flushes (speaking from experience) and (b) running a 5+ minute test is a likely
a waste of time/resources.

> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  x86/unittests.cfg | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 522318d32bf6..bb2b9f033b11 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -427,7 +427,7 @@ test_args = "vmx_pf_vpid_test"
>  qemu_params = -cpu max,+vmx
>  arch = x86_64
>  groups = vmx nested_exception nodefault
> -timeout = 240
> +timeout = 360
>  
>  [vmx_pf_invvpid_test]
>  file = vmx.flat
> @@ -435,7 +435,7 @@ test_args = "vmx_pf_invvpid_test"
>  qemu_params = -cpu max,+vmx
>  arch = x86_64
>  groups = vmx nested_exception nodefault
> -timeout = 240
> +timeout = 360
>  
>  [vmx_pf_no_vpid_test]
>  file = vmx.flat
> @@ -443,7 +443,7 @@ test_args = "vmx_pf_no_vpid_test"
>  qemu_params = -cpu max,+vmx
>  arch = x86_64
>  groups = vmx nested_exception nodefault
> -timeout = 240
> +timeout = 360
>  
>  [vmx_pf_exception_test_reduced_maxphyaddr]
>  file = vmx.flat
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 


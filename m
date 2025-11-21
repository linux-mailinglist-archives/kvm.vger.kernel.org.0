Return-Path: <kvm+bounces-64230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 0350DC7B66E
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:57:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4C477365876
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 18:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 612EF2F7AD2;
	Fri, 21 Nov 2025 18:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LLx78sYE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F962F7AD7
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 18:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763751369; cv=none; b=qCNIZDW9c6XDw+AYZwZ41wU+dM2C7PQFTij5QQUZj+VFY3XIRUjukQt/d4CsqiI3PKFfWdvO0iO7sH8dAhSHGwDxmr/oqxs9CB7iS7Y6+6pPiBEVw0E19B/f9PPNsoLThVP4FT8dGxD1dGpWHNMnzpZf3JxBFnkhmsLBOp3QKoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763751369; c=relaxed/simple;
	bh=yqJq4nxqm4hdhXnz3iFnmvE2wXLFRti9zrk/vdKD7UA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XYIvQQITbMFEDBTFH5I8JmFMg9N/wWPcU+QC4UCJU39ORb+sJtEIE0S3uxGrPFHDyjln4iqz+8ES41MzFJP89mW++HZyv0SU02/k1Ng42N/BHOYPOMSz+Ski7jLFMWTBNTD1liQ5KW5FNla3MeOjE7BmvaYpLJoEssxe6Z/7Ak8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LLx78sYE; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-343823be748so2537523a91.0
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 10:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763751367; x=1764356167; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A3QWlNVy57LnqwEzBf3LMc9SbGPppmAbNX2qZtCwvLM=;
        b=LLx78sYEger4TFU8AY9g66h1xIzn3A02kLAUJWKx2a4tvIkLClVX778xCDo93qB1J8
         BnBBGS1Ntvyy6RQAnV00rvXun1XnNGV8j/ltthacJLpl6pTw91CUODiKqb0G3Bi0qPIg
         QbE3BO5vdcrqYW3uPkjoOofBxB/LdySHd4FAVbMpnPNOp3vGWLrouQpjeqfYrwH3TiUn
         VsIMuVAse30UkEbXBp8R9Oju2BIynZchbEqpdOaLmL5p14S3mqPaGSQnRJzcbLKdTi/w
         imrDH1qsPNCmMvDu/kT+D1MVDdGCG77mhVXSAXRDnO1OPKO+9AII8uP0YXZsTILCUqzP
         0HvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763751367; x=1764356167;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A3QWlNVy57LnqwEzBf3LMc9SbGPppmAbNX2qZtCwvLM=;
        b=hVnQlsN6T0gM0zAlCVtt+DoV4UF0h7n0qBQElzHU+Ts0QuQzZZzrGU+2TlPJfwsbjA
         IIBAaxEy4QEVfCwXU0E7QJEtNbg0sfqfFH2WpiGa1V+Mide5F3qgsZ6jxe0nve040g1d
         3Z5jirbVkwmWehu04JT008quk4/FvUHefXELVNUo6JMKh8hh+ejfanQDzqiY8BSa8xPO
         vgJozOYkSHcnr0SUZDiWIGIwEX2HlkB8ccPnk+1SuF6bSZyExPLw/8EfEnFUcMPrzD/A
         RZAqn9dSeWIh7nO1QpGKJ4kn7cER1+EH6atLpOK/ANGs8xdoBWW6+ngMyoMLM+u0+Xvx
         SRhA==
X-Gm-Message-State: AOJu0YxTSQw0TgG4WPccq8VzjrxlZJwEs18MnxrFni0F7gJKqn6YI19W
	QpyTuwDs10QhKW72HRIBpoMpTjzQn5BAUggfL9r12VcCTsmc33A9nnWu7C4Sm+HuKUGY3TOZqYj
	oVLGlNg==
X-Google-Smtp-Source: AGHT+IGNWHWjX7e535/RFmTpoqIaiYvqySpkUhhgXs4Lf2QgB2ZqjoWFAIJ27q0K38Ohj4QelXWDC9ZUbVM=
X-Received: from pjo1.prod.google.com ([2002:a17:90b:5661:b0:340:c1bf:6e2d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:ec8f:b0:340:66f9:381
 with SMTP id 98e67ed59e1d1-34733e59272mr3932957a91.10.1763751367301; Fri, 21
 Nov 2025 10:56:07 -0800 (PST)
Date: Fri, 21 Nov 2025 10:55:29 -0800
In-Reply-To: <20251108013601.902918-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251108013601.902918-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
Message-ID: <176375129249.290125.10701416647980581775.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Allocate/free user_return_msrs at kvm.ko
 (un)loading time
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 07 Nov 2025 17:36:01 -0800, Sean Christopherson wrote:
> Move user_return_msrs allocation/free from vendor modules (kvm-intel.ko and
> kvm-amd.ko) (un)loading time to kvm.ko's to make it less risky to access
> user_return_msrs in kvm.ko. Tying the lifetime of user_return_msrs to
> vendor modules makes every access to user_return_msrs prone to
> use-after-free issues as vendor modules may be unloaded at any time.
> 
> Opportunistically turn the per-CPU variable into full structs, as there's
> no practical difference between statically allocating the memory and
> allocating it unconditionally during module_init().
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Allocate/free user_return_msrs at kvm.ko (un)loading time
      https://github.com/kvm-x86/linux/commit/11d984633f7f

--
https://github.com/kvm-x86/linux/tree/next


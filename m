Return-Path: <kvm+bounces-57785-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A2E1B5A1BF
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 22:02:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51B9F2A7AF8
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 20:02:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AFDF2E54A3;
	Tue, 16 Sep 2025 20:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HQ/mEYRh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465C32356B9
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 20:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758052914; cv=none; b=MDIJZTIBS8tperXXWWvD703KqxicTVSoZJ2RpGAiSvMgTXfeBGptT/DHIELv0PFy7igCDMHisMwHdpjpQYysqgpQE5UtTW2Au5KsM/ODY+LAOvpgNk3tw2GuMW2Ir5XT282AGqjS9TJFNs55cstwS2DNqIFc+mTWS63VNku8wQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758052914; c=relaxed/simple;
	bh=ORY2R+nyYLlhpUC+2xMlNWbFZKMrBgMXQ0ha6+zfUwo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=ULBUByRYKa8ZPEPE1tuu2S2D9CU9T+UV9NgE64BlRHPfoC2uuCXnhTq0vwAy20/6RHJc8LTLdW1y6JK/Y3lg12CgJtsINUVYT7gIvZUu3+6aBnhjtdCDEf87PKlyegnFEoXFMOT3O+GBlD+F98EvLWREmUZoKth0P1BmmRnJzJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HQ/mEYRh; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32dd9854282so9326443a91.1
        for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 13:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758052913; x=1758657713; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M0gfbjH4A2acdS03HXdgPmM2zx4rBDxyf8JBJExJVLs=;
        b=HQ/mEYRhtjGYCsoxJ681AACvcELbOLucyUkHu7QK71Y9Zt4mbYLr5EN5bDeGQrplep
         dbykSxMjUy9xR70RtFBGIX7iPakw/SK54yc8vl4O/nECGythqq8/fLz0r5Wc6WHIdLCt
         DOsWpEETWiDDMi5kvR6N5/fL9lEjp43C5LNVlSDO34sAIFmbqqqGvUVrUZq/wUY3cuwU
         TFSEKXAzuo/fgxHjbzQdsJg4PUm+4xxDvpHF3ILuHTc/hNcKRwLVEeXO4SRlU+Tehc9Y
         v2o4+9agcecz+0Uyif1gDQpfFKSfMhy1+ItR0WF5V8LMXKL+wj07KNBW8YHc973lprDk
         jgpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758052913; x=1758657713;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M0gfbjH4A2acdS03HXdgPmM2zx4rBDxyf8JBJExJVLs=;
        b=OiM/ASqSE2EFiKMXDzPYYgJWqrEvgJI8amg0xbddjisa9rvtJxUx6nj4waCmcIMo5C
         IbGnOZMZP/a7LWdg2mZmrhNf8+v5pbghBdvnLN++R7UxN7UOkz3Uddr+Nnh/e0bFeawi
         AWy2z3Turur3CJNPQCgTW616JtXc/JQXTpYtxJ2Be9LO52LL7kFQqRZ2KIpohrnUqcEf
         Rklh0jtUbm/uj1KI6vbTZfNV/KNQmN55iegovlTKhtj6pFV3LdeOLTHrC3IRFnhoUQxT
         JnTIKJ1uI2mxCz3Q34wjOP9VmW2rFvM4sfvYM/2VodkYFmo8Srj2JCtQvy1PpTDEIwqR
         L2cA==
X-Forwarded-Encrypted: i=1; AJvYcCUFoKlOJwBH16KMvpuveaigE60eifqYurgT0cxAnoT7A8LS7rWt99PHUz9JXQRG0cuiJ4c=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywnyh8c8klzq+Lz53k+isOC5LBWQ3cd4z3JWYfEwMVVLevJfUjJ
	afY6ykWIfP5TMKvtEg9jI19s8SiHDLY9N/jQoPtyCKhBoQNQZgw92aPED1WbEBNHGqfs9h6UpLn
	TGjW3xg==
X-Google-Smtp-Source: AGHT+IFYFfM/6Ka1HXDuIekePMOv329MNcJFQsMEhleOmjrL4bcMCw8Y8Cxbz02ln+iEi1nLUg4TwngiA14=
X-Received: from pjx12.prod.google.com ([2002:a17:90b:568c:b0:329:ccdd:e725])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e18d:b0:32b:65e6:ec48
 with SMTP id 98e67ed59e1d1-32de4e5bd79mr19311585a91.8.1758052912699; Tue, 16
 Sep 2025 13:01:52 -0700 (PDT)
Date: Tue, 16 Sep 2025 13:01:51 -0700
In-Reply-To: <175798207153.624508.1085968130364515751.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250901131604.646415-1-liaoyuanhong@vivo.com> <175798207153.624508.1085968130364515751.b4-ty@google.com>
Message-ID: <aMnCL3SdKcQP0ZUO@google.com>
Subject: Re: [PATCH] KVM: x86: hyper-v: Use guard() instead of mutex_lock() to
 simplify code
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Liao Yuanhong <liaoyuanhong@vivo.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 15, 2025, Sean Christopherson wrote:
> On Mon, 01 Sep 2025 21:16:04 +0800, Liao Yuanhong wrote:
> > Using guard(mutex) instead of mutex_lock/mutex_unlock pair. Simplifies the
> > error handling to just return in case of error. No need for the
> > 'out_unlock' label anymore so remove it.
> 
> Applied to kvm-x86 misc, thanks!
> 
> [1/1] KVM: x86: hyper-v: Use guard() instead of mutex_lock() to simplify code
>       https://github.com/kvm-x86/linux/commit/864384e97981

This one also got affected by the force push for an unrelated commit, new hash:

      https://github.com/kvm-x86/linux/commit/cbd860293d13


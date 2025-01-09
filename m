Return-Path: <kvm+bounces-34947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B860A080DA
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 20:50:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E50CE188BDBB
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 19:50:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6958205ABA;
	Thu,  9 Jan 2025 19:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kYEZ+2iP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7A21FFC58
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 19:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736452138; cv=none; b=fmS41LC/7X7sye3A18iHfnxmvGmyQtR+3gpep/Q/ZTszsNLOhdU6SNupkWj2dqkirWjXwvDPi0s0lTIOxjWmJ6PS78cGXjqdYPnTeCpDhtg0p+FHfRpD8MHEjQACuTy/81D821FzyjBVfbXJ5S2+S2CqeOUw3d+yQD5Kk0hUVkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736452138; c=relaxed/simple;
	bh=R3htTwJk+vZ2zNqsXn4VlqB2l7GIqaPrfKbUAVg5VAg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZDvXgNikTKxxyS1h16TEOJ41BPXY8J0jwpgWFhlY2jX9TeD9giHqdBc2dfX4T39yLxKTTcc4eRve1TkHPJ5YO/8cEpuskZy002nilXkRJ6Up8vMxInoHjkHSuElv0jFnzbxUvUSXsKT08imMH4F9rfnexFrtfbZ7/XyrieRqFrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kYEZ+2iP; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2eebfd6d065so3243109a91.3
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 11:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736452137; x=1737056937; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lfhaSmxpTuw/GN3P4+eLipeQYHEKMeL/J6VjlNwuwjU=;
        b=kYEZ+2iPQ0bTK6pgt4WHPezLL7XsltFwBaXm7VDGfZQkKkKDkbJj77ZPuD1E4xr/AN
         /QwmbY9z6Tu/QfztDga+zvFSIQzgbFsXikmFhSpP2JG35JArwmotqQ9DAHlbI8YryAFN
         p/SJvAaL8MacSGNog+UP5MQAnvRFz7oT7mATDO4IsRf1SI+YI5OegCjnryQJp3Pm3Ex4
         EWBdXKDPP4uujxvvg06ezwh4wNJFtBJ4MJ3kjMtvLCPg3JZoS6/6vD+rtl8d/1X9Q+46
         rykQCDiecXNcxfVeMSEYw6S80HhFUVG9XmD1cDF0vBA4fxodCgYOvw5sESx+zR+9ANl8
         cP4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736452137; x=1737056937;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lfhaSmxpTuw/GN3P4+eLipeQYHEKMeL/J6VjlNwuwjU=;
        b=Jl+To6hGZq5YnQ96qHtJEfi7JJivOhwzS1gl3sqta1xU0enODUf6huISPNFivQ3mXE
         pyR8otbrBw/dPFm947oOyyobO5sCohIQB8gPhFxAlm3I1T6+1b9ONtluiczZwnrjUm6G
         hET/vQmlq09BWivk2dnzTibh9C47hvNVsadPQLz3zWAR+wWMN+Jcd4bOCQqVGnEGyN63
         xV4z7hCzLOJYCdhkHqKGn1U+3UTKi1oeh7iraLTH9nNdMpeSjL1oo31QPDoX13HjaoOn
         FFA9Qkvhxxam/DdzU17ENWhqupakBR6326niGcm06RN+8DP5vW+P0hZKYvDaNZPxdCHo
         Fsxg==
X-Gm-Message-State: AOJu0Yxnm0sjhdixVOjClh+YX7WUqtL1sYrGjCgOmQVVxqnJtpa4Y5Su
	ceKA5eewW1HcQAO9hYtzccyxjV3f4TpcqKjRGFDo49I8meJpEHhzDAcBbiSCK4R/T0yZSn3PsyG
	ygA==
X-Google-Smtp-Source: AGHT+IFbTlnPjI66cIHitJkLWroDgxiUG5mQj5U4MmwDZ1U5pip9Yd89a2hABhhURKE1bT5VGQeRfLDUeHs=
X-Received: from pfus6.prod.google.com ([2002:a05:6a00:8c6:b0:728:e1a0:2e73])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:b89:b0:726:f7c9:7b28
 with SMTP id d2e1a72fcca58-72d21f383abmr13826859b3a.8.1736452136968; Thu, 09
 Jan 2025 11:48:56 -0800 (PST)
Date: Thu,  9 Jan 2025 11:47:17 -0800
In-Reply-To: <20241127235627.4049619-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127235627.4049619-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173645118101.885497.8247079551108053264.b4-ty@google.com>
Subject: Re: [PATCH] KVM: selftests: Use data load to trigger LLC
 references/misses in Intel PMU
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 27 Nov 2024 15:56:27 -0800, Sean Christopherson wrote:
> In the PMU counters test, add a data load in the measured loop and target
> the data with CLFLUSH{OPT} in order to (try to) guarantee the loop
> generates LLC misses and fills.  Per the SDM, some hardware prefetchers
> are allowed to omit relevant PMU events, and Emerald Rapids (and possibly
> Sapphire Rapids) appears to have gained an instruction prefetcher that
> bypasses event counts.  E.g. the test will consistently fail on EMR CPUs,
> but then pass with seemingly benign changes to the code.
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Use data load to trigger LLC references/misses in Intel PMU
      https://github.com/kvm-x86/linux/commit/7803339fa929

--
https://github.com/kvm-x86/linux/tree/next


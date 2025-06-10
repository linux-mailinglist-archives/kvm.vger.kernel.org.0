Return-Path: <kvm+bounces-48865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 28962AD431A
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:44:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF6B03A43F2
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADE98264A85;
	Tue, 10 Jun 2025 19:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QUvSE2YS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81120264A65
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749584657; cv=none; b=T0VFnG7MX2o7/DNZcjHUgkB6sAyt4ISGpemKz/vfP67S25tYJX2kjt3zYyM/HUdCDao1Q9Vn0Y73vSY6T7FRW9etEl0VNhMfWlK57rmIb11H3WfrwKLZiTFhkMJrpGMCAYQbDrYJCNGu1cvHJbvIFdNeUqITkrLKZGMsjPOKCyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749584657; c=relaxed/simple;
	bh=Ls/BZ6L7Yi+XBVt1Ae1XNZQXFXgiVkv8ziE52b5QC4s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U58JFOK/FDDeA0DAs78WNcOg/HjT+AHix1r/jQSe57MoVDGzObDdwqTazJT+Y3dhfikHNDNnaXtuVme2nFSpueFWIWb/keev3VzUclXkvD9ILxLRfv7s/toRjXMn7lSFTzNON7rU2tVJertHTaKDWVa8XBXC42YNxqJOV05m0BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QUvSE2YS; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31171a736b2so9783635a91.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749584656; x=1750189456; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tsPbakSn5vFewyFdve6OFbISUHMJh0q3/xTQ9+QsAR4=;
        b=QUvSE2YS+xeANSipwHBZX/8oEcE+OlnmU1w3p3Y9ZzY/+NRnZYYySxzkjCxYxLwS4e
         Cz7ZJCAmANzGkfJFWGSzYyzgWsaVxoKF4X+CzlJ2b6MZr4NZmGIP2gz/PojtI+6XuG2D
         RclqsoXdyq5p3g2ZsBMw77zAVgujG5/nrlTS3BErm/iJWyExsYaUn694DruVIrnvj2yA
         w43aIgqzpRdaPtBHSMcMAuC5xhFyJLDHrru8i94BUz2ZmnyzTEMGKQX9AIZaTWVhDVy1
         6DlP3KqdnRJwVIHJgUouZKVHcSrCuxqJJYRbRFwZy2I9CWgB3TyFZKd7Wp8re2qH9+ne
         3UTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749584656; x=1750189456;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tsPbakSn5vFewyFdve6OFbISUHMJh0q3/xTQ9+QsAR4=;
        b=lA9ebZb+Nn6R1I8qLYrB6NAKWzok7fmhq7WUg7kALBbeckJdcAyyHWeq/o7pli2M1y
         oAAKapLwowhe0Ses0SmR93ZM9T8SXeTVc+xSRHLPrtjsRDmzjcWjSIOV4k+B6/OAsh+V
         FiSeXSDtZOlMZB3TXRC6ZZYSeZlMYSfsuYtbQbPJHVEC1rk/85cdwyX7+ycxkNkBXW+p
         CkBzEEKw75+Cc6HXp9cooGW/9znoo9qFfhBww5i9yhNe1XtN23gvxLwuInss/6HMxXfu
         h27BBjy2PTNXt+p3vtTayyEyV671DNJ0ovTvUGUOOQP0lUvIXdDKX7aY9Ltvlcoxy2Nj
         F6SQ==
X-Gm-Message-State: AOJu0YxfQkLGGCDa9bp2SVLjZ3VG2B3V3Ca/zg1nK31YDN9R4UiQ0IR0
	tu9QZq2sZIAc5YQJzY+QVQ/TswU0iS5+n8uqXRvTcLlniv9wqx3GEopqyFmFfBQNG9tlPZ3obv8
	UDaXzjg==
X-Google-Smtp-Source: AGHT+IHyEZ1hNLMTPbs2M0LaUSVApE2ES148IHOx+H0uKVxIMt+xGsfCyAVfCiudDWLeSjGO+RNerHINBvM=
X-Received: from pjv7.prod.google.com ([2002:a17:90b:5647:b0:312:2b3:7143])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5106:b0:311:cc4e:516f
 with SMTP id 98e67ed59e1d1-313af28d26amr964513a91.31.1749584655952; Tue, 10
 Jun 2025 12:44:15 -0700 (PDT)
Date: Tue, 10 Jun 2025 12:42:38 -0700
In-Reply-To: <20250529213458.3796184-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529213458.3796184-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <174958166334.103250.7452786850221627711.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86/run: Specify "-vnc none" for QEMU if
 and only if QEMU supports VNC
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Thu, 29 May 2025 14:34:58 -0700, Sean Christopherson wrote:
> Explicitly disable VNC when running QEMU x86 if and only if QEMU actually
> supports creating a VNC server, as QEMU will somewhat ironically complain
> about "-vnc none" being an unknown option if QEMU was built without
> support for VNC.

Applied to kvm-x86 next, thanks!

[1/1] x86/run: Specify "-vnc none" for QEMU if and only if QEMU supports VNC
      https://github.com/kvm-x86/kvm-unit-tests/commit/0f982a8c1e22

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next


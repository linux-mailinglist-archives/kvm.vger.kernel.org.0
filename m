Return-Path: <kvm+bounces-39772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A9BDA4A6A3
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 00:40:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EE45D7AA520
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 23:39:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 280911DF748;
	Fri, 28 Feb 2025 23:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="crTPHXi+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB5D1957FF
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 23:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740786041; cv=none; b=XAFbx8Pa6UL9+FpfwaGz4g50w0Jjqjylbt5Mja5jYFBxwymiIztS5jFYFkRMoOfN2H8ayji9IPsdmRKAVfRkbW0qgdklXk09KMa9Fz8ibSMDlDx6Yh0g7k30Q0THq/NLMqqhomOfpQZ+x9Mfe0hJL3OqSIbztT+ArAtB5S4aZ5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740786041; c=relaxed/simple;
	bh=+YDEWUYRf3MHFT8PzzaqVpg4yGdZTKtMjbqIoYAlFe4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ov2ByUUIM/s+NoE1fvgWAOPLoWk1MotvzaikV7cCuY7KX7rgyUIR8EozXcdp591pgG8OYHlg+H3tHDcek8+ALWEeM6l5PIWGoowc906gaKok+Cra13C8TQJWLBywl0bHon5fga6CAST2pBE6K/7nMOAu5nV9VQybrRJZuYPaJhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=crTPHXi+; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc1cb0c2cbso8295704a91.1
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 15:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740786038; x=1741390838; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VgmZbIs8LrjUAYwQIMHJPsubRoSVLW5yQ0A0xB/9GV0=;
        b=crTPHXi+23mdnmjbVAdWR9P8jxb6GLtHll/0RoD8xz+w7bRrsGalJsoVbGhc8mRt+K
         wJM4qUhFPVX50r3hU8hu58VrCxAYPzWdJnxXN8BLZueSiMWL/U8PCuCUyzjWMZor6HV0
         FHpZvuSxuKkm+UZzqMuRApXbqMRuB82pWAn8gWhKQ2El2qsk+3B1k/FiS/sUTso4+Yx3
         Ejcn3MX2gPeFelNbX2SCfa7hzQhx634RA/ER5uKS/4t+/Ew8bAa7grwW4hwB1UKzsvP7
         QBblymeu5UrfWPWLFlOPM3kLFockta4V0zBce/gReETrzuJOYtBR1zNY8ZVnIXP0USWd
         ovGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740786038; x=1741390838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VgmZbIs8LrjUAYwQIMHJPsubRoSVLW5yQ0A0xB/9GV0=;
        b=K+ho2cWqe/d+J26ZXKQQo7Uk/rGrx5nwlkQJk3qhvbqR5TZ9opo3W4+Jj/9rqDbSca
         wG9iqtcKfKI+dTdpDgYT3rBRZR1M1TXyLixDvpxUCDEdYS5BLC+yAmhXlMGV6RKhqPLP
         +yiVbdm5VgjF6wK73cUrGFZYy1Xw+x4NIG+M+vnf1QR9Y1hyVtiW3g03My+45qpwXrsh
         HkORmQsS1UNOD2EG6R8eo4SercdSf2FYs97KCIsHeige0t/Y68ocCf/Js8Nb5N1aGrgV
         qPx1nxF+hzkRLU3bI81S6kCt/ojowKjTVOBC7MVjHZJ11+xSTJcEerWp1C3oY+we0Ds0
         heow==
X-Gm-Message-State: AOJu0YzjX7PDZbtomceRgWwgIUg82LdtQYfo05J150l4dGULKzYLXv18
	lYngkxFp2d8klSQYTZ32YHMlHvsfMtVNQfTWi/t8FLz0usdX+H8KZbQe+6hkSZpMu4nRcskyLB6
	+fQ==
X-Google-Smtp-Source: AGHT+IEgsz4e6jcfc64iTfG+oc/6rOROHmDQlA+xA77VruZkmuESCg3upohcOmnc/OR9kgx8Xg5q2CHxoCw=
X-Received: from pjg7.prod.google.com ([2002:a17:90b:3f47:b0:2f8:49ad:406c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b0d:b0:2f4:4003:f3ea
 with SMTP id 98e67ed59e1d1-2febac0659dmr9420269a91.33.1740786038203; Fri, 28
 Feb 2025 15:40:38 -0800 (PST)
Date: Fri, 28 Feb 2025 15:40:24 -0800
In-Reply-To: <20250224165442.2338294-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250224165442.2338294-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <174076295827.3737602.3025030463131592806.b4-ty@google.com>
Subject: Re: [PATCH v2 0/2] KVM: SVM: Fix an STI shadow on VMRUN bug
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Doug Covelli <doug.covelli@broadcom.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 24 Feb 2025 08:54:40 -0800, Sean Christopherson wrote:
> Fix a bug where KVM puts VMRUN in an STI shadow, which AMD CPUs bleed
> into guest state if a #VMEXIT occurs before completing the VMRUN, e.g.
> if vectoring an injected exception triggers an exit.
> 
> v2: Use "raw" variants to avoid tracing in noinstr code. [kernel test robot]
> 
> v1: https://lore.kernel.org/all/20250215010946.1201353-1-seanjc@google.com
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/2] KVM: SVM: Set RFLAGS.IF=1 in C code, to get VMRUN out of the STI shadow
      https://github.com/kvm-x86/linux/commit/be45bc4eff33
[2/2] KVM: selftests: Assert that STI blocking isn't set after event injection
      https://github.com/kvm-x86/linux/commit/f3513a335e71

--
https://github.com/kvm-x86/linux/tree/next


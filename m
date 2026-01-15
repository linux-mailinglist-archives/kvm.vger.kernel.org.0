Return-Path: <kvm+bounces-68229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BD1ED2780E
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 19:28:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 5FBFE305C1ED
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 18:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 590B53D3481;
	Thu, 15 Jan 2026 18:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jGwihb4j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6A23C1970
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 18:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500473; cv=none; b=d222B94/DQm3xGq8TXqOTs/lPhlCCQSXcjMWQZEa80PlOxkLI49ATkQiiG8LtM47Z+L4a0aRZ9jnnIo40PgJpW+tV++38QFRbZlIA/ERJJtrno1k4NyW9RvQyvUNXt/s7yKNw1Zdr5z63sG3FzZm/2IKHUVhkNa5PAT2D9LWHfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500473; c=relaxed/simple;
	bh=HPD7TG1AvL7tCooRk/oBayY61XqHToF4X+HFMC91ZP8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lxvSlOtzkFfFlrn5sPLhFbh6NHQi77OjfjLNZIoN9JGkV5Gqkal1V6Ycjb3G2zFCS0dra3rKZ/EW55yEjjiQrLjEKLYb16Nn0/yo0XNubPA46jvTPGrcMAG6Zivq736xnR0MUI5W6uJHKO/6h5e3gjPV8++Oy2U+1fDBlPPC5hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jGwihb4j; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c52743b781eso737322a12.2
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 10:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768500472; x=1769105272; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=n5PnbXF8wA6F7oaRDvwu+VcUBZwYdKD3rN14BB+0Tl8=;
        b=jGwihb4jj3JLCZ8uRznDs71OgU+xtCo2/HvlLBdDhn8yBNvP8J1CPp1bdOUug/QnbT
         c8Tjl1woAsTnmDLXqyIub7Ntm6Z18Ir/8YdTpw+loIdOeKPp02f3Vapf1r0Ncx712hiX
         Cd/EnkLydQktm6NijBY1+GZU5vzA5iy8CF07UIG3aC+n+2vCf+xi9QTctDfPS2sjzEOT
         d6hw7XS1Hz1om5My5R1cCQA+KHhel7rnlQIJu7SInUfObEXDF8e+FQxBHWveSNowHSFn
         x/xU0rebQ+IznjqpCvElRZt3hgHqPhWphNUOwT09jslBzW+MHHfsMTxqkFSKvLezXeA/
         HDDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768500472; x=1769105272;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n5PnbXF8wA6F7oaRDvwu+VcUBZwYdKD3rN14BB+0Tl8=;
        b=J0pv1/dAYZ0TDrgaZ53rtywhPQCZSILqDEFC9NJwc5I0H+7+LRg5CgXzXeYnkEG/HC
         KaOPLKyP/2UPd91Q5UTVL09KAhseRpcfR/41p45EUnZpSdDuFC8DcXA+v9wpFS/2Fv2r
         kVv5fXEKK7XcK6dbZkub9Der4VxkumsbCvDuiR619CZ40hShJcT2OpYCoZm+BJHr4dQp
         FjYi0HE0cjBD/WRevj67N518i6NcfYzyqRkiHaqLrSlnfDa8fI2F424BWz8e7Rzd1d7K
         dmNrsGNiI6/lBe87eOpZL0WHoCoINCZLMUN7q/sno9EpejqWwlztuiyv01nyIRizJQKW
         WTCw==
X-Forwarded-Encrypted: i=1; AJvYcCWJaKJgSQYf39SWS9a6tx/6MCVLx0uSg5Ay93joZRI9wOkoIVZD811zKGIemlyi13Rrlps=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSeQhdzxnFzct4dKZYPQhSwZ+Y4z4JnTDh2pV+cPfmS8mSo9RN
	siTuZ80xIOiw0EFgU83lAIyktSpjnNGXpFJLyfBx4SysYZvbW7kRsLITCUv7xq1Fe0apkNVUQP8
	gBJ9i5w==
X-Received: from pjyw19.prod.google.com ([2002:a17:90a:ea13:b0:340:bd8e:458f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:51c2:b0:32e:528c:60ee
 with SMTP id 98e67ed59e1d1-3527323b4demr184460a91.24.1768500471639; Thu, 15
 Jan 2026 10:07:51 -0800 (PST)
Date: Thu, 15 Jan 2026 10:03:38 -0800
In-Reply-To: <20260110004821.3411245-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260110004821.3411245-1-yosry.ahmed@linux.dev>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176849539790.691793.6615872461180369815.b4-ty@google.com>
Subject: Re: [PATCH 0/4] KVM: nSVM: nested VMSAVE/VMLOAD fixes
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	Kevin Cheng <chengkev@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Sat, 10 Jan 2026 00:48:17 +0000, Yosry Ahmed wrote:
> A couple of fixes for nested VMLOAD/VMSAVE and a selftest that verifies
> correct behavior. The test fails without patch 1.
> 
> Patch 4 is a proposed added WARNING, I am not sure if such warnings are
> generally acceptable and if that's the correct place for it (hence RFC),
> but I think it's useful to WARN if VMSAVE/VMLOAD are neither intercepted
> nor virtualized by the CPU, because it means that the guest is directly
> accessing host memory with them, a massive security hole.

Sanity checks in KVM are definitely acceptable/encourage, but this particular
check goes too far.  There are sooooo many things that KVM _must_ get right;
asserting on every single one without strong evidence that we're likely to
screw up without noticing isn't something I want to encourage.

In other words, for me, "the consequences are really bad" isn't sufficient
justification on its own, there also needs to be some amount of "we've botched
this multiple times in the past", "it's tricky to get right", and/or "this is a
low level API that makes assumptions about how the rest of KVM works".

> [...]

Applied 1-2 to kvm-x86 svm, and 3 to kvm-x86 selftests due to its dependency
on the selftests NPT support.  Note, this means running the selftests branch
without the fixes from the svm branch will fail.  Far from ideal, but IMO it's
not worth doing a merge for something that is unlikely to ever be a problem in
practice (and now I've jinxed myself).

[1/4] KVM: nSVM: Always use vmcb01 in VMLOAD/VMSAVE emulation
      https://github.com/kvm-x86/linux/commit/127ccae2c185
[2/4] KVM: SVM: Stop toggling virtual VMSAVE/VMLOAD on intercept recalc
      https://github.com/kvm-x86/linux/commit/55780d8a1dcc
[3/4] KVM: selftests: Add a selftests for nested VMLOAD/VMSAVE
      https://github.com/kvm-x86/linux/commit/55058e32151f
[4/4] RFC: KVM: SVM: WARN if VMSAVE/VMLOAD are not intercepted or virtualized
      [DROPPED]

--
https://github.com/kvm-x86/linux/tree/next


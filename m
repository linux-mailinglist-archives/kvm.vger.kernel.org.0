Return-Path: <kvm+bounces-65365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 55E18CA886A
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 18:16:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0E5DD327631A
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 17:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D99E334C81B;
	Fri,  5 Dec 2025 17:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZTXnhn3Z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C2F34B1A7
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 17:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764954037; cv=none; b=en38bPx//Z05mxWF+18+QzcqreMcQceKnTmrYGxixcnAuvsij4noFdxENv7DYU9xFzzqlDI4TrkyqUbgkxJpLuycwVw5/cSONZvRkKS8n9s/oiSlAgtV9P0vB4KA/VnyXjZ+1KKjWNTT+awPt773/8uG+tCTrlVe7bF3mX27Ufg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764954037; c=relaxed/simple;
	bh=aaFpnj3IQFmy3xc/HrRZVS58s8ztekXzgqmlRlJFpFU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VALuPDffaYT5ED/baB3IDk4KLsMM2h2TQlrERAt4xPHjmCkse/e5x1fQRQY1nhcW3/w8GnGyO0vs5LkqJsKQG8ErUVdBmQlyS3yKnYOhDjsYeosrq7fCo7DXMjr3zNUmjmsxl4RYs5NNz53odvv/tcUMOU0LsjjoEnAsbWhRAtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZTXnhn3Z; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2956cdcdc17so25537455ad.3
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 09:00:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764954027; x=1765558827; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iDj3choeiT4e+El0IukGCUfkaMg0VC3BogLJ1vZELy4=;
        b=ZTXnhn3Zt9X0S7Em1GOBz0VFP7M/wgidB/siUCVovxIr2KYtOoa0siqTLlVS2mtTi8
         CsrFoYBLJTEJVIYMQZXQvs2W+c7mALXvUaPLZPQbw3mCD9z0yScgZ1uJKC4DfCxUvZFy
         8z5XPxuYen8S7XcvGaw9w300qva6RrvrIMEIzEsUgzoZ7DaviAq0WceL+s7UzmwtC/kX
         kNeFy+k8ZlakWPfSczu148WT42H5xAVzs6MRnJPD3aJjer275zYoWmaQgHaWiJey0iCZ
         DrQGoYOBYOypvPbRVxk0jt/otVmCjOLu/iS9Xip8ydvnF5v53kCP17SQjuHpP7u4QQvr
         pyNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764954027; x=1765558827;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iDj3choeiT4e+El0IukGCUfkaMg0VC3BogLJ1vZELy4=;
        b=WnCynCQbauq3Ssmt6CrFYK7FZQk4mUk3tPh+jYSsh0X7XrPOYoi0NJXM5bK9Qb8ET5
         +PuO+G3UpefWxB4s0l4I6FtwUug2YlJlkoGn1L+CfR4Ly+RQM+yicKfY32jS2RJ5ElD7
         H0o6Ezq46Uu1txeiN+sP0921JB5u8w0xyvUMzGcSky4adUh8gR/Oqf83LiDYq1cHK9e5
         6Z7Q7zCeMu4wStpvVUcNqIbIWdHApNwikphOvesUz+TV2iM8TwFjao83whpyyjZWxLCu
         dUTLHTuj/wzJ5pLMehEEcT68sTlmUEn9wspFNZC6DBR5HZBYrrEaoOebHnYH9xSH8H92
         6oKA==
X-Gm-Message-State: AOJu0Yy4vws/p7WLf1zuclTvKZuP2R1Kt40TjArt5QinIe6/+4mg5Q3v
	MUWCZaA4xJ/t2RqI29v+xOO/nGf/oLMcvaANg+Kih9glo+hIVTyCrYLXA8fnLn2MIgpvWRgd34m
	Npk2Mkg==
X-Google-Smtp-Source: AGHT+IEfQPDZ6RmwciNkP/Py4ntixsYOUEMmkTHshPOm/gAzRnuAMijx6Hwt4UQq+2+N6jFtyA7/dYhw5eI=
X-Received: from plbmn13.prod.google.com ([2002:a17:903:a4d:b0:295:1ab8:c43c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:245:b0:295:6c26:933b
 with SMTP id d9443c01a7336-29d682be6a7mr123048855ad.1.1764954027471; Fri, 05
 Dec 2025 09:00:27 -0800 (PST)
Date: Fri,  5 Dec 2025 08:59:31 -0800
In-Reply-To: <20251113225621.1688428-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113225621.1688428-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <176494714145.295908.1538917525859193574.b4-ty@google.com>
Subject: Re: [PATCH 0/9] KVM: SVM: Fix (hilarious) exit_code bugs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>
Cc: kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"

On Thu, 13 Nov 2025 14:56:12 -0800, Sean Christopherson wrote:
> Hyper-V folks, y'all are getting Cc'd because of a change in
> include/hyperv/hvgdk.h to ensure HV_SVM_EXITCODE_ENL is an unsigned value.
> AFAICT, only KVM consumes that macro.  That said, any insight you can provide
> on relevant Hyper-V behavior would be appreciated :-)
> 
> 
> Fix bugs in SVM that mostly impact nested SVM where KVM treats exit codes
> as 32-bit values instead of 64-bit values.  I have no idea how KVM ended up
> with such an egregious flaw, as the blame trail goes all the way back to
> commit 6aa8b732ca01 ("[PATCH] kvm: userspace interface").  Maybe there was
> pre-production hardware or something?
> 
> [...]

Applied 1 and 2 to kvm-x86 fixes.  I'll send v2 for the rest soon-ish.

[1/9] KVM: nSVM: Clear exit_code_hi in VMCB when synthesizing nested VM-Exits
      https://github.com/kvm-x86/linux/commit/da01f64e7470
[2/9] KVM: nSVM: Set exit_code_hi to -1 when synthesizing SVM_EXIT_ERR (failed VMRUN)
      https://github.com/kvm-x86/linux/commit/f402ecd7a8b6

--
https://github.com/kvm-x86/linux/tree/next


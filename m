Return-Path: <kvm+bounces-67807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C756D147F1
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:47:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 086CD3029806
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:41:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46BED37E318;
	Mon, 12 Jan 2026 17:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ArcENUSe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5876921D599
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768239696; cv=none; b=nhKM+EbvWWRbf97/t+I7HgXyGcm3lPcTY6vaRVT5Lvx0JtYEXaHWvcjrKwjueNa7nmMNnthh0IChhB++gVrmqPColgnzxPFtjd00LBcEAdqmzKDQEv7cJVYf4qKKllcFcpKlmBh+sQGZ8vIQx0AWnmorlmQdUzwVJHzEZJziK9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768239696; c=relaxed/simple;
	bh=vz3s4QEoQSCPIcBCfTW7AiJd2EK5vdhq+cM9ipv5WYU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YyPH9jJTJS9Ti/kQEqJRDUBLUm6M1YUHL6BWOxKjRceY1SRDT5VulMeVMZZlhe5riDD9nohluk6lOlWwIAxCQOxd8xRZQpTkN9KaP3aWmIjlPw+FQ1/ZOt3PRhz6OdQO00dc3rPhejbLyLmrKWkZyFumnMCJ2CQfexfh+XmH4sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ArcENUSe; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0bb1192cbso62220345ad.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768239695; x=1768844495; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HJn+6mDwhm4cb58DlkOOR+klYuk5zdCPDtsBuhP8pM8=;
        b=ArcENUSePl0NLE/+SWYrsp/ih4f7um2oCocR3x5880BDUUJz/RV9E/Z4IJHT59p1ZT
         qdb6ZE0j5vghWpUYWczlQMaQa1NXPSo14SNIfgNSFFmlSdphAuy42HfzIn7txYsJ+doi
         PqWd0A5LOk1ex8jn2q3LEJIwN6D+5MHY0WAZUyQkQWK9I9AZwuBRn9/9glOzWo0WslF6
         xIShj/U1JiAsTaCBlFis/xP8E34Rldz5c5/L5AgvsqtEqaUII5eC0jWAnkQER+KCHLBL
         HY1hxbclibhoWjFzYdcrYBB9TFdXTmNPj363a8K1x5BHTRgYrns3ADlJcYcht4Kz2z3f
         VbnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768239695; x=1768844495;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HJn+6mDwhm4cb58DlkOOR+klYuk5zdCPDtsBuhP8pM8=;
        b=Dr22t5OSCUPE1YcgzCc0yPaWve7u92gKV573IRZqFLWMHTXhDK/SjCu7vITPpeuyAn
         wVuJvk0ERWrBmdY2zjYzcw1YbF09eSVm3t4OPOj71X6KrqqJ6OZYSoTHL3+5Qrhey2vP
         ohHX2w60dk82nDmEhceKfpAkPU71DraBiAbBuDSH9DrkB2/TWKxpLf6dtPVtz6TKyKOg
         FwjRcRKC7LYJgo/BU+lF5CAz6fDd8bgYj0AXSevNTUWq+e/c0OTfYpRP7zRINxVQRSqV
         f7QKWXWKzch5zSXZyzexTHK0Omd6yKnwnAxl70xd0Op5WNKSsRa8G1VLrN4bCyAqsqju
         vltA==
X-Forwarded-Encrypted: i=1; AJvYcCXYJxBc2d7unPUiVIlE9mFRa2W1ZEepFYEmrAMVZCA0iYMsrKFvx8v0DZK/Odip+1HspXI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbhcDBVw/zREMNUWp464ZWLA4W4aaBLx4J7KkqU7FwtIv39W+o
	ExKG99/TMgm7g+2HAIPxRjMeOQPkiN0jkzaeTFl21sVvtm74rZB/D5epVUNwMhHId2pmDz86EtO
	ePQ6U1A==
X-Google-Smtp-Source: AGHT+IEL/FnAl+pohq5kuGuvhM4Ebv1523qeW+ugft+GugmQFozzPxALeZAi8oj2SUHMtnrU0D072WAd40A=
X-Received: from pjyj13.prod.google.com ([2002:a17:90a:e60d:b0:34c:2b52:cf75])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce0a:b0:298:4ee2:19f3
 with SMTP id d9443c01a7336-2a3ee4edf11mr195610105ad.49.1768239694498; Mon, 12
 Jan 2026 09:41:34 -0800 (PST)
Date: Mon, 12 Jan 2026 09:38:54 -0800
In-Reply-To: <20251215192510.2300816-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251215192510.2300816-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <176823877360.1368641.767900599632930102.b4-ty@google.com>
Subject: Re: [PATCH v3] KVM: SVM: Don't allow L1 intercepts for instructions
 not advertised
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, 
	Kevin Cheng <chengkev@google.com>
Cc: jmattson@google.com, yosry.ahmed@linux.dev, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, 15 Dec 2025 19:25:10 +0000, Kevin Cheng wrote:
> If a feature is not advertised in the guest's CPUID, prevent L1 from
> intercepting the unsupported instructions by clearing the corresponding
> intercept in KVM's cached vmcb12.
> 
> When an L2 guest executes an instruction that is not advertised to L1,
> we expect a #UD exception to be injected by L0. However, the nested svm
> exit handler first checks if the instruction intercept is set in vmcb12,
> and if so, synthesizes an exit from L2 to L1 instead of a #UD exception.
> If a feature is not advertised, the L1 intercept should be ignored.
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/1] KVM: SVM: Don't allow L1 intercepts for instructions not advertised
      https://github.com/kvm-x86/linux/commit/1d1722e52fcd

--
https://github.com/kvm-x86/linux/tree/next


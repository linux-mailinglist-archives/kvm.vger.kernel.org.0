Return-Path: <kvm+bounces-39026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E742A429B0
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:28:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DBDC17A72E
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 17:27:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31E7A26656E;
	Mon, 24 Feb 2025 17:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dCzLjq7X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AFA263F5F
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 17:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740417974; cv=none; b=PeqgWKjghnWbpUtGS9HTGkxOKrJSrnWOYQC+YV6BZqhgY05H2EeGJQpy46gbr36N+DxQyFU0V4oAQQXuz5kHEIid2XvtyV9i6FIxHgwqjd2m11BB3tdeK+WgPdEbS4lbSrn9s8TAJsYY8KFwomymvKO3KCbdIZ2k9cJbwsl87mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740417974; c=relaxed/simple;
	bh=01LsZkL5ksL1fxwv4UmuiZd+9iiRZ7iddPOBMSgeaBU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ET3VBEd+jkQ1yRS0JJO5Ybd91BJSRDAK81sq4QZdRlCZCvfrR15ERbRj9PMTd6YsG4kYUqFjswkb7ckleTbIOaIbk9Yy5VQs9WuYU+ehDm3lIQNFRZpjRirY1yfIjqhVilCpbucS6d8FZowgjbUuv15jBivJJcQKmWF5i2GgKlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dCzLjq7X; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc404aaed5so15477101a91.3
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 09:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740417972; x=1741022772; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PYDQfOi8yN/ottvU1SrxX4MOXb4oWKQvkw5aVvkeGRI=;
        b=dCzLjq7XbTU8eNlSv35i3E4dJvyZW/ImxE6MkrifNLZwWjGj4CpzQxMNKYbDNJMelC
         7UlmJGZfXAkhrRO7vQd4WDZlEHJqEMsWrpCZrdOFhT1SBTTSOs5p80unG6AMWN0/2lwt
         Y6eJsqaSpKuL0oY6BHU0q0jRn7jfNsVmJpXtmNSY2WvzV0DibzG6dtqNavPlnlePNtpn
         qggZXmyAh2vGoHzZVed9rTGvg7V8YRSKI4eZ8uZnfZFRdVvGdmWVZjNtz0u3PnACqUtz
         vEM13UFHaDQDZ7WTHZZByd5XxLPSgK+nIFGk4kOMXX0j2c2iTstmcuOOGX4lOo5bETh4
         sLrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740417972; x=1741022772;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PYDQfOi8yN/ottvU1SrxX4MOXb4oWKQvkw5aVvkeGRI=;
        b=PtDSakHbZt3R5zUHPNe0ItwIoVfqLupHVk2c+V+wo0fc3rLHaD84MH3Db81+iBS6c0
         2Z3edD2QgDmJ2jxalSEKNZijT4jBhEP0lDs1a7kYjHmt7DnfDQYdAw71PHVpwVGZdNeA
         vYi5jy101bkJEcVjOqOFwvgILF/LGqPW750RxDo3/FLwdRdAEiajLfjdEtwxR+6PvtcA
         +SEMktFHo0T9U2sSLU8lJd64+Xk9c8X6DDlM4ONNxqXTGiCbtli+LMmX0RbNF5tqKpZJ
         oLk5mSYdtsg49RIfAJOUWXbaI8UbixuKkj80ka+9js9pB6pT3cIx3hv6LGP5fwhPgrQV
         8ERg==
X-Gm-Message-State: AOJu0Yw3lyA8cYvIPt0qNKdoMtQRU1FlQhVm9LqKeuXqGJciTPCTa2wm
	3hUAVBpCltClgAOvI1RnwYL7q9cK1EfiZ6tNPn7uc04KVADrScKb/DbLksdR7u2j+gnssfCLO78
	5Hw==
X-Google-Smtp-Source: AGHT+IGi2WHkUJ6Ksh/ZKU4l+5cJ2JBB7H9seH1eJnkBZmHyJ7CEdp84EAMeg7imTZVd8Z6pbXGs5whEbsM=
X-Received: from pjur14.prod.google.com ([2002:a17:90a:d40e:b0:2ef:8055:93d9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f4b:b0:2fc:3264:3657
 with SMTP id 98e67ed59e1d1-2fce75e3336mr28374488a91.0.1740417972479; Mon, 24
 Feb 2025 09:26:12 -0800 (PST)
Date: Mon, 24 Feb 2025 09:24:13 -0800
In-Reply-To: <20250221233832.2251456-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250221233832.2251456-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <174041749041.2351510.2782611318161715558.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Move SMP #defines from apic-defs.h to smp.h
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Fri, 21 Feb 2025 15:38:32 -0800, Sean Christopherson wrote:
> Now that the __ASSEMBLY__ versus __ASSEMBLER_ mess is sorted out, move
> the SMP related #defines from apic-defs.h to smp.h, and drop the comment
> that explains the hackery.
> 
> Opportunistically make REALMODE_GDT_LOWMEM visible to assembly code as
> well, and drop efistart64.S's local copy.
> 
> [...]

Applied to kvm-x86 next (and now pulled by Paolo), thanks!

[1/1] x86: Move SMP #defines from apic-defs.h to smp.h
      https://github.com/kvm-x86/kvm-unit-tests/commit/d467e659b2b1

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next


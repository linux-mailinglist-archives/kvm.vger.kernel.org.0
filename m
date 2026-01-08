Return-Path: <kvm+bounces-67424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AEB6CD04E2B
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 18:21:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1A49B3454618
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 17:07:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7952429B77E;
	Thu,  8 Jan 2026 17:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qQsQvaeW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B3E27603C
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 17:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767892016; cv=none; b=o+cnEV3r072WR2ao5P6hl1Scj54W2BcOX95rTVW1WkXC4ttg6JlnI2VwSQycQ8iAr/weeDeW45dGu0GAImyjjG7fbktJKYiEr4CWmAcoC+mxLilqmKRNTcvj6Ua/A7JqenQAc3J5dUpc6+ceoL92we1cBkm8Emd2E/AGTwukiZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767892016; c=relaxed/simple;
	bh=muPI2Cu8xaoBPojdhtEq4FRkVwa4sSdm2P6NIFiW0v8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XiRP1H3joC327+JSJrVo4nhcRLA/cV9KVNZNw9ud41YBRMUTBSs8y+TMtuBcDfGCqXABhdVReqI918ftmeZqHFEc1YbjcJgKdk3A9gZrtUcWtsNbNDjH/nJt6NL8G08RooyisITBohk2+YToEQ5d4/FhnkKE+7wIeNRtojVck0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qQsQvaeW; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0c495fc7aso38622365ad.3
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 09:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767892014; x=1768496814; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QVefpuP8UR/7XkjLDjyyzWv1Aal+G6i/DuibP933gXc=;
        b=qQsQvaeWIxRi51/8rPUejYCrwYJsv67H9KdtSk8kBnmRahLnMSYloKHB1MT4s4ICzP
         UkuRwinoZs62Z4R9sHR/tpX/lWW89XXafme+uqBvN4Vy5JeZqa/Y16r0cvXLBf7izPzZ
         3N3lpUmeGR6tz8XSwrKJ9frN+x1n0m0/K/GollOsKizUqb3KH8QzpwX6Jsdlxw5QVf57
         vaIpelGFlfOdtjdOw25ZvxhXxpbdAXKrcr3hEKFwpiTzAT7MV3K6PCaI+OtY/lGTFdal
         aUt181hnBwx0yFyuhFPb9esBnb3AMUAbkY8WDkNcgldV5e9hmNJnVdJ7UnAQenAl7hGS
         0dOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767892014; x=1768496814;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QVefpuP8UR/7XkjLDjyyzWv1Aal+G6i/DuibP933gXc=;
        b=YcCe+jMpP5HjgG81wOFLr0l4ayviRPHfKzlLP47Piyxc2oE/DDnZt55oWuZwLHYGV/
         1d0w5smYTJ5pFvBeMQ5RKa0hS1jhUl+R/RuCA/vp0wQIZkmY1V63TXNYVn8Y7/0B5f6p
         x031KXn1tcS1w/empEvIepL6VpDQwvUULOtiKCf6rrGlzI4MfiOTFVM7rmf3IGhEaHjz
         pSWbPQPOOmzVOjC0sgxnJDDEdqPHARGgI76zuJDMdRnFH1w3t/9qo+kC+t4AKbwk/k0+
         QGDcRO8E+aoLOIdU9eryLZ/OJkgl0QhOkSLaj17ICKeTEuWRnABPcLQGpB0h/ugF2UWN
         A0cQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/FlgwMv0JJPqbxHcTW1VGyqZwcmDITY69PMjCkB1ne5SlT2XqoHy2N9B9Nxk4sZpAhiE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbvhHdSlKbWLs9+XDgYN941vu8xrapA7iQZ+dX+FFxULaxofAN
	jZ8zeb2eqKnijMhgCMdQsfJYVvcmjet+MUOZIwF0RdBSL6oZrgoJ18x5tsBmQrC4b5mu3qoEqvq
	s8i6AVQ==
X-Google-Smtp-Source: AGHT+IFQl0ff8pn8KbqQ/lIIr11/3kfrRynmb0Zf119br04GQv3Ng0sDtXyGq7Ap5LK8lMqpSMFAhy6uy/E=
X-Received: from plhz2.prod.google.com ([2002:a17:902:d9c2:b0:258:dc43:b015])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d86:b0:334:8a8e:6576
 with SMTP id adf61e73a8af0-3898f91d311mr6362674637.29.1767892014507; Thu, 08
 Jan 2026 09:06:54 -0800 (PST)
Date: Thu, 8 Jan 2026 09:06:52 -0800
In-Reply-To: <aV-GPYoKB5HIzcs3@blrnaveerao1>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260107204546.570403-1-seanjc@google.com> <aV-GPYoKB5HIzcs3@blrnaveerao1>
Message-ID: <aV_kLHFQzu7taPS_@google.com>
Subject: Re: [PATCH] KVM: SVM: Fix an off-by-one typo in the comment for
 enabling AVIC by default
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 08, 2026, Naveen N Rao wrote:
> On Wed, Jan 07, 2026 at 12:45:46PM -0800, Sean Christopherson wrote:
> > Fix a goof in the comment that documents KVM's logic for enabling AVIC by
> > default to reference Zen5+ as family 0x1A (Zen5), not family 0x19 (Zen4).
> > The code is correct (checks for _greater_ than 0x19), only the comment is
> > flawed.
> 
> I had thought that the comment was correct and that you wanted to 
> reference Zen4 there. That is:
> 	family 0x19 (Zen4) and later (Zen5+),
> 
> Though family 0x19 also includes Zen3 :/
> 
> I think it would be better to update the code as well, just so it is 
> easier to correlate the comment and the code?
> 
>         if (avic == AVIC_AUTO_MODE)
>                 avic = boot_cpu_has(X86_FEATURE_X2AVIC) &&
> -                      (boot_cpu_data.x86 > 0x19 || cpu_feature_enabled(X86_FEATURE_ZEN4));
> +                      (cpu_feature_enabled(X86_FEATURE_ZEN4) || boot_cpu_data.x86 >= 0x1A);

This thought crossed my mind as well.  I'll send a v2 with this, I especially
like the idea of swapping the ordering so that the checks are "ascending".


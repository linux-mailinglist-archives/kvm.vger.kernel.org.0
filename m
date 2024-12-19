Return-Path: <kvm+bounces-34098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 110649F72C4
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 03:41:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D639118909E8
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 02:41:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C29812B169;
	Thu, 19 Dec 2024 02:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zZGXKNuE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E381979C0
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 02:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734576068; cv=none; b=Z+2PXn9tlYpYjN8k/zEg7vDz2WAWuzwYgP228AltFcnqOhAFosUCBHA9IAsed4uHMV9MdUjpMRpufoTp7FEHyJCYhs62JONZuiQDAqdNMpF0yBn4ualNzsF1LaGQgeiceofD7djKs2oWt9O7XrYBkwGDsD3QCFRG07REdW6kzUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734576068; c=relaxed/simple;
	bh=eOEL2WrHWEpi5a9iSwUIEOE+/AdQwi0qQZiUtbWyh/w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gUG2Rpu7OpjfBebTlAn/5tI+zT04xfSmqY+XRIMNo5IgK1Ywlrkk4RX3ZCz0p88+mayjrMkJUzZN4fj2VpXiE0RQLv7oogc0diFoI75TSAGyJnFbUCGudnDx1A6QPy8U39FqpAUEqzIDvqhy/D/e80okvR7DjfIW4gO2Z3d4jkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zZGXKNuE; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee6b027a90so426699a91.1
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 18:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734576066; x=1735180866; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wbb0Eg3UwwWOo11oZmbLgzoTMJnGZQROUXn+RBNp/VQ=;
        b=zZGXKNuE3bXxB6jH6QiaCs2HXi6g2PFVze+0fIkwJNgN5VxlYzaVM1zLuDXkI2I7Zt
         5Z4cQIzJXnGAGrgj+xWJA5mvkjvHn8mMwJ7Y5zIwUZMmroKYME1IPx15Qrk/yKMM4cGf
         erIWNoXJevdRypNBYZNfJT9Ru5yi41/Pj2L11vo2ZhO2mWQ6Znv2iZjGI21q5rdu4rGB
         TVFxiSrH7NN3bIrtUjaXcJskr0t2BI/croZmObypi5zc0u+9eTFo7XrAnr2XEL+rqkA0
         yLp3cGmLFcwJIiwNYs4i4Y5JgWV86BmAZSXG3mkSrtb70Ll3VEvKQBpt11OvybRwVzUm
         KlxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734576066; x=1735180866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wbb0Eg3UwwWOo11oZmbLgzoTMJnGZQROUXn+RBNp/VQ=;
        b=FBCt7QCBDiHQMUJBv0Z2d7obyrwIhCAenQOUM/cycasdlrc2Hx0LXVbLtME/t88mow
         dhqPKDeNlyqhr7hz4lfaI2Xj1EZ4KPzgmghQG2fTWcK5OJV5ew7aYAPhGxyIuN/z16Ll
         Nnm/RJT/foy87D/MQu1XvXgPYSd/Bs1JcmgsTEn5Zgkn/+niFDVGNGHigGsBZMHqjMOO
         BIEnns1JvGbArNtp5VTbfaUN2IlSzM1cDmc5z8Uae+SbJwMl7Kz/hVdE+V+oHd81aOxK
         W6LfPcPYaNI6XMhUYS77Dr7BuplVSwRXDk8HXvzygLq8JLPrX6myoUSW5A2CHsP6BURZ
         JMdA==
X-Gm-Message-State: AOJu0YzO3E81t7OvlzJ70f6aBLd1yIkmrroldL9lnoS2SqH7pW4dieXE
	VfnGoHVKQg8ofQkDQB0GjzHcTu2flPPOh/5tMrsD+OG60/zqKe5CPkG2Aett12Y+SGJPQeydVTu
	89w==
X-Google-Smtp-Source: AGHT+IEl3DvR3M/c9bCjK2ANMoW4EFH4x1PqaTfKCv68PUYqHPtTY4zB/lpzw11QdmFBnIAwBuNWFaHe5Ak=
X-Received: from pjbpa1.prod.google.com ([2002:a17:90b:2641:b0:2ea:5fc2:b503])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e70b:b0:2ee:aef4:2c5d
 with SMTP id 98e67ed59e1d1-2f2e933c2ebmr6902161a91.26.1734576066328; Wed, 18
 Dec 2024 18:41:06 -0800 (PST)
Date: Wed, 18 Dec 2024 18:40:40 -0800
In-Reply-To: <20241218213611.3181643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241218213611.3181643-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173457570836.3297396.12144430815948289089.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Treat TDP MMU faults as spurious if access
 is already allowed
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, leiyang@redhat.com
Content-Type: text/plain; charset="utf-8"

On Wed, 18 Dec 2024 13:36:11 -0800, Sean Christopherson wrote:
> Treat slow-path TDP MMU faults as spurious if the access is allowed given
> the existing SPTE to fix a benign warning (other than the WARN itself)
> due to replacing a writable SPTE with a read-only SPTE, and to avoid the
> unnecessary LOCK CMPXCHG and subsequent TLB flush.
> 
> If a read fault races with a write fault, fast GUP fails for any reason
> when trying to "promote" the read fault to a writable mapping, and KVM
> resolves the write fault first, then KVM will end up trying to install a
> read-only SPTE (for a !map_writable fault) overtop a writable SPTE.
> 
> [...]

Applied very quickly to kvm-x86 fixes, so that it can get at least one day in
-next before I send it to Paolo.

[1/1] KVM: x86/mmu: Treat TDP MMU faults as spurious if access is already allowed
      https://github.com/kvm-x86/linux/commit/55f60a6498e7

--
https://github.com/kvm-x86/linux/tree/next


Return-Path: <kvm+bounces-59584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AE21BC211F
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 18:13:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 178E619A410F
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 16:14:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D4AE2E7BDA;
	Tue,  7 Oct 2025 16:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jG7FSzFN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4471FDE09
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 16:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759853621; cv=none; b=esbegA1XL7fEHskgQ4jm8Ir6aofaRN6mh62Z9eEnfUtj3zXiUIuDjOWTXR/d9yMf5Ubsxv1n7w13rMKeo6ZWSMmMBGnUbCRKB1pezdbaOlz+2YOVBQpZOaQaRnPISpJwbdXckwSQzAQgjqLvv389SbPGCCXVNKDW37OkarAhH9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759853621; c=relaxed/simple;
	bh=76Hq9+KcZm5GgG6f6rPowJlqTFP/oNiUaWKana1uGRg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VmMHK2w9Z0WjMZBJj8bHqLegM4HdJumJOujLelP2KoeyAyoEY4ZK3ryPLAbMGrP8aGzfPuPVU8BIEk2tabjxfnd/lLyYt20LuMD6O97z0mGdy7AAOHXJw4bikrObexy/XvCesvbBZVgPjvTL2nmJFJcO2zHPxgCaFwN8H4lMLHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jG7FSzFN; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-339b704e2e3so6540933a91.2
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 09:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759853619; x=1760458419; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=m/0R1SD3VaA/2ykITD569p+LVuMnDQxYEsLsVmg+Y+w=;
        b=jG7FSzFNQA6NZQ6W1zWsB4FIBkamJg88fYZDbhLRllyIpfwRt5bFQdAJkN9KiIioSd
         QJ3KvLgWE7FnFR1Pr6TwqWywzUhDEw79pzFrYnME42LY6bFV1NIH8JdtWJO3CoCB7mDP
         EPUYhPLBixN4MppN60IlYaV/lJM2CnNhwsluKwlqB2raZSlmQwE6FZp5xgrsb8bY0Dfx
         UDd7pV6gTU1lr8CjSKRgzWqV6WCCDzgozDFy84kmcMvRu4h/MyhtfkhpVowB4Yf5aqkw
         gqHtOKvAKQyf2j20MsFeTuJ7ugG7VYAWUpAIIuFRpxqPYeYyxLJd+5INkKKIOFIBN2Aw
         y+Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759853619; x=1760458419;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m/0R1SD3VaA/2ykITD569p+LVuMnDQxYEsLsVmg+Y+w=;
        b=YfpzIqsQ2a1TNnDaW6Kd5+MyYYazfY0f8Cdyr/JgcePrC1ZbRc8prnn1lfR7eI4RvF
         xOsI44ODtZZ8/sDBydycarB00LYoZ2VsWpqEpdSu4UfUSTrLMVfAHBcK42QiYefjhOb1
         7mWya6muvTlxsMB8qXIZn9Dy4uw2+A3ZNhKwSTghLExulJ99t+5c5az4GVzgnFAve5s3
         wNGGCBAHRjaqP+g//3eqdxtKqybvj5rQ2/+tgpA0vH7Fj7q3PYGy2xzm8taVCTyywWt3
         ieVz7y+OtshmyzoFeaJwv3VhS5HZyrx2CKWkPro/mHgH6UMF1BCsSSwWpIDknWbXA+eh
         LqhA==
X-Forwarded-Encrypted: i=1; AJvYcCUSZ5jPz9E017BWCNknFr9V/slCZ0AUU9y9AshrrKmjD4TCBs7bFi3EH3ZAtoqLzBSpA68=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz76KBj9oZalfM+WRmeOjYSzYmETaExNbzJzWYatwB9axXn0fx+
	sgfxPoQ5kK3fe+jEdqiP+jGh2bwAf8uVnlH9OIDFikh1XIuvYMrGzq66iL8k04oXpS9RXQgcjVJ
	2Nvmzww==
X-Google-Smtp-Source: AGHT+IFi6jaCqXX6ipD3iFzSfYf2cSObKx2sGxvSGH0ly75WnnVzYddNut6i5GgfZdU8C9rFg/s6RmCxrTE=
X-Received: from pjhh16.prod.google.com ([2002:a17:90a:510:b0:32b:6136:95b9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3a8a:b0:32e:a8b7:e9c
 with SMTP id 98e67ed59e1d1-33b5139a3aamr71491a91.29.1759853619222; Tue, 07
 Oct 2025 09:13:39 -0700 (PDT)
Date: Tue, 7 Oct 2025 09:13:37 -0700
In-Reply-To: <diqzh5waelsy.fsf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251003232606.4070510-1-seanjc@google.com> <20251003232606.4070510-2-seanjc@google.com>
 <diqzplazet79.fsf@google.com> <aOQkaJ05FjsZz7yn@google.com> <diqzh5waelsy.fsf@google.com>
Message-ID: <aOU8MbqQ0ZnHgRr8@google.com>
Subject: Re: [PATCH v2 01/13] KVM: Rework KVM_CAP_GUEST_MEMFD_MMAP into KVM_CAP_GUEST_MEMFD_FLAGS
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>, 
	Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 07, 2025, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> >> In this model, conditionally valid flags are always set, 
> >
> > I followed everything except this snippet.
> 
> I meant "conditionally valid" as in if GUEST_MEMFD_FLAG_BAR was valid
> only when GUEST_MEMFD_FLAG_FOO is set, then with this model, when
> KVM_CAP_GUEST_MEMFD_FLAGS is queried, would KVM return
> GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_FOO | GUEST_MEMFD_FLAG_BAR,
> where GUEST_MEMFD_FLAG_BAR is the conditionally valid flag?

Oh, conditional on other flags (or lack thereof).  Yes, the capability would simply
enumerate all supported flags, it would not try to communicate which combinations
of flags are valid.


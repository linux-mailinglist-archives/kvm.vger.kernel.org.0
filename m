Return-Path: <kvm+bounces-63618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EF6EC6C001
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:29:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 229CE4E70D7
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:29:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D90731B803;
	Tue, 18 Nov 2025 23:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V3PVvovF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5D5189906
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 23:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763508498; cv=none; b=VNFdVnPJCl7Rm4li8wRwoV4b4o6Oc2cTjKAC1wc9sJARSel6y8OjvDeEkGin1IeNRCwYsaKCEVsFyIBisS7lLqsoX1Ut/+x4mETR492r51dEAnjlVRiOteGnVmRX1cfgAVPwv0NrgSV232Jn/CL/yliSIc0nvTDRtrxIxj9LkHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763508498; c=relaxed/simple;
	bh=JYIbD/xHf4kvTELApTN0Qkn6sDe5a5c/t+pHwdB7H08=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eob70IfyXbfXGOhbERVF096+zKLDWjvHDt9C5u7t20m0dOQfzwJg70JMXhTWl5AvgVGwWjvqn3TYT2pOPUl0An2Q4aQ1SVn9YtL4JxYlyvmtW4sH6vM0N7W9MLh3bftda1JbHHZtlkEP4qKgG6x0RDAtUUVPHuzEESHrXK3uzj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V3PVvovF; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-29848363458so159935405ad.2
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 15:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763508496; x=1764113296; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SSftY5ci1EGKLIUFb5TDQb6i/yPGJWA8JO8vUwt2+ks=;
        b=V3PVvovF+5jhoWT69gWOUa79lejK6YMNxB4kVxr1EhHUhadJSnhLTRKQ9CbJlQJipo
         qL6GS44Gl7/7HVbkNJcNZpPTKK6+UAlHI7oLjSeobphEgxXTPL+pt8trexuP5kP1nB5r
         kC6Ob4Yi1O5LX09kooSNECm2WbvOilA4+ICFL+0bmdDzJp4MidVi9v5xw0s3dix3XPl9
         600lBNetSqrQhANIyrOui0c6H34zkCXUtZQagh36dC0sZ65TrGIfKaKZ5WyD+9x6qKez
         opOWQqgPr+kCHLAwC1oGH05Xinv+9uvNz849lSkltI0ketPP83gTa/G7+uLDVhP2oF7v
         YmWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763508496; x=1764113296;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SSftY5ci1EGKLIUFb5TDQb6i/yPGJWA8JO8vUwt2+ks=;
        b=MROlgAnAHV9mSkgOzE+lUKlsJxOIQaQXAwTE2U+NyoImU13Dh14HpjbrnqJiXf4xy5
         eAGU6vJcheyx6bs+hCrEz6BNS1Cv/pafbrLGK7DTG5nyxsjahG0SdzivtsC7mbOc3iqx
         jx/GqycnV8lUzR16c+3TVHJiUZI1ozAXYsgvjRfOn8Wh3cm8bICLE3dye57Ld6WkgpHA
         sjQxrQs/ZpiEfE6CdM/XV51MHQmCfmGnLrf3PkmfU2Kw7Y5kteY/xgldB7oJIUj4fZFc
         7Q3zBc4i1h6gS5/zLpALkHO8/hOEWBimNUx9fNh8t/US/VC9Ln77G0aZvHs8y9SWQjjd
         NjoQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4MWZ+Q7wh6wLXSCNmHLj+uXnO6o4YaABoaorU8JMq6T+rfwJPgDllpfJZ5IOaW3S/ZTw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5CLBNzas7QU6irBBhmbkVQsXyL+hr+BoNMFDN9CjsCDFPkLo3
	F2RT7JxnqSwOjyCQjqmTN6cfn1irQgnwPraIaUhSquE3Wyv333qVr0Nl1lnUsri/SZXQHRiBqEl
	1RxtCLw==
X-Google-Smtp-Source: AGHT+IGn2JswFn4UeOAKifKE9H8f5r8980lrAWB1rQnFeljdA8CZmCPwX9Z+MUOeK8ZXWSwcX3f1f+kkIrA=
X-Received: from plpw11.prod.google.com ([2002:a17:902:9a8b:b0:273:8fca:6e12])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2f0e:b0:295:8c51:64ff
 with SMTP id d9443c01a7336-2986a7420ebmr202776415ad.29.1763508495956; Tue, 18
 Nov 2025 15:28:15 -0800 (PST)
Date: Tue, 18 Nov 2025 15:27:48 -0800
In-Reply-To: <cover.1761593631.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1761593631.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <176350811296.2284106.5037458299764023896.b4-ty@google.com>
Subject: Re: [PATCH v4 0/4] SEV-SNP guest policy bit support updates
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	x86@kernel.org, linux-crypto@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"

On Mon, 27 Oct 2025 14:33:48 -0500, Tom Lendacky wrote:
> This series aims to allow more flexibility in specifying SEV-SNP policy
> bits by improving discoverability of supported policy bits from userspace
> and enabling support for newer policy bits.
> 
> - The first patch consolidates the policy definitions into a single header
>   file.
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/4] KVM: SEV: Consolidate the SEV policy bits in a single header file
      https://github.com/kvm-x86/linux/commit/ce62118a2e48
[2/4] crypto: ccp - Add an API to return the supported SEV-SNP policy bits
      https://github.com/kvm-x86/linux/commit/c9434e64e8b4
[3/4] KVM: SEV: Publish supported SEV-SNP policy bits
      https://github.com/kvm-x86/linux/commit/7a61d61396b9
[4/4] KVM: SEV: Add known supported SEV-SNP policy bits
      https://github.com/kvm-x86/linux/commit/275d6d1189e6

--
https://github.com/kvm-x86/linux/tree/next


Return-Path: <kvm+bounces-60092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id BAFB6BDFFF5
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 20:07:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A1DD44E1D75
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 18:07:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C67733A014;
	Wed, 15 Oct 2025 18:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k77Pvm3u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E133301477
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 18:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760551590; cv=none; b=gvLJsrksXmnkVsFe3dHbX+KrOy5USfpD+3Wz7GTL7Qhg8/0rGlLXM2LmPEv/riyDgBHsamLPRHhbjFq+LzuHy7DPIBH1NCjECbDxZqyrBydKJeCBdF8fkEnPKbIZvUSZZvqkeXQd2mzDe6hBGPfm+3/flNVqrlSv7lufC5Fn8Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760551590; c=relaxed/simple;
	bh=jCQT9rzR0PGk0TwlODkGp1o4DOlgrfcR726BSpIb9+A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=U0eEyJ+afdVOVA44UwdyOcuEGrhhMaE3c7lHa88t+08kHlBPpbAJBBbRR6a/z5T5uxT3JUgFJ/qO6w13Esb6rE0vLbPMxkgEJy1O0X7ZjpRmnyFBRTQkTITwPdYnmkVVD6N8ZJYgMZhfypgGoMHqS13bk6sjzYHn5Is9kl2NYYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k77Pvm3u; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-286a252bfbfso262211165ad.3
        for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 11:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760551588; x=1761156388; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kfndc0ENoTTfepY9TJZDH63d6SpRDMFgibtbVYkYO9Q=;
        b=k77Pvm3uHy7lx2jlytJ5SLv7+JRewDe16CoFZKLuUS8umrFHPZFpgNCvx5nf/cAOzS
         sJDTw/SWR7VdqIjiWOSUCSyt2Jyo51vSPEjLzEKW2NkzUNBQFrhprTJxxRcfJO71iDf+
         vX6jlOEXptTBk/u95OtVcju5KJ/8NrnxASw+LMgZoKMyFmJimqdxO9qNQf6T6xCCWkF9
         OvPxlah/P1h2uev6ugLLoYfWx464q20gUKfR3VGpOGkKKvn0vRwkazShK2Eux8Z0aB0/
         HMifCyN/y3qGl0wWzoKElOG9yUdnun654wsvbDKGJKB4IMTXvrKFLDsXXdeHz3vrEr0h
         txYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760551588; x=1761156388;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kfndc0ENoTTfepY9TJZDH63d6SpRDMFgibtbVYkYO9Q=;
        b=Jjb0PYI1Bx6QUom6/hVARFdByFzgna7OuwIHTZlA3RRhyDjf1eEIENCnp2uJwbQuoT
         oc8N+FLTEfpJ/8Lm2pO6Q5oKeeL8WuTgU03MoNCieshI3fgogUotGvTxudEnD8vNgSrC
         ptwsBSemP3/4d0oX1QkJ5FJmvxadJFAtLdcK5q7LwqeBpNouUyJ0rJvnPRDsZEAB/isa
         Fu5xsn6/sR7nrT8ndkSRxCtMzT1oNvRzZeFGwoKsrzw5SVXnRNEnkcnT/y/dmWPPL6O6
         fzUPxoLc4UvsLdJnZGMZaDASdJkadsny84wk9N5sJXxAe3iYQ1FoZJ8tPZFHhPfY4gEy
         OpPg==
X-Forwarded-Encrypted: i=1; AJvYcCXGnwgRHjS0tS+xSv7Zzzb09pKzhzIrUJaMDI0fppyzrD0AoQJ9q48IKVBwlbVoan97mEQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVX+ouJfnKSumIIOpPSDiKlWv/06zH2VvDqy8k4tChQs0X+D1W
	J0KpRx1jT/PPr/8pLjXnUAZbBNhX9uwXw8C8hL5/pc+F0s4L8QHKNoZU2z+EchUjTVnPk55Yiy4
	7keBRbQ==
X-Google-Smtp-Source: AGHT+IEFikS4cpk1gJ+ktd6gIEZmHmDT2uGZui1IjDGD50V9+QyIzANKYLSdF5afaqE0Z1KaLae3FikYyE0=
X-Received: from pjbgc13.prod.google.com ([2002:a17:90b:310d:b0:330:49f5:c0b1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ccc4:b0:250:bd52:4cdb
 with SMTP id d9443c01a7336-290272c1971mr327416285ad.32.1760551588419; Wed, 15
 Oct 2025 11:06:28 -0700 (PDT)
Date: Wed, 15 Oct 2025 11:02:52 -0700
In-Reply-To: <20250922162935.621409-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250922162935.621409-1-jmattson@google.com>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
Message-ID: <176055125879.1529816.3450355285833031488.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: SVM: Aggressively clear vmcb02 clean bits
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 22 Sep 2025 09:29:21 -0700, Jim Mattson wrote:
> It is unlikely that L1 will toggle the MSR intercept bit in vmcb02,
> or that L1 will change its own IA32_PAT MSR. However, if it does,
> the affected fields in vmcb02 should not be marked clean.
> 
> An alternative approach would be to implement a set of mutators for
> vmcb02 fields, and to clear the associated clean bit whenever a field
> is modified.
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/2] KVM: SVM: Mark VMCB_PERM_MAP as dirty on nested VMRUN
      https://github.com/kvm-x86/linux/commit/93c9e107386d
[2/2] KVM: SVM: Mark VMCB_NPT as dirty on nested VMRUN
      https://github.com/kvm-x86/linux/commit/7c8b465a1c91

--
https://github.com/kvm-x86/linux/tree/next


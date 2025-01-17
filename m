Return-Path: <kvm+bounces-35713-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 92A9BA1475A
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 02:08:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCE0916B564
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 01:08:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F3DA13C9D4;
	Fri, 17 Jan 2025 01:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PhTgw1gz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F227E765
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 01:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737076049; cv=none; b=OavfIVwvPQT4hIXEQOCGSZLZdnDuK19rXu5pgVNaVjisA+RHSg4aZW6vwlKOOKGwe398C1/4gYfF9nigpqpfXzKvJosEtJs4mvTx7o7/i+9hHbU1FYbpHpmgtSdyD/asO89z2hesQlzQfKPZs09EL4K+TQVv6e4y4pYOE3xVd2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737076049; c=relaxed/simple;
	bh=yd2TjaiEyw/6MJ80/Yw7+Jnn6sDGbjfEJnbnIijw+yQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=REhDw/M9oTCf07mtm6AOClCg5Kwu81t8YQc7PyF7AqSBlo8b0FHRQaQNrDAF2MUn+ojaxCPhpXEMJC9RD3zDuV58ACsXn48cNrbW4T69vdYcz3Yj4IjLrRFQX04Pc+ktoJr9OlOtjrzdxUDsXNI+WvhHnHFep3p9N2eFnwOIDHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PhTgw1gz; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef7fbd99a6so3103348a91.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 17:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737076047; x=1737680847; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RbuVGyupY5o94VOcM2qrZJ0cJlEaZmURUnrwEaLkFpU=;
        b=PhTgw1gz8ycmWtAH3sneMlLRTgXwZKeuB2tTDdWHPxxNHjsHAayAPhE2QBAIWwEODk
         ciDOc4QUOW0IU5NgDuBDt/rw6cHQqDruucs0ovHOb8h3jD95hf/O50rLQMhAnwyyEODN
         P/EfipIKiRXmIIbjgJBzAt6/mV6q83yqZMJIKxVmi4YoUTQ2UYxN+LT+0ujKnnh9X6ek
         0UMVzRWp6nQWWKlnUJ2LzXhmkbnbe5LyHR5e3QyNwSb+hJ69OmN2AzPGgk/CxDLAcZx9
         8GsD2sJ8R+6X0Y5ZRIcN/inmlPoMoU01g7Z2cni4zvx+Mx+8sQiq/JX0N9zmOKrwm/cx
         RySQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737076047; x=1737680847;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RbuVGyupY5o94VOcM2qrZJ0cJlEaZmURUnrwEaLkFpU=;
        b=JA/d4cmT+1W+vihz63EFUA+HqXAdNvawMXoDEyjJjQc70B3IrQneH4wHY311z44Zaz
         ou/gOT+DdRFwarsO4tm0DicZs+0qufLSvSJoavhWfEXr0KvT897THY07SScBTAS8F/0Q
         qDq+woIT7Z6Sr9zB0T53QnUOg3lvXbLhrZjtA96y3pXhKIGJucH6nRR9rOeLUfxpuEHC
         OSYo0DCSheY0O79gdX4KETfC/LQWkngEskPYWP4VMZSPQc9fLT7SduqEKfN6RPnRXvj2
         chNscdtFbeOmFZwBNtZHSDbZ3F6HPowT+tBHM6e2KQ5kJXTMndf3qtsh6kRlJ8DFE6ep
         ZbOQ==
X-Gm-Message-State: AOJu0YyoBoghscZxwdiejmThrnOPh1N8nAHyiDP4oWe1aY1/JAmF6oeH
	lB42P1mcYQ+JQyfJjM4jTYZSEp9Iu3ALxA5He2UMtiN9TznAjjyNLqdJalE9q/pLSgifL1GsvDZ
	Mxg==
X-Google-Smtp-Source: AGHT+IE3F/7rb6FVOj0nBAd4Wchh8+35BzElSC8Czgs6XgDR2r4iCV70THjdYWzoRDkf4NX+ES8LkofYLPI=
X-Received: from pjbcz4.prod.google.com ([2002:a17:90a:d444:b0:2f4:432d:250c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e06:b0:2ee:b66d:6576
 with SMTP id 98e67ed59e1d1-2f782d8670emr953077a91.30.1737076047575; Thu, 16
 Jan 2025 17:07:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Jan 2025 17:07:14 -0800
In-Reply-To: <20250117010718.2328467-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250117010718.2328467-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Message-ID: <20250117010718.2328467-4-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: MMU changes for 6.15
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

A single lonely change for MMU.  I was anticipating landing James' lockless
page aging series, but I didn't get to the review until too late in the cycle
(it's looking good for 6.15 though).

The following changes since commit 3522c419758ee8dca5a0e8753ee0070a22157bc1:

  Merge tag 'kvm-riscv-fixes-6.13-1' of https://github.com/kvm-riscv/linux into HEAD (2024-12-13 13:59:20 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-mmu-6.14

for you to fetch changes up to 2d5faa6a8402435d6332e8e8f3c3f18cca382d83:

  KVM/x86: add comment to kvm_mmu_do_page_fault() (2024-12-16 15:27:34 -0800)

----------------------------------------------------------------
KVM x86 MMU changes for 6.14:

 - Add a comment to kvm_mmu_do_page_fault() to explain why KVM performs a
   direct call to kvm_tdp_page_fault() when RETPOLINE is enabled.

----------------------------------------------------------------
Juergen Gross (1):
      KVM/x86: add comment to kvm_mmu_do_page_fault()

 arch/x86/kvm/mmu/mmu_internal.h | 4 ++++
 1 file changed, 4 insertions(+)


Return-Path: <kvm+bounces-44366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1661A9D531
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 00:10:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9328F4C25B7
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 22:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32961235361;
	Fri, 25 Apr 2025 22:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="daJe1wps"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0775C233153
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 22:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745619035; cv=none; b=BsUVyaF8VLMg3IrwgBlPlDOMsUM9HdzhkrubhKrNpMDzrI/585Di7YN27VGRfdf3iFxH3WHTPuZx9Qtiau/1s0fnQ9DdVJdYgNwvmO3QZLvpT6vipvUlV8ort3YB4Jdes8igZSJPtz4/Vtj+pL+D86UeTC9E++Fexbp2xFmO2n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745619035; c=relaxed/simple;
	bh=aimnY6tUnV94o9RMhPjhm6dvNWiap2zaXUs78GC9ue4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UKqSVes76Qd3weFJAyfIkOt6//SAgMJ+bRFgoNpa+D00etY7Po9MlrgF8pwezrZ6dIGec6qhT4TekkqsBmJZPd+I4YpCVEAwnbY6x3mHH7wiWJ2xZK2mpmuNGFPNipkBCZSyjTBuYIra6vaPqDE9q9yZzNtWwR7QHjWvQL89br8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=daJe1wps; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff8119b436so2175042a91.0
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 15:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745619033; x=1746223833; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N4LgaQ1GuAUWP/kw7PddvzqxjqGh3o+JtvV4OkUBUe8=;
        b=daJe1wps1Ozklx5W+J2iyk0OddGhNcj5xcZ9HN4J1U6ZY62U0Vi1+hofDXtPL9OciX
         4rflYit7WXV8QWNj5dghU40uqd0bvGgtx96H1+BwzV7wUSTmHYJMQ697eqJhl2cSqbMW
         R835WVWUb9PgxKes0TlVtwiBhKk9OOyR9UPKsAl/AX95chJme0LJdC2tkz+BYxvSve4D
         leY0nnuSK2+uWKh+T4vzTsn/hDYx6spTeEvY9QMnGbMWc+D7qYvAzHwG5cNxtRPWX1o+
         lNAChxPAuz7BDWOjsLC83BkLNc6S1tn7cVTCzc5bzmd7WCKT6oi3MbuvYYpqU0AectHF
         kt4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745619033; x=1746223833;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N4LgaQ1GuAUWP/kw7PddvzqxjqGh3o+JtvV4OkUBUe8=;
        b=aBU5LYEB0ncVvzypo0OViXAc/uP3SXp9C3aITz/4qXoh/d/AheR5F6rd/vS8zoAY0N
         l++fopSNz6FSrFdJV90xcVeNFhHzeaNWNBqdKHbsmfNLBIZaONbqOZ0JgJC2gckI+DcN
         gEg2MsDP4GAi9VuOXObE3Ew57I9FWegs29AWhgIXbpfjCTTG7GKh3+O6TGnSMal0Imi6
         jr1PJNqfGJVvObqkAIAwCmw3FuRIwtI0Npo5i5sQnmzk0pjW4isEaMDlpigeABAnaDfe
         zWQO6Uzjt5M1iWTZfz3xGMmooSfO2fYvDNyWoOmJ/uSh7evRet++k17sgCZY7NfE7I2p
         UIfA==
X-Forwarded-Encrypted: i=1; AJvYcCWWIUfD9pa4mM5QHVwzIXcosxuTgSVkh2mJiG7Cdac8nDHSt/kIzMkuOBlzo+1QnMX59ss=@vger.kernel.org
X-Gm-Message-State: AOJu0YzN4QM7uojk2Vc1B1ieKklgWMg+1MrA9qmpqxrFC41L7zsnS+oO
	UBfvnHUbew1kH5gx4MWFTyp4b/fzJSn2ho80CLfoW2oewBicIB9ArU52P5eDx8DhGJ6yXUXNHe7
	Qdg==
X-Google-Smtp-Source: AGHT+IHcSOCDilduu6zKy2qslrDSQQbZGnCFwZnVCF+4bEL6G4X94qzFQSwcH21tq4LeS9ZdDdCRP63DyQE=
X-Received: from pjbrr7.prod.google.com ([2002:a17:90b:2b47:b0:2fa:2891:e310])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4cc2:b0:2ee:44ec:e524
 with SMTP id 98e67ed59e1d1-309f7e8f6dbmr5194411a91.35.1745619033277; Fri, 25
 Apr 2025 15:10:33 -0700 (PDT)
Date: Fri, 25 Apr 2025 15:09:00 -0700
In-Reply-To: <20250324160617.15379-1-bp@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324160617.15379-1-bp@kernel.org>
X-Mailer: git-send-email 2.49.0.850.g28803427d3-goog
Message-ID: <174559664970.890368.7017242957436567888.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Sort CPUID_8000_0021_EAX leaf bits properly
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Borislav Petkov <bp@kernel.org>
Cc: X86 ML <x86@kernel.org>, KVM <kvm@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, "Borislav Petkov (AMD)" <bp@alien8.de>
Content-Type: text/plain; charset="utf-8"

On Mon, 24 Mar 2025 17:06:17 +0100, Borislav Petkov wrote:
> WRMSR_XX_BASE_NS is bit 1 so put it there, add some new bits as
> comments only.

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Sort CPUID_8000_0021_EAX leaf bits properly
      commit: 49c140d5af127ef4faf19f06a89a0714edf0316f

--
https://github.com/kvm-x86/linux/tree/next


Return-Path: <kvm+bounces-37910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C9C6A31490
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 20:03:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E93D188AEE6
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 19:03:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D8B2262D17;
	Tue, 11 Feb 2025 19:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="q+9jUF1d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C59F26139F
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 19:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739300615; cv=none; b=Is3K7wuVa1b9qWDvHBFtS0+++FqssXYOxxaE2g9T88ND+VdrPwFsUxa/r5TlinS0hjk1mME8dR9E3iEZtYiqGMHJ9HZfZ7WhN8PHYUHDJymsxrzBm6ZlgRVg7fLlZZ8HWbcyHVTkFOqoh3LuCUL2z9Bg7z6D+JuAIEehhjG2BOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739300615; c=relaxed/simple;
	bh=aFRbjSre0n/PpbhfPdOu1q5jYzsALXfM3ldTnjaDe4k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y4rrr53aFYfHPWOc8+53iLtYdjuSYnz3Lf1zQ6ZK3F6GqqHoLWWCIZ4ZyH+tyY7RMXg0/2O9XSupZixQTy4ZqIYoKYlqc/KQTfEYITatIqXrjC/A+h8+aAfbNYopohRphrcMhDTOz/HZgZ3B0ckPg76govdrb2h+ZD9m6jUd41A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=q+9jUF1d; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21f68852b7bso128774985ad.1
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 11:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739300613; x=1739905413; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X6RZHwu8fSUx1PRlASdGoMqhsw6pMz1JSKazfVdmFy0=;
        b=q+9jUF1dp8fOhBh0u/9JltV1yPnW1ywnhgEDOTJFIe1TtXi+JNS56XKxP3IhbTSKcM
         MN7HL26FTuOzviCSghyORszxraETEmkLudxSBdFPFni3qpqXJCU8wMtqTHb8i+kEmsnE
         Nyv7CjaJPqZg4akjmcXLBTCGiutIJ63iLfLNhNGGhycg8y5ZCBtn5+ZZDKo6CoJ0VvFD
         e8ZCSh1lQcHJ1pFvodN/qzGB4Wo9LsxI/z/ltuDmnloTCCVCTQBhbotAmwNoClrinkqt
         1PYP5SVRqyOoSD3wN6A4lUx+VBD2Mar58hlZCMbIenvgRNgloUHjl2klp9fW6fRJmgjt
         fhMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739300613; x=1739905413;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X6RZHwu8fSUx1PRlASdGoMqhsw6pMz1JSKazfVdmFy0=;
        b=HKD5JyigyLZ8nnJCdFApXwd7X+E7YVZX3eUAZ4SQgFxRm1saAPWNghBjhYxxthlWje
         3xaBHvyfe/+2gWtrdGYT3ny1FdnwVATs2K4N4hc0/TP1GAavk0tS7fb2OIJ1fLheta+5
         iK4B3hSiZERWy+xZeoVAHin0Ogy/QJmTtytFMJrC5KAixRSbxnVAFvrxkjCd1OkVhW0J
         jKI/RIFJqXpTLCdq2SGmECde0IvgwT74ZR+lesOvR6YHGhGr6F62l0KoaptvIPgefge0
         h6cwAtXpsEcGPewcCzgUsP9FHXsDU1u169r2fwB8dGHNVQ+KOkpbey6xvG3hNzCrp7+2
         oCqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXd7tDgb0x9RpyZeOUV2WXeZDtj/5zYsxhVBCv2xzIf0owHxpLNTaGBvXRBHyNYWyS8BVY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxV8CO9DhP7GQzYpgsWN257xMCPPlh3MEQGLqci+Z174YDqyrX1
	UWdEW78nDj4VB4Q6pk4Wc+Lfe4Yn9AEKTecTgUGEDgHwTICRB9dAKk3FgyiQ61+y9ol1XwtjNyT
	zOQ==
X-Google-Smtp-Source: AGHT+IF83FAVS6JbAJzhSAAsNQR7sGHkfYmlENylg6JcCsQBTAIdcwm5DyQRH0pv2Gc0GyUcz7M5iSbKK64=
X-Received: from pfbbh7.prod.google.com ([2002:a05:6a00:3087:b0:730:7b6c:d5d1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:258e:b0:1e0:d6ef:521a
 with SMTP id adf61e73a8af0-1ee5c732f01mr650938637.1.1739300613311; Tue, 11
 Feb 2025 11:03:33 -0800 (PST)
Date: Tue, 11 Feb 2025 11:03:32 -0800
In-Reply-To: <20250211184021.GFZ6uZlZWPVTI5qO1_@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201021718.699411-1-seanjc@google.com> <20250201021718.699411-2-seanjc@google.com>
 <20250211150114.GCZ6tmOqV4rI04HVuY@fat_crate.local> <Z6uIGwxx9HzZQ-N7@google.com>
 <20250211184021.GFZ6uZlZWPVTI5qO1_@fat_crate.local>
Message-ID: <Z6ufBMy4u0jcmIl0@google.com>
Subject: Re: [PATCH 01/16] x86/tsc: Add a standalone helpers for getting TSC
 info from CPUID.0x15
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Juergen Gross <jgross@suse.com>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Alexey Makhalov <alexey.amakhalov@broadcom.com>, Jan Kiszka <jan.kiszka@siemens.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-hyperv@vger.kernel.org, jailhouse-dev@googlegroups.com, 
	kvm@vger.kernel.org, xen-devel@lists.xenproject.org, 
	Nikunj A Dadhania <nikunj@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 11, 2025, Borislav Petkov wrote:
> On Tue, Feb 11, 2025 at 09:25:47AM -0800, Sean Christopherson wrote:
> > Because obviously optimizing code that's called once during boot is super
> > critical?
> 
> Because let's stick 'em where they belong and keep headers containing only
> small, trivial and inlineable functions.

LOL, sorry, I was being sarcastic and poking fun at myself.  I completely agree
there's no reason to make them inline.


Return-Path: <kvm+bounces-52554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 679EBB069D9
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 01:24:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2BCA3AB80D
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 23:24:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F36602D63E6;
	Tue, 15 Jul 2025 23:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EGCpR5Dq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAFA2D46C7
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 23:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752621868; cv=none; b=HhbaGXLLPFK9r9lUAUZe2lB68jqhslj7m8eP69qiL6+89kcU/Vz+5JyuLgi8/3195nbP+OAMdzijoiA49lE0MU7+5yyoBh9Coz6vthZb0ud4r32gkQWmtKwmgDGUlv6dhQnF0iFv/AcsPO2Mpe+GECXlVQreyzse8jOPGuOPbh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752621868; c=relaxed/simple;
	bh=nq6i7UWsrChHFspcpqg8vmXlrYiwDO/Qz7sfzZ29Fgs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rOF270ejp/a8oQtY3DnaiVkFbjCxEd42sRO5t2c9cGcPYj46PNb+wp8F4tYoJJD8vMLTfP0/hQPDz9PSSFrid7goUDq/z7zXVQJ5W1J+R5dsZaz9XaicBUkX1sz8bXl0YZjoza4gCov00VaA6t5fAy7KJAdhdcIm8FKM/uikQKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EGCpR5Dq; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3122368d82bso8627752a91.0
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 16:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752621866; x=1753226666; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=975PH/shSeR0AqFV7Pd5lI4L1+eV8i/9w38Uuqw+Whw=;
        b=EGCpR5Dq85Oqro/C2PkvWSsue+hQR6p1oaXxS9GigJ14LFIM0Iy8+sXwQvgDxL5aAC
         kWZAmnizbKjuO8nWRxL3fmFFIIesSDD5gN2ubrQ/SEJJ+kRXirE+639QVjLTv7o/VChj
         siLmLbpPoqbAb7q99Vg6rIoFJ0h+sElobIYRe4lzCqkYzp8pyp9aCh1wxDRf+OnZLLaX
         xbfy1NS82JC3xNz6rT+2LglwBTk4/EBwWnFQ0caf3Vw2mhUebf2NRaX67A6Ujrwms/pG
         kbhk5EBcg/0Zh/xspU76mUmVyZOKGIw9b6vNTPHq5KGUK5g9Wq4mYQ9kSnNoi9yB28WQ
         67Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752621866; x=1753226666;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=975PH/shSeR0AqFV7Pd5lI4L1+eV8i/9w38Uuqw+Whw=;
        b=TqUnbmX9gTOKEcMbxqcOBOjeoIIQ5UBvpJwKkwWn4V0/tboyvC+dWPOsg1WdWls3vx
         ln0wbtta8VRHWJYy9UZ6k4SIfeG56vITaRJyfrjlL+BSS9/fK89j6wKPLvWUJG5oWp+P
         5LFJm+Fr8yv7FObNQR15PAGfYK8TfVeM28NPXS+VbLF7TjtaylUQxCY8OOY9D8LzDRcs
         vmNx42zT+3xUtB/q+TZSfY027VfULJn9KuE2HG9UuLq49Iu43R0iJEu8COauzNY7pkkw
         xclRTb0iEf9zEZbdPYvefXKJlINha+BJsa4cBUJ/O8RLzP3FgjSv0HzeC+eMROpwAcgx
         WrPw==
X-Gm-Message-State: AOJu0YwNtUpEiBOJErXcTQwwhlcdvO27QcBsXuB6H40t8oRY2bBD6Xgk
	UlrLdqcccH80S+6WWL6Jo2TrvxF+KNyLA822SrfMOzR32zGW3mOPWUmuFUzBjKFY769rWT23+wH
	WentWMw==
X-Google-Smtp-Source: AGHT+IG5Zjbdlf9KDwHnS2wt9su30n3/ohIFoDKHlCcpDxi/IzL0dMDtTweTGTBWrQ0Ul0Zzj5WG2JG4hxk=
X-Received: from pjb13.prod.google.com ([2002:a17:90b:2f0d:b0:313:246f:8d54])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1fce:b0:311:9e59:7aba
 with SMTP id 98e67ed59e1d1-31c9f3ee951mr736995a91.2.1752621866253; Tue, 15
 Jul 2025 16:24:26 -0700 (PDT)
Date: Tue, 15 Jul 2025 16:24:21 -0700
In-Reply-To: <20250714221928.1788095-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250714221928.1788095-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <175261351809.1924612.2322752513285300165.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: Ensure unused kvm_tdx_capabilities fields are
 zeroed out
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 14 Jul 2025 15:19:28 -0700, Sean Christopherson wrote:
> Zero-allocate the kernel's kvm_tdx_capabilities structure and copy only
> the number of CPUID entries from the userspace structure.  As is, KVM
> doesn't ensure kernel_tdvmcallinfo_1_{r11,r12} and user_tdvmcallinfo_1_r12
> are zeroed, i.e. KVM will reflect whatever happens to be in the userspace
> structure back at usersepace, and thus may report garbage to userspace.
> 
> Zeroing the entire kernel structure also provides better semantics for the
> reserved field.  E.g. if KVM extends kvm_tdx_capabilities to enumerate new
> information by repurposing bytes from the reserved field, userspace would
> be required to zero the new field in order to get useful information back
> (because older KVMs without support for the repurposed field would report
> garbage, a la the aforementioned tdvmcallinfo bugs).
> 
> [...]

Applied to kvm-x86 fixes, (with the typo fixed), thanks!

[1/1] KVM: VMX: Ensure unused kvm_tdx_capabilities fields are zeroed out
      https://github.com/kvm-x86/linux/commit/b8be70ec2b47

--
https://github.com/kvm-x86/linux/tree/next


Return-Path: <kvm+bounces-65364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0502ECA88F5
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 18:21:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CDF19309A433
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 17:06:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 421B334214F;
	Fri,  5 Dec 2025 17:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rQF5bwLC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1B734B190
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 17:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764954031; cv=none; b=d64VDk7xLVYDwbD2vmA44bFhxYhlapywf9nV6LfWE2gb1YWbkoEdDwbEFblVRWy7RwDAozvjfm3kFTWKoD3AlZco/Cp3ieprKuvT/6WEYcJQt5tLTGwFcR3yxrGLRR/MpXBOg10myIOq8YGQ1OhjiJZ5cmH3onueiAvQcCVRNlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764954031; c=relaxed/simple;
	bh=pJ8yFcPnJVTemBH5LLrP0aRwqGd9ZLrLD2YAijIxors=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=K4Kinqg9PFY8gmjZb25mYmN1LAQw0v/1K8PHgMv8d+j9IZaAZjnkIzheGf9OGlttkl2Hz8eq8gAPUZR6WiLnhF31iiw9TCfxCbQrPtnJVnOmAcSZzbkxZIuLbI0xbNbYWVLMjwT6jve/nf+34f3JqIurqyCyGCEFRrP6k9Jp0YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rQF5bwLC; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-bd74e95f05aso1961385a12.1
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 09:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764954020; x=1765558820; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j/nv/S0AF1aww/PpL3h7iNG9Cj3Ek+VrZ+ocMBY/e3g=;
        b=rQF5bwLC+hNbcM/gV0+GFAmEblmsbbhI9e5obXCSbrcayizSH+4XDatnwFsikanSKS
         7o2aQ6GfnZKuotKTwdHI86KuhEL4R7YKeRQ80+9jGTPNnQsjfSxvwZNOlOsAlOre6znK
         5PZbF7btaVYHBODZ7jfXekAMZxuVadAogL4qZ/X3Ofz4sgL9X6Usf0eIGVdjtavaRciL
         xdJB3vVMc/XSD+xZTLAxB3wMrNq00vIePp75djSpNeYFnvDwpAguqGO6G1ImZ+A5qGua
         CUTzYBLMNJARtmPySWlt1o2041D/E2zWOOcqO/lY3NaT75r0CRXao712POtflh9pqpav
         PH6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764954020; x=1765558820;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j/nv/S0AF1aww/PpL3h7iNG9Cj3Ek+VrZ+ocMBY/e3g=;
        b=SchSVUGKJmWXRcb6Ff/plKzEwZpiLhpjeswpr8p/crgdGWs9yZVWMdVhhchQC8TYJI
         Nh0pM17RdBP1eGBQn0DgP+VMYpNrgK98BYpQqObavjZg6OgbtSPOnjjMvlrNg69dJ9ug
         ZAU3oDhjEnd7kPxXAGursUSWXXc75/X4SuXBOzwRm2zI2ZNgeGiJcwaMaLaL1togkRat
         yvNZsPbGZCaiFuAsWNsuU/SrD1bEphJRWMTUm3kUZOxyso/S/x1uNxGOJBOeoZaA8+L/
         KYTVBcYfNf3xJcXL0HERdnDO6t8XRTphVFyPhJlHCsVJFb1auq+fbB0tz6q63i5EX+hJ
         l+fg==
X-Gm-Message-State: AOJu0Ywh6MRm7jGiHEEnX7Sp+YNmU14V4sLWj1brSejBfjTNpIJG/xKW
	2YAp6F2goiRQp+kFYDe8OGEBDfgQg2Nvt68HcU4AvDHD/3l5pXIBJ265KqzMW/OxUYzQY+VETiM
	rGn2Z6g==
X-Google-Smtp-Source: AGHT+IFYjMQLTRpb/CMPNwPd79bJ1+pRxDeYiCcgaN7JU4cjSSguLVy9KKfRzmOTpZ9lCz6rJb8slQ9scnQ=
X-Received: from pgcq11.prod.google.com ([2002:a63:750b:0:b0:bac:a20:5edf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:72a5:b0:364:14f3:a5b
 with SMTP id adf61e73a8af0-36414f30ac0mr3768954637.2.1764954020258; Fri, 05
 Dec 2025 09:00:20 -0800 (PST)
Date: Fri,  5 Dec 2025 08:59:29 -0800
In-Reply-To: <20251202015049.1167490-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251202015049.1167490-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <176494721851.296449.6639753862362613097.b4-ty@google.com>
Subject: Re: [PATCH 0/2] KVM: x86: Do runtime updates during KVM_SET_CPUID2
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Mammedov <imammedo@redhat.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 01 Dec 2025 17:50:47 -0800, Sean Christopherson wrote:
> Do runtime updates (if necessary) when userspace sets CPUID to fix a bug
> where KVM drops a pending update (KVM will clear the dirty flag when doing
> updates on the new/incoming CPUID).  The bug most visibly manifests as an
> -EINVAL failure on KVM_SET_CPUID{,2} due to the old/current CPUID not
> matching the new/incoming CPUID, but if userspace were to continue running
> past the failure, the vCPU would run with stale CPUID/caps.
> 
> [...]

Applied to kvm-x86 fixes, thanks!

[1/2] KVM: x86: Apply runtime updates to current CPUID during KVM_SET_CPUID{,2}
      https://github.com/kvm-x86/linux/commit/e2b43fb25243
[2/2] KVM: selftests: Add a CPUID testcase for KVM_SET_CPUID2 with runtime updates
      https://github.com/kvm-x86/linux/commit/824d227324dc

--
https://github.com/kvm-x86/linux/tree/next


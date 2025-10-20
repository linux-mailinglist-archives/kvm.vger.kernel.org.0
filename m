Return-Path: <kvm+bounces-60543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1588FBF237E
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 17:51:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 02DFA4E7E51
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 15:51:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22B792765FF;
	Mon, 20 Oct 2025 15:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rl6jrsIr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C434F275B1A
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 15:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760975485; cv=none; b=fUc3uosRCjkNVlVZLuESwpEKZDFaE62cT784F22MINletoenYAY6VQ4P/yzfFnRZhe4kMBSvS+Tl0GzCc7Dz+avPTb12GLcubZhqWEajT67JzxkPbQBbMWLNzeTWArET7KCwdL1ejRIagTshveUvGcbqVK8w7mkXPRERq8X/1T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760975485; c=relaxed/simple;
	bh=r6hW6C8nu1blcYXCTHjsVd9dGnFnuGkfu1pr50KdNOE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HmnEU13jwhrfJdPQyYHXQXq2gwpKiZ5Piq/D0XLip2SutGNhwNbgS8cL0+jWcWbkxODDIqYr3KfufwUSTERIn/2djwXLXioLQtGOD9gbQsqcURU3m6fMX4hlEkMdmay/cRE40mFRVH7M6ZSLSNxKJDG3Q7BdRqFHQ+8JVk0sCM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rl6jrsIr; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-28e538b5f23so50245345ad.3
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 08:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760975483; x=1761580283; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U0BnniMqbZE4aAUiItvL6YB9ZDrqDRkHOgLhpY4+LF0=;
        b=rl6jrsIrw958+RrTmf/+OIhiYnOOD97+yRXZbnHwxpcKD66PFkHMZdR86RGoPfyWUM
         iv47ShbC9aumbirgt7/ZpQax3yXSn77Yx3bEy7mLUGIJOOWtwJjnVshKS91LYFv6644Y
         Efq9RG0wT36liHKCnrqqfwz0Zvvbj1t+L6bfR5y+9bbGCwb7GChNieWrJ6cxXyp+BvRz
         aO1+eto1xhv8UHtCu+7FkkOCveQ+U1dE/pNwcaorRi1gmxhhEYgfSRvH/JhBoZOvS60C
         CX1n4KjdIvQIMxBvUMqGSeD4dem6PG5u6r09SnRyv78yoa5SX2lhgq2ZuSWUTLNk5fp7
         WCgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760975483; x=1761580283;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U0BnniMqbZE4aAUiItvL6YB9ZDrqDRkHOgLhpY4+LF0=;
        b=PrQf8SvOpi+Zw/CE0ZNMe+VbHnUPE8x3y6MoRkrsmgcGL+M78rFeozrAo/NY99Ok+o
         3pareXWu3+00/IeP/POMrUt+QLvFK/CDiA2Cezxe7ssqTL59wwRuUF/pDkUmFJTSTul0
         VqIYYfGVZacS5RFaomWiDnuCT/hTAFENzxq9D4l++e3374xpjfmqMyhA0khBEl4H37HH
         iHtplvovjT/wvvANLbc9eAGK+vjLU8cdiqukWcZQw17kiq/AJmns03Vx7WS2lke5miGT
         42lQ4lPPJfeBG7VKxOIXp5Em1/2V7/l6enuTZ7Gtu9bvTsOSE66sBdXoL5yq7pyJjoTH
         ucmg==
X-Gm-Message-State: AOJu0Ywe5hTZPJSkUoXK24Tl8waaw8PnJ5a/eXtAUg0M99Kk5QFYr6pM
	Jb/x/iZvH6epNwcSqEQXffeHx48oKs6LJaguLJziqqBkNtqr1HP0XgFJTEciSBRZw6Sc+fABhd2
	m8z9+/A==
X-Google-Smtp-Source: AGHT+IHCsYty/WB1qu/x0cvmAiHv88kmNMjvq8wPjCLHxhUiPz1nl9CMQsyuwyu1MUqyQD15VEkJEy6oYl0=
X-Received: from plau4.prod.google.com ([2002:a17:903:3044:b0:248:7db1:3800])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cec3:b0:290:a8fe:24d4
 with SMTP id d9443c01a7336-290cb661a74mr172657735ad.50.1760975483046; Mon, 20
 Oct 2025 08:51:23 -0700 (PDT)
Date: Mon, 20 Oct 2025 08:51:21 -0700
In-Reply-To: <176055117173.1528469.2261818917462419157.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251007222733.349460-1-seanjc@google.com> <176055117173.1528469.2261818917462419157.b4-ty@google.com>
Message-ID: <aPZaeU1PGQFkUSHE@google.com>
Subject: Re: [PATCH] KVM: guest_memfd: Drop a superfluous local var in kvm_gmem_fault_user_mapping()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 15, 2025, Sean Christopherson wrote:
> On Tue, 07 Oct 2025 15:27:33 -0700, Sean Christopherson wrote:
> > Drop the local "int err" that's buried in the middle guest_memfd's user
> > fault handler to avoid the potential for variable shadowing, e.g. if an
> > "err" variable were also declared at function scope.
> > 
> > No functional change intended.
> > 
> > 
> > [...]
> 
> Applied to kvm-x86 gmem, thanks!
> 
> [1/1] KVM: guest_memfd: Drop a superfluous local var in kvm_gmem_fault_user_mapping()
>       https://github.com/kvm-x86/linux/commit/c1168f24b444

FYI, I rebased this onto 6.18-rc2 to avoid a silly merge.  New hash:

[1/1] KVM: guest_memfd: Drop a superfluous local var in kvm_gmem_fault_user_mapping()
      https://github.com/kvm-x86/linux/commit/5f3e10797ab8


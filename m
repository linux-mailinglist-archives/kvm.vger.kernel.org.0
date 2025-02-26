Return-Path: <kvm+bounces-39213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D07E1A4526D
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 02:54:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E024188A170
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 01:54:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8844719E82A;
	Wed, 26 Feb 2025 01:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t2VFU5r1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2A51552E3
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 01:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740534832; cv=none; b=JHsWVCJgJGVCvverfjlPsjBJ+yXJHoeoG/xFrr5Qrq9hOMPXPpRZlMzJSbxUYucBo/9FGmFKOsZLZfno6WyaWGYcxkPQdML4dL4FpxzwEZRXoEg7qgZ1+DByiPgPRlHY15oX3GNcie09xeW4CIjn4ro0aW9qHgPB7KpXN/4JqwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740534832; c=relaxed/simple;
	bh=mt9ZPQ68rspzjWyqQSWrq3VOqM7TIRbM4OFSIyDzI1E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U6cF8BSmA7J3OMcNDwIddnyOiEV18A0kzkiS4SFlpL8gZ2w/cWjMDppX2Px+CNWn1n9eMrUkYSU4Gf9rjmbh35E5M8OIPWcqK8ZF07eqJvjz+Sp06YewtUWbijTi0IA65r0lgWakyJELGqfefRLWs0jiLVVppXJIr3K1oNLn62Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t2VFU5r1; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fe862ea448so336685a91.3
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 17:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740534831; x=1741139631; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qy84pRVEWANZRUM0lPCmW+OAKARH3NjZYD4jWNoJGGM=;
        b=t2VFU5r1iXmm+bkGTzRvmeR4t1EK5lCZV3UpUNdGCR2TqChX0mqQ3g3wodgwg3wbYU
         jILRLibfegjmcXJWenVngr9cjYMql+xE/gvTpP/jBd/mU35zef9RHsPKnkukYyGMuWOe
         OvUL+xAQ9siqi1fzXWaL1fGNREKpE8JpAXwEKfmD6Mq5yhSE3l/QzKe/ii+8rkxul4MS
         h0SrShEU7SNbDuFBavgFIcCuhpJEAjQqwFNL/T+teorxMlMpjiR+t+RFxxBAmtiPPoHf
         4YvxO6ui5/nomNcVOq2EoChXQRR8OD40U84Z8XJnrbXYXqVHDjuWM4RGQBVI8ccxIFlS
         /x+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740534831; x=1741139631;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qy84pRVEWANZRUM0lPCmW+OAKARH3NjZYD4jWNoJGGM=;
        b=ka0ali2Q7eDcrAJ2pubW4+ultkGtkxtbJYEx3MWLqMOS9Ac2G47oEWSeNYA+jQY3Yq
         T/BMKpt5Ezmx0NGv0SLxKQ0gy9r0Pkl3d/2ZplZ8Lo689fe+jc7r+iNkcoufnXvyRDDZ
         6AY2Md3JDYrA/Uf8fVh0frTTxfUUdblDcEHlGfBp3i4HfqBS8/cE/9e/LbuPhKu4KY6W
         t8sFIa6QMmV1WrJk4mp1+shaLWH4EqUSeCAiVcfqLh1uX2zBzuoOqrDCJppCOcQ8OD56
         rryduk1W+MPg1sZE+EQmIWXYOkMNey3oqQE6yvslXjxc96IH+3anRtvxWZa0X0i2mBlf
         1YUw==
X-Forwarded-Encrypted: i=1; AJvYcCV1FGKZJ34f7TYK2wejKeRTmG2EsAxRpwHDbaAqUd44X/Le6CX69QtU/bWbTpPDCYsvVwo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1bhwxZqzVjv5picLDgAF0jpXdJPjBd0EoBI70v1Z0smVRphss
	j+8V17PhP5ESPem2EFAjzqTA4VaplSWMnuCf0ieWvUquigQLTBI1LNZ4Yfk0XUjZeQ90WG6Ern1
	pow==
X-Google-Smtp-Source: AGHT+IEJjGJb9O/bSNSRy5vZ6GfVz8lZRWSwczFt1c3DSQSuSg0EpGbpRjI4VST/mOFIjxYS4aIjr8nRu8o=
X-Received: from pjbtc16.prod.google.com ([2002:a17:90b:5410:b0:2f7:d453:e587])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2803:b0:2f4:4003:f3ea
 with SMTP id 98e67ed59e1d1-2fe692c8403mr9701542a91.33.1740534830763; Tue, 25
 Feb 2025 17:53:50 -0800 (PST)
Date: Tue, 25 Feb 2025 17:53:49 -0800
In-Reply-To: <69a1443e73dc1c10a23cf0632a507c01eece9760.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250208105318.16861-1-yan.y.zhao@intel.com> <23ea46d54e423b30fa71503a823c97213a864a98.camel@intel.com>
 <Z6qrEHDviKB2Hf6o@yzhao56-desk.sh.intel.com> <69a1443e73dc1c10a23cf0632a507c01eece9760.camel@intel.com>
Message-ID: <Z750LaPTDS6z6DAK@google.com>
Subject: Re: [PATCH] KVM: selftests: Wait mprotect_ro_done before write to RO
 in mmu_stress_test
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Yan Y Zhao <yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 11, 2025, Rick P Edgecombe wrote:
> On Tue, 2025-02-11 at 09:42 +0800, Yan Zhao wrote:
> > > On the fix though, doesn't this remove the coverage of writing to a
> > > region that is in the process of being made RO? I'm thinking about
> > > warnings, etc that may trigger intermittently based on bugs with a race
> > > component. I don't know if we could fix the test and still leave the
> > > write while the "mprotect(PROT_READ) is underway". It seems to be
> > > deliberate.
> > Write before "mprotect(PROT_READ)" has been tested in stage 0.
> > Not sure it's deliberate to test write in the process of being made RO.

Writing while VMAs are being made RO is 100% intended.  The goal is to stress
KVM's interactions with the mmu_notifier, and to verify KVM delivers -EFAULT to
userspace.

Something isn't quite right in the original analysis.  We need to drill down on
that before change anything.

FWIW, I run this test frequently on large systems and have never observed failures.
Maybe Rick and I should go buy lottery tickets?


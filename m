Return-Path: <kvm+bounces-38765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE995A3E2E9
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 18:46:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93E63421CF6
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 17:44:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5176A21324F;
	Thu, 20 Feb 2025 17:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NK8RLOsR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C45B212D97
	for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 17:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740073422; cv=none; b=TVqAQgDo/LVKJkztHMwKb9GROr2u6FfmTWzEx7+YQuR6vparJfA6Su2e9WNYbUHtqIYqBVqOL+pzn08jYe8ANqrOVZEHMYhoPU4E5Ybz03DKTjycN1xJagxjLMnt+OTDwY/mySzS32qW4/EiHr5Nha5gbhvM1KB0QDXKj99o2II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740073422; c=relaxed/simple;
	bh=usuZGUAtebqFlzbxpJ09+Fsa2hbTxy9H2t/CGIiL8sI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i2S1tKUknjHAXC+hvkbrJ+lt8tZdhcNHbcy9Z9HWcvbwP0Y3FHLXiElHmM0/+ksHMShLa4VOO3+VTEhsYM2CQmX3F+AbHo2buNOY+RNzw0G6XT42WvBwfplJ5V/s2t7EtkuDzniSYCkWnaNF1YgVJQaHgIGS9qAgTOSVD4H87P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NK8RLOsR; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fc1eabf4f7so2694345a91.1
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2025 09:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740073420; x=1740678220; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sikh5SAYhpSS22RtmRiuMGMqEaJpRF62XukNxLFh/AY=;
        b=NK8RLOsR7dq6KFEZvhUYsuekE+JsnDQ7x8wEVwjILvie9LhpmDOXC4ncfjsumArQTz
         7xE/5qIJxywP1fw1ln89GUCI8+cGk/YxuMLJmYIcYPqOxgqmBoqx1t9o2YCzGx+i5+g+
         m0h60KYb76utIj+REATgdPfWnBVliWQrpMxAEENMqrtwew+D8lH65WN+7+o1fSlLAEzK
         y+yPeeiYWOvgkNr/n3yLOgG3tvIqM9yovQbFfoc2tSY119rEoAD3oE5W6EyTw0v7q476
         BLs/W6oRItWC83cmWq2MIBxLauK7RKVFBShx51s9Nd7nMz4cv/eHwtVTAyafVIaLt8og
         +qrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740073420; x=1740678220;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sikh5SAYhpSS22RtmRiuMGMqEaJpRF62XukNxLFh/AY=;
        b=IbES/AjzaAQzP8ZgzY+li6EJ8ZBy0QFQmItPs17efX9zBDWgQTbRHY9Hj1z4jQ8KDH
         qR6mqlQpNyBNXql6zNQAg5iGXAr/PvIUROZHEHTba4PnhlqkK3VxAc8J2YKuxUfGb7Ce
         tOqqtT6IEZuAJf0AUg7Z1d24U7YZAIJ3F1Ssh3yanTJlY5YMJ6RpOoze8ncWu0Do8Wof
         oQj1cGJSWFDJzEl8kpizrGTfE9DZhdEZYFrzaCedhXVicqYST7NkHna9Qu7gMomKkmDE
         SqrEbt26F2XbimK76ac6UBTSv8aWzPH4Pb1SbOwbaLGDtrNrEagkAhDrhGZGydDc5wjd
         whaA==
X-Gm-Message-State: AOJu0Yz8m/HGwl3E28K22DkwJuPIq789DABni/ujFYg1L5cx/35pCom7
	1/9TcaplQp6t2W+pOspzZuUxNNKfLdF974u7udpSVRuQp/Abw3S3/VC7l7nbY+Rp1//1lBwwtKX
	mUA==
X-Google-Smtp-Source: AGHT+IE1CUVX9qIYmaKSa01tUKYfZLpjvA3ewbpeLW06UvwSk0kDGWMGUMbA7rZDAxd0VMCUNhibkDRCEb8=
X-Received: from pjbnd5.prod.google.com ([2002:a17:90b:4cc5:b0:2e9:38ea:ca0f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:384d:b0:2ee:ed1c:e451
 with SMTP id 98e67ed59e1d1-2fce78cbc8bmr46892a91.15.1740073420398; Thu, 20
 Feb 2025 09:43:40 -0800 (PST)
Date: Thu, 20 Feb 2025 09:43:38 -0800
In-Reply-To: <bug-219787-28872-Buv2FGa6sL@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <bug-219787-28872@https.bugzilla.kernel.org/> <bug-219787-28872-Buv2FGa6sL@https.bugzilla.kernel.org/>
Message-ID: <Z7dpyiQtKNrAyOVe@google.com>
Subject: Re: [Bug 219787] Guest's applications crash with EXCEPTION_SINGLE_STEP
 (0x80000004)
From: Sean Christopherson <seanjc@google.com>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 20, 2025, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=219787
> 
> --- Comment #4 from rangemachine@gmail.com ---
> (In reply to Sean Christopherson from comment #2)
> > Are you able to bisect to an exact commit?  There are significant KVM
> > changes in 6.13, but they're almost all related to memory management.  I
> > can't think of anything that would manifest as an unexpected single step
> > #DB, especially not with any consistency.
> > 
> > And just to double check, the only difference in the setup is that the host
> > kernel was upgraded from v6.12 => v6.13?  E.g. there was no QEMU update or
> > guest-side changes?
> 
> I was not able to bisect yet, sorry.

No need to be sorry, you didn't introduce the bug :-)

> And yes, I double checked, the only change is kernel upgraded from v6.12.10
> to v6.13.2 (did not checked v6.13.3 yet, but rc version had some behaviour).

Please let me know if you'll be able to bisect (or not).  Unless I have a random
epiphany, this will likely require bisection.


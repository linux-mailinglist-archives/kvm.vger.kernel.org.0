Return-Path: <kvm+bounces-63245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A927C5EE31
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 19:36:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D70E3B0B5E
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 18:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EF962DC78E;
	Fri, 14 Nov 2025 18:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JvXbwxTi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB462DAFDA
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 18:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763145344; cv=none; b=te2RuocxnDWUWbLtNWSBlmKPH0X1vD/ZFAGVCDssE1pVnCtY1NrkOh/uQpxCDHc29YQRRjvJAaStaSfR6Cda8F3ROdFzGOhk9h4D2vEgvGb0wBOUfooyH+9huwnIJsHNjCqoEWIwyy6Lv6Hwip6EXMvepNdimKognBZdIEGtTTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763145344; c=relaxed/simple;
	bh=KyhFs8L8GdU7c1klqSuB5uwPjA7wvbExcuBhsYGxqZM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LjmHiYp3qHPnZCWYRjgpgd06bvNY93/ojc+4vUN37b92hFutC69vaiQO2NPGFqk+Fidc/NRwO4LVkUXAMeOkt48LHKi6IDkJp/JVF4b96ZCmMbZw6cZ3y3eNLFk1w9Dkzhn7zAl+8GZ3KIQnViE299qs4jK4/7x5ZFZZnypTsaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JvXbwxTi; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-343daf0f38aso2767167a91.3
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 10:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763145342; x=1763750142; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lh4Z8xcO9m7bNqIc8uInEiX49gZLzo1eqW42/iCQjS8=;
        b=JvXbwxTirRLLD7fvS54MiRdoPCPxaHcW09XvtnLF5zmjrGLY/AaaCQFaGWKb3vW+Le
         6xYQ9OZQjkaJEOBnf/T0WKOU+hh8hUNsAYGBb9yPsRnERbkt79x0NLsravy38kvSHap7
         7f6SQ6axuVy2SwCHBDRBTRnuPz22TuHaXRWAOkDHvotYV0eOh3Dmt0EWqgr1LhedtvM/
         o/YYIeLuHmmMd6OPWQYzm7i1ceq1e3Fvt77wTKkfJD7A3IX/XZIdQwny+ilLw7+XXW5k
         SsIfZZ9m64RfEnFp6T1Nif/hbQFTY7ew+BghD95uyWi46aHcJqquTAGbluSYa+UBRY+o
         IfCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763145342; x=1763750142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lh4Z8xcO9m7bNqIc8uInEiX49gZLzo1eqW42/iCQjS8=;
        b=AVnvkitWJymtE6YJ8f42J0X2nopfY7o5K6uAr6E5wxlG48wkiHDHvJHvLazn0CBrM/
         u+ffQJX404QsHxBO5MdBcnMNPUsOsSANeeh1BKCYqm0wmWJsscJEm2xeTHc+wc0scYT/
         3ChK2kb7m//RygyPAYyeR9qTBGqN+lY9tvhn4wZKClmBUxBpab53mEv8kt+FlI+5M9s3
         JpM+ciUx0gngQaQUHBoilkBi31bR4R/5kBMgDO7uHiY0J6IGkstiQeMabCvfurcALusX
         JUAs3+65hR2lT31xG9Bmra3HuPvEyhF6MYwGnPRAYsEHpYcW5grp6WBIkTqOOyCUwz/o
         80SQ==
X-Forwarded-Encrypted: i=1; AJvYcCWkQKF8YflqtpQxoeLrOdX97Xw1m0vJ3acMXvQulrEmmzjFz8tgnwRsqatubCCUNOntSzg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtQJ1+UYu/vu27HBk5U3pRjKgMbw4oQHPYkYkmfUqMtywSWrCs
	yYZdXK5Sq4BXBSBY6mbq18ZOMoymi7bB47c6iP6MHiLcDVQXLHYFOcy0p0wPLiKI76WK6tvUqRa
	1lhIhFg==
X-Google-Smtp-Source: AGHT+IFshqMuynYh4GEeQYqlqgZcZ72XH4rEskiUXOCzisvk31oYAN2aB7kGMtDQLc0ydZlOgGkfzKUUpEM=
X-Received: from pjbcz5.prod.google.com ([2002:a17:90a:d445:b0:340:bde5:c9ee])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2890:b0:340:bb5c:7dd7
 with SMTP id 98e67ed59e1d1-343f9e92771mr4385141a91.5.1763145342586; Fri, 14
 Nov 2025 10:35:42 -0800 (PST)
Date: Fri, 14 Nov 2025 10:35:41 -0800
In-Reply-To: <20251114182921.GB1725668@liuwe-devbox-debian-v2.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113225621.1688428-1-seanjc@google.com> <20251113225621.1688428-8-seanjc@google.com>
 <SN6PR02MB4157AF057CC8539AD47F6D66D4CAA@SN6PR02MB4157.namprd02.prod.outlook.com>
 <aRdJQQ7_j6RcHwjJ@google.com> <20251114182921.GB1725668@liuwe-devbox-debian-v2.local>
Message-ID: <aRd2famvq_3frSEq@google.com>
Subject: Re: [PATCH 7/9] KVM: SVM: Treat exit_code as an unsigned 64-bit value
 through all of KVM
From: Sean Christopherson <seanjc@google.com>
To: Wei Liu <wei.liu@kernel.org>
Cc: Michael Kelley <mhklinux@outlook.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Dexuan Cui <decui@microsoft.com>, 
	Nuno Das Neves <nunodasneves@linux.microsoft.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jim Mattson <jmattson@google.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 14, 2025, Wei Liu wrote:
> On Fri, Nov 14, 2025 at 07:22:41AM -0800, Sean Christopherson wrote:
> > Ah, my PDF copy is just stale, it's indeed
> > defined as a synthetic exit.
> > 
> >   https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/nested-virtualization#synthetic-vm-exit
> > 
> > Anyways, I'm in favor of making HV_SVM_EXITCODE_ENL an ull, though part of me
> > wonders if we should do:
> > 
> >   #define HV_SVM_EXITCODE_ENL	SVM_EXIT_SW
> 
> I know this is very tempting, but these headers are supposed to mirror
> Microsoft's internal headers, so we would like to keep them
> self-contained for ease of tracking.

Ya, no argument from me.  Aha!  Even better, what I can do is have KVM assert
that HV_SVM_EXITCODE_ENL == SVM_EXIT_SW in the KVM Hyper-V code, because what I
really want to do is connect the dots for KVM folks.

> It should be fine to add the "ull" suffix here. I briefly talked to a
> hypervisor developer and they agreed.

Nice, thanks much!


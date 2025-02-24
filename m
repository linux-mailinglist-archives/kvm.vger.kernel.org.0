Return-Path: <kvm+bounces-39001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB45AA42663
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 16:36:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FB453B19DF
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 15:28:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3595823BCE6;
	Mon, 24 Feb 2025 15:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qY8ILijp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0944B23371B
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 15:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740410907; cv=none; b=VDv/2fgU4gNcxgE1B1oZeE4TaCtPImiF/LgfGuvTvMTfmIvtEV/rid/ijSbl3+wnDvePZ8vTfRowxvO3edNLLJD3vGIkVwZy6HUk2JRrUPoN16ilg9f3jPeGja8ELPutw9wJ1g7xLe5CDpjx4oQy/5MoL+y30o7/JfD1ZJ7PNno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740410907; c=relaxed/simple;
	bh=9/LiUsNGXiMWWBMnJccgIJTiYuSBlmo0m5F5ia7qwlA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WhiDmhOujX3e5ZRLjBzl2E4aRDDRyTgonONG5ydJpD5El+4YGYrVJMb6MdnumaX0WwKMUOfvsDiPn9BIG3NqH8dUpeS+9C00q4owl6HuiQPBwa1G2uIZuN57KImbvJ5od3SOVQv5Pz9sFZqFJ9IS7G+TDzymoEtorBUS7ajd6QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qY8ILijp; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc0bc05bb5so9446026a91.2
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 07:28:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740410905; x=1741015705; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BZ9WRhhDp4EpcPuZC6wdG80ENu6Nv4RwOVFsbFBTA9c=;
        b=qY8ILijppFMksIjnstrvQmTCnOgzMvXClhGMuexGxwBpEVz+2oZQTy+QIG6gnO+Iry
         Sr4nCwPMSJnwClqKGEndUFr86QQMOV0Qj6XlCAOIfpwD0ZDy9YKlL2TTtBFvClG9oNaG
         OM+fqM8aS+Iijmgf+nzg3BOx54uo899RQ5JajkH/qD21roA5Liv5d4er2sKWGAT2HgW4
         QdJvsoY/QlHF0xmY469+alGL9KBo7wc2cCsZ2LY/DXqD06xhH/m/QnWvwiWLl9tGQxyQ
         Pl2qYFSsYyrLwxH+J4e6I6/uLPKpvZULAYqnhugzn0YoHkifOu+e9CsFnl/EhK+QNQR3
         c9hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740410905; x=1741015705;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BZ9WRhhDp4EpcPuZC6wdG80ENu6Nv4RwOVFsbFBTA9c=;
        b=oQCmqt2isgvf0dCxvewYyqUMXKFiyETWmlTOtAkaSq7kVK1twjfZu+znxExb/UtTHu
         3sAjBZ5DmFyJbF0ttXAQ6jH02bi6tKmgq94Z2oKBmorTY1QfGwzdTG2B+U12K1OQhSkB
         j2bRGXuohrXc8tlooSOpSb7sullbAMb8maFhyGEXZ66KBoLGv8G0Oy+13swI7cfQ+NgC
         veuDkc7Gh6ZnAT4CDCyk9osdTLvBbGRFIjtHldNmY8ZyKN9tOSBgi16T2jVC1COS2oYk
         iY2OoEb/xo+fVPKsrd9OpCk86DedEFnz/fnD1514UQx7a1PiioN3u/qyyJtsAOFhiR0r
         uiFQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6duJrDoMCmsoqM92Du5qXrtGKts9yaudqS/WcyS6f5ksYdXQIUocbgd+PL9f0BxVou4w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyw3xtodrHelacCukOFvBTizN+BMVaD6/gAY+KCkhMxgUCt6jmq
	HuEUACtPlue7q0tFaWZS2u7vg+cQb5mEYN+/4JfDe4qvhfjielU+kvHWO3JZ09P/g5lb9A6884r
	8Ug==
X-Google-Smtp-Source: AGHT+IEcNlTzfDmVspxLgOlDSsK8M9jOUb8JLbfZBhzhCGil5fTbECy927wxDJUWNzfYdgpZIatsSwLs8K0=
X-Received: from pjl4.prod.google.com ([2002:a17:90b:2f84:b0:2e5:5ffc:1c36])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:ec8d:b0:2ee:f677:aa14
 with SMTP id 98e67ed59e1d1-2fce78b05b0mr22786916a91.13.1740410905241; Mon, 24
 Feb 2025 07:28:25 -0800 (PST)
Date: Mon, 24 Feb 2025 07:28:23 -0800
In-Reply-To: <20250224112601.6504-1-ravi.bangoria@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250224112601.6504-1-ravi.bangoria@amd.com>
Message-ID: <Z7yQFz3niLKXIdOQ@google.com>
Subject: Re: [kvm-unit-tests RFC] x86: Fix "debug" test on AMD uArch
From: Sean Christopherson <seanjc@google.com>
To: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: pbonzini@redhat.com, nikunj.dadhania@amd.com, manali.shukla@amd.com, 
	dapeng1.mi@intel.com, srikanth.aithal@amd.com, kvm@vger.kernel.org, 
	santosh.shukla@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 24, 2025, Ravi Bangoria wrote:
> As per the AMD APM[1], DR6[BusLockDetect] bit is unmodified for any source
> of #DB exception other than Bus Lock (and AMD HW is working correctly as
> per the spec).
> 
> KUT debug test initializes DR6[BusLockDetect] with 0 before executing each
> test and thus the bit remains 0 at the #DB exception for sources other
> than Bus Lock. Since DR6[BusLockDetect] bit has opposite polarity, as in,
> value 0 indicates the condition, KUT tests are interpreting it as #DB due
> to Bus Lock and thus they are failing.
> 
> Fix this by initializing DR6 with a valid default value before running the
> test.

The test is weird, but as-is it's correct.  The APM does a poor job of stating
the exact behavior, but DR6[11] should never go to '0' if BusLockTrap is disabled,
even if software explicitly writes '0'.  Any other behavior would break backwards
compatibility with existing software (as evidenced by the test failing).

Editing to omit irrelevant snippets: 

  Software enables bus lock trap by setting DebugCtl MSR[BLCKDB] (bit 2) to 1
  When bus lock trap is enabled, ... The processor indicates that this #DB was
  caused by a bus lock by clearing DR6[BLD] (bit 11). DR6[11] previously had
  been defined to be always 1.
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The test fails because the host leaves DebugCtl.BLCKDB, a.k.a. BusLockDetect,
enabled.  With my to-be-posted change to manually clear DebugCtl prior to VMRUN,
the test passes.


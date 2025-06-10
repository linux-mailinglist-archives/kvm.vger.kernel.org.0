Return-Path: <kvm+bounces-48808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83E39AD3EA2
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:16:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D2593A21A7
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 16:15:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCC8623C4F5;
	Tue, 10 Jun 2025 16:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WoSkqB/Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A528BFF
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 16:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749572164; cv=none; b=C8cdC5UWE6MNhUqzxJ185z4XqWwY8OXE+9SIexLuQsTGwt1COq41/ZZiAZqUIpXUHTEluQ+YSxvWwXaQOAdfTbqscZCk5WkVBVCUzVtYpHteRO80R2Q1xbO4xqLHElblmRZaXDNT7U/D3bQkNaRPwTrvOXo7Du2ciy/ap1yMx/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749572164; c=relaxed/simple;
	bh=i1wysgW5zGZ4yIMcnwwg65sgoJiICB3in7hX8h58OOs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jx5xUK/8mqjEFU0cOWXaaUcHP3RCjGhrlnWkG4PZlxAYVj/95DBuDeK/oiHYbc0qnbpOtW4dwuDQBHmaE8F7Y5DT5o1Rt3BOYM6bx7D4PXKJc59NSDqq/5cx7HcD2QpLXZmG2xw/O2awYDdp5hhdQe1Y/WZXzscaAncvTB05jCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WoSkqB/Y; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-311ae2b6647so4309824a91.0
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 09:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749572162; x=1750176962; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cUiAnBaABBi8MmezG61ur8Gw02SUWXIVP1zr4GYN+eo=;
        b=WoSkqB/YtB3i5+UxGLQqkpT5EmTOmLMJfo2UD0yxuDvN9CY0ZOQE1nlGImbfxxFuCq
         cfitA5mFGzYltFmQfaY3S8+57TCuTj3zHkJKpL+05u+A1rTjBrpnfbJdxq1aFKFIDyG5
         rpYZTnBsjWEk1XoBd71F+C/HSjbVmWGtizcX9UOTdGenPlKB98ayB021aJYLVZP0agOp
         XLrtMlMKIOeEBeBbJc4hLy1dMzCFGeoVwiAszzB4zCwcubb/1enwaUTX68ryqbpUleCn
         pJb+Gdh1PyhW8ettAFdMSkXY558+kvbYk3/g+s5+5UcbnyPXKHR3zGT1B4P96VAGZsKv
         rbmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749572162; x=1750176962;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cUiAnBaABBi8MmezG61ur8Gw02SUWXIVP1zr4GYN+eo=;
        b=s2fK/iNZacZhgfBYv/OShBAHjvYYArzF/JixCl0RMH4kr2i6b905Jzfki9sm/RigQZ
         5C6gy74q3FAxpxZikGog+Spr2/QAbqTVy0++6b8iSCsb/ipgcWo5t3g0xjCcOADLkXws
         5uV+lii+rBmBnBVpPesksYOp7T9opOcNoHGuP0BFKG9R0y5QT7OmQE9QeoRc80nzPrpu
         CehZfNBErlKmzbZcLOVmAbPV5oAJ1Ll+bTwD30E3PHwvDy9xbbExJ1uEv14PQ+NF0QZW
         8RSl6rAidVYYVdwehF1Bbt/rqYplSsy5n84TcOmFpvU3g7M6zT2QFF5w03ptopG7LnO3
         TYsA==
X-Forwarded-Encrypted: i=1; AJvYcCXEoKsksiQLRe4aHkDXDzUkpS/TI0cUQVSMkhQG/0u09s3c0XIP7fRxzpPDk241h2VOW/Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzF8rbLRvuf5rmsP/TmHO7iPBB9Icb4kKTTZFsqdx/ipRlEk+7e
	a3e5fxc9FHkTcan0Ps/7sYQA1/iGw2K0jWUgqDBOpn+3JnLrdI6qltivYiKYhlr23dKumCrCNid
	J/kbFdg==
X-Google-Smtp-Source: AGHT+IFXepQ7WyapQC/S8+sadNNKa7dRlJl1xoZOq4ObQKiG309XNQlCV5UWTBLTlgr03UbH2Wtya4oGIg8=
X-Received: from pjbst14.prod.google.com ([2002:a17:90b:1fce:b0:2ea:29de:af10])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3906:b0:311:ad7f:3281
 with SMTP id 98e67ed59e1d1-313af10ad5dmr288344a91.12.1749572161888; Tue, 10
 Jun 2025 09:16:01 -0700 (PDT)
Date: Tue, 10 Jun 2025 09:16:00 -0700
In-Reply-To: <ffb5e853-dedc-45bb-acd8-c58ff2fc0b71@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250529221929.3807680-1-seanjc@google.com> <20250529221929.3807680-8-seanjc@google.com>
 <ffb5e853-dedc-45bb-acd8-c58ff2fc0b71@linux.intel.com>
Message-ID: <aEhaQITromUV7lIO@google.com>
Subject: Re: [kvm-unit-tests PATCH 07/16] x86/pmu: Rename pmu_gp_counter_is_available()
 to pmu_arch_event_is_available()
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, "Nico =?utf-8?B?QsO2aHI=?=" <nrb@linux.ibm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 10, 2025, Dapeng Mi wrote:
> On 5/30/2025 6:19 AM, Sean Christopherson wrote:
> > @@ -51,7 +51,7 @@ void pmu_init(void)
> >  		}
> >  		pmu.gp_counter_width = PMC_DEFAULT_WIDTH;
> >  		pmu.gp_counter_mask_length = pmu.nr_gp_counters;
> > -		pmu.gp_counter_available = (1u << pmu.nr_gp_counters) - 1;
> > +		pmu.arch_event_available = (1u << pmu.nr_gp_counters) - 1;
> 
> "available architectural events" and "available GP counters" are two
> different things. I know this would be changed in later patch 09/16, but
> it's really confusing. Could we merge the later patch 09/16 into this patch?

Ya.  I was trying to not mix too many things in one patch, but looking at this
again, I 100% agree that squashing 7-9 into one patch is better overall.

> > @@ -463,7 +463,7 @@ static void check_counters_many(void)
> >  	int i, n;
> >  
> >  	for (i = 0, n = 0; n < pmu.nr_gp_counters; i++) {
> > -		if (!pmu_gp_counter_is_available(i))
> > +		if (!pmu_arch_event_is_available(i))
> >  			continue;
> 
> The intent of check_counters_many() is to verify all available GP and fixed
> counters can count correctly at the same time. So we should select another
> available event to verify the counter instead of skipping the counter if an
> event is not available.

Agreed, but I'm going to defer that for now, this series already wanders in too
many directions.  Definitely feel free to post a patch.


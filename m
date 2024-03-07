Return-Path: <kvm+bounces-11335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98E1F875A59
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 23:37:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAD501C20E41
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 22:37:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E15DD364AA;
	Thu,  7 Mar 2024 22:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0eOd3UUJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE69E2D050
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 22:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709851033; cv=none; b=lGdR3laeaNH3y454O8HM3qUenanOsDjDE7GV9VyqPvEFyGHrHNXOjuSKobO3KRH9uRgfby3m8ahDtYk2mN/GOZDCcT+p11nbdCkloqWEkUbZ3Ipy+Z5NS4RTkd0a8r1TvxRXGniKKvAVujJ74BVyWtM06lIxLeuE7VhhaUBrgVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709851033; c=relaxed/simple;
	bh=zK8qLpbyclmQ35oZOXzuvDe0P4N7QunEsSV83ELCrUI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Reyrat44HSZmI3dqelDkOQFPojvDnxq9TPF+mukcZTa1I/ks9aZ9jAyT/RA8Szzikryjund3AMCkA7ho7WrCf78oTzI9qeiB4EvxzW2mGTir2/B+ClPiq6Tyt1sufEjxyt0ooQw8xfrOkD7L8fbFOmJ9naL9o2cO8ChQXxzIAT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0eOd3UUJ; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e644ea814aso1101675b3a.1
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 14:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709851031; x=1710455831; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z4+9PzNWMkfaJ8f2k7RQGbCbPIDSanlwAqzPKObubIg=;
        b=0eOd3UUJgxHAx33315tB/cxLLtgDE9kCx1gQMaQTee9nFbNOgLMfHjflv6RX9n+pDh
         um2IT45+e+VABfVhxWuqd7NTLMBjFZhRgccE2p9QqIJyCak4r4Fs88OO8M/MO2/UG7L8
         7Q/2utS8c9qcav6dprV7s/CE/S2ZBb8d/ROfI05PnUDrMHQnc0JV2C1INxd9p5FnXvds
         J701Sv+LVlFdpUavt2226xUiNMLQa0JabReJWXg6ofHm4ucLKrcI4XRrI9mQsGGWPQUA
         Gw3Q+QgrGuEv08zvMY7IimMfgnnJ0hTonplOg7NbGirRva0kU/VivHB+pKTjtFY7P0sT
         PHUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709851031; x=1710455831;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z4+9PzNWMkfaJ8f2k7RQGbCbPIDSanlwAqzPKObubIg=;
        b=pdLr3Bamnx5tBdnw/lE0PXOA9BVWn44gQYa0pS9epRsY2suzxzAUtQi0bdB72oyOca
         SPPtR/qoXhrlmvYoBPOTFbOKDhLEU6Ay49ZxcgUrliaZapZdhBua8m56TonThlNkj+Fd
         sxNbEWML99G2XREMixCJgG9BLU2b0VqchhiI0GaTc7K8tiu/nsOvGWrFXD3DorQFeI55
         Pzqqu01FLdV9oZGof+xB3faHutJU7JRUjaDtgJQp2NBUdNtqO5b7vGHo7Jf8rix5Bxkt
         EhlyYoAMNaUMC9MkLf7K3j/DedqwQm3bopwMdKvBzFWMSGrBiYGMW2W/TVV8xteBV7ZT
         Gotw==
X-Forwarded-Encrypted: i=1; AJvYcCU/pft5KWJ2aFQFMliJAIFV8HUE1PQUlS3Z0L+jfXxKCuz/kJeHJnIqPO3EZ04Uzd7heU7Qw86Bc7oALAU+VJz1FY3X
X-Gm-Message-State: AOJu0YxOChKhsR8uEfMbaX6N7pTeN33u0QAnTw3SdOsl0FCZoTrgUtmZ
	h3R97VopIEqhr6MJenhceSlFHQF49yrTFv3/YK695pJ10MQkO5vKKoYmg8EQhDrlXBgdfN+118H
	9CQ==
X-Google-Smtp-Source: AGHT+IEIJuIEF5H/6PwXZvap4bnAVSwU2qSqAKoa1tkc/2QiCpE4phfIGxgoJp/pla9ucCbOXzTJJssx8tQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:cc2:b0:6e6:42b9:5d22 with SMTP id
 b2-20020a056a000cc200b006e642b95d22mr174151pfv.1.1709851030908; Thu, 07 Mar
 2024 14:37:10 -0800 (PST)
Date: Thu, 7 Mar 2024 14:37:09 -0800
In-Reply-To: <20240307194255.1367442-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240307194255.1367442-1-dmatlack@google.com>
Message-ID: <ZepBlYLPSuhISTTc@google.com>
Subject: Re: [PATCH] KVM: selftests: Create memslot 0 at GPA 0x100000000 on x86_64
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Peter Gonda <pgonda@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Michael Roth <michael.roth@amd.com>, Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 07, 2024, David Matlack wrote:
> Create memslot 0 at 0x100000000 (4GiB) to avoid it overlapping with
> KVM's private memslot for the APIC-access page.

This is going to cause other problems, e.g. from max_guest_memory_test.c

	/*
	 * Skip the first 4gb and slot0.  slot0 maps <1gb and is used to back
	 * the guest's code, stack, and page tables.  Because selftests creates
	 * an IRQCHIP, a.k.a. a local APIC, KVM creates an internal memslot
	 * just below the 4gb boundary.  This test could create memory at
	 * 1gb-3gb,but it's simpler to skip straight to 4gb.
	 */
	const uint64_t start_gpa = SZ_4G;

Trying to move away from starting at '0' is going to be problematic/annoying,
e.g. using low memory allows tests to safely assume 4GiB+ is always available.
And I'd prefer not to make the infrastucture all twisty and weird for all tests
just because memstress tests want to play with huge amounts of memory.

Any chance we can solve this by using huge pages in the guest, and adjusting the
gorilla math in vm_nr_pages_required() accordingly?  There's really no reason to
use 4KiB pages for a VM with 256GiB of memory.  That'd also be more represantitive
of real world workloads (at least, I hope real world workloads are using 2MiB or
1GiB pages in this case).


Return-Path: <kvm+bounces-55877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0560CB3831D
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 14:58:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA17646244E
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 12:58:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31FD13568E1;
	Wed, 27 Aug 2025 12:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4Kkj4ISX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB8435334B
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 12:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756299467; cv=none; b=LcO/OfTWeBl29ryUumOW8DzWv7EhyXH/2e1vN7fZmF/5mvW8xYbU0zJrA0ETSwY0r+tQf1+QYV/1sI4kfKx2s4TrIOemqbSTMcfGTrUu57cBprWYjjOaNoVipUZ7nIDSYRLP0+kQuKZHEUWtK0fCWX5nlD/yd/0ksMFoNt6FdUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756299467; c=relaxed/simple;
	bh=w3nOGUy17xC76CjSfrnPpR5S63ym37zVcNGqJFaVJTc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qNyf3lL913BwQGQEttA0SRFx7SOMDJYnuMWMbGS2rbzBTcU8BQXyRs8BRgA7O2JNhCr5KEVDRSxxuiEAxxk+AK+k0d00AeE45yrYqI3sfRvmFiVaNMUCV8WhekLFvuui8EiVBue/PWabcl8W5oGpvwKUnzVBGlyoFt1yLfq6Tx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4Kkj4ISX; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-248abeb9242so2925615ad.1
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 05:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756299465; x=1756904265; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tBqCOEucd2EHQAImfHa6bYvYMgk6Ar5j1i6s5MVGeY8=;
        b=4Kkj4ISXmTplKT7hbTfEnVHF05Bc8Qc1jGvNKAnD3TFEOG9WeKhmDvu6aCN4BMO1Ql
         apDTqA3aQ5nsEf7ikytHhgEj9upS6G5nRRNW1xWNZKOy95kWIhhoiap0DcosQAmoxAUs
         56LlYpVKw7Ch0ORmphb6bq2YpBVWDN4/hvlNL8twxlNgQWpFFoacQdkAgilsRFktjYNk
         lpBhlAoCNTHWGdmU9ZiwBtkadPRQ3BX21o2R4eGO87R9/JWXajR/w4DryTc3KYxJn7g2
         53kK/2l7SeI3fI7q2CSbv483HOIi8u1YtzbqbPeB+ZWhw3gDLP8lacBAlJK8uk3OCjID
         j4fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756299465; x=1756904265;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tBqCOEucd2EHQAImfHa6bYvYMgk6Ar5j1i6s5MVGeY8=;
        b=KWwbAY1fLZOVjx31KTkLVnxhedHLo3/59Qm/cuqD2QYmYKtah0ZnetqufFTijUPEQu
         aSyRCeuArA2b1XasQ9MZVBq3pZdSWVj0C9oOP10w4N6E6Gp76IzsZfFT0DHPOMir9xhR
         ZvPycwiDjELuDrM77rX+N8VDMi5LtKvudNrftyCwrlVJsfHKzkNmtjXWdE+3xI1mJ5uv
         TB/30PyJJM4EvVlX1zdEJJ6jWVeHn8L5brUEgIB9cilSd7BRV18g4BgXNkMcbrPw6JG5
         RtvcNY2oXjXfVUBVegNjfqdtJI+y4cV6B5/vR3V/YMfunIuTrN9VG0VupzEafdahBQwb
         Kgwg==
X-Forwarded-Encrypted: i=1; AJvYcCX19beH+/PxKrdZSsQ1LcGFDFo83dC2sbRt2MhxuDcMVhnexf18t8SDoxzWYJq/1bbmwI4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNvEZKivq+I9JF+PDGHiSYNajdOuPL/56FqjsmNFzQ6hWsu+tc
	vPAZdoiBSBVLQeiIwYaPBYjwGsA+BVSoCd8Gqx3HV5M9njZ48GFGJEi5HslfEBgFhEy7RRn46iK
	g5yoD8g==
X-Google-Smtp-Source: AGHT+IGjYzo/cbnGJG6xrvxcdKkBIhOc9WrrVofRF0UoN4jq9615eiNnHnaTmYmPl4ZeSe1Rkx8Oa2x6F14=
X-Received: from plbmq12.prod.google.com ([2002:a17:902:fd4c:b0:248:8f78:7ff4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:db0e:b0:246:edc9:3a80
 with SMTP id d9443c01a7336-246edc93d95mr136614825ad.5.1756299465291; Wed, 27
 Aug 2025 05:57:45 -0700 (PDT)
Date: Wed, 27 Aug 2025 05:57:43 -0700
In-Reply-To: <87b10d94-dca2-4ecb-a86f-b38c5c90e0cf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250729225455.670324-1-seanjc@google.com> <87b10d94-dca2-4ecb-a86f-b38c5c90e0cf@redhat.com>
Message-ID: <aK8Ax2EchXMuX642@google.com>
Subject: Re: [PATCH v17 00/24] KVM: Enable mmap() for guest_memfd
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Gavin Shan <gshan@redhat.com>, Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Tao Chan <chentao@kylinos.cn>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 27, 2025, Paolo Bonzini wrote:
> On 7/30/25 00:54, Sean Christopherson wrote:
> > Paolo,
> > 
> > The arm64 patches have been Reviewed-by Marc, and AFAICT the x86 side of
> > things is a go.  Barring a screwup on my end, this just needs your approval.
> > 
> > Assuming everything looks good, it'd be helpful to get this into kvm/next
> > shortly after rc1.  The x86 Kconfig changes in particular create semantic
> > conflicts with in-flight series.
> > 
> > 
> > Add support for host userspace mapping of guest_memfd-backed memory for VM
> > types that do NOT use support KVM_MEMORY_ATTRIBUTE_PRIVATE (which isn't
> > precisely the same thing as CoCo VMs, since x86's SEV-MEM and SEV-ES have
> > no way to detect private vs. shared).
> > 
> > mmap() support paves the way for several evolving KVM use cases:
> > 
> >   * Allows VMMs like Firecracker to run guests entirely backed by
> >     guest_memfd [1]. This provides a unified memory management model for
> >     both confidential and non-confidential guests, simplifying VMM design.
> > 
> >   * Enhanced Security via direct map removal: When combined with Patrick's
> >     series for direct map removal [2], this provides additional hardening
> >     against Spectre-like transient execution attacks by eliminating the
> >     need for host kernel direct maps of guest memory.
> > 
> >   * Lays the groundwork for *restricted* mmap() support for guest_memfd-backed
> >     memory on CoCo platforms [3] that permit in-place
> >     sharing of guest memory with the host.
> > 
> > Based on kvm/queue.
> 
> Applied to kvm/next, thanks!

Thank you!

FWIW, I did separate run of the patches and came up with the same resolutions
for the arm64 changes, so I'm sure they're perfect ;-)


Return-Path: <kvm+bounces-59048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D49E5BAAC6B
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 02:15:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 442A47A4054
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 00:14:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7977C86340;
	Tue, 30 Sep 2025 00:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="emd2ATTj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3FF1A275
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 00:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759191331; cv=none; b=N2SVI534eOJ1DL8tG5keKGz4TDk0hUdL4BQ5OOCUFqU+d681SnUcpYZgC5YPCNtvreFpkoMQdH+8Opi4QQzmRTS+JYVs8RCgYGn7pfrpzxzncVp+t/e4wyKazwa5473p+P1bVXc13MGUu/dT9w+WYU7LnCqvMQDLRj4P8YJ4hO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759191331; c=relaxed/simple;
	bh=sr6UMLGJo6Pgq+ok7BYVRjZyCY6qu7Jt6gAbG5eSDVA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N/S+ExIVGVHP9W2rS3o50rseoRN9cycvIJg3iJmeTsvAfE6QuyBc2sZtdjdVd5dKybfNBaOimqs3BwJzMwSUy+vArl5QOdbeAYy6q6jg/OLD6bVXxYNy05dn212jqkBU46pCk1i8at5U+XXNgAo65YRNtNMly/xHrHqUdl7t41s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=emd2ATTj; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3324538ceb0so8439632a91.1
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 17:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759191329; x=1759796129; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ox23JA2zqsUyi2/t9XndyvxMILNLbQxRs/c7zoz7G7s=;
        b=emd2ATTjfJU18nD3pgBQIR5nRG+/Bgb3jVM8BU4zUR0p+BEjuWJUUFD9GC5UX5lLyg
         bWnR6Em6EJ7vzhSIfqbSigXa8gl35BKoakTC8McQCEg4Kt1D2jKqFpi2DJicM+it4jNe
         nOCs5b0Kkv0XIcD6OzI7yHSX0PIP9ymvgTfv0O14ws5cmKj8mpSt5isj+j15HvdmEYlT
         qfMU2dpYnBGXT83ahlzzbqgni/2zMJJxw8bBBoVRyydE0ayFzcMHAz5rQh2po3QgruzL
         3xFacp+ZO8q8+cJdeG0qPUL6G0k+Ga2SYEHg6n2QFU3zbkg1bb9nnychy8x+18bgX5du
         p7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759191329; x=1759796129;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ox23JA2zqsUyi2/t9XndyvxMILNLbQxRs/c7zoz7G7s=;
        b=Do8THUbJE3srPoBySnYhQiSSQzw8wvbBxlU6+cSsbtBCYB/vJDNO6RVz40FukQdqKj
         +mIdeAp2K0ZrFNstG1rT6W1SiVSgOZzXpegLmcudxRyJyIqgq720zOQaHlukLzJDKTMs
         QJUTJegCuhAHzS/EQflbRw0f0A08i3uVXWbsFLv8gQBvibMuZjIwL0C5exMCAeanZ7e2
         nF2Y+E5vlaZUexhP5ecRPsU6eTF4OkJd+DQPXVxyCABuLRxONrlGW88HK6qqCh+uaU/l
         7PpoQJFn1YuFEQx+ro5zRN4s0d+W2YHkWRJ/3bXcf3pBfKLfstpdgVyzcURhBgrFZD4o
         k3RA==
X-Forwarded-Encrypted: i=1; AJvYcCVAz5gJwBSuC0/V2IkBipFqkRCYZO1luL7pDz1BjZjxTUB3cql4G5fhm1f3OBBiF75lxFw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPY8TLZwhuNDf1Ovk7j6PNhQecnD4V1FzfRB724THmuZUHJqfX
	TeYkkzHi/7SC5tMyl2spMJOWOsfPEhox0ThM8hkfpw7I2OhgFmCvVrA6USkB+0tkFuv0NmLs635
	GkxMDwQ==
X-Google-Smtp-Source: AGHT+IEFB/zG6X5Vwil/d0GOFdZHYb1u1iQ7uAb3bb7Tiu+dE5P39o8vxvoXqh2MYMb/EqQzi/NW9xaIb3g=
X-Received: from pjbci3.prod.google.com ([2002:a17:90a:fc83:b0:330:62e1:cda6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:380f:b0:32e:32e4:9789
 with SMTP id 98e67ed59e1d1-3342a257486mr20862154a91.3.1759191329558; Mon, 29
 Sep 2025 17:15:29 -0700 (PDT)
Date: Mon, 29 Sep 2025 17:15:28 -0700
In-Reply-To: <aNq6Hz8U0BtjlgQn@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com> <20250926163114.2626257-2-seanjc@google.com>
 <CA+EHjTzdX8+MbsYOHAJn6Gkayfei-jE6Q_5HfZhnfwnMijmucw@mail.gmail.com>
 <diqz7bxh386h.fsf@google.com> <a4976f04-959d-48ae-9815-d192365bdcc6@linux.dev>
 <d2fa49af-112b-4de9-8c03-5f38618b1e57@redhat.com> <diqz4isl351g.fsf@google.com>
 <aNq6Hz8U0BtjlgQn@google.com>
Message-ID: <aNshILzpjAS-bUL5@google.com>
Subject: Re: [PATCH 1/6] KVM: guest_memfd: Add DEFAULT_SHARED flag, reject
 user page faults if not set
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand <david@redhat.com>, Patrick Roy <patrick.roy@linux.dev>, 
	Fuad Tabba <tabba@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Nikita Kalyazin <kalyazin@amazon.co.uk>, shivankg@amd.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 29, 2025, Sean Christopherson wrote:
> On Mon, Sep 29, 2025, Ackerley Tng wrote:
> > David Hildenbrand <david@redhat.com> writes:
> > 
> > >                           GUEST_MEMFD_FLAG_DEFAULT_SHARED;
> > >>>>
> > >>>> At least for now, GUEST_MEMFD_FLAG_DEFAULT_SHARED and
> > >>>> GUEST_MEMFD_FLAG_MMAP don't make sense without each other. Is it worth
> > >>>> checking for that, at least until we have in-place conversion? Having
> > >>>> only GUEST_MEMFD_FLAG_DEFAULT_SHARED set, but GUEST_MEMFD_FLAG_MMAP,
> > >>>> isn't a useful combination.
> > >>>>
> > >>>
> > >>> I think it's okay to have the two flags be orthogonal from the start.
> > >> 
> > >> I think I dimly remember someone at one of the guest_memfd syncs
> > >> bringing up a usecase for having a VMA even if all memory is private,
> > >> not for faulting anything in, but to do madvise or something? Maybe it
> > >> was the NUMA stuff? (+Shivank)
> > >
> > > Yes, that should be it. But we're never faulting in these pages, we only 
> > > need the VMA (for the time being, until there is the in-place conversion).
> > >
> > 
> > Yup, Sean's patch disables faulting if GUEST_MEMFD_FLAG_DEFAULT_SHARED
> > is not set, but mmap() is always enabled so madvise() still works.
> 
> Hah!  I totally intended that :-D
> 
> > Requiring GUEST_MEMFD_FLAG_DEFAULT_SHARED to be set together with
> > GUEST_MEMFD_FLAG_MMAP would still allow madvise() to work since
> > GUEST_MEMFD_FLAG_DEFAULT_SHARED only gates faulting.
> > 
> > To clarify, I'm still for making GUEST_MEMFD_FLAG_DEFAULT_SHARED
> > orthogonal to GUEST_MEMFD_FLAG_MMAP with no additional checks on top of
> > whatever's in this patch. :)

Oh!  This got me looking at kvm_arch_supports_gmem_mmap() and thus
KVM_CAP_GUEST_MEMFD_MMAP.  Two things:

 1. We should change KVM_CAP_GUEST_MEMFD_MMAP into KVM_CAP_GUEST_MEMFD_FLAGS so
    that we don't need to add a capability every time a new flag comes along,
    and so that userspace can gather all flags in a single ioctl.  If gmem ever
    supports more than 32 flags, we'll need KVM_CAP_GUEST_MEMFD_FLAGS2, but
    that's a non-issue relatively speaking.

 2. We should allow mmap() for x86 CoCo VMs right away.  As evidenced by this
    series, mmap() on private memory is totally fine.  It's not useful until the
    NUMA and/or in-place conversion support comes along, but's not dangerous in
    any way.  The actual restriction is on initializing memory to be shared,
    because allowing memory to be shared from gmem's perspective while it's
    private from the VM's perspective would be all kinds of broken.


E.g. with a s/kvm_arch_supports_gmem_mmap/kvm_arch_supports_gmem_init_shared:

	case KVM_CAP_GUEST_MEMFD_FLAGS:
		if (!kvm || kvm_arch_supports_init_shared(kvm))
			return GUEST_MEMFD_FLAG_MMAP |
			       GUEST_MEMFD_FLAG_INIT_SHARED;

		return GUEST_MEMFD_FLAG_MMAP;

#2 is also a good reason to add INIT_SHARED straightaway.  Without INIT_SHARED,
we'd have to INIT_PRIVATE to make the NUMA support useful for x86 CoCo VMs, i.e.
it's not just in-place conversion that's affected, IIUC.

I'll add this in v2.


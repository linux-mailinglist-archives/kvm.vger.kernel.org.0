Return-Path: <kvm+bounces-47202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 290A3ABE854
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 01:52:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 900C31BC0568
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 23:52:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A58A62609C4;
	Tue, 20 May 2025 23:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F4jUzqgp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62F321C19B
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 23:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747785118; cv=none; b=ndcy9NuLZEOaJ0o4GxCBPhu7MyiBEkIJvW3L6Kih0IiwrlknRhvr+8hqi++7am+kq9IKnrIkhQpIL/4cOWPi/sgBtup24tsvJdVGpasdZlEaca0OucwmpVC4N5+vcIeNWZdLghBi1oOm8Tus8dt7BTmHEqDYscxyqKhfFfMA8JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747785118; c=relaxed/simple;
	bh=B3PIdaofAJCL1gtUtpYDYYdhAIxOHvUYqxon7uAGepE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jLYeyaOY2I8+J4sRAfu0soZ/yRGJrS3GqBL/ntlRslBARkQethqu2+GCbOY+MdRLKnQf0d3GBnEKBoR0s8VXQnTvDL/hGE6WJ3nV2UUo0pvv4q2PNmNnZxP1oOsxHlTLezXyC+vgtFUXjd+OGIDYvJFwjFQwqsRlvdk6P+6Nncw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F4jUzqgp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747785113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oCx6DibYP4odc57ay/ENqMjE+rQ2YsxE6Q4XHEh99BQ=;
	b=F4jUzqgp1bdoVcq18Kes4saiyuJspY/tYPQxNsaBwHxkajpheBZXb8YLC5eJ/eMPvLqb1+
	gRfZ0QeBJm2IVSccLV+Ro8PsfS5OjvWusHTieVQzBrZFd4YGAB5e3UzrsbhVLSL/TaRlTo
	LpmfwiglODj3RKFOF5JaM31itEHgw1s=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-602-cMUDy78MMaaGsu0TSHlJWw-1; Tue, 20 May 2025 19:51:52 -0400
X-MC-Unique: cMUDy78MMaaGsu0TSHlJWw-1
X-Mimecast-MFC-AGG-ID: cMUDy78MMaaGsu0TSHlJWw_1747785112
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6f53913e2b6so90847536d6.2
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 16:51:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747785112; x=1748389912;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oCx6DibYP4odc57ay/ENqMjE+rQ2YsxE6Q4XHEh99BQ=;
        b=GXKNIsKMUqSwcx/BoDsmelBhNLYxP8YF+jQ30GW3dudcueZwrLthGUnp56+IF2gF9P
         39Z/cwJDnQ4POlSFZydczOyku3N89dcprPlteX2gsanXMyRO3LEGb7M9Ky8F+WjHiQ6n
         LdlAX1+lIx09OCLYty0Mhb+zSDh1gx3GjWA4kvtJo5u2AWnbOBZ4GhNrwGwtItqK/NiI
         u/hyenbmsX/bZzoXzySzontrL41Xxz/UwieexziT17t8VhbYd1hMl+gSjxGWr38lZHQh
         f2fb0UZrymAnnfzuxE7ZX58frHXKxF0UJIDH3MsOhaQZRfHLj55biYNL6mqA9NP3w+Mt
         +F5A==
X-Forwarded-Encrypted: i=1; AJvYcCULQfqJ81AS1+pgE3mf1dCwaXU6R3BfEuTGXOXdRrAD0szg0T+H9PLC7g5lXz2U5bPBzjE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOHVK0IjHXqGAAZplTnBGzDvh/QpVaSdYrognpEpIQ3+dZhmiJ
	iJGt1YI/zoiee+w90M57z0t3BBdxsT0V1KiCx3j49lMsXRg/RUMMtni0Jp6d2CBm0FtwybWTmBv
	f/7CL9f9tmyADgNY3hCjcBIyZEU1L6pReYNXhfJYQBBiOn94pbjakcA==
X-Gm-Gg: ASbGnctPyDtt8wpg+ErPT+7WgCLOUSirqBCnH1rY8Q2r3T9Qu70xVxZo30pk6eVEGfk
	BNh7/jrHC9hesD2VJTsrhBdpiWU3YOVkBa3GuOWJw7Mv49ebczsbaIfpP1VaXN9cZ5WwmV+U5dt
	qC2vv0btqYADW8zdoRN/MDoGFIiLpw1AansAJotilIRjc+LL7i1e6syinud6sA6IUurkmzpEQUP
	SBg1HkYxKfMqq4qVUt8MZcIzGebWY6cxsE9IFIsof9dNkDdW0mgHI2AtXvhQE/kEV4J5BdbKxxS
	PQ0=
X-Received: by 2002:a05:6214:1ccf:b0:6f5:fb5:35f0 with SMTP id 6a1803df08f44-6f8b08ceac9mr260631316d6.30.1747785112066;
        Tue, 20 May 2025 16:51:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFEIlVPypnzo7S17o9PUvy0BEqpDjhoUDhLWxqeEPyI/VDnHBmzee3xdJ1BWCBv4uvKxjhQrw==
X-Received: by 2002:a05:6214:1ccf:b0:6f5:fb5:35f0 with SMTP id 6a1803df08f44-6f8b08ceac9mr260631076d6.30.1747785111728;
        Tue, 20 May 2025 16:51:51 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f8b0988e08sm78045886d6.125.2025.05.20.16.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 16:51:51 -0700 (PDT)
Date: Tue, 20 May 2025 19:51:48 -0400
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	James Houghton <jthoughton@google.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>
Subject: Re: [PATCH v3 0/6]  KVM: Dirty ring fixes and cleanups
Message-ID: <aC0VlENyfE9ewuTF@x1.local>
References: <20250516213540.2546077-1-seanjc@google.com>
 <aCzUIsn1ZF2lEOJ-@x1.local>
 <aC0NMJIeqlgvq0yL@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aC0NMJIeqlgvq0yL@google.com>

On Tue, May 20, 2025 at 04:16:00PM -0700, Sean Christopherson wrote:
> On Tue, May 20, 2025, Peter Xu wrote:
> > On Fri, May 16, 2025 at 02:35:34PM -0700, Sean Christopherson wrote:
> > > Sean Christopherson (6):
> > >   KVM: Bound the number of dirty ring entries in a single reset at
> > >     INT_MAX
> > >   KVM: Bail from the dirty ring reset flow if a signal is pending
> > >   KVM: Conditionally reschedule when resetting the dirty ring
> > >   KVM: Check for empty mask of harvested dirty ring entries in caller
> > >   KVM: Use mask of harvested dirty ring entries to coalesce dirty ring
> > >     resets
> > >   KVM: Assert that slots_lock is held when resetting per-vCPU dirty
> > >     rings
> > 
> > For the last one, I'd think it's majorly because of the memslot accesses
> > (or CONFIG_LOCKDEP=y should yell already on resets?).  
> 
> No?  If KVM only needed to ensure stable memslot accesses, then SRCU would suffice.
> It sounds like holding slots_lock may have been a somewhat unintentional,  but the
> reason KVM can't switch to SRCU is that doing so would break ordering, not because
> slots_lock is needed to protect the memslot accesses.

Hmm.. isn't what you said exactly means a "yes"? :)

I mean, I would still expect lockdep to report this ioctl if without the
slots_lock, please correct me if it's not the case.  And if using RCU is
not trivial (or not necessary either), so far the slots_lock is still
required to make sure the memslot accesses are legal?

-- 
Peter Xu



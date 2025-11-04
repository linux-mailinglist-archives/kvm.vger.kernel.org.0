Return-Path: <kvm+bounces-61992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97797C325A4
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 18:32:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BFB43B4AE9
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 17:29:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97915334366;
	Tue,  4 Nov 2025 17:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20230601.gappssmtp.com header.i=@osandov-com.20230601.gappssmtp.com header.b="LldZsMxH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2584232E73C
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 17:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762277385; cv=none; b=Uz56qulY+3y1wwzdl4ETSNLtcZ3GcVcapfK1SmUQyIbI+/H1eYwe9V/sEANc7SssiCxnc8HTmi+++nPGoyA8ZvZ4yLx/8mQ6sbdVcJu6ElM1PWpCCm9WO/X6YPZgARGLw5LjYCk1jnNBt03EW+H6gmeFFP9CPjVAG2Uhpbvnmtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762277385; c=relaxed/simple;
	bh=sKo5HQZ0uZFRVkuO94DorlkAu2exezebY/kAOBcRapA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hFMnORMt8XuBabOePDKqY6RprFi/XWOdmO4gjqJVn14yKDs4f6Rz2GB4IaEJAH3ULkm7UHnwAHSqGPAHEdFTdOQvV4A8hw2wmW8EyhX8N3OnzSX1h+MAXMaIoKK28OWDJOjLiZxxkreE8R5+OttTg4gJt+Q8YwdS+t0heSkWxMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com; spf=none smtp.mailfrom=osandov.com; dkim=pass (2048-bit key) header.d=osandov-com.20230601.gappssmtp.com header.i=@osandov-com.20230601.gappssmtp.com header.b=LldZsMxH; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=osandov.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-340299fd35aso1025401a91.1
        for <kvm@vger.kernel.org>; Tue, 04 Nov 2025 09:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1762277383; x=1762882183; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MLqOInqy7tyOXTRDkp7TWSpVgCNqS0EcUV+Vv6RyAXc=;
        b=LldZsMxH2h4AYbOQknXBrqvm0c0ljTxT6/qo5CeWvhjyAWqhSPpuMaRucWlIRyvo0j
         QZnQXOTW0OD9bVi4p18+sbIGlT5RJfM6uOdQdlc9L8zFj6vQojzPLjpvRQ0/u6GmVZgW
         bwj66q7N77o83OMQJn1JWRcjnJnoYl3gxEtc3m3wXN7ZdGD8+vkeLeDBVyzsCxKrrWC/
         gWkpBgLjQ4AmhhPx6WPx8xBW7yKJSgD2L897tEWtEvM+7Pfctu6JC4L2y5Y+jsgMSR/N
         2jVx/ecXD8FDP4uCh+vmzhmNUpRXHZNXXc5+Q5HGxJ+P+xvSLFPxgJVTxLJ5cU6yhn+Y
         zsYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762277383; x=1762882183;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MLqOInqy7tyOXTRDkp7TWSpVgCNqS0EcUV+Vv6RyAXc=;
        b=ijE42WtXY4ANYEeldZzwfBSTAI5DnIVBdV/Be3uI3JTVdWve60JaP/cU4PfQOiZN2T
         09NdkRUSlCMjTvEVU9ASqMxOdAFvTInZHU2f2e9Er63eTvvg+bO3EhOKZFSm5RCgOuX1
         AEtSFiHDDLIZRd24ZBK2do7plg6XC2e3opsT8rUGBbfvGMis5ephPnpRcfFpMy++UPh0
         TX7eShEFd8O6aDKyUhoiedmO9a95zMPFKS8GYo+GXsd+K/d2MNcjGS32FYPkrzSUNFOF
         K0jm4Bp8OY4C1L3hR6DnuP8Dnuba9ZNrpqf50i+B/X7bVNXeXuidSt1SPZsciuY7QhQz
         KTCA==
X-Forwarded-Encrypted: i=1; AJvYcCX2zLJWAT8zTS+IwYvTBaZoulj+oiPvwCu8oxXNYQJgHPZiha0UFiopdCKs684GvXMeqyk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCIeNpdIJ+MkoewRNbNWx2UByTDvbkS5KwiJ/DFYQuLOPig/RZ
	X4MH7rYoQILKJF5io51rIqpfFUVeq8AlJCP2AflqwgEhp6skdC8bXeoXASDMMlYRhhI=
X-Gm-Gg: ASbGnctuEz4HaMn6j79ePLaL2v+Tm/5bwSPkTM1miiX/ZTw0FjCUmt+ndXJALSmuvgB
	wFDXSs/fnKBtcE5Vv28kv0Wl2zFfzxQoGq2M0JcdxQ2v6GWwejjNiNawl8zW8uznOcwjJbBjwUk
	H/5weBYEW6OyTIG/c0QHkxz0COb/FRAPwt3bBerCG7xx4wUDqAMg5dP0lPIP7uAUJXYzlgNd5vI
	WlgKk0hUVZa+hG3FDJ1G6StP94wX05Ktqn8aWOptMm4XEgbg7SegW9k7OACveRmmTBuFwy0rwtc
	wqRo3tjGDcJ5aB8xOkhZVeItXDNBwZ5N8EudEDU7o8b8x4P3cO0pp5v2qZqYQTOC7k6mMZr7j52
	m2U7FoLbxipinBAXz/cxC9ErIy5H0OggQw64tDzvJYJ0dko1Q9vDPhlqdCw==
X-Google-Smtp-Source: AGHT+IFZMI12de40sJPVxwqv4mtaNpqUnJEU6+i5eAXnJ4ILoxjf69dl/6iFbYDvD/kSo4ohFra/Nw==
X-Received: by 2002:a17:90b:1e41:b0:341:8c8d:64f0 with SMTP id 98e67ed59e1d1-3418c8d7246mr1394832a91.6.1762277383319;
        Tue, 04 Nov 2025 09:29:43 -0800 (PST)
Received: from telecaster ([2620:10d:c090:400::5:5bc5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-341a68d6877sm63806a91.14.2025.11.04.09.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 09:29:42 -0800 (PST)
Date: Tue, 4 Nov 2025 09:29:41 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	Gregory Price <gourry@gourry.net>, kernel-team@fb.com
Subject: Re: [PATCH v2] KVM: SVM: Don't skip unrelated instruction if
 INT3/INTO is replaced
Message-ID: <aQo4BQPyY57ZeVnn@telecaster>
References: <6ab4e8e5c5d6ea95f568a1ff8044779137dce428.1761774582.git.osandov@fb.com>
 <aQU7vR9_pf8uwqry@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQU7vR9_pf8uwqry@google.com>

On Fri, Oct 31, 2025 at 03:44:13PM -0700, Sean Christopherson wrote:
> On Wed, Oct 29, 2025, Omar Sandoval wrote:
> > @@ -2153,6 +2158,10 @@ u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);
> >  #define EMULTYPE_PF		    (1 << 6)
> >  #define EMULTYPE_COMPLETE_USER_EXIT (1 << 7)
> >  #define EMULTYPE_WRITE_PF_TO_SP	    (1 << 8)
> > +#define EMULTYPE_SKIP_SOFT_INT	    (1 << 9)
> > +
> > +#define EMULTYPE_SET_SOFT_INT_VECTOR(v)	(((v) & 0xff) << 16)
> > +#define EMULTYPE_GET_SOFT_INT_VECTOR(e)	(((e) >> 16) & 0xff)
> >  
> >  static inline bool kvm_can_emulate_event_vectoring(int emul_type)
> >  {
> 
> ...
> 
> > +static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu, u8 vector)
> >  {
> > +	const int emul_type = EMULTYPE_SKIP | EMULTYPE_SKIP_SOFT_INT |
> > +			      EMULTYPE_GET_SOFT_INT_VECTOR(vector);
> 
> Apparently our friendly neighborhood test bots[*] are the only ones that tested
> this :-)
> 
> This should be EMULTYPE_SET_SOFT_INT_VECTOR()
>                         ^
>                         |

Oof, I'm disappointed that I missed that. FWIW, I did test this with my
reproducer, and it passed, only because this buggy version will always
retry an INT3. I don't have a test case for the original bug that commit
6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the
instruction") fixed.

> And I suspect EMULTYPE_SET_SOFT_INT_VECTOR() needs to cast (v) to a u32 so as
> not to overflow the shift.

u8 (unsigned char) gets promoted to int before the shift, so this won't
overflow, but we might as well make smatch happy.

I'll send a new version.

Thanks,
Omar

> [*] https://lore.kernel.org/all/202510310909.y5ClH2qW-lkp@intel.com


Return-Path: <kvm+bounces-10651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D277D86E319
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 15:15:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7151D1F21F7A
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 14:15:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04B8C4087A;
	Fri,  1 Mar 2024 14:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="REbiII+C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553F66EF0B
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 14:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709302494; cv=none; b=AMoJS2EV9ErnvvRebDCjynqvYcMzmAXByvq5kacOjWI6xqiVuSxWQWpTjgQqZ1lOth8o2llQhZ/RHDv21E+tl8kHXty+m2DTHIhYtfO6VVq5voCzc0PXFefzAb6K6I4IH/iuDj13mTHwtUBQPonF7EWXgNEptmicIawwCdIgjMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709302494; c=relaxed/simple;
	bh=E24arxKS5Pes9Zke4D1Z5oL4QvbPPALYePQv2HZjlTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RXF3fKnpqh1Zb8YnWoMojiKDPK0oSWFJqdgvIPaon1UDfUD600wxbB9mHveQhUStUm+NFv3ddkoiAoakKDsqE0drGqIZN4B8WBaKjyDGIRXRo1+p9PfTLWs09Xup7++JsC8lu8+/3fD0NNATQFZ+B40Fz1P5R3Ul+9COTJ4BjA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=REbiII+C; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-412cc617b68so1345625e9.0
        for <kvm@vger.kernel.org>; Fri, 01 Mar 2024 06:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1709302491; x=1709907291; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9+ahSplsrpMk5JPa0yOPjfO7AGvDqKLJSzvpgj67f0Y=;
        b=REbiII+CvHFm2X8hQPGOYsw3tJE6+cErnDSu7uVF7mnR7rgNbF5uMY/YAKWQJY2yI6
         cQwT4ik2bhf0VFft3KgDNQ0/mfvAAiq0Ci+iydF4q5uiofGF8OvRZOl6LhVD3He74PRF
         GQBKMbUkerU4l/G43p2VdVIeTMybPDv1K9S1rkKSGHDBB5P7WPXBuY6arDxTsNvZFyud
         jToG8qoXuJokD5KgUVmXWDvF56R1bJHM2D1Yk37fjspFj3YJy7ckDdZDeiBKG2mWXKGQ
         yWReOZ7E+ryxpT6B+6wcYHVbyKHUrFGJPD8FWCnJwn2EMSqy2Y+LxBZQ3aOju+cRnioR
         NEzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709302491; x=1709907291;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9+ahSplsrpMk5JPa0yOPjfO7AGvDqKLJSzvpgj67f0Y=;
        b=mUIUUeV8iG67UCjh76oxbkG8Z341Qib+qv923b58voepNRmBbcgvrtwD1LhanXGrGf
         7vZ7y6WE1t1kciUVo4Y8RAWx9QbZwTO72TYJ5JKm+QXPTtui5E22bM0gF3tGU2vV6SWi
         r6TVJVzVUvxEIMIEaKGTSK8g8dxAynj3w+Lk/Km5s6fcsMoqD/quduUQiccNQMuI7jZL
         +G5gaRxqcCN1ZWcdmz33Nmr+VlbdHgrFWVb1+91lhGoQ0rhHJLwRRQqmPvnFEHDMRhxw
         qr+cefxj2R0/lCtSzDbIbZDEg8lEp0bg+/iL6j0G8/jcTOl8oObs7cgulpVWJSyUysuT
         e6Kg==
X-Forwarded-Encrypted: i=1; AJvYcCWBoRzcXvmVWDUiqPAbFW/IhvQxuBLh98Jg3nWNWwrzyrp3ilPEXplj5fTdZcnQRR7s4dBxmDZP+1bSDrO2yGVpiFYv
X-Gm-Message-State: AOJu0Yy1Ab44whanCGaMeeq4JLn0K9YgNyrUy5BloVqllM401O7Mq0p3
	4xVHBNxAUm0sMfh9Xu09r6vfmRN2uQGqUrrYsAuokE0ZI3BbdGjt2AgCApAcZZI=
X-Google-Smtp-Source: AGHT+IEl0jm9MbCywK4R1WKHEn5lIJp0R+fbP26gqjSgfLOcsDV2IXggp1N1gfgebXtPPiChzEKBDg==
X-Received: by 2002:a05:600c:4ed4:b0:412:c9d:9284 with SMTP id g20-20020a05600c4ed400b004120c9d9284mr1710063wmq.41.1709302490552;
        Fri, 01 Mar 2024 06:14:50 -0800 (PST)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id jd20-20020a05600c68d400b004128fa77216sm8636118wmb.1.2024.03.01.06.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 06:14:50 -0800 (PST)
Date: Fri, 1 Mar 2024 15:14:49 +0100
From: Andrew Jones <ajones@ventanamicro.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>, 
	Laurent Vivier <lvivier@redhat.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joel Stanley <joel@jms.id.au>, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 14/32] powerpc: general interrupt tests
Message-ID: <20240301-0483593c146ffd3bbded2f69@orel>
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-15-npiggin@gmail.com>
 <1b89e399-1160-4fca-a9d7-89d60fc9a710@redhat.com>
 <20240301-65a02dd1ea0bc25377fb248f@orel>
 <b4a1b995-e5cd-40e9-afc1-445a9e5f6fa5@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4a1b995-e5cd-40e9-afc1-445a9e5f6fa5@redhat.com>

On Fri, Mar 01, 2024 at 02:57:04PM +0100, Thomas Huth wrote:
> On 01/03/2024 14.45, Andrew Jones wrote:
> > On Fri, Mar 01, 2024 at 01:41:22PM +0100, Thomas Huth wrote:
> > > On 26/02/2024 11.12, Nicholas Piggin wrote:
> > > > Add basic testing of various kinds of interrupts, machine check,
> > > > page fault, illegal, decrementer, trace, syscall, etc.
> > > > 
> > > > This has a known failure on QEMU TCG pseries machines where MSR[ME]
> > > > can be incorrectly set to 0.
> > > 
> > > Two questions out of curiosity:
> > > 
> > > Any chance that this could be fixed easily in QEMU?
> > > 
> > > Or is there a way to detect TCG from within the test? (for example, we have
> > > a host_is_tcg() function for s390x so we can e.g. use report_xfail() for
> > > tests that are known to fail on TCG there)
> > 
> > If there's nothing better, then it should be possible to check the
> > QEMU_ACCEL environment variable which will be there with the default
> > environ.
> 
> Well, but that's only available from the host side, not within the test
> (i.e. the guest). So that does not help much with report_xfail...

powerpc has had environment variables in guests since commit f266c3e8ef15
("powerpc: enable environ"). QEMU_ACCEL is one of the environment
variables given to unit tests by default when ENVIRON_DEFAULT is 'yes', as
is the default set in configure. But...

> I was rather thinking of something like checking the device tree, e.g. for
> the compatible property in /hypervisor to see whether it's KVM or TCG...?

...while QEMU_ACCEL will work when the environ is present, DT will always
be present, so checking the hypervisor node sounds better to me.

Thanks,
drew


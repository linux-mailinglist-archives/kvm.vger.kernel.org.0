Return-Path: <kvm+bounces-7345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FDF7840ACC
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 17:06:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFBCA283BB9
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 16:06:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86A7115531A;
	Mon, 29 Jan 2024 16:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ajW5/ZI7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9F315530A
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 16:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706544374; cv=none; b=k6FYMXPk7raz3RBS6aFW0kE3JC+RtCJffabgc1j+3wFESKizLAbnpRngLuk589cR+lgqyBM42PD0ePUw1UkJYZ8u+m//KJS0JKgZdDIa54duA8ONRbLfEhYL+32IR9/e1kpeRvnw3dKhtk4VaZrU3BBWst0llzlK9dbHgEuH078=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706544374; c=relaxed/simple;
	bh=spdhQtlVqwZGxE4WLvNyqmE4pPTaQvGGfD0owlqyrn4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WKiCJB15kIc7/J+TY8JS1D+l0yD+X+XthK88LSB8JTU5aIZBuukQS2lsbnkwPbSpol3iMwNvshn9679swDUT/TaIbOEe/kn7oFYJBqLFxECkbQyIgIf6OKaAVBtAxPWfw54v5GMrPiyJJwfPxJwip2dZv+EorO9UTNpSTNm3LEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ajW5/ZI7; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5d8bcf739e5so1026262a12.1
        for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 08:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706544372; x=1707149172; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/QJhPN9B0DFyt0uGBm0tTKyr6mAm9uyszmwYK+ey7JU=;
        b=ajW5/ZI73utd0MqqP3WWh+4f7jf4psLeRjJ/BN2v2Z03F7RcwqaYKoGtszeSesseNZ
         GyQoFb1Sw3JoEiBEjsASZoNRvtvTypf8rG97Yeqsa/47NVOPEVztYucB9WU0suZJWD9y
         Oii1eTT7/DanBMoFiSKJIKkajxmJC4MaYpidDGxD60DmphA5g0RArG0g3xRGQGLV/css
         iaWXuPxnUS87cif0QPMGXry1AOOixYKLnSeiCVPAr+SFSGynH1UuBqlYyw0h6UrPAABH
         nPydt/w7CEWZU8LEVZOpHeozovbHA0U1YE3QUk8s0izBjgWeyN4q7b6kR5HOh/SfBd13
         iJmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706544372; x=1707149172;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/QJhPN9B0DFyt0uGBm0tTKyr6mAm9uyszmwYK+ey7JU=;
        b=kH0McfdbD3DrM8fu5Ne/EVsoIiZhgW5G/GgnaTztjrd3bfK1TzgDBiu8vLqNLNjGeV
         /1WYnEFxdGKGr+Kh25+61pyeJqrqgHcOfBhdHHXvCvunVg5yoD0m+stMBWVBoPJvArcA
         oh0f/MTWRkBygZxu5autUfG4G4BCyRGqSmCJ3slERpi7q2sHkET/sjLdZ4b6MGPTFEEn
         Fc7Tk2mZ0EdPNuySY3LiAb/p9lqtYof+MlJ0D/THyz7wApcH0dVuCVmNQmJhZnqFTJne
         Xl5GIB2OkuZKE6jS+stgE/vRqdew96pADIdLZx5oQlTOfUecpmjZw4BPlqZP8pXxA4NY
         MizA==
X-Gm-Message-State: AOJu0Yw1ejGn0a06Y5DvoDG77i9RH64RjKT4W4uFoDxO1hlY3SmPqVHe
	Iz54UtpVqJafN1Iw5s2ruudvIP6e7aN+OWqdcLmNSMvklgy3ksN77Q5xOAXzlu91IpsULTrRokl
	XRw==
X-Google-Smtp-Source: AGHT+IGeJuMzinOv4G1LhBN1dQPrLZMNZOW8qaacXubx8vE2kR3dJwXXjPyvetrZj6mvs5PmsYPxMJiYqs4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6803:0:b0:5d8:c0fa:c982 with SMTP id
 l3-20020a656803000000b005d8c0fac982mr19571pgt.10.1706544372349; Mon, 29 Jan
 2024 08:06:12 -0800 (PST)
Date: Mon, 29 Jan 2024 08:06:10 -0800
In-Reply-To: <877cjs8q8d.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240111135901.1785096-1-vkuznets@redhat.com> <877cjs8q8d.fsf@redhat.com>
Message-ID: <ZbfM8peFYU-jY9-o@google.com>
Subject: Re: [PATCH] KVM: selftests: Compare wall time from xen shinfo against KVM_GET_CLOCK
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	David Woodhouse <dwmw@amazon.co.uk>, Jan Richter <jarichte@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 29, 2024, Vitaly Kuznetsov wrote:
> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
> 
> > xen_shinfo_test is observed to be flaky failing sporadically with
> > "VM time too old". With min_ts/max_ts debug print added:
> >
> > Wall clock (v 3269818) 1704906491.986255664
> > Time info 1: v 1282712 tsc 33530585736 time 14014430025 mul 3587552223 shift 4294967295 flags 1
> > Time info 2: v 1282712 tsc 33530585736 time 14014430025 mul 3587552223 shift 4294967295 flags 1
> > min_ts: 1704906491.986312153
> > max_ts: 1704906506.001006963
> > ==== Test Assertion Failure ====
> >   x86_64/xen_shinfo_test.c:1003: cmp_timespec(&min_ts, &vm_ts) <= 0
> >   pid=32724 tid=32724 errno=4 - Interrupted system call
> >      1	0x00000000004030ad: main at xen_shinfo_test.c:1003
> >      2	0x00007fca6b23feaf: ?? ??:0
> >      3	0x00007fca6b23ff5f: ?? ??:0
> >      4	0x0000000000405e04: _start at ??:?
> >   VM time too old
> >
> > The test compares wall clock data from shinfo (which is the output of
> > kvm_get_wall_clock_epoch()) against clock_gettime(CLOCK_REALTIME) in the
> > host system before the VM is created. In the example above, it compares
> >
> >  shinfo: 1704906491.986255664 vs min_ts: 1704906491.986312153
> >
> > and fails as the later is greater than the former.  While this sounds like
> > a sane test, it doesn't pass reality check: kvm_get_wall_clock_epoch()
> > calculates guest's epoch (realtime when the guest was created) by
> > subtracting kvmclock from the current realtime and the calculation happens
> > when shinfo is setup. The problem is that kvmclock is a raw clock and
> > realtime clock is affected by NTP. This means that if realtime ticks with a
> > slightly reduced frequency, "guest's epoch" calculated by
> > kvm_get_wall_clock_epoch() will actually tick backwards! This is not a big
> > issue from guest's perspective as the guest can't really observe this but
> > this epoch can't be compared with a fixed clock_gettime() on the host.
> >
> > Replace the check with comparing wall clock data from shinfo to
> > KVM_GET_CLOCK. The later gives both realtime and kvmclock so guest's epoch
> > can be calculated by subtraction. Note, the computed epoch may still differ
> > a few nanoseconds from shinfo as different TSC is used and there are
> > rounding errors but 100 nanoseconds margin should be enough to cover
> > it (famous last words).
> >
> > Reported-by: Jan Richter <jarichte@redhat.com>
> > Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > ---

David, any objection?


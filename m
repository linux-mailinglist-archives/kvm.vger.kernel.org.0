Return-Path: <kvm+bounces-37188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 88094A26801
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 00:47:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B0B93A3F72
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 23:47:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFBD4211A05;
	Mon,  3 Feb 2025 23:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pYM7IE6e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3B92116FA
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 23:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738626412; cv=none; b=Pxh3DALBlIJUvd9C2cm8tW5JaK/zUBtQW+KudohnyAqhDx+UScvQG8D5jp0tSh1aNRSvpX4zoEMazMlXwwQUKpsnkwhg1YLG3XYYD3Nte3Kt4FtgcRldlD/SDwJbId+96rgf/LqMsiYbaH0y8WPcHVPlFMgGSYKRya46JbiMDQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738626412; c=relaxed/simple;
	bh=8L1MKKLJRKA9fwjgy6wanwQsDI5QUdniP9phDu8pHk4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CzJjbx2KbNhLNAoPVsMMFdeEnp8CpU3fGQyBpUy/s4S1qzboEE3/NkA5ei2kAx0ppqYKGbQLKsqksjPrIvkm18rinlD29Fblo5hwwghdR88b+OZUWFQwxx4Cxuos0da9JDHNVuaYecUO87RkYEhSgikk+kHBaw38l77CWBPUv5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pYM7IE6e; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef728e36d5so9533200a91.3
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 15:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738626410; x=1739231210; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nSuGosaK5hHCEp+e5MR1KOURrACh1Uth6m86fvoF8Fs=;
        b=pYM7IE6eaX/EjjUKSWBXFnlN5uhP8JjxSbfLxqXg5nTPLSgRSYESCqvgkAqF2pLT2o
         e5l81p8SY4OSYjG8bU9gKmmeRPr3H0cktNzIkgwCgU5tKZ6Dx/+nW5c7NEJCQEOZQDdU
         wIjrCFD07jkdzAbzsdHZpdzz0n0hzXpTWGBZGLCpQteJwhnshJVJkavt2e2WpgIVMNmi
         yVHoLsZL6PlBn/mLPUjbsKw/aEQIg19AZ5i6wmWF0ZU78fT8inTj4Opeljmc++10vT0K
         MvKleclR/efBbRQ1XUKFW3510/wEv94InIDSUagDqe1Z+Ww7ZoyTyDrbA5bpub+quiZh
         S/xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738626410; x=1739231210;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nSuGosaK5hHCEp+e5MR1KOURrACh1Uth6m86fvoF8Fs=;
        b=k+2dltj5psQ2qWj83O+SENifroRMSGT6owGWos8arF379pql8uIJGgtne3VIuex1KF
         4LQvfifZsXT+gsLsvpy4manCCfYyh0GCtmQlg3hjXliEBjvLvQZp7iiBkIbKlZy20Gkd
         2m9s5RNRLBb1UuatX6JLKTCl03T8/Bc2gTnrbwF0k32MzOIVs0gnHSZAyqOZeZt2O4O7
         DD/p9LEbUMZm9ZfbaJTuAewYWRlQZDSORlb5BoWw8WE1mf3t/MRZIqV/tbjoZsMJ6e9a
         3b7pWjQgE7yutt4Zp+bsK9z9aj6LhC84nfXmRkd1VRNcwsDlToubf6Vtepw5hSOQoowT
         M08Q==
X-Forwarded-Encrypted: i=1; AJvYcCUxZuuK90HqUoBdjy70XufBHZryIOxAjEJ00DU41xSFYAQp0qYgisZOjSi+5LGYkjjgDbU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyqzTALcFZ2G2J16R22RRYjbQ4c8Yhp4jQyLewWhlHFhO8LfEG
	auUzqBH9xJNa4fOcJAUUpTAvt3jJCNojzZYaHTt68D3f+wHWPaZ78zLqOtiewQYnSLddjJObvo3
	oYA==
X-Google-Smtp-Source: AGHT+IFVIhjhmzB9sg2VIMO96ePNC8Z1cE9aDKvshJUFp6DXLPZUlLZI1uXZjpV1zos3/By+HkWoUMPzU6E=
X-Received: from pjbqi16.prod.google.com ([2002:a17:90b:2750:b0:2ef:786a:1835])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:56c4:b0:2ee:e18b:c1fa
 with SMTP id 98e67ed59e1d1-2f83ac70df4mr33349372a91.28.1738626409829; Mon, 03
 Feb 2025 15:46:49 -0800 (PST)
Date: Mon, 3 Feb 2025 15:46:48 -0800
In-Reply-To: <60cef3e4-8e94-4cf1-92ae-34089e78a82d@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1738595289.git.naveen@kernel.org> <405a98c2f21b9fe73eddbc35c80b60d6523db70c.1738595289.git.naveen@kernel.org>
 <Z6EOxxZA9XLdXvrA@google.com> <60cef3e4-8e94-4cf1-92ae-34089e78a82d@redhat.com>
Message-ID: <Z6FVaLOsPqmAPNWu@google.com>
Subject: Re: [PATCH 3/3] KVM: x86: Decouple APICv activation state from apicv_inhibit_reasons
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Naveen N Rao (AMD)" <naveen@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Feb 03, 2025, Paolo Bonzini wrote:
> On 2/3/25 19:45, Sean Christopherson wrote:
> > Unless there's a very, very good reason to support a use case that generates
> > ExtInts during boot, but _only_ during boot, and otherwise doesn't have any APICv
> > ihibits, I'm leaning towards making SVM's IRQ window inhibit sticky, i.e. never
> > clear it.
> 
> BIOS tends to use PIT, so that may be too much.  With respect to Naveen's report
> of contention on apicv_update_lock, I would go with the sticky-bit idea but apply
> it to APICV_INHIBIT_REASON_PIT_REINJ.

That won't work, at least not with yet more changes, because KVM creates the
in-kernel PIT with reinjection enabled by default.  The stick-bit idea is that
if a bit is set and can never be cleared, then there's no need to track new
updates.  Since userspace needs to explicitly disable reinjection, the inhibit
can't be sticky.

I assume We could fudge around that easily enough by deferring the inhibit until
a vCPU is created (or run?), but piggybacking PIT_REINJ won't help the userspace
I/O APIC case.

> I don't love adding another inhibit reason but, together, these two should
> remove the contention on apicv_update_lock.  Another idea could be to move
> IRQWIN to per-vCPU reason but Maxim tells me that it's not so easy.

Oh, yeah, that reminds me of the other reason I would vote for a sticky flag:
if inhibition really is toggling rapidly, performance is going to be quite bad
because inhibiting APICv requires (a) zapping APIC SPTEs and (b) serializing
writers if multiple vCPUs trigger the 0=>1 transition.

And there's some amount of serialization even if there's only a single writer,
as KVM kicks all vCPUs to toggle APICv (and again to flush TLBs, if necessary).

Hmm, something doesn't add up.  Naveen's changelog says:

  KVM additionally inhibits AVIC for requesting a IRQ window every time it has
  to inject external interrupts resulting in a barrage of inhibits being set and
  cleared. This shows significant performance degradation compared to AVIC being
  disabled, due to high contention on apicv_update_lock.

But if this is a "real world" use case where the only source of ExtInt is the
PIT, and kernels typically only wire up the PIT to the BSP, why is there
contention on apicv_update_lock?  APICv isn't actually being toggled, so readers
blocking writers to handle KVM_REQ_APICV_UPDATE shouldn't be a problem.

Naveen, do you know why there's a contention on apicv_update_lock?  Are multiple
vCPUs actually trying to inject ExtInt?


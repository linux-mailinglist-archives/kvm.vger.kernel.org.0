Return-Path: <kvm+bounces-65640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 79868CB1992
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 02:30:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5E5CF30B79FC
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 01:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 359EB224AF9;
	Wed, 10 Dec 2025 01:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F678y7SM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B8C2AD3D
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 01:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765330225; cv=none; b=RG5nWdz3vKg2z4tUluWwEP7JMH1/0dBto1v4bdl9Wmlj4cDeV8tPBUIfoOevjGwzuEPyFZCHZ16YynLEDdYhS/YI8ngXaxAly6lr1xXA+LFSno1IJ5jw5uqDBT5FH5as8QetBcdZzQmP9uIdI30tBqwEDPfm3pc8A3dkap6aDg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765330225; c=relaxed/simple;
	bh=TEZjehRxrB+UPe0+HJci/NcWrRT8LAqyVR2B/TVryps=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qp+yMZkojykqQaAVL2WGl2FOGuiJIXG1XtU5TmYGesW/zqwMAjUw+CmVF1bnzyjpvmna5YvuW+osGhK8xyaw+aYu+XAXD+JELjmlaoJLFMb2ooTa8aecYdbfl0X8dTyyDr3xBw6N/0no/o79nbpNQ4HYeCFeAeDIr+4MVCAdr6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F678y7SM; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7a99a5f77e0so10336209b3a.2
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 17:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765330223; x=1765935023; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bzYVdiyOUB89PcTxYLbA315w77wh23i5yN1FuYvCu0c=;
        b=F678y7SMse2zVVT7cj9Udu3louzVAPfreKkDX4hmXjY3woZa7wSJA+xR8ljrjGyLOe
         sElSnFqi2REHYHrlcEPHmj8AbY0Hw39nEmf+HIlbb4e8oZuEQ393OsabAwoFEaGC+z9q
         CAE7YoBV9r2ZJbzzFhmseJ8ENn1GgSEchrfZvG4rH3gIgx2ZJgn/EI0xV8cpJidx5/7k
         uzsv4qYmvzegYq3YXslfbf0T4iFYBewoDm4XC/99PJFuzf3cPIGj/ALmMjkkhgO0jCgj
         V/aJi+DtpKEIrYh2oIpRYbekkNIP7mbH1Pbg0VkN460Dr1RdKdEuPwHdzgKWJVsOTjgj
         UR9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765330223; x=1765935023;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bzYVdiyOUB89PcTxYLbA315w77wh23i5yN1FuYvCu0c=;
        b=AVkaTJWTla1lXBaCGgrhyUjbBAYT3r++aFOwO3ucd4UWhO+vFWC9e6NMjNh974v+pg
         PMT01A1MMvsYfipblsEzQWbT/aI2fsSn8SRWQEdPdWsPTgh6UJ51qKzelO9+NNsCgdaE
         kbUJEb60hlJGjTCZ+oIxo3v3uc+vS1vK34CsSD9NJGFrbVbahI6dgg1j07tDuDX9XlgW
         nWcveXuOsQMu5gYV8jeh3P1mQb27BUW8lJeqjTkQ7OmSPsS70bQXadHF9F8AleYQrn0l
         zbymve/OWhOavKf3MlTZbEgRfWQWQpTBbxahp4eAzBnWSxzQ4TVqXbVyT9KISBRMEcxv
         hl1w==
X-Forwarded-Encrypted: i=1; AJvYcCXJJCMWbpashcm9gVJx2/PP1buR6yKRvSzC+G5LS6Cx1K9XZxryHW/i9wotghkK2L7KNSc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7Vws3hsZyAO/ea7EQ7uT9RNKkBVzxXUmd8oIKCJlg4VUdFAOT
	rR91SIzr/EJzKrEOJyz+cx5qv//PvZGnYCPss8guUohgKV60OlL2mtyZi66FoYDV9HI53kZJzDH
	SGj3s7A==
X-Google-Smtp-Source: AGHT+IHCoAoYGyPw5j9JBku0hHTxP/A4fWJZOerFAj0Mbk5JHgReKtVWkoA09cZ+6DnOUbpNy+4DPxRjdBM=
X-Received: from pjtd13.prod.google.com ([2002:a17:90b:4d:b0:349:d3b1:8ea4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3394:b0:35e:2a82:fdf4
 with SMTP id adf61e73a8af0-366e2fb7523mr592380637.59.1765330223201; Tue, 09
 Dec 2025 17:30:23 -0800 (PST)
Date: Tue, 9 Dec 2025 17:30:21 -0800
In-Reply-To: <5649e224-bb6a-4b63-bb27-5541216df0b6@suse.cz>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251203142648.trx6sslxvxr26yzd@amd.com> <20251203205910.1137445-1-vannapurve@google.com>
 <20251203231208.vsoibqhlosy2cjxs@amd.com> <5649e224-bb6a-4b63-bb27-5541216df0b6@suse.cz>
Message-ID: <aTjNLdxvmAMuo7VG@google.com>
Subject: Re: [PATCH 3/3] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
From: Sean Christopherson <seanjc@google.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Michael Roth <michael.roth@amd.com>, FirstName LastName <vannapurve@google.com>, ackerleytng@google.com, 
	aik@amd.com, ashish.kalra@amd.com, david@redhat.com, ira.weiny@intel.com, 
	kvm@vger.kernel.org, liam.merwick@oracle.com, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
	thomas.lendacky@amd.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Dec 08, 2025, Vlastimil Babka wrote:
> On 12/4/25 00:12, Michael Roth wrote:
> > On Wed, Dec 03, 2025 at 08:59:10PM +0000, FirstName LastName wrote:
> >> 
> >> e.g. 4K page based population logic will keep things simple and can be
> >> further simplified if we can add PAGE_ALIGNED(params.uaddr) restriction.
> > 
> > I'm still hesitant to pull the trigger on retroactively enforcing
> > page-aligned uaddr for SNP, but if the maintainers are good with it then
> > no objection from me.
> 
> IMHO it would be for the best. If there are no known users that would break,
> it's worth trying. The "do not break userspace" rule isn't about eliminating
> any theoretical possibility, but indeed about known breakages (and reacting
> appropriately to reports about previously unknown breakages). Perhaps any
> such users would be also willing to adjust and not demand a revert.

+1.  This code is already crazy complex, we should jump at any simplification
possible.  Especially since we expect in-place conversion to dominate usage in
the future, and in-place conversion is incompatible with an unaligned source.


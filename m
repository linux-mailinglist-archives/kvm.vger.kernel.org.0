Return-Path: <kvm+bounces-42161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 90F32A73F06
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 20:48:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66AC888144E
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 19:44:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE8FF221DAE;
	Thu, 27 Mar 2025 19:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u6+WczHa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956842192EE
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 19:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743104551; cv=none; b=tjITzP7O4ejXDlZYa97S48lTgdiB9ntBxFO5J7+E4SF+GO7j2STc1rnoDRSQgbh2F2ZVMauoGPWivmWlsn+HGQMHeWKD8pZZWWyLc7YCtWGStOBoSx7KbkoQDgeY6k5iNMvIGP7KDZzdrRuFAV6unDggXt7H1GMZX/J+HT0l46Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743104551; c=relaxed/simple;
	bh=70CqdwZp/XJNJBFhWh4bbWfnR3WgzS7LFHiH6rLnjrY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q2BB2N55HhwQm4wgrpxDm2Y71/cdb8l5ITZWO7A3pDxphTJU9XmpiDYrwN09L49R9FWZTSNmUjYDX3QIvq88eNPHCq81xxoQkhJYitrxgLycsuQdAZPbn3rblQXTO6u43ytOQkrGUhAF3ZH+UIBnIpu7x0t2DPxyYkY+fIj+fk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u6+WczHa; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff55176edcso2499381a91.1
        for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 12:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743104549; x=1743709349; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z6XBRFWpvobDfnwv4/d7dnVOqu4/BPRmvKykTxk3LH8=;
        b=u6+WczHatmMn8d37fVKSq2DQg69Fv6X27FzQ5A3hhYWP+GekgcAJHcmRfSTXd6BaAO
         ftRwa1i8pYo6ymTA2XntJzlwEP+GME+4mSx9b6nh0uuuUlipgZNP4dnLQsPOxsN8UlHu
         Rt5eM6sGizHIKIEh2m5Cwiw9ADGN4mIi7r7OKqQwkrMnqtLQIkE5exrd0ycwTj9RAfNk
         QpuArNWIaX1B05GoRaldz8ZPkaYrf9NPE7ga3dach7KkYJk5XmZWGuumQC02muux+6D4
         t4Z3ssVFbyObtj9iPg8iPU9Y+AA5MVBN7uHlGdnzehYZuQrvfUlMTa1V3DzO9kjWEr5q
         en0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743104549; x=1743709349;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z6XBRFWpvobDfnwv4/d7dnVOqu4/BPRmvKykTxk3LH8=;
        b=JduqSvksjOMa7p3iICIshHXJB9w3ikkV6YqTqVqZioNY7dekK8ioRnE4ncPQJq8+TJ
         Xv9bRg8aQ8PL/0W7S60d2cg/c3QdCtybuhJX0K0WexiUQq8wSZJVwPEyzTuMr6wY4JXo
         Wkj+K6PfqXuND3SrFTbUOH0dKyGEBFBdwBX/Ev04DydnJxNx8O940aizztUCWk14Lw8V
         kCATfpmXEcN7onV2JpmNDyREZlQdZ1Ue9Eqq7avU5Y/Yw3GDpJQTzfY3Tq2BUX8dnv8f
         pDAH0A25bF1Nhq5JojfdccJqvfUzoHVzKqolSCwksty9BFbOGyUbZSOKJ5fsxoqyWCFG
         MqHw==
X-Forwarded-Encrypted: i=1; AJvYcCVBxAsBnWaLxay4NzL4N/FjOarKQFwoC8IVIlAu2EY1v5NL1xssEHANcA7MdCyt0WJbrO4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlTaa31EU2NCVMPVKj+vVusexXgIkqi9GBQEOtHRUJ2HGm37Cm
	c7qfzcH9zyGP7SO6abN/x+xUiizeAaKKrzZtkQLcB8bsriUbZCkWHF6WQ8UiLJJXL+3bo1bg1s9
	bqw==
X-Google-Smtp-Source: AGHT+IEwMIuIvP1yQ+YKbRo8TKvwpvbVEhQ0FrrBLdqpprW7xe1nl9ykfCh6ovQsJejeKJwT7Tg9ravmCG4=
X-Received: from pjtu12.prod.google.com ([2002:a17:90a:c88c:b0:2fc:b544:749e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5686:b0:2fa:15ab:4dff
 with SMTP id 98e67ed59e1d1-303a906ebc2mr6800482a91.31.1743104548855; Thu, 27
 Mar 2025 12:42:28 -0700 (PDT)
Date: Thu, 27 Mar 2025 12:42:27 -0700
In-Reply-To: <Z-WHMZPvCNLsXZ_1@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
 <20250326193619.3714986-2-yosry.ahmed@linux.dev> <855xjun3jc.fsf@amd.com> <Z-WHMZPvCNLsXZ_1@google.com>
Message-ID: <Z-WqIxO1XfFAmchX@google.com>
Subject: Re: [RFC PATCH 01/24] KVM: VMX: Generalize VPID allocation to be vendor-neutral
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Nikunj A Dadhania <nikunj@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jim Mattson <jmattson@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Rik van Riel <riel@surriel.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Manali Shukla <manali.shukla@amd.com>, 
	santosh.shukla@amd.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 27, 2025, Yosry Ahmed wrote:
> On Thu, Mar 27, 2025 at 10:58:31AM +0000, Nikunj A Dadhania wrote:
> > > +unsigned int kvm_tlb_tags_alloc(struct kvm_tlb_tags *tlb_tags)
> > > +{
> > > +	unsigned int tag;
> > > +
> > > +	spin_lock(&tlb_tags->lock);
> > > +	tag = find_next_zero_bit(tlb_tags->bitmap, tlb_tags->max + 1,
> > > +				 tlb_tags->min);
> > > +	if (tag <= tlb_tags->max)
> > > +		__set_bit(tag, tlb_tags->bitmap);
> > > +	else
> > > +		tag = 0;
> > 
> > In the event that the KVM runs out of tags, adding WARN_ON_ONCE() here will
> > help debugging.
> 
> Yeah I wanted to do that, but we do not currently WARN in VMX if we run
> out of VPIDs. I am fine with doing adding it if others are. My main
> concern was if there's some existing use case that routinely runs out of
> VPIDs (although I cannot imagine one).

No WARNs, it would be userspace triggerable (hello, syzkaller).  If we really
want to harden things against performance issues due to unexpected VPID/ASID
allocation, I would rather do something like add a knob to fail VM or vCPU
creation if allocation fails (nested would just have to suffer).


Return-Path: <kvm+bounces-14042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 670D889E615
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 01:31:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DD810B22D52
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 23:31:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54E47158DCB;
	Tue,  9 Apr 2024 23:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ims+bXGo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E71C156F4E
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 23:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712705481; cv=none; b=bxFyKh3PaJ/rwFxLCqrcn2Rz3WdkqTte25/M6zpAx3oba/hHcOUPEAWpIWD3moNLtZJzHWmP59hjdi8+jy3XZw0jUZb7s5/SqngsJtkSv/UvCPU0cQU4+cJ8XajTLqv4IxbaLKYAgRcYKnRPSyYnt3rZAtElhNbY9QCFENqWniQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712705481; c=relaxed/simple;
	bh=o6AfuIgundkl4bbl9CUm36kU0qLZ4OYzLfN95ggeZS0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cNxjsCt89uHVxpKh4FqCri3lflrJItJvdY4FHYNiNREeuBI7It4jnEuZnXHOECzPzrIots3uFylvfOIL4V+CeqMO7n+PPL15Uhcg/CWGpXzpwI26z3Lh4M3BMz65K+rtP5lOf4JbEpvbFrCw5d0xc+3+46LZ0bSkt3Mx8AqLPc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ims+bXGo; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6156cef8098so104685517b3.0
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 16:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712705479; x=1713310279; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YYHsTSM0p3jA34WowQOoWiNKqZGdJ4aSpoAHXmvwcEE=;
        b=Ims+bXGoNhID1nsycPoakBSdnAb25l1YVOLoUVouHbZW2TYK97fWiPopg/CExNRgUv
         ZKe6RObtv6iAG4A885RRJlKfTMCaJFty+1MdbiNhMod/4pCYqrrKuZQv4N1/8Ab0+XDN
         HxlT2Rdr6jpd/VdrbW89c3B0VKX1Ma/fWvOmfZEXRMHfciagOEyv9Z2k8y/+xKe6uQ2t
         ag4U2LrSad744IR26flcyZAtoLxJ0G7XC1YJFzhFHAjtpRPZvClJLmGffHAz0pus/cM/
         S5xhAtzlzLurlSN66YKeO3Cf7DWTn6gRf0K+0luOe5Z19I0VbMw1Khubdtj6HLxMo14M
         EdHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712705479; x=1713310279;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YYHsTSM0p3jA34WowQOoWiNKqZGdJ4aSpoAHXmvwcEE=;
        b=waSTPDl0xtiUi4gFu9myLxku8s5G6lhYN1TRoKR1n9UAF0ViEDoigwH9CCh2WPmyNU
         GU9fue5Exk46iwU9v+yBRfhS75j4Bh+0bAcxbCufb3vYP9hvvl/c0JCIAdQ8a+qpCyUM
         cqObpEjjQBuwIYZG0DD+ibmeMX240NJuYe7fU4UAPDB7K5HiaGrJ8rziw3d0ruejV8+G
         u19CAmJ8tg7CGYENduJWaP5v7+l6+wdrMLvrPJkr+/t9VT8XOHiLX8LiyLi3kw58bXZL
         oa+p2tP0J4lLf/LbfYSnIpfoQQ5NALGxTCCU8lZH6l3G5s+kUaVa1iuWSOiOp2xT5R8M
         lumw==
X-Forwarded-Encrypted: i=1; AJvYcCWI/tmIBHzxORYHacthsQ6N3FzdgI9iko1vpV+x9NprdDJLsEHqcrZh6Dr3OvmCtHmge0zVMA9qbuXzXYv/yl4d56ww
X-Gm-Message-State: AOJu0Yx+NJuZTL7MXrc1Lbxz4phwD07Sda8Yo82Kp4QncNOhrabmWH/N
	3+oU/7CtjJ2KuawJ3MIRb9pjOkN2sONTRqDB9IvZJmreWoneAUTXGLDENQmmxSJGcUOv5J+ESTA
	Ykw==
X-Google-Smtp-Source: AGHT+IFjRuizEM6iREGIu7HDXQtNP0iLntilH9PoPjULNTeHImSovir31dY+o/zn+LeVgcHeovUAI73XthU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ef09:0:b0:dcb:b9d7:2760 with SMTP id
 g9-20020a25ef09000000b00dcbb9d72760mr341637ybd.13.1712705478999; Tue, 09 Apr
 2024 16:31:18 -0700 (PDT)
Date: Tue, 9 Apr 2024 16:31:17 -0700
In-Reply-To: <20240307194059.1357377-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240307194059.1357377-1-dmatlack@google.com>
Message-ID: <ZhXPxTNOqyDwgKuC@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Process atomically-zapped SPTEs after
 replacing REMOVED_SPTE
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Mar 07, 2024, David Matlack wrote:
> Process SPTEs zapped under the read-lock after the TLB flush and
> replacement of REMOVED_SPTE with 0. This minimizes the contention on the
> child SPTEs (if zapping an SPTE that points to a page table) and
> minimizes the amount of time vCPUs will be blocked by the REMOVED_SPTE.

I think it's worth explicitly calling out the impact of each part of the change,
i.e. that flushing TLBs avoids child SPTE contention, and waiting until the SPTE
is back to '0' avoids blocking vCPUs.  That's kinda sorta implied by the ordering,
but I'm guessing it won't be super obvious to folks that aren't already familiar
with the TDP MMU.

> In VMs with a large (400+) vCPUs, it can take KVM multiple seconds to

large (400+) "number of" vCPUs

> process a 1GiB region mapped with 4KiB entries, e.g. when disabling
> dirty logging in a VM backed by 1GiB HugeTLB. During those seconds if a
> vCPU accesses the 1GiB region being zapped it will be stalled until KVM
> finishes processing the SPTE and replaces the REMOVED_SPTE with 0.

...

> KVM's processing of collapsible SPTEs is still extremely slow and can be
> improved. For example, a significant amount of time is spent calling
> kvm_set_pfn_{accessed,dirty}() for every last-level SPTE, which is
> redundant when processing SPTEs that all map the folio.

"same folio"

I also massaged this to make it clear that this is a "hey, by the way" sorta
thing, and that _this_ patch is valuable even if/when we go clean up the A/D
performance mess.

> +	 * This should be safe because KVM does not depend on any of the

Don't hedge.  If we're wrong and it's not safe, then there will be revert with
a changelog explaining exactly why we're wrong.  But in the (hopefully) likely
case that we're correct, hedging only confuses future readers, e.g. unnecessarily
makes them wonder if maaaaybe this code isn't actually safe.

> +	 * processing completing before a new SPTE is installed to map a given
> +	 * GFN. Case in point, kvm_mmu_zap_all_fast() can result in KVM
> +	 * processing all SPTEs in a given root after vCPUs create mappings in
> +	 * a new root.

This belongs in the changelog, as it references a very specific point in time.
It's extremely unlikely, but if kvm_mmu_zap_all_fast()'s behavior changed then
we'd end up with a stale comment that doesn't actually provide much value to the
code it's commenting.

I'll fix up all of the above when applying (it's basically just me obsessing over
the changelog). 


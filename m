Return-Path: <kvm+bounces-30793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DC4B9BD5BD
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 20:18:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04E0B1F2376C
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:18:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CBCE1EBFE0;
	Tue,  5 Nov 2024 19:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jrygHNjt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EE61E7C27
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 19:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730834299; cv=none; b=K/hv9GbPfM1+x2IebRrHqn2Xb2BIlbpkLlbt7+dn1BNDidFck/aYVkhwZb43AnAl/qSaIZflbjYrkTNrM7siVh9lli41N3vTIAn2XXFeWPgcdj32lmU7QwvLMw36iapa58Lqsu8vgdOGQde4YrhmU8WJ7SuDgc1nKeeoLuj4Y98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730834299; c=relaxed/simple;
	bh=KcLNmdINbboEOcPBnOOngbnVFtKqG1jrQP932oLB02k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fNS/iu53j88tZxEFagTIb7UJg4R+YVFb6T+6MgrUg9BAc2HcYhFcVwf7qNcPBX4htOrDLHc1BSjK8Rqu5nV/ZVG6FyCR9XBLYDBVa79H70aBGSqAqC+QfvjkwvXMpd+qRqatCBN70njka/zslEvrTFqvoqA9FFkaRqbqDpDDdRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jrygHNjt; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2e5a60d8af1so5587259a91.1
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 11:18:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730834298; x=1731439098; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9f4OfL/WzG7jWvwRWk9HMZifJUGYJMKeOzFPitEAUFc=;
        b=jrygHNjtZKGCqBn6FUXaLqHFlbU5FDIR5klRoMU/5AETQ6YEZdEIVGUegGV2GtckbS
         JJQ5oTsq8onF/9Oew4FNOOkXtuEpa+CRlGNBsisxko+bCrM+Rz2H3sT8N5vAMzPzG1qY
         h4GiRYQkWubfA1u1aBCWDIuMtlZd+I/SpIEJpG0yOnrlC5sagu5+p/+sP2oAg3udSy7X
         klwciuAS/vid1kwFBW9vSAsF1IjFVYOD+IOLsEgSaFc3jfgmXsvQINFEmFzelNilvaSr
         xrq8xhEI7SpBxl8Py0vJ1Hc+A2QOaERT0/DGf9r0F4dw42dD1VmG9hiKIodmI/J5CpfR
         kLCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730834298; x=1731439098;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9f4OfL/WzG7jWvwRWk9HMZifJUGYJMKeOzFPitEAUFc=;
        b=p2dEkx+2fZlfxj5CIcakkIfMdTkiOVvoja9oD2k2nT4NYNwcKWtvpoaAWkS8Tvy93X
         cSIVWjwidcfvDMvC3++mVDLJzwOGtouZPqza4ikfEPpjiwqzfEe6Axq9dtLOQkWz2WFX
         ymDg3CsztAU38GyUXURxdkv+q5MwfJJeSytfL+96LOXnp3RsWZ6xbZBpC3ZiiDDUvk22
         qvzC9jITA9qB4JBBGikSQK2tJzI+DFPIy8rn2w0l6BxPvbjBhk2Pg9/yiSM0KG32DnbA
         k3YGsA6sNsdz3dZLSmT5G/fMoPplELVpcHG9aNP/8sL3TFoDJ/lgO+8LBpPd2MqTgKQh
         eKIg==
X-Forwarded-Encrypted: i=1; AJvYcCVGvaXOTAK3HxMl10KlIpfwMT+odfo7a1Sp5Tm/ERTLsYGnQINOFUrWbub3KfLK0zziFBM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWn6grfEvqO8NckrqdUpuUjOCuSwsOse27OFJuS1v7ydiWHmO0
	VG+z1igz0lYdhvUS49/mQzp2cijcx2QsYLrSLH8md04txR4rI11cW+xyfm2z1Z1IY+fheKR3+0u
	XJA==
X-Google-Smtp-Source: AGHT+IHMYuAZnXAc/S1cVTWe83OJa2YM6NdR95YJGJDDiTdYVajYkwQdrKNrGa/D+hjmRYf6j640qi+2ZIM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90a:a40e:b0:2e2:d3d2:347 with SMTP id
 98e67ed59e1d1-2e94c51d7c1mr31265a91.6.1730834297611; Tue, 05 Nov 2024
 11:18:17 -0800 (PST)
Date: Tue, 5 Nov 2024 11:18:16 -0800
In-Reply-To: <20241105185622.GEZypqVul2vRh6yDys@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241104101543.31885-1-bp@kernel.org> <ZyltcHfyCiIXTsHu@google.com>
 <20241105123416.GBZyoQyAoUmZi9eMkk@fat_crate.local> <ZypfjFjk5XVL-Grv@google.com>
 <20241105185622.GEZypqVul2vRh6yDys@fat_crate.local>
Message-ID: <ZypvePo2M0ZvC4RF@google.com>
Subject: Re: [PATCH] x86/bugs: Adjust SRSO mitigation to new features
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, kvm@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Nov 05, 2024, Borislav Petkov wrote:
> On Tue, Nov 05, 2024 at 10:10:20AM -0800, Sean Christopherson wrote:
> > All of the actual maintainers.
> 
> Which maintainers do you mean? tip ones? If so, they're all shorted to
> x86@kernel.org.
> 
> > AFAIK, Paolo doesn't subscribe to kvm@.
> 
> Oh boy, srsly?! I thought I'd reach the proper crowd with
> kvm@vger.kernel.org...

It gets there, usually (as evidenced by my response).  But even for me, there's
a non-zero chance I'll miss something that's only Cc'd to kvm@, largely because
kvm@ is used by all things virt, i.e. it's a bit noisy:

$ git grep kvm@ MAINTAINERS | wc -l
29

> > What does the bit actually do?  I can't find any useful documentation, and the
> > changelog is equally useless.
 
> 
> "Processors which set SRSO_MSR_FIX=1 support an MSR bit which mitigates SRSO
> across guest/host boundaries. Software may enable this by setting bit
> 4 (BpSpecReduce) of MSR C001_102E. This bit can be set once during boot and
> should be set identically across all processors in the system."
> 
> From: https://www.amd.com/content/dam/amd/en/documents/corporate/cr/speculative-return-stack-overflow-whitepaper.pdf
> 
> I think that's the only public info we have on that bit.

Heh, I found that.  Not very helpful.

If you can't document the specifics, can you at least describe the performance
implications?  It's practically impossible to give meaningful feedback without
having any idea what the magic bit does.


Return-Path: <kvm+bounces-60573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81030BF3E2A
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 00:24:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6E7D487891
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 22:24:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C64502F1FF1;
	Mon, 20 Oct 2025 22:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tvrSVPk7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC782EE616
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 22:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760999080; cv=none; b=D231SISa/v+5fzKxwWRz8qfiIYqe4weU6uJp1qq0tQa/l5Zxas4r9K/nnh0TUHlgJ2cQU8P4WlbJT/vY5Qgdzht0x9+YyxXf4sqpTdf2B/ckT88sT1H1QlJ5MmjZNLzaVUSuYkLNRYchEgHCsPdSltBveBVbu77QHN9hNxGOCWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760999080; c=relaxed/simple;
	bh=rwI4Q0igxrGek7Z30UI6EiSACc6o5I1weTBUNiXBwbI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MBmpjYdKNUNvb+D0g5AEa9aN12BRLoLLrN1aOzhvhwQG7X14IIzw6CgzRvqV6uQtlRVOdl9gE6WqsGBaVa/WfMKzVkOjYWMgJ2URLrz+VP9pPPaHxXWc89HhmLvsLzN00g78E1FyM1EziAOwVQ/BuqWe8VoWhjIxSFnyYKIvbR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tvrSVPk7; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33bbbb41a84so9819925a91.1
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 15:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760999078; x=1761603878; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O/hlonJDisEdxFqgeg+9pNsgF5x3rn1Y1jGkL4uD0z8=;
        b=tvrSVPk73JnEG3Wn4gjCNfwFrTtOwO72DmL1yZuVhFO2ACnRfUJrt8q4e885pWW++2
         C2HsDBrRClk7skcq7ydTXB/yGRz4ybzHCcXZkPMqkSi0WmIame/GV/NmbwektPjQpeVF
         EQiJIKgNzYqFO2heNh3CmuWXGzQ4vzRjVrBSLtPj0kkfjhIl1Ukrf8t3AW3GXBRc/5Hp
         uiaelukyKYOfD5D4rQHOUr963UKoKuLRmmghhcv/iswzB2fhjnMQqiFAtXU38IER2rkQ
         RB+BQeJscJx+ZMP6nLR96ElYPaqVoNZBExbV2MxzcRWz+NIwZm5Uxvf5O4UADKddX/se
         iG4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760999078; x=1761603878;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O/hlonJDisEdxFqgeg+9pNsgF5x3rn1Y1jGkL4uD0z8=;
        b=NefkGi1EC/3cohCM6oUVERRNvhLhZtMT9L1oT1QxOutb0WpXmI0AphecP21IHL6Njj
         rqFqz1rpgTmOBBGwzwbMfD1hsqNO8sBKU1qn52q+u9xRxo27DxnOiNTKAFw1u3mOYAqC
         sPyC5dxUmXZUvAtMBAIpUxRBgTHSOv7PKhSRZw4Zf3Cnkpo+sKaEUq8a8IvgsxwKdIx+
         gB8fdXkU3wQaBP8/J+f0+ysOMjxS5zf9hY7p9Lx2JtsSvOTo7zwqiy93IIYsc8vnWAq0
         3t+vue4xB1zBx+E2C4i1yRbe+pwWYISi8OhxouVYR+nEkCN1V6kile8NMI99iAyR9cdv
         xwHQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9ECsItvs+m3WrUzqe/KFhdibKWE4TT4QVihM7uIj5cNPNJUHdWkg2gRNCVSZv+wc4mF0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9gR3bY0CJ3BkIiNWns0J8zEekgzf1cZCSxAFwgm7cREca9/Ri
	orIrVZ8IYWbJ1rQErxeZ3TWhIxpFL3IWlmF0LvAdbsgQ2HV7eA++PYTBJNG7d9ht/vDQpUD6oeI
	ULGgjgg==
X-Google-Smtp-Source: AGHT+IE6c9sEci3X0zPR63N37Gu2Es1JlDgLufLRd3jB/+ym0SdtXH8HFpO/JAdI7UjiT18+DG3UC5Msm4Q=
X-Received: from pjff13.prod.google.com ([2002:a17:90b:562d:b0:33d:69cf:1f82])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2fd0:b0:33b:ab6a:87d7
 with SMTP id 98e67ed59e1d1-33bcf8fd36amr20949231a91.26.1760999077924; Mon, 20
 Oct 2025 15:24:37 -0700 (PDT)
Date: Mon, 20 Oct 2025 15:24:36 -0700
In-Reply-To: <20251020205602.xrgypiwk5dwejdqf@desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251015-vmscape-bhb-v2-0-91cbdd9c3a96@linux.intel.com>
 <20251015-vmscape-bhb-v2-2-91cbdd9c3a96@linux.intel.com> <aPZe6Xc2H2P-iNQe@google.com>
 <20251020205602.xrgypiwk5dwejdqf@desk>
Message-ID: <aPa2pHtY8X-TBXeY@google.com>
Subject: Re: [PATCH v2 2/3] x86/vmscape: Replace IBPB with branch history
 clear on exit to userspace
From: Sean Christopherson <seanjc@google.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Asit Mallick <asit.k.mallick@intel.com>, 
	Tao Zhang <tao1.zhang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 20, 2025, Pawan Gupta wrote:
> On Mon, Oct 20, 2025 at 09:10:17AM -0700, Sean Christopherson wrote:
> > On Wed, Oct 15, 2025, Pawan Gupta wrote:
> > > diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> > > index 49707e563bdf71bdd05d3827f10dd2b8ac6bca2c..00730cc22c2e7115f6dbb38a1ed8d10383ada5c0 100644
> > > --- a/arch/x86/include/asm/nospec-branch.h
> > > +++ b/arch/x86/include/asm/nospec-branch.h
> > > @@ -534,7 +534,7 @@ void alternative_msr_write(unsigned int msr, u64 val, unsigned int feature)
> > >  		: "memory");
> > >  }
> > >  
> > > -DECLARE_PER_CPU(bool, x86_ibpb_exit_to_user);
> > > +DECLARE_PER_CPU(bool, x86_pred_flush_pending);
> > 
> > Rather than "flush pending", what about using "need" in the name to indicate that
> > a flush is necessary?  That makes it more obvious that e.g. KVM is marking the
> > CPU as needing a flush by some other code, as opposed to implying that KVM itself
> > has a pending flush.
> > 
> > And maybe spell out "prediction"?  Without the context of features being checked,
> > I don't know that I would be able to guess "prediction".
> > 
> > E.g. x86_need_prediction_flush?
> > 
> > Or x86_prediction_flush_exit_to_user if we would prefer to clarify when the flush
> > needs to occur?
> 
> Ok, ya this is more clear. I would want to make a small change, instead of
> "prediction_flush", "predictor_flush" reads better to me. Changing it to:
> x86_predictor_flush_exit_to_user.

LOL, see, told you I couldn't guest the word. :-D

"predictor" is way better, thanks!


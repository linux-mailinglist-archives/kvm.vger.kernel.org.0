Return-Path: <kvm+bounces-64020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 28D8BC76C5C
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:26:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 88A8F3486AC
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D143E266B6C;
	Fri, 21 Nov 2025 00:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZaM2nqsK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832BF264627
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 00:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763684664; cv=none; b=H2ro5OlAjuyFtxLvJpE27PExc8pviXorlR8QIlwY7/GEqpFOO0iFArBEDTElt4KavTdg8oMG/tMsjRgqT5qlHuSH0Pp5CTIlXLNjX9HG/LGmdJZEXC8VTo9Xt+pt17qYq5g/Gj3KVFIvcWelLb4Q3oSszRemxW4tuaMAEtT8kEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763684664; c=relaxed/simple;
	bh=WFtsWkc6oBiaKbV86QmWbyu+9b6FdCObrST/t8uPvqA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l0LBqo70liWxbOik9IqEalxFbdWp55UpMSUmZk6D5dPK7Q6ga5WRwgmHt9qug6ImILJZeCxwdbguqcJcH6lRnhFKF82AWEdJRKWBrfjn+JXbk7e9m40ckkCHzbms4rbxafzxyxy8qo8Xw3lfSWfM/uEcYMpNO476IdVk6Ps0WfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZaM2nqsK; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-343fb64cea6so3964332a91.3
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 16:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763684662; x=1764289462; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oGd96OzltDe2oScYSMy6IxJhoHTysu7llELtM9LMLoc=;
        b=ZaM2nqsKIyAgl3/YpKjKy6stToMpcFTzFoAkaBgxNbi/4ZeTXWJQpi3lD+CoCbtOwf
         HPAAHBWk8AFiKjNnTeA3xV7YgaxiUryI9FMvpJxJte1aENxNC1tFp1q0tUldaWNxmcVh
         Jlcx7fUFItUH/DYLjGJ4LpkvDvUDM5PrVdnoWAl3XhO+AwKrslXF2y6X4nIEs/6KHw8X
         hF96DS7yXgaSgm9Ip/KAdmsupz8sL+hCHYBqB451klgfM5XfshudmD/rd6Ja0aEvGyZw
         Lr83Kea0BaUeHHFEU7GRmvOReJAHOd7/fBlViPdRmtY32WesyKSZdkEt7pu2Zb4lYwMp
         ZpYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763684662; x=1764289462;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oGd96OzltDe2oScYSMy6IxJhoHTysu7llELtM9LMLoc=;
        b=KxF+1dTvjuiEI/5zOA1me2jMYM8ispRXLlxH20CKwhFfp946zWoJcxSNKtX/Dnbg8a
         WAbxEcreDKGJ5d1r22lmlkT3fJ7aTBEpg/YcHcf5iJvJ9Ac+HORp09k25k4+JSrJ6AoC
         fpheJ57S9vTNqMMg6KBNuqUNwkLyyxxuLbGITCRyKn/6abdbtqvePkjPWvKLz/eAvBsu
         EU2ScxIGw2SfWrvHzO4ubcF/AnvDxr+pLEWAnAbJYooHRofXbdQ7NeeQl6T00vbA2x6K
         yW2btOmc0tPq2GvG+qe4Zl1se8XDtoo2s55PUPBPgm542amvVlbkdMbQUBfbFewl9kZK
         4ydQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7hRxIUh11QX/gbFpnacAj/WrDZQ+xhErHyBVcFS1nQJU2B1oMxcJ/Tj1oP/w1Nq+6E5c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwNf7EVUeaEcUi2Oh1qy9KRsYIDBsPVIdysL+3yRNonIquArx0O
	PNyySqELGg/28lc8bL+CR64fmcoJcGix3fMydRVVZ5nXZZnLRHBcCmaehK8+rWe9Hh7oP822IGp
	TFKh1Pw==
X-Google-Smtp-Source: AGHT+IGcJW8CLz8xQUpZviFtpcwWxG1D7eJa/+Xzi9UYxz87MzTpWm/PcxpyBZooQN1u8LJlPUFNY5vJavc=
X-Received: from pjis12.prod.google.com ([2002:a17:90a:5d0c:b0:33b:ab61:4f71])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:ec8f:b0:335:2823:3683
 with SMTP id 98e67ed59e1d1-34733e4b2ccmr325314a91.9.1763684661676; Thu, 20
 Nov 2025 16:24:21 -0800 (PST)
Date: Thu, 20 Nov 2025 16:24:20 -0800
In-Reply-To: <t4modyzuwzmlmu4hcwpxzsbprhebjwuz3uc2doc6nauepruczw@vray2facmzks>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
 <aR-pMqVqhgzsERaj@google.com> <t4modyzuwzmlmu4hcwpxzsbprhebjwuz3uc2doc6nauepruczw@vray2facmzks>
Message-ID: <aR-xNA0l2ybr0UqC@google.com>
Subject: Re: [PATCH v2 00/23] Extend test coverage for nested SVM
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 21, 2025, Yosry Ahmed wrote:
> On Thu, Nov 20, 2025 at 03:50:10PM -0800, Sean Christopherson wrote:
> >   KVM: selftests: Extend vmx_tsc_adjust_test to cover SVM
> >   KVM: selftests: Extend nested_invalid_cr3_test to cover SVM
> >   KVM: selftests: Move nested invalid CR3 check to its own test
> >   KVM: selftests: Extend vmx_nested_tsc_scaling_test to cover SVM
> >   KVM: selftests: Extend vmx_close_while_nested_test to cover SVM
> 
> Not sure I understand how you to proceed. Do you want me to respin these
> patches separately (as series A), on top of kvm-x86/next, and then
> respin the rest of the series separately (as series B, with your struct
> kvm_mmu suggestion)?

I'm going to apply a subset "soon", hopefully they'll show up in kvm-x86/next
tomorrow.  I think it's patches 3-9?

> As for set_nested_state, if you plan to pickup Jim's EFER fixes I can
> just include it as-is in series (A). If not, I can include
> generalization of the test, and send covering Jim's fix separately.

We're likely going to need a v3 of Jim's GIF series no matter what, so let's plan
on bundling patches 1-2 with v3 of that series.

That leaves the paging patches.  Unless you're super duper speedy, I should get
patches 3-9 and Jim's LA57 changes+test pushed to kvm-x86 before you're ready to
post the next version of those patches.

So:
  Fold 1-2 into Jim's GIF series.
  Do nothing for 3-9.
  Spin a new version of 10+ (the paging patches) after kvm-x86/next is refreshed


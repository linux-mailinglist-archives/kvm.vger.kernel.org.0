Return-Path: <kvm+bounces-13949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4565089D028
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 04:02:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4031282CA8
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 02:02:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A84A551C5A;
	Tue,  9 Apr 2024 02:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n1yyYNVV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BD951036
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 02:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712628115; cv=none; b=IJn6MX3rJl3EIETOirBf+Xo0kHXBekdRCUj19XSwCh7Y1eb1e498FcXfgPmcpN83ZAWKVXlH2+81JUMxN1EwJbDFtX+zTDrwPZOrsU8IqTCmYV3e1cz4bor5ZtHGxXWaGGOBqrUQMaY+ovuke/ICxoLmUXX1fcaRU4IKKTS/wDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712628115; c=relaxed/simple;
	bh=Idd1OGdzEkMkRZJRWImpyOGXFz5IB4BbPtSiNGNyeHQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FunGx4Fem0v1WV1qrDSo9tDnZboakUAj9iivquCGzs/xa96qrlO3LbPz6AV+dg7N2WHxwX9S9AvoYy5lc/Wa43RjwABHdBtf+3Okc0KgR6+d9iL4VzXpsJrxxJW9Iok3zl5NwFtm6QH1ehDdnvHux3SbJjn5oi45aiuzUSV2gME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n1yyYNVV; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61506d6d667so87916747b3.1
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 19:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712628113; x=1713232913; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2FWHqdez77NfnwFdv1MlKZWeYLKe/YUQINtEFCpbrlo=;
        b=n1yyYNVVdudZ9KtPOJO00SGJdhG39Svc8MUHVGzo/DtVZ0Ib3e++4091LnjRnAwWLS
         DiLmr0NGV/43YfzD9b8UaE9oJ8CEDONDFwWNk0x93gJwSfjNLv/WKuFhVnAQ5G4wq1Xe
         YFvm7c2JkHhdZCVskiIPwa5V84mj7NPc1Pd1AbIBjv3ZSwkoWk+9jnJ3SEoqGJuvbDgX
         A7Ruo5XKsG1sxavpWE+bNsrWeYSfhKVbn/v0708WFCA+hRsitk257fogBLMXcQwlllC4
         hB/SFlH69Tq7fbuIrO8y09LfpxdB11+YpDfSs/h1zTe0V7vinMZOglr0WLQjNOkngcEg
         708g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712628113; x=1713232913;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2FWHqdez77NfnwFdv1MlKZWeYLKe/YUQINtEFCpbrlo=;
        b=DaHPyl85egMXjVX0U1Dl6uO2JvdQVju/Co8O7/PS37OWG4kxklAi2pMVbA1yqn5K9N
         ujUE1l5dIE0lG/u23xUwGTV8AFpJOTIFRuqj1SWlraYf1UCi3kCgj6v+IjjgcqZnPvUj
         ZNfJJHmFlRSrYTbHCmoKLASlku73fSXYb1b/m1LvBsYLWhmJ2OHj8Y54/ELTxidPIrRx
         xraxHXoloa6yQPp5zR+jw5Ejv5UlCjR3YGGPyMR74Z0SqPUi2Kd0fiVYcM8k23OPuaG+
         Ks15cXQVl98ljEGIK71/x4L62ce3BAHUndNhvkQHkDOTrgfnLlXnhpnOEIOxL5Rz3x+K
         m6fA==
X-Gm-Message-State: AOJu0Yz8DRnwoLKMfI/9gCjKf0sl/PJSwNdQLUNHSl+xbehSRU8CPUES
	F9ab1dVqe647lf1eXuk0iAyb8XHQfWJemXJEjhoByChCkz4mWlLn9QQV5Fm5zlruCDMlqZX1Yuf
	N5g==
X-Google-Smtp-Source: AGHT+IHvN10zX5HDwpDTrA4Ys3GezE7nVjPrebT42ZNWDZUsBcoJgafbRr1uHe9OjYnu9Hus3bcaV0c+pGY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1893:b0:dcc:5a91:aee9 with SMTP id
 cj19-20020a056902189300b00dcc5a91aee9mr3228659ybb.7.1712628113439; Mon, 08
 Apr 2024 19:01:53 -0700 (PDT)
Date: Mon,  8 Apr 2024 19:01:27 -0700
In-Reply-To: <20240405235603.1173076-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240405235603.1173076-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <171262747625.1420673.10308591615885503972.b4-ty@google.com>
Subject: Re: [PATCH 00/10] KVM: x86: Fix LVTPC masking on AMD CPUs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sandipan Das <sandipan.das@amd.com>, Jim Mattson <jmattson@google.com>, 
	Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 05 Apr 2024 16:55:53 -0700, Sean Christopherson wrote:
> This is kinda sorta v2 of Sandipan's fix for KVM's incorrect setting of
> the MASK bit when delivering PMIs through the LVTPC.
> 
> It's a bit rushed, as I want to get Sandipan's fix applied early next
> week so that it can make its way to Linus' tree for -rc4.  And I didn't
> want to apply Sandipan's patch as-is, because I'm a little paranoid that
> the guest CPUID check could be noticeable slow, and it's easy to avoid.
> 
> [...]

Applied 1 and 2 to kvm-x86 fixes. 

[01/10] KVM: x86: Snapshot if a vCPU's vendor model is AMD vs. Intel compatible
        https://github.com/kvm-x86/linux/commit/3b764d0af391
[02/10] KVM: x86/pmu: Do not mask LVTPC when handling a PMI on AMD platforms
        https://github.com/kvm-x86/linux/commit/85cff527ab31

--
https://github.com/kvm-x86/linux/tree/next


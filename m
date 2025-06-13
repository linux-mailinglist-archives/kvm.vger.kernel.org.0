Return-Path: <kvm+bounces-49513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 70326AD95E0
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 22:03:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B7001BC32A4
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 20:04:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 544FB24E4C3;
	Fri, 13 Jun 2025 20:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wu1aolB8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1C6248867
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 20:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749845000; cv=none; b=oQdPymXYnZVRx/1tAHG1bviFIUDBna2pk32wVTAZNJ4pbdN1VPvtMjodgSQGrgsqGIyVCdse88fYqOyIQOzXLTPFCixBPPPpGbnU1NbrOWgqSIXJvPGNlxkmY/2FHR9UUcGjukOHRgRCm0/S7JKjTdEohtas/Kg9V/J37aSrSOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749845000; c=relaxed/simple;
	bh=H1fXVD8SmgWbaPrQ37kvyYzIJ8KMmGQOBuk316FWEpU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hGtBt0JCp2F4R6F/To94oeAAGcPiYoXIyo//IN6KAzXD/QtI+YiNtLTOBQeCJddZyyPqsUQG4dD+wN6CvvSnCdGoHA9C1xte3iUdj5/WZ3OBrOMhpwhZkqXSyQ0NDNR3n3How6JicW2qpZOynZfzimnAbBJFEXQWc0i3LpwyaDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wu1aolB8; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-31332dc2b59so2103643a91.0
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 13:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749844996; x=1750449796; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9jkTY9es+L0SHOQjbsKMylNmSXtoJEwR4XCF9O55X7U=;
        b=Wu1aolB87FBOhs+l1YK6rRSlhgdVaYprjE/vORx1mZMg1R/XBTqFq2dboxqRo8roBC
         et+qi0oBIjByY5omKChJN2M264RIaS2felZjZ8Dyb4Rhhydu3z5Z/oXNd/bcuAvz53ku
         4oyWySSLBh8F+nk39FMlDhieu/+SWzaNaK8jD8aNg9IXKXkw9neIbwO+wVHgo2rQCiqo
         Oj6xyFh2br7z7npyjBHCLcEKM3DMLqPHh+Bben/6Ybq5wzeSlIfD+664JlzHlExBmiw2
         d0vHsjzobBfxDMx5BkvN1ssUWTQ2yAql41TaqDV3sqgyjGiC9y+akOWCLaeUjyBM73af
         Jvog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749844996; x=1750449796;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9jkTY9es+L0SHOQjbsKMylNmSXtoJEwR4XCF9O55X7U=;
        b=PE5Icza8CMRtK4CV0eTxrTdU420MlbSThgohtZwJqIcHp68M2AwT1+nSn++AxUsdVp
         jyGl3Bd31g3Mxhp2BY45xgTd99Tnrqkcnq4x+CnwmqwDU0rg4c31l7EwshJQPixMiFrs
         fRjU7I7K6z7lPEdwN7EMPSGF9JW3um4K4GPetzGNSINwmpv0o9/dw+If1QnEaL8DQUji
         CC3qGgCHI3JGMBGwBdCcfoYPqpq0hijy9sKsX7C9VoJ2k6hmRTpTiaG21OjO9yjmU8vL
         FvI1bIEvFGx7ADmUPzfkDV8zpfRgnh9fN//OAjoUllqhxK2YgnvFuk6CMGjHQdrUNVid
         4s0g==
X-Forwarded-Encrypted: i=1; AJvYcCWTDuTfbcP3DRx3q7M0IqRDGAnVS+nH/dMX/Kk++plojRvKdUuuSIBsXmI8+ZCUlA656Fw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGX8/wGWEqu3Jhijp2Fh2H3AeGEp8PgiOhSQrbxwTzaKyOhtDn
	FBhqgthUiqHG8Aa9cHuhujxG6M+eOUuLdKomLVi8M+es+ae4a7/2iF5D12KXxAHAZaxI+S2QJZq
	+2/Fcpw==
X-Google-Smtp-Source: AGHT+IHeFRFgvpHTT7ADjIBFSpJOAij4nlVS+2t6k1iLjMAhZ20QavMK8ENnHmWsKo/qdTUkyN8SO+Uybws=
X-Received: from pjm11.prod.google.com ([2002:a17:90b:2fcb:b0:311:ff32:a85d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:55cd:b0:312:639:a06a
 with SMTP id 98e67ed59e1d1-313f1d0aa4emr1327100a91.31.1749844996505; Fri, 13
 Jun 2025 13:03:16 -0700 (PDT)
Date: Fri, 13 Jun 2025 13:03:15 -0700
In-Reply-To: <00358cf3-e59a-4a5f-8cfd-06a174da72b4@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250613070118.3694407-1-xin@zytor.com> <20250613070118.3694407-2-xin@zytor.com>
 <aEwzQ9vIcaZPtDsw@google.com> <00358cf3-e59a-4a5f-8cfd-06a174da72b4@zytor.com>
Message-ID: <aEyEA6hXGeiN-0jp@google.com>
Subject: Re: [PATCH v1 1/3] x86/traps: Move DR7_RESET_VALUE to <uapi/asm/debugreg.h>
From: Sean Christopherson <seanjc@google.com>
To: Xin Li <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, pbonzini@redhat.com, peterz@infradead.org, brgerst@gmail.com, 
	tony.luck@intel.com, fenghuay@nvidia.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 13, 2025, Xin Li wrote:
> On 6/13/2025 7:18 AM, Sean Christopherson wrote:
> > On Fri, Jun 13, 2025, Xin Li (Intel) wrote:
> > > Move DR7_RESET_VALUE to <uapi/asm/debugreg.h> to prepare to write DR7
> > > with DR7_RESET_VALUE at boot time.
> > 
> > Alternatively, what about dropping DR7_RESET_VALUE,  moving KVM's DR6 and DR7
> > #defines out of arch/x86/include/asm/kvm_host.h, and then using DR7_FIXED_1?
> 
> We definitely should do it, I see quite a few architectural definitions
> are in KVM only headers (the native FRED patches needed to reuse the event
> types that were previously VMX-specific and moved them out of KVM
> headers).
> 
> Because there is an UAPI header, we probably don't want to remove
> definitions from it? 

What #defines are in which uapi header?


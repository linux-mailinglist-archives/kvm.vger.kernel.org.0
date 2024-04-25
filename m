Return-Path: <kvm+bounces-15929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 935D08B241E
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 16:30:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D25F288561
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 14:30:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0053E14A4D0;
	Thu, 25 Apr 2024 14:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1REExwm0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078275B1F8
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 14:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714055446; cv=none; b=dXAfntEsJNft6ZT/mQHTUJwG9IjsHRrSnKo86EKIUmLiIq0R6YohLT312rrMxj5V9fpPvKghDLQs3twqcYzNXV3knn6tPWEbBrtHQO/K/vlCN2y+QtmJb4nuj6H43eTQ25tLovOA/aEOLJ1sgkgKgruUpS8U+DEXdFYm163qC/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714055446; c=relaxed/simple;
	bh=DLzP+3Hp24Q60ySS9izVdIdMXy4Y3mqooLkZvnVRdM4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UTetoDKnktZs1j5EiV7cOhpdM08VhwYyQuhE03jSikguKlqYqIk+KnJa0BBt9KO5P27a2bULIbC9CK7u1vx2gQ882XkPzs4A9c4M15VSJWV/swzDmxL+Jrx+CiA+6aA1aUXBEDAAbiwtU+rTpOFsQqAwCDqsL54kNfFsp4FEUkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1REExwm0; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5dbddee3694so850733a12.1
        for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 07:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714055444; x=1714660244; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OidfOhKfgKTQSCP/Z51uFSAKtD0oyBSVMoiDS/URY9A=;
        b=1REExwm06q7TMragHwHUgwYcPztEyYkITRJuzNKmmN01XcFNtpV24Tmew719/yIwUP
         5c5UlY4yURxdEwemi1ioVm6v8eqGQ3O49eUBU66htH0ZlGlZC282FcAZ5+6oBenZF7J4
         ihxnuSH6PKHrDOADTmrxuRi9GoZwvfR80yBu4cn9A6SUtB0vjdSzx3tDXmigGgTDi/o7
         D+bfxFyCvB/Qu4fZ9/fHswo+wuNZzFQfCU+axestTXgj05NWlKEgNi4VYtpf1k73YL/0
         IY2I9JU9u/yrE0ubYGrcT7WlyadQkCTQsNRu4kMDzKxxunsWUNOtFxO0nj8mUA4lnSeH
         dp4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714055444; x=1714660244;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OidfOhKfgKTQSCP/Z51uFSAKtD0oyBSVMoiDS/URY9A=;
        b=O675u0MwTHN1QJ5Jn7F1PG6/R4Yq27L7nFWXRXfBdXssNaEHtoIaQGEHirtte4cft2
         XVzaBxtx7nY0d0vmfN9pss1Nim2i721Mvvps54KUpOtH7/H+n5lFT0ZJTU+dPyNWzaIu
         Uz65ySnYb8oeCu3DDyAtkhkzys533kAUsr6zU6O+853cvx3cHVuZUIOSV4m4ON63izIO
         YK8hpPOBcFu4hBkGIwviYDlqxGZfWaO35yUMgyBvs4SyNkUPwImqt3W+n4jQpYfXI0jB
         FHuViGobyq/4MrsYfJp8IdCIc4zAY204/rZG+4ACYDbAxKHaMLo/FW83pW6UkWdowv6a
         pyfg==
X-Forwarded-Encrypted: i=1; AJvYcCUQrFJdSYktFbFA96jPzI/oydt3f6s8kNfybUtPK9u7LyrdWFstBZHNToHaEt2tQbVS4jse5vj6OKCnrar0EyiYPx0x
X-Gm-Message-State: AOJu0YwnPQ+mk4J25T9xOEZwXepCWykWZgeTHA5AgZ8d2/64yFhOJf5E
	AYAm2rOgDT1b3Gn/enpRrXXYoeJHYDXrmRQMTYEkIy1KgiEF5o2ArMwdJ4MvYWDT4RMCgb/Y+Lj
	2BA==
X-Google-Smtp-Source: AGHT+IHAff1VD29O3wmP83ETaXK4RYSPcQ9B5eo1n44lKxTDPCjOxG2hCPXznlRe/zQW81Q0SxEekAv2Y3Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:621:b0:5f4:36ab:acad with SMTP id
 bz33-20020a056a02062100b005f436abacadmr13452pgb.5.1714055444144; Thu, 25 Apr
 2024 07:30:44 -0700 (PDT)
Date: Thu, 25 Apr 2024 07:30:42 -0700
In-Reply-To: <4a66f882-12bf-4a07-a80a-a1600e89a103@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240423165328.2853870-1-seanjc@google.com> <4a66f882-12bf-4a07-a80a-a1600e89a103@intel.com>
Message-ID: <ZippEkpjrEsGh5mj@google.com>
Subject: Re: [PATCH 0/3] KVM: x86: Fix supported VM_TYPES caps
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 25, 2024, Xiaoyao Li wrote:
> On 4/24/2024 12:53 AM, Sean Christopherson wrote:
> > Fix a goof where KVM fails to re-initialize the set of supported VM types,
> > resulting in KVM overreporting the set of supported types when a vendor
> > module is reloaded with incompatible settings.  E.g. unload kvm-intel.ko,
> > reload with ept=0, and KVM will incorrectly treat SW_PROTECTED_VM as
> > supported.
> 
> Hah, this reminds me of the bug of msrs_to_save[] and etc.
> 
>    7a5ee6edb42e ("KVM: X86: Fix initialization of MSR lists")

Yeah, and we had the same bug with allow_smaller_maxphyaddr

  88213da23514 ("kvm: x86: disable the narrow guest module parameter on unload")

If the side effects of linking kvm.ko into kvm-{amd,intel}.ko weren't so painful
for userspace, I would more seriously consider pursuing that in advance of
multi-KVM[*].  Because having KVM be fully self-contained has some *really* nice
properties, e.g. eliminates this entire class of bugs, eliminates a huge pile of
exports, etc.

 : > Since the symbols in the new module are invisible outside, I recommend:
 : > new kvm_intel.ko = kvm_intel.ko + kvm.ko
 : > new kvm_amd.ko = kvm_amd.ko + kvm.ko
 : 
 : Yeah, Paolo also suggested this at LPC.

[*] https://lore.kernel.org/all/ZWYtDGH5p4RpGYBw@google.com


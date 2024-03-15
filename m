Return-Path: <kvm+bounces-11929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2579787D320
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 18:54:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0D6C1F245B4
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 17:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 590CC4D599;
	Fri, 15 Mar 2024 17:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="04cfUQk2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324A74CB28
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 17:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710525258; cv=none; b=jY/6FZui1sSacAyJPglvp0EsiaLMi6ynfw/Kv67YxUZ1xaSmhwrGxk1IUEhOrsUPmuWs6Z7MqUah6W3bKho3+BTtXp+l2BiuxYckb3l1O60I+e/BV35UV6yHke9cG3jSJ5q9DpFP/Ie7+FXTWM95trQDkcTmEYsmRg9NRKjqCZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710525258; c=relaxed/simple;
	bh=lz9UOu8zwPxOJOC9JnglDqWSmLeWMHfg3F8fVmAosDA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pfnGhvOFhwldekH2IRKdc29YdRrV16PAkowc+RR/QbFkQg/OGPj55VzgWhMgiMC0pp2/s5RpPwwJ2awRRm6WvuxJCDGHTgUupUOAu9DJ/0+i0cA1SJCPue1oiknFIv0WqFRWPx+edDyLljcfePV86IMOrlqwy9wxc0NQR2vKiuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=04cfUQk2; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5dcab65d604so1796842a12.3
        for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 10:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710525256; x=1711130056; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tCsDGVvQ5JoDUuAN7b8P1xADRPn/t2ImWR7kgkVi4o8=;
        b=04cfUQk2ojDZ8Zg9YW2+FbR9NI9xSkZMiv+3ZrwgTJ9EvZzyc70KJqVsGSCEZoNG0T
         3q34VZL/CJuJ7BWfZbKBXddBcNVvnFZeylWZFd4PRKZlzVSxeOLRDIqYL8f6roUu7P1q
         lswDwJswVZflZT7eCYYVDQr7sycroI9g9ljjZEhljJy/hf5nkSjE+VCOY7k0TYOTYlNW
         JqNhCAXxGCMpSX1Y1fCmWlHR+LV1Hf7Ad/FRWJpjUHdoKtjoIznqTdHOiYLpIqBAhdtB
         d92HPyeTo71mamND81M/GQfnZl1L8m1lg8gc1sIAPvze5HJbxA9+9C0Ry1dAZgY6HZY4
         EUOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710525256; x=1711130056;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tCsDGVvQ5JoDUuAN7b8P1xADRPn/t2ImWR7kgkVi4o8=;
        b=RV1Deyyh1oz10y1J1dkbnX1KF1wvV6cVDyqyhso5t0I8ay81sgB+hnSts7BN6SHuwt
         8sjWmNkUzbGmgQEbHhJ3qb8n5I12wr67+1zq8iarzWdDFQ9BSDRM68ArRGMcClMQWlAf
         N/lJNfZDVepLCW8UHOHynZFu4Sa/g0loJcudz7wPzAt4H2wD181Y91NmOZ7487KcZgP7
         09+QArNwXyQSTV1NKauVNbgxWr0ZDO3B5CCS6pW36254zyk+fMXn+56UDkr5pLRXcKmv
         AQP1dSjJseXCf9nwXU8kcAmjvrVypwhaN6baQuwRKgyf5IL8Uhg27jvuAdRunj/iTQ8G
         HPTA==
X-Forwarded-Encrypted: i=1; AJvYcCW/YkFK9UB6VGnAO1cPIH8Wg+8AOKzMnUy2n50dEfcSbx0ZTx8JRmEaKEyWdNU24kh6NAT9yl8k7P6BD82reifSNh28
X-Gm-Message-State: AOJu0YwxvjfQBsViPIG52H3STG5AKxZrVfAEk8z5/L2ygaQb0A6AaOgA
	eOzEtuMxzGCpVYYeyeH6ZEL6taD+eY6/EDpAeGoEgCCYLk4ZQZq4XSUGsSuP4IUTah/W/JqjQHM
	FSQ==
X-Google-Smtp-Source: AGHT+IGx3iU2+pXYgrsYlfzRD4L2SFsFI2Lh2FuJp29A8reYoyIdPfgXOZkztIK0oo4Aw0JFW3nQyT0NIVw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:6546:0:b0:5d6:cfc:2f39 with SMTP id
 z67-20020a636546000000b005d60cfc2f39mr13226pgb.11.1710525256443; Fri, 15 Mar
 2024 10:54:16 -0700 (PDT)
Date: Fri, 15 Mar 2024 10:54:14 -0700
In-Reply-To: <ZfRtSKcXTI/lAQxE@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309012725.1409949-1-seanjc@google.com> <20240309012725.1409949-9-seanjc@google.com>
 <ZfRtSKcXTI/lAQxE@intel.com>
Message-ID: <ZfSLRrf1CtJEGZw2@google.com>
Subject: Re: [PATCH v6 8/9] KVM: VMX: Open code VMX preemption timer rate mask
 in its accessor
From: Sean Christopherson <seanjc@google.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Shan Kang <shan.kang@intel.com>, Kai Huang <kai.huang@intel.com>, Xin Li <xin3.li@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Mar 15, 2024, Zhao Liu wrote:
> On Fri, Mar 08, 2024 at 05:27:24PM -0800, Sean Christopherson wrote:
> > Use vmx_misc_preemption_timer_rate() to get the rate in hardware_setup(),
> > and open code the rate's bitmask in vmx_misc_preemption_timer_rate() so
> > that the function looks like all the helpers that grab values from
> > VMX_BASIC and VMX_MISC MSR values.

...

> > -#define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	GENMASK_ULL(4, 0)
> >  #define VMX_MISC_SAVE_EFER_LMA			BIT_ULL(5)
> >  #define VMX_MISC_ACTIVITY_HLT			BIT_ULL(6)
> >  #define VMX_MISC_ACTIVITY_SHUTDOWN		BIT_ULL(7)
> > @@ -162,7 +161,7 @@ static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
> >  
> >  static inline int vmx_misc_preemption_timer_rate(u64 vmx_misc)
> >  {
> > -	return vmx_misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
> > +	return vmx_misc & GENMASK_ULL(4, 0);
> >  }
> 
> I feel keeping VMX_MISC_PREEMPTION_TIMER_RATE_MASK is clearer than
> GENMASK_ULL(4, 0), and the former improves code readability.
> 
> May not need to drop VMX_MISC_PREEMPTION_TIMER_RATE_MASK?

I don't necessarily disagree, but in this case I value consistency over one
individual case.  As called out in the changelog, the motivation is to make
vmx_misc_preemption_timer_rate() look like all the surrounding helpers.

_If_ we want to preserve the mask, then we should add #defines for vmx_misc_cr3_count(),
vmx_misc_max_msr(), etc.

I don't have a super strong preference, though I think my vote would be to not
add the masks and go with this patch.  These helpers are intended to be the _only_
way to access the fields, i.e. they effectively _are_ the mask macros, just in
function form.


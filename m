Return-Path: <kvm+bounces-24203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8309295252B
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 00:01:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6D111C24DCD
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 22:01:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEE6E14D719;
	Wed, 14 Aug 2024 22:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AP3trLNF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E111149000
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 22:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723672845; cv=none; b=G/0KIr9cNxbNY28Mw3ckxceTywA7Wo/5GdoFKuP7igL2m60r8FzYjlatbWVVo8yCoz+luagEZ60cVORSnE5S8Mv9zHLFA5q3NmFvAHeJbi36Z7oTs9IjG1/zZSSxgrvPcTSZ0lkezehMOZJnpWGLPrPiKf8SRDc16KKAu/e6vfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723672845; c=relaxed/simple;
	bh=uRXjIX6o3jqniHqBvNFoA/0kF5YG9DuENMSbXpC82UY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lF+aFsRhe2qhkzK/Uycug2WWNypAmDdmpStQ+jwpZJFjFJOJDNKK025ojMirWSoOIOBdr1DmQA1Bhw/mSJcsGrw7tumiCNOTu0y/yKTYC8H+UjPaLmr22yCgNYnbvc9STo9LTtQg0/ewn7INwlcGLJwBdNn/qSNSmo74xsmOHq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AP3trLNF; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-200aa7dbc3bso4240905ad.3
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 15:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723672844; x=1724277644; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5oH6P3nqpQ94wKrIC/Mozd39AchaUcxSzRhAmiF3FGo=;
        b=AP3trLNFoIDfDlK7Z7oGentd32HbvVd9DlajPaRESkORInffK4pSuO2aMh/HC+RL6S
         4nD8AgNqE5oEoWMX0rPqASBKpKC1Kgucu6TdIDkLnj+a3CuJJBEKNurrZ+URfIC6rAuu
         g46wwKTZZrssXndjkzqWxlU3zJAZE5ytyRjKJ0P3eN4mCcHqM58qP4hVTFmqKMHRGBmj
         otj0iXb/CjAgj59x0KsBapxUUype3NwGlWIZbtxL6APIRnOkbnQoLiBoDOyYcS7wgJID
         0Y07xKn2vaILqWXILBChZW8Y34SXd4MTUXjbDmK14cNi8WROog/27PelvIIydV0rg98n
         OcuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723672844; x=1724277644;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5oH6P3nqpQ94wKrIC/Mozd39AchaUcxSzRhAmiF3FGo=;
        b=A7YheLU8zCvGBcS597jBZByfRjzhyoT8UG/YCKVnrpZhWPl/OalnlVTZeUf2Z8n4VI
         6os4PUrEnrvoyBdTENOS/VEBkz4+BMvd032TembJ0/DY7OPP8kqGiH7LCYt5nQg1gTIh
         VEMltY40xLKKNFykCTHwFOYHbSP3qbOP9jjJHgrIccVnrm/ot4/skeU8rZTAjoeCQmpZ
         ZBuqdkUKxUaSKHxnbHGra3pR4XQ+S96clNgvIE02kG44EeSFTBYVPZHCjGsSeqpPg0gQ
         2MWaK7VUuuOYC2iEGAKz7BKqAfgXzGQMgwg8prNmYADrG17Kg6EF33JA+8efZweewgAk
         wBjA==
X-Forwarded-Encrypted: i=1; AJvYcCX4UD69j3bnD/kwzScdRWLbfmlUeIKnbtC/LLNE6DqRsf8xTMkCwolcPwKozBAOW/+Pi4PQWdNCwFQFCV9Qqw7VK3/9
X-Gm-Message-State: AOJu0YxgKsO72CsGyd2yDhq1ocsWGvZj3BcQ6Yor4xTxnfmdWjAcam92
	SVhczbXc2uDB6ldve/zp28Ac0MUdJnUBmtMmV3MAex45YbvIxW6R8fbBnSs8qW9ihDblyFO9f5f
	XDA==
X-Google-Smtp-Source: AGHT+IELSmNcIfcWqD1y6wfROgLi5On6yYa9ztLE8WB0+uhpire+X0WHbKhlLbGeYLBF6mQ5SB34xpmbxzM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:da8b:b0:1fd:6529:7443 with SMTP id
 d9443c01a7336-201d64b4f7bmr3318245ad.11.1723672843639; Wed, 14 Aug 2024
 15:00:43 -0700 (PDT)
Date: Wed, 14 Aug 2024 15:00:42 -0700
In-Reply-To: <Zr0ZbPQHVNzmvwa6@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809160909.1023470-1-peterx@redhat.com> <20240814123715.GB2032816@nvidia.com>
 <ZrzAlchCZx0ptSfR@google.com> <20240814144307.GP2032816@nvidia.com> <Zr0ZbPQHVNzmvwa6@google.com>
Message-ID: <Zr0pCqo1YtkiuGqb@google.com>
Subject: Re: [PATCH 00/19] mm: Support huge pfnmaps
From: Sean Christopherson <seanjc@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Oscar Salvador <osalvador@suse.de>, Axel Rasmussen <axelrasmussen@google.com>, 
	linux-arm-kernel@lists.infradead.org, x86@kernel.org, 
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>, 
	Alistair Popple <apopple@nvidia.com>, Borislav Petkov <bp@alien8.de>, David Hildenbrand <david@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Wed, Aug 14, 2024, Sean Christopherson wrote:
> TL;DR: it's probably worth looking at mmu_stress_test (was: max_guest_memory_test)
> on arm64, specifically the mprotect() testcase[1], as performance is significantly
> worse compared to x86, and there might be bugs lurking the mmu_notifier flows.
> 
> When running mmu_stress_test the mprotect() phase that makes guest memory read-only
> takes more than three times as long on arm64 versus x86.  The time to initially
> popuplate memory (run1) is also notably higher on arm64, as is the time to
> mprotect() back to RW protections.
> 
> The test doesn't go super far out of its way to control the environment, but it
> should be a fairly reasonable apples-to-apples comparison.  
> 
> Ouch.  I take that back, it's not apples-to-apples, because the test does more
> work for x86.  On x86, during mprotect(PROT_READ), the userspace side skips the
> faulting instruction on -EFAULT and so vCPUs keep writing for the entire duration.
> Other architectures stop running the vCPU after the first write -EFAULT and wait
> for the mproptect() to complete.  If I comment out the x86-only logic and have
> vCPUs stop on the first -EFAULT, the mprotect() goes way down.
> 
> /me fiddles with arm64
> 
> And if I have arm64 vCPUs keep faulting, the time goes up, as exptected.
> 
> With 128GiB of guest memory (aliased to a single 2GiB chunk of physical memory),
> and 48 vCPUs (on systems with 64+ CPUs), stopping on the first fault:
> 
>  x86:
>   run1 =  6.873408794s, reset = 0.000165898s, run2 = 0.035537803s, ro =  6.149083106s, rw = 7.713627355s
> 
>  arm64:
>   run1 = 13.960144969s, reset = 0.000178596s, run2 = 0.018020005s, ro = 50.924434051s, rw = 14.712983786
> 
> and skipping on -EFAULT and thus writing throughout mprotect():
> 
>  x86:
>   run1 =  6.923218747s, reset = 0.000167050s, run2 = 0.034676225s, ro = 14.599445790s, rw = 7.763152792s
> 
>  arm64:
>   run1 = 13.543469513s, reset = 0.000018763s, run2 = 0.020533896s, ro = 81.063504438s, rw = 14.967504024s

Oliver pointed out off-list that the hardware I was using doesn't have forced
write-back, and so the overhead on arm64 is likely due to cache maintenance.


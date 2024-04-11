Return-Path: <kvm+bounces-14314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ADCB8A1F11
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:05:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA51D286082
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 19:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 323E3205E18;
	Thu, 11 Apr 2024 19:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OTCyS/BY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18040205E14
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 19:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712862332; cv=none; b=tVH1YC+rZcjjtf1ClLMjwPObu8NYLGWuMznAO/kR3FuqNsNWP4yVv+2hXI6NBpdyzdbg7P7oYsKCsariY/dG6qNtDAHnQaG1jiAHmsmeRh/Ph/5RIWgiSpOj4CN3B5okPzTIVELMWy387pzTVmJcr09Rtcm53cKPwJTa6LTUTik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712862332; c=relaxed/simple;
	bh=Ocy+0fEzfXS5sQAYwDMV8ViHyq+Ou3j+fV+ygiLQfSY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sKUCwFuOOt027oVDZmF8/aZ3m6glo64BHZumtzqAkkWLTCMdFoBJMlxMVAfb4mpyrgNYYQtCZ+O84jxe/V0g+SLPN8cWJV/nvRXsZ0yih6tkfM7UzP7721Y3GSoBsuYbhtlzTIe1PbXL/XlUegiJ+0yVu3DCn/6k789gCBX9n/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OTCyS/BY; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60a20c33f06so1129597b3.2
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 12:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712862330; x=1713467130; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=clKeq70RPFc9QXZP7aF0MPVECFwTUekvQYtIoU4m4cM=;
        b=OTCyS/BYVf+ENgYAbGX1LJ0oJYrmUiuxBZ/VR6HPeVtHXNopiRvTh2WrqWgog5NVdp
         WRHDekQiezQu2dKpus+TOWdcr4w7qQmi8zZMRYfe3r3LsYBTaYKrcVEp/yBJxU22Qq2a
         gfZ93fQKkNHIKQCBWwLOMxKn0jaj4/h6kZAn1wIj0Lxuu2ea6U5inln+Bvqm+z6u/RSw
         /o5GezRrFWkZZErs4epuwRfjyGCN6gmSCNTaDqhsv+k7+T7EsMaAgLnRi88wZ713b5Pk
         9nArVE/XAWOyNU1YzhH62q+hnWRiUUUEs84TgJLsB/c7pa+TtDwk+tmyP4XQxqnCCoEO
         n4MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712862330; x=1713467130;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=clKeq70RPFc9QXZP7aF0MPVECFwTUekvQYtIoU4m4cM=;
        b=vUhxQ1F/svFRsKL709g6nMbollti76urginGytmTf1EYZzN/mXp6p72kvRzYbi/hcb
         CWF5BbtLTutVjoImwHuXWFwewOSqaj214c/NwI/7LRXx3VxuvWM09HltRf8K4CKN5+4T
         +yAWZbSL0ZQOJAbNr1UIKyuCmH9h/hTNWpVvOCE8mKAlAUOsla1NY0DjyEr9rxr9HXv/
         ntlcKmNb3w8T5rdfS8942Xv0rCAqWZnLcEHkuHuaqv8pZRnCnmXOxT12PuJtv9q1rvD8
         gcix7567suf1U9CMAoDN+/cbcNsgRMYFTBJbodGjwa577tfXUms4pBGEABPd4e1SGlMD
         W6Tw==
X-Forwarded-Encrypted: i=1; AJvYcCVw4mH0/sp+ZsDNFVTKO04f6w35FdaFkN69lh77DyYnxE6rLJX/drFHzU1mo2+y3KG4VmJQJgAwovZazJG9eI/Ls3QE
X-Gm-Message-State: AOJu0YxcmMkoxZHlYP7qx2yTz/9VLuyvl1f2ju1AaY/Tsuu+FwkIX/hK
	JLLaZY0a2phCG3g0AJfw2VZoEIG8IeJ2/rtK9MU53lg4x7XWy1u2Tn+qDV1Jbgi4PrgMpVIzfAT
	Wpg==
X-Google-Smtp-Source: AGHT+IEVV0K/NsKHvincQvOwZ5oaygUzm9suLbxzrsAifLIiHpIfA1J2Hnh30X4NcZ4Nz043OpUOk6/CXhI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:848b:0:b0:615:ca8:6058 with SMTP id
 u133-20020a81848b000000b006150ca86058mr70184ywf.5.1712862330335; Thu, 11 Apr
 2024 12:05:30 -0700 (PDT)
Date: Thu, 11 Apr 2024 12:05:28 -0700
In-Reply-To: <ZhgZdqAB6LlvJLof@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-5-xiong.y.zhang@linux.intel.com> <ZhgZdqAB6LlvJLof@google.com>
Message-ID: <Zhg0eLwnJsNhPu93@google.com>
Subject: Re: [RFC PATCH 04/41] perf: core/x86: Add support to register a new
 vector for PMI handling
From: Sean Christopherson <seanjc@google.com>
To: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com, 
	kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, 
	jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 11, 2024, Sean Christopherson wrote:
> > diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
> > index 05fd175cec7d..d1b58366bc21 100644
> > --- a/arch/x86/include/asm/idtentry.h
> > +++ b/arch/x86/include/asm/idtentry.h
> > @@ -675,6 +675,7 @@ DECLARE_IDTENTRY_SYSVEC(IRQ_WORK_VECTOR,		sysvec_irq_work);
> >  DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_VECTOR,		sysvec_kvm_posted_intr_ipi);
> >  DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_WAKEUP_VECTOR,	sysvec_kvm_posted_intr_wakeup_ipi);
> >  DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_NESTED_VECTOR,	sysvec_kvm_posted_intr_nested_ipi);
> > +DECLARE_IDTENTRY_SYSVEC(KVM_VPMU_VECTOR,	        sysvec_kvm_vpmu_handler);
> 
> I vote for KVM_VIRTUAL_PMI_VECTOR.  I don't see any reasy to abbreviate "virtual",
> and the vector is a for a Performance Monitoring Interupt.

Actually, I vote for KVM_GUEST_PMI_VECTOR.  The IRQ/PMI itself isn't virtual, it
is quite literally the vector that is used for PMIs in KVM guests.


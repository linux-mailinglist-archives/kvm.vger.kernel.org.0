Return-Path: <kvm+bounces-54430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15595B2136B
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 19:39:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 434BD1A21EFB
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 17:39:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A9612D4808;
	Mon, 11 Aug 2025 17:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UiH6TrUW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1357A2C21CB
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 17:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754933933; cv=none; b=gEerEFfVZCZ1cu98rqTxloi9TuGvDRLrT37z1SJO7lC04yV3k6U0o/e/d/nlfYYLX0JpwcCrPcSVmby8HOuhR8mluGjowqGiQxajR4CUTnmdXoUYCzhlb0pHv6xYabhxPjqQCj8mMgnBy/Ub2lxjxs1skVfsIZQSCQqXOqSqRjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754933933; c=relaxed/simple;
	bh=CRRkZPsmc2QQ3XWsdn2Up+MRBm+VzEWKJxGbzgiGX8M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PDCQJ3SOGVfvDzporhdGXWamGVKznLtfVoUQ7wEGtRp6uvL5h/RtYc2fpwLBFWoHHwr5/dyFzzvfuU5KasgBS1sGdSR0p7LwdGYMhfexarfNAv/lvb3UshUI0o/ITKn0CWB7rTEgyac/+GeCVniy2jgdX1QuHcOG0/V+GqDh47k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UiH6TrUW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32147620790so4906245a91.1
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 10:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754933931; x=1755538731; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=D0qWTDt5Fgc4M6C75ofKduQqjIPupxwL5rgTNSXkxj8=;
        b=UiH6TrUWNgPUoq11u9safnD3Uf3ThH2vnzBp7tRgK/MmMGLAAkZ2/lX73NyADd6mQN
         XCgP4tzH+gmHjGrl9lcOFDFIN1xnrPh9RvFCDNqpmp/P/RbGmlzAOWHQ61cpYAL1LBip
         K6QwQ5XgeXvgDczCEYWiRNdtXaA6KlOaDMefAIUZHohL2ykBwi+lOxU2CirdR3fwZ/nP
         DdYvhE7Y95MPDXc7RuQKPkYObMMGf1xO+kbcg+EQd2BZpMZ/nvmYsxRq1slrJdQRevER
         AMi3bNbgZHZ5WTuDNPv+fn1i3VigxQLGoo22NLpc/bPVRkvBlL7nlmXrn/50PpUgDalR
         baAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754933931; x=1755538731;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D0qWTDt5Fgc4M6C75ofKduQqjIPupxwL5rgTNSXkxj8=;
        b=wQJm5QmX68aWvSub94SKMGZd1mTEqDSZ5SJPSjDXqPfKAxPKw+vKQB3pPVKlCNLyBP
         41F4/Wxoc2ozWDc68C8RIpjWoVHoSRgjZHhRDlPPStnBeUfWZTpTuOngjkm6oN5WREqX
         PqFY2M5bnP7XZc0eoIG+DzrPCsyEkXjgwjsFRRPOwn+gbOxJEdbBaNEi7CsyIhlvekmN
         187V1WUs69gEfSlBAHpRDeK/U4h6m9tJLtzwVLqLvbNJbKeI6ZifreSGZhSVUZQn2EP4
         WaTRNqaj+BZDXx3nwK1IKPeJTSlopK8Ei9o8nBFDgfiQ+8sPwEQvgwyKbO6scGSJlgg0
         ZbRA==
X-Forwarded-Encrypted: i=1; AJvYcCW582AR3vvMn6pC4wglOGpTdbMeaOJi3H0HsDtaBxUgcW72y4HyVEV31kP63zWMnM4gZfY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEJF0aMOWpXGQRWm69U6wEZ8LmTXPX0Tzlg6xJV99V6IS/33Xa
	tbT00l7/CUKAU9ywHRWdECaPOtDxN8T09qZiMJcULFMfCf0vMRjkqEmsFNTziYojjGNG1jPxut1
	lRj3/nw==
X-Google-Smtp-Source: AGHT+IG/CUcmJn+gftHkvxBOV0Z2pVUCpoCwKpG1Kx2L3xffGF7ZIDvldqUNDPHKpVjYgmN7ORZxaRq74uI=
X-Received: from pjyt9.prod.google.com ([2002:a17:90a:e509:b0:31c:2fe4:33b7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d44:b0:31a:ab75:6e45
 with SMTP id 98e67ed59e1d1-321c0af20famr512709a91.28.1754933931258; Mon, 11
 Aug 2025 10:38:51 -0700 (PDT)
Date: Mon, 11 Aug 2025 10:38:49 -0700
In-Reply-To: <20250807201628.1185915-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250807201628.1185915-1-sagis@google.com>
Message-ID: <aJoqqTM9zdcSx1Fi@google.com>
Subject: Re: [PATCH v8 00/30] TDX KVM selftests
From: Sean Christopherson <seanjc@google.com>
To: Sagi Shahar <sagis@google.com>
Cc: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Ackerley Tng <ackerleytng@google.com>, 
	Ryan Afranji <afranji@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Erdem Aktas <erdemaktas@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 07, 2025, Sagi Shahar wrote:
> This is v8 of the TDX selftests.
> 
> This series is based on v6.16
> 
> Aside from a rebase, this version includes a minor bug fix for
> "KVM: selftests: Update kvm_init_vm_address_properties() for TDX" which
> was called out in v6 by Ira Weiny.

Folks, this series is completely unacceptable.  Please read through
Documentation/process/maintainer-kvm-x86.rst and fix the myriad issues with this
series.

I will provide detailed feedback on this version to help move things along, but
if v9 doesn't show a marked improvment, don't expect much more than a formletter
response.  I have made my expectations for KVM x86 abundantly clear.

Process violations aside, I am also extremely frustrated that seemingly no effort
has been made to update and polish this series for upstream inclusion.  As Ira
pointed out, there are references to terminology that we haven't used in *years*.

 : If guest memory is backed by restricted memfd
 : 
 : + UPM is being used, hence encrypted memory region has to be
 :   registered
 : + Can avoid making a copy of guest memory before getting TDX to
 :   initialize the memory region

And then there's code like this

 +#define KVM_MAX_CPUID_ENTRIES 256
 +
 +#define CPUID_EXT_VMX                  BIT(5)
 +#define CPUID_EXT_SMX                  BIT(6)
 +#define CPUID_PSE36                    BIT(17)
 +#define CPUID_7_0_EBX_TSC_ADJUST       BIT(1)
 +#define CPUID_7_0_EBX_SGX              BIT(2)
 +#define CPUID_7_0_EBX_INTEL_PT         BIT(25)
 +#define CPUID_7_0_ECX_SGX_LC           BIT(30)
 +#define CPUID_APM_INVTSC               BIT(8)
 +#define CPUID_8000_0008_EBX_WBNOINVD   BIT(9)
 +#define CPUID_EXT_PDCM                 BIT(15)

which is just... ugh.

Please make cleaning up this mess the highest priority for TDX upstreaming.  I
am _thrilled_ (honestly) at the amount test coverage that has been developed for
TDX.  But I am equally angry that so much effort is being put into newfangled
TDX features, and that so little effort is being put into helping review and
polish this series.  I refuse to believe that I am the only person that could
look at the above code and come to the conclusion that it's simply unnacceptable.

Y'all _know_ I am stretched thin, please help distribute the load.


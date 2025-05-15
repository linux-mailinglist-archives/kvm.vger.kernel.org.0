Return-Path: <kvm+bounces-46736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF6B6AB9228
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 00:05:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8C61A20FEC
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 22:05:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F05228AB0C;
	Thu, 15 May 2025 22:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xru8s1gV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2448221D3CD
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 22:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747346745; cv=none; b=L6lLyTeNmPM6OCrnMAwnxcHiAI7UfRgtKgdJhL10gPOVkiinQOJwzuw6jDU3yw/+lRU7OFIBlj8IlX2ejLSf7i07A/AFcXmiUD6WOw6nXQcBtxwG3Nqe0IqphvNaHdPQiH6dwz0jrKomvI2Fk0LzYLS5yA4VjAUFSe1ui3UGExg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747346745; c=relaxed/simple;
	bh=R04t5OP7VoRR7an/K/mH1NZqJb80IHwLckbbrUiaTWY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oF8xnGlg2wtDBqjFYuCCli0hrioVv2CQkNWFwzD4qXlmyXoV84W6OyHyGjC03BjTpomQuGL6oXO2UN5Nf7e7oxQjY1ADoBC1suRHx3qJjf95lcP4tepLwUD+EtFDTN/JxyRJsUs+sGw5deSUp2vP4Ogc3svT9WwfJRfplr+FJzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xru8s1gV; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30aab0f21a3so1610141a91.3
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 15:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747346743; x=1747951543; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Oi7sS9/hL2apZcsFxNVWjiM0xG6d7sH4nOsxyAerdW0=;
        b=Xru8s1gV9rTttrOCEX454kSAt6Z/XcJLtgwZZVSRIho1K0AdR3xDFulZlIfeL9NAUO
         nsCEaHUXj3pBGi/UBNg9JD1tMvpXrxK5THx+A8iniTuqQfFAaE8lPWGPwmoBeQQsmlcg
         RFYo+X7oThXS0X3zjX4Zha6JPli4exBIAQMoZbRR6zArhr2KjTF7ROpFu5UBocz6GmMv
         TpU1uOuE/bFmdpteQphfquHLDQ4JFL2UK0Q/ujWx/7odLtbHffW7d2+o+ZBtuPTZLMXF
         h7h8G1TFobXE+gsxiVVkIfrEH23lgAPRIj7LviOvMFzxVjWuV0u/rWiRcl1Iu2V5XH3N
         y5fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747346743; x=1747951543;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oi7sS9/hL2apZcsFxNVWjiM0xG6d7sH4nOsxyAerdW0=;
        b=mA37bvS6XBDi0C1nQTvCecp4Qekce0dteA9cijYnnk0Rfrq54w/oSxbPc/Tw1xh+6B
         VYsgyiYBJoFBRma9Sn4TE28UtqBXAqpuhni0zBAgQrfY4640SVTgFp6fdf80Ez2Nz3gg
         6Th6vKJ3ZmWIthzuVdoPkiI+BEOvlsdq/nhpu4MVHxVMKI9WQaI8UrwNIN6sVPSeo3PH
         oi8rlAoSLTk0DUYp+hHwXNXtRXiWFTe8uSmiH5tLYsYq9t1eW8NNPlRQZDahyY0psjJp
         B275Y0H6BHDbPASxdqFRXTjZImfcuoeCR8a5zxaewY/brme6Fp0t4z8kk/HsGnjGrFg9
         dImQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+qVb7LY0DoinQW6DSExZfQpszGkKo9cf7qRY8/uvjWhlZYn/BOq2md0OYQqRTgcB/aiU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4LRD0ahTTFi7OdTxQwDkM7WNzFkEZWtqraOfjVDQUAT9eKVjX
	wdxRkrdY2TTY0/N82jH9R5n5wb809tWnFgi884JKDoafmWNu58c4MDIsKLSoukGF8fFcVBaI1mU
	b4OgTFA==
X-Google-Smtp-Source: AGHT+IFsAyQHkBD9JIcdxXmgn3lyYCeVd2u7vwK18dv1Rs4/Dq4Q7I3Qiz7gFrycKUxrAq6vHuxsB5iwTcg=
X-Received: from pjbqc9.prod.google.com ([2002:a17:90b:2889:b0:2f9:e05f:187f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1dd1:b0:2ff:784b:ffe
 with SMTP id 98e67ed59e1d1-30e7d522171mr1418806a91.11.1747346743464; Thu, 15
 May 2025 15:05:43 -0700 (PDT)
Date: Thu, 15 May 2025 15:05:41 -0700
In-Reply-To: <20250515120804.32131-1-sarunkod@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com> <20250515120804.32131-1-sarunkod@amd.com>
Message-ID: <aCZlNYlhSKXRFvnc@google.com>
Subject: Re: [PATCH 00/67] KVM: iommu: Overhaul device posted IRQs support
From: Sean Christopherson <seanjc@google.com>
To: Sairaj Kodilkar <sarunkod@amd.com>
Cc: baolu.lu@linux.intel.com, dmatlack@google.com, dwmw2@infradead.org, 
	iommu@lists.linux.dev, joao.m.martins@oracle.com, joro@8bytes.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mlevitsk@redhat.com, 
	pbonzini@redhat.com, vasant.hegde@amd.com, suravee.suthikulpanit@amd.com, 
	naveen.rao@amd.com
Content-Type: text/plain; charset="us-ascii"

On Thu, May 15, 2025, Sairaj Kodilkar wrote:
> Hi Sean,
> 
> We ran few tests with following setup

A few!!?!?  This is awesome!  Thank you, I greatly appreciate the testing!

> * Turin system with 2P, 192 cores each (SMT enabled, Total 768)
> * 4 NVMEs of size 1.7 attached to a single IOMMU
> * Total RAM 247 GiB
> * Qemu version : 9.1.93
> * Guest kernel : 6.14-rc7
> * FIO random reads with 4K blocksize and libai
> 
> With above setup we measured the Guest nvme interrupts, IOPS, GALOG interrupts
> and GALOG entries for 60 seconds with and without your changes.
> 
> Here are the results,
> 
>                           VCPUS = 32, Jobs per NVME = 8
> ==============================================================================================
>                              w/o Sean's patches           w/ Sean's patches     Percent change
> ----------------------------------------------------------------------------------------------
> Guest Nvme interrupts               123,922,860                 124,559,110              0.51%
> IOPS (in kilo)                            4,795                       4,796              0.04%
> GALOG Interrupts                         40,245                         164            -99.59%
> GALOG entries                            42,040                         169            -99.60%
> ----------------------------------------------------------------------------------------------
> 
> 
>                 VCPUS = 64, Jobs per NVME = 16
> ==============================================================================================
>                              w/o Sean's patches           w/ Sean's patches     Percent change
> ----------------------------------------------------------------------------------------------
> Guest Nvme interrupts               99,483,339                   99,800,056             0.32% 
> IOPS (in kilo)                           4,791                        4,798             0.15% 
> GALOG Interrupts                        47,599                       11,634           -75.56% 
> GALOG entries                           48,899                       11,923           -75.62%
> ----------------------------------------------------------------------------------------------
> 
> 
>                 VCPUS = 192, Jobs per NVME = 48
> ==============================================================================================
>                              w/o Sean's patches          w/ Sean's patches      Percent change
> ----------------------------------------------------------------------------------------------
> Guest Nvme interrupts               76,750,310                  78,066,512               1.71%
> IOPS (in kilo)                           4,751                       4,749              -0.04%
> GALOG Interrupts                        56,621                      54,732              -3.34%
> GALOG entries                           59,579                      56,215              -5.65%
> ----------------------------------------------------------------------------------------------
>  
> 
> The results show that patches have significant impact on the number of posted
> interrupts at lower vCPU count (32 and 64) while providing similar IOPS and
> Guest NVME interrupt rate (i.e. patches do not regress).
> 
> Along with the performance evaluation, we did sanity tests such with AVIC,
> x2AVIC and kernel selftest.  All tests look good.
> 
> For AVIC related patches:
> Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
> 
> Regards
> Sairaj Kodilkar
> 


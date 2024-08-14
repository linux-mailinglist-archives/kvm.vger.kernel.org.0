Return-Path: <kvm+bounces-24185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF6879521AD
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 19:59:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F04E0B26C84
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 17:59:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82E001BD01A;
	Wed, 14 Aug 2024 17:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U8XFEVXJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C5E1B8EB4
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 17:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723658346; cv=none; b=MYPAn+6FEOU+PkwtRG6i2E0xM02gYwY6cMiaOLgtKPZ4jYeB4cK6QT7+a8qTcUt7K/uBMtwqlVNITH3gOeMoPtlp2DCHvLFwGi7c7QtUrFDJmeseBThGxi19cdg1gQBbt+3Ms7nFRo9eKLkJUXwPiW4Fwzt0g60lhKz3AVSqzg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723658346; c=relaxed/simple;
	bh=M8GOuLvnypz73WwCDUFc8X7HjtFBve9Hh2f1yHpVwzc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aocfzH1dnVYjJCIK+zqlQ4VGS4SSUiBR3NO6xqyAVusXDAi8CvguC9r3jXbTr1IR87GmvKwl+5kP2y/dQ27HeGXnipeIcA+83Im+VjyQe8HbvUDfs6c3GjqYnQMziERYEH/Q4u3EDXiTJdsyJdSjmrgt3iQaCnO3C1Hu/Tlh1KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U8XFEVXJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723658343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w1hk3Uwk3crCv48zaKF0+S7Qg23JitwooGXiDV5xo7M=;
	b=U8XFEVXJvDxBh862K8gnmF86IFHXI5x4YGtU0KoTh8tX0SvCXhUzcLnGkqk4IsgQm72PsD
	JC1G3aZNqpNRTIrqUg5jPi/1rF3bRUExiIQYhvvy2Xcb8YQRQFIOxCyfDlPdOzSNn+O+vI
	FKXxg5jt7boRQlrNQ5K4IVFPOG2P/O4=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-262-rrfLfzOtPsG60WJHG7jTyg-1; Wed, 14 Aug 2024 13:59:02 -0400
X-MC-Unique: rrfLfzOtPsG60WJHG7jTyg-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2ef2b0417cdso1212971fa.3
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 10:59:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723658340; x=1724263140;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w1hk3Uwk3crCv48zaKF0+S7Qg23JitwooGXiDV5xo7M=;
        b=L23BbzGY7v3KLqvTxR5TozKCXSc7CME7EhEkzwOLHEksYoo45QUinzCTGq+YZVIkAc
         KzFnSYH4KLo6l70Nguv7BAvZqnfZ1DdfmXNQVXUprQM2nhmNz4XNBvnXrgzwQjNq8GeV
         pRMVxxybO0Ze/EsYkD/G8WiMkN99YFCa5wy76pWO6lFEIWKZoFeyobDtFUVnSucaIZOc
         X6RXh9JYnHvXSPIeY+q4YU7XNJFrlJwR8YEgx7ocv+30BND4bmvatsKS7HOmoe1pzWvJ
         OYMR4ZD96JRq9H8MNhyTnCf1FSUBWwZOSggLLqxsEHYt0uTnOGuEwTF55nG4pLdWc+ke
         H4xw==
X-Gm-Message-State: AOJu0YyfbzdiDSxId9Mete6f7ah1WBucZODJOlp/X1NUWoP2LAKWh2of
	0MEtkRPdcgYLtji2KJcS5bOxgrHP1lc5SQXntaWbUlu8CtuqZYeXskWejjnq6YnU/yDNjPk4XQ3
	49FEIVC6gxKx7ye+R7I0Tu4ZoLFUDiAzIErdIFR0L0MBHrN+URg==
X-Received: by 2002:a05:6512:2395:b0:530:ac0a:15e8 with SMTP id 2adb3069b0e04-532eda64013mr2096051e87.11.1723658340431;
        Wed, 14 Aug 2024 10:59:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEEImyXCZ4wNRUOvofwfVooQv6fxhtQn2NmAjmGUiAkyZOxLZNMUilj+C7mj+lNQ8my6rni9w==
X-Received: by 2002:a05:6512:2395:b0:530:ac0a:15e8 with SMTP id 2adb3069b0e04-532eda64013mr2096041e87.11.1723658339839;
        Wed, 14 Aug 2024 10:58:59 -0700 (PDT)
Received: from [192.168.10.47] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-429ded364fesm26861805e9.27.2024.08.14.10.58.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Aug 2024 10:58:59 -0700 (PDT)
Message-ID: <1e6955c8-3672-41e7-ba8a-f2a205a601d9@redhat.com>
Date: Wed, 14 Aug 2024 19:58:58 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/22] KVM: x86: Fix multiple #PF RO infinite loop bugs
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>,
 Vishal Annapurve <vannapurve@google.com>,
 Ackerly Tng <ackerleytng@google.com>
References: <20240809190319.1710470-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240809190319.1710470-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/9/24 21:02, Sean Christopherson wrote:
> The folks doing TDX enabling ran into a problem where exposing a read-only
> memslot to a TDX guest put it into an infinite loop.  The most immediate
> issue is that KVM never creates MMIO SPTEs for RO memslots, because except
> for TDX (which isn't officially supported yet), such SPTEs can't distinguish
> between reads and writes, i.e. would trigger MMIO on everything and thus
> defeat the purpose of having a RX memslot.
> 
> That breaks TDX, SEV-ES, and SNP, i.e. VM types that rely on MMIO caching
> to reflect MMIO faults into the guest as #VC/#VE, as the guest never sees
> the fault, KVM refuses to emulate, the guest loops indefinitely.  That's
> patch 1.
> 
> Patches 2-4 fix an amusing number of other bugs that made it difficult to
> figure out the true root cause.
> 
> The rest is a bunch of cleanups to consolidate all of the unprotect+retry
> paths (there are four-ish).
> 
> As a bonus, adding RET_PF_WRITE_PROTECTED obviates the need for
> kvm_lookup_pfn()[*].
> 
> [*] https://lore.kernel.org/all/63c41e25-2523-4397-96b4-557394281443@redhat.com

Nice!  For now I've placed it in kvm/queue as this is clearly 6.12 
material.  It will be replaced by the v2 of course before graduating to 
kvm/next.

Thanks,

Paolo

> Sean Christopherson (22):
>    KVM: x86: Disallow read-only memslots for SEV-ES and SEV-SNP (and TDX)
>    KVM: VMX: Set PFERR_GUEST_{FINAL,PAGE}_MASK if and only if the GVA is
>      valid
>    KVM: x86/mmu: Trigger unprotect logic only on write-protection page
>      faults
>    KVM: x86/mmu: Skip emulation on page fault iff 1+ SPs were unprotected
>    KVM: x86: Retry to-be-emulated insn in "slow" unprotect path iff sp is
>      zapped
>    KVM: x86: Get RIP from vCPU state when storing it to last_retry_eip
>    KVM: x86: Store gpa as gpa_t, not unsigned long, when unprotecting for
>      retry
>    KVM: x86/mmu: Apply retry protection to "fast nTDP unprotect" path
>    KVM: x86/mmu: Try "unprotect for retry" iff there are indirect SPs
>    KVM: x86/mmu: Replace PFERR_NESTED_GUEST_PAGE with a more descriptive
>      helper
>    KVM: x86: Move EMULTYPE_ALLOW_RETRY_PF to x86_emulate_instruction()
>    KVM: x86: Fold retry_instruction() into x86_emulate_instruction()
>    KVM: x86/mmu: Don't try to unprotect an INVALID_GPA
>    KVM: x86/mmu: Always walk guest PTEs with WRITE access when
>      unprotecting
>    KVM: x86/mmu: Move event re-injection unprotect+retry into common path
>    KVM: x86: Remove manual pfn lookup when retrying #PF after failed
>      emulation
>    KVM: x86: Check EMULTYPE_WRITE_PF_TO_SP before unprotecting gfn
>    KVM: x86: Apply retry protection to "unprotect on failure" path
>    KVM: x86: Update retry protection fields when forcing retry on
>      emulation failure
>    KVM: x86: Rename
>      reexecute_instruction()=>kvm_unprotect_and_retry_on_failure()
>    KVM: x86/mmu: Subsume kvm_mmu_unprotect_page() into the and_retry()
>      version
>    KVM: x86/mmu: Detect if unprotect will do anything based on
>      invalid_list
> 
>   arch/x86/include/asm/kvm_host.h |  16 ++-
>   arch/x86/kvm/mmu/mmu.c          | 175 ++++++++++++++++++++++----------
>   arch/x86/kvm/mmu/mmu_internal.h |   3 +
>   arch/x86/kvm/mmu/mmutrace.h     |   1 +
>   arch/x86/kvm/mmu/paging_tmpl.h  |   2 +-
>   arch/x86/kvm/mmu/tdp_mmu.c      |   6 +-
>   arch/x86/kvm/vmx/vmx.c          |   5 +-
>   arch/x86/kvm/x86.c              | 133 +++++++-----------------
>   include/linux/kvm_host.h        |   7 ++
>   virt/kvm/kvm_main.c             |   5 +-
>   10 files changed, 184 insertions(+), 169 deletions(-)
> 
> 
> base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f



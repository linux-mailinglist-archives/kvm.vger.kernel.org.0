Return-Path: <kvm+bounces-11648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A46A0878FDD
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 09:42:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54A76281DB6
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 08:42:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F57377A1E;
	Tue, 12 Mar 2024 08:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="WL0F5bKh"
X-Original-To: kvm@vger.kernel.org
Received: from out203-205-221-173.mail.qq.com (out203-205-221-173.mail.qq.com [203.205.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D563F2AD05;
	Tue, 12 Mar 2024 08:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710232937; cv=none; b=M4EWYo8qNewSmn/tlrPq3aER4MY8cerSsHuA0LNEWSaf0u2xrLrzljO4NvBIuXQciwTPqRnEgAMpA36iLU9HVCCWiafi3+HmQn8HWjD97O5yRllebXGiic9r/wwUS4XNtEjmUh29csbs7Q+0nbaj1NflKQ10i1oKUPctxWfFpnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710232937; c=relaxed/simple;
	bh=TkQc0LJpx1K2SN7U/Lb6gwYCHyLR5+4QLPPXGZLIyYU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F9VKS4zS6MQwfP2EEQKDihHCTQfgLqXCwk5QxV1q4x/BwuuszYe3/LecQliYIvgLYAyRACxrLy1LtGPUQbo6tLUhEATwSceTS7gN6+LxLfALIMzCzH69TlRcf4+xhsVymuvUaPULL1gPda8jBlKklrak9KrG8HkFJ3yM2IJpEgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=WL0F5bKh; arc=none smtp.client-ip=203.205.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1710232926;
	bh=nsWR5G0TESRsR1Ba3uGvn81H+502dSAJciQiGCQRQEo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WL0F5bKhMC6WFiRirGDlx/wlOQJK+yuB6MG54Muc1lVyi9Nb4mTDmTvdfFWXFXXxS
	 0O6DtSvtG3IK4UxFfsjURemUH1cnJLRJYiT62JrVCYql6rMvDGfJTTCSxRDuFPUeup
	 YCt5e2m7oIEMPxfyz131+4gU/OLCdSnPyqof1kiY=
Received: from [172.17.78.110] ([58.208.182.212])
	by newxmesmtplogicsvrszb9-0.qq.com (NewEsmtp) with SMTP
	id A818E4BD; Tue, 12 Mar 2024 16:42:01 +0800
X-QQ-mid: xmsmtpt1710232921t1kfupkjf
Message-ID: <tencent_AA5D14EAA36D58807959EE9AFC9E07548108@qq.com>
X-QQ-XMAILINFO: MyIXMys/8kCtb9++LIiO4CpfoxdndEQDr5bx1HMICsi2UMMy2DzEGniMw+y23Q
	 E7uoqJ7o8iktc6QJPbNFzpnu/S49SSdixvSbo6IPwNSicbLy1rGfFPogIJlpjpt6tYX81YfzqkYH
	 klgr5trTVaOWzu1Ra+T55SQZrRE5ReZsTy5oBxs21zIehFBilU6/OppKDpvW43hLSVQhUSthQOxG
	 Zk2u/val3VwSqexVS8wOsvrnHcg7G2vrfI18+t0q1vwZiUr9vX/M1MMQvXh78+OYGlfOxeq7XXbA
	 WlEvjxzXHo9/1vrgCZS7MG9WL0n9n2Upg43MAxbtOjQ/Y5C9YIcZctchOPbNIcpBaWBkwyf28RJ6
	 cRy0aRztYHERvGgruPGJ6Q5/vIJXRq8CplNWJOtcEyi1ZiPy/V4DA8TACtXs7+0k/2GDOMnhMtf8
	 7KpgySW+lcyW6iPb38gFRJEZDMuYUQQa7cu/WbolSx3Ya5mdnySzXdN6JvepXN0JbW0+rGksShCp
	 D4CODil0kg6c5U8J5N9R5FEQT9/kkwM+YfFts4XFrp7zWbCg1mlzVDGfOKZ0zM8+LGeu3o1IpKFo
	 WD1Jf47pn68g0xbbIUxAf2Gl7WRP3JALn9VnjYik6u3clpnnATaomQDFCYiWcsmpvoWB+epai4pQ
	 RBsl/ezwHEG5RH6w+NK0ZVycuSl3InCnFgSJBqHzZuvmKPehxkADfKPK11xldtLxN9pXThQ3R1h8
	 ZThe5Tov7h04k5yRwoBmkL/gR4eCzKnkhc1WpogN0JsMOTG6gPtoH428MLq8mYuLtCe5NtALjJJ5
	 H8TaxbcSITLGyPazIJdIaDr+cgBsG49ESLoGjaLnkHR8aKB3uUVVG6wnhAyFOaE9uElL314wA1eW
	 aUq5257kVD7cSXhH36lnf8LNUVX+OYj2WSOtOKH0hIspa9MUf1mfOMhgHRh7vewL9hTccUPfErHQ
	 5zGX1hhERh7R9mPMUHQkRiGpebFINNaVTC4C+yt6K1stGcNGN+/Q==
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
X-OQ-MSGID: <b05a6763-3c74-4da9-bcb7-6581aa0511d1@foxmail.com>
Date: Tue, 12 Mar 2024 16:42:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/mmu: treat WC memory as MMIO
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, rdunlap@infradead.org, akpm@linux-foundation.org,
 bhelgaas@google.com, mawupeng1@huawei.com, linux-kernel@vger.kernel.org,
 pbonzini@redhat.com, peterz@infradead.org, bhelgaas@google.com,
 kvm@vger.kernel.org
References: <tencent_4B50D08D2E6211E4F9B867F0531F2C05BA0A@qq.com>
 <Ze8vM6HcU4vnXVSS@google.com>
From: francisco flynn <francisco_flynn@foxmail.com>
In-Reply-To: <Ze8vM6HcU4vnXVSS@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024/3/12 00:20, Sean Christopherson wrote:
> On Mon, Mar 11, 2024, francisco_flynn wrote:
>> when doing kvm_tdp_mmu_map for WC memory, such as pages
>> allocated by amdgpu ttm driver for ttm_write_combined
>> caching mode(e.g. host coherent in vulkan),
>> the spte would be set to WB, in this case, vcpu write
>> to these pages would goes to cache first, and never
>> be write-combined and host-coherent anymore. so
>> WC memory should be treated as MMIO, and the effective
>> memory type is depending on guest PAT.
> 
> No, the effective memtype is not fully guest controlled.  By forcing the EPT memtype
> to UC, the guest can only use UC or WC.  I don't know if there's a use case for

Well,it's actually the host mapping memory WC and guest uses WC,
one use case is virtio-gpu host blob, which is to map physical GPU buffers into guest

> the host mapping memory WC while the guest uses WB, but it should be a moot point,
> because this this series should do what you want (allow guest to map GPU buffers
> as WC).
> 
> https://lore.kernel.org/all/20240309010929.1403984-1-seanjc@google.com
> 

yes, this is what i want, but for virtio-gpu device, if we mapping WC typed 
GPU buffer into guest, kvm_arch_has_noncoherent_dma would return false, 
so on cpu without self-snoop support, guest PAT will be ignored, the effective
memory type would be set to WB, causing data inconsistency.

+	if (!static_cpu_has(X86_FEATURE_SELFSNOOP) &&
+	    !kvm_arch_has_noncoherent_dma(vcpu->kvm))
                return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;


>> Signed-off-by: francisco_flynn <francisco_flynn@foxmail.com>
>> ---
>>  arch/x86/include/asm/memtype.h | 2 ++
>>  arch/x86/kvm/mmu/spte.c        | 5 +++--
> 
> Please use get_maintainers.pl.

sure.

> 
>>  arch/x86/mm/pat/memtype.c      | 8 ++++++++
>>  3 files changed, 13 insertions(+), 2 deletions(-)



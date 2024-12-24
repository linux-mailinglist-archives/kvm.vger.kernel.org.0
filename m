Return-Path: <kvm+bounces-34356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C6F669FBF36
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 15:31:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B45816071D
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 14:31:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18CF11D7E35;
	Tue, 24 Dec 2024 14:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YobppoE2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD071C3C10
	for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 14:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735050688; cv=none; b=J/VwJG0O4t4HwxbX1+ox8UbIKrCIUwA0xuhHShrWaFPRWocq3hB0n9cWxw5Gl1Llnn+2t2g43myb+cM25F++4hCcA4yR1DNJa0q8dLxs0SpqwGfn5Yn4mK0UGD11L8YN4SsaGDnJLYN405MXfwOcjjlu2GPLI9EXxMvpPx02N6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735050688; c=relaxed/simple;
	bh=ZoSPYhBvVfRt83gSw+A6kMUFCloSLxsNTtQuquU2nXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B33YFkIfuFobNVcCIQBWIqcZm6EyfnHcPgfhocJeYBRZK0iOCVf1tqLcaGKeShyWN8Ybr/nL7ni8uXvq9xPUlma3VRGIcgFZIrHbPwgdeTanJM+m+UN+s9BCMY+r7R/xNj4J03NGny5tyy4CXDUNQwi4GRcPZVDBP4aQQmterps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YobppoE2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735050684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zj09KOMKGxwIRdjDHFl1qr/TsFOgXNXD7+iWbwI9oCo=;
	b=YobppoE2umsYGO3pGMilKR9IpiZ6mZhLEhTunqE/te8Ul8HnJEfBjPGsHRAJBP0hrJv2HS
	jyZgJV/RSBww9OujI/QZeoak6f6aimpGJbI5mvNLQ1dW1OOWYrzMXRtoiaemC2Q8nSwKv0
	37PTuGO66cAEPNPIr19tWJh5heUNGOc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-QWcPFkrROvKiXi0byufLiw-1; Tue, 24 Dec 2024 09:31:23 -0500
X-MC-Unique: QWcPFkrROvKiXi0byufLiw-1
X-Mimecast-MFC-AGG-ID: QWcPFkrROvKiXi0byufLiw
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-385d7611ad3so2909190f8f.2
        for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 06:31:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735050682; x=1735655482;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zj09KOMKGxwIRdjDHFl1qr/TsFOgXNXD7+iWbwI9oCo=;
        b=HUzz/z4W7zrXRkB/QWMmBlR45Q912O0m/Xht2l0qNpxMGt2Zc4b9d9mybfqipXTdzA
         UPO51apcb0Ih/Rbj/4gTh5nWotjTWpgW4Rkdqlv8d8Z0Tp8i9Q3Yag5/MvweIzPgV7gl
         3aLFxGNErDdVpfkJJtkm+FlFdY9jNa5TBJg3uUrb9S2/KSUVQdNFHRLrfnQOSEoP70lz
         VfRtAVle0iOshdXvqgByuBZOx2J0a/aVr+tW5YS6wU2lYr5oBbwXk9TC8YrvL9+h8j1+
         jAB7mTvvLGEWe7IxFUGqwuSfpAc14M3rUTogNvUgxR0q6RyyYRWPgxv3bTWatgXpnXDq
         n25A==
X-Forwarded-Encrypted: i=1; AJvYcCX+7pn1M/HWEcvSr9y1zLpSdUY3PHk2cybCDXJKmFnS6xqjEfFSFlJKdea1yBo8MO+XlTM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwH5LAsvXzDhcyR0Rhc2tllJDx+12nd7be28M8+sUC3g65JHqj2
	H9fuwR4lSXbCQy82MGw7AXNYpg2wP01WAxKjLMmvr6Gy74UalRAPOg1XsgeEH163gfpSjcrLjcp
	LyW/2GVZSDbGBy5EET2r/gKHmAmI6jJuRUK0Tvb7xGkfoMw0+2g==
X-Gm-Gg: ASbGnctpHRvYzcIxg7RlH1ldm+kZ68pQfrlSo2XJH9qi9xvWvjx+OKs9gGqx0Vy/ZRd
	H7eui3elXB4/6GeZM+h0rBnr4S0OTDE5dWlBYnQBRjUlMorAl84Iw06ca9fqZ5ktG/9LUKvvH/X
	lGAecrepYvCZDfBUVW3GgD9k3OcXHTf1fs2JkxANXL+LHUYYZJWMstV+NpL/0UNyCtxTsowLNlZ
	2tLXS0QGi1E64n9bL0SyqqWjC/GNyD9P5GhkjsqjGq2ZCCwPbD54HMaHvQ2
X-Received: by 2002:a05:6000:4a0d:b0:385:dedb:a156 with SMTP id ffacd0b85a97d-38a221ed2e7mr13008908f8f.6.1735050682021;
        Tue, 24 Dec 2024 06:31:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFUvdABnkVt+9LSKjCliq/5aNwgQOJO2/oDO5XrjmE0f2woMAZpAYXB5RSfz5sTBfurXrcoYQ==
X-Received: by 2002:a05:6000:4a0d:b0:385:dedb:a156 with SMTP id ffacd0b85a97d-38a221ed2e7mr13008881f8f.6.1735050681589;
        Tue, 24 Dec 2024 06:31:21 -0800 (PST)
Received: from [192.168.10.27] ([151.81.118.45])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4366a093cbfsm142487575e9.22.2024.12.24.06.31.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2024 06:31:20 -0800 (PST)
Message-ID: <fdcab98a-82d3-44fe-8f4b-0b47e2be5b7e@redhat.com>
Date: Tue, 24 Dec 2024 15:31:19 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 22/24] KVM: TDX: Finalize VM initialization
To: Yan Zhao <yan.y.zhao@intel.com>, seanjc@google.com, kvm@vger.kernel.org,
 dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com, tony.lindgren@intel.com,
 binbin.wu@linux.intel.com, dmatlack@google.com, isaku.yamahata@intel.com,
 isaku.yamahata@gmail.com, nik.borisov@suse.com,
 linux-kernel@vger.kernel.org, x86@kernel.org
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
 <20241112073848.22298-1-yan.y.zhao@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241112073848.22298-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/12/24 08:38, Yan Zhao wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Introduce a new VM-scoped KVM_MEMORY_ENCRYPT_OP IOCTL subcommand,
> KVM_TDX_FINALIZE_VM, to perform TD Measurement Finalization.
> 
> The API documentation is provided in a separate patch:
> “Documentation/virt/kvm: Document on Trust Domain Extensions (TDX)”.
> 
> Enhance TDX’s set_external_spte() hook to record the pre-mapping count
> instead of returning without action when the TD is not finalized.
> 
> Adjust the pre-mapping count when pages are added or if the mapping is
> dropped.
> 
> Set pre_fault_allowed to true after the finalization is complete.
> 
> Note: TD Measurement Finalization is the process by which the initial state
> of the TDX VM is measured for attestation purposes. It uses the SEAMCALL
> TDH.MR.FINALIZE, after which:
> 1. The VMM can no longer add TD private pages with arbitrary content.
> 2. The TDX VM becomes runnable.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
> TDX MMU part 2 v2
>   - Merge changes from patch "KVM: TDX: Premap initial guest memory" into
>     this patch (Paolo)
>   - Consolidate nr_premapped counting into this patch (Paolo)
>   - Page level check should be (and is) in tdx_sept_set_private_spte() in
>     patch "KVM: TDX: Implement hooks to propagate changes of TDP MMU mirror
>     page table" not in tdx_mem_page_record_premap_cnt() (Paolo)
>   - Protect finalization using kvm->slots_lock (Paolo)
>   - Set kvm->arch.pre_fault_allowed to true after finalization is done
>     (Paolo)
>   - Add a memory barrier to ensure correct ordering of the updates to
>     kvm_tdx->finalized and kvm->arch.pre_fault_allowed (Adrian)
>   - pre_fault_allowed must not be true before finalization is done.
>     Highlight that fact by checking it in tdx_mem_page_record_premap_cnt()
>     (Adrian)
>   - No need for is_td_finalized() (Rick)
>   - Fixup SEAMCALL call sites due to function parameter changes to SEAMCALL
>     wrappers (Kai)
>   - Add nr_premapped where it's first used (Tao)

I have just a couple imprecesions to note:
- stale reference to 'finalized'
- atomic64_read WARN should block the following atomic64_dec (there is still
   a small race window but it's not worth using a dec-if-not-zero operation)
- rename tdx_td_finalizemr to tdx_td_finalize

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 61e4f126addd..eb0de85c3413 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -609,8 +609,8 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
  	get_page(pfn_to_page(pfn));
  
  	/*
-	 * To match ordering of 'finalized' and 'pre_fault_allowed' in
-	 * tdx_td_finalizemr().
+	 * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
+	 * barrier in tdx_td_finalize().
  	 */
  	smp_rmb();
  	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
@@ -1397,7 +1397,7 @@ void tdx_flush_tlb_all(struct kvm_vcpu *vcpu)
  	ept_sync_global();
  }
  
-static int tdx_td_finalizemr(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
+static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
  {
  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
  
@@ -1452,7 +1452,7 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
  		r = tdx_td_init(kvm, &tdx_cmd);
  		break;
  	case KVM_TDX_FINALIZE_VM:
-		r = tdx_td_finalizemr(kvm, &tdx_cmd);
+		r = tdx_td_finalize(kvm, &tdx_cmd);
  		break;
  	default:
  		r = -EINVAL;
@@ -1715,8 +1715,8 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
  		goto out;
  	}
  
-	WARN_ON_ONCE(!atomic64_read(&kvm_tdx->nr_premapped));
-	atomic64_dec(&kvm_tdx->nr_premapped);
+	if (!WARN_ON_ONCE(!atomic64_read(&kvm_tdx->nr_premapped)))
+		atomic64_dec(&kvm_tdx->nr_premapped);
  
  	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
  		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {



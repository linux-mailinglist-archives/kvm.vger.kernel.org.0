Return-Path: <kvm+bounces-37081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 66ED1A24CCC
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2025 08:13:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BACD818857B3
	for <lists+kvm@lfdr.de>; Sun,  2 Feb 2025 07:13:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 063971D5162;
	Sun,  2 Feb 2025 07:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bPIdoKWr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5E91BEF81
	for <kvm@vger.kernel.org>; Sun,  2 Feb 2025 07:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738480383; cv=none; b=O2I8PQlmPi3GdkA2MlCTSP1wb39pmjahu8dxvPZwxEXq2jRA0we5gmkEauwz8ujGp3TJjZU4joCN1nhsxatx2hy5aXoLh4BU3NACuY5/3OSJ2BCVha4XjuT5DxaS4tKQ57LULr0H4MDTNYRlcM3HaUdoaqZ1rOD+nBckRtxb2ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738480383; c=relaxed/simple;
	bh=CXPd9+3PCf0ABtxW27kGa+FmX6LrCMM7KEngRhxn1qQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fSrnG5i+mMWbgQA8j0FVH+Py0NFJy9YWKVlUsryGmfAc1qictBs2f+CsrYpbo2TbUrDh9CAVcFyMZ9yGyERzlZN4WMInOrlPhhFE2WrCzvsPTxkDekoyl0hcNr8lEy9GIXYupiOoI5rw1s36joYxa5xOR39vshF7nq8cwrC7Tdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bPIdoKWr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738480380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Akyo3JQj2YPzoJhRHm4ECXXW4B+Mshy1bBF/6XTbeo=;
	b=bPIdoKWrQITlBtZKA2HywtSRmwQSBhPoby66hX0frNbt176SI8guY02ILPTx7oq1T2pcTE
	FIK1pyF4xj+Qgzq+sXrV9w1SHwivWC3lUMb9V0ruOQHLLBcSr+JcElvmHIKdrwJQnrJ/SX
	+nT7vJdGou/PpGbIY5b17R+q/2BDm7M=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-UlHBx0vDMlSBGyP2gwd5iw-1; Sun, 02 Feb 2025 02:12:58 -0500
X-MC-Unique: UlHBx0vDMlSBGyP2gwd5iw-1
X-Mimecast-MFC-AGG-ID: UlHBx0vDMlSBGyP2gwd5iw
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-216430a88b0so70368765ad.0
        for <kvm@vger.kernel.org>; Sat, 01 Feb 2025 23:12:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738480377; x=1739085177;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Akyo3JQj2YPzoJhRHm4ECXXW4B+Mshy1bBF/6XTbeo=;
        b=q/fbD2/cwH8suwnkbRrjs35b4sfIC2KGnrunpt6c1JudYecsrMoAzm7bO3RESoERDa
         66AH7S+QqPNf5RE7XTWlxOqBUBYQ/VlOG/eHkE9DwntVJtoMpXvBicZmtp9+xO6vhrkJ
         ydzD4Svsf9Dopmu924Wccr95f0+gAwObD4mPPn3DFc2t52rLE4rMwXtrNUz8D67PWr5r
         X2coRbulAJMuKzROkrLptJOgEy9MUAfYo0lEei4DswdDcpotFeLKEpZxARub+0judUbl
         KpCOKrU1aZH9W8llqNKI1dxVdKWcEy9kF3VU3vLHCm15BbIr+v4M7vzM8HbpgN4OY6i3
         pWUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjSQoJIgH/tLbmh777FWAB4sKty2KWhewW13rFt6JPtz7XuUPEUWTL/I2wrC+RRehuOl8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmFwiCcZDBjGRXjUBrzjWRoMUAmGVxSOfv0VuRrgt2f111GZjV
	T+djz8Q2jIUDtDdEtqKctk5kQ6W0u0qJKc9iqAfXCf/6Ofo4qYxGltritfNiZMOM70l4Pyd5Pwk
	JK+eHM7GCXMQKOl/m02trytSMrzpnggdCd7r6Kg7UQY1o9PD3dA==
X-Gm-Gg: ASbGncv4L5P4v8ZXwR0xZkl2xQuh1dHXdpB+2I4FhTe1j6PglY/XxUEY9lOqv1/LJVB
	hiuL5iZi0ZtFpLSfQRletKUhcZ36GkcOUJpfNoOXqHAw3dNUJDe50Zmsp60/L1jyGA9DUTwJIX0
	YEQkhpSRzFS0cEgdqhsP0DCZsWbKAO9eF38TwBBWO8W40uk4jY0qaRkefEQpOXPVc0JLFqfoiN4
	WCIQF9Y9JXxk58+TIeB7fJ/Oh5vEXZ4psaWrykXMCwjEx2zjxtSCZJqdloEUkPdiiTwh/tSAg3J
	UOhEuw==
X-Received: by 2002:a17:903:110c:b0:216:1ad2:1d5 with SMTP id d9443c01a7336-21dd7deebd1mr265357365ad.41.1738480376999;
        Sat, 01 Feb 2025 23:12:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEEbEpN4KQNQWRi1soSDL1v4OtYLgM2DYDPCY0eEgB/YujTFWmFABLlbkBOcGlGdKwPsn62yg==
X-Received: by 2002:a17:903:110c:b0:216:1ad2:1d5 with SMTP id d9443c01a7336-21dd7deebd1mr265357095ad.41.1738480376627;
        Sat, 01 Feb 2025 23:12:56 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de32ea5f1sm54843395ad.130.2025.02.01.23.12.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2025 23:12:56 -0800 (PST)
Message-ID: <f339729a-00a8-40b5-af05-f0f019579e5e@redhat.com>
Date: Sun, 2 Feb 2025 17:12:48 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 30/43] arm64: rme: Prevent Device mappings for Realms
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-31-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241212155610.76522-31-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 1:55 AM, Steven Price wrote:
> Physical device assignment is not yet supported by the RMM, so it
> doesn't make much sense to allow device mappings within the realm.
> Prevent them when the guest is a realm.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes from v5:
>   * Also prevent accesses in user_mem_abort()
> ---
>   arch/arm64/kvm/mmu.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 9ede143ccef1..cef7c3dcbf99 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1149,6 +1149,10 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>   	if (is_protected_kvm_enabled())
>   		return -EPERM;
>   
> +	/* We don't support mapping special pages into a Realm */
> +	if (kvm_is_realm(kvm))
> +		return -EINVAL;
> +

		return -EPERM;

>   	size += offset_in_page(guest_ipa);
>   	guest_ipa &= PAGE_MASK;
>   
> @@ -1725,6 +1729,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	if (exec_fault && device)
>   		return -ENOEXEC;
>   
> +	/*
> +	 * Don't allow device accesses to protected memory as we don't (yet)
> +	 * support protected devices.
> +	 */
> +	if (device && kvm_is_realm(kvm) &&
> +	    kvm_gpa_from_fault(kvm, fault_ipa) == fault_ipa)
> +		return -EINVAL;
> +

s/kvm_is_realm/vcpu_is_rec

I don't understand the check very well. What I understood is mem_abort() is called
only when kvm_gpa_from_fault(kvm, fault_ipa) != fault_ipa, meaning only the page
faults in the shared address space is handled by mem_abort(). So I guess we perhaps
need something like below.

	if (vcpu_is_rec(vcpu) && device)
		return -EPERM;

kvm_handle_guest_abort
   kvm_slot_can_be_private
     private_memslot_fault	// page fault in the private space is handled here
   io_mem_abort			// MMIO emulation is handled here
   user_mem_abort                // page fault in the shared space is handled here

>   	/*
>   	 * Potentially reduce shadow S2 permissions to match the guest's own
>   	 * S2. For exec faults, we'd only reach this point if the guest

Thanks,
Gavin



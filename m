Return-Path: <kvm+bounces-26120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8940971B76
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 15:46:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10CB11C2100D
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 13:46:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 777F71BA877;
	Mon,  9 Sep 2024 13:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GYwWJrZU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C6B1BA292
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 13:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725889509; cv=none; b=uShBGSuI7zwSUR7dDc0jYzGu6orP8lnlWzpwF6egGHGHtsovK3sTfeBa46Qrq3GNbJ8SQFnTyngqE5LSkk8u+mw/6ardoZ02+WCoSGWRCGjZRzGVMcj+xTqYR4edE/RrZ8uT2GZSh+11WG2fSBqMakM7MnD/Nj9TUz/cvQshupg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725889509; c=relaxed/simple;
	bh=+9F3uKNMboa1SgybT1etH6wDb2f1GTpwoZhVE0ms3UM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YSodk2/uyXdzxZ5h2iDz3BwRDQDD2SGVy9f6lmg4+BP8GIOXTgKmyMIZz+pzOqCKWrz5dCLXQnBvwd8Wgr1VjxmFSpuVAbvQB1XcVO8il3XMmQxMZbSvg96B2nfCs72jZnIIhoWpe+cZk9ktr1Ax5uke2o1qgY8aLNDFFvAfnCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GYwWJrZU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725889506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ylw46X/xkXMlviR3Hl2ecKDrkpKoQWtNAOjrdUUapm4=;
	b=GYwWJrZUk1Eu7Fa0An7N0TWE3/URazKrTLIfNfBsR9n+7KSPkZihvHfJcsOtCa+2ZjwdEc
	n4kRUMocAtoAW7Td1YJZM+fkUU3h0O+Is1LrXaEtL6EqqBWXuX4u639+ILprM0dNqhF5YQ
	L34eUuV2owjCUEN3EfRH0jiLvnuzmCI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-325-nMBSb0t9OM2EMR1TMEtsTA-1; Mon, 09 Sep 2024 09:45:03 -0400
X-MC-Unique: nMBSb0t9OM2EMR1TMEtsTA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-42bbe70c1c2so34738835e9.1
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 06:45:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725889502; x=1726494302;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ylw46X/xkXMlviR3Hl2ecKDrkpKoQWtNAOjrdUUapm4=;
        b=HhCYHyKTz+GMTnjNpU/9i7yT9Hz4rG0Gw9xqqYiRQBTUhZtHGtcNpvgbuC1x5cBnv1
         pONBOKHg6UijGcryZwJp9MIlZLmvAi4Tzlf2ke94NUgP68qpb7laCV4x2IVafDspr9SD
         r3G2SYPDGmik8hY6De8JKF74Fqrn07offsWYX/7Rnr1kG3QUcPkcqbX0vF7zvOcyUZSV
         XZvIYAeKDK9tv/Rb/zqBGtP3YLtlIIGgme1pnr43SG/aLpMFX9iN5c6ygs0wO+Pv8zdG
         Qxu3aax38jj6MID+2FETXxAZWvA6NPRJp0kUdkI0NyPsd2SVX2q6w6tNjTBw/XSYBm1B
         kyhQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqFcTh+FQuCjS+ORmXuAJI6OoBF2D+bQ6ZxIZhDdKzvYzYOLxpk+gZSQMe9x6SqQBtUB8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4NAKC2EXUQQRqJS7RmviGE3MRksLgJSR0Mqd7qi6wRMW3ZBds
	8nF32XjolxNuWCQ036Q98uCfplNUoVgyivxDhBR7ce7RQPXUFLJnOiZnJ+JPAqEyuejwWJghf8l
	saHFY1syucbm0jlgNWZKRPZ7zYrHSJp4oQ+9U3COzgNzHAo8sOw==
X-Received: by 2002:a05:600c:4f16:b0:42c:a72a:e8f4 with SMTP id 5b1f17b1804b1-42cad760ee2mr62757805e9.14.1725889502084;
        Mon, 09 Sep 2024 06:45:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFF/95U9vbW29MTrTQs2Nva4ge2R5MZvBC10txmNSECUK5cgpTJ7gCxCL3V/RbNxVpoohqTOA==
X-Received: by 2002:a05:600c:4f16:b0:42c:a72a:e8f4 with SMTP id 5b1f17b1804b1-42cad760ee2mr62757525e9.14.1725889501607;
        Mon, 09 Sep 2024 06:45:01 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-378956767c4sm6079302f8f.63.2024.09.09.06.45.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2024 06:45:01 -0700 (PDT)
Message-ID: <d4e07759-c9fc-49db-8b99-0b5798644fcc@redhat.com>
Date: Mon, 9 Sep 2024 15:44:59 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/21] KVM: x86/mmu: Implement memslot deletion for TDX
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, dmatlack@google.com, isaku.yamahata@gmail.com,
 yan.y.zhao@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-2-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240904030751.117579-2-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/24 05:07, Rick Edgecombe wrote:
> Force TDX VMs to use the KVM_X86_QUIRK_SLOT_ZAP_ALL behavior.
> 
> TDs cannot use the fast zapping operation to implement memslot deletion for
> a couple reasons:
> 1. KVM cannot fully zap and re-build TDX private PTEs without coordinating
>     with the guest. This is due to the TDs needing to "accept" memory. So
>     an operation to delete a memslot needs to limit the private zapping to
>     the range of the memslot.
> 2. For reason (1), kvm_mmu_zap_all_fast() is limited to direct (shared)
>     roots. This means it will not zap the mirror (private) PTEs. If a
>     memslot is deleted with private memory mapped, the private memory would
>     remain mapped in the TD. Then if later the gmem fd was whole punched,
>     the pages could be freed on the host while still mapped in the TD. This
>     is because that operation would no longer have the memslot to map the
>     pgoff to the gfn.
> 
> To handle the first case, userspace could simply set the
> KVM_X86_QUIRK_SLOT_ZAP_ALL quirk for TDs. This would prevent the issue in
> (1), but it is not sufficient to resolve (2) because the problems there
> extend beyond the userspace's TD, to affecting the rest of the host. So the
> zap-leafs-only behavior is required for both
> 
> A couple options were considered, including forcing
> KVM_X86_QUIRK_SLOT_ZAP_ALL to always be on for TDs, however due to the
> currently limited quirks interface (no way to query quirks, or force them
> to be disabled), this would require developing additional interfaces. So
> instead just do the simple thing and make TDs always do the zap-leafs
> behavior like when KVM_X86_QUIRK_SLOT_ZAP_ALL is disabled.
> 
> While at it, have the new behavior apply to all non-KVM_X86_DEFAULT_VM VMs,
> as the previous behavior was not ideal (see [0]). It is assumed until
> proven otherwise that the other VM types will not be exposed to the bug[1]
> that derailed that effort.
> 
> Memslot deletion needs to zap both the private and shared mappings of a
> GFN, so update the attr_filter field in kvm_mmu_zap_memslot_leafs() to
> include both.
> 
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Link: https://lore.kernel.org/kvm/20190205205443.1059-1-sean.j.christopherson@intel.com/ [0]
> Link: https://patchwork.kernel.org/project/kvm/patch/20190205210137.1377-11-sean.j.christopherson@intel.com [1]
> ---
> TDX MMU part 2 v1:
>   - Clarify TDX limits on zapping private memory (Sean)
> 
> Memslot quirk series:
>   - New patch
> ---
>   arch/x86/kvm/mmu/mmu.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a8d91cf11761..7e66d7c426c1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -7104,6 +7104,7 @@ static void kvm_mmu_zap_memslot_leafs(struct kvm *kvm, struct kvm_memory_slot *s
>   		.start = slot->base_gfn,
>   		.end = slot->base_gfn + slot->npages,
>   		.may_block = true,
> +		.attr_filter = KVM_FILTER_PRIVATE | KVM_FILTER_SHARED,
>   	};
>   	bool flush = false;
>   

Stale commit message, I guess.

Paolo



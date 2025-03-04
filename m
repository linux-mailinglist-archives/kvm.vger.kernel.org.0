Return-Path: <kvm+bounces-40014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 026E1A4DCFF
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 12:51:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A69C18977C1
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 11:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35ABD201017;
	Tue,  4 Mar 2025 11:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YNvLCemJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF991F37D1
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 11:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741089101; cv=none; b=esdKQcyg//OgCBWpS+jtqquH+mDas4qZh2d1XvVfVaMh2x5JuSMdIls/2SSoqtvNlWkOiPbvVnWjSKo8z19e6PD3P4jDTOK7gIPqYUoobJrQ3qmbvBnfzdZiggtPt482LoblaZVwHtulETuzUbdMPfrkU/t6dwXXwm81gk6uU1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741089101; c=relaxed/simple;
	bh=yWbmFnDDcW7+/qnqF0tm/sx+AWkJjTYVTQwvn5TuuzI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=latqS2u0LsIv8mZQz9hYhHYX4GHzD/+8wsoyf2eUHe3VmX+19rrdZ5EC48IiiQUTzoqp0LI9NAC21MKS3UquSHuXmlQOZwIAUk4hFIrtI/Bx4D+76L5HivIhhEqFIMzBGGtPQ+9U7Mupk09EUPta8YpUUMhVut9lwmEMd7Q5kRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YNvLCemJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741089097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9SvHiAzkhpGOwKIBXJW3ZvTlN3vuL1LXpAI2oO3MJds=;
	b=YNvLCemJTRA8RCZdFg7mYgXMDzdtp7Ca5LEuaGUwgibWL3m4zNcT67tUHK8ihToPVNBYnN
	76C+0WJgu0Ujhwztl7de/4DHXbiYtePKRwWIMyElXcfllnRfRPZpQnm0FDba4Prds/Arug
	RALTztKxBkNQ6bMMa4i9h62asxoFeJI=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-394-fAf-6oBGMK2KuC0UChY0Rw-1; Tue, 04 Mar 2025 06:51:36 -0500
X-MC-Unique: fAf-6oBGMK2KuC0UChY0Rw-1
X-Mimecast-MFC-AGG-ID: fAf-6oBGMK2KuC0UChY0Rw_1741089095
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-223d86b4df0so25497335ad.3
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 03:51:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741089095; x=1741693895;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9SvHiAzkhpGOwKIBXJW3ZvTlN3vuL1LXpAI2oO3MJds=;
        b=u2+2VkPI0AHiDsk8QwuREv9Jn6eoyfjHuB8AfZXGVBi5dk2bMSRNhWpwo87CHnhOL7
         hFIm2vN+HKtLA3XpRBjx+imqPgzPpbmh/QsvN/VJOY8gfNupHPPp63TLgmLfv+vCO16J
         /3k2AEbYx8KjPWJZic8ZIWHkmW/ZMyXMj4bsgfAWHePeFP2FjP3VhCKFx4ljGZv2ITIQ
         gnxCqQLC37MLAba4SS60Ep5kHwA2AA8pYnjnOaGH/vZNOxNjhCx5wxAgP9xT+piy/YSK
         lvbHP3+8PP9Nc859LW0f/WIsWgwblk+OXj0EzQ/ogDEbPswLbJOXMBaYGd1pH/69u65q
         9E2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWSSEYHK2cRpsdt4ZapLPCpNGLOtHf5Oacbx8JRpowYbTVvyrjQnPk8ocbQgL2K75xnJVc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWtr2vnSsS9DVMK1hNofhAVW4z0eDVL8BNXZ64EIhdGvCOtDC6
	zDlrs6wbl2GifFvL2GKbaOZeoBpr+aD9grltmNGMU07DnDeQftpf8y2em7to9D/ONhm0nShpN3y
	nx1muYwr422bl4OzP4Y6RWvOEv/HtQOBhICHUzfBbtRqw48jItw==
X-Gm-Gg: ASbGnctwYmuuM011HEnRygRWsOD9S4s1/FpJMFcCDdaVMJvB4Ycq7spUF7iLHdo9SMD
	QzfM/VqkYnzQp4a7NXplumSziA/yruWx4atOqC8voCa02cm7gG2JwWM8CvFu2wYLGYk+kABz0r3
	2o7G2Ch0Osk0NSZh53uj2kLZCC/K/utC1EjVau50l3oIqam7mbFOQmaEiIShAkYUB7bIbpJ9IoU
	lykYTMgwH8WpniZ3hSFNRC47XYfQT8nVnT+hbj57UX8q/Zq2j9D3G0JjiXQEMrnZDuXG6LL2wQ3
	kkqea4e9C+VDYZO+IQ==
X-Received: by 2002:a17:902:d48f:b0:220:c164:6ee1 with SMTP id d9443c01a7336-2236924786cmr286756845ad.32.1741089095293;
        Tue, 04 Mar 2025 03:51:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGqkDc//0lhtuEEGTLRirsOl+2zU34lz3XcWjEj6faC+59ETLrTC0850jV9RLUFK6Nc4S9jqg==
X-Received: by 2002:a17:902:d48f:b0:220:c164:6ee1 with SMTP id d9443c01a7336-2236924786cmr286756495ad.32.1741089094965;
        Tue, 04 Mar 2025 03:51:34 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.164])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2235052beaasm93466525ad.233.2025.03.04.03.51.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 03:51:34 -0800 (PST)
Message-ID: <32a09a27-f131-44dd-8959-abb63b2089a8@redhat.com>
Date: Tue, 4 Mar 2025 21:51:26 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 34/45] kvm: rme: Hide KVM_CAP_READONLY_MEM for realm
 guests
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
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-35-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250213161426.102987-35-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 2:14 AM, Steven Price wrote:
> For protected memory read only isn't supported. While it may be possible
> to support read only for unprotected memory, this isn't supported at the
> present time.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/kvm/arm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 

It's worthy to explain why KVM_CAP_READONLY_MEM isn't supported and its
negative impact. It's something to be done in the future if I'm correct.

 From QEMU's perspective, all ROM data, which is populated by it, can
be written. It conflicts to the natural limit: all ROM data should be
read-only.

QEMU
====
rom_add_blob
   rom_set_mr
     memory_region_set_readonly
       memory_region_transaction_commit
         kvm_region_commit
           kvm_set_phys_mem
             kvm_mem_flags                                    // flag KVM_MEM_READONLY is missed
             kvm_set_user_memory_region
               kvm_vm_ioctl(KVM_SET_USER_MEMORY_REGION2)

non-secure host
===============
rec_exit_sync_dabt
   kvm_handle_guest_abort
     user_mem_abort
       __kvm_faultin_pfn					   // writable == true
         realm_map_ipa
           WARN_ON(!(prot & KVM_PGTABLE_PROT_W)

non-secure host
===============
kvm_realm_enable_cap(KVM_CAP_ARM_RME_POPULATE_REALM)
   kvm_populate_realm
     __kvm_faultin_pfn					  // writable == true
       realm_create_protected_data_page

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 1f3674e95f03..0f1d65f87e2b 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -348,7 +348,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_ONE_REG:
>   	case KVM_CAP_ARM_PSCI:
>   	case KVM_CAP_ARM_PSCI_0_2:
> -	case KVM_CAP_READONLY_MEM:
>   	case KVM_CAP_MP_STATE:
>   	case KVM_CAP_IMMEDIATE_EXIT:
>   	case KVM_CAP_VCPU_EVENTS:
> @@ -362,6 +361,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_COUNTER_OFFSET:
>   		r = 1;
>   		break;
> +	case KVM_CAP_READONLY_MEM:
>   	case KVM_CAP_SET_GUEST_DEBUG:
>   		r = !kvm_is_realm(kvm);
>   		break;

Thanks,
Gavin



Return-Path: <kvm+bounces-22726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BC9EC9426F8
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 08:37:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38FDB1F2141C
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 06:37:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB73D16CD1B;
	Wed, 31 Jul 2024 06:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Agl1ePpN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC5059B71
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 06:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722407825; cv=none; b=m8n3e1z9oGaTDCOebnmFytuSUg++G0oaoqtU3dBEGAqrktsdjB97xD7FCgCQQK89xbt3R0aiJaKDNti5HYCYly6/bMZIju2eTm9tS1amTcMmKX42n56ONJcAiuvLo34YRLm2LRtSrJGT7k1tlrSRXQV1TuRzhS+XO6tykiViX5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722407825; c=relaxed/simple;
	bh=T5xtq2+T4SGA+SuVDFG7nCUZboCIDjJHRn/Bzy4RjSY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EgARh3KMMLgVXo3f7ZkdCyJM26BM7wwEMIlda8nxsWy1q2Ox5rkEAzNkpNz9gO2kW2lOZRXTHmjyIp/h7B53+yIQedzpBa6bJUMuwvrMJZZpWgvRgHXcXsTKes2WgXwOXruUNDc6x3L8KzaYQ9lSLY7SrtUmi3/9s+SJNQEx2go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Agl1ePpN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722407822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2f5yai2p+2ixByjx7pWktU2JtLhPUEw7G/kkgGPzfME=;
	b=Agl1ePpN3fN9ZO/Al2xGq351ASohUb3D9vwP4FjFzQlkE/Se4drMmS5DWAC1WqSSPG44ao
	oqrtq82rE0IODBK7dBC7g0+f2lmF7FKCZWzl519CTp0SK1FmMUr29tKhMezlMfHPlVomoF
	bsKOkyu4NNEBVvB2c1IVoLuXPR6Ymk8=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-168-_MVbFN1NOseSw4IEcVGWaw-1; Wed, 31 Jul 2024 02:37:00 -0400
X-MC-Unique: _MVbFN1NOseSw4IEcVGWaw-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1fd9a0efe4eso41847215ad.0
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 23:37:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722407819; x=1723012619;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2f5yai2p+2ixByjx7pWktU2JtLhPUEw7G/kkgGPzfME=;
        b=rc4XTH7vf6EpG4PLq8NQWY2+WyuImmQREW8IS4ivOLoTibw3AcRt34MMOUjmq8a/Wt
         Zyy+aSRr4mScLz47mS3NF5phYVvTY3j4EKPc8qN98/qxhoa2EGduqYRUCy7FzD+cS2y3
         ZTJ+QaXCzmGeXG6ozSCdixx9DjuZiRbTuA+adxAmAh6fNpX462VY0BjOqYwVu3mDD0X/
         0eBaFykuLq5kaxaZvH5e17OiAsKYVpmfC/034koBHOf++izs8gvxIYZQtT/ep+PRT5Ko
         T5Om6mTw1VXCNNy89HBjxIa+tqJf2W0wUxLz3tERhqGFDz5YPQSKtvPKslGR1CQpLZ7o
         oW9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWesUD/HDiBWTBQDdj1WzvI1d4VkLQJBLR/78TYq+R4TziN2WieWVZiHwGwmaNjro3n9/uAbGUs1VJMT3LTkI2d2OYj
X-Gm-Message-State: AOJu0YzLqy/6A+ETeH9E12nB+p/GXXFdQpOMQTiKddUn0dx25Gf1lH1v
	DRpOJnHalD40VcOgXK4sHGF3GUNsO1nRCs3EZ0/BjjmJub/unCij1dvjTLMId0xVjI4Ud4s/ePt
	HimNmcTsluDbY8z/3m1FQLtCr/UYFr3M4REpya6gZrFd8XPwCOQ==
X-Received: by 2002:a17:902:e810:b0:1f7:1655:825c with SMTP id d9443c01a7336-1ff04860a59mr127749435ad.36.1722407819471;
        Tue, 30 Jul 2024 23:36:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHmcfjVds5cuNEcd1txMPa+VApIJaSskNZFLiX3i8Sit0Q2n9g9r0lcLijWVpFQdhLCW8zJaA==
X-Received: by 2002:a17:902:e810:b0:1f7:1655:825c with SMTP id d9443c01a7336-1ff04860a59mr127749205ad.36.1722407819034;
        Tue, 30 Jul 2024 23:36:59 -0700 (PDT)
Received: from [192.168.68.54] ([43.252.112.134])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7ee1477sm113129505ad.169.2024.07.30.23.36.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 23:36:58 -0700 (PDT)
Message-ID: <68acf6c9-4ab8-4ed5-bddc-f3fc5313597e@redhat.com>
Date: Wed, 31 Jul 2024 16:36:49 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/15] arm64: Mark all I/O as non-secure shared
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240701095505.165383-1-steven.price@arm.com>
 <20240701095505.165383-6-steven.price@arm.com>
 <b20b7e5b-95aa-4fdb-88a7-72f8aa3da8db@redhat.com>
 <e05d2363-d3e4-4a23-9347-723454d603c9@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <e05d2363-d3e4-4a23-9347-723454d603c9@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Suzuki,

On 7/30/24 8:36 PM, Suzuki K Poulose wrote:
> On 30/07/2024 02:36, Gavin Shan wrote:
>> On 7/1/24 7:54 PM, Steven Price wrote:
>> I'm unable to understand this. Steven, could you please explain a bit how
>> PROT_NS_SHARED is turned to a shared (non-secure) mapping to hardware?
>> According to tf-rmm's implementation in tf-rmm/lib/s2tt/src/s2tt_pvt_defs.h,
>> a shared (non-secure) mapping is is identified by NS bit (bit#55). I find
>> difficulties how the NS bit is correlate with PROT_NS_SHARED. For example,
>> how the NS bit is set based on PROT_NS_SHARED.
> 
> 
> There are two things at play here :
> 
> 1. Stage1 mapping controlled by the Realm (Linux in this case, as above).
> 2. Stage2 mapping controlled by the RMM (with RMI commands from NS Host).
> 
> Also :
> The Realm's IPA space is divided into two halves (decided by the IPA Width of the Realm, not the NSbit #55), protected (Lower half) and
> Unprotected (Upper half). All stage2 mappings of the "Unprotected IPA"
> will have the NS bit (#55) set by the RMM. By design, any MMIO access
> to an unprotected half is sent to the NS Host by RMM and any page
> the Realm wants to share with the Host must be in the Upper half
> of the IPA.
> 
> What we do above is controlling the "Stage1" used by the Linux. i.e,
> for a given VA, we flip the Guest "PA" (in reality IPA) to the
> "Unprotected" alias.
> 
> e.g., DTB describes a UART at address 0x10_0000 to Realm (with an IPA width of 40, like in the normal VM case), emulated by the host. Realm is
> trying to map this I/O address into Stage1 at VA. So we apply the
> BIT(39) as PROT_NS_SHARED while creating the Stage1 mapping.
> 
> ie., VA == stage1 ==> BIT(39) | 0x10_0000 =(IPA)== > 0x80_10_0000
> 
                                                      0x8000_10_0000

> Now, the Stage2 mapping won't be present for this IPA if it is emulated
> and thus an access to "VA" causes a Stage2 Abort to the Host, which the
> RMM allows the host to emulate. Otherwise a shared page would have been
> mapped by the Host (and NS bit set at Stage2 by RMM), allowing the
> data to be shared with the host.
> 

Thank you for the explanation and details. It really helps to understand
how the access fault to the unprotected space (upper half) is routed to NS
host, and then VMM (QEMU) for emulation. If the commit log can be improved
with those information, it will make reader easier to understand the code.

I had the following call trace and it seems the address 0x8000_10_1000 is
converted to 0x10_0000 in [1], based on current code base (branch: cca-full/v3).
At [1], the GPA is masked with kvm_gpa_stolen_bits() so that BIT#39 is removed
in this particular case.

   kvm_vcpu_ioctl(KVM_RUN)                         // non-secured host
   kvm_arch_vcpu_ioctl_run
   kvm_rec_enter
   rmi_rec_enter                                   // -> SMC_RMI_REC_ENTER
     :
   rmm_handler                                     // tf-rmm
   handle_ns_smc
   smc_rec_enter
   rec_run_loop
   run_realm
     :
   el2_vectors
   el2_sync_lel
   realm_exit
     :
   handle_realm_exit
   handle_exception_sync
   handle_data_abort
     :
   handle_rme_exit                                 // non-secured host
   rec_exit_sync_dabt
   kvm_handle_guest_abort                          // -> [1]
   gfn_to_memslot
   io_mem_abort
   kvm_io_bus_write                                // -> run->exit_reason = KVM_EXIT_MMIO

Another question is how the Granule Protection Check (GPC) table is updated so
that the corresponding granule (0x8000_10_1000) to is accessible by NS host? I
mean how the BIT#39 is synchronized to GPC table and translated to the property
"granule is accessible by NS host".
     
Thanks,
Gavin







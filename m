Return-Path: <kvm+bounces-26224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 621BC973274
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:23:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8005D1C24435
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 10:23:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C66DD193092;
	Tue, 10 Sep 2024 10:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cHVZKzNW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4970A192D83
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963428; cv=none; b=j7gWWHu5czh7KA8iqfD5fEGJG9Da9215S6r7Go5Sey2uzyqyZl0gk7K6650i3GsO9GQa/Aounk36jsgV68qpc9ceBLWSl+agYYAfgGRtcV829PHrgFlq03JOUH4jgEzR1ey4wvI4UOVbSjKXp/7Auq5bBpe8I5D2aYu1Hbbk1Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963428; c=relaxed/simple;
	bh=KNChsGjb2lH1QCaO4c+WHc3vsV+IaCnT/wqDgxFZC2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZiA9Q6sVkDB0+7XKzaj/PrzmJr7TLwWc6QecMSoK0lLAEyv60Ifsn8R12Hsz8ftXM8/VOHbTBup40uK5prfp59sflCOiuzuoXIs3a+En0k7wfdAfpaA8YHfuYG8REjUEzLRKNtgsIusHaAnSLQmOO5QDqNSduju/QGRXq5+Kp/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cHVZKzNW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725963425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jZlCkxgHqgVcOJKGhBbJjTTzPrSj/msY1WbagCrbXA8=;
	b=cHVZKzNWSbS3ZpMKfCDMRWMAsVgdqRnNoyzHeEmGEHHUwQaIo6suLSBH/lV4JhQKEQLx2p
	kyzHRYs88L9Rgom3SaUhA3o4W4Ioi2CwLHnlA2CBE6PHydHHf/SrOvbW9IUT+4FcCIXXP2
	cuzKwye4Tgvvy8kecDMcqPudWCGM2is=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-119-UQVmLIemNzSriczAzbnxrA-1; Tue, 10 Sep 2024 06:17:02 -0400
X-MC-Unique: UQVmLIemNzSriczAzbnxrA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-374b9617ab0so2293620f8f.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 03:17:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725963420; x=1726568220;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jZlCkxgHqgVcOJKGhBbJjTTzPrSj/msY1WbagCrbXA8=;
        b=dVZ+bMLj33DyOFhXu66uv+W2m0v4jccYqVCStnnb+T3uvqlUaszmcFqx/aefhdTW4C
         alRcAaRYXjC39fiUy/yaI1PEU/aZ8Qf+D2r0zK8ATcn90agMprMMC0L1Gw/qfjqmNlX6
         MKqSbpW/Ni77G/vVECJAdypdT0qzF2XvsXqeGmKlxAvA9KwmOn6VvqhM6Tq9YQLgVEdk
         ZHzXo9td1lDx1UvEzDeMEUpvPIvo2LMw02u92KgMVrmAdOpY1AGOieXz8U3x9JuJYfJs
         p6DiprEjGl5R79rUQ+dQk3kUsUBuFhWu68le6JEfxihMDXa/X4KQfHgy4WOR/L+2plN4
         W56A==
X-Forwarded-Encrypted: i=1; AJvYcCUIANF7LpYkg1eRVeWYUE2pXoYlD6b6cu6Fw+UPt1exRln7VsbP0lfa+GllpRvmQUeHZzw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzi6vg0iw+ntM/krMxx7irn9W0CtBPrynQ2KlUHbtF3tb+phOyC
	flGhxETqgq2Rb93MuEAsuhjFozzpl7NvZftXPChqInzhquxAb9v+vuUdxZLF5nwM5k1VZWHDHiu
	PX3Xkbv/jV+ECAfNfThVwriCZdyA20eSCza8G+RlTuEHHYBlWIF+vzbgzL9LL
X-Received: by 2002:a05:600c:314c:b0:42b:a88f:f872 with SMTP id 5b1f17b1804b1-42cadb699b9mr81196755e9.32.1725963420368;
        Tue, 10 Sep 2024 03:17:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGAeXGEmEHACVBKTkX/4xRjxYnAdgIyFeR4exeeYt/TzMW/gb7oDzfGPzcJ9AHrR0KmKTIGsQ==
X-Received: by 2002:a05:600c:314c:b0:42b:a88f:f872 with SMTP id 5b1f17b1804b1-42cadb699b9mr81196475e9.32.1725963419770;
        Tue, 10 Sep 2024 03:16:59 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-42cac8543dbsm116224985e9.42.2024.09.10.03.16.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 03:16:59 -0700 (PDT)
Message-ID: <9dc3f31d-a7d7-4cf3-a86d-4266a5146622@redhat.com>
Date: Tue, 10 Sep 2024 12:16:58 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 19/21] KVM: TDX: Add an ioctl to create initial guest
 memory
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, dmatlack@google.com, isaku.yamahata@gmail.com,
 yan.y.zhao@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-20-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240904030751.117579-20-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/24 05:07, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add a new ioctl for the user space VMM to initialize guest memory with the
> specified memory contents.
> 
> Because TDX protects the guest's memory, the creation of the initial guest
> memory requires a dedicated TDX module API, TDH.MEM.PAGE.ADD(), instead of
> directly copying the memory contents into the guest's memory in the case of
> the default VM type.
> 
> Define a new subcommand, KVM_TDX_INIT_MEM_REGION, of vCPU-scoped
> KVM_MEMORY_ENCRYPT_OP.  Check if the GFN is already pre-allocated, assign
> the guest page in Secure-EPT, copy the initial memory contents into the
> guest memory, and encrypt the guest memory.  Optionally, extend the memory
> measurement of the TDX guest.
> 
> Discussion history:

While useful for the reviewers, in the end this is the simplest possible 
userspace API (the one that we started with) and the objections just 
went away because it reuses the infrastructure that was introduced for 
pre-faulting memory.

So I'd replace everything with:

---
The ioctl uses the vCPU file descriptor because of the TDX module's 
requirement that the memory is added to the S-EPT (via TDH.MEM.SEPT.ADD) 
prior to initialization (TDH.MEM.PAGE.ADD).  Accessing the MMU in turn 
requires a vCPU file descriptor, just like for KVM_PRE_FAULT_MEMORY.  In 
fact, the post-populate callback is able to reuse the same logic used by 
KVM_PRE_FAULT_MEMORY, so that userspace can do everything with a single 
ioctl.

Note that this is the only way to invoke TDH.MEM.SEPT.ADD before the TD 
in finalized, as userspace cannot use KVM_PRE_FAULT_MEMORY at that 
point.  This ensures that there cannot be pages in the S-EPT awaiting 
TDH.MEM.PAGE.ADD, which would be treated incorrectly as spurious by 
tdp_mmu_map_handle_target_level() (KVM would see the SPTE as PRESENT, 
but the corresponding S-EPT entry will be !PRESENT).
---

Part of the second paragraph comes from your link [4], 
https://lore.kernel.org/kvm/Ze-TJh0BBOWm9spT@google.com/, but updated 
for recent changes to KVM_PRE_FAULT_MEMORY.

This drops the historical information that is not particularly relevant 
for the future, it updates what's relevant to mention changes done for 
SEV-SNP, and also preserves most of the other information:

* why the vCPU file descriptor

* the desirability of a single ioctl for userspace

* the relationship between KVM_TDX_INIT_MEM_REGION and KVM_PRE_FAULT_MEMORY

Paolo



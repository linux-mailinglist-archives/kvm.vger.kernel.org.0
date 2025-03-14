Return-Path: <kvm+bounces-41036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F67AA60DE6
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 10:51:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97DB51B603A2
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 09:51:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B7D31F2B82;
	Fri, 14 Mar 2025 09:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QPJ2xHAE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959C41EF368
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 09:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741945837; cv=none; b=Wfka3hxSDCwa+qOloTXkYR705pHcGc8XybcP1cgcUtgxiVXXGD7jC3OHGWqOHVSjdaRV2G7tuKFFzEcnMXLlHf+Dkm4Ngx0KWlyEiozs13n2vytpVe+NsGmhabLkdx++u2T8AfsyAVRTETr3wRvQUllPROiMJMofFoe535+wepY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741945837; c=relaxed/simple;
	bh=2YbCjKwn91peoO3lDPuuBejpiPo3S8WBJy+HmUMzmZQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tcnB/ymWVLzcECMo8uwsb5s0WrM2BREPOys4atA8Un8wIC+oKy032n2mOeBbv4Ly8GoBLxKqWGmaeZWl6Vw2V59ZYpU3MhB4adsDOngOEgJr0ju+igJ/K3EJOpik/HHYtCZXYDfcCDdx/sEeAMTVwOCiBUZO7z3ndq3DGwtTFek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QPJ2xHAE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741945834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DO65Jq3ncBMLs59OX/C3EEaa/dJveFjrkwXbuX/qlyg=;
	b=QPJ2xHAEPGC93kjQJp9GP/UMLo1zVNJds57vrErl0ripfhN8Ku0pe3TwYVBW/zQ5eP8qlO
	vBUPdhBtJG2sDVmwJbKJ7qjYRcbJtu/OPpI4l8uKpu1CGpcRz7FfkcVolMmMSqgNASq2zs
	/Kjhiv9C8BoklthDlsAAV0tZxVgckns=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-7EzhSKhlNeGP8S1hrhkLYQ-1; Fri, 14 Mar 2025 05:50:32 -0400
X-MC-Unique: 7EzhSKhlNeGP8S1hrhkLYQ-1
X-Mimecast-MFC-AGG-ID: 7EzhSKhlNeGP8S1hrhkLYQ_1741945832
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43cf3168b87so9954905e9.2
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 02:50:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741945831; x=1742550631;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DO65Jq3ncBMLs59OX/C3EEaa/dJveFjrkwXbuX/qlyg=;
        b=ra1r77LDK6enwKHWoD/NbssMga9anLwrjNSRat8YBuREgqtcI6bEgMYCg1ICpeqQiq
         nGzZYumr+EbMPT7oOZLPBVW/d8ZfV3aNjJJCi/SZbsygB3U29koUXBdGrAN580Gu4B6G
         aSwXE/CwuDu/OO1PZaqgSWpHrkR408yf1hapPpvXEWiwkFhD0qNbJuJ0X0Zhot6xGqCT
         HOEp33SPEFeHtCtVukRfvEvqvs4Ea5AHXD58DizJn3H/orAtfs9RMYIi7oCZieH1t9qy
         EmNh6Re087KLyMhRcZvB7TQH0a7QsghqIhzaBjk27GxY7+uSaD6H4/QqwAB20qB6Zlhy
         3uWw==
X-Forwarded-Encrypted: i=1; AJvYcCV+RmBxEAFahLuOMAkyNwW4u/BSHMSduSHBkw+S6vBt7cpa4QR90F0jk/X25esvL3hK0g4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5LI2r2scpafU4/J2xqHnG3GmRR/BNeDzLclOc0P1f0xGXR8hJ
	4qfR1rjDCC15iWe8fuDBUinZ+P3VbPaQul7JJ/JWJGLP6h7TN36pjqhHOOzLGG6TCY+38tBxLF3
	Vvm+5jZkAvq+Ei7xJu3X69pHKO0oSRkmdETWkNquYY+gRir+imw==
X-Gm-Gg: ASbGncsZwKD+04pGUjHbFEUjaG720selZoiVBJmBO2UONLlarx+gu5cc3mWDeL9kYj8
	I5OPVqweJItNOWO/e8F0MYJb6omSfCO3WIH13qfrhcKafTlAxsVomsNndGMExJ5QmWZmfjySdOl
	KJwd4f5F/Hf0sYiI1i6ZcEUElRWz0ZopyCGPHhw51VEnOAtGPKZLy7NTBkO9TZU8l4DRCgo1RGl
	zA3Nqj+tuL9V/Y3qUgyr1xmOiWBKI0BeZMMWeEnrs0jFtY/Z12yXoexeZFuR9MADqGb0GgsuloE
	5Ij6TCBZMxkbEOLeGbieiriX/YM+7qUJc5HKl4+gwyTJoX3E3TpMQ1uZ6YBIuWFpvzcEIeNTE5s
	Xs+OXniWgCQJigYp2dR13dT7I9JK7wNwRcljBszd/VCY=
X-Received: by 2002:a05:600c:46c5:b0:43c:ec4c:25b4 with SMTP id 5b1f17b1804b1-43d1ec7a33dmr23155175e9.10.1741945831592;
        Fri, 14 Mar 2025 02:50:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF2gPuMmeY4FdotxtdtpVaCKUqgzeJYWExaOPB2sEi+uamT07yL2pHWlLokJa8qFuW6IWTGbw==
X-Received: by 2002:a05:600c:46c5:b0:43c:ec4c:25b4 with SMTP id 5b1f17b1804b1-43d1ec7a33dmr23154855e9.10.1741945831131;
        Fri, 14 Mar 2025 02:50:31 -0700 (PDT)
Received: from ?IPV6:2003:cb:c745:2000:5e9f:9789:2c3b:8b3d? (p200300cbc74520005e9f97892c3b8b3d.dip0.t-ipconnect.de. [2003:cb:c745:2000:5e9f:9789:2c3b:8b3d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d1fd6b2acsm12455885e9.0.2025.03.14.02.50.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Mar 2025 02:50:29 -0700 (PDT)
Message-ID: <af80216e-7a09-48a3-97b8-5b19cc3ded28@redhat.com>
Date: Fri, 14 Mar 2025 10:50:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] memory: Attach MemoryAttributeManager to
 guest_memfd-backed RAMBlocks
To: Chenyi Qiang <chenyi.qiang@intel.com>, Alexey Kardashevskiy
 <aik@amd.com>, Peter Xu <peterx@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250310081837.13123-1-chenyi.qiang@intel.com>
 <20250310081837.13123-7-chenyi.qiang@intel.com>
 <8d9ff645-cfc2-4789-9c13-9275103fbd8c@intel.com>
 <11d40705-60d8-4ad6-8134-86b393bfae8f@redhat.com>
 <192a8ed9-fecb-4faa-b179-ed6f9ef18ac8@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <192a8ed9-fecb-4faa-b179-ed6f9ef18ac8@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14.03.25 10:30, Chenyi Qiang wrote:
> 
> 
> On 3/14/2025 5:00 PM, David Hildenbrand wrote:
>> On 14.03.25 09:21, Chenyi Qiang wrote:
>>> Hi David & Alexey,
>>
>> Hi,
>>
>>>
>>> To keep the bitmap aligned, I add the undo operation for
>>> set_memory_attributes() and use the bitmap + replay callback to do
>>> set_memory_attributes(). Does this change make sense?
>>
>> I assume you mean this hunk:
>>
>> +    ret =
>> memory_attribute_manager_state_change(MEMORY_ATTRIBUTE_MANAGER(mr->rdm),
>> +                                                offset, size, to_private);
>> +    if (ret) {
>> +        warn_report("Failed to notify the listener the state change of "
>> +                    "(0x%"HWADDR_PRIx" + 0x%"HWADDR_PRIx") to %s",
>> +                    start, size, to_private ? "private" : "shared");
>> +        args.to_private = !to_private;
>> +        if (to_private) {
>> +            ret = ram_discard_manager_replay_populated(mr->rdm, &section,
>> +
>> kvm_set_memory_attributes_cb,
>> +                                                       &args);
>> +        } else {
>> +            ret = ram_discard_manager_replay_discarded(mr->rdm, &section,
>> +
>> kvm_set_memory_attributes_cb,
>> +                                                       &args);
>> +        }
>> +        if (ret) {
>> +            goto out_unref;
>> +        }
>>

We should probably document that memory_attribute_state_change() cannot 
fail with "to_private", so you can simplify it to only handle the "to 
shared" case.

>>
>> Why is that undo necessary? The bitmap + listeners should be held in
>> sync inside of
>> memory_attribute_manager_state_change(). Handling this in the caller
>> looks wrong.
> 
> state_change() handles the listener, i.e. VFIO/IOMMU. And the caller
> handles the core mm side (guest_memfd set_attribute()) undo if
> state_change() failed. Just want to keep the attribute consistent with
> the bitmap on both side. Do we need this? If not, the bitmap can only
> represent the status of listeners.

Ah, so you meant that you effectively want to undo the attribute change, 
because the state effectively cannot change, and we want to revert the 
attribute change.

That makes sense when we are converting private->shared.


BTW, I'm thinking if the orders should be the following (with in-place 
conversion in mind where we would mmap guest_memfd for the shared memory 
parts).

On private -> shared conversion:

(1) change_attribute()
(2) state_change(): IOMMU pins shared memory
(3) restore_attribute() if it failed

On shared -> private conversion
(1) state_change(): IOMMU unpins shared memory
(2) change_attribute(): can convert in-place because there are not pins

I'm wondering if the whole attribute change could actually be a 
listener, invoked by the memory_attribute_manager_state_change() call 
itself in the right order.

We'd probably need listener priorities, and invoke them in reverse order 
on shared -> private conversion. Just an idea to get rid of the manual 
ram_discard_manager_replay_discarded() call in your code.

-- 
Cheers,

David / dhildenbh



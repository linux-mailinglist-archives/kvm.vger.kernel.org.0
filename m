Return-Path: <kvm+bounces-48270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 94C7DACC150
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 09:42:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 97C377A7031
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 07:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44A5C269B12;
	Tue,  3 Jun 2025 07:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W6p1D3gp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1D71F63D9
	for <kvm@vger.kernel.org>; Tue,  3 Jun 2025 07:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748936528; cv=none; b=OP3A7XGXEH4Cm9f/glInrzcxSzq+EcdftFVxRFNbUuIs1ZE3Za3Lh5REXqVRjZplFj1P+GEPpU/Ys2lXJ4+3UM1HRh14Rc9Zz5sdMSQcyFxdrL7le4kZLUpEyRTiV+1Avz3N1aqirTA3fiEqubSTzWExrKLHPItSn8CR5QpPpLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748936528; c=relaxed/simple;
	bh=ibe8SZAqVKXS4EUsFEulhBjOh4Ywk+gV1vBIUzCWO3g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oidoqPnWQsLLeuZZWVXUFpsI0GuKfeMcxDc654FGUgnYXrlsMafOAvOrRy6X904YTSTAs69zZJjZyMLNFrIoWtAK6IqdzkBMiLqBA6YkaONR9IBnlg1uPEJjOQFCMk89c6rBfysOWOK0ducskHVhYteFcuHNiXzAx6JKQP5IuYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W6p1D3gp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748936525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hoQA1PjrBU5ELXkE8jzZ0CuLbxAFe5dIoZ6yV+xCS2o=;
	b=W6p1D3gp52bmqs3Sm+gO2w/elxKGMRJDJwEAbVv76R0CqP15BzGo2ebhruIlxsVl6SmJlz
	o8g4tw0fYDraDxJuaZxTHqiNod0BPkQZECO4bXSaza4xQMOvIsEddTDYinwS2+eQrr/sOi
	o9mPqM5hiPTDbJbHjvUygiNF8Ped7UY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-573-XcJa5ChPOn22zk23UYgiUg-1; Tue, 03 Jun 2025 03:42:03 -0400
X-MC-Unique: XcJa5ChPOn22zk23UYgiUg-1
X-Mimecast-MFC-AGG-ID: XcJa5ChPOn22zk23UYgiUg_1748936522
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-451d7de4ae3so12596515e9.2
        for <kvm@vger.kernel.org>; Tue, 03 Jun 2025 00:42:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748936522; x=1749541322;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hoQA1PjrBU5ELXkE8jzZ0CuLbxAFe5dIoZ6yV+xCS2o=;
        b=l8VgixEna4rUFA7GEVmHAQNGByz8H7I92MRLrt5IO2DahUQbFnD7nkdBU/zNDnJRno
         OAUe/kNTKC3VxWOCYmUpMRk2atea5SuTWsLtuXOLCQinfquQDwiik/VM9D2efXWhz2/L
         tpTPQUUrEmUCLOvnstxi5c0PCd/2va7HJdiMPDlzvX2hqlhmwTApHq6WBKV93atANHSQ
         EzZfvNu58gVx2HiGD5po8A4kbHp8xI6HQJXHxaE680VkDXtlaqOzyNdA+zt6vPIzSs6O
         1FtPi2zs/gXIVj7qPyv4LZ9ip68LzQs0VCGRhaxfrHKV0iKaBO3eGUtXODa7vGIsVAs6
         aKQg==
X-Forwarded-Encrypted: i=1; AJvYcCU8BJlpVAK+ML1r0tsRuxyJM3Up/SBptiTnS0FLUDFJmJmgZAn4++xZFCE3g7IEc39mlh4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+Y7FXrqsiKuv1m4xVX4Vd0eN0I5a7AoMGeaLgegPOtVglVdPy
	3J8n6LrPMoXsRH2LkOIvWlmbmnFpZ+w6I3zgvJqEucdGPyOnNUxUwbfHwuWNKXmhRkF0L5lyGWW
	myRVvIgWDMRhgHtTGLt7ZRWBmWTNThCizDxKPOO8gwW1EG3ZkJnpRIQ==
X-Gm-Gg: ASbGncth7CRw63TmwR9qi8ALjQhPiMdehbZ5jmPrCVtuyQMOtQ3FIT+QBpXHhXZT+2o
	BuogeQSpVq/XtM7SKfBRkicFZlFL5ngWNs657IJ5+G2szA1aHUIZ2Sggupbviv8SqH/TP5+FJ9N
	RwLWuSfzWs6C1Ril0Gl5dHohgWrbFl9wt0ru9zqfGeTE7UN1g9/fisYiIFj2sZ4NS8BeCXLId4E
	DB1Z2xuzxGqqk8/H8oyJqNK9HIECuHY79JnT1icKPjjffzRRTl7vstZh23o+bBLzkxPh6Lc/flf
	7zX1KSCvNoiSzgCVDiXY3rLJiSfw+WA7jNNfrjf5kcoFPuvPMXdEl1C6YE8KtM/L321bbTy5Chw
	l+REXMZdQeGPgF5UfmHV385hNkKR69EPNHPrHWFg=
X-Received: by 2002:a05:600c:3593:b0:43c:f3e4:d6f6 with SMTP id 5b1f17b1804b1-450d887f958mr153565595e9.31.1748936522098;
        Tue, 03 Jun 2025 00:42:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0kzJVFDha4ynuUkq+3H10o3/73S0BS64Ir7cRJstfcLxUK2VWcnrK8x0totFOafmPtKuLUA==
X-Received: by 2002:a05:600c:3593:b0:43c:f3e4:d6f6 with SMTP id 5b1f17b1804b1-450d887f958mr153565255e9.31.1748936521679;
        Tue, 03 Jun 2025 00:42:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0d:f000:eec9:2b8d:4913:f32a? (p200300d82f0df000eec92b8d4913f32a.dip0.t-ipconnect.de. [2003:d8:2f0d:f000:eec9:2b8d:4913:f32a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450d7fb051bsm149380305e9.18.2025.06.03.00.42.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 00:42:01 -0700 (PDT)
Message-ID: <828fa7bb-8519-4e3f-a334-c1b4ea27fee3@redhat.com>
Date: Tue, 3 Jun 2025 09:41:59 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/5] ram-block-attributes: Introduce RamBlockAttributes
 to manage RAMBlock with guest_memfd
To: "Gupta, Pankaj" <pankaj.gupta@amd.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
 Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 "Lindgren, Tony" <tony.lindgren@intel.com>,
 "Maloor, Kishen" <kishen.maloor@intel.com>
References: <20250530083256.105186-1-chenyi.qiang@intel.com>
 <20250530083256.105186-5-chenyi.qiang@intel.com>
 <4105d9ad-176e-423a-9b4f-8308205fe204@amd.com>
 <9a9bb6bb-f8c0-4849-afb0-7cf5a409dab0@intel.com>
 <d0d1bed2-c1ee-4ae7-afaf-fbd07975f52c@amd.com>
 <c646012a-b993-4f37-ac31-d2447c7e9ab8@intel.com>
 <219c32d8-4a5e-4a74-add0-aee56b8dc78b@amd.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <219c32d8-4a5e-4a74-add0-aee56b8dc78b@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03.06.25 09:17, Gupta, Pankaj wrote:
> +CC Tony & Kishen
> 
>>>>> In this patch series we are only maintaining the bitmap for Ram discard/
>>>>> populate state not for regular guest_memfd private/shared?
>>>>
>>>> As mentioned in changelog, "In the context of RamDiscardManager, shared
>>>> state is analogous to populated, and private state is signified as
>>>> discarded." To keep consistent with RamDiscardManager, I used the ram
>>>> "populated/discareded" in variable and function names.
>>>>
>>>> Of course, we can use private/shared if we rename the RamDiscardManager
>>>> to something like RamStateManager. But I haven't done it in this series.
>>>> Because I think we can also view the bitmap as the state of shared
>>>> memory (shared discard/shared populate) at present. The VFIO user only
>>>> manipulate the dma map/unmap of shared mapping. (We need to consider how
>>>> to extend the RDM framwork to manage the shared/private/discard states
>>>> in the future when need to distinguish private and discard states.)
>>>
>>> As function name 'ram_block_attributes_state_change' is generic. Maybe
>>> for now metadata update for only two states (shared/private) is enough
>>> as it also aligns with discard vs populate states?
>>
>> Yes, it is enough to treat the shared/private states align with
>> populate/discard at present as the only user is VFIO shared mapping.
>>
>>>
>>> As we would also need the shared vs private state metadata for other
>>> COCO operations e.g live migration, so wondering having this metadata
>>> already there would be helpful. This also will keep the legacy interface
>>> (prior to in-place conversion) consistent (As memory-attributes handling
>>> is generic operation anyway).
>>
>> When live migration in CoCo VMs is introduced, I think it needs to
>> distinguish the difference between the states of discard and private. It
>> cannot simply skip the discard parts any more and needs special handling
>> for private parts. So still, we have to extend the interface if have to
>> make it avaiable in advance.
> 
> You mean even the discard and private would need different handling

I am pretty sure they would in any case? Shared memory, you can simply 
copy, private memory has to be extracted + placed differently.

If we run into problems with live-migration, we can investigate how to 
extend the current approach.

Just like with memory hotplug / virtio-mem, I shared some ideas on how 
to make it work, but holding up this work when we don't even know what 
exactly we will exactly need for other future use cases does not sound 
too plausible.

-- 
Cheers,

David / dhildenb



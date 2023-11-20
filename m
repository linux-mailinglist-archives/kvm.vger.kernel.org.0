Return-Path: <kvm+bounces-2048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DCAC7F0F1A
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 10:30:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A03BA1C20EF7
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 09:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54BB011707;
	Mon, 20 Nov 2023 09:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HlObWMY6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC45DCF
	for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 01:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700472638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XvzFW29kk3rWAqj1jC4b7/K7OTvxSImb2oD5NlF+XWU=;
	b=HlObWMY6NpY47PLg1ev9ZbUf3HHXV6EtTA/s7Z15EdywscR/Zw7deCpDGLouzyazXVWdgm
	KyXvNuQbx2ljT6vRecgsGHJxB4J8ZMM3ocfyMnPxNtvfqwpUVWJJPqmne00II+T4Qjcq/A
	bChq0ipTk0GlEkXXZe8WLKA3kc3kPMI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-DGDlTrXbNIO0bZCqDJmtTA-1; Mon, 20 Nov 2023 04:30:37 -0500
X-MC-Unique: DGDlTrXbNIO0bZCqDJmtTA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-332c50f4d98so488276f8f.1
        for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 01:30:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700472636; x=1701077436;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XvzFW29kk3rWAqj1jC4b7/K7OTvxSImb2oD5NlF+XWU=;
        b=cnwLrRhBMNakoYY9PKSFdyp8j7HdWfphn68x94XbdhTw3VNnKg5wbsFBp0aCemYE+L
         G2u92Ps5ME/+Bqm2AON+yh5Lv4+vA1Sgy2yg67uHtAX7oUYSvECx+MvHL3KumE72ok/z
         PTm8PEGKBYq26Du3czBs0kgUJWhHTE6wMORL8ksHED3/uIW0KrO94saACcZc9c1PgvMS
         3B75laor2ZAER0a+81rfvASii46wRM5fXTxjv0toTMKBCyaP4lwcDC108uCMAlAJ5bue
         kc31OnVAg25rciQ7IGs9+s8yfue7/PoOQXQ3g7HWARyhcOo2om4AD5UdZheyEV/7OnUp
         1GZw==
X-Gm-Message-State: AOJu0Yy7f4LraJiv6WIwKRoHkpqZPS/OG8ZGcQhEgI3jw198mdcwlC/d
	3KGsKpv2CDmUxWBtYH8EWbO8RDbKZAD84r/qIUiIgC9fF34UVapK+vrul2z0iC5r227H3o90ldT
	B6VDUcSU7wOUK
X-Received: by 2002:a5d:5985:0:b0:332:c5c5:7847 with SMTP id n5-20020a5d5985000000b00332c5c57847mr2643878wri.5.1700472635845;
        Mon, 20 Nov 2023 01:30:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHRqYP+pPaH8UHnG90WWytlsAIEMLMSrXl0Ex4SkLsApxKkEBpQ3Ej9zru1Sxy0D2tfAAJrkw==
X-Received: by 2002:a5d:5985:0:b0:332:c5c5:7847 with SMTP id n5-20020a5d5985000000b00332c5c57847mr2643850wri.5.1700472635436;
        Mon, 20 Nov 2023 01:30:35 -0800 (PST)
Received: from ?IPV6:2003:cb:c746:7700:9885:6589:b1e3:f74c? (p200300cbc746770098856589b1e3f74c.dip0.t-ipconnect.de. [2003:cb:c746:7700:9885:6589:b1e3:f74c])
        by smtp.gmail.com with ESMTPSA id f12-20020adff44c000000b003313e4dddecsm10493621wrp.108.2023.11.20.01.30.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Nov 2023 01:30:35 -0800 (PST)
Message-ID: <0ca6a665-ce88-4c81-927d-6e94a249949d@redhat.com>
Date: Mon, 20 Nov 2023 10:30:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/70] HostMem: Add mechanism to opt in kvm guest memfd
 via MachineState
Content-Language: en-US
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Michael Roth <michael.roth@amd.com>, Sean Christopherson
 <seanjc@google.com>, Claudio Fontana <cfontana@suse.de>,
 Gerd Hoffmann <kraxel@redhat.com>, Isaku Yamahata
 <isaku.yamahata@gmail.com>, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
 <20231115071519.2864957-5-xiaoyao.li@intel.com>
 <af2a5b80-f259-45b1-9d92-812e3c4bc06c@redhat.com>
 <6674dc2c-f1ed-496e-bc17-256869bdeae9@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <6674dc2c-f1ed-496e-bc17-256869bdeae9@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.11.23 03:53, Xiaoyao Li wrote:
> On 11/16/2023 2:14 AM, David Hildenbrand wrote:
>> On 15.11.23 08:14, Xiaoyao Li wrote:
>>> Add a new member "require_guest_memfd" to memory backends. When it's set
>>> to true, it enables RAM_GUEST_MEMFD in ram_flags, thus private kvm
>>> guest_memfd will be allocated during RAMBlock allocation.
>>>
>>> Memory backend's @require_guest_memfd is wired with @require_guest_memfd
>>> field of MachineState. MachineState::require_guest_memfd is supposed to
>>> be set by any VMs that requires KVM guest memfd as private memory, e.g.,
>>> TDX VM.
>>>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>
>> I'm confused, why do we need this if it's going to be the same for all
>> memory backends right now?
>>
> 
> I want to provide a elegant (in my sense) way to configure "the need of
> guest memfd" instead of checking x86machinestate->vm_type in physmem.c
> 

It's suboptimal right now, but I guess you want to avoid looking up the 
machine e.g., in ram_backend_memory_alloc().

I'd suggest s/require_guest_memfd/guest_memfd/gc in "struct 
HostMemoryBackend".

Apart from that LGTM.

-- 
Cheers,

David / dhildenb



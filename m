Return-Path: <kvm+bounces-2045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C010B7F0ED9
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 10:19:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0D541C213BB
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 09:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6280111193;
	Mon, 20 Nov 2023 09:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P+KxBqX/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CE0B8
	for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 01:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700471945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=C01FVro+eBYGfwM2zmh9AzxNuWPUTQJmcdnzf9+a05o=;
	b=P+KxBqX/G0JApOxovvVyJqS7ZrPZ1ZjbhGC1aTxSdPpx1FrbnfKvWWf1t2eXZgInhy/A99
	mp51AlJFdgQ6rHgG71KbyvwIs0sS1U3XOQ398ekAiTYvDVF5yvmXpPl2yKon7qxiY2iFIu
	tE4WYFsK5+LFBJO86sxwH/i/4K+ANIY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-352-CViQe6b8PZOUl98LPJDTTQ-1; Mon, 20 Nov 2023 04:19:04 -0500
X-MC-Unique: CViQe6b8PZOUl98LPJDTTQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-332c9eca943so241646f8f.1
        for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 01:19:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700471943; x=1701076743;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C01FVro+eBYGfwM2zmh9AzxNuWPUTQJmcdnzf9+a05o=;
        b=PwHTi1TdwvM2ixI4QXwTIEGedXuC66Si5mwf/Um69/qxNONs0VECqI50dugEvXVYmf
         mkrmzyiiCVCrjsHWaquSe9of07iXOs6sKFzV+EQZDq+puy+wD4/1t+VTQDEGvx4ZAeBG
         RfStpW+qcpMu5jkxW3YjKggf9JeK6FUVEJ3HXBqtm196fcFnuKbF1753fR1gF0iui7Qf
         W2ySV6grBmH5knhgvLwM39R+0AD950TAx7vFJdR8HKvGwbWFjx1b+bSI5E7cVcbA3wLC
         8mVghXrm9kW0MBSnSr4l8Ay2XNApqKDCApDaBAz8ZVakMZ8//VjWigb+pA7zTb1HjjOc
         lqlQ==
X-Gm-Message-State: AOJu0YzTTV5FRj0oFUl7Nv67zNtGz05llCgaQ+EWZHz8/GiJHZQtX7J0
	Hkr2cAAxcBDOQN7TjJlBXFBK11ROMN5/xduW7WuK0BJ+NnaNhywPfNF33DrhwJDK0l9eM2dmXnm
	w7NGwYERWrUmv
X-Received: by 2002:a05:6000:1845:b0:32f:84e3:9db5 with SMTP id c5-20020a056000184500b0032f84e39db5mr4804864wri.6.1700471942723;
        Mon, 20 Nov 2023 01:19:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGFvP8qH2+mldOM/2UKYvC5vq3PsEmRnLmPU78lcyEVojnAbSdsjITgHo2cIESifI9BvE3HBg==
X-Received: by 2002:a05:6000:1845:b0:32f:84e3:9db5 with SMTP id c5-20020a056000184500b0032f84e39db5mr4804846wri.6.1700471942326;
        Mon, 20 Nov 2023 01:19:02 -0800 (PST)
Received: from ?IPV6:2003:cb:c746:7700:9885:6589:b1e3:f74c? (p200300cbc746770098856589b1e3f74c.dip0.t-ipconnect.de. [2003:cb:c746:7700:9885:6589:b1e3:f74c])
        by smtp.gmail.com with ESMTPSA id b8-20020a5d45c8000000b003142e438e8csm10522544wrs.26.2023.11.20.01.19.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Nov 2023 01:19:01 -0800 (PST)
Message-ID: <c3a7704f-12d8-457e-aad2-1c2ece896286@redhat.com>
Date: Mon, 20 Nov 2023 10:19:00 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/70] RAMBlock: Add support of KVM private guest memfd
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
 <20231115071519.2864957-3-xiaoyao.li@intel.com>
 <ed599765-65b7-4253-8de2-61afba178e2d@redhat.com>
 <37b5ba85-021a-418b-8eda-8a716b7b7fb3@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <37b5ba85-021a-418b-8eda-8a716b7b7fb3@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.11.23 03:45, Xiaoyao Li wrote:
> On 11/16/2023 1:54 AM, David Hildenbrand wrote:
>> On 15.11.23 08:14, Xiaoyao Li wrote:
>>> Add KVM guest_memfd support to RAMBlock so both normal hva based memory
>>> and kvm guest memfd based private memory can be associated in one
>>> RAMBlock.
>>>
>>> Introduce new flag RAM_GUEST_MEMFD. When it's set, it calls KVM ioctl to
>>> create private guest_memfd during RAMBlock setup.
>>>
>>> Note, RAM_GUEST_MEMFD is supposed to be set for memory backends of
>>> confidential guests, such as TDX VM. How and when to set it for memory
>>> backends will be implemented in the following patches.
>>
>> Can you elaborate (and add to the patch description if there is good
>> reason) why we need that flag and why we cannot simply rely on the VM
>> type instead to decide whether to allocate a guest_memfd or not?
>>
> 
> The reason is, relying on the VM type is sort of hack that we need to
> get the MachineState instance and retrieve the vm type info. I think
> it's better not to couple them.
> 
> More importantly, it's not flexible and extensible for future case that
> not all the memory need guest memfd.
> 

Okay. In that case, please update the documentation of all functions 
where we are allowed to pass in RAM_GUEST_MEMFD. There are a couple of 
them in include/exec/memory.h

I'll note that the name/terminology of "RAM_GUEST_MEMFD" is extremely 
Linux+kvm specific. But I cannot really come up with something better 
right now.

-- 
Cheers,

David / dhildenb



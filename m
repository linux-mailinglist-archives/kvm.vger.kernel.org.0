Return-Path: <kvm+bounces-52628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C2900B0752C
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 13:57:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C4CE7B1C7C
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 11:54:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE6212F3C26;
	Wed, 16 Jul 2025 11:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="vAlgwaGO"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36592BE647
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 11:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752666948; cv=none; b=VOUaytWqmZF65lm/UNx3uloTL1ebatEKkuuke73wBodQsPIavrMRnOkFNooSztLYcWBUOnrSrk3eGEaqCXd6IkQ6SSrMM2yrpsBcVPhdxIJaYKLdeRUzWVqSxGOGFurhC0247bmpkJA4pWDLwBSuFeNF8ZjutyyAtSbtgs2vlHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752666948; c=relaxed/simple;
	bh=ui0dZ7bzzwjHU1GcfQhDAqgbdyXWF0SK5bbkTZBv3K0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gpdlxl9366tjhQXv638+2yJZbscMPFHqhYf/KtRAhus8zHNjRfLcW+Jf6RQaN+5gobjTEQ3t8RjVxlU/PHtwdbINz3atvyG1ukWvIJwmE798u4LDX+AWp4w/oNdNBSdUtza0eNONhAzFsc42DWj+yBe2RdXH9zcnzoeEXINOwkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=vAlgwaGO reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from [157.82.206.39] ([157.82.206.39])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 56GBtiDw032585
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 16 Jul 2025 20:55:44 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=35L8HRBjOQ1lFYDWVFY8MHeYKn6iTAxwtbU8F1CQFVU=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250326; t=1752666945; v=1;
        b=vAlgwaGObVxhq3ExobDUjZ1guCfThxNZqMTCtOhDSOQL52fGG9XSTEDYIGYrOjD2
         98OrTu/Olzm3Ck62aIG5ninth9+RrutGhpTdF8YLf+JszKUj6PaAZuY56B9NR5Q1
         P5W75EkiVmYB3zjytN0S67QFjAuoc8cs9xkmT+VdHspUvSjIzIv9iDfZpeNUAQyU
         U1JiH6SABEl16MsPy/nTjR56G5dQf60BqQoKhfGkQxlRCX1bsbEoYsCP/2KwKfSn
         GGowJ/Tdh1LQqB++o3fs89g4umSS6qcdm3BqhREheg6qzOOtgFjGA+BH53YEEKT0
         4xhcsQ44W+qKjsXBXmYnlA==
Message-ID: <b4ee5979-c35e-4c50-97c4-dbb0ae1e6d27@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 16 Jul 2025 20:55:44 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 06/13] virtio-pci: implement support for extended
 features
To: Paolo Abeni <pabeni@redhat.com>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Jason Wang
 <jasowang@redhat.com>,
        Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, Luigi Rizzo <lrizzo@google.com>,
        Giuseppe Lettieri
 <g.lettieri@iet.unipi.it>,
        Vincenzo Maffione <v.maffione@gmail.com>,
        Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
        kvm@vger.kernel.org
References: <cover.1752229731.git.pabeni@redhat.com>
 <eb1aa9c8442d9b482b5c84fdca54b92c8a824495.1752229731.git.pabeni@redhat.com>
 <8af39b78-a95d-4093-b68c-20b556860a09@rsg.ci.i.u-tokyo.ac.jp>
 <f1381483-a507-4420-a0c9-52bf8131e6e6@redhat.com>
 <59102a09-1e25-4c14-a681-7170c87df501@redhat.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <59102a09-1e25-4c14-a681-7170c87df501@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2025/07/16 18:14, Paolo Abeni wrote:
> On 7/15/25 6:21 PM, Paolo Abeni wrote:
>> On 7/15/25 9:42 AM, Akihiko Odaki wrote:
>>> On 2025/07/11 22:02, Paolo Abeni wrote:
>>>> @@ -158,7 +159,10 @@ struct VirtIOPCIProxy {
>>>>        uint32_t nvectors;
>>>>        uint32_t dfselect;
>>>>        uint32_t gfselect;
>>>> -    uint32_t guest_features[2];
>>>> +    union {
>>>> +        uint32_t guest_features[2];
>>>> +        uint32_t guest_features128[4];
>>>> +    };
>>>
>>> I don't see anything preventing you from directly extending guest_features.
>>
>> Uhmm... I have a vague memory of some interim revisions doing that and
>> failing miserably (but I have no log of the actual details). I'll try to
>> have another shot at it.
> 
> The VMSTATE_ARRAY() macro has explicit checks on the specified array
> matching exactly the specified array size. Using a single:
> 
> 	uint32_t guest_features[4];
> 
> variable, this statement
> 
> 	 VMSTATE_UINT32_ARRAY(guest_features, VirtIOPCIProxy, 2),
> 
> causes the following build error:
> 
> --
> include/migration/vmstate.h:259:48: error: invalid operands to binary -
> (have ‘uint32_t (*)[2]’ {aka ‘unsigned int (*)[2]’} and ‘uint32_t
> (*)[4]’ {aka ‘unsigned int (*)[4]’})
>    259 | #define type_check_array(t1,t2,n) ((t1(*)[n])0 - (t2*)0)
>        |                                                ^
> include/migration/vmstate.h:282:6: note: in expansion of macro
> ‘type_check_array’
>    282 |      type_check_array(_type, typeof_field(_state, _field), _num))
>        |      ^~~~~~~~~~~~~~~~
> include/migration/vmstate.h:373:19: note: in expansion of macro
> ‘vmstate_offset_array’
>    373 |     .offset     = vmstate_offset_array(_state, _field, _type,
> _num), \
>        |                   ^~~~~~~~~~~~~~~~~~~~
> include/migration/vmstate.h:1090:5: note: in expansion of macro
> ‘VMSTATE_ARRAY’
>   1090 |     VMSTATE_ARRAY(_f, _s, _n, _v, vmstate_info_uint32, uint32_t)
>        |     ^~~~~~~~~~~~~
> include/migration/vmstate.h:1096:5: note: in expansion of macro
> ‘VMSTATE_UINT32_ARRAY_V’
>   1096 |     VMSTATE_UINT32_ARRAY_V(_f, _s, _n, 0)
>        |     ^~~~~~~~~~~~~~~~~~~~~~
> ../hw/virtio/virtio-pci.c:168:9: note: in expansion of macro
> ‘VMSTATE_UINT32_ARRAY’
>    168 |         VMSTATE_UINT32_ARRAY(guest_features, VirtIOPCIProxy, 2),
>        |         ^~~~~~~~~~~~~~~~~~~~
> --
> 
> I'll keep the union here.
I think you can use VMSTATE_UINT32_SUB_ARRAY().

Regards,
Akihiko Odaki


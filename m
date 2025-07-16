Return-Path: <kvm+bounces-52597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6622B0715E
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 11:14:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EC4F17FB7D
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 09:14:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05E922F0028;
	Wed, 16 Jul 2025 09:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mn7tNt6F"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725B22882D2
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 09:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752657282; cv=none; b=FUga7QYf4SjMvxquLW5eXGNKIe0+IRLypv3CKDZD7e3to6PXJijTz7tLcCF0jX8U+gO6SGi0xF0EUX8WV9LApI+SRHhVfy2jQMVdb2QJ+t8tVE2wHAyll9a9ut56aogtVzgIY4zzlgg31GKWPm+cDKh2dV7b2yDtVa2hiarie1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752657282; c=relaxed/simple;
	bh=tr16mTIhIH3ENf6ROXjejIZeBsuEgu355E+Wzb+ezGM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=K6hiBPqt0PhpfUexgR9XFbOkZ/nswPibyC6PG1OHExJYgOZIiNnL9B4Oc7Fj6sJi9mjVvLj0SytrIM9KwFi87cm8HD0LNN0473P++KL5A8M2rt1oMXjBbgwO5tH1BUSATNSFimO8r5qmVmDGpYxFA0HEwUKEuETWwlX+72gvR0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mn7tNt6F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752657279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S3590grheIM7SBHSSWdWWCgMSUC8TLviiTt0ycoGy/w=;
	b=Mn7tNt6FUKQk64irubGo4KqmU2i+NYAxee7YZ/8PRITMqo+2AoIkmQOdM7HbPypabeCqfW
	woQonlbPJuTh85Dw9qcowH8wRLpyJn5O8FbrE2lBz89D1pDe66MyaCy2msBsrdAq6Kw0ZB
	EJ8QdeYLprdjIY8sGcQfjzm5NY0nhg0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-TQ2ybFiDMZSQ8m5VWA_vgQ-1; Wed, 16 Jul 2025 05:14:37 -0400
X-MC-Unique: TQ2ybFiDMZSQ8m5VWA_vgQ-1
X-Mimecast-MFC-AGG-ID: TQ2ybFiDMZSQ8m5VWA_vgQ_1752657277
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-455f79a2a16so40136735e9.2
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 02:14:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752657277; x=1753262077;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S3590grheIM7SBHSSWdWWCgMSUC8TLviiTt0ycoGy/w=;
        b=E4eBYsO1DCu8M7lrVJxmRrm7ceDnDz/GnzmR7gYrDF+KnB9RY20mklGz/AclzILrN1
         KVwGFpiC2/4mEuFHba3Ax6AiZ62cGqNfsrSG32iu8wSZdUG8LlLh6y+P0ITHBs1EZ0ZI
         IeSgCUc/k6YI8G/BfrjPtn8fTRGalzlcNCJzkdI48k8c7B9U8LX6buCFce/LjTtde/9Q
         3UNQjnX9mqSPyqBnRlFvdegMGEOcuoTKP88Z78WgCqaE0lBYyiwj5TI8iDwf/KjB7tjk
         Ja+TYfl3+6/Y52A5iM5GOtHwa3RZH0jSUCkZ+WC6qc7IpOpph/WOqJv161NSjKEGzOaZ
         VOTQ==
X-Forwarded-Encrypted: i=1; AJvYcCXnuAKv4ObX2avfyfSKITtpnbB4MbJzpYOa0NEw2oOjcr6QOGLNLfEjcEccBvm9IGiluA0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwF2B8GV/VXSwoPDfLb2UxRlq97lGmo0maLU47kQO/zFkuv8HiG
	qMY6Aro2d95J2LsznthvrNudkJfKXSJpqLCOKSu/JrJXTA+Jgs9GChK2K6UW9wPN3iCbJq38m+p
	SIagWdaDnR6sLeBNM/yGlWafifyFbxo4qftRCv5dorTkI1KuR2LmxWA==
X-Gm-Gg: ASbGncv3rhAtdNERCnnv8i28dmi4IjR0k9R83jx9JQZ0Gcy4ARoKbk5mvf3IyAZqIos
	1YBN/VdOGVS0nQwDuCxq9Kmp88y/MxcSXghnfVhj2A1+FcOPDHfkyKucV8TxSLMDWNQXl+mTXgy
	S5uSlnzCUDUOvptHlWgBwG4PxoOiLeAzHqtvAZUhIl+56i9GmFIE2Y1ZS0FpDl4eYMN92VNCFWH
	12sD9HJjkG526o4E+BP6WCZ/4RtubLc8EplnWm9cWl0kGFZ8mg7jf9Js0sxUD+UvcwoPY40CyWj
	FfCToJ8TdoovIt7TV+m/yotztGgoEBPKIJzV6k4Ek31vbUvMxQNOWRgJQJxE65OEbVTzI9IITE2
	HBIAsxKqH3xc=
X-Received: by 2002:a05:600c:1ca9:b0:456:1ab0:d56d with SMTP id 5b1f17b1804b1-4562e039c45mr17589725e9.7.1752657276700;
        Wed, 16 Jul 2025 02:14:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGybf5a1t+wptrgD61Zw0KBNta+k6d7nSI6sfxYjqw/ky3lpLxQlL6Xe7+rGINNZk79IybFlg==
X-Received: by 2002:a05:600c:1ca9:b0:456:1ab0:d56d with SMTP id 5b1f17b1804b1-4562e039c45mr17589355e9.7.1752657276269;
        Wed, 16 Jul 2025 02:14:36 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e10:4d59:d956:544f:d65c? ([2a0d:3344:2712:7e10:4d59:d956:544f:d65c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4562e7f2f28sm15022205e9.2.2025.07.16.02.14.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 02:14:35 -0700 (PDT)
Message-ID: <59102a09-1e25-4c14-a681-7170c87df501@redhat.com>
Date: Wed, 16 Jul 2025 11:14:34 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 06/13] virtio-pci: implement support for extended
 features
From: Paolo Abeni <pabeni@redhat.com>
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Dmitry Fleytman <dmitry.fleytman@gmail.com>, Jason Wang
 <jasowang@redhat.com>, Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
 Luigi Rizzo <lrizzo@google.com>, Giuseppe Lettieri
 <g.lettieri@iet.unipi.it>, Vincenzo Maffione <v.maffione@gmail.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 kvm@vger.kernel.org
References: <cover.1752229731.git.pabeni@redhat.com>
 <eb1aa9c8442d9b482b5c84fdca54b92c8a824495.1752229731.git.pabeni@redhat.com>
 <8af39b78-a95d-4093-b68c-20b556860a09@rsg.ci.i.u-tokyo.ac.jp>
 <f1381483-a507-4420-a0c9-52bf8131e6e6@redhat.com>
Content-Language: en-US
In-Reply-To: <f1381483-a507-4420-a0c9-52bf8131e6e6@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 7/15/25 6:21 PM, Paolo Abeni wrote:
> On 7/15/25 9:42 AM, Akihiko Odaki wrote:
>> On 2025/07/11 22:02, Paolo Abeni wrote:
>>> @@ -158,7 +159,10 @@ struct VirtIOPCIProxy {
>>>       uint32_t nvectors;
>>>       uint32_t dfselect;
>>>       uint32_t gfselect;
>>> -    uint32_t guest_features[2];
>>> +    union {
>>> +        uint32_t guest_features[2];
>>> +        uint32_t guest_features128[4];
>>> +    };
>>
>> I don't see anything preventing you from directly extending guest_features.
> 
> Uhmm... I have a vague memory of some interim revisions doing that and
> failing miserably (but I have no log of the actual details). I'll try to
> have another shot at it.

The VMSTATE_ARRAY() macro has explicit checks on the specified array
matching exactly the specified array size. Using a single:

	uint32_t guest_features[4];

variable, this statement

	 VMSTATE_UINT32_ARRAY(guest_features, VirtIOPCIProxy, 2),

causes the following build error:

--
include/migration/vmstate.h:259:48: error: invalid operands to binary -
(have ‘uint32_t (*)[2]’ {aka ‘unsigned int (*)[2]’} and ‘uint32_t
(*)[4]’ {aka ‘unsigned int (*)[4]’})
  259 | #define type_check_array(t1,t2,n) ((t1(*)[n])0 - (t2*)0)
      |                                                ^
include/migration/vmstate.h:282:6: note: in expansion of macro
‘type_check_array’
  282 |      type_check_array(_type, typeof_field(_state, _field), _num))
      |      ^~~~~~~~~~~~~~~~
include/migration/vmstate.h:373:19: note: in expansion of macro
‘vmstate_offset_array’
  373 |     .offset     = vmstate_offset_array(_state, _field, _type,
_num), \
      |                   ^~~~~~~~~~~~~~~~~~~~
include/migration/vmstate.h:1090:5: note: in expansion of macro
‘VMSTATE_ARRAY’
 1090 |     VMSTATE_ARRAY(_f, _s, _n, _v, vmstate_info_uint32, uint32_t)
      |     ^~~~~~~~~~~~~
include/migration/vmstate.h:1096:5: note: in expansion of macro
‘VMSTATE_UINT32_ARRAY_V’
 1096 |     VMSTATE_UINT32_ARRAY_V(_f, _s, _n, 0)
      |     ^~~~~~~~~~~~~~~~~~~~~~
../hw/virtio/virtio-pci.c:168:9: note: in expansion of macro
‘VMSTATE_UINT32_ARRAY’
  168 |         VMSTATE_UINT32_ARRAY(guest_features, VirtIOPCIProxy, 2),
      |         ^~~~~~~~~~~~~~~~~~~~
--

I'll keep the union here.

Thanks,

Paolo



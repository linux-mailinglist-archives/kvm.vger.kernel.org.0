Return-Path: <kvm+bounces-37254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 71BCDA278C4
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 18:42:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDEB9165D64
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 17:42:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 957CC21638F;
	Tue,  4 Feb 2025 17:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OKqUu500"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22603213E82
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 17:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738690953; cv=none; b=DrQbR+qGS+qO8UJQeyZTVV0VLjB9JSlfrbWH8AoRh4j9OJ+Bv/uGZKv7xSo3DPWj0NOugP/xEklvcmOoMsHN9YAi5Rhln3JU5wfUZFdImNvz3XuqkKCv45laxX7lvdJH5YYOGJphkMUmrxAZwfsGy5kIIB6lgNy9KFH9WORBM3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738690953; c=relaxed/simple;
	bh=TE2nvjzS9waRQRDvTmhX5eCI5Y3S1yUETwOVB+l2HRY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mYRF4YpvHoG3iDBHpGLGr8R+b4LtC0/8lTQaP6fF8OwpL9m6czpxv12eWMx0pkWR9Cx9E+NLZgIjcdJpDAoHxle/EhqMITOQzPJyj5dNbG1jkN89bMAjM5+ejq4QtpZ9NRcxcPqT6eWeQp4NKh1NkX7kWp+OGI4KfYkLv/YIdJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OKqUu500; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738690950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6xvLMBbIJRGPQ6vbqTTrPD/v72AS7GvH4rIHfkZKoNw=;
	b=OKqUu500ApJ9lC+1b3zLtdWp4enKK48UUL0u01S7BntIEi8rg/Y5k3+9kpAULILv1VOFI0
	OllPTX3L8B5XJUL+wD0KiZtobOy6UV3yTh271D+YNeip/N+pfxYMAxRnxBGtYcTjhmeiuw
	ZgENUaCP2JVkIlaVRtRlrnEI5GRzlDY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-nZ0GuY0VNeGB6HP0fuhW8w-1; Tue, 04 Feb 2025 12:42:28 -0500
X-MC-Unique: nZ0GuY0VNeGB6HP0fuhW8w-1
X-Mimecast-MFC-AGG-ID: nZ0GuY0VNeGB6HP0fuhW8w
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-38da839b458so520535f8f.2
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 09:42:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738690947; x=1739295747;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6xvLMBbIJRGPQ6vbqTTrPD/v72AS7GvH4rIHfkZKoNw=;
        b=SfraCKFfUCHOKY/oPJmqbinw35KaCV3m7/aQzX+iAW42RFLb2oKzHemNkPjZ6KTYeL
         vq/j2CfPLj6i0onZWwVVLovIEiAzpoifo1okAqzu1dpJukLtBEegnSA8yqClCSKzhJqf
         8WEtqPdW90qEfB5LEI9Bc4sd3q91h/hdyqgIQyiAXPRFBHi/Zbvy2PN9X+tgEEytGDvF
         qV3/ICVhdj+Mmhys3NkLWjp9y6SmD6af5KsmWfKTFSM/ywR7M5jfAsy+ifrG+LdkPL9r
         8ImctGxX1dHCXfIeqiqwKnGkRDDKYJhGq+eol2AXhpQCnJxHLCkPtJsZXMXmIQGlPEyb
         8bHA==
X-Gm-Message-State: AOJu0YzI7OfFWaJs71SfjwVHyMCXm5Z+Rid204Xlgmxeje0xJ/RzHWqF
	8g1ZATj/ig51Un4cJ3VgBkM3fO6NZ+1H92DAwgWB+Aa0wb8y8yox3qDmihbHWUdyPna+YlRlCNp
	iWFJN6e11786cHmzzZvx/4B0YR2eaiBxywIZb+4XjnDRfKftERw==
X-Gm-Gg: ASbGncukEAKCFe/ILYb7fePh+fr+Kc77bGTsKnXvynfcM6HKX7jjQ02G2SdVrti7XAA
	/XQCjXiklqL8iyWpHEtH3hUhqOKT1MwstSrADNh+BcHIyp0mp4LFJKBWpffnfyA//r2pBdMAVhr
	JXAXSahGXnbvbx5uPzIUyi59vwR/q0Hv5T3G8dYEwNciiTSgoGMnvarAwLeS5GfTcCZOvSTMStk
	0po071lcgo0uC2kFuCbEjcqwzxN6uW1nbxXtSTuwODVGoyRhMoUhVlGfK1zl9cmq3ZbV9Fyg8jU
	HXmYe7ICTmUHVygp5Atia/qYyKrMNxK1AUjzqFxs3/q/RI0rgzM4EApU6IYMqGhaYW7H2M+VZVJ
	swMPoTVnJG65i0cbX1uNKTyhclL8=
X-Received: by 2002:a05:6000:1843:b0:38c:5d42:152b with SMTP id ffacd0b85a97d-38c5d421959mr17554952f8f.54.1738690947621;
        Tue, 04 Feb 2025 09:42:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IELvjoW4MAsrHMrqVA+MWQOCPc8cn37hi3pvEa8AmqT2Q9JgqOf2fdpvq5Mt4lYJjWB3ZC72A==
X-Received: by 2002:a05:6000:1843:b0:38c:5d42:152b with SMTP id ffacd0b85a97d-38c5d421959mr17554942f8f.54.1738690947283;
        Tue, 04 Feb 2025 09:42:27 -0800 (PST)
Received: from ?IPV6:2003:cb:c70a:300:3ae1:c3c0:cef:8413? (p200300cbc70a03003ae1c3c00cef8413.dip0.t-ipconnect.de. [2003:cb:c70a:300:3ae1:c3c0:cef:8413])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38db15f7712sm899214f8f.49.2025.02.04.09.42.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2025 09:42:26 -0800 (PST)
Message-ID: <6356ce2f-0e41-4d6d-a019-5164af502de6@redhat.com>
Date: Tue, 4 Feb 2025 18:42:24 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 4/6] numa: Introduce and use ram_block_notify_remap()
To: Peter Xu <peterx@redhat.com>, =?UTF-8?Q?=E2=80=9CWilliam_Roche?=
 <william.roche@oracle.com>
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
 pbonzini@redhat.com, richard.henderson@linaro.org, philmd@linaro.org,
 peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
 eduardo@habkost.net, marcel.apfelbaum@gmail.com, wangyanan55@huawei.com,
 zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <20250201095726.3768796-1-william.roche@oracle.com>
 <20250201095726.3768796-5-william.roche@oracle.com>
 <Z6JLmG8srpk9_3Jn@x1.local>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Z6JLmG8srpk9_3Jn@x1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 04.02.25 18:17, Peter Xu wrote:
> On Sat, Feb 01, 2025 at 09:57:24AM +0000, “William Roche wrote:
>> From: David Hildenbrand <david@redhat.com>
>>
>> Notify registered listeners about the remap at the end of
>> qemu_ram_remap() so e.g., a memory backend can re-apply its
>> settings correctly.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: William Roche <william.roche@oracle.com>
> 
> IIUC logically speaking we don't need a global remap notifier - here a
> per-ramblock notifier looks more reasonable, like RAMBlock.resized().

Right. Note that qemu_ram_resize() also triggers global notifiers.

> It'll change the notify path from O(N**2) to O(N).  After all, backend1's
> notifier won't care other ramblock's remap() events but only itself's.
> 
> It's not a huge deal as I expect we don't have a huge amount of ramblocks,
> but looks like this series will miss the recent pull anyway..  so let me
> comment as so on this one for consideration when respin.

... and ram remap during reboot is not particularly the fast path we 
care about (or should be caring about).

> 
> We could also merge partial of the series to fix hugetlb poisoning first,
> as this one looks like can be separately done too.

hugetlb frequently uses preallocation, and the remaining patches in this 
series make sure preallocation after remapping happens.

-- 
Cheers,

David / dhildenb



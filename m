Return-Path: <kvm+bounces-35385-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F08FFA10859
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 15:02:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 78490188937D
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 14:02:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E4FF13B7A1;
	Tue, 14 Jan 2025 14:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NEOm61hb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAAE45C14
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 14:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736863358; cv=none; b=CQ6dcOow3U4DzXAUOp+ldW/4iu5qQOXoS5EfyD+nwRn0jlrQsKdNPYLDDrwUAGRsCYhDBzboMCEJH26pFZwO0CK1EKk9b+RfAqHWpXqs4e7d3yTE0B/tJ0rpbVe8N8pCE6nZot1/Ihj7P5CiQfM2GRC3hgk5VmS0f1Jf/pfCQfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736863358; c=relaxed/simple;
	bh=cVG7aZHSYkUvbFYkrUPZqp+vYUCgwG+DY3jooVGkMII=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ucK+aZpYXxbftziuxzVpqv/Yzsn5DuGyHBXesf2A3qUYnTg6sM4cpeejFbDQUWuzyOmxi97V1PIj6LX6I/KJVuLsppH7RAkIhp9bhzkRPzUROw2kWIrqEEw9oZxk+cvu0Zrvii30L1fWMhbh/0J4tGi/xlcugGRdcC1nUA4jnPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NEOm61hb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736863356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RpUZ+GGieafLel0Gxe4KEIbQV4ju5WGCHcCJH31DYa0=;
	b=NEOm61hbiKJ3fAI2LGn86T8irER8FCL2IV4yxh1RCv1d/uqQJcI7EgGRheZwYkXTXTf8O0
	MhVt5k4MB88PfhupfyQAhvqbetUZ+BvWMNH9bfCzJwIRVMV+NuTIhFMA++JimUq58x4VZU
	I0bVoUFxspG9WI+69b7+cJ0GODOZ5UI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-241-PvsVDxylPlSc8_LqbjFv9w-1; Tue, 14 Jan 2025 09:02:31 -0500
X-MC-Unique: PvsVDxylPlSc8_LqbjFv9w-1
X-Mimecast-MFC-AGG-ID: PvsVDxylPlSc8_LqbjFv9w
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4361ac607b6so42547505e9.0
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 06:02:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736863351; x=1737468151;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RpUZ+GGieafLel0Gxe4KEIbQV4ju5WGCHcCJH31DYa0=;
        b=vjHRfWNlNb3luWy7lrJHY06iTeMNa12lKvj0ekpMJFY38ESFA98BLPPYhQcg1AVS1w
         ja3LkwJDBTAY+LFvQCKuIRqKPRF53kzag30U+ynyaoPsrJHMOI29nwvwZs1+GFW2Mept
         u8Zsdiwno8nDLnFfaUTJvOK31edlXbur8M7h6gLuqouD6SJXB6rvcxuJQ76iWI0PpPY4
         iOSRbt978tJ6VPMwi5SZP1K8z/k0adqB0bNwwl6dw/hOk4ViOtUFdO9pYiM++YBAXHL4
         OFisiiqsZPCnpvVC8kR9JfUK1SV1aHus+UhXD6aoYkN43j5iIban66UQ7e5E5rdZE3Uz
         FFcA==
X-Forwarded-Encrypted: i=1; AJvYcCXHEDaaFHv5+T7cFDplmPn3xTw3hrChJ5NjeWmLPEoyV4O+n6R+88kvxrW5LaYI7ptCR6A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgfoCzAqoitWuokM9c1iX7QBKAS5Q+/Dx7ygJ/WAYJd2vBEH2Z
	yiVIt9AfyNinzOlxrRDOJkpyZbeP8H4Gonl+6WbyGRqJhY16w0Iqn8S1vQyVDxwohmP9cpDIQWu
	PlKQ1/b/mWvFO3ZOw8HzBHa0C9x1xIPOLhPSxgFKZFc9uoPmnLQ==
X-Gm-Gg: ASbGncvv1QxyukgITLZMY4DygILrFCJLVp1syaygTR6yMsJDz433qI5nZAVfcP6WKVw
	S7D//Um05k0gHSTEGHL8ozCgEV+21NXahE7j6Xj8Wg0TPlr2MfPDGxbSER544UxOxtORoxqsSSN
	t9kmFC/9MIuDtuUQjbHGYbLtIejeyuUUPvbbxGjAcpXesUz8aGE0E7YTpNITou+i7KLZoF1UfW2
	n5F522hX/XKiFEL050jjLQkLOxlMyq693FwTinUbKmFk59OlHQn1Y2iumF4kr4sliPmcG8pbFCM
	ZwLnE8+SkMesJUKHx8JdVDHDujmSSMqucrgvF77LOz/JeQrJ7FnBn2wS/Q9jR2rU0nXxNcCIGxq
	VULrJqMJM
X-Received: by 2002:a05:6000:2aa:b0:385:fa26:f0d9 with SMTP id ffacd0b85a97d-38a87086c15mr23569733f8f.0.1736863350579;
        Tue, 14 Jan 2025 06:02:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFwJyCbLnWc+0oHQBOQk9bvC/zhSOLD2Js2QRVvPEKyvrbmCH2hAWnw1bqeczeP7Zg7ICvkiA==
X-Received: by 2002:a05:6000:2aa:b0:385:fa26:f0d9 with SMTP id ffacd0b85a97d-38a87086c15mr23569627f8f.0.1736863349827;
        Tue, 14 Jan 2025 06:02:29 -0800 (PST)
Received: from ?IPV6:2003:cb:c738:3100:8133:26cf:7877:94aa? (p200300cbc7383100813326cf787794aa.dip0.t-ipconnect.de. [2003:cb:c738:3100:8133:26cf:7877:94aa])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e38378csm14828197f8f.25.2025.01.14.06.02.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 06:02:29 -0800 (PST)
Message-ID: <2a79643f-1d9e-4122-8932-954743a18c21@redhat.com>
Date: Tue, 14 Jan 2025 15:02:26 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/6] system/physmem: handle hugetlb correctly in
 qemu_ram_remap()
To: =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>,
 kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20250110211405.2284121-1-william.roche@oracle.com>
 <20250110211405.2284121-2-william.roche@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250110211405.2284121-2-william.roche@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10.01.25 22:14, “William Roche wrote:
> From: William Roche <william.roche@oracle.com>
> 
> The list of hwpoison pages used to remap the memory on reset
> is based on the backend real page size. When dealing with
> hugepages, we create a single entry for the entire page.
> 
> To correctly handle hugetlb, we must mmap(MAP_FIXED) a complete
> hugetlb page; hugetlb pages cannot be partially mapped.
> 
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: William Roche <william.roche@oracle.com>
> ---

See my comments to v4 version and my patch proposal.

-- 
Cheers,

David / dhildenb



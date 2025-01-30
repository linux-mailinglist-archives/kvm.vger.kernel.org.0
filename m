Return-Path: <kvm+bounces-36919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 01CA3A22B4A
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 11:07:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A7003ABA50
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2025 10:05:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 357AE1B87ED;
	Thu, 30 Jan 2025 10:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V3hyByea"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7718619C561
	for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 10:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738231541; cv=none; b=C68U3h7K/1ZbSLC19gPtnqyrk15BFIzHiUsjNeNvLYqN4vxtCXlOB6MxWV8tyCNVgH2pnCGBR5ggtXDvenSi+Hpjw1DUvSiWOcPtucyP5ChYlQs097Ah8k0562zGxP4bBjvB4UmIwm0wEAV4S4zBCT4xuiOGLiMlrA8dz0fjKMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738231541; c=relaxed/simple;
	bh=f09orQzbzT6R/IN9wLvbBl2KUDn4pYD8bZ6lxNzTYLE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nifig6qcOL675r+SIx/UE61RuNQQjgpr++jKEMf+mJxvbj9+qUTMPwOCLHnt0kun87E7Wnw6QmqyeqasAAIwru53AnQWZfkVBejYWTfIgq1aCY2ert7ygHoo51cnLgzsWAYihvVrmlrLLohUAXT3YbQ7bwNx9raZs6TApdAjfJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V3hyByea; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738231538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ej34TRKzCk3u66g7ZUBbMIDJC/Cfgozb+JXmH9zPuFY=;
	b=V3hyByeaUEcUYQtbTepP+/KVmDjpm0gpbfb2yuRzabLXhpVn5aM7g8go4XZrBxtJJCOOho
	1emTjldytYJDXQBO54ze/JCNMo2fcT0kyHqACd6eDp//G/fy5cCgVlW34R0oIuIJqAwJpK
	yasshRuV3/MLraisJFAayFodo2byN2M=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-SL0YsquoPD6gBGiUraxWXg-1; Thu, 30 Jan 2025 05:05:36 -0500
X-MC-Unique: SL0YsquoPD6gBGiUraxWXg-1
X-Mimecast-MFC-AGG-ID: SL0YsquoPD6gBGiUraxWXg
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-436723db6c4so3802595e9.3
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2025 02:05:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738231535; x=1738836335;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ej34TRKzCk3u66g7ZUBbMIDJC/Cfgozb+JXmH9zPuFY=;
        b=qsAZ43ZUzxrZDbTik+n8K2ykVcOyoXKpaZt2RbKBJlzNhnzau1wHbtDyZFzHYb8UBZ
         9FBNpqRjbVKA1Rlx+Q5VbEuliC47H0TwDP+NkdbwZ1mj2MRsmUrWYJhHdJZIKAB3cXRn
         SrPZ6uhsZFA7OYhno3TajDKXsN7isOFnzd2ibbf5Jsa+/YpP01nBzWZUqlxYQTvawXDA
         sja5ZwxJmKbLs/XSHqRKA81IgM0gcfuUzxnSgYWBDKSIPgbT4I2dsXGcxSG34vL6LIVS
         DCiIlwaCYaXde0FVPcwHtkAGdeOdBOoxPMmERRHWES6XAXRWEruPxq4OWdjG4tWH8Vjy
         4QKw==
X-Forwarded-Encrypted: i=1; AJvYcCUl32PNhQ9DF3xs8YdkChcJ9hMwl8uqG/G1B/uxgeWBLcU5BspsdSy3GIzoxj8Ygnc2l00=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqNIGX0N8squXSncKJ/rFeaYpHRLaZuHlq9MWDQe84L4iP1eRC
	z3KUqFNSAdqaBZh5Ewf7SF7Pp72ssKh8G/cimIFYo3+/5D3V5ZgIikaJ5sPLp2cFYLOnaNmbOxz
	hO6fzwJIczH2zlfW61zEifLoUy5Gzph5BTCzOMPvTGAxRomiQfQ==
X-Gm-Gg: ASbGncthU9Iyn7GZ9cFyfFUr+UCkvY23T7aucoVQ83CCLfCe5gG+7963inrB86RLzVL
	UVjO99EIhL2qItnWItFoUPuT6qTGfAhFdNohtIb4V2PWGaBw2VNRMTSX3PFLnpogbiJdN1WtB08
	XlPqvDQSfae0YIx2aGxqBrz5R+c7o8m7/tWcOIHtuSz7mSHFDRVudvPjo1Zt6+kgBXmvCH+L9rU
	opdTfPcMd9yaiRx0722tD4DBuq+N4QoJo05Q3Aqc/q5LkdKG/dzlxA1b7Krw/WdLoReK+84X44q
	ApQwVzC/zHsPnIzLB69OWN337/My7G8WWVeF2WTj+KdI
X-Received: by 2002:a05:600c:3306:b0:435:294:f1c8 with SMTP id 5b1f17b1804b1-438e018288dmr30450575e9.28.1738231535594;
        Thu, 30 Jan 2025 02:05:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFgp2XICVOdE2kJIWFsVmaEZlHa9/HKHWxrRKY9p1icaAeHtZ46p62yKdSY9hlFA7LqmysKkQ==
X-Received: by 2002:a05:600c:3306:b0:435:294:f1c8 with SMTP id 5b1f17b1804b1-438e018288dmr30450285e9.28.1738231535217;
        Thu, 30 Jan 2025 02:05:35 -0800 (PST)
Received: from ?IPV6:2a01:599:904:96e0:a245:aa9f:6c57:eb41? ([2a01:599:904:96e0:a245:aa9f:6c57:eb41])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438e245f49dsm17378355e9.35.2025.01.30.02.05.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2025 02:05:34 -0800 (PST)
Message-ID: <05295422-6baf-4f7e-9f02-d2bd9344b7e7@redhat.com>
Date: Thu, 30 Jan 2025 11:05:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/6] system/physmem: handle hugetlb correctly in
 qemu_ram_remap()
To: =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>,
 kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <20250127213107.3454680-1-william.roche@oracle.com>
 <20250127213107.3454680-2-william.roche@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250127213107.3454680-2-william.roche@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 27.01.25 22:31, “William Roche wrote:
> From: William Roche <william.roche@oracle.com>
> 
> The list of hwpoison pages used to remap the memory on reset
> is based on the backend real page size.
> To correctly handle hugetlb, we must mmap(MAP_FIXED) a complete
> hugetlb page; hugetlb pages cannot be partially mapped.
> 
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: William Roche <william.roche@oracle.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb



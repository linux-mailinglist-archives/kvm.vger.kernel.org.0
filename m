Return-Path: <kvm+bounces-36564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C68CFA1BBF9
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 19:17:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B1BD188EF27
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 18:17:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 950421D8DEE;
	Fri, 24 Jan 2025 18:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gj/HkfRg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C96519005D
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 18:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737742644; cv=none; b=KE5f6qmmy8df6H4Z+iX7tdCc2PUQjcV7pFBgsZrk0TCPZUkqggPKh2rBXcGYA186lkA9fxqA3gmJZaBInliJy1MGUS9eIeGd2e0JlzCQ9fCW0qTRU2D0eNcL22ziCA8+8ktC9yE1ONZsqsaSmheD74avxb+uycxi5O9AvNkqd5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737742644; c=relaxed/simple;
	bh=ch/TrsAHKfwOqeCmBsWToXZmnm7nHKTtnxx9OLkl8nQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M5viEgzt32Qm6eAzzFjY/m/WXSI7HpPE5XuQkqZgDeKMVmCIK6pA5Hqdd2o4894SoGAuBrErticEHRnuL7iUF7HXiweJXpulPY9HV8e+0g56jruYZQDkbUA+rTkFainSD6qbacJObZBp4aeQiW1dIMoMoWjeBXpIcC+aE5u82oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gj/HkfRg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737742642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DyFagDZcQZMbR6uxs/thUKDbW6WymRHjrUfU8/GiIzA=;
	b=Gj/HkfRgzsZ5pOdijSkk58Z9qYd4scRhk1H7y1cLPoYASbK4R7l8TppG9mSg6/a8xO+pIs
	Y4EbK/hxOyWp4Q4Oo2H6cpsc0xUAIrcmDZMZveSZXKpO1xxu2dL8CVJqpH4aNvYmk+JYAb
	ATLJPrGVnSXr5sIaI2ayowElQTrEv+Y=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-341-wP6i1Nz6O1SeDaM1QaatYg-1; Fri, 24 Jan 2025 13:17:19 -0500
X-MC-Unique: wP6i1Nz6O1SeDaM1QaatYg-1
X-Mimecast-MFC-AGG-ID: wP6i1Nz6O1SeDaM1QaatYg
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4362153dcd6so11849135e9.2
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 10:17:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737742639; x=1738347439;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DyFagDZcQZMbR6uxs/thUKDbW6WymRHjrUfU8/GiIzA=;
        b=mv4w3u39kRxxObQ0NtFA/4OBKJOCCqOmcDwWdKwaTGEVfBRWh4bM264RMBbNoUL28d
         h4TPDO0fdKjypbrhEtrvmZZpraXVPO2gght9SYRFo4Wgmnbt4obWJdZu4x18TeB/C9UH
         5IPBNOFbCqMkI+lPGMJ7tOGtdMC4+r+g88ftywqikIogNlkSL+k1J69m9sQS9H/SdU7i
         phjNIKDq6w6JpsFfZwCgDHnhELN/tyJhkTiCmpKCk+r7kXtK8Zx5Y9vKNmhZV/fJB44+
         /u/lT0HsDxqjDwFw5MvI8bOCYoI10/4CFuEYlVHlcj/QYc9aKO4+VlLCmXJcNMPabGaW
         liiA==
X-Forwarded-Encrypted: i=1; AJvYcCVPUs3mpfHtETseqvqDuvdFg7ZJVSnMcynQmr/fyZnVeLlwjApARagDIjoqc4jGPJH9LsE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxProe13SOnSL60MLbUigm9PEdPM25v3BQaN/t3Td4HbCF/l7L2
	VYb6g3mEiIJlYSQSnuHd8ct52RPD3MVjxV18o/UPu+XyTD6wygcAAgFCsE+LU6tbdDq4i/B3mDv
	Sgg2Ql3IXbRpTB2/1zfcaaTYNBA55LDQG1iLjafNtNc9FYVNBng==
X-Gm-Gg: ASbGncsB8YUy6ZDEtODt8aOPgb6PeUAlxZyQN1tzCHaWFepfRMmRpGcgagvPkGf/qXK
	FQ+otL9FxagWEgYkHV1QrQE+4kdN9LzbV+8EjmNeze3ElfwNSEa0uwJbVT2pDnk8DgUm9PcIPpH
	JinEArzQXjt6IVi/u/rJ9KA+rtp2H+Aq8wo4K8oHJsEONQjeYaQWUF7QBTYTtOD/cf6yErALzHV
	kxwu+IrpwsoxqOT+1+/s6j99ucphdjNkAK/BC9jw3HoUOfBaBMVcKsGdDhkxquQYKTSAkypiaWv
	T8KADK7aOwRyBESqRgE8GXE=
X-Received: by 2002:a05:600c:8717:b0:434:fbcd:1382 with SMTP id 5b1f17b1804b1-438913ca6acmr334745065e9.11.1737742638824;
        Fri, 24 Jan 2025 10:17:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEeY5fPkyvOEFiSXqLivrGFnJ22mJrft/87lA+ewPdJOl08/pF0fqRIg82oyAiA0JtM75Samg==
X-Received: by 2002:a05:600c:8717:b0:434:fbcd:1382 with SMTP id 5b1f17b1804b1-438913ca6acmr334744805e9.11.1737742638475;
        Fri, 24 Jan 2025 10:17:18 -0800 (PST)
Received: from [192.168.3.141] (p4ff2332e.dip0.t-ipconnect.de. [79.242.51.46])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438bd575468sm34272335e9.39.2025.01.24.10.17.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2025 10:17:17 -0800 (PST)
Message-ID: <3d81fc15-912e-45f7-a60c-7a3c1e86f59f@redhat.com>
Date: Fri, 24 Jan 2025 19:17:15 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
To: Peter Xu <peterx@redhat.com>, Xu Yilun <yilun.xu@linux.intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>, Chenyi Qiang
 <chenyi.qiang@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <2b2730f3-6e1a-4def-b126-078cf6249759@amd.com>
 <Z462F1Dwm6cUdCcy@x1n> <ZnmfUelBs3Cm0ZHd@yilunxu-OptiPlex-7050>
 <Z4-6u5_9NChu_KZq@x1n> <95a14f7d-4782-40b3-a55d-7cf67b911bbe@amd.com>
 <Z5C9SzXxX7M1DBE3@yilunxu-OptiPlex-7050> <Z5EgFaWIyjIiOZnv@x1n>
 <Z5INAQjxyYhwyc+1@yilunxu-OptiPlex-7050> <Z5Jylb73kDJ6HTEZ@x1n>
 <Z5NhwW/IXaLfvjvb@yilunxu-OptiPlex-7050> <Z5O4BSCjlhhu4rrw@x1n>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <Z5O4BSCjlhhu4rrw@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> Definitely not suggesting to install an invalid pointer anywhere.  The
> mapped pointer will still be valid for gmem for example, but the fault
> isn't.  We need to differenciate two things (1) virtual address mapping,
> then (2) permission and accesses on the folios / pages of the mapping.
> Here I think it's okay if the host pointer is correctly mapped.
> 
> For your private MMIO use case, my question is if there's no host pointer
> to be mapped anyway, then what's the benefit to make the MR to be ram=on?
> Can we simply make it a normal IO memory region?  The only benefit of a
> ram=on MR is, IMHO, being able to be accessed as RAM-like.  If there's no
> host pointer at all, I don't yet understand how that helps private MMIO
> from working.

Same here.

-- 
Cheers,

David / dhildenb



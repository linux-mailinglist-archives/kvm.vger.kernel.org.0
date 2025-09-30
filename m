Return-Path: <kvm+bounces-59076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A314BBAB641
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 06:42:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52B281C338C
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 04:42:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AE1E24EF76;
	Tue, 30 Sep 2025 04:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NZcrNuND"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A936672617
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 04:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759207342; cv=none; b=P8/qatH9qNKKdu5vfp1tItugWHS4tIwgSN5SW5Krb6IGKwQNv7xKe/uPK1jPNeLtF0ZSx8DdYZWeg+rLBefQziuTPXkUMsp3JpilvDULzSG2BNl/HKU6yMYdGGzujBKPIlmeiundlHIQzywojUWzpy1YBhEfBWjbcrY94/UK2i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759207342; c=relaxed/simple;
	bh=bUEbHmAgV500zj4N1yrxbpg5atbryz28JlWOsu02ki4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nKYllVRdDewHJLbWq2nZpDkLSYdvJpYDSjNhU2oDkYPhCIbkoAN5Itf5aGKhdhHX5x1frcjyzIBAZESmvt467M8HxoCKnHvECc76S+YooP0KIfafP9gWUPP7YZ1LLasdCd4XEvUCFqnSGid/DHWPo2GXhYCCs2sPujEjjcHqxuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NZcrNuND; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759207339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tvxLjB/EsvBZ5htouvq/q3x83R6wXLK+5or1QrTnakw=;
	b=NZcrNuNDEV+RiCbVuGjddgcNeoRWmtrnQalgxte8aZZDS5gPkEefYEchJWGNDnIij1pL0m
	831tnulTVCoXPK/o73TeIApKtRUTTXsWKV93dekAyhC12aXGQPKZjEWPNkmAmKTzmtXiMJ
	QWOSnBXXFX9Ghpk1MueW081ZQygjecM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-A4efLaebOOCjU3i9JwAeYw-1; Tue, 30 Sep 2025 00:42:17 -0400
X-MC-Unique: A4efLaebOOCjU3i9JwAeYw-1
X-Mimecast-MFC-AGG-ID: A4efLaebOOCjU3i9JwAeYw_1759207337
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-b335fbe7c0dso652070766b.1
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 21:42:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759207336; x=1759812136;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tvxLjB/EsvBZ5htouvq/q3x83R6wXLK+5or1QrTnakw=;
        b=AMBzrGYCra3cCxYJAjfFQf7opBiU49bu0JKzufqyHGdGeuDv/GdkPwexabg3T1sEBH
         /cUY+IsO1i2sWRT5t2mSAd7HOWoERdrvyXsW7o5LAOSsZ4dNiSkAUOa0fcVNbyl/Q8pv
         ISjBS0kFO3hBJgAVHB+IMkWzqY4MdxHG8Rdfe8el2pivH8z5r3rudH864L7ERV3NP2Bf
         aShOCyiYGmo3pgWMGCxeDFaewuGS2L3BSroxg0GGOhbokx5ZVnNKxnSo1j6VLgP07XBN
         wdnp2UPxsytbzxXx86io/z+/89ThD3+nlDbq6Jp13ouDWwDznfrvY6MRTNNfZAdeeJ3Y
         JPOg==
X-Forwarded-Encrypted: i=1; AJvYcCUm7+dtK+IrX+4riZzMrP1O91VY7BVgkEUwp8sUy89X6M97gR3JKvK+5oh7xjgPMSBRM8Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBOPr8aWWgSL1EFfC27V1tJeP1iRULRAXNLkPYX7hrdb636O5r
	J3+Ngj9/zepXoWIXi1iVA4B81xmxrvbSATcGrhRlV/WFHb2apXRsNkZpdgPX2CLXFpKCwiG8lwM
	uELzDaYOH9Ugi7X6anZiUoSRAp3z5SGSm4ELF6EcK261E3kBurslX8A==
X-Gm-Gg: ASbGncuLz0Vcsrchr4TIWplAvQj6t2Ait8KWdwAjDcAdd4AUWk0yeNAiJTbrJZig+LY
	SeP803p79yaLxPo8XIx/TEjiflmXTbuUEGw+Ylrn0+EkbHpLwKcyrHLzA/c94/W+/7FHZloHJB5
	w5vileV8XJWuBWbWn2iI2ZVGyM2m5FmXfqj9VZkuyPQ6O6dy3CUlZkjGXViTUGCARHJbj6P2cPm
	8JNhNciIEbBqMJUYdnokqwo0OqSK9ifApkeubJ6yihh4aYXnP9llWNoFvrLPAki3UrRhZeBl+53
	bNDEFQ1BKLMGNHGwidRscgwWhBsB5E2SQakZURBa7SM0Dtiv9Jmfz51hx3BXTjrgXBCetIfurF0
	K3BCcmmPeKA==
X-Received: by 2002:a17:906:55d3:b0:b3a:875c:294f with SMTP id a640c23a62f3a-b3a875c2f2bmr943873866b.10.1759207336652;
        Mon, 29 Sep 2025 21:42:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE05FwuhQMGeXmbqCfNb5OYa/tRq8eoNKOW/kmksbVHWw0wqxA34cy3qT6OjHD0nk6wgB/ziw==
X-Received: by 2002:a17:906:55d3:b0:b3a:875c:294f with SMTP id a640c23a62f3a-b3a875c2f2bmr943870066b.10.1759207336259;
        Mon, 29 Sep 2025 21:42:16 -0700 (PDT)
Received: from [192.168.0.7] (ltea-047-064-114-056.pools.arcor-ip.net. [47.64.114.56])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b3e89655b09sm359039666b.77.2025.09.29.21.42.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 21:42:15 -0700 (PDT)
Message-ID: <69b0255a-b6b5-46da-9940-ce1f2a18c2e6@redhat.com>
Date: Tue, 30 Sep 2025 06:42:13 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/17] target/s390x/mmu: Replace [cpu_physical_memory
 -> address_space]_rw()
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc: Jason Herne <jjherne@linux.ibm.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Stefano Garzarella <sgarzare@redhat.com>, xen-devel@lists.xenproject.org,
 Paolo Bonzini <pbonzini@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>,
 Eric Farman <farman@linux.ibm.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Halil Pasic <pasic@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>,
 Reinoud Zandijk <reinoud@netbsd.org>, Zhao Liu <zhao1.liu@intel.com>,
 David Woodhouse <dwmw2@infradead.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sunil Muthuswamy <sunilmut@microsoft.com>, kvm@vger.kernel.org,
 "Michael S. Tsirkin" <mst@redhat.com>, Peter Xu <peterx@redhat.com>,
 qemu-s390x@nongnu.org, "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 David Hildenbrand <david@redhat.com>
References: <20250930041326.6448-1-philmd@linaro.org>
 <20250930041326.6448-10-philmd@linaro.org>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250930041326.6448-10-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30/09/2025 06.13, Philippe Mathieu-Daudé wrote:
> When cpu_address_space_init() isn't called during vCPU creation,
> its single address space is the global &address_space_memory.
> 
> As s390x boards don't call cpu_address_space_init(),
> cpu_get_address_space(CPU(cpu), 0) returns &address_space_memory.
> 
> We can then replace cpu_physical_memory_rw() by the semantically
> equivalent address_space_rw() call.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---

Reviewed-by: Thomas Huth <thuth@redhat.com>



Return-Path: <kvm+bounces-39294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 16F38A46404
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 16:05:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 114191885A54
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 15:05:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 599E922256C;
	Wed, 26 Feb 2025 15:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c0sVXWdg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BD1194AF9
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 15:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740582319; cv=none; b=UrlgUAIQCWU7UBL0T97hvkjtRFrW3o6mBAph1eQqe5XrBUVdNTQpS2oORsilqlvsXcVx/6rPizYRKEHN09HTDkfISsRuzQnRVZZHRt+kqkXf8WPcZaXPL+VocE+nIf4mtA2qM4y9Xr+TH3SyR8lskmoeZ8PkSmPryGWKhKhYqC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740582319; c=relaxed/simple;
	bh=UbsznBB7Ta4OOWxE6Q76ciArrmMaaUYgQLE2J5Bd0ok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fHAq5IU2MZdoh5zH6Hjo9sOCo7RzFGjlQ5imEZhuf9qtl4PfP0OTNlhawHrjGe7k9ymtlwQ9bNeyDNzj3DXxflv+gL1zd5JitHew/15E0feVigucAK9IkGfBUIWJ+CgRm4Pz9yZfXAYlxkA7OgZF7Decf8cGyQCLqYtj+CpJrTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c0sVXWdg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740582316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DtaKuouL0Y3pv+96Ex3YwJXMFO8jE7lmxjvjb5LQJDY=;
	b=c0sVXWdgsSSrRxSALZtJ05GZrQnhSd6BNeu49l3y5Mx1r1+M/YAdNDokgWMIew6Z00SKRK
	PSHPFT2GFRgbYlpOBI1FVsN6gSlss95w9m3etUPW6SpNIm3ww5fyzgyHORMzupBv3GICWn
	KLWALrXXCT+DYnXpLUCqexg9IMPeghk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-NgPgE9DEMkKkWaHLpediog-1; Wed, 26 Feb 2025 10:05:15 -0500
X-MC-Unique: NgPgE9DEMkKkWaHLpediog-1
X-Mimecast-MFC-AGG-ID: NgPgE9DEMkKkWaHLpediog_1740582313
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4394c0a58e7so52895805e9.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 07:05:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740582313; x=1741187113;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DtaKuouL0Y3pv+96Ex3YwJXMFO8jE7lmxjvjb5LQJDY=;
        b=lLNJIwW5uLTII0P9tTuXpQI8ILzpbCnXfT6MY4AL1piWMXa21MMkCW7VroeL0/Asv0
         ECKrdtH2q5UbsdnZ5P++oKT0v9Sj3R46X3MiqtaS9JbN6Pd1D/UxJ/9Br1ovH+9JSjlS
         xWGrFyIamiSyeocrHlGolRPKXeaP+l7+u9nKwyDO0hI0j5OOu1LiW4ZmJCSkyfi8qa3S
         P0vvWGYPBCVso2C6PsBxQcpfKC00treJegFSro3u4/tLBlq1PcoYN/FrfpWoHxOHKQja
         B54r2c2Q9/O4Yrg4PtPyoRnkUnbPa9EnJWyY5cvNpY8Ie1g4iBfU2n9PwWyHG3H6BFyL
         U8iQ==
X-Forwarded-Encrypted: i=1; AJvYcCVi6DyO82jkE6oo3nUPG4PfvJbk+75Il1DMMgPX6Q3WS+XjHIUGpKx0+j9usi4du9mFMGo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWgYSLW8UCehhoh1Pw/kqlnNg1OSHMoBpF6STo5eIqXAmQSaho
	NrIphJh7Xj8NSm8xYg7wEBDJFS8jpQ8vhziKxDo5cRI5ZMH3bD/TTdOkvWF4XTTMXdAk7aTUF/r
	L9/iyRjSLlBJUPuXEuNAg6e3/Rm6JTiYYZ1AACA/H3YA4YVfOuIME0kBLg1fo
X-Gm-Gg: ASbGncuBoovGmlvBsGLP1nUdeYzqpqaoIgiiEzF/HRGptRU2NpMMfDDBungRpAzcaCO
	qCkkbqt+w8vo6jpV/CMlu4GQqv/yOJ1yiOXRNiCBZZF0SPwfOepGLO4jQAEQkGmJLzquEfY+vnp
	9VFQEfM88bxaT9vQHQ6S40OEzc80jTdvneCAklCI/7kA52OzrMsySH3nNEGgqQu0hphcBk1OWjo
	eLXDaxUSZud/Yfyso9L89dGEnGXGmXeSlFSCt/BJAnL67JgbHVQup2DmKS/knw3gPJvtp7tpwea
	DUycQh0qkdLWKj8pEHRbwrqXSr7CFZOQBKhwC5q8WmHF
X-Received: by 2002:a05:600c:3506:b0:439:9f97:7d6c with SMTP id 5b1f17b1804b1-439aebcfc40mr173325245e9.29.1740582313010;
        Wed, 26 Feb 2025 07:05:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE3bcYNh8Rp+gjnHI+8lWknh+fmKRrB7o51AAIckCXQu2kuHMMgbo940KVzsy6o7t0A+oKQMQ==
X-Received: by 2002:a05:600c:3506:b0:439:9f97:7d6c with SMTP id 5b1f17b1804b1-439aebcfc40mr173324475e9.29.1740582312582;
        Wed, 26 Feb 2025 07:05:12 -0800 (PST)
Received: from [192.168.3.141] (p5b0c6611.dip0.t-ipconnect.de. [91.12.102.17])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43aba5442c0sm24142145e9.32.2025.02.26.07.05.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2025 07:05:12 -0800 (PST)
Message-ID: <0dfeabca-5c41-4555-a43b-341a54096036@redhat.com>
Date: Wed, 26 Feb 2025 16:05:11 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] KVM: s390: pv: fix race when making a page secure
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 frankja@linux.ibm.com, borntraeger@de.ibm.com, nrb@linux.ibm.com,
 seiden@linux.ibm.com, nsg@linux.ibm.com, schlameuss@linux.ibm.com,
 hca@linux.ibm.com
References: <20250226123725.247578-1-imbrenda@linux.ibm.com>
 <20250226123725.247578-2-imbrenda@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250226123725.247578-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> +int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header *uvcb)
> +{
> +	struct folio *folio;
> +	spinlock_t *ptelock;
> +	pte_t *ptep;
> +	int rc;
> +
> +	ptep = get_locked_valid_pte(mm, hva, &ptelock);
> +	if (!ptep)
> +		return -ENXIO;

You very likely need a pte_write() check we had there before, as you 
might effectively modify page content by clearing the page.

-- 
Cheers,

David / dhildenb



Return-Path: <kvm+bounces-58632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D5C6B99D00
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 14:22:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2CE637AF40F
	for <lists+kvm@lfdr.de>; Wed, 24 Sep 2025 12:20:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1EB0302CB2;
	Wed, 24 Sep 2025 12:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JgTGj9Sr"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C592FE068
	for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 12:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758716535; cv=none; b=OIAKROFYXPvmYqg+/+qOjy1OX7OBZPLwBPR2Pe3CRiSdbegD1jV/MGKm22HP0LbbatQvdnhsvEdfsNGuknvXY0/cpuFhUR25fcn0ZeNaOs9FzfDehkW9Grsr+IIYS1SayE7WE1/zs8eoCAoznMi21+phVNq6kqKO1N3Gtjluqpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758716535; c=relaxed/simple;
	bh=F12QU4q8Qkjdx4foIaaaCsAMOffO02IlwUOMyao4sik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I2Mi8KU7OVWrSjdw9uXQXgNXNiY0lVvciinpEPpGgQeUzBasVlqvItqyGmJPANdtSP0gilNKxiQU8reNbq0qa26LYSm9RQgjZ286Mto2V1D4YwNgKrMsO8ynvF+6LMBiAYReJQLq8eXm+MmKrNKh1fD8IcIZLwwobX5K5Gezy7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JgTGj9Sr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758716532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Vmz9e9JSHdKEXdBu/pteycJ1iSIYc3poo80ZjdbrzKo=;
	b=JgTGj9SrNvM1b3TjdvfRc42DXfz8UW14pOycpNCJjd4QZE8C3MgD1Z3o32StmCqtkiLNQm
	grnX48rBiK1lWNKPrNOm2+okXXxyBJtuExiw124IhX4SSFPFo7vFQxNyNrnFBg8EXkrFn3
	I759CyYm8ea7Hv/fnhaBieBKdcQpuwg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-AWSqjaWKP5yyBCQCCAqdBg-1; Wed, 24 Sep 2025 08:22:10 -0400
X-MC-Unique: AWSqjaWKP5yyBCQCCAqdBg-1
X-Mimecast-MFC-AGG-ID: AWSqjaWKP5yyBCQCCAqdBg_1758716530
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3efa77de998so3342263f8f.0
        for <kvm@vger.kernel.org>; Wed, 24 Sep 2025 05:22:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758716529; x=1759321329;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vmz9e9JSHdKEXdBu/pteycJ1iSIYc3poo80ZjdbrzKo=;
        b=KXjrhTCqpIUWLeZFS8WjSoI32rPqX+Liiz7tjsl6znyb1180UB8UHTfb6aDZXvWOBi
         8ST96JUBu/jMy/uXI34Te4IhxO7//iqEXwj/cPWGc47/C2ol/bi6cSm1NdzG21WoLyHr
         9rzBoDjFI202i3RA7bbZPp1njUAxSRxL0GX4gRAXiHsFrMHvrLwsJzWx/M/Fkv1X22V3
         G/D7JtE2GQwm/ZIciIRzQtdI12m7RxUIrDsQg4j0uRs0qscGHQNt08qhYtVpZPehre1D
         7guWUILPhmuN+ppeCWhefTvy6+TRHs9JJFiFFxxbi0NeL2SFr0XRA18+0xt1Es/u0xZG
         p/fA==
X-Forwarded-Encrypted: i=1; AJvYcCU9tTGAhlFyapLVpj8IdkC5zYWEPQh/NWM19zjYPvTHxJ8bq7E3g/acVjy9vOHUtisVYKE=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywgi9sLzCd2ch1CFHwT2erPo+JZa/c3QJnkOBDO3K0ZiOy91Qru
	TIcrl+xnZAQ/zg95OL+LmTqgXqI+vWB8ywlbnVwBMf3fnJHgV0FitcP9zy25Phr6szOskEjtIkn
	MqZSpeDXqH8b7DrEcGTqlaC3uYH+TnNRlw+6a7H5dY6YT9AHKlvHkug==
X-Gm-Gg: ASbGncvWcSv3yDrc23JIYcsQZ6gKdRmY87e3UUalzr6QLAsmnebWnS70FkvRX7P3QTt
	FIQpbL1ijSom0YPhjdJ4pdGKOoVI5nauMpUpWRbkiEzi8I4xoEqMylL1Un31MgezMkQApne3R5f
	v8+8xfqtB7OAA8n8pesZoVMJdf0cId2Uv0LTeZxulOgMEef3crX2zHMH4wXQd60UZHbCQp5cUeZ
	ToDteP/hb3mcocIbZMaBzL3VAjFoS8O1ANcvhvbPBudi63o7JSgoPUyz9dya0vOyee2l8Y7z1H3
	nnvEL+pJgDvAZ3gPEHxqRXhxS5yqNEHy9c1ZV7MmU+vWufiACRF3KnUFuIP7ZMtrS0ALskgmT45
	v4PcpA82EytFJPT6CBTYBWs2xOK9uhIdYqxK0z2Vm80UaLDLgugW75LonPTiMaIql3g==
X-Received: by 2002:a05:6000:4029:b0:3f9:e348:f70 with SMTP id ffacd0b85a97d-405cc9ed199mr4696078f8f.55.1758716529567;
        Wed, 24 Sep 2025 05:22:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF5gZefcieEpNs9h9qe4+85WE47fFv6kBePDFTI4Qe2rs31B+VWsQMipVnDJxVutukKGr1/Fw==
X-Received: by 2002:a05:6000:4029:b0:3f9:e348:f70 with SMTP id ffacd0b85a97d-405cc9ed199mr4696056f8f.55.1758716529167;
        Wed, 24 Sep 2025 05:22:09 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab62233sm30548635e9.21.2025.09.24.05.22.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 05:22:08 -0700 (PDT)
Message-ID: <dfc83821-f2ff-4b9c-b9cf-9dda89e8eb77@redhat.com>
Date: Wed, 24 Sep 2025 14:22:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: Fix to clear PTE when discarding a swapped
 page
To: Gautam Gala <ggala@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <20250924121707.145350-1-ggala@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250924121707.145350-1-ggala@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24.09.25 14:17, Gautam Gala wrote:
> KVM run fails when guests with 'cmm' cpu feature and host are
> under memory pressure and use swap heavily. This is because
> npages becomes ENOMEN (out of memory) in hva_to_pfn_slow()
> which inturn propagates as EFAULT to qemu. Clearing the page
> table entry when discarding an address that maps to a swap
> entry resolves the issue.
> 
> Suggested-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Signed-off-by: Gautam Gala <ggala@linux.ibm.com>
> ---

Sounds bad,

I assume we want Fixes: and CC: stable, right?

-- 
Cheers

David / dhildenb



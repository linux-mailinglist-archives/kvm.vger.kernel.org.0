Return-Path: <kvm+bounces-53982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9133EB1B322
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 14:12:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DC251895236
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 12:12:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A448E27056B;
	Tue,  5 Aug 2025 12:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DJOQYUM5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DCD26B74F
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 12:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754395925; cv=none; b=sz+GsuI1SVwxtYdmqEWtv/Rrfp77AUtmWdWv9JrzjGLg+IjXCgXIN5BCWQd7JgCIkL9WlgvKP6MATDJy1581sPV0BPLH3ZMhsQp7X6WKHQdt2+FCUhdWUgWtvUK7Ab31xxtm5wvUaW1Ky1v2KeRUUHkrkD//ks/YWSPmUbc+ATA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754395925; c=relaxed/simple;
	bh=PkN2XX7pLKcIUWqfRErxMi4SNlpWdneWn9/g4TS296g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RvMkMq5EeWzAE0owSZBIqtx7gwSf4ZquwPGww1D6foAeu6ArvihySeK+4ZOmqYeB6VidnbWTpAlkSZ6YP2+S0v9fLhBJgzS6UFMSHjLWQaEF6p4mhscCu/7vKiJXLidmD7GUgzgCDLr2D9s70SKXs7qu9I80tyb7ptf9f+qpTeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DJOQYUM5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754395923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SILdafDIUq6T1vxmByNHoLz/yQ+KxKADC56XxDUmCig=;
	b=DJOQYUM5Xu9AHqE5egi088TrqRL+1n/HP+sa96HIG7HMYHFGcc3NQQJgvsCX1X2sYENhZ4
	RBJeEPSB5L5gB01oDf56c+O8JkaP1NlSEEpLiVZ/IHjXQpTj3Ih5kD0LeVYzQ5gFHij18H
	pYR2F2eQZAZjy12TD0sR8SNraKcilrc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355-kpfI8XHcMMitQkxCHIOOYA-1; Tue, 05 Aug 2025 08:12:00 -0400
X-MC-Unique: kpfI8XHcMMitQkxCHIOOYA-1
X-Mimecast-MFC-AGG-ID: kpfI8XHcMMitQkxCHIOOYA_1754395919
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-459d5f50a07so11784275e9.3
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 05:11:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754395919; x=1755000719;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SILdafDIUq6T1vxmByNHoLz/yQ+KxKADC56XxDUmCig=;
        b=uEUH+UaJNaPi+pqQpcUEDrHOSQ+GJAI6X5dBNK6yGyTAgpCBmnyRG9yxcTvWNEkjoV
         0DqDRoiN9vGwmowWk0Qdo1+X/7r6SxMIpLYUgVDDPA8dS63f7j8mTOhjdtKCCWSC4V/W
         CG5HKoN8VOCpWXMLrJVijIOTmwBgNPEuMJS+mTmXCEmwIT0xE/NBdfhI9UEkXfcHlcpj
         jvvBonlHnBxGU1PEBnVmnuGODO7qAhQUfG3Czbsjq15fPm0ZgxBGom4XTM398GdVy7Qi
         C44dc0shliu9PDF2dccygjl+P0H8EeaWIKHWkNkjO239qYA+zij3HObkRMM5/E4y0yX/
         /Gdw==
X-Forwarded-Encrypted: i=1; AJvYcCUMXbg+RSMfkuNSe0/OUkBNn5KsebzdvU0pZg5Ye8ioM2rmDcjsZSzr2jWPT1u7ZVw4KqI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXWhqpo/hbA1JJoaiPQk2ZgnmLByPofcf+KAAs8XeUYUPBDEb3
	jjpRLELJbV1CmG8QI5y2lCDR49a4RP8qwCdO3Yrk4+mZG+LzCsLzndGxIsiYs/LU0vLiUIq5oyM
	mLYQgv7cHOVV6nqkNQ6hcAo3+BtvYLrOrNv1bWQGkPTtrBPZw43XCqA==
X-Gm-Gg: ASbGnct0NnGNajf8lAKahtf8SilSX8ec8h9fPs39VpL5TQqOZIMwiCCMMjqWo0QrRfi
	PbVWJd0KxxlyE/F0foFOwhtKS9zqG/qzQ/LpxzSNPUb+PBD/EaNdxEAGekH0TeDgdcGd2fgNyiU
	D8W/uOAs191uhdGonosg7766i8eVDuveV7cRiHX606msmAR03XDG6tOaDkBASKB7EpA/8CBuuq0
	p1PAw17ZjgyJU6fmHrLIvgO45o/834bMZfRmzsoVHZEX37sbobA7GgAzkcoOVlT2P0rEl3+4nNi
	lZPxDaXkU5bNI97yWZQLKaECNkb2Fon/VCUsQdOIHvCt8MphEyxzmy+JMZTP/sIU95oDuQE3J4L
	uyy4ltoF5cRUYXmQYkz2PkYVJjkWtyQndkgh7oSil6SZleog4rWyc9eDPmOVnV8K5f1w=
X-Received: by 2002:a05:600c:1d08:b0:459:db5a:b0b9 with SMTP id 5b1f17b1804b1-459db5ab3a2mr48234285e9.28.1754395918801;
        Tue, 05 Aug 2025 05:11:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxZPzHZOSJwMEcCot86poc9UZ/c44aOsLDwgU/vzU4XSjaGj8F0yKq7r0fWaYJ4jtRH1ng3A==
X-Received: by 2002:a05:600c:1d08:b0:459:db5a:b0b9 with SMTP id 5b1f17b1804b1-459db5ab3a2mr48233995e9.28.1754395918402;
        Tue, 05 Aug 2025 05:11:58 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2b:b200:607d:d3d2:3271:1be0? (p200300d82f2bb200607dd3d232711be0.dip0.t-ipconnect.de. [2003:d8:2f2b:b200:607d:d3d2:3271:1be0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3c4d02sm18618858f8f.33.2025.08.05.05.11.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 05:11:57 -0700 (PDT)
Message-ID: <0c778373-3805-4dd2-b8ac-97d5ce77235f@redhat.com>
Date: Tue, 5 Aug 2025 14:11:56 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] KVM: s390: Fix FOLL_*/FAULT_FLAG_* confusion
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org, frankja@linux.ibm.com,
 seiden@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
 schlameuss@linux.ibm.com, hca@linux.ibm.com, mhartmay@linux.ibm.com,
 borntraeger@de.ibm.com
References: <20250805111446.40937-1-imbrenda@linux.ibm.com>
 <20250805111446.40937-3-imbrenda@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250805111446.40937-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.08.25 13:14, Claudio Imbrenda wrote:
> Pass the right type of flag to vcpu_dat_fault_handler(); it expects a
> FOLL_* flag (in particular FOLL_WRITE), but FAULT_FLAG_WRITE is passed
> instead.
> 
> This still works because they happen to have the same integer value,
> but it's a mistake, thus the fix.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: 05066cafa925 ("s390/mm/fault: Handle guest-related program interrupts in KVM")
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb



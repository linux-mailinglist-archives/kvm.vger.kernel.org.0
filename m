Return-Path: <kvm+bounces-12285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 986E7881116
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 12:35:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FBE3282E22
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 11:35:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE3363EA98;
	Wed, 20 Mar 2024 11:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LOk2N/pR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657E73DB89
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 11:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710934540; cv=none; b=tdYq5bHGT9ubHVwSGykOIxvkvhJgB2xohn6zauwuYSsxc8hQlpjQjvTBCdTaSy3EA62Oo49/Z5uMBb36P5cbv+y/Nm/MAlrdMfvVaT2q5MhFaGlSGgdNyqGWR1ZjhLkyXj/xZm3STnUYDtgc9/uxiLL9OiEjCCLeE63UFx5u+7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710934540; c=relaxed/simple;
	bh=SLiFCfY4b3lVXzFCGGs9sIbiGRlF4bB6wOUpWVI6vOQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a+z/9wKt5GjZH6Dq7yOzhbQBlJiZjUYOuOQ28Q3+Z2RU4B/E+gGKqtNP5AfnPLLXi4VRi99Y4TBYiauJq33Wq5BcVIIygwx6irvp1/baappfC7wAnZpPTSf9+qltVTdvr7zlSYkYIQLX+z+EQI+GTEQBO0hxZRK9eiJHjJipPic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LOk2N/pR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710934537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WxTD2hB5MDacVjwhAlli2Ecjh1dJfTB2r6xn0IlYg78=;
	b=LOk2N/pRG60IaQgbVf+aChN6C4QvaU3b2ruIHUUZow9XoDG2+3BKFcdrWGA56Rj9PXMggt
	ZkSfbA3w29iIbsAhWkNHnKmLIFioUVvIrNetg9SXFK5ju1m9WjJFhedwZ4iYsvWfj2Yy3L
	6yuu8L5c/z4am45qy5A+B78sLRMr4+0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-458-nNLrbdXfOvehfwmih9M9lA-1; Wed, 20 Mar 2024 07:35:35 -0400
X-MC-Unique: nNLrbdXfOvehfwmih9M9lA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4140f58ac00so18776795e9.3
        for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 04:35:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710934534; x=1711539334;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WxTD2hB5MDacVjwhAlli2Ecjh1dJfTB2r6xn0IlYg78=;
        b=i08beH2mW3a5RkXNEgTlyB2zSTeRhpAeixd4Zsv6zlxUa4woujWs1fhPuMqy6nFRz2
         EiQHEni5+pYxhTFjjUL7a62VCjxwBX1Y2pKBVI/mb0ibpYnDAW5R6RG4vNVH4l2261ew
         dryJYcgHEOprH0f8RdIVNPufztziFqDx92pb3qLhuW+dTqC5u/G7DMqen1TkzqPAMp6F
         4jIMb+NbfcZLheeSi/EcawVsEZZkYBIavQJwa5FXyak5CWECYY17CVJ2QOWGUEgMU3LK
         enzpA7FuSUVYzf+xEGDTmjpDDJ0Ae/Rr5kAxxEPkg63xiXjH+svo7rKyItZ5Q9kF5x1Z
         v3tw==
X-Forwarded-Encrypted: i=1; AJvYcCXrxGFVKIP+gIwNJYPU6+Kriesx3QOpgMchBMoQOjYgykCbDbhl6NpsHnFNeva0D5kj5WK2t5YswuyUWsll86HjqgDH
X-Gm-Message-State: AOJu0Ywcj23eCP1PWt+GnpdIMjdUu4E8YG4jQOsWcvZvnNQL0fDhIPyc
	+bPXSiGyngGVlsCBN5UBSpzwOv3e12BhzCcdV100YQzxVQv//DtRYYbrUS5UN9d4fBrAT0PVam0
	ymQNWO4yQsgwCXZmYrNgx/wJz0IpuXkSx15IF2wzid/a/KR+hKw==
X-Received: by 2002:a05:600c:16d3:b0:414:a75:7457 with SMTP id l19-20020a05600c16d300b004140a757457mr4053435wmn.10.1710934534418;
        Wed, 20 Mar 2024 04:35:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFjoZC9y4pciiC3OvTk2Rvtxv60Pt4OK8yPKuhguUJbDVj7YETGt4ivST4/40otF+ZlcB3qwQ==
X-Received: by 2002:a05:600c:16d3:b0:414:a75:7457 with SMTP id l19-20020a05600c16d300b004140a757457mr4053418wmn.10.1710934534036;
        Wed, 20 Mar 2024 04:35:34 -0700 (PDT)
Received: from ?IPV6:2003:cb:c709:c400:9a2:3872:9372:fbc? (p200300cbc709c40009a2387293720fbc.dip0.t-ipconnect.de. [2003:cb:c709:c400:9a2:3872:9372:fbc])
        by smtp.gmail.com with ESMTPSA id q14-20020a05600c46ce00b004140a757256sm1962413wmo.31.2024.03.20.04.35.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Mar 2024 04:35:33 -0700 (PDT)
Message-ID: <a25db70e-2e17-48cd-bfb3-58cddc99af7b@redhat.com>
Date: Wed, 20 Mar 2024 12:35:32 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: s390: vsie: Use virt_to_phys for facility
 control block
Content-Language: en-US
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20240319164420.4053380-1-nsg@linux.ibm.com>
 <20240319164420.4053380-3-nsg@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240319164420.4053380-3-nsg@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19.03.24 17:44, Nina Schoetterl-Glausch wrote:
> In order for SIE to interpretively execute STFLE, it requires the real
> or absolute address of a facility-list control block.
> Before writing the location into the shadow SIE control block, convert
> it from a virtual address.
> We currently do not run into this bug because the lower 31 bits are the
> same for virtual and physical addresses.

So it's not a bug (yet) :)

But certainly the right thing to do and more future-proof.

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb



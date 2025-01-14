Return-Path: <kvm+bounces-35389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 95727A108C7
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 15:12:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC9D93A1CDD
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 14:11:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5736113B7BE;
	Tue, 14 Jan 2025 14:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HY9g9a0T"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D996113AA2F
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 14:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736863873; cv=none; b=BPyLW3XlLgtzwWeeve2qUCYGcHTXGurXlHPP8a4KxUSx+E5i1fTVs70CB15faBAcUzZlFjfjPm1ZFtoVbhw0b0Ed/5urAOd2zOUpmVmBHqOLvVD29hjTgVZlvNtM+SSK6h640dn9J6I9J2J2PYEWYiwJKMOrpfi0O7vrPDh1qtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736863873; c=relaxed/simple;
	bh=M1wKFPqr6t2Zh6Kz9dgh9aVJk57Ools3iKIW/v66aCg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oX3AFU6s2rtdhGeGDEa1AjLJDdKMdeoRRri/ku8atvR9GEH9gfqvxY9qkX3bEO0Pyu9A21dr7X5httdLt9roR5XmO/Nx3QNIVb2K4YSnK9w8m7K0KS0huaboGmpPvWG00K+BYNBwDEm6zyZpkL3AQ4Wc31nBjt4oegD7D9BhBQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HY9g9a0T; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736863870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4PrAckxjMX0X/2ESjCBt17CaHgHYf56af0Xw3wi3t9c=;
	b=HY9g9a0T8eYxW5pK8j1BpJ6FSjXaEIFoN3ZcFB5FQFYhnhC1Is535rGFXui3Yf0Jag1vN9
	J0m5ydCsFed2JAndKQtO5XJ4emVkFSoEsQlfJZ9OOUDDEoWUJigQYIxjV0dX1/YZTKnDsA
	vc6Hy/W/TY+fnQ2zIiQVM82AZ856BhQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-164-9Uzu8jwaNrCACbQ5beiGEw-1; Tue, 14 Jan 2025 09:11:09 -0500
X-MC-Unique: 9Uzu8jwaNrCACbQ5beiGEw-1
X-Mimecast-MFC-AGG-ID: 9Uzu8jwaNrCACbQ5beiGEw
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4361fc2b2d6so31042175e9.3
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 06:11:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736863868; x=1737468668;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4PrAckxjMX0X/2ESjCBt17CaHgHYf56af0Xw3wi3t9c=;
        b=Jw/rgaPXaw9ov7gPgy5V+qdyXE8ckrMDgILPkHaYiIsVY13R4F/FeIL8En+0vq/nv7
         PzWT+2E6I01MTV0wyV+BTGOpbmnOFxuN9686zOQ6eSuZtOUfB5qUPpi2dofMtNXMDX41
         HnlxWBfHbNoM1UbXPqzliKgcYEdK4WAkwtcsmUt1oinMFNW2akgvs/sx1cc3tIucTULL
         klAtvUEZXv0FgHxV4uD37YhN5TymgZA5pgXoB6+UK8pXhxg8PCMaU+RNqhRQnaiYreLG
         XlND+cAu8+Y2gUDT/d5JjIBgVXqAs1UdAypCXt2KVGFsu4+Mfo7ZKOAlpLtMt4eRp9rj
         t0ZA==
X-Forwarded-Encrypted: i=1; AJvYcCUdGFa+uiPMf/K0p8gBh0GS+Mc/LHWIuHNuW2O7QGzseUzWTDLtsHdAPCoSB0e57J27330=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdAr2LGuHAxQTc42LkK5Dl4NNhc9E5L7nb0+CsUBp3W1qy7noz
	tXP/zuTsDGh0LYD2P1+DfYQ0EV9InJa8+qqCsOsHN2bs+zDYi1r8kzj8mPMx76z9fWig+2Yf81Y
	WvESiREpYb4RfAWzYR++eFGT/D/wSa0Kh/U5XyrcFq4xnywSEZsj9xLwpLtYd
X-Gm-Gg: ASbGncvQYozziw6ngOFDGtXm+zXoBQw+6PkeHj5CEKRqJXygocKezVZv1wprAp4mubw
	d4948nKSwCQJ5FA3T8po4MnNnPtbQbX+0dhXHKTt34cRNC+Wky+9npRsD0gxY6xYpxgxQGec99r
	Mps0FYCXoijQEC0m6B9pB+3LV+x//9szQp99iJDMebCzZdf/mtKXpEhZ3hwB4D22A545f18WUNU
	x2VnQiZJ7UBOH3nbDMc6gbLrzRStX093/dwC6B9eY8IFNbJYOt7gpX2k7uM2It2Gphcr+9x93lL
	hHE7k93DhX9DpI9h7BQYe7+sWwhaoNAV4ZiOH6shEnRr8QABr6/egCDvvP1Af2gpqgb12/E1+dh
	UTKwOxxk1
X-Received: by 2002:a05:600c:3aca:b0:434:f335:855 with SMTP id 5b1f17b1804b1-436e26eb428mr188949855e9.28.1736863868169;
        Tue, 14 Jan 2025 06:11:08 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEm4gIS/GqcHDaKSqHL+sf9sek6/M9j9JUiMeKGvQ58scjz3viCwAVZBGRTOUPtuLzfXiQvEQ==
X-Received: by 2002:a05:600c:3aca:b0:434:f335:855 with SMTP id 5b1f17b1804b1-436e26eb428mr188949595e9.28.1736863867844;
        Tue, 14 Jan 2025 06:11:07 -0800 (PST)
Received: from ?IPV6:2003:cb:c738:3100:8133:26cf:7877:94aa? (p200300cbc7383100813326cf787794aa.dip0.t-ipconnect.de. [2003:cb:c738:3100:8133:26cf:7877:94aa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e9e6249csm174697565e9.38.2025.01.14.06.11.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 06:11:06 -0800 (PST)
Message-ID: <295cb360-b618-4a89-86e2-1630b872fa7f@redhat.com>
Date: Tue, 14 Jan 2025 15:11:04 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/6] hostmem: Handle remapping of RAM
To: =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>,
 kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
 philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
 imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
 wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20250110211405.2284121-1-william.roche@oracle.com>
 <20250110211405.2284121-7-william.roche@oracle.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250110211405.2284121-7-william.roche@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10.01.25 22:14, “William Roche wrote:
> From: David Hildenbrand <david@redhat.com>
> 

You can make yourself the author and just make me a Co-developed-by here.

LGTM!

-- 
Cheers,

David / dhildenb



Return-Path: <kvm+bounces-59527-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEAB9BBE205
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 15:03:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A93213BF422
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 13:02:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CE4A286D4B;
	Mon,  6 Oct 2025 13:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PEmm/hp7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB032868B0
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 13:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759755741; cv=none; b=So+CEiZJUcN+JZLEyjEui21inLxbt+Q/Z/qA7sgfKHktdsDDeEz4JlL76udTm5OIF78QT3R2SjtFZKt9wyhw34ZWUteMrjNxxzDIZqOp71vpC1boTq+i3pw3gbE9CXfTctYU8VWqzLZpLPMooZVV+wlJa3CGQ7YUptn65PwLxj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759755741; c=relaxed/simple;
	bh=UPkwNlSY/9N8EmAYSw1o8kXKQrb+iH1+cyfJ/ckoVEI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M2x8e13chij85BIWQbnSs7RPl3NRserDIHE5GnkTRf/VPaMRSHcJnqPuZ4DccB0rHtSyYH1WCyz7lSheHvKReFP/btpcMIT1zl3hYd7cKzN+LgJygLrU+9jIRZN+dE/VXx6ZAYpr2IuwbEvGKarbbzXp4vsGgchEDz4LnbNP1xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PEmm/hp7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759755738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8XP+/L6ShZ+ErNDo2j7T4i24j2ImOHXB2awMNPB8ugI=;
	b=PEmm/hp7oj393jTUDtyVJjcy0EDHy/xZjl8ZK/0U1Z6ykghw7JdmOmtOYsBPH3kGrXcm7C
	cK8VsmBrIdWlz1awBX8ZcGtklwnR6r4JNA8ozeDZOPHdvzMOZBcb3h1Pn/o2AXtlc6btxE
	wHf3l3SupgYM/L8obKZzbo4/5Sln7RQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-480-lxdhwQmXPrOdXBuODmV9iQ-1; Mon, 06 Oct 2025 09:02:16 -0400
X-MC-Unique: lxdhwQmXPrOdXBuODmV9iQ-1
X-Mimecast-MFC-AGG-ID: lxdhwQmXPrOdXBuODmV9iQ_1759755735
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e4c8fa2b1so21085495e9.0
        for <kvm@vger.kernel.org>; Mon, 06 Oct 2025 06:02:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759755735; x=1760360535;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8XP+/L6ShZ+ErNDo2j7T4i24j2ImOHXB2awMNPB8ugI=;
        b=DXVyk9W/49LZ6V7zvklPPzoYDRLW96UBXRY9/6TKABeojjYfXFgBbqjvVkhT/VrKhz
         wZP9FetWJcBL90Z45Ua7Scjq5U9g6BSYLq/trLrTbHpu2EonqvOW1lTewknUUc2Xmg3S
         /HdOIdAVb1HWrf/0Efeqr6+RJaNQGZR7D3Ah1Ed4fX2acWtFXaeCJxLNGp9bsViaOAFS
         sPz25RVjdo4Pub/4m0Z6Y1M9x54sAhuj8SVCnOBNFAQ6s+QB7fhEgBnCkUA7VJ4hwyGQ
         t3/c9dMT08GieucrjUdkLjS6VTtxq941rLjMNMeIoPyJ2nlCqoXu03SNFYmY+RT0C+rJ
         JDrQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCB5tskNTfGFmUdXS+7hSlTPL8xUlW5d7Niyzb9yTsQRsOUgfUKGvrxomqGsyaym3W+cA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxih7a7+0Wx/RB5BlZyXeHvFZfsL2QH7X2dgLTHH8ixGGQ08ZfR
	s8ZWFPRZZr5bfOTXkaBUkteBbz+jJQJxVWkh4h/7HLQ4uMW6aBxnDXBU+453NESOD4WhYHSWQTe
	UqDmVFa6F47Sl9213M0oz3eFZxkjb61kSrJ8sDO3En5h5Cox7+A5PKQ==
X-Gm-Gg: ASbGncu7WsPUyDd3Whm71O3OtbefVMHNlyfMEW6eEcl0nvJq3l9cLmPR/P/ee/OBfrD
	yjkQD+2/NRCmRAupeIu85imzt3lnRUtE+v4osPkSFarLsnIuf5OrMlo0ATSAN0DRCE2YY8NFlV2
	YxumGSgHUkeiPr6AMTMr5NaPPpdFOnUBkV3LD40o24FUKo//AFsSMiouRcGrf1wPlU63t7aPmQX
	Sy6Yi/rL5ocXPU0QEsP4jyfSiu+ikZ1jEvhKvF/AT3o4aOKZsr68DmqMZbTZGTajkBoyJFTp0Pq
	mArLiBBYV7oeV8tHBfPOnsY5Y9sq23F85RUysWDawXE9FMGjMrUXDg5Zi/T4vswovhiD0h31/Yd
	kMZo2MwGNeQ==
X-Received: by 2002:a05:600c:474d:b0:46e:3901:4a25 with SMTP id 5b1f17b1804b1-46e7116411emr74067905e9.20.1759755735224;
        Mon, 06 Oct 2025 06:02:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH5c3nOdBnQ9j37P39o/Q5Li46dr79sX1W7PgBCfxkuek9zYsqmOCp+rbWk9IR7bBwE9cCAYw==
X-Received: by 2002:a05:600c:474d:b0:46e:3901:4a25 with SMTP id 5b1f17b1804b1-46e7116411emr74067525e9.20.1759755734647;
        Mon, 06 Oct 2025 06:02:14 -0700 (PDT)
Received: from [192.168.0.7] (ltea-047-064-114-056.pools.arcor-ip.net. [47.64.114.56])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e78c5d290sm117768045e9.0.2025.10.06.06.02.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 06:02:14 -0700 (PDT)
Message-ID: <3209475c-ea4e-4b73-942c-6354aaa36f52@redhat.com>
Date: Mon, 6 Oct 2025 15:02:12 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/25] hw: Remove unnecessary 'system/ram_addr.h' header
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Nicholas Piggin
 <npiggin@gmail.com>, Elena Ufimtseva <elena.ufimtseva@oracle.com>,
 qemu-arm@nongnu.org, Jagannathan Raman <jag.raman@oracle.com>,
 David Hildenbrand <david@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Eric Farman <farman@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>,
 Jason Herne <jjherne@linux.ibm.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@redhat.com>, kvm@vger.kernel.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>,
 Peter Maydell <peter.maydell@linaro.org>, qemu-ppc@nongnu.org,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, Fabiano Rosas <farosas@suse.de>,
 Richard Henderson <richard.henderson@linaro.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-s390x@nongnu.org,
 Peter Xu <peterx@redhat.com>
References: <20251001082127.65741-1-philmd@linaro.org>
 <20251001082127.65741-7-philmd@linaro.org>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20251001082127.65741-7-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 01/10/2025 10.21, Philippe Mathieu-Daudé wrote:
> None of these files require definition exposed by "system/ram_addr.h",
> remove its inclusion.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   hw/ppc/spapr.c                    | 1 -
>   hw/ppc/spapr_caps.c               | 1 -
>   hw/ppc/spapr_pci.c                | 1 -
>   hw/remote/memory.c                | 1 -
>   hw/remote/proxy-memory-listener.c | 1 -
>   hw/s390x/s390-virtio-ccw.c        | 1 -
>   hw/vfio/spapr.c                   | 1 -
>   hw/virtio/virtio-mem.c            | 1 -
>   8 files changed, 8 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>



Return-Path: <kvm+bounces-59526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B37C6BBE1FC
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 15:03:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A64CE3BF641
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 13:02:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B695A2848B3;
	Mon,  6 Oct 2025 13:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M5eSCUIq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37674284662
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 13:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759755677; cv=none; b=NfZtQJ3AhewxYrLo/lZVt189+087UA1/EcJJc63skN/0Kdr2OLlrpUl4hiEFwDEbGwJzTefZR3cOLGkvP6UAUYAIaqtlmhOOrU2XQCFiQAR5oLy+iizjcvody4muZ8AaICaNsfwVTr3A6LA3RVapCo+b8z7LCMa8ibjFN2XWlkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759755677; c=relaxed/simple;
	bh=DMf3Bv60FETylcvilDLAgaW4Fm39getzasuR0OY6UVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U2gJhW8tXJ95p0Dumw9lsepNTynn1OpArFvugLjn+N7N6QoFqBtb+wPJe8F/qtpXFGafCYEKW14KGlw9uKPBbQipJeS4l5U9TfB2Uz8Z3q7q1WQ9bCyYtjUrnFQjd5NcTNOAhpNJfyyCOv4hJ4FYu+S4PFL2E90zq33VJSwYwak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M5eSCUIq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759755675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tbg/jdlMLCmitobHajNdFI55jOdnqoy47OONdMKjRyA=;
	b=M5eSCUIqCpFdXMpNn3n8PCzI6PZtEERpU++SCHGJY4tAimEzzjpm2S7kWOt4bZ81LTicVB
	OHTI0HaMhBD/3FcQD2q+fUOYewS8ljKd7ApI4TqdIaXSJri0TxHkPpR9SnCqrxs9Um0Z7V
	0JQARrK59re/xDjaSqTOQykmT6dsWP8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-VQ1pQ-CfO-ioYqpfkYTWcw-1; Mon, 06 Oct 2025 09:01:13 -0400
X-MC-Unique: VQ1pQ-CfO-ioYqpfkYTWcw-1
X-Mimecast-MFC-AGG-ID: VQ1pQ-CfO-ioYqpfkYTWcw_1759755672
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e509374dcso22752615e9.1
        for <kvm@vger.kernel.org>; Mon, 06 Oct 2025 06:01:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759755672; x=1760360472;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tbg/jdlMLCmitobHajNdFI55jOdnqoy47OONdMKjRyA=;
        b=VYh3htij/hoCN890rMus3NhgdrE/eqKSAk3Nyx6iby8XJ7jR19hfUavq9yKKrXpCdU
         dcz3PjpHUV6OO0rfG1/rat2FqOVKvgCt4B4GHYDZ8PygCI1sonmL7Hevacigw7xpbSsS
         bduAfeNEkn5S2cpbMX01foh3cnxQdCIilHADcLZ9LR6Aknex7uPww1Z+DCLGe1QBvE/l
         CBNc5RmYbXtBJUW5618FNqmuyDUbKEHSQSBDHueGTAii1qGmzMXr5+6cMbQcP7boHcjx
         /S4aksd0dhEHp8ZtMxcqARHZ2qpS+FFoXj1PaqU0oaFeQzaSV4iybNavxbikUoO0tLkV
         gaDA==
X-Forwarded-Encrypted: i=1; AJvYcCUAB8zucXsmHyzzbDdPwYJ7z+7aNji0hmYt96003QYggpJh+ks6Sh05rIuCAXj6fh9tieE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrSWsx8/Z+fQi/aJ8Yjau9J5QT4g7iL6GS6BOQkrQObIYw04Z2
	0Xv+qIaU3a84rJ+ThBcIYbJJ6+NpTjgp5mfqWo1Zv2tvx+nisyD6HtTHETXeKFVugtMB51eUY1W
	NJzv1VhF/iK086aBXNpLbk3OT8GVxO+KKyGrvyFD/xG+djAT16X4WlQ==
X-Gm-Gg: ASbGncuXLbonIrDhmBXuKHPpi3cCw48wIMWm5PmKh990wJ5O/Vwt0a/CJmLUREJeYLm
	QLadkKPWo2+l1CJUHbqtQ7HOkiP+BPT+vEM+D/++Ym6EqEHSeNMJRQyXXJhfYtRlNvqr8CEYV0y
	tjGUH2LOEf4XPqWWBI6P27p2wBLr8Vc0WioGPUYegPmUh4WvkNUIeqy0jvu/IczXwtsZMIrpoXP
	I4/78/Q+dNzT5T554RrwBP44K0GWOk6Lz9EBDaJLfwNz213DovGjlRyEd2v4TI/ENTLTLjbo7p9
	WTLtHssbacj0UX/S4Quw4dB4ycFENNIxMgtuIIy0oRBXpRTeCIJjdRsnoQ3qq29Ick3+RmGUizy
	yyKci2tPohA==
X-Received: by 2002:a05:600c:4fc6:b0:46c:adf8:c845 with SMTP id 5b1f17b1804b1-46e71124395mr99858255e9.16.1759755672192;
        Mon, 06 Oct 2025 06:01:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH/RFmdQCBtd4GU/CABKhL7qsIvB+A+AXJ+ouRDj1zbgXPndLNpU2GqgLCh7IjJLD/drew79w==
X-Received: by 2002:a05:600c:4fc6:b0:46c:adf8:c845 with SMTP id 5b1f17b1804b1-46e71124395mr99857655e9.16.1759755671596;
        Mon, 06 Oct 2025 06:01:11 -0700 (PDT)
Received: from [192.168.0.7] (ltea-047-064-114-056.pools.arcor-ip.net. [47.64.114.56])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e72374b8dsm174600995e9.19.2025.10.06.06.01.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 06:01:11 -0700 (PDT)
Message-ID: <932a0061-a673-4ca9-a935-99edca9af9da@redhat.com>
Date: Mon, 6 Oct 2025 15:01:08 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/25] hw/s390x/s390-stattrib: Include missing
 'exec/target_page.h' header
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
 <20251001082127.65741-4-philmd@linaro.org>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20251001082127.65741-4-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 01/10/2025 10.21, Philippe Mathieu-Daudé wrote:
> The "exec/target_page.h" header is indirectly pulled from
> "system/ram_addr.h". Include it explicitly, in order to
> avoid unrelated issues when refactoring "system/ram_addr.h":
> 
>    hw/s390x/s390-stattrib-kvm.c: In function ‘kvm_s390_stattrib_set_stattr’:
>    hw/s390x/s390-stattrib-kvm.c:89:57: error: ‘TARGET_PAGE_SIZE’ undeclared (first use in this function); did you mean ‘TARGET_PAGE_BITS’?
>       89 |     unsigned long max = s390_get_memory_limit(s390ms) / TARGET_PAGE_SIZE;
>          |                                                         ^~~~~~~~~~~~~~~~
>          |                                                         TARGET_PAGE_BITS
> 
> Since "system/ram_addr.h" is actually not needed, remove it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---

Reviewed-by: Thomas Huth <thuth@redhat.com>



Return-Path: <kvm+bounces-18748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F1C4E8FAFD4
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 12:27:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B12DB2222F
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 10:27:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D05FE1448D9;
	Tue,  4 Jun 2024 10:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FEyDRmSm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F411448C9
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 10:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717496816; cv=none; b=uZLBgM+euro3bERyMQjJHla0bxnQFW0z4dkJjVF3JC0pmqTvlYSzutQAFKahDurK5jPxny6iVBT5oze4oHZ/8F7wgJnYyWdMXl/Eks4Ra7Mu4dZNhy/AMmvRM5zr9mK2tF8ZKvD6Her2wNMJvPL8EON0jsgut2NsYlRMje1uDCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717496816; c=relaxed/simple;
	bh=SCmrDJLlfFUjsJ3dWR7gUBYN+yUXdTLLuHtYi3S0eSU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FW9UYfb5klR1BcOHMt9hZPN3eN7GgBJM09OqKbb1/9boGUlA7X1DQ1tGDxMobGLUKuVDgcuPM5h8Cfof2R18tMeAwwK0iVczwthISC2G2OTYrA2J2IseiOAtQ4gqkkU5E6FBH1p8PBkdNafJ40FRIfD/ouHYc4zXdszIaeEJidI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FEyDRmSm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717496813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kY9Du9qgKfAUdeyHQjwhVARg02PI7WFxrxGmmFdBjw0=;
	b=FEyDRmSmfCK0MIYpCSbJmTKTlb1AkoEUSh0uy0m1UQYZa+Rr57WQONTRFN+A/QKB6KhboW
	nVt9Q4cN9maUipFGpDS2zoaodoH+3uLtCpCZTQXyxYDkNYU1iXAbLel/wSnJtpP6q6HaOV
	WklGFuwIjQFIuLSk7FuEcIFD1gFcpno=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-402-1JY2KilNOiWhle-ExWVNhg-1; Tue, 04 Jun 2024 06:26:52 -0400
X-MC-Unique: 1JY2KilNOiWhle-ExWVNhg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42133ebdf24so26581845e9.1
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 03:26:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717496811; x=1718101611;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kY9Du9qgKfAUdeyHQjwhVARg02PI7WFxrxGmmFdBjw0=;
        b=k1Ue6Uluhsk2Ijbs+jzfLAyRoEaU0Ef7N0rpXhfEGHlXAo3c8teZdcPRSUHDh6ugGq
         0Aatn6u+WPcrfA5Ag3fNRrAz0nkQ7O3XdzZk/e5bqRtnWwhOaDxuZSi/2l8T31OTTXl4
         9rK/mrTFMXY6NtgTv+K/hmhGvmdk61Vt4MxMhtIOVcM5Ke+ohqWL+4jD2ej9Y2mrS2ka
         SEhopCvGEclUCVJZeCJlBFx42FdKBs1Keh/E0BI4CrviWLiFdUmcqpby+6xkXC2XgDGD
         mUdfj5lvBlsBhZDyPrRkLYmUOeoIxFTFTl1qHefnUp1YAuuQDm4vtu732EJ/J71j/2qD
         lVWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUT2AZs24L0ytV8tWBfS1H3uHvmptD/ltPXnzVAPH/fF3NSZs4Fv+aHHBov8T+pkxDVI52Z4MJ8mTHKEnrhKI/0xx1J
X-Gm-Message-State: AOJu0YyFroifjC1YigIz7ge2/clqlWbOOmUV2xXQRlbaiI0tO1QCucv/
	JvE/FUqxFhqLvZfU9ffvaf6DaxNpDtzMQxOvPZzC+3iKHvYOjLNlXHvKd6x/SXDwGYsnvIWf2Qe
	qREQCF0EAyI+AbHNMciXhVlkjj9ylC8FpsBl7+LM7sxCZOJsmcg==
X-Received: by 2002:a05:600c:5113:b0:41b:f3b6:e5da with SMTP id 5b1f17b1804b1-4212e0c3fc1mr111662875e9.36.1717496811045;
        Tue, 04 Jun 2024 03:26:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+/orUCKtk46b1PVxJCj9U9qcI611YuDN7+DueJ9sIdtfYUKEX1W8KZiC6DxR7/U6KOxf8Vg==
X-Received: by 2002:a05:600c:5113:b0:41b:f3b6:e5da with SMTP id 5b1f17b1804b1-4212e0c3fc1mr111662765e9.36.1717496810672;
        Tue, 04 Jun 2024 03:26:50 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-178-97.web.vodafone.de. [109.43.178.97])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4212709d362sm180144245e9.33.2024.06.04.03.26.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 03:26:50 -0700 (PDT)
Message-ID: <d893a716-bea2-4e12-a02b-77271210a28a@redhat.com>
Date: Tue, 4 Jun 2024 12:26:48 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v9 26/31] powerpc: add usermode support
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-27-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240504122841.1177683-27-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/05/2024 14.28, Nicholas Piggin wrote:
> The biggest difficulty for user mode is MMU support. Otherwise it is
> a simple matter of setting and clearing MSR[PR] with rfid and sc
> respectively.
> 
> Some common harness operations will fail in usermode, so some workarounds
> are reqiured (e.g., puts() can't be used directly).
> 
> A usermode privileged instruction interrupt test is added.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---

Reviewed-by: Thomas Huth <thuth@redhat.com>



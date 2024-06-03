Return-Path: <kvm+bounces-18593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EC6C18D7ABE
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 06:23:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8179F1F2232A
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 04:23:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF61817BB9;
	Mon,  3 Jun 2024 04:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P4X/Gm40"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4509C10F1
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 04:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717388581; cv=none; b=dqQ6OjVFnI6rw69GQKcvFjJNytldF+IoO75lO3HXYsqtL3Xcq81xVbOZ2vig99sW6ttDXCutk+30Zf5fhaQ01EiyYpdhBVFZ2FZywi4C7kt7kRKFLao6AOWAT3Yc3miWiHt0rSVYwc4vsbJKyt++99SpnfwRN6kEQsdAxWFVfIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717388581; c=relaxed/simple;
	bh=NCgrPHR3Ob4bS3acki+oi3n7Q4EtHi6yaSOZgdq6r2s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ueg/k5C/S68e0CLG2y7OKuOP+loOSaF1xaOfepDCNqgivLIcxoPdMoG7jCrFtRH6bxyfZyNcVXWWTJ2q1oBmRqgOSwcx1wBc3drsZ9Rb54DYFLWK9wMR/JHa0bnlZDGZT17VQkNJfqOSIngxODmQ9LgOA/zSlCZZMJl9gj9u2VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P4X/Gm40; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717388579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qAlTeIMwPia5J6/6wUDU1wIcI4b48/gFdq+hpYwu+jM=;
	b=P4X/Gm40U23QVTrxuHAwolRSTT8ZYp7wfUJRSA84XQFurslQyVESTyBX71uGMZ5BwmcD/9
	4o8wR3faheFKPP7zLUBdHK7zoU2Mk4cAJkmX2BZMQdetVe6lgKGNmEf12zwkn9xd54C0ge
	C4OOD8UgeFeI0Jdv4D5lwdH5oUgKKVs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-279-iIL8cNJsN9Cv6O1ZI7iMtQ-1; Mon, 03 Jun 2024 00:22:55 -0400
X-MC-Unique: iIL8cNJsN9Cv6O1ZI7iMtQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4212e2a3a1bso16981305e9.3
        for <kvm@vger.kernel.org>; Sun, 02 Jun 2024 21:22:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717388574; x=1717993374;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qAlTeIMwPia5J6/6wUDU1wIcI4b48/gFdq+hpYwu+jM=;
        b=LVLmorGNsFIbnvNHujEaQWGgukoQ9qTlAN1BhQbYtuBokOvSCizcVT2NbjRFX9KxnY
         V5HCwwvPyECIQk2vxjtpiOSKoIeI+l3RBPBVS94LowoqdXOdFw/faHRoU8rutzXMDZh6
         FCItMzYYGNLCIvJwIW1aVKLAS3MrIR30AXXaAE5lNCQAa0huhFYNMT4yB6f00/i2zj2I
         I3eTQHh9obYo0RPzNZdFYLIFh8BtOvsIgkIxLAxHXJJsQie30zo24jH1ThNo5yEHXdne
         RUK3sy6fCzjJ8MXlSFgAPzewp9CCLFe2w61nHWv61uf79zU4l469Ti7QVKw4eIckK8bw
         CO4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXNbOfbxFUIRVvF72UHxgIrqvfwUvfQ1qv7IEXANfc8TBV2BxYoV2Xwh1GQrnwLfHrja1L9TA40DaOCrhr10D0T8WDl
X-Gm-Message-State: AOJu0YyB8SFQ9RCxtHRcD83lbPHFIXTW7TuPGVfbG6Du5IJFi17wAJm/
	AkHy0XYuT3CAsv3BXVf7uVw54Fay14HJOmbz26GKXjupfStrqe5VyqJdJECN+j/OdV6LnBsEcc/
	F1feV2Xw6SYVkxabO1STOdsXzeu/H07qTPr05dNrvJO+qJnd3JQ==
X-Received: by 2002:a05:600c:35c5:b0:41a:a4b1:c098 with SMTP id 5b1f17b1804b1-4212e076530mr64932915e9.19.1717388574105;
        Sun, 02 Jun 2024 21:22:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG5OSq90yUwL56YZSe4KZbA2XAv6+I6Y1lgds7Jx0t/sFuvlkMgbgXoho76tHMvXGw8pUhnsg==
X-Received: by 2002:a05:600c:35c5:b0:41a:a4b1:c098 with SMTP id 5b1f17b1804b1-4212e076530mr64932845e9.19.1717388573739;
        Sun, 02 Jun 2024 21:22:53 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-176-229.web.vodafone.de. [109.43.176.229])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4213c264714sm27405855e9.12.2024.06.02.21.22.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Jun 2024 21:22:53 -0700 (PDT)
Message-ID: <0149c5dc-ae3e-474f-b0f4-cdef4b3fa3b2@redhat.com>
Date: Mon, 3 Jun 2024 06:22:51 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 1/4] powerpc/sprs: Fix report_kfail call
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org
References: <20240602122559.118345-1-npiggin@gmail.com>
 <20240602122559.118345-2-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240602122559.118345-2-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/06/2024 14.25, Nicholas Piggin wrote:
> Parameters to report_kfail are wrong. String to bool conversion is not
> warned by gcc, and printf format did not catch it due to string variable
> being passed at the format location.
> 
> Fixes: 8f6290f0e6 ("powerpc/sprs: Specify SPRs with data rather than code")
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   powerpc/sprs.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/powerpc/sprs.c b/powerpc/sprs.c
> index de9e87a21..33872136d 100644
> --- a/powerpc/sprs.c
> +++ b/powerpc/sprs.c
> @@ -590,7 +590,7 @@ int main(int argc, char **argv)
>   
>   		if (sprs[i].width == 32 && !(before[i] >> 32) && !(after[i] >> 32)) {
>   			/* known failure KVM migration of CTRL */
> -			report_kfail(true && i == 136,
> +			report_kfail(i == 136, pass,
>   				"%-10s(%4d):\t        0x%08lx <==>         0x%08lx",
>   				sprs[i].name, i,
>   				before[i], after[i]);

Reviewed-by: Thomas Huth <thuth@redhat.com>



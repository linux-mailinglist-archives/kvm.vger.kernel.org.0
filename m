Return-Path: <kvm+bounces-23834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B7E0A94EA70
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 12:04:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EA231F228D1
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 10:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB2B116EB56;
	Mon, 12 Aug 2024 10:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YUWzAy/b"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8298B16EB4B
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 10:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723457063; cv=none; b=D3iZlGZ63qcYhgaTpTbZHi9P1YKr5DSZnljhn51OyAJaioCIViPbLqTt8fok3WrLRW4IVYOCYcXqIPR1VAwa/YI1szIQ1dpSDFQq5pOiBlzCM80lei0R1gAFGnBW5jI7/oN7g4Gyn+C5Xc0EMyncAQlIVK0ES3OJ7SaxcsVxqCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723457063; c=relaxed/simple;
	bh=FMhv9gR//hL+oW5Y92Px+f0x2+KYZGuRYJkizZjcMzQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q4tXajqKqD6CR4iTY6DeZsvdqqrRfwzohyfK3R2aCRmZ8A9sJFw8wskJvgX1G3/ZY0YwidSDe/4Rokln5FbWZFX+G4mPW6rmxeW0kOx4JEjhrbQJPdYqzcnjBJdejOkf8X+b4TdZl/dWYYy7bWio0HW2zP2wWzmo1WaqoP0S2fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YUWzAy/b; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723457060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WH+34UDAHX79Po2Yq7ExNVjTPxlkArwIEowUs+SryDk=;
	b=YUWzAy/bsLiJCql5oggu3PSSp6BgO2kilFrka9T7o+0z7Ph2fsKKf56Rh5SykcGHhTZCu9
	jBY63U8PeLz5GFCfsBHdg6W95kXssc5to9I2CibflglYtN3LiV6cqHEdb0C18c/UOw48WM
	WI0vWFzk401OZnVp4BLJBH6Iy7y+Gn8=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-5WZRAee_OLC3iOhV_bBt8A-1; Mon, 12 Aug 2024 06:04:19 -0400
X-MC-Unique: 5WZRAee_OLC3iOhV_bBt8A-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-52e9557e312so3286636e87.0
        for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 03:04:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723457058; x=1724061858;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WH+34UDAHX79Po2Yq7ExNVjTPxlkArwIEowUs+SryDk=;
        b=uK8ateWEalq+Kf0756/PMAAu4lkkvKUOTFb570L2cFMQrdXyWpgI4LIUYzMIcEPmPw
         vk0EVjBAmDnoHsoLNcKA1M9/O9PY2wtHXnS9IVC1ZuB0MV0b2bpGIAKRyWcaoXOqS901
         dhVFqfn2JJN45D6fJCBdOwoH3uZKSzTzH1uyloFqb4zX2p341VhJ049quVObho6tDPDL
         No1E7KwJdNaCA0YdYlJNsIeFfF9Xfhpp8HkOn5KUsAwHOsy/qFaVRKAlCtiQCinuhGSy
         wHfarHB+3C5Q6mDlSEnher2uSlfEK4b4mr3mmDmyiYmiDwt4BJHhBafcN8JQKYEdfomz
         fsaA==
X-Forwarded-Encrypted: i=1; AJvYcCVAZeFssZxy4zscYmPdOg1nAk7LAEmyjqrwjrXFn9ZWEZbP7p/2rJ/XJiIn484Bixc3jZKmexnGwAFCZa2+rIefMFu3
X-Gm-Message-State: AOJu0YzIEvYpEKnqiV7E336N2fYEUVhARj/IB3asASCB/oX2MjAmg985
	cr7qq0p0g5dBWx9EkiYz+y3EE59GraxLtOxFA9mwCGhyt63mYfBgn7eJck4WsV3dZgvrPK6DVuZ
	IA7V9cDvA7IDxb+VsgrUkUhNX9GVzxOkMSBTuezUUdhQ5EhimBw==
X-Received: by 2002:a05:6512:31c3:b0:52e:9ebe:7325 with SMTP id 2adb3069b0e04-530ee9958f5mr6282344e87.31.1723457057821;
        Mon, 12 Aug 2024 03:04:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFK+STVX8B0xyGRx+La+5znM6BFUq1kpM5Ysu0IPnW/eI+XUkLxbNRlUYjVBqeS0udHBDKzRQ==
X-Received: by 2002:a05:6512:31c3:b0:52e:9ebe:7325 with SMTP id 2adb3069b0e04-530ee9958f5mr6282294e87.31.1723457057213;
        Mon, 12 Aug 2024 03:04:17 -0700 (PDT)
Received: from [192.168.0.6] (ip-109-43-178-125.web.vodafone.de. [109.43.178.125])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5bd187f5671sm2009223a12.3.2024.08.12.03.04.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Aug 2024 03:04:16 -0700 (PDT)
Message-ID: <ae5f3a65-4cee-466b-aac4-ddd83c8fd1e5@redhat.com>
Date: Mon, 12 Aug 2024 12:04:13 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/18] tests/qapi-schema: Drop temporary 'prefix'
To: Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org
Cc: alex.williamson@redhat.com, andrew@codeconstruct.com.au,
 andrew@daynix.com, arei.gonglei@huawei.com, berrange@redhat.com,
 berto@igalia.com, borntraeger@linux.ibm.com, clg@kaod.org, david@redhat.com,
 den@openvz.org, eblake@redhat.com, eduardo@habkost.net,
 farman@linux.ibm.com, farosas@suse.de, hreitz@redhat.com,
 idryomov@gmail.com, iii@linux.ibm.com, jamin_lin@aspeedtech.com,
 jasowang@redhat.com, joel@jms.id.au, jsnow@redhat.com, kwolf@redhat.com,
 leetroy@gmail.com, marcandre.lureau@redhat.com, marcel.apfelbaum@gmail.com,
 michael.roth@amd.com, mst@redhat.com, mtosatti@redhat.com,
 nsg@linux.ibm.com, pasic@linux.ibm.com, pbonzini@redhat.com,
 peter.maydell@linaro.org, peterx@redhat.com, philmd@linaro.org,
 pizhenwei@bytedance.com, pl@dlhnet.de, richard.henderson@linaro.org,
 stefanha@redhat.com, steven_lee@aspeedtech.com, vsementsov@yandex-team.ru,
 wangyanan55@huawei.com, yuri.benditovich@daynix.com, zhao1.liu@intel.com,
 qemu-block@nongnu.org, qemu-arm@nongnu.org, qemu-s390x@nongnu.org,
 kvm@vger.kernel.org
References: <20240730081032.1246748-1-armbru@redhat.com>
 <20240730081032.1246748-3-armbru@redhat.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240730081032.1246748-3-armbru@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30/07/2024 10.10, Markus Armbruster wrote:
> Recent commit "qapi: Smarter camel_to_upper() to reduce need for
> 'prefix'" added a temporary 'prefix' to delay changing the generated
> code.
> 
> Revert it.  This changes TestUnionEnumA's generated enumeration
> constant prefix from TEST_UNION_ENUMA to TEST_UNION_ENUM_A.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>   tests/unit/test-qobject-input-visitor.c  | 4 ++--
>   tests/unit/test-qobject-output-visitor.c | 4 ++--
>   tests/qapi-schema/qapi-schema-test.json  | 1 -
>   tests/qapi-schema/qapi-schema-test.out   | 1 -
>   4 files changed, 4 insertions(+), 6 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>




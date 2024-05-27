Return-Path: <kvm+bounces-18163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36AB88CF92F
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 08:33:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1F77281E68
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 06:33:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EFE017BCC;
	Mon, 27 May 2024 06:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NSia9qzI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE50817BA9
	for <kvm@vger.kernel.org>; Mon, 27 May 2024 06:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716791591; cv=none; b=bN67oKEpekLbSJSH29AHohT36mpL1R8yRhL7CJkk6jjw6Fmwjgqz5V2qKBZTCgMHS3s/34bzH65PmVCaCO6wqc2e71p67++qpd8zgWsS3uxzf5p2OaNhyRhu0v3ZIhRIfQK/OwJCPiiO2m4Zq3xfXVRkfv5fJvMeOQFlMlMluXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716791591; c=relaxed/simple;
	bh=M+/HxTM8EavQdtD/WLYGJcaXWspwpNl1FutT3scizKQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DDXEHy4Mf5yJzIkDGf3JSGqTF28GLe+iTUsUxJJBP5w5tHX/NNtUazbeNyIvPCzkeDbdazBza5OiBSUwAZn5HXprSSolMxH/cx8/MfHxvT8hai/9lVG6WOnREP8NmumIle0kXG18XMGZQSaSO5uhlkRBtVj7P26nZFJrr8hoRF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NSia9qzI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716791588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KNlseLgFUu+dL9phtmwaSdB3EyvVGSX1tvDvz/FKi+E=;
	b=NSia9qzIQsm5VzGDu7UKjGMbPDSVTNMo0NI2R0baeBWbClTKu8bFo7/GybkGwTX2ZlfY+8
	DKfVrSJFFGachfFTEiKaQcDNdWLA7dMomRAu/EIXLEKGIjzdEJdMro9kUqdo15V6HS4DsY
	3rKxbEwcksUvc6gGLxp9QD+cGqgShGs=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648--JZV9lmuM6O41CHGy3J8KA-1; Mon, 27 May 2024 02:33:04 -0400
X-MC-Unique: -JZV9lmuM6O41CHGy3J8KA-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-529aa3f32ecso773457e87.1
        for <kvm@vger.kernel.org>; Sun, 26 May 2024 23:33:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716791583; x=1717396383;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KNlseLgFUu+dL9phtmwaSdB3EyvVGSX1tvDvz/FKi+E=;
        b=gANg+ulqTc1LgneqmwIYv9zd4dbHoE1GE66FqSjubgbJzpqryjuHeT8c/WW4Yqm4G8
         ZUd60znSjMq2GrcQfQwGjz3yC8mi5Cu0CjOrthK+GbGDJpd02P8eh8CH4gTTznCOOBUq
         MT7BuZOQgA4tLu6Imkfhxd/Kq4CZov9r2k9JnhrgXoNHXipGTnq2yGn6+Ev3uR3xSJc+
         oD5gf/vxw8f1BZvYyftzRdOXrkC2+jLcLQKTOyajqJNnW1rVI/SCgLz8tWNmGrABq8n7
         KzyCim7ssaMHIEIByCnplNRQVnDkiwTqUbb8nyyTFJ25oa92Kv/AeoTuGfGEqk1f4sF1
         jAmg==
X-Forwarded-Encrypted: i=1; AJvYcCWblp4wZJ1atmbWpekXsQRO50ZHrR6vONOXhUcdDBY0AQyq4bv6QlliI69iolguDfZ/TWydvBALFEM/PYFVIyj7HMtH
X-Gm-Message-State: AOJu0YymFoR1mZkIlsZouPw1OHwh2h+45QWf+yjgwNEaUJsw7wO3OI6S
	aLgIcNN8/0j3BfTYDLKyJcxzE8YR1tuNflHgxnbHyEKZIfxFw7XptEC0iLlyKvZyMyH7eyE0Kyg
	jN8dK3CMB6ldyQVAmAq/amyL02cj/fWd3kPKfOXfKO59WdDtC1Q==
X-Received: by 2002:a05:6512:526:b0:51b:567e:7ea4 with SMTP id 2adb3069b0e04-52964bb2673mr4629924e87.26.1716791583457;
        Sun, 26 May 2024 23:33:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHi6QfLB5ew1LK+ePAd1/DqvUBt6yTnf31Itsov+cBL2BGvIAXphymV8jdWU0ZhdRjpfDo5hw==
X-Received: by 2002:a05:6512:526:b0:51b:567e:7ea4 with SMTP id 2adb3069b0e04-52964bb2673mr4629908e87.26.1716791582954;
        Sun, 26 May 2024 23:33:02 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-179-90.web.vodafone.de. [109.43.179.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4210896fc8asm97698005e9.13.2024.05.26.23.33.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 May 2024 23:33:02 -0700 (PDT)
Message-ID: <dd42e2c0-622f-42b5-b94b-df7be07f4733@redhat.com>
Date: Mon, 27 May 2024 08:33:00 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/8] scripts/update-linux-headers: Copy setup_data.h to
 correct directory
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas@t-8ch.de>,
 "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Laurent Vivier <lvivier@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org, Alejandro Jimenez
 <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org
References: <20240527-pvpanic-shutdown-v8-0-5a28ec02558b@t-8ch.de>
 <20240527-pvpanic-shutdown-v8-1-5a28ec02558b@t-8ch.de>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240527-pvpanic-shutdown-v8-1-5a28ec02558b@t-8ch.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 27/05/2024 08.27, Thomas Weißschuh wrote:
> Add the missing "include/" path component, so the files ends up in the
> correct place like the other headers.
> 
> Fixes: 66210a1a30f2 ("scripts/update-linux-headers: Add setup_data.h to import list")
> Signed-off-by: Thomas Weißschuh <thomas@t-8ch.de>
> ---
>   scripts/update-linux-headers.sh | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/update-linux-headers.sh b/scripts/update-linux-headers.sh
> index 8963c391895f..a148793bd569 100755
> --- a/scripts/update-linux-headers.sh
> +++ b/scripts/update-linux-headers.sh
> @@ -158,7 +158,7 @@ for arch in $ARCHLIST; do
>           cp_portable "$hdrdir/bootparam.h" \
>                       "$output/include/standard-headers/asm-$arch"
>           cp_portable "$hdrdir/include/asm/setup_data.h" \
> -                    "$output/standard-headers/asm-x86"
> +                    "$output/include/standard-headers/asm-x86"

I just ran into the same issue!

Reviewed-by: Thomas Huth <thuth@redhat.com>



Return-Path: <kvm+bounces-10625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65B6886E001
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 12:16:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CC811C20AD5
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 11:16:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F31146BFC6;
	Fri,  1 Mar 2024 11:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dBZD9FJG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A205D23BD
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 11:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709291769; cv=none; b=hE5rgktu0k8JG14YzG7QGPmTpvF0kXGDxDIzrxzJZcYOO2uN9aK1TrahniskIY65mTuyKC+YQ6rmqkB8DCB7sIIrjNVL0O1yYmZP2MvmBF0n0/xXDxS7iuFIV7t8KsO/cKKbbIUzQNmtOcdCfyRuZPdeoMV6UJ1+O8dRdlwjbDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709291769; c=relaxed/simple;
	bh=QRkyqV3BpGvP77PNRBUdvlPtk3cr8zXG2tzni/ygQCo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=APGFHo22WUe+bPtw445X3siEDLpIs0WqHp/3W/UodBy58if0ut1SQTpO0Vg3YG8s6YTBOmgIkYIeIFsisJF5YeXxTB98QKoMnNESkEosHFUkRBGZJfo6+F4S7Uh+c6t4ipGS0lajqEHHus/0jQ8WaAGkf1uXvVxFLppHxAX1wA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dBZD9FJG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709291766;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hz2gVlDx8rmyr1wJjekvfluZY3NlkxY6GUZj6+XbcUk=;
	b=dBZD9FJGaT9EjynE9lwm9xTRCG7mPBySK8JfHTFzf7oXYxBNuKu/AMm1aYAVdHcg/LE0V0
	DRM/qZMQiUdbY3Y9kSJpU3vmNC4csZM8XWiR3JnoBPaxBkQMz7CdREjc0i+LC3KJ7X6dY5
	GkwtcKKaS+4cInYNwiRCw4XiLJuA7QM=
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com
 [209.85.221.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-eR0OoXtUPzyl0mtRYzub8Q-1; Fri, 01 Mar 2024 06:16:05 -0500
X-MC-Unique: eR0OoXtUPzyl0mtRYzub8Q-1
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-4b92015b9dcso1143708e0c.2
        for <kvm@vger.kernel.org>; Fri, 01 Mar 2024 03:16:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709291764; x=1709896564;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hz2gVlDx8rmyr1wJjekvfluZY3NlkxY6GUZj6+XbcUk=;
        b=fUjK7mkngCVwLrx6GiRlNWV8znHZhwJnqRCghI66+0xox8YBut7xOLHbI0di9mhxoL
         5PAvOndFQzewlAO7W6vFLf7BHRZN1KwDhC1AJO9SVZlja7+qb0qtp9bnyGSeenD32Mld
         FwnTkGtYkSsKHB791YxYE6RJdxcbmuhuioiqg6Eh+ahu/ISHd2cgsTPEAiPrsvYckSbS
         F+aVK92Y+pYqKFveS+z3flvhw9CV5K0q6dgkzaCFB0F2ERKsIJj3Rey5ecZkIPe8okcE
         V5nxjv3ZTprJWMkrQw3K+xnrMuw5BRzByAC61EeMhrmHGMMGFMVL6ihvBl5TZw0TQTPg
         Hvcw==
X-Forwarded-Encrypted: i=1; AJvYcCX0GSxo6vP9u8lSBRvdhCx5q+vlIhrJuBQG0vv8H+qY7OVk/ZwUBRo3s5ikz7Azi+9MB1zHDB5hw1xXsWdHAhqKnqI0
X-Gm-Message-State: AOJu0YwQcDgM5Rcp2T+Prj8KOgheBPBpln/bBpAKGbunZawTFznceJyw
	qRiKc06ECzrPf0eGC45wQcI9KN0Yk5ykVa23FpXa+JWL+NbmbWGO7bh06bBMAnmxH7+ZPHyjudF
	qUGLHfostfZ8+IlKWotoI2Mgys2ACsgaWLuLdmPpqb/eHWW/ZIg==
X-Received: by 2002:a05:6122:459a:b0:4c8:8025:f451 with SMTP id de26-20020a056122459a00b004c88025f451mr1112229vkb.12.1709291764753;
        Fri, 01 Mar 2024 03:16:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEBgzNPag+mP+cbaorJIWf/mWEgMxVtHFiHVO5YW298gVYpDpwwcQws5mdd100h5uHBRc/CTg==
X-Received: by 2002:a05:6122:459a:b0:4c8:8025:f451 with SMTP id de26-20020a056122459a00b004c88025f451mr1112216vkb.12.1709291764457;
        Fri, 01 Mar 2024 03:16:04 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-133.web.vodafone.de. [109.43.178.133])
        by smtp.gmail.com with ESMTPSA id f14-20020a05622a1a0e00b0042e1950d591sm1601473qtb.70.2024.03.01.03.16.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Mar 2024 03:16:04 -0800 (PST)
Message-ID: <04e976cc-0239-4ee9-b0d2-cfdebbc4c3d9@redhat.com>
Date: Fri, 1 Mar 2024 12:15:59 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 07/32] powerpc/sprs: Don't fail changed
 SPRs that are used by the test harness
Content-Language: en-US
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 Joel Stanley <joel@jms.id.au>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org
References: <20240226101218.1472843-1-npiggin@gmail.com>
 <20240226101218.1472843-8-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240226101218.1472843-8-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26/02/2024 11.11, Nicholas Piggin wrote:
> SPRs annotated with SPR_HARNESS can change between consecutive reads
> because the test harness code has changed them. Avoid failing the
> test in this case.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   powerpc/sprs.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/powerpc/sprs.c b/powerpc/sprs.c
> index 8253ea971..44edd0d7b 100644
> --- a/powerpc/sprs.c
> +++ b/powerpc/sprs.c
> @@ -563,7 +563,7 @@ int main(int argc, char **argv)
>   			if (before[i] >> 32)
>   				pass = false;
>   		}
> -		if (!(sprs[i].type & SPR_ASYNC) && (before[i] != after[i]))
> +		if (!(sprs[i].type & (SPR_HARNESS|SPR_ASYNC)) && (before[i] != after[i]))
>   			pass = false;
>   
>   		if (sprs[i].width == 32 && !(before[i] >> 32) && !(after[i] >> 32))

I guess you could also squash this into the previous patch (to avoid 
problems with bisecting later?) ...

Anyway:
Reviewed-by: Thomas Huth <thuth@redhat.com>



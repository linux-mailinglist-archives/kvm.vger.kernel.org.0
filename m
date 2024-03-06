Return-Path: <kvm+bounces-11155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D268873BCC
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:13:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3829C289864
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 16:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D440136987;
	Wed,  6 Mar 2024 16:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YEKpVTmq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6501361DC
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 16:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709741626; cv=none; b=F18JHLEc6UW3/kTLnkfn4oTqFET1AD6vDI39bmx74NkOuBliOXrbXSOzAev3v00dkLMr4QAVaoVnXhoM+LmdP3QRAowbPjCn6jsUiGr9dWRsckWfMN27Ijzu+0JgHXUUHx592izgxQ5cecvZrWuPq+NS8ezaIsUcYHramfu9aBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709741626; c=relaxed/simple;
	bh=ao0BFktZBKioeT8PNX6f6jX+eCwQCtDJEOmL5xL/Os8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sK8MeoqzRXtP/bvGVxB5vOmhBnm/Ps3S+G8XAWKp9fhKII7MFm+P8o8nGO60GEg1D13lYt6iVvlAbJxIPtGE6WoSR895KYz3iJJ/px32h1mMgNQH7EL2BxUNeF653Frjr2JraQHFZ5xi37KWsAiqRr5yyQAiQIPVP5g2/Qa8ICg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YEKpVTmq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709741624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6K78E5CJ8XYBJ62d0iTJb93ffVkVG6PjNuvwW4+SJIA=;
	b=YEKpVTmqXM5rkmeM+vvF1ISsla1kfDqsaPOYpNgiXjwKYW0Fhrl+9kk7OLnt8tRAWDQsl0
	JB+k9Ni6I/nGIg1z+M6gJhPJoWOWPjcM9VaO4lX/L8/ToQD3w+wdUhkHCFc8MzgqdSHlXi
	Aktilz0VIjxxpQ4dEMh2bTE/98y4+eU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-zpn1LFG_Nua-rgjEZyAifw-1; Wed, 06 Mar 2024 11:13:43 -0500
X-MC-Unique: zpn1LFG_Nua-rgjEZyAifw-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a45c8ceb9e8so1428066b.1
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 08:13:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709741622; x=1710346422;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6K78E5CJ8XYBJ62d0iTJb93ffVkVG6PjNuvwW4+SJIA=;
        b=KCmPSgXRMzNJ8HIhynnXa1kncjrtpF5cPNitBvcdihMpIYc1V1IzSbGJxOiSut4Mh6
         W2rVEWE3+iWvzAuOq7S+k2buaW9w5QrSa25EVOKJX5uOZEinys5vaLbu29AkN24IszYs
         i7IqrY+y4zAHWVqSSuoMEbhsxmDK5WqSELs5ByDp7/Dih8XbGa13qC/7SklnVBbouKnw
         b6atRBGptDN6weMDg57LMEpddwHKD2hAP0eBfYv3moYprByg37XUDOCr4IxUfxyQFFVh
         y7z5W4FCj5mRjRfrjyTqwLj0MuFYI/EC6gPYPjAt846M6Bi6aKseEGZX0otbTeUJ7RZv
         /anQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9bkomfr2iKHTCnBxb/2aYI05B3StKo+lVY8axi/RDQdJ43pDMpngHmwXfWuLNbTLSqv6rYWwUBvs4O64Mw2AM69id
X-Gm-Message-State: AOJu0YwS3GlNOlFWp5x0L2Hh8QO11m7NUMWqURuvjCmn37A7oOU7bKmJ
	U0D/WmKw9E6u4NbHNWWWhtFbhgQw7IDa4lQckSSfgcjrPzLXPG5F8UNI8mYD0u01i7is+7tihIN
	5WfJWp7OtlLmqt5twUA0hUBr1TYq//J3Ur3obp+4KQkMEwJ+kPYgS69TARA==
X-Received: by 2002:a17:906:f35b:b0:a43:fb64:e21d with SMTP id hg27-20020a170906f35b00b00a43fb64e21dmr12384752ejb.7.1709741621901;
        Wed, 06 Mar 2024 08:13:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHiWjEHgK0IYqRr7i7DPAFD6wlJCz9StafWJINimzFWi31F6pYAFN+xUh7QSOHjc8ae5Zk5Mg==
X-Received: by 2002:a17:906:f35b:b0:a43:fb64:e21d with SMTP id hg27-20020a170906f35b00b00a43fb64e21dmr12384735ejb.7.1709741621578;
        Wed, 06 Mar 2024 08:13:41 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-151.web.vodafone.de. [109.43.178.151])
        by smtp.gmail.com with ESMTPSA id lm7-20020a170906980700b00a449fdfe27bsm5976048ejb.170.2024.03.06.08.13.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 08:13:41 -0800 (PST)
Message-ID: <de2b989f-a44b-4634-9ace-f8d961f903f4@redhat.com>
Date: Wed, 6 Mar 2024 17:13:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.1 03/18] hw/usb/hcd-xhci: Remove
 XHCI_FLAG_FORCE_PCIE_ENDCAP flag
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Igor Mammedov <imammedo@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, kvm@vger.kernel.org,
 Marcelo Tosatti <mtosatti@redhat.com>, devel@lists.libvirt.org,
 David Hildenbrand <david@redhat.com>, Ani Sinha <anisinha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>
References: <20240305134221.30924-1-philmd@linaro.org>
 <20240305134221.30924-4-philmd@linaro.org>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240305134221.30924-4-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 05/03/2024 14.42, Philippe Mathieu-Daudé wrote:
> XHCI_FLAG_FORCE_PCIE_ENDCAP was only used by the
> pc-i440fx-2.0 machine, which got removed. Remove it
> and simplify usb_xhci_pci_realize().
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   hw/usb/hcd-xhci.h     | 1 -
>   hw/usb/hcd-xhci-nec.c | 2 --
>   hw/usb/hcd-xhci-pci.c | 3 +--
>   3 files changed, 1 insertion(+), 5 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>



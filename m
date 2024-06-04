Return-Path: <kvm+bounces-18714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA6158FA9D0
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 07:15:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94ECC28E32D
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 05:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA46A13DDBA;
	Tue,  4 Jun 2024 05:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bpl/QkdM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A66413DBAA
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 05:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717478090; cv=none; b=aCMWK2IrpG1tm07hRTuG+9W78U45cK7I7RefNcisVMxS9NFG//TKlmySq7bkQV25TmN+66J484euNKpLur6if/vZq1kD6/OKDVyfD1emw4iqZhy/D/o8G27YfXfpZjddDqU6CkAEa5KQnt2r9o49HiHSy56Gduio2YnNlqCMapc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717478090; c=relaxed/simple;
	bh=THxdGleHkrLLht/CM1g/ZC8zPjxLlyyuAZ8Lf7THhks=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GqjejN/ML1SWXJznX+YMhW67QYV2G1oUfkZCQbE0kpp9ZHGIH+yEuSvw+wbWstkDg9aligjyW0mrsCzSWo1pGl68JSmUdBtYCHrQjjdCckozUnCFgi7fRzozvyhHEr/Y3ZKh82SgZYPK63TmBcEhk7C5UF6iN3mLGD9iFB0l/t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bpl/QkdM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717478087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kStgNUlwxbTa4YCTYJ5zuzRi1YAJ7VZ5qO1Uor7dBsQ=;
	b=bpl/QkdMkGKNmK/TCB+jc2YMleHPxaq93t7irARRBufc+PsA9MEJFq4497qnwFpqgm348t
	mY3lWDr448hB+Vf4J8DZEQtkwYxTNYYLlH0ayYNA0unHCcGQyPaXbXyb3+4NU0XGIfymtR
	HYu8NWlZPVnVqIC4ltlCt/+6qSLTQxs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-644-krDAy6-BNTat6XlaKsQSNg-1; Tue, 04 Jun 2024 01:14:45 -0400
X-MC-Unique: krDAy6-BNTat6XlaKsQSNg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-35dcb574515so434581f8f.0
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 22:14:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717478084; x=1718082884;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kStgNUlwxbTa4YCTYJ5zuzRi1YAJ7VZ5qO1Uor7dBsQ=;
        b=sOU4RyihY03QPMOyOXJn+SHMqEz8qw9FzRrqtG0G0X1VI/ZFTTzD1nux4EK9sOcKzK
         sQ0DaF9A7K0+OL+NULDhUmB80zX9effDUEf0AeEElvQaKqPv5AAWT6EJiE/otsiIzKEV
         KUYj/OuC92fbfh0PXLtzwHD6PnA+iNobm86SGAh4dklxE34qz0smWvHaqj4IWY4DX39B
         cx30QnkyqkzBLjvySix8wonA4yp2/JoWFqyN9PldWJVxTFUe6uhjeMnTQHXQJEOCFOsu
         5I5vTZetvsi5WPgNHLwUb4uhvGME+cSCRx1hf4mt7Bwr4SybYjEHc4ULLWtVznm4CYEb
         U7yA==
X-Forwarded-Encrypted: i=1; AJvYcCUfIouvFvU+J9ojqY6Th3kGbZZOnf+F86am15Bwaf9yRojTcErNLuZql72AiYCVnM7MS7B0QG823h0652WR+q0PdOXK
X-Gm-Message-State: AOJu0Yyxn2lLTDPLKkT78biDgIbK6zWr9F4GazUbjkaElon9H/oj1XMC
	4e69x1ky2ulbmzp5/wuT+Ov/+6DiKr/+ocTRQx07cxabYE6gfjT0P6+Y4L+fKcYYiOqboNVaGcO
	YmcisWO+5z/Y1Adxp2VFEdyCZVIWyzahBrhuIMBNIOns6ytNGDA==
X-Received: by 2002:a05:6000:1281:b0:354:df8e:d72b with SMTP id ffacd0b85a97d-35e0f271598mr8542688f8f.21.1717478084528;
        Mon, 03 Jun 2024 22:14:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGh8tKFfZdnDFBcZvr/SEuFGJDBUAbOUzKGNI7IVcZaUv1MqjgxQ4B30mVv1leLkRcI3pAm5g==
X-Received: by 2002:a05:6000:1281:b0:354:df8e:d72b with SMTP id ffacd0b85a97d-35e0f271598mr8542677f8f.21.1717478084161;
        Mon, 03 Jun 2024 22:14:44 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-178-97.web.vodafone.de. [109.43.178.97])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35e5260d400sm6564120f8f.77.2024.06.03.22.14.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 22:14:43 -0700 (PDT)
Message-ID: <f1a7b4e0-5349-40d4-8f54-2861de7a3587@redhat.com>
Date: Tue, 4 Jun 2024 07:14:42 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v9 16/31] powerpc: add SMP and IPI support
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-17-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240504122841.1177683-17-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/05/2024 14.28, Nicholas Piggin wrote:
> powerpc SMP support is very primitive and does not set up a first-class
> runtime environment for secondary CPUs.
> 
> This reworks SMP support, and provides a complete C and harness
> environment for the secondaries, including interrupt handling, as well
> as IPI support.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

I now skimmed through the patch and it looks fine so far:

Acked-by: Thomas Huth <thuth@redhat.com>



Return-Path: <kvm+bounces-18878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 05FF78FC964
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 12:51:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7BDE51F240DD
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 10:51:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B5D219147E;
	Wed,  5 Jun 2024 10:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hDmS+kcp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E4414C5A0
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 10:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717584670; cv=none; b=fyPnFIIPDJVmzbbqjXmgGI67fFh3YiE0RPnuzJDg/+wtjARwpQNP/xAqCidW5hq42PIRT3UGF8dwV72/7jlWaOercoeYRffn1uPKH0uiGgkpwYF+OaNdW3fRR3n89fzaawvF9hqkqTbVXh+I1Ma78Htso3CMuThSCO5SRLkGto8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717584670; c=relaxed/simple;
	bh=N7OUHxkbaqGSOkOBW3IJxysQZ7AuxQlbOVhukVA0PYg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kkbKT7qeNbxAIJy/WcZcU72Uk2d9HK/Y1Wr9p8ExaD7NwR2fUGWuQ4SrDo/e7w337IhsYAJe2SQgfma5hSW3DyEde/Dg5wM+rE13lDUQMmt/wlNG8uFLP/2cjSOJnbb3Iyiyo13IfAAIm9ibcS2H2lhGOJbjxi/ZyEE/76zoCqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hDmS+kcp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717584667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yNzCmHN9efYU5ImS6ytW/l9Nw3kJTGbSptd2fOgTkHs=;
	b=hDmS+kcpYtkFqKq31HlNqLMREM+ADyptHmV0h10uIWhHqObiaLr9CesyTXYLSXOJ2Wh1iM
	emeXhdhFZoBjjfAptgIuxWV+kDqWvdKQZSo/VJC+DGVvM1Vb6cmjbX2ebG2TXDKke9voD2
	oscHlqMqaS7pMKz2tEqxHRrCORxy5iY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-686-Bk9bR1TNNBK7MVwm-6SLsg-1; Wed, 05 Jun 2024 06:51:06 -0400
X-MC-Unique: Bk9bR1TNNBK7MVwm-6SLsg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-35dcd39c6ebso480335f8f.1
        for <kvm@vger.kernel.org>; Wed, 05 Jun 2024 03:51:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717584665; x=1718189465;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yNzCmHN9efYU5ImS6ytW/l9Nw3kJTGbSptd2fOgTkHs=;
        b=kmEM+mRPGBDAXq1h/mHHeYN9SOdKjBC/NGkyiLPnmoqqC3lJkOfFQj4mjSwymW9PCP
         iJc0H3D36vannAZr53sNHdYG4HRRVnYh4FYD1CMPKiN96fqFhtIKxBRcP9o73MDsi5U6
         XPNH4++kbBJLn6cc423Os9xcHtxTvW94FiC4XMFwh7pSa8VaJ7CK8jhpEYo3pC65UUKL
         5niUQrgukFr4bwLaCyJEullJVoQPNP1uLb0bsm2aw+fLn5CFW1hj3Nkjo3rBkCLSWVT8
         c7ZoUWgDUNiP5D5YLAMSttN5coDrLC2yFCQQL6fTVj3FZB2NRKYe7/RtxRvwGbMQL4gN
         QuDA==
X-Forwarded-Encrypted: i=1; AJvYcCXaO7feSG6feJMYS+Grhm5TZZKrxvj4yx4VLgNyhpXqRHtE1v3gdtxR9aAyLPe/vb8xHI4pMaOghSzaU6G3ktzTxrt1
X-Gm-Message-State: AOJu0Yy66jDzQkEU7G3JpHrYty8Mbob+7VYgyZZCfCcyM8Am5kA5nFWo
	KmRp7Kdr0RdIeDcCDmCvGFACmL1miKU/YNcnGByoUQT8xJRnrQyQe9u2zhCzWTh89GDVzf/PiXf
	E9HljKQT1CYVLWuotyXTfArYgW18jcCQIcmvlwwUNicV4Y7hbsg==
X-Received: by 2002:adf:f1c8:0:b0:351:ce05:7a33 with SMTP id ffacd0b85a97d-35e839d4fe1mr1962606f8f.24.1717584665414;
        Wed, 05 Jun 2024 03:51:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEzfmLJB5CeS1IWMdsa3QcUKN1qgX4O++ksiOjCAjkZ2uSiC0IMQk9pin/l3TJCfquyTVrSyw==
X-Received: by 2002:adf:f1c8:0:b0:351:ce05:7a33 with SMTP id ffacd0b85a97d-35e839d4fe1mr1962588f8f.24.1717584665002;
        Wed, 05 Jun 2024 03:51:05 -0700 (PDT)
Received: from [10.33.192.191] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35dd0667366sm14048513f8f.111.2024.06.05.03.51.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 03:51:04 -0700 (PDT)
Message-ID: <965f4c82-d85c-441f-b033-abb768d797fb@redhat.com>
Date: Wed, 5 Jun 2024 12:51:04 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 0/2] misc docs/build/CI improvements
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org
References: <20240605080942.7675-1-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240605080942.7675-1-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/06/2024 10.09, Nicholas Piggin wrote:
> This just tidies up the two outstanding patches from this series
> (fix the wording of the migration group documetation, and make the
> artifact when: always comment a bit more understandable).
> 
> Thanks,
> Nick
> 
> Nicholas Piggin (2):
>    doc: update unittests doc
>    gitlab-ci: Always save artifacts
> 
>   .gitlab-ci.yml     |  4 ++++
>   docs/unittests.txt | 11 ++++++++---
>   2 files changed, 12 insertions(+), 3 deletions(-)

Thanks, merged now!

  Thomas




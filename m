Return-Path: <kvm+bounces-14228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0F2B8A0B1B
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 10:25:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9384E2882C5
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 08:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60F7614263A;
	Thu, 11 Apr 2024 08:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JOxzhU/n"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B24C1422CE
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 08:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712823873; cv=none; b=nsTk8VCU56FWsI1t7zUG94hcfFerp8wC2TR2R8Q0N8wmvHieElpd50Re00vGtwvu2BfvFRU00bPzur3/Scy2jHAbalNWMyAWi4f9bp9vC2q50vR2nm4IZmlrWVsQUCy1e/QWaDNVp7PD0X+t78JRKi3F0io29T2eikRzC1ePiI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712823873; c=relaxed/simple;
	bh=far60FsTiaR8mPNecCMBcens+25r/eOEIzzuoajX794=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p4vlgWQNxkMACj9ko1qmnjch4NQanS+pWW34LnwR59ycXB4oJvjTrCF8dwSiOVfSFcvdz3Dt20rzTrk9QiHa0qhzynKqtHQfhPXMxiS+L/a53Y/LYfQ2rC7mQW1sTYDYddRUmF3TQUyg+SMX2iEuc6ejWQFcVqozQqnX5IG5OZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JOxzhU/n; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712823868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5IDmeRuawGevC7/GQWPB5FuCfnPYvWswKNlISqm/crQ=;
	b=JOxzhU/nzOuGEEy8NDpKRA9gyPKtjbvbvU/Jg1Q97vItgUvPKPurwXMYIdFqOajC0u9U1F
	f3Ei36vOVFumER23CvQ3rrG1AFdWVFO3osMZbt4f8boTRhNOcSGiueazYPe9LEbWVJiJGB
	pBkxpyjoztOqYOpc5ojfxT71LYEU8gQ=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-s0ZV5ERDND2FmfENktIX_g-1; Thu, 11 Apr 2024 04:24:26 -0400
X-MC-Unique: s0ZV5ERDND2FmfENktIX_g-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-516d754664dso4605672e87.0
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 01:24:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712823865; x=1713428665;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5IDmeRuawGevC7/GQWPB5FuCfnPYvWswKNlISqm/crQ=;
        b=E0W4ebXN3WFCUqNHdsBIK9yZCGFamQoQBqqOxag+jdSn8QLye+TReWbECW2nPzCRgw
         L+lhkeX2aDSSTj2Be8+EAFul7ZXqJBdUGj9zQINX468rCglU80zU5SIDuuH+K7PaJ1ZI
         PuMVxbAhvzQE3fs4/OniKgeFd8msLAuMc+bp7QcaBZAAySevRn72ZUaWX48BWXzAClrr
         wTIHUcMqNMx19mJhhZC2SAI7HUphsx7UTKilxX+BwHDcVd31WIGBwSv8BJhCQ9cmmpNt
         T5WIP9muL+1Po1+AgULQIrNYMVBI8H39Mn2e858TxtCkKd+da1MdNfT9XATn+IFWPDhw
         CCrw==
X-Forwarded-Encrypted: i=1; AJvYcCXu3tjaJaomSBwBHXwMLrRvO6tfwppcfVmnpcDtE+5ox5SHcaXOJ5HxppicmNvpbgrG74GOwhdUvR+gRH6t9kqjOlYs
X-Gm-Message-State: AOJu0Yxh67clKHDu1m58Ivkaqp5ubN47qGzbsoHk/Qf9Sku8Cj2r4Hv5
	wol42sq0NPxT3bFDwdz3vaN0eGqu/ZAyd/WwVPrmnoEO/YKOcexSb5el2k1NqiYLIgb4mSsUczb
	qt68/b8yKk4tigGhFXG6MCUcGWg4QnfZF2TnS9HyHEPLU2DQYAQ==
X-Received: by 2002:a05:6512:3d94:b0:513:cf75:2ccc with SMTP id k20-20020a0565123d9400b00513cf752cccmr5011776lfv.0.1712823865347;
        Thu, 11 Apr 2024 01:24:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEV4c89duT4DE+mZDEx6uhdNJiRs/GUGp7wbno9F366OQyIfJ2TLr0kWI//codLOQuWvMvDpw==
X-Received: by 2002:a05:6512:3d94:b0:513:cf75:2ccc with SMTP id k20-20020a0565123d9400b00513cf752cccmr5011752lfv.0.1712823864930;
        Thu, 11 Apr 2024 01:24:24 -0700 (PDT)
Received: from ?IPV6:2003:cb:c724:4300:430f:1c83:1abc:1d66? (p200300cbc7244300430f1c831abc1d66.dip0.t-ipconnect.de. [2003:cb:c724:4300:430f:1c83:1abc:1d66])
        by smtp.gmail.com with ESMTPSA id u7-20020adfeb47000000b0033ec9ddc638sm1194154wrn.31.2024.04.11.01.24.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Apr 2024 01:24:24 -0700 (PDT)
Message-ID: <63f39394-380a-4817-8d5b-f5d468b0092e@redhat.com>
Date: Thu, 11 Apr 2024 10:24:23 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/5] s390/uv: don't call wait_on_page_writeback()
 without a reference
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org, kvm@vger.kernel.org,
 Matthew Wilcox <willy@infradead.org>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Thomas Huth <thuth@redhat.com>
References: <20240404163642.1125529-1-david@redhat.com>
 <20240404163642.1125529-2-david@redhat.com>
 <20240410192128.2ad60f9b@p-imbrenda>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240410192128.2ad60f9b@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10.04.24 19:21, Claudio Imbrenda wrote:
> Reviewed-by: Claudio Imbrenda<imbrenda@linux.ibm.com>

Thanks! I'll rebase this series on top of the s390/features tree for 
now, where Willy's cleanups already reside.

If maintainers want to have that fix first, I can send it out with 
Willy's patches rebased on this fix. Whatever people prefer.

-- 
Cheers,

David / dhildenb



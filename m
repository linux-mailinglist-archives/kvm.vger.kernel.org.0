Return-Path: <kvm+bounces-22927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62473944896
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:36:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85A4C1C21096
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 384B9170A28;
	Thu,  1 Aug 2024 09:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WRSdpF5n"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0307515252D
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 09:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722504982; cv=none; b=unTIJXwEVru2D0xCkuPRyqTnr7YdZmICDcEzOpkT+Brk/Uat/y6qYCi+43znr+ICmRff1Y7vmCMn5+kDE3YplOItV/cO3swJ3XUqP6p0AlWc2gcAWQXSSw8hgRYjKelrLjJh5zxe/1F1akb1/RUsCq8/lgp7ae0m0WvxxBRHWjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722504982; c=relaxed/simple;
	bh=RQAbB+4xwgd8rgrT5Xo97jqhsVqqGwZd4S+HhvCqU10=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UgFTMKFWRFF/oA61ia26gaHJDITgczDlDC3fiwyXFVWX/bvUeGXirGmEAZS7QedyOn6XoBajexYeNFtErWIdk1gP5P9xVWtUd8hUc6vfEOZQaNOjf4oTd9eBm9el+y6g6vja39FMDLDp7RbHPy8kV8RspNLG9bdqPpbwmXR2u78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WRSdpF5n; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722504980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KJ/HMyeCTpAdrNibsjz2nmyKmky95K7l5NS86QU5jXI=;
	b=WRSdpF5nIlH3YQJR5Pax8xPkCgS67DZr2oAvxXFlc9hA2+N/GtgrsMB9BwtLhUIMkaGEIe
	mi11qs8253xusQGcFDtSMrbvImiWJgrvaFlxEOY5kEuePQKaiEDju8yrU1p1cmDY+hTbSy
	NKkuRXx+/OTSZlixwgHSTvN/t3jCEC4=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-299-lTeyqaZHND2kX1ftzPPf3Q-1; Thu, 01 Aug 2024 05:36:18 -0400
X-MC-Unique: lTeyqaZHND2kX1ftzPPf3Q-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-52efcb739adso1164622e87.2
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 02:36:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722504977; x=1723109777;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KJ/HMyeCTpAdrNibsjz2nmyKmky95K7l5NS86QU5jXI=;
        b=lu4zZyMZIj9R+fdSXWSNgU6wJOHje3x1zfQ7BqAiQYEKMqmagCWWxOETmUrMRHALy9
         HQaYRRjfWaqwuk3TM4ZCYNc04htxDyIhl5KN+2cSNSO3vQd8+sz86xnrBXhePsRyVs+H
         re1eyavvV0oq6oauAnp0hH6bgHHvkE/99LOTMg/UWSixwrQaMjNHsRpLH8aIurOIvQP7
         SoHU0jEq1+WbCbo/N38+/0C2n02MfQ7fuEOTZr/3alue29HsEBlLiU0oZwPnyCSZrk9a
         PUB5CqBJ8Aok/+wkzDizPioQvulGDHXP7EushyYOO0m3KwgVFcc3TXEVSzBIu5cja6N6
         g4nw==
X-Forwarded-Encrypted: i=1; AJvYcCUGftklAk7zpwl9LrTUDPWp6euEE+rGGOHT4IKecr1F3coPLrAlU2wpRcIzh5iBSjkZSBS6dv53DEc0jxu3/aoyUA38
X-Gm-Message-State: AOJu0YxSH2GViFz6EGGFw5YydFxoD3potw5Z7rCTk69qD++D55mYVso7
	C6YQ2AAKjJUPzsrY0a8u4+C/x0gkFYG6cgN5WayJ105SXkP0t1d4eZw8QUHUQuxS98Bac3BMksU
	EYFl3FPdBfMRTBg6pSGgfWndFnS3jkJ/kY6UWhuNDL1xM9VfU+w==
X-Received: by 2002:ac2:46ef:0:b0:530:ae0a:ab7a with SMTP id 2adb3069b0e04-530b61aa918mr892639e87.17.1722504977096;
        Thu, 01 Aug 2024 02:36:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFBu+QMo4gAEWvVK7f3J31mT8lTsS1wPjplRZ9rVb/L5dLtT7Zpo/p40oBB0gNZnxzN3H/cdw==
X-Received: by 2002:ac2:46ef:0:b0:530:ae0a:ab7a with SMTP id 2adb3069b0e04-530b61aa918mr892597e87.17.1722504976510;
        Thu, 01 Aug 2024 02:36:16 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:5c00:e650:bcd7:e2a0:54fe? (p200300cbc7075c00e650bcd7e2a054fe.dip0.t-ipconnect.de. [2003:cb:c707:5c00:e650:bcd7:e2a0:54fe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4282baccccfsm50752385e9.29.2024.08.01.02.36.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Aug 2024 02:36:16 -0700 (PDT)
Message-ID: <37ae59f2-777a-4a58-ae58-4a20066364dd@redhat.com>
Date: Thu, 1 Aug 2024 11:36:14 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 05/11] mm: Add fast_only bool to test_young and
 clear_young MMU notifiers
To: James Houghton <jthoughton@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: Ankit Agrawal <ankita@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>,
 James Morse <james.morse@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>,
 Raghavendra Rao Ananta <rananta@google.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Sean Christopherson
 <seanjc@google.com>, Shaoqin Huang <shahuang@redhat.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>,
 Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-6-jthoughton@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240724011037.3671523-6-jthoughton@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24.07.24 03:10, James Houghton wrote:
> For implementers, the fast_only bool indicates that the age information
> needs to be harvested such that we do not slow down other MMU operations,
> and ideally that we are not ourselves slowed down by other MMU
> operations.  Usually this means that the implementation should be
> lockless.

But what are the semantics if "fast_only" cannot be achieved by the 
implementer?

Can we add some documentation to the new functions that explain what 
this mysterious "fast_only" is and what the expected semantics are? 
Please? :)

-- 
Cheers,

David / dhildenb



Return-Path: <kvm+bounces-26231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EDFE973571
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:49:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DEA54285CFB
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 10:48:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BB95184521;
	Tue, 10 Sep 2024 10:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ET3uqHoX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1437C2AF15
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965331; cv=none; b=ZRiUBSGXrSRDGQJUjbygLwcWHLQdieVqkcDWUvTQsEcZcYC25kcxUMXW+sJNtynwZPLKCUhIw6Aw/iTrUlVpIiXdxTAUl3sw/1kw+qp2KhVELj7BR5izonI4PHPSSATBRoBG1fspQ4dSxekXlSwDFosOYRzozw8ANsPfWweASRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965331; c=relaxed/simple;
	bh=Yry6yn1otmrO433bv7L6l95zS3P3tvOdRr0ia+1ysdg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hiimkknzYEZKIH5J8Oq8aUomCMXnUg7VPax8gZ9FSkX9bIsRyb83FYfl4duKFG2GPBj8pllaiLCqWp5t2GFuOJvL7JtNxToY+T1R6IfZAKjJwheUNO3hIIKSb0PZYIJV28N5XqpFr5HGsw6q44NDbn8UFfFZ3q/fv6b9yfR9oSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ET3uqHoX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725965328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=B2ieYUxbbHHGGo0E6WELXjXJIeasVfrRq3zIDQk/VQo=;
	b=ET3uqHoXTLwLPJ9PyXO0cGna/BEM+QETZovKCI96QFjho1aaukjfhzXGT9EiQ6AYveB3EE
	eX1Gf0EnzyAxYwSW9AxtwjOXuF8rckU+MczmpA0EvDaVtfVAGEi3FypNGApHDn6ZhDBk+0
	JigWp4Czrd4CpcEaORkKJxhh9T/62Pw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-3djCLiiDO8e9lsDtBE-8KA-1; Tue, 10 Sep 2024 06:48:47 -0400
X-MC-Unique: 3djCLiiDO8e9lsDtBE-8KA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-42cae209243so22145175e9.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 03:48:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725965326; x=1726570126;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B2ieYUxbbHHGGo0E6WELXjXJIeasVfrRq3zIDQk/VQo=;
        b=gbzRBj5dTmND5AfQPF5EYxI7BWckUtRQhrl+m3fGvHte5anW1316N92cts9/JPPlc6
         JEJbcLjzdzT/9hXhU8iARwbyIi29Hg8rMyEzcpuVRjqPAhFb6oWiLuNJqSZPGUbRvVIQ
         nQOLSM7LDeJK49i8UM5hbffXEOMp2aGDKdKvJUTRt1SRiR3/YhEjjNTQQoSWFmPZ0EZW
         0j6OS0hIUSpme9ElqTiSDuhRnRk6lW5i37T6mWTw7OW2Glu0aWdBEmSuKDFIOqvOQxap
         lZwK8/1xjAhjbtUS0cvxh9FlaodxZpK+8Pv9PnV16Jxs+yX4j3Sk2r+h2XHKGrmBAsC2
         UoBg==
X-Forwarded-Encrypted: i=1; AJvYcCW7psT4/ZR2IgZPnaEqVnr6Elck85aDQ39UcMobUpMHVQKgpA0HUWfrGvtF7S51VklKjcs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOmoxoxwjLB0vvbVMcPed7QzZ0PtVtryH/01yA6ol3y7ynA8cB
	PX1liUtymfQ31wE6gOkBIBO33HgN0Ps88VSokDDkoeUnWWXjcyWBBzcOeII+9dxW3qQtqo/MUUK
	N66aKOqYm8WKRbHtzmsEsF1B6PnxcZCTcAWfcXYgLOlhjClJKEJ27Ag1/LVc5
X-Received: by 2002:a05:600c:3555:b0:429:a05:32fb with SMTP id 5b1f17b1804b1-42cae70f2c4mr86924885e9.10.1725965326434;
        Tue, 10 Sep 2024 03:48:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE20Ebh6b/agKccFilSQknl7HrcvujOdpkCfv2DU9dT0Q2NhUpep/t2EMMM9InGNCQWzUuMFQ==
X-Received: by 2002:a05:600c:3555:b0:429:a05:32fb with SMTP id 5b1f17b1804b1-42cae70f2c4mr86924605e9.10.1725965325922;
        Tue, 10 Sep 2024 03:48:45 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-42cb2f86488sm88949275e9.15.2024.09.10.03.48.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 03:48:45 -0700 (PDT)
Message-ID: <92b86a71-3bbb-40a7-ae45-ab32215cce90@redhat.com>
Date: Tue, 10 Sep 2024 12:48:44 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/21] KVM: TDX: Add accessors VMX VMCS helpers
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "seanjc@google.com" <seanjc@google.com>
Cc: "Zhao, Yan Y" <yan.y.zhao@intel.com>,
 "nik.borisov@suse.com" <nik.borisov@suse.com>,
 "dmatlack@google.com" <dmatlack@google.com>, "Huang, Kai"
 <kai.huang@intel.com>, "isaku.yamahata@gmail.com"
 <isaku.yamahata@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-7-rick.p.edgecombe@intel.com>
 <bd423b07-3cb4-434f-b245-381cd0ba4e58@redhat.com>
 <38b2a97bd60e55505bd77e92a9257d5504c22b8b.camel@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <38b2a97bd60e55505bd77e92a9257d5504c22b8b.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/9/24 23:29, Edgecombe, Rick P wrote:
>> Maybe a bit large when inlined?  Maybe
>>
>>          if (unlikely(err))
>>                  tdh_vp_wr_failed(tdx, field, bit, err);
>>
>> and add tdh_vp_wr_failed to tdx.c.
> There is a tiny bit of difference between the messages:
> pr_err("TDH_VP_WR["#uclass".0x%x] = 0x%llx failed: 0x%llx\n", ...
> pr_err("TDH_VP_WR["#uclass".0x%x] |= 0x%llx failed: 0x%llx\n", ...
> pr_err("TDH_VP_WR["#uclass".0x%x] &= ~0x%llx failed: 0x%llx\n", ...
> 
> We can parameterize that part of the message, but it gets a bit tortured. Or
> just lose that bit of detail. We can take a look. Thanks.

Yes, you can:

1) have three different functions for the failure

2) leave out the value part

3) pass the mask as well to tdh_vp_wr_failed() and use it to deduce the 
=/|=/&= part, like

	if (!~mask)
		op = "=";
	else if (!value)
		op = "&= ~", value = mask;
	else if (value == mask)
		op = "|=";
	else
		op = "??, value = ";

Paolo



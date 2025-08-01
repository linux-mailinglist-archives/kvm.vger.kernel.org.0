Return-Path: <kvm+bounces-53832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 32901B1811A
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 13:28:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87BAE1C8297E
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 11:28:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11411246793;
	Fri,  1 Aug 2025 11:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SWIaAWJj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6DE2561D4
	for <kvm@vger.kernel.org>; Fri,  1 Aug 2025 11:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754047619; cv=none; b=O6HqYttAzDroO0Skaq/KI/Th+HzAK+78a+jm6sDmN68lRmBCiBrsTVq26cPLEkyIdui5vXopzuSGiYkBpoqVejQXvf52owN6z5Ae5UemFgz1RbGLfhruhHSAcaFV+0bbldCPSmdZFzVcOgvELvs0NzuvQIgQDnZCW6ZuyKfRoCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754047619; c=relaxed/simple;
	bh=4xyQvpgC+I9+1Qp0FJ9nuQV679QR/nFwxzq863jh5tU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ez9dqLvpcGJwkxUdvi4catLbDrsBRh6IJEM0q91W5FHgHq0fUxAnremBsrRw22yl0JH655uoKCrds6+1e8WjVKk02o0S28xy2e1/vvG32RaVpIUCZl051qgjd5VOsV2mjfY8UYPq+vZyhXRG0hHYN2n+OMADcgfcMWo3OoxQt/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SWIaAWJj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754047616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pHOprKZ6PR/GAM6prd1YkB5yUEoiTGeLa6WoyKyn8vQ=;
	b=SWIaAWJjDhnDVIwTMzDt1CLX6OUnHKE5CUY0Ny7miGugNxF4i/gGQ3wnDcwI25Q1jHuFbv
	bAITBUYUcixvOuxkWof/JHMdscHJ9/wglYOp0fAM9QSINDFwED+HCUN799q7L4T4mOQLGH
	tDVqe8mH6Y2Iualsg6W0UR91BB11Jzs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-473-wiLUVVscOkG20Yc-V_6Diw-1; Fri, 01 Aug 2025 07:26:49 -0400
X-MC-Unique: wiLUVVscOkG20Yc-V_6Diw-1
X-Mimecast-MFC-AGG-ID: wiLUVVscOkG20Yc-V_6Diw_1754047609
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b7891afb31so468175f8f.2
        for <kvm@vger.kernel.org>; Fri, 01 Aug 2025 04:26:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754047608; x=1754652408;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pHOprKZ6PR/GAM6prd1YkB5yUEoiTGeLa6WoyKyn8vQ=;
        b=xOEUPFTsOUgPbmSFW0beSSdwy2fgQC3RrRG6D/ZPb280mKv5qqvTc5kFwAdJZmrohO
         IHzJGu5CgtP0mPNvGUmIgXBJm/Mh74eOBafSnSZ7rrtVrUDWy0+AMnQW07N8I60OclpD
         ty+1US8H3RUcBmEVZEC/HSEfrWkaZBVHqmz78UiNtq2SQIwhEF7uDZD9n4bMaTwBiZOd
         /wgyMaL809R2P9DB1edlyPeFNbkqq8JNnzC0Zo+udKy2OCMul0eSJwEe/BFr9eAkOl1i
         OE/IPFo22bziJ0sCZX1ZwNzN7SjrZOLjmRK56Aego3GkpNTMQZ16oPi984rmqx0blOCI
         D8Zg==
X-Forwarded-Encrypted: i=1; AJvYcCVmySTbnuv1fA97oWARoTsPyRaHWsmshsNJsWBwY/Z0RCNTUl5BEwew8MBEdnLa6ReY12c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXOn61lfZhX8xUw76juSAoJZI4vQpv1LHmgH/ZJy449HhARG3T
	V/VEtJ1MN9qhMPhMdA+F+HOGGL1n0x1LXTHuBuCxit+1TBHQu3iHAnykx1y5gn125tHPimHCz3Y
	jWY7MlJ408SEh89e6mzAtdGs+q5c3qw7BE1uMSclAjO6eT0r5u98O4g==
X-Gm-Gg: ASbGncsb8E9CPmqIfEJf0965+/kfuuHLtRQl3wCGjtpVG9x+4vdC10YRom4ryr+maVg
	v3KT1T5GFdUX92d+DRRAOuD3nL9lbQ0q1NL1mrWCmg4QnjwUtkW3Ey57C0XVRxrYjwX2o/ezMfn
	Eb7kFKAweHOCYrC0s0zuvbqzp2yrPUSRuj8iVSBpnevcstvt7iIaL1s9L85EjsSPFj2+bPFD2DY
	bObQyalxUL+mrvV2CW2CsRd7KXEH/07MNHfOoqfdNwvnPbkyG/tDdGpw3D3b7yH+GP9N1tvJbkx
	D0u1YwKlJHFY4PL00BofuXJhWOpQmaghCG//h4asZBaBAU2DWgeHghRgEmKcXSvLGCINPAIFOs1
	gFTk=
X-Received: by 2002:a5d:5d07:0:b0:3b8:d7fe:315d with SMTP id ffacd0b85a97d-3b8d7fe344amr350942f8f.34.1754047608604;
        Fri, 01 Aug 2025 04:26:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGRBJH9g8fRYAfsc45Q+0l1Ggbop+PWThVcIfuhi55RsC2803vYJ2GW5q7gTx71Z8MzzyOq8w==
X-Received: by 2002:a5d:5d07:0:b0:3b8:d7fe:315d with SMTP id ffacd0b85a97d-3b8d7fe344amr350926f8f.34.1754047608152;
        Fri, 01 Aug 2025 04:26:48 -0700 (PDT)
Received: from [192.168.0.6] (ltea-047-064-114-086.pools.arcor-ip.net. [47.64.114.86])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c4a2848sm5473887f8f.71.2025.08.01.04.26.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Aug 2025 04:26:45 -0700 (PDT)
Message-ID: <bfe5477e-7340-468a-af3f-192adc451c2d@redhat.com>
Date: Fri, 1 Aug 2025 13:26:43 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] arch/x86/kvm/ioapic: Remove license boilerplate with
 bad FSF address
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-spdx@vger.kernel.org
References: <20250728152843.310260-1-thuth@redhat.com>
 <2025072819-bobcat-ragged-81a7@gregkh> <2025072818-revoke-eggnog-459a@gregkh>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <2025072818-revoke-eggnog-459a@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28/07/2025 17.50, Greg Kroah-Hartman wrote:
> On Mon, Jul 28, 2025 at 05:36:47PM +0200, Greg Kroah-Hartman wrote:
>> On Mon, Jul 28, 2025 at 05:28:43PM +0200, Thomas Huth wrote:
>>> From: Thomas Huth <thuth@redhat.com>
>>>
>>> The Free Software Foundation does not reside in "59 Temple Place"
>>> anymore, so we should not mention that address in the source code here.
>>> But instead of updating the address to their current location, let's
>>> rather drop the license boilerplate text here and use a proper SPDX
>>> license identifier instead. The text talks about the "GNU *Lesser*
>>> General Public License" and "any later version", so LGPL-2.1+ is the
>>> right choice here.
>>>
>>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>>> ---
>>>   v2: Don't use the deprecated LGPL-2.1+ identifier
>>
>> If you look at the LICENSES/preferred/LGPL-2.1 file, it says to use:
>> 	SPDX-License-Identifier: LGPL-2.1+
>>
>> as the kernel's SPDX level is older than you might think.
>>
>> Also, doesn't the scripts/spdxcheck.pl tool object to the "or-later"
>> when you run it on the tree with this change in it?
> 
> Ugh, sorry, no, it lists both, the tool should have been fine.  I was
> reading the text of the file, not the headers at the top of it.  My
> fault.

By the way, is there a reason why LICENSES/preferred/LGPL-2.1 suggests only 
the old variant:

   For 'GNU Lesser General Public License (LGPL) version 2.1 or any later
   version' use:
     SPDX-License-Identifier: LGPL-2.1+

... while LICENSES/preferred/GPL-2.0 suggests both:

   For 'GNU General Public License (GPL) version 2 or any later version' use:
     SPDX-License-Identifier: GPL-2.0+
   or
     SPDX-License-Identifier: GPL-2.0-or-later

That looks somewhat inconsistent to me... Should the LGPL files be updated?

  Thomas



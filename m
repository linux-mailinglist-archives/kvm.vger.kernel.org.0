Return-Path: <kvm+bounces-17762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BB7E8C9E63
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 15:49:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D1DD41F2204F
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 13:49:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D92E13667F;
	Mon, 20 May 2024 13:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MKPOp2UP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE9C53815;
	Mon, 20 May 2024 13:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716212944; cv=none; b=Fwk1IIO524prynlUMuLuHm3Hdoj7V9/UVGl6VJE86QmUS2BtxKZFg7GfRqnPd/aBl/SNb4W63I8ZiUx723qbSaECx2ac6O3UI5vGXTu203agVXLQ3qUzuTKQlKVtrzEPl5/OoJerPjf70mA3og72qiRXRBn0PSpBIjXUhO+Io3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716212944; c=relaxed/simple;
	bh=6gAQwjlt1Lf6/xnYJFSYyzHnBMyQlxfbiPdG5vR45kM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rhiXcH3dRdjnECSKfJLow5DWA6IhwdlSRxcMv2VlF7axIGk2NBhZIx5WnkhsjitcKvMGcox0+dj1y8to3ytZhLhdHQxNv6T3vzujZzkctLNlWJF2FxZoSNnbHXiX/reVmCIaUf4s3ToucwhHhOC6iVftPABAazwmBS/xj37Qiyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MKPOp2UP; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6f12d22331fso1610036a34.1;
        Mon, 20 May 2024 06:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716212942; x=1716817742; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6gAQwjlt1Lf6/xnYJFSYyzHnBMyQlxfbiPdG5vR45kM=;
        b=MKPOp2UPQhr1D92GmxXvdsrnRaOeKM0rlEAaaiVVPe38zrHDGtYUYNr4Uxc2wGE/5Y
         vNjN1yO06/dwX5753eSJVVNN/em2d507tNPhdTqbWLRQNfCB3V6BBi0iPMwKaDi8M0hw
         dN+R2CJirAduvB2t4K+XZ8roXq/qVA+TzwZrmZWxa/ow1Tva4B5GPinznwf2/URE81Fk
         vo0fGooMCWQ96n2nZ1MmHN7q5B8qzr9AO6/77BiCnd2VtLX77hgSpYp6Lsw50a1onQR2
         7T/z2Hv9ZsiHLeveEvX3rsZkxQGgyfxVT+INEQfcdQNd77+IoW6LMgowQMqRo/5+m5/F
         di3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716212942; x=1716817742;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6gAQwjlt1Lf6/xnYJFSYyzHnBMyQlxfbiPdG5vR45kM=;
        b=HF6rzqfaMBX0OvlO3ZFB1pPZ2N6BNUP6qcdkg1LhiclAYflpFEYrWC708rjElvi9zl
         c0ftzyjvzNEAgE/gDdp+OIbV4gI1yUi2m/ATRtbTRubt/kHjkdPfDznV3/OxZnz4s+nY
         jkL/1Ec5SCIDTeWUtyyrSIJ6XgmZOlzG0JQSxuF9v8wf3A09zvkyiOi415qgiHfcUERF
         UrRjItD45Y8wZQp0vN8J99fNrm5f1/qNKqkCgsVBH2eTHb5faZlDVjk/L9U1MiTnDan/
         QfCi3cAeF2WOLB1rXan++Gof1CnanF7sSEgi8cTzQVw4XAFE8VgNm8n0MA8LZDzW/Wrc
         2d+g==
X-Forwarded-Encrypted: i=1; AJvYcCWaQwRERi/jRvihcUX7tT8oh1MIgsNEYGaVI6FHSHLuyOuJIlA1Fy3Vxi1q8OWBc1bK8ciHHBYQS4t76Nnmj3iY6DHFc6UoNiT/QXLFdfoyPk2rhSPj6KYvytK0DwotQx+hMOLE
X-Gm-Message-State: AOJu0Yx4VHWYrbfNIn+bgIIkU8946vo0+lWPAt2inRQiGnWlDwyVOiDY
	24gWVIru5Y/Rm5f1EOnKP4MHjDotxXqLZxVGbKSkXFo3ScC83c8Z
X-Google-Smtp-Source: AGHT+IGKZLu/Z9N+xI6zYc7/lPYsbvLG0rFYVkPMmquhfoFbH4AYb6GNldD6sgF8oVfnen71ZoObwA==
X-Received: by 2002:a9d:63d0:0:b0:6f0:e54b:d968 with SMTP id 46e09a7af769-6f13d83ba47mr2554300a34.16.1716212942395;
        Mon, 20 May 2024 06:49:02 -0700 (PDT)
Received: from ?IPV6:2603:8080:2300:de:a9f0:3fbf:c113:e332? ([2603:8080:2300:de:a9f0:3fbf:c113:e332])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6f10bdfab8csm2872239a34.28.2024.05.20.06.49.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 May 2024 06:49:01 -0700 (PDT)
Message-ID: <cfdf1ee1-41a3-46f1-9a71-ad09894ee931@gmail.com>
Date: Mon, 20 May 2024 08:49:00 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SEV: Fix unused variable in guest request handling
To: Markus Elfring <Markus.Elfring@web.de>,
 Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
 kernel-janitors@vger.kernel.org, linux-coco@lists.linux.dev
Cc: LKML <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>
References: <20240513181928.720979-1-michael.roth@amd.com>
 <76413d53-4572-4a38-baff-8b01f6179c8e@web.de>
Content-Language: en-US
From: Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
In-Reply-To: <76413d53-4572-4a38-baff-8b01f6179c8e@web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hey Markus,

On 5/19/24 12:50 AM, Markus Elfring wrote:
>> The variable 'sev' is assigned, but never used. Remove it.
> Would it be a bit nicer to use the word “Omit” instead of “Fix”
> in the summary phrase?


I can find many instances of "Fix unused variable" in the history of the
kernel:

ubsan: fix unused variable warning in test module
x86/resctrl: Fix unused variable warning in cache_alloc_hsw_probe()
octeontx2-pf: Fix unused variable build error
etc...

but not a single "Omit unused variable" commit.


>
> Regards,
> Markus


Thanks,
Carlos



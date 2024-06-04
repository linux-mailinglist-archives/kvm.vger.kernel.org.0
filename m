Return-Path: <kvm+bounces-18751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CBFA78FB05F
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 12:50:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A2CB1F22423
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 10:50:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F03F145343;
	Tue,  4 Jun 2024 10:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fX3MrB35"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCAE144D1A
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 10:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717498198; cv=none; b=S+k+izL0itOHeas1lBcNnIFL0ob/0H84W0Z9w8au3cJG0qEg0ZnkkCorJFsSPL3brUcylKMtMfnAxT6iirN8razdEo6f2C/s1v2XEqU/y3c3gTWAuLNRRQ2Ns6D7I+9RLLRpTrYLGqZyzqrHOieiyRBSurdgW8GzcT8/4Mwpz5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717498198; c=relaxed/simple;
	bh=Ytv9S5j5vsCsWvzRxEId5F4Qttd+ltQwIJt04kdcokA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uLe1nkKKwTEY1Qwz0beX5AKdLkUfwLLkwnmSCSBm/i9QpLxw8+ps1v6CA8dP5sCCmE6AOXlxPceY3yWX9D0kt3bkntQsRfT4VAN4oOd32KrSBc9yrigfDtjUtDYYayf1hYeh/2E/ckC8+QMANxYIDUzkb0TrbJXLmWE3ZUcaXGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fX3MrB35; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717498196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=U1w2bG5lPOfWEVpr4xHtf9bwg5SohkWgMrHEQtHuoCA=;
	b=fX3MrB35JfygwFsUucpi8ywMHWD3S5wp2+i4fEBi5fBPGdKScaoMzjRW2qDJaMnDgG+NPs
	LopmfvWe94LAeBGNk0oaOaxAeoYQw0mPmBquk8xxYOCBZnb5DlXm5j0I0f/6O9GgsuI4OI
	a6InJPrhT67VB4xepdQX7Py/BrVKkgs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-404-CQcluX7PNDWCMF_E0tZrtg-1; Tue, 04 Jun 2024 06:49:55 -0400
X-MC-Unique: CQcluX7PNDWCMF_E0tZrtg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4212e3418b1so25498785e9.0
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 03:49:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717498194; x=1718102994;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U1w2bG5lPOfWEVpr4xHtf9bwg5SohkWgMrHEQtHuoCA=;
        b=VGcN8SIZ1NgzCs7XEVrruZv2qvSS4cmdkDtyVm9n7pHr/LKThO+LeaIh63L2Nfd8mf
         JU7ZmfW1GPlUzqqKv18LCrHsVFa6a4Kwc1OiWZJbFw3MjZPmwWB8vDLU6071jioMnpzp
         0Jy3kejdXbM6OXwuroSyIBbxkYMu71EaMyC0lF+tgaYffeFRoBkEvLLWig68LZGcJzuF
         pTzpvoiR57qnrn3l9I3XGwNR6WFfqfmd5470zduWqkP6gkJioS2fmWSdfPO79mZL8qls
         +H/1RqSwXHYznD7Y4NHcfexxDTRMgMg7LO/E6f89XTeX5S4gut8NH6TWZXsbt06ufIZ1
         1GVA==
X-Forwarded-Encrypted: i=1; AJvYcCXVIRQYD1udlZsNruH9NFAQENihWavWVENl3qGihYT9MWup1MDqsy+ifqyKzdDJRtTychtICvIJTDMGhCaYuQZKb14F
X-Gm-Message-State: AOJu0YxQ3eLgce66xu1pZ2aDXR0MZGJ1VQll+ljnQKGKqOARp4jrWdXf
	PDvXluB/iDezQiMmkUZiTjiOhCjRj1eB7Nn/m3+NhvAUlOuki/1SaPp2t12+N3g5FfmqVHcyAgd
	NwoLRS7TlB3Su+the46OcD6bBaJwDpDFOyp7bnKpvfVTcqGN4Og==
X-Received: by 2002:a05:600c:3ba5:b0:421:2065:3799 with SMTP id 5b1f17b1804b1-4212e0addecmr98197825e9.29.1717498193923;
        Tue, 04 Jun 2024 03:49:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHolKe0OTesc59eKyR5Tl4T4Nj5Xg2kbayiJShosCk0JGDK4I2jUvKZhoSBsne4+vdw1UBVxg==
X-Received: by 2002:a05:600c:3ba5:b0:421:2065:3799 with SMTP id 5b1f17b1804b1-4212e0addecmr98197695e9.29.1717498193554;
        Tue, 04 Jun 2024 03:49:53 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-178-97.web.vodafone.de. [109.43.178.97])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-421526593cfsm12414475e9.42.2024.06.04.03.49.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 03:49:53 -0700 (PDT)
Message-ID: <15d6ae85-a46e-4a99-a3b9-6aa6420e0639@redhat.com>
Date: Tue, 4 Jun 2024 12:49:51 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v9 29/31] powerpc: Remove remnants of ppc64
 directory and build structure
To: Nicholas Piggin <npiggin@gmail.com>, Andrew Jones <andrew.jones@linux.dev>
Cc: Laurent Vivier <lvivier@redhat.com>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-30-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240504122841.1177683-30-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/05/2024 14.28, Nicholas Piggin wrote:
> This moves merges ppc64 directories and files into powerpc, and
> merges the 3 makefiles into one.
> 
> The configure --arch=powerpc option is aliased to ppc64 for
> good measure.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
...
> diff --git a/powerpc/Makefile b/powerpc/Makefile
> index 8a007ab54..e4b5312a2 100644
> --- a/powerpc/Makefile
> +++ b/powerpc/Makefile
> @@ -1 +1,111 @@
> -include $(SRCDIR)/$(TEST_DIR)/Makefile.$(ARCH)
> +#
> +# powerpc makefile
> +#
> +# Authors: Andrew Jones <drjones@redhat.com>

I'd maybe drop that e-mail address now since it it not valid anymore. 
Andrew, do want to see your new mail address here?

Apart from that:
Acked-by: Thomas Huth <thuth@redhat.com>



Return-Path: <kvm+bounces-18614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AA118D7F0B
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 11:42:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC4431C219D4
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 09:42:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A607586256;
	Mon,  3 Jun 2024 09:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BibBWiew"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5842984A28
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 09:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717407263; cv=none; b=Rf3wsgPChE6nf0/j2XNT5RFVjWs+0IBCO6zT07Wzz61snPCiH3XPUKzBFnSjAhVNwPbPqcM/7iuRj1jfLOQgBfClZ/SHLQ2A9stj+7HpekECSkPTAHIrW+/10BgMhLV37t4ByJT/GPewx37LJMU+gQdnQULSneT4/25aaDQDZbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717407263; c=relaxed/simple;
	bh=xKglAfshd+1zno6EiEObKfSDRgCV3sjOaAo0cr/kANE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZCm7SZzJ42Cq2qsuAZ/GwkCFmchYkJjZCeM5paAUqRL0oVnxJqbZcYCMU36l8OJzAAafazLqINUeulfX5kwJVyWb0G3Q6BnV8/th3ajSr3VqvH3CUGcl5pNC7BJ/OJ0R99ZwkRjzGg7nNrV32B5sxrE/R7bCRm51UYeoxt7p9dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BibBWiew; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717407261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=infxpK+k9ZLlsTQqf8XnBBNOcIjsLHMwF7zpH2Bo4PQ=;
	b=BibBWiewjVGaF8I/nraxquXYINJ3LJxq547wPGwAQ2TRf+bsg0T3jjvngWoPU7qlKlVl6j
	eGDsNf4pt/9qMYuUdSTtGuIpKYt7Yjf/LmHXRyXv/aret0dNjQVfdM4q0ZeLL5UV8QKNzn
	4teLvoAO0PJL3oTvHCU56HS5f0I58Xo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-488-RMmbOW0yPYqHeDL97ytaGQ-1; Mon, 03 Jun 2024 05:34:19 -0400
X-MC-Unique: RMmbOW0yPYqHeDL97ytaGQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-42133728a50so18861135e9.2
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 02:34:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717407253; x=1718012053;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=infxpK+k9ZLlsTQqf8XnBBNOcIjsLHMwF7zpH2Bo4PQ=;
        b=Dq7NoSL8/IbMgfB3VimL87BXzsYMdCxFjKjYM2dJaTuwrS7kKMtpkYfxcghM2TakOE
         zzwfHKYWCgz7E+fHl3WgTi6Iib4NelGZFK1BmCvX5MhAy5OlcgZe2WRAGqXnQsRRGHP4
         Q35tgBXqIfMmEkcLFw2IQqsvITOpAAko9n1VwQvGrspkZ2nlCdIwaE8Sl9rCoZrHapSE
         1eXB/H6imDJyMV6stvBiXxsrrMphFZm3EVbssdHK8Rno3tLRo8PjEmPYJwwHHTVTnrIL
         /89a1tiPA+f4udsZv/dWBIIP9gAzx2KpC/bg28XTQreRu3BjhFBwRnAYlR3up/vbPCyO
         qzDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyQXsM3hNNfyWlpUu79UcyAWTdPJg7Hp6oNRT76RQJH8J7nrRTx+UGGF5UkiWWE7XsFiEQn9Zn1OuswKZcMD8sjrKW
X-Gm-Message-State: AOJu0YwYhkqydPRrsS/Y+GWeE70di8ck3QTmMGOh17reJOPBTPFlEi7v
	QBhp8UiTXxEJg1XELXK1NEOppjTqVk/nSEwC6asNRWmYo1t4v1MKPnzRNqKKUDustryK/EX+xDM
	VqpegTqpqucHP0saECMuRDfYtmlWMC0JrfKKgUSoENqbFjsxdxw==
X-Received: by 2002:a05:600c:4704:b0:41b:eaf2:f7e6 with SMTP id 5b1f17b1804b1-4212e046c83mr83461845e9.2.1717407252994;
        Mon, 03 Jun 2024 02:34:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGirsPtAPAuIW3XYtLJpOhQCCYU6ftfpY6BE8KOxDXC3PFRdRcTH4QTquOHz6Bwf+spoyizQ==
X-Received: by 2002:a05:600c:4704:b0:41b:eaf2:f7e6 with SMTP id 5b1f17b1804b1-4212e046c83mr83461645e9.2.1717407252515;
        Mon, 03 Jun 2024 02:34:12 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-176-229.web.vodafone.de. [109.43.176.229])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-421386d858esm62692875e9.48.2024.06.03.02.34.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jun 2024 02:34:12 -0700 (PDT)
Message-ID: <a0fdb18b-3cc1-42be-b1cb-66ef305b0a9e@redhat.com>
Date: Mon, 3 Jun 2024 11:34:11 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v9 15/31] powerpc: Enable page alloc
 operations
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-16-npiggin@gmail.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240504122841.1177683-16-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/05/2024 14.28, Nicholas Piggin wrote:
> These will be used for stack allocation for secondary CPUs.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   lib/powerpc/setup.c     | 8 ++++++++
>   powerpc/Makefile.common | 1 +
>   2 files changed, 9 insertions(+)

Reviewed-by: Thomas Huth <thuth@redhat.com>




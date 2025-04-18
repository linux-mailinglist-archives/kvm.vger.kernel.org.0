Return-Path: <kvm+bounces-43665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F38CA9381D
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 15:51:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6EC7B7B3B5F
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 13:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF81584A3E;
	Fri, 18 Apr 2025 13:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d4Oq+k89"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EE541C64
	for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 13:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744984252; cv=none; b=ugVdayKMzEVCA93OkcyoZ1elIlb9iOIJwZNo4MkcXPwOUrIex4unVeQZZ4GzFLViHiBzXPPeIfaMzN/OQFmL5fADhn52GrlxqBMtSzzRvMTWYOoo/bB7bEi52JcmqFoISrAnWgfNLXNowXU89G4jDfVDF0lB67zjI8pkO9gobRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744984252; c=relaxed/simple;
	bh=UbjIbGTrPTkKL3gYlzrk9QwGAFAq74FP1w6P/d1XVf0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oSqBgAEmSH5V1Cl8wB03H4ExIy6l/M4JAeJhEgNovoNpjC5i8CTGzLZ/mbhHGYvULYbvqxJX7csEatjHrEzgw0fUEl7zM+iZSUrsXjqLA6eGkseFRcWifJgbWItymaC7/vb6dG15I6Qdj8R/ZXIWKqcwGW5w2X6K/iPPn51Wtbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d4Oq+k89; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744984248;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tGlQyLIR9+MOfM/w1lJszKf4ODlHsXoTioqS3LmoSkQ=;
	b=d4Oq+k890zwh6TO8tNj/q5WNK5EZfwS8nch7Pn0kKdp0Z/tuw6TX+Gtby+gEFBVyvs/jLF
	ErIz+C5Il8PD542eRSigFRazovrHtYWp7iID3uqJmyiDzNuNzwcZXL+HAsSSF99zgO/dhl
	dvh54e1RIo52vy8MslS0CsV20vslR5s=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-571-W9rlsBy3NmKoCl7FvLleBw-1; Fri, 18 Apr 2025 09:50:47 -0400
X-MC-Unique: W9rlsBy3NmKoCl7FvLleBw-1
X-Mimecast-MFC-AGG-ID: W9rlsBy3NmKoCl7FvLleBw_1744984246
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43eea5a5d80so9508355e9.1
        for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 06:50:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744984245; x=1745589045;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tGlQyLIR9+MOfM/w1lJszKf4ODlHsXoTioqS3LmoSkQ=;
        b=UACq50dQXdwkSEi6DpS+8AreMnhziH+5SCIubVQYLsyyNe60SjR3OfZUFU6l/mBIHE
         luBKoN0TgQ95EcJnqMMrRy5xU/v+kmHg/A1qWI0JDzUnjEEI66ub9YIDwsV5sIrPSuMJ
         AS6k9RhwkcnzDGO+CUKjvf2gcEwuIkQW10OzZv/jr/LTShzdOzzpXG9e9UK4Z1sCIE1O
         mh9q3naHuwBVgYq1bEhrtVOieDy987aLyuQaLrKG88BXUh5xg0CpdAllV0SuzRuTgxKY
         LCQY+RIxurdVD9q7WidgMXcpuw8OWZQsm9rj4zYNghby274FkpzHmeflQYkUIu4ypDgE
         yG+Q==
X-Gm-Message-State: AOJu0YwWMIWwPu3nI0xMQE/IoLNLQOMqXKOsKc89KlnRNDyX3UV4eLVD
	twAt+fjBiYaYE/lzSTxvt8S2851z9wZueUqNSG9Dyq3nByKGZSPsLttGgzznbb/oqYiyxMR+kGk
	7JKylYwh7libeKc4GgPJB0LH36QZgCMqD1JfWf8FcozaURbwn2CIFIJQZhA==
X-Gm-Gg: ASbGncuFXsipH5BOET7/0N6kPU1aLaM6ExNPqBoOBoSu/hjXMLQLwCqGsDgRoVSVD3u
	+OsTNHRfLywTrdgSOD2pozQtYYEFgljZSPbThOlSxxVaZZBbv89QEWzNW4tGQyY2+J3lssbwyoQ
	s49gtpMVg1Hxlzb7tWyqtdn9jhtPTXx1xJMVE2UiEF/42Q8DnNtjXjkv+EWWSnsOcZe9bP3Y43W
	mxXu8KIZeVbeDEx4Y+nCNJjeFEF+vqx9/8yjs6XUIspdrVP3TngksfOEFEFm/WnV5gcq2dZtrZS
	qa1tg/I75h4XoKtv
X-Received: by 2002:a05:600c:524f:b0:440:6a1a:d8a0 with SMTP id 5b1f17b1804b1-4406ab81d81mr19482205e9.7.1744984245656;
        Fri, 18 Apr 2025 06:50:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGeDDSbMUMwprkh8AxY6nw7Ls5/1xN6yPoNeGLQ1cDw4UMfBL0DleLsCe20jeF1qLLUeaG7IA==
X-Received: by 2002:a05:600c:524f:b0:440:6a1a:d8a0 with SMTP id 5b1f17b1804b1-4406ab81d81mr19482065e9.7.1744984245133;
        Fri, 18 Apr 2025 06:50:45 -0700 (PDT)
Received: from [192.168.10.81] ([176.206.109.83])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4406d5acc9esm23697325e9.13.2025.04.18.06.50.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Apr 2025 06:50:44 -0700 (PDT)
Message-ID: <dc5789b3-79fe-4589-ae40-00ad28a90807@redhat.com>
Date: Fri, 18 Apr 2025 15:50:44 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] kvm: potential NULL pointer dereference in
 kvm_vm_ioctl_create_vcpu()
To: Chen Yufeng <chenyufeng@iie.ac.cn>
Cc: kvm@vger.kernel.org
References: <20250418134440.379-1-chenyufeng@iie.ac.cn>
Content-Language: en-US
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20250418134440.379-1-chenyufeng@iie.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/18/25 15:44, Chen Yufeng wrote:
> A patch similar to commit 5593473a1e6c ("KVM: avoid NULL pointer
>   dereference in kvm_dirty_ring_push").
> 
> If kvm_get_vcpu_by_id() or xa_insert() failed, kvm_vm_ioctl_create_vcpu()
> will call kvm_dirty_ring_free(), freeing ring->dirty_gfns and setting it
> to NULL. Then, it calls kvm_arch_vcpu_destroy(), which may call
> kvm_dirty_ring_push() in specific call stack under the same conditions as
> previous commit said. Finally, kvm_dirty_ring_push() will use
> ring->dirty_gfns, leading to a NULL pointer dereference.

Actually I'm not convinced that this can happen; at least not in the 
same way as commit 5593473a1e6c, because KVM_RUN can only be invoked 
after the "point of no return" of create_vcpu_fd().

The patch is good anyway because it's cleaner to use the same order as 
in kvm_vcpu_destroy(), but perhaps you can also move 
kvm_dirty_ring_alloc() before kvm_arch_vcpu_create(), so that the order 
remains opposite for creation and destruction?

Thanks,

Paolo



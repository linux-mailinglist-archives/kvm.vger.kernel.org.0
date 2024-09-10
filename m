Return-Path: <kvm+bounces-26230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B73209735D1
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 13:00:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 73BBEB297F8
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 10:46:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AC711922EB;
	Tue, 10 Sep 2024 10:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bwqtp6Tx"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A63184521
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965114; cv=none; b=BCqSQTmDsey/aCn6SjyvI6kbJi3EPYZ3s7Ysrg78BniZELPOcgItUCWh3tmkah0pPrPaijlySs3h6Z1Eup1hUoKa7Go3Sq+3EJjSyaoDVzYEpLRrtcTgDK3weBOl2Mh4+WX9z7itPa5Gqt9xZfhDnd0Yqe/G4lTHn5JfpJo8sy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965114; c=relaxed/simple;
	bh=jYlCh8yNeYIkjiBpQOKOkIMz2OZvTJRJ/aETlxPhMrA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nARY/uqrnNoYHmDR6qAxEktNJgOzHmtkmvZFuomZOsofIEMqchGzKo1bJXjmu2gy6zN+UVwyNJzrY+MR5YljULqRTSAwU/16urTQSpHXoBY/IOMJS7+xGNJ7OH3cFrVg2vJBdM5ySEPWMv16jTt0WtYFq8Ckt435KWtszF6jW18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bwqtp6Tx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725965111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jyPpBrEHkd08T4IqqfOrRciboN+U1FHHDgcUpFHe6pE=;
	b=bwqtp6Tx6WC0DlOaPINpDo5PDPysKZsCYveHHnfz2r1vIehfegoOVYFA9feJ5hrpa2bREF
	ACLu0MSSz5K2yi5S6RzEgY99C/HFayALLpoW0GaFBer6Qo1Em9jvkgqvPSfejFefM3nBQC
	kZU7SZ+YNVa2116prW8Xac3n59IOrQQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-2dVrchrmNHKcUK5-Fhosjw-1; Tue, 10 Sep 2024 06:45:10 -0400
X-MC-Unique: 2dVrchrmNHKcUK5-Fhosjw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42cb33e6299so16693655e9.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 03:45:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725965109; x=1726569909;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jyPpBrEHkd08T4IqqfOrRciboN+U1FHHDgcUpFHe6pE=;
        b=nH8mx/nmiMW/DRZdjsodR00dMdhzbhnKoUlwSHt0psouyxBq29Tjpc4Ve9ilqXS74H
         Mwq7ZhzxVqVmO7fqcGfdxGIy4Q3EVcT+MplN9WDWzmBkRl1sGCeBfiE5dUEfFFJGqp/u
         291NomBMd8fytPqj3bsc2jWt2eHZqIK9110/98ovhFZAGpKwDWX9sd/pDPcNjw5liaNB
         i2CZLRcxooQlTGk4G78zzIDNyp0eAganVMUzrM4P2cTFZsVHSGE2MAWJtWm0cfJTXgyO
         FYF1d44fpPErO90us0lcixObBkKoQ4DjVxhYBB9ia6X4nD9DRhrIH8/JWQP3XaiW54AO
         b+xA==
X-Forwarded-Encrypted: i=1; AJvYcCXDKr5shGGZFyGSc/2xB8JMb4sH9jpUknz/QJ7PE90KbsqFAH05tEKL+Whlr9rJ8nX1igQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzb3rfiZS1Hbv6xt3oLbXhZvT+I6JUaHsTXUTeAydM23KOC/rni
	+83zDCarsUV0Rdnzx023/9Ct8VfXKYPCfzb9IbA8dF0yuKpirMgymQt/G2GLJROlR08j04OM12j
	53iRFpykPWfrdD2/aFbqXLfY71+qlWKkHNDPXxRCnwftR0YtDcA==
X-Received: by 2002:a05:600c:3b9a:b0:42c:af06:718 with SMTP id 5b1f17b1804b1-42caf060aa3mr68287645e9.28.1725965109335;
        Tue, 10 Sep 2024 03:45:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHfmE2OcdsT+5uBbdXW+uePHJTdUw7zg7QfpVhNTyVckW+6q4fb0qb3B5MMthaJdYsgSv77Gg==
X-Received: by 2002:a05:600c:3b9a:b0:42c:af06:718 with SMTP id 5b1f17b1804b1-42caf060aa3mr68287355e9.28.1725965108879;
        Tue, 10 Sep 2024 03:45:08 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3789564a18asm8495403f8f.15.2024.09.10.03.45.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 03:45:08 -0700 (PDT)
Message-ID: <7fab7177-078e-4921-a07e-87c81303a71d@redhat.com>
Date: Tue, 10 Sep 2024 12:45:07 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 21/21] KVM: TDX: Handle vCPU dissociation
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, dmatlack@google.com, isaku.yamahata@gmail.com,
 yan.y.zhao@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-22-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240904030751.117579-22-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/24 05:07, Rick Edgecombe wrote:
> +/*
> + * A per-CPU list of TD vCPUs associated with a given CPU.  Used when a CPU
> + * is brought down to invoke TDH_VP_FLUSH on the appropriate TD vCPUS.

... or when a vCPU is migrated.

> + * Protected by interrupt mask.  This list is manipulated in process context
> + * of vCPU and IPI callback.  See tdx_flush_vp_on_cpu().
> + */
> +static DEFINE_PER_CPU(struct list_head, associated_tdvcpus);

It may be a bit more modern, or cleaner, to use a local_lock here 
instead of just relying on local_irq_disable/enable.

Another more organizational question is whether to put this in the 
VM/vCPU series but I might be missing something obvious.

Paolo



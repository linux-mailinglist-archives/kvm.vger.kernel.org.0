Return-Path: <kvm+bounces-26228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 894F69733F9
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:37:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45DE628B3EB
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 10:37:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F24CF191F9E;
	Tue, 10 Sep 2024 10:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KvHMuddi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97EF0199FBF
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964392; cv=none; b=e9ASxI2A9gM4xwI2WjYDaOuGtp0OXQkqFFaIi923HD6rViA71pvpSlgvDsPKuF5zToZwkw8/Yiz7TVxgfFN74WaBz5ZWXi4XfpN+HPnWefjeW+YNIa+/UY6VB+kAmmmf4X0H4RHRW2DhkqXUoeqPzeimF1R3sTbk8z3UZ/4mZ5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964392; c=relaxed/simple;
	bh=E7b1PYOVHWN5xCqgTRRoX5NdHD+pFEhDlqhbJhh0bE8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TW3WGwW436uOMXbzS0p5oFZr7DRQrkJogQPMdoCcozKO6evIgZqEaM2MFTVsiSgwuA1g36fPxp0071/CGlELmN513jSCbJ/2ojFbFeI8CcsbQsvJzNERcWbkNiNzrPvtnwCJBLv4gG7ztBzCf4Gzvhw5aoPAd0Z6nde81m8IOIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KvHMuddi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725964389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kH6ocw22R/6xdiCeGhIaHWbkrwvsT30iP39Es6KAESo=;
	b=KvHMuddiaNlar/B8yvFnFoFE/EJu9TDpFtrRHU26s/btridL11BEE9UYF9jCW/HdxvuCND
	6CAf9PJGgE/1qjAFmt8x6I+tQElZtLzF64G1Q83jSc2bYUdp/Y0AIYXPUxMxBnR8tLgcA6
	lOJ7oBptpp3s/+NWFRjnTaSYClDu8aA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-314-Ii0CR6xKPUCbEx4Mori6ew-1; Tue, 10 Sep 2024 06:33:08 -0400
X-MC-Unique: Ii0CR6xKPUCbEx4Mori6ew-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42cb99afa97so14331085e9.2
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 03:33:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725964387; x=1726569187;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kH6ocw22R/6xdiCeGhIaHWbkrwvsT30iP39Es6KAESo=;
        b=Z0To5xkAp1TtWFbq7YObhFk7POJkV20AgdUgfohF0sxoNZtZR69T9gQomAUZH/PFQr
         2ZcSbs0P+0vyklidkm0i8nxwR3TSkgME8vRqgws4LsBLbZmjrmz4a/ylxHPU1dZtjsO/
         NDpfgzuZy3QLplT9qcZvQRoj55C31AuaFZurfRBIzSpNv3PvrbzFWlE+g376xFRa+e7U
         lpw9zrrSzgxkob31S7Ge1nTb6qRxVgjBzLy7ZCb3XyWZDZnKJf5QZKSrkdMtsfU0d2yh
         +QQBsulyc5KplexwdngesHs19ZyDf331nomezp7zIHyLkzJ1TQaVHO4KLTFji5Z4+XmJ
         VSAA==
X-Forwarded-Encrypted: i=1; AJvYcCVz4oWvKhrWpPCbENq5rivYbQBnfAliFQpedrWzCgIiO/dCac3Kj+gTpQ6vskiCOrLQxFc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUpe9l/XeAPZMwmFTBZ5fOqKWG+H396rmfhjYPvgVCqmMI1dT7
	vcolY4udGh1HQo+yCW6/vz+lSusADYqVtrd0M7RyDNa/5uif9fJo234sNPvyc3Cxie+TP/gfhMP
	3BsV1oe/3mnrNNtmQVfy0I8cjNk0V/vriJoX9d1vnKB/EtsA0XA==
X-Received: by 2002:a05:600c:4a98:b0:42c:b45d:4a7b with SMTP id 5b1f17b1804b1-42cb45d4b9bmr64796945e9.25.1725964387124;
        Tue, 10 Sep 2024 03:33:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDvKFSGsIPys4hC/yFj79QDz8i3Lu4RTATnsyup1trsn1zD2fosHieD5Yc+BZJYzv4Ij2Bag==
X-Received: by 2002:a05:600c:4a98:b0:42c:b45d:4a7b with SMTP id 5b1f17b1804b1-42cb45d4b9bmr64796715e9.25.1725964386673;
        Tue, 10 Sep 2024 03:33:06 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-378956dddacsm8409917f8f.107.2024.09.10.03.33.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 03:33:06 -0700 (PDT)
Message-ID: <5b2fa2b3-ca77-4d6e-a474-75c196b8fefc@redhat.com>
Date: Tue, 10 Sep 2024 12:33:04 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/21] KVM: TDX: Finalize VM initialization
To: Adrian Hunter <adrian.hunter@intel.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, dmatlack@google.com, isaku.yamahata@gmail.com,
 yan.y.zhao@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-21-rick.p.edgecombe@intel.com>
 <58a801d7-72e2-4a6d-8d0b-6d7f37adaf88@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <58a801d7-72e2-4a6d-8d0b-6d7f37adaf88@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/24 17:37, Adrian Hunter wrote:
> Isaku was going to lock the mmu.  Seems like the change got lost.
> To protect against racing with KVM_PRE_FAULT_MEMORY,
> KVM_TDX_INIT_MEM_REGION, tdx_sept_set_private_spte() etc
> e.g. Rename tdx_td_finalizemr to __tdx_td_finalizemr and add:
> 
> static int tdx_td_finalizemr(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
> {
> 	int ret;
> 
> 	write_lock(&kvm->mmu_lock);
> 	ret = __tdx_td_finalizemr(kvm, cmd);
> 	write_unlock(&kvm->mmu_lock);
> 
> 	return ret;
> }

kvm->slots_lock is better.  In tdx_vcpu_init_mem_region() you can take 
it before the is_td_finalized() so that there is a lock that is clearly 
protecting kvm_tdx->finalized between the two.  (I also suggest 
switching to guard() in tdx_vcpu_init_mem_region()).

Also, I think that in patch 16 (whether merged or not) nr_premapped 
should not be incremented, once kvm_tdx->finalized has been set?

Paolo



Return-Path: <kvm+bounces-26226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 36F86973318
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:28:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C71F1C24CB5
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 10:28:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63245194A43;
	Tue, 10 Sep 2024 10:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CLFRLnV0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2856F19414E
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963873; cv=none; b=HXIJ7np2cDicfdAknG3yZVqjfViEC4e4BRzALTycE1w/J9+HpFISMfSPhD2Qpz4jn+Pk4x/Xu7DaSzfT3lqnB9gDLlRBNExkiLwhae8FMkaahqlyt9c33qq6GA/tSGl+5HeEB5J+idXoFl4GxYWbfHpSAs3eJ6E27X9Db/A/+Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963873; c=relaxed/simple;
	bh=nXvrPvFjtTjtAjKT6nA1wFfclENcoRtXi11ug+J2lwo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=colavs0KT0y7iQX6O3n3qhz6kMRtfeQJVx2TnMPc7o3x17Sxcew0zAZ7b7S9DklR3tf9JXBvyLx4pf39x6gQro5HJIkXI9YrzHPtaUlgdNiKhcn1BxLUslLpZD0rZDFH9OIF2lRWfWTKUi30Gvw9rCa6F3HVJM9aujwoFJWP9dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CLFRLnV0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725963871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pKYzNHJ3lAuHhH6jLGhXV5eTNQfU4yBoKprwBFL3mU4=;
	b=CLFRLnV0Ux/LBjVNITqwzrJpHC6rnePVNehpfkaQVrWjUWbgB2fCbfkyX2hCambxaRH0RK
	H9BkZXAYkjX09Sf/ZKPTp9VO93cHFp1TiYnLE2AhDhigTs3UPnfpRBV0ucCMEfE9CeUdi7
	EkW0a48ReWYgeoht2hLNZCkdTlTTMbY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-_FzFjVYZN1SsQg7jVVBjXw-1; Tue, 10 Sep 2024 06:24:30 -0400
X-MC-Unique: _FzFjVYZN1SsQg7jVVBjXw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-42cb080ab53so19725275e9.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 03:24:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725963869; x=1726568669;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pKYzNHJ3lAuHhH6jLGhXV5eTNQfU4yBoKprwBFL3mU4=;
        b=Ib4s0eUubfZ9lRBswbxZOrrXsMckQojaPvPU2S/aijZjQRihJTFTMWdYCPPRBGTYr5
         4PpGv84i/q6CH+gWBLvdqLJqyTpT7laQ4Vmex3bqrfNpozwFQyyNq9ClBKj//3QWdCw4
         YmVifTtkajNu3Ryn+DZq+Dz5fZYHjp9sO1KoAFdyfotbS2cECp5Z6zWPnmqcJetEnz4x
         okml/gIfmo8DLCmuxQQX7vB9G96ocIp1ZjvACaDSPFdhqCmGRtYxOTsdnrYvYcWl9+u+
         1clSP+sg0QiBsSImweoIU3q4OWBPuGUXMF5+YpQvt9farYy7TepMRSC/iOoBlY+FVH8S
         A4ng==
X-Forwarded-Encrypted: i=1; AJvYcCXZ7LLqyVN7PhM9eDH2OuzLCYeiMMiwspBmMBK2SsJ9hHsfSXPY80tguU9NuimY5AAYm1w=@vger.kernel.org
X-Gm-Message-State: AOJu0YywHowMfNl9MarW8BCx671uQntl1szA83GDPd5IEOdQbPcl7g1h
	1+OasbDZjpWBBkajHreWIgG6EEj/ZK9KIYslGUFIvWum2GFO7tWlW32SYl+JvmAuRmMp4axkayF
	BjtXZySYrU7auW+CtpptXymdBqlo33h4uF20vKMJ3BeZYdv4Ahg==
X-Received: by 2002:a05:600c:5114:b0:42c:bb41:a079 with SMTP id 5b1f17b1804b1-42cbb41a1c9mr32616525e9.1.1725963868602;
        Tue, 10 Sep 2024 03:24:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IENcet5ILMp51VKtPT4BboXFJ/TyXG+2SnKYfEfsbQHLjrrijaX9zJ19ZcvKqPE/OtJovwmMQ==
X-Received: by 2002:a05:600c:5114:b0:42c:bb41:a079 with SMTP id 5b1f17b1804b1-42cbb41a1c9mr32616345e9.1.1725963868085;
        Tue, 10 Sep 2024 03:24:28 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-42caeb45c81sm107400145e9.28.2024.09.10.03.24.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 03:24:27 -0700 (PDT)
Message-ID: <6d0198fc-02ba-4681-8332-b6c8424eec59@redhat.com>
Date: Tue, 10 Sep 2024 12:24:26 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/21] KVM: TDX: Premap initial guest memory
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, dmatlack@google.com, isaku.yamahata@gmail.com,
 yan.y.zhao@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-17-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240904030751.117579-17-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/24 05:07, Rick Edgecombe wrote:
> +static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
> +					  enum pg_level level, kvm_pfn_t pfn)
> +{
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +
> +	/* Returning error here to let TDP MMU bail out early. */
> +	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm)) {
> +		tdx_unpin(kvm, pfn);
> +		return -EINVAL;
> +	}

Should this "if" already be part of patch 14, and in 
tdx_sept_set_private_spte() rather than tdx_mem_page_record_premap_cnt()?

Thanks,

Paolo



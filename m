Return-Path: <kvm+bounces-10091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CE32869906
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 15:49:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDBB928268F
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 14:49:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D49FC13B29B;
	Tue, 27 Feb 2024 14:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D4oAHmRB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849A231A66
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 14:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709045362; cv=none; b=NeGh0c68XwJGjx0gJ5gNAqQmKVlrBdi1fQEwn3banganABQ55xuXZaL2jAZzJpuzsnbQUW0NDslNvrcSR5eWpKTSKOUS8xQf/dc29q0lQ2MJZ8eUrrTxHgoVR4cmE4yMFvCxe3yVXgtqu4se9Hb5+/MPUbl8Vkrv5ke8de+PDKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709045362; c=relaxed/simple;
	bh=HAVJPuU7BOgcW98XhKZX69wgaDPMRkw2K8mYwRqeglc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=POYu0K6JrV7rr1E7aFqVFmQXla2Cd5rTxjNjzEry+e58qQ1qq+VqG7FH6M6v6AcZqZRo1bzyinInvtjTAmJLKpJvCHlngzgjJLLUFkFQYeUb5BYbo9kcY6I+557jkOoKTc8MSzqcESli7IiKD6iJsd8lP4K+/D2ypFRt85SFhH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D4oAHmRB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709045359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8JqYt5Zfwys1N5cnMs63h0pS5dTrYqC8seV0eDo2UIc=;
	b=D4oAHmRBzNVb5lR+IIWywI7iLIeUgQkstAW7/nlX13yklbcy+GYc+nUoKQly3TNCMp1llT
	aU68hpaGzTRkjTQ+e51V4QBSV/ivFx/70mrKxfvP9sEfOdbsiKV5hIjpFykxAQIfkaonVy
	e+fVdKBWlpPYvZfDlt6G4PkEp/ofEyU=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-300-QhJzrUHfNuK3HqVmONCyVA-1; Tue, 27 Feb 2024 09:49:18 -0500
X-MC-Unique: QhJzrUHfNuK3HqVmONCyVA-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-51314c5a05aso262504e87.2
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 06:49:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709045356; x=1709650156;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :references:cc:to:from:content-language:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8JqYt5Zfwys1N5cnMs63h0pS5dTrYqC8seV0eDo2UIc=;
        b=IWZPA9xINXScwI0z++VcN/r2YVyO5Om1qVU5BWvIvJVxtw/WvbizlY0IZvDOoOFEot
         +d+GG/ZFuis+aBRWumHx4vxdB3o8Nlo6fpEfGbk9U3jf0oYweiSmyvo4HgS9hCTh6Bng
         9Kyo3xruyjkhJdfnU+wYXnqaNZ1xSzte8ssCmTKeljOGMRaPPztAURGPCtmM6WhPRhMJ
         cbL1IM4HjPD+Pm61pkAJBSd/vR8Q0xORVSEFtNG8+Y/qWGDoolkJpvV6tT9Ipk3UYPS+
         /B4XUdc1DPsWQPDUU1pnCitmo1/6sPBzlh7UmBvAHg+adA3oCexxUbIFgbVTErL3UdEe
         LT1Q==
X-Gm-Message-State: AOJu0YyAaOy0WzrPNHFRgZ3STbyU77gn1x2ZAV5isC2H5EnLjCbc7D6o
	eUsnVUdlN2WmUz0zL3VSphNBdhM0T+jFYFIa2xqJfSlhs2yQjn7sgxY2zm4jvnx+MyO0wY6bS63
	4Z2uDkLwZQALfRC5YiVprGOv/38eaORMJl2a+GvGlgUAqunh2Zg==
X-Received: by 2002:a05:6512:6d0:b0:512:fc60:38e4 with SMTP id u16-20020a05651206d000b00512fc6038e4mr4838999lff.54.1709045356626;
        Tue, 27 Feb 2024 06:49:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHbibhHAmZvCo7uDUDAhLzVV1Li3+DSP/zmGu74g4ICnXOvc2V6Psx50tmhQjigmz/qsRFHrQ==
X-Received: by 2002:a05:6512:6d0:b0:512:fc60:38e4 with SMTP id u16-20020a05651206d000b00512fc6038e4mr4838952lff.54.1709045356179;
        Tue, 27 Feb 2024 06:49:16 -0800 (PST)
Received: from ?IPV6:2003:cb:c707:7600:5c18:5a7d:c5b7:e7a9? (p200300cbc70776005c185a7dc5b7e7a9.dip0.t-ipconnect.de. [2003:cb:c707:7600:5c18:5a7d:c5b7:e7a9])
        by smtp.gmail.com with ESMTPSA id u6-20020ac248a6000000b00512cc8d915asm1214555lfg.157.2024.02.27.06.49.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 06:49:15 -0800 (PST)
Message-ID: <556574e4-093c-47fc-92f2-cbe2ed69e44a@redhat.com>
Date: Tue, 27 Feb 2024 15:49:11 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 00/26] KVM: Restricted mapping of guest_memfd at
 the host and pKVM/arm64 support
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
 chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
 paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
 seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
 willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com
References: <20240222161047.402609-1-tabba@google.com>
 <9e983090-f336-43b9-8f2b-5dabe7e73b72@redhat.com>
 <CA+EHjTyGDv0z=X_EN5NAv3ZuqHkPw0rPtGmxjmkc21JqZ+oJLw@mail.gmail.com>
 <a09996d9-17be-4017-9297-2004f0bc8ed3@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <a09996d9-17be-4017-9297-2004f0bc8ed3@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I missed here "I'm wondering whether ..."

> Extending guest_memfd (the one that was promised initially to not be
> mmappable) to be mmappable just to avoid some crashes in corner cases is
> the right approach. But I'm pretty sure that has all been discussed
> before, that's why I am asking about some details :)
> 

-- 
Cheers,

David / dhildenb



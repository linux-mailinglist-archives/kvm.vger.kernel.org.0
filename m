Return-Path: <kvm+bounces-35601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4F23A12BCA
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 20:36:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA9E81658DD
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 19:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C07771D6DAA;
	Wed, 15 Jan 2025 19:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QxLhcGcz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D0A14AD17
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 19:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736969780; cv=none; b=YYIQX1oR0lFsX1ZDqktOw98BRcZAfg4dv4YxOSz2uwpIubM7iSP+BQBr0nGZ6Rm7uYS6Bgoxt6HRgXYf23RrGArRVbJqcqJF0ATkDELAFsFPJznWRgxz5QuDRyg3SwJX6nAqBxzUumDTdkktDLR6rnpMXR03sCJ9T8WsR5vz/hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736969780; c=relaxed/simple;
	bh=iOy70BfVlezEpJB0lDD0UJGbnFNKewEaPzmw0semrgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o2WQdO5kZTu4507nWcWis6kIqX0Lu6JHXj1AXXmwzYHLb8B2ot9jaNaDatLzJuO+Is5Zn4uzevfwEsYs7sc2AVc4nEw4tWMJwNPnFlf/PYoFqxMw8GnVIAtFoxqglMEM3Lj8O9wd0sVQ79RQXuJQ/OlBuIBm4h9sGlaw6JKFV5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QxLhcGcz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736969778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+qlEbT9uA5wGbwhgBAl4E6qoq++gRVhQKCyZLtv5wgc=;
	b=QxLhcGczqmCC6cw5O2Qec7d3tPut3WkZ6kj8ESvrJBuyu3Ycnk/w3azqWyJSwPUpO+9GUu
	zZy/9i6VWFSWTXV+VAI/m6jO3UCiLd4BBg9NADEzLNKyNjqkF11bSWBFzoV5rX+JdH1rmU
	z6T/WlMoosqufTNeIfsUb9HFxjhPQwE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-4SFQ3xpTPzSg10oiOZPQiQ-1; Wed, 15 Jan 2025 14:36:16 -0500
X-MC-Unique: 4SFQ3xpTPzSg10oiOZPQiQ-1
X-Mimecast-MFC-AGG-ID: 4SFQ3xpTPzSg10oiOZPQiQ
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3862e986d17so68564f8f.3
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 11:36:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736969775; x=1737574575;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+qlEbT9uA5wGbwhgBAl4E6qoq++gRVhQKCyZLtv5wgc=;
        b=Tt7ktEVPuzv9R2P7kVNkufNTrFeSRBCZpFkMN0EtlQ3fm+ccD70wAUAn/M7IGJx5uy
         jWm/mjpn72yLtrfKAkm6UfM1y7xu3qjWw3OSw9DfPqVBT7nwKNJhf2C6huMBSDDhGo/9
         PV+Q1YHTtrtelADV9sG/d+YNWHNsDg8q1qgPeeJ11dSqjqVvU8tuw/3/jXk11csAXqev
         Z6Hvql0ILo2ZPxH0TF/OrSCx7JHzmmMLMz9sGtNt867Rvg+N7JIytYfJQsv63SJHy/Wn
         afvpLfAZ/cs47dPqDiOn68xKifK67YupwnYXQGcCml+wrMKTCQD61CZ2qY7W06862Vvv
         rqPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXK0MYQMsZ1/BtJDqHQTMVZrGIqZgPD7l8ovzEEd7GeR67D50xC0iH1vl1Ehj8p8WJunyQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTuXM0u3Kd6aEC/ElSgICFie7rSXB8yk9rv1m9YLdCyBE540ar
	VJqm5TNREJp4i0JXCPHI7lqqbft0G9cbVr1ZlNDm9kXWi62v0q3XawbgLZs7uCbopUvH29QM7yP
	4bsC2QJUCTnm1mKs+AXmO0g4CxDo2V8tMcN2+D7sgiOIXE6SN5w==
X-Gm-Gg: ASbGncsJ+loEPQLJqgEb3JJv67iVoo9ilv40pun4CByeRpIlp5n8PvpRZSQexpaMWQ5
	6UeWuOhu+kB6UTBUeUiKshmq4xUgAneEGtqZnAokKsaBoWJzX1YVeWwFopNI8/cXM5neouao0Zi
	bdHP2yLVzLWyvP4qlDqmWMPzhVok2QzqWMTNIsjJ3eod3rqVEV/lqV5xLqp3qg3mmbqUk/hD3YH
	YLCpliuUEY+RdMG2qStxW7JIkGlRbJgpi6HMHP45lwW3xOiDOOBO76x9Jxu
X-Received: by 2002:a05:6000:381:b0:38a:8f77:4b with SMTP id ffacd0b85a97d-38a8f770320mr22481132f8f.5.1736969775582;
        Wed, 15 Jan 2025 11:36:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IESiACywlhcNV6vE1eNRKEutn33GsR1OONXP/pZ3PPewwRDw3n75pKnebvhf2PnOKBxwYjLcg==
X-Received: by 2002:a05:6000:381:b0:38a:8f77:4b with SMTP id ffacd0b85a97d-38a8f770320mr22481118f8f.5.1736969775261;
        Wed, 15 Jan 2025 11:36:15 -0800 (PST)
Received: from [192.168.10.3] ([176.206.124.70])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-437c16c4c12sm29832795e9.3.2025.01.15.11.36.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2025 11:36:14 -0800 (PST)
Message-ID: <e4b2c596-a2a9-496b-8875-4f73ddcfcf26@redhat.com>
Date: Wed, 15 Jan 2025 20:36:13 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/14] x86/virt/tdx: Add SEAMCALL wrappers for KVM
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
References: <20250115160912.617654-1-pbonzini@redhat.com>
 <00ff9b4e7ff1a67ca43d4ecd7e46aa59d259733f.camel@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <00ff9b4e7ff1a67ca43d4ecd7e46aa59d259733f.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/25 20:14, Edgecombe, Rick P wrote:
> It looks like you missed these build issues and bugs from v2:
> https://lore.kernel.org/ 
> kvm/6345272506c5bc707f11b6f54c4bd5015cedcd95.camel@intel.com/
> https://lore.kernel.org/ 
> kvm/3f8fa8fc98b532add1ff14034c0c868cdbeca7f8.camel@intel.com/

I did, I'll update tomorrow and repost.

WRT hkid, I interpreted "I'd personally probably just keep 'hkid' as an 
int everywhere until the point where it gets shoved into the TDX module 
ABI" as "it can be u16 in the SEAMCALLs and in mk_keyed_paddr" (as the 
latter builds an argument to the SEAMCALLs).

I understood his objection to be more about 
tdx_guest_keyid_alloc/tdx_guest_keyid_free and struct kvm_tdx:

> Oh, and casts like this:
> 
>>  static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
>> @@ -2354,7 +2354,8 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
>>  	ret = tdx_guest_keyid_alloc();
>>  	if (ret < 0)
>>  		return ret;
>> -	kvm_tdx->hkid = ret;
>> +	kvm_tdx->hkid = (u16)ret;
>> +	kvm_tdx->hkid_assigned = true;
> 
> are a bit silly, don't you think?

so I didn't change tdx_guest_keyid_alloc().

Paolo



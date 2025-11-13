Return-Path: <kvm+bounces-63104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D082C5AA7D
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:42:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 181324ED991
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:36:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7A0C32ABC6;
	Thu, 13 Nov 2025 23:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WjGE52WN";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="uDMnFk/6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AF82727FA
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763076876; cv=none; b=gqRbDlzxfPXiLqVLZOuKpFoWwtPYqIhP2WRlNNKD2mKwDVCPYaao98vNHSQTbzDbmyzWSVfvQ5FmlfaSy+PIWvQQFqgZukQEdxLPYgTtkc5YNvhqsZdMWVnzuEWI16GR9BEpBBOBt0QieNOqdyz8Y1Q4sI+qQqzCgGn2dfW4Rks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763076876; c=relaxed/simple;
	bh=nSAmUj2PPzVCr9D694ZC4Y9wkmKds7/+ncIasA87VeY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qv+DOeCKQLVAZoTCvSB8VfrJJaqZKv/NbME7Z+VtBSGOgjVJKI2hl0KMpbjEbBBxe3p0AlCzH/MMXgPJS1b7X1fjCNXbapGl/Pgr5RcOq7y0vo8KBSqyNO3/p0tXC12Pk50f3zu+3Bm1ttnY6/jyifFMIOGnr4AHcdZeSKy/ZkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WjGE52WN; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=uDMnFk/6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763076873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5Fca0SgoNeBQ3o6rFvitBJywOwYUQeyoWjMRAFT/08A=;
	b=WjGE52WNFC/Uvj9qMGoajmhEvrGDUqtvEf8gHN3VAmZectH8oD7UQorRotI0z9gZBJvCzm
	D5mSeMsb8iSp7Ppx1KIlp4ize+u/IAK3p94A3G/NshefEUJ8ta1A5yAi4qdZRXC0NgCx7l
	u+Hg1zoucVMCsMvH4cG3+gmTMFkbGZ8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-9b84XG3oM8i1aIz8qPwjbw-1; Thu, 13 Nov 2025 18:34:32 -0500
X-MC-Unique: 9b84XG3oM8i1aIz8qPwjbw-1
X-Mimecast-MFC-AGG-ID: 9b84XG3oM8i1aIz8qPwjbw_1763076871
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47754e6bddbso10762615e9.3
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 15:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763076871; x=1763681671; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=5Fca0SgoNeBQ3o6rFvitBJywOwYUQeyoWjMRAFT/08A=;
        b=uDMnFk/6kdWMoxRE1MP6Sx45QO/LAc+LYdJ3skPj2n6gRD2XgQnGxS1CPV6bN3t5Gy
         H+G1JP+IWUE7HxezwbHM+sl4F8cazQt/fFRoSt8oNqIQb/ss0OUC9yl0/dqpOgxQoHWd
         tNycHpbu8GF4cOIb4eGSRLBfD3KN/bHb7y/qit6Jid/vctJVLkztHkhG44avyPGnoZLR
         ZtFQuLGLshr7JTL9N/18W7RVDy+GCqxhOuCcJJ/HYeOzqmFPDuUT7mdc8UPIZAxy5FQD
         ZojMLbEVWs9E72dClMP9ZyKBKhsHOln0uVztJXeXs1ajbWDrerrwTeOnw8EydsMlXfs1
         iNOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763076871; x=1763681671;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Fca0SgoNeBQ3o6rFvitBJywOwYUQeyoWjMRAFT/08A=;
        b=tsB1uGOmDrC7nH3Fl8sGia0HUiSpz29amoIZV4a+AQMH4BzbTrgk9rwH5WKvOgRIuV
         ODcRvO3ksEkLkgGHDnC6LME8xCoUH7U55nhmsZ7DtCw0bMUSmCxy4aDC2aj7vK7dgYY5
         CAun8Hyk97YJJTteGuqyZ2qMmaq49ZyBgLeEetlKzltE9gVWWiPd6D9RuGFCcihdkK8I
         tnlWe9R/PoHiUxTS4v4wjmDDkY2v+oiibCEeoIZJBRiavqZQQeyt171g3Cz4arznU4Pr
         Rbjhr/1/fazIM81KLPI21yVcL5FyT6bX0s87SPi0msloxZ6xeqlP6aPyPiy3oU5G0mxQ
         1YNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWOvaFMqkTqbCqgKB8K4oU3tOv+wpGff+zvEkZN9cZwZ8yzOn+G8DR03geKKZmlybG2uGg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4ueAmZyNri/eVxVBGjFrEy30xF9fmtQu8ryce37ccmjNyqTWR
	OkjwjSM+4j5ZNiD+obI4OnkLom1U0dj/4b9myJRBJ5vYt80elhq7S7f8eyWytIEMkEObDejFaN3
	gC6E+zWL8tCA4tz8669cuVJn8ZHz2sK1ujjrMlC7W6130f7cNDbN36g==
X-Gm-Gg: ASbGncvy3MFquf75EyGvgQcOEgtoY9rwVfWbBbtB0AZlBf0yQb7I5m1RH4cgO6w/7ZQ
	9x95st/eGlN+24/Vff2LaCzuYahH4hV1Aam2yL0NMAq54ylyRKyK3q3gMZJPoZl+Ac2PDYdjXkO
	hroUuJ7++Sbl8q4mzB+72xJSsFr9V0nAotYO0Y5CrJLiQZkKZLgEng76mG9ZhJGHTGzavAclBg6
	W6cgOkjr7VN4dZEvCSx8RnrfvmRqw2qtrx//s6HQVlchlBvALRzi1gQNqzPtA04JIpu8EE/NdIX
	wpyZUM6wJ1GxwkFJohGN4dh7epvYqqxHZ2sh3c4N0lIyX2z7Pfzo23nCWHtu8WZGvjgi8rm6qXm
	i9dlgjU5VWxreylSEv+u9E8+D5SthsN7wky74UunpLL63iHW0+JBl3rguZ6CFaKATPDbwq709GD
	AJiMvA
X-Received: by 2002:a05:600c:4594:b0:477:73e9:dc17 with SMTP id 5b1f17b1804b1-4778feba6c6mr10084575e9.35.1763076871332;
        Thu, 13 Nov 2025 15:34:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGQOYOlxdhURLMzvoi/8fJYt0kspxD6hs1g4npvnC2GTeZN24SCGJgDIZvczjJpV6clo0xsGw==
X-Received: by 2002:a05:600c:4594:b0:477:73e9:dc17 with SMTP id 5b1f17b1804b1-4778feba6c6mr10084395e9.35.1763076870930;
        Thu, 13 Nov 2025 15:34:30 -0800 (PST)
Received: from [192.168.10.48] ([176.206.119.13])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4778c897b1dsm57706675e9.13.2025.11.13.15.34.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Nov 2025 15:34:30 -0800 (PST)
Message-ID: <febcd8bb-0a47-4c3c-8fda-fb13012aee31@redhat.com>
Date: Fri, 14 Nov 2025 00:34:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 16/20] KVM: x86: Decode REX2 prefix in the emulator
To: "Chang S. Bae" <chang.seok.bae@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: seanjc@google.com, chao.gao@intel.com, zhao1.liu@intel.com
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
 <20251110180131.28264-17-chang.seok.bae@intel.com>
 <6a093929-5e35-485a-934c-e0913d14ac14@redhat.com>
 <25c8c533-73a3-4cc1-9fbf-4301b2155f11@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <25c8c533-73a3-4cc1-9fbf-4301b2155f11@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/14/25 00:30, Chang S. Bae wrote:
> On 11/11/2025 9:55 AM, Paolo Bonzini wrote:
>> On 11/10/25 19:01, Chang S. Bae wrote:
>>>
>>>           case 0x40 ... 0x4f: /* REX */
>>>               if (mode != X86EMUL_MODE_PROT64)
>>>                   goto done_prefixes;
>>> +            if (ctxt->rex_prefix == REX2_PREFIX)
>>> +                break;
>>>               ctxt->rex_prefix = REX_PREFIX;
>>>               ctxt->rex.raw    = 0x0f & ctxt->b;
>>>               continue;
>>> +        case 0xd5: /* REX2 */
>>> +            if (mode != X86EMUL_MODE_PROT64)
>>> +                goto done_prefixes;
>> Here you should also check
>>
>>      if (ctxt->rex_prefix == REX_PREFIX) {
>>          ctxt->rex_prefix = REX2_INVALID;
>>          goto done_prefixes;
>>      }
> 
> You're right. Section 3.1.2.1 states:
> | A REX prefix (0x4*) immediately preceding the REX2 prefix is not
> | allowed and triggers #UD.
> 
> Now I think REX2_INVALID would just add another condition to handle
> later. Instead, for such invalid case, it might be simpler to mark the
> opcode as undefined and jump all the way after the lookup. See the diff
> -- please let me know if you dislike it.

Yes, I also thought it was unnecessary but waited until we merged the 
respective patches.

Paolo



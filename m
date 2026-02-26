Return-Path: <kvm+bounces-71952-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kN7+N/AdoGmzfgQAu9opvQ
	(envelope-from <kvm+bounces-71952-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 11:18:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 657131A4238
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 11:18:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 075E9304AD0E
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 10:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 541993A1E63;
	Thu, 26 Feb 2026 10:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EYJVcRiD";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="atmAsdR9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E70D296BA8
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 10:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772100999; cv=none; b=PZWMYIXrzg6/rt3RlgFKxBHGlzXcxGudpCAq6ioxo9l+jt4qxg5Ny58xLsxCFovU9zlvWAgmhaa1GYvw2/0HvyPkJaA0+z9R/bgKF0KaXC8aESgBuh0+qejbHbIR7Ep9IgHmbzeVTOZGFIuHazsiJx2CeYtQ5mmRpFDV15iqo+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772100999; c=relaxed/simple;
	bh=taXgugruSNQ0DabjU01prcU4nAnughsMbQTxiW28RzM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TC/UI0K+S7YPqwBhR4UVgyPsE5be27O8qOIhbIBBRULv81nCMsun6kCJ04cnunC1VTkrbvVosRBQ+GQF7XMlWeK/A/mNkbYQkjh9h6aeTwKLHZda+v3w3hAMwsNRUFECogyrSgRIXgEwOKaJ7w1u2QokRuwPmwby0DBvzhrUl1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EYJVcRiD; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=atmAsdR9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772100997;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9oWCswLb5L7ptghwnTCvOR8gC3pEp5Uc3EP+QJdSQO8=;
	b=EYJVcRiD8EwQJ6n2HaxLG+f0iUJr0Y7vv5oA3bKIk+kz4lMjr6g7do8hCaKASSk/dZFcr0
	aeGhYccPveJu4cxOKT8SSNiQSQPhG9JgT+68v55ufyN9sjAqGGf+1BJqwKd5Dp/xBSZ++F
	zUXOBkkamnEXMNwhxnQLvNsLJhZZGUw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-8AqYkd4BMHyAZt8BCFgIVw-1; Thu, 26 Feb 2026 05:16:35 -0500
X-MC-Unique: 8AqYkd4BMHyAZt8BCFgIVw-1
X-Mimecast-MFC-AGG-ID: 8AqYkd4BMHyAZt8BCFgIVw_1772100995
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-483a2db68caso5205745e9.0
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 02:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772100994; x=1772705794; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=9oWCswLb5L7ptghwnTCvOR8gC3pEp5Uc3EP+QJdSQO8=;
        b=atmAsdR9tH5ng4I2i46/G5TzxhUCNyt+Kq/3OK+JUNQQrrBlkyR4ePbhxJibsz2R4E
         Cs/wdio5IIe0QrO3YzjN7bHDk2fXsJZOVo5bJNzVemuVacJRYjbanGCHbsBPy1+rD8Ta
         zlT36+h8lsN2ukDXNF22nK1ilGKGjNMJy3QMrEb11KNHSW5Ne44bs55z4z/upmlu7MMp
         Lhqj33JO4TV1UZ0NIQW4r9uRbJK3ex7e5u1hzuBZBaDsfTNvoriFqNT4iVYwtY/yR7x5
         M5bsbi3Pu2zVDJwIoJQjMTX8tvpWXUpYTG+pBAc93Cr9XtSOKKGF47+9N6JSeX79rf5X
         kHcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772100994; x=1772705794;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9oWCswLb5L7ptghwnTCvOR8gC3pEp5Uc3EP+QJdSQO8=;
        b=tFvhTkZ5oMvnr/JMMHuAMdtz36cevY0er2SW0sGEMgbpazMdlQU+91piOiYELgLhm1
         KMfuBKSNIinsGwhfaSIWs5JAF4g9GGVCINkwOzn8M/XtxHjibLpLovJfA/5GkiscS8ai
         1EE6MZfHesubrOg1QRvYZv+J/iDUfAN0k0M+wE4BtGLvb7K6HfJ6vbO4PwKwhHTwoP6c
         mONtYExw+3o8rzYWlV54Tte/NkS/tj/pnb5VqwwyCN8qM+x0sCzw5T680l6z2SAvntOs
         6bTHQqGuVrfI8C2b9otyapYFxfmgoasqyxG7xxChs9e8cOv+utnZ426tai0vwqMSuhbt
         JNfg==
X-Forwarded-Encrypted: i=1; AJvYcCXjo4MmHo//WActzXJuWbKjtwug0bemTosPgMLm3pFSQYXF2NOU7r3XBEoutrD3grx01fw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFOYNFVI/pFWdVGPsHswDU+jBq+Z8NfrVanR5FKWRKVSA51K3z
	rHxHBoXMytCSbBwI8lJThxszr501upgpsF3KIkqOQ33KRvqYW8cDW8Ifqu0blugzqOcfYwVnOPo
	Ul3D2L3YmbixpOoL0YI3OFLjeSKhtosvtOMbS2fKSW3l8JWIg28FaPA==
X-Gm-Gg: ATEYQzx//NOzFd+09tcmAEahaJK1Q/I/bWGMRnUroSDrh7j70MkgOVP0rJJgBvbkxtL
	NqNY3fwySJnIWaky/zZvAVjss7TCyUrLA1lWeAGp2QrIzH+Rg9TmRccuOPv1SEh0ITLQVGMcaGO
	HaFpmQh+3VDhsMt7TfQz7kIzHk3li0doVVKzPGV344u0/KIUw7mj6fQMXYCAk2gC5uqwTPgLFQY
	9jJ57bw7gKnfbXrZ0mRAr5pVzEqLYl0/GchYDroVMDYcVWI7G/WRuqjwOLlbbCxKjWVxPrNRabg
	KjBBL4EvHKsU7y04sAOKNx1SJ0IBCDIuGqsO73WVeAdqYHa4pAj8ga7bO6x054LqnsQuqhdj7S/
	9HUa4g0CzetB8iQHrAIgMxZ6WuvBm0HgpKitrJT/9KuopZcjuEgbVrMhCog==
X-Received: by 2002:a05:600c:8b35:b0:47d:8479:78d5 with SMTP id 5b1f17b1804b1-483c3db518dmr24698305e9.7.1772100994472;
        Thu, 26 Feb 2026 02:16:34 -0800 (PST)
X-Received: by 2002:a05:600c:8b35:b0:47d:8479:78d5 with SMTP id 5b1f17b1804b1-483c3db518dmr24697785e9.7.1772100993974;
        Thu, 26 Feb 2026 02:16:33 -0800 (PST)
Received: from ?IPV6:2a01:e0a:165:d60:2c1a:3780:4e49:dfcf? ([2a01:e0a:165:d60:2c1a:3780:4e49:dfcf])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfbb465bsm78546265e9.3.2026.02.26.02.16.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Feb 2026 02:16:33 -0800 (PST)
Message-ID: <23522438-72ce-4b54-94ba-125ec513876c@redhat.com>
Date: Thu, 26 Feb 2026 11:16:32 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/14] system/memory: split RamDiscardManager into
 source and manager
To: marcandre.lureau@redhat.com, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Alex Williamson <alex@shazbot.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>,
 Mark Kanda <mark.kanda@oracle.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Peter Xu <peterx@redhat.com>, Ben Chaney <bchaney@akamai.com>,
 Fabiano Rosas <farosas@suse.de>
References: <20260225120456.3170057-1-marcandre.lureau@redhat.com>
 <20260225120456.3170057-7-marcandre.lureau@redhat.com>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20260225120456.3170057-7-marcandre.lureau@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_FROM(0.00)[bounces-71952-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clg@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 657131A4238
X-Rspamd-Action: no action

Hello

Two little issues below break documentation generation.

>   }
>   
>   /**
> - * memory_region_set_ram_discard_manager: set the #RamDiscardManager for a
> + * memory_region_add_ram_discard_source: add a #RamDiscardSource for a
>    * #MemoryRegion
>    *
> - * This function must not be called for a mapped #MemoryRegion, a #MemoryRegion
> - * that does not cover RAM, or a #MemoryRegion that already has a
> - * #RamDiscardManager assigned. Return 0 if the rdm is set successfully.
> + * @mr: the #MemoryRegion
> + * @rdm: #RamDiscardManager to set

Should be @source

> + */
> +int memory_region_add_ram_discard_source(MemoryRegion *mr, RamDiscardSource *source);
> +
> +/**
> + * memory_region_del_ram_discard_source: remove a #RamDiscardSource for a
> + * #MemoryRegion
>    *
>    * @mr: the #MemoryRegion
>    * @rdm: #RamDiscardManager to set

Should be @source

>    */
> -int memory_region_set_ram_discard_manager(MemoryRegion *mr,
> -                                          RamDiscardManager *rdm);
> +void memory_region_del_ram_discard_source(MemoryRegion *mr, RamDiscardSource *source);
>   
>   /**
>    * memory_region_find: translate an address/size relative to a


Thanks,

C.



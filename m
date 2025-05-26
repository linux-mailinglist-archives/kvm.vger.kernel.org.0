Return-Path: <kvm+bounces-47696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E9593AC3C94
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 11:23:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DCFD1895C81
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 09:23:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A1DC1DED51;
	Mon, 26 May 2025 09:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bR2tZM/5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947FD481A3
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 09:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748251391; cv=none; b=RdQkzunkMYzExKucChJAf8j0XoMiV9upBg+88NGj92ozochtJtCOJRqa7nZ/u6iGYHTNtkqHeG7abQdPMv09KSXZhEA6u8X3ul4B6c7Q5cwGYsCBD3u1QACaTIy+dgN8mrSVvSYF0etBwD4HZL9dtC8o4+90Xdu5++EGt4g0XqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748251391; c=relaxed/simple;
	bh=JCaBnUpSAIcktj+lWMB2Nrj/aH7F/mF2WGfyLJ13KJ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lz9ZpSCvf4uZ8pw5RTZESciN4kQ8k+nCRbBhQA8O+zkHuAXh4uPHcXV6C4kGN/q0GX5PxAlIcnhb1GYVT11bTFBZptQvtf77tpYVTfnh0nqcN/tD1lN9R6ivxRPaBwH7FBzNJ8Px6wHmChgNEYIbwXXgoTYyjohzlBk69Eyg1SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bR2tZM/5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748251388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=phTdJj0KAJyBPbCCmlZgtPAAFKe+8e9lUlf5Yjatomc=;
	b=bR2tZM/5f+6exUzYb1UzM/pSlm38LdjR81fpo5fylrPq9/xPfqwJs+VSiD00cPNrg9aKfO
	HgQ8ruUMpHDkbtiNDhhr/OwFwOyV3TnPIkTWAAhpx88/AX89omNJ7cspHrEs/bPEhgbzF4
	rFQm9ReL/AfzPHG/whu5Lq2x2R8eZxs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-438-3LUvEXIfNJ-w6GHsRHQ0Dg-1; Mon, 26 May 2025 05:23:07 -0400
X-MC-Unique: 3LUvEXIfNJ-w6GHsRHQ0Dg-1
X-Mimecast-MFC-AGG-ID: 3LUvEXIfNJ-w6GHsRHQ0Dg_1748251382
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4cfda0ab8so517924f8f.3
        for <kvm@vger.kernel.org>; Mon, 26 May 2025 02:23:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748251381; x=1748856181;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=phTdJj0KAJyBPbCCmlZgtPAAFKe+8e9lUlf5Yjatomc=;
        b=eJvs3XxFp35dJW9XBsL+suipzNfNsjsPeAWBXWHpX8IyrjyN2kk2PGWDV4u5QmlWxD
         6s5Q1is4/aO9kZA1Bn1f//hucyY62NTITia7ruNFigmMBv4DwMLY9KPCkl2CKEH8HqqB
         Y5/HlO2gSdynesNbLQABJ7viXh3LNk5Vh5oepWdn6VE3aLpLH9YsTt9nUSKNM/K+d1xm
         kfoHxUOC5ZyOhk3cTE2aDQ72NkiLIVCHGEE5YnhjIJ2QfUbX3E4EQ+NX/8hFXsIgvYWr
         /QyWZbNpo7alxULf3bOAUiGgqTIJnFu/IIlKj1JytF7BS9zVgYgLRTl1ciS0KrqefbZU
         0aeA==
X-Forwarded-Encrypted: i=1; AJvYcCWU1R1dUDkrAM9tQqgwhldCzJCyYIs0HR+srx4umKnax0H/F49TGn68t2+RAsogFFPv78U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzaJsT7OoSz6ztKME7KFiOxoUICzp26cBAs4AOthU5Ld8NIMgUB
	jgbWxO6oviHLBTrcOQw8KwvIv7cIZXiWq/907s+5xj0SlSaCMLTCWFnrnhV1mnkUVwM0eLrNTRQ
	u/1YX4uz/biEHWHo8S+k94uJ4ZXYL6DBynQm5WKnqehXLmaDeCUwtFw==
X-Gm-Gg: ASbGncvORQ362Nl5SdtWGnXKux4AcZnzlAahlRcdSpLKYKBqwzCD9msTP0rR4JUKU31
	7qmjwCHsJc0YVhA9jGU7TtM6Ozs6t55IWKRzYHYF9ZL25RIAxaY/YgGndXz8cxSPjcrCAjlCqaY
	5d3KqpSfINEB5NcSRjEvjbMFFXXOkSgJQk6R+UY50T/xtlHT7Rzl1FtCq4vUKFf8OxKPnW2Bs6X
	0Ri32EWJ6EgsbaUNf2Lg85ziCTkgT4Sj/D+CcUCTwuK9/xseDGSnm6VZ4GJyyZbFmZmCTZJ7+ix
	BiqbTfGNf+pc3WhlB78wN6WT6dNuNioLa+AEz8jSd0SwSd5Admw6lxkl6iVZdR4y19f2fTC3gk7
	qWrqz22Q2SG8J2JBvIFXHhm99FZTlmfg+B49Fnxk=
X-Received: by 2002:a05:6000:2082:b0:3a1:f68b:57c9 with SMTP id ffacd0b85a97d-3a4cb407b33mr5416593f8f.6.1748251381641;
        Mon, 26 May 2025 02:23:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0Iy+mETN512dlt1DljBDoAYB1upu7FTX113bm5Gtwq9OByr75EkOWODGpn6zZkGn10wi9vg==
X-Received: by 2002:a05:6000:2082:b0:3a1:f68b:57c9 with SMTP id ffacd0b85a97d-3a4cb407b33mr5416576f8f.6.1748251381293;
        Mon, 26 May 2025 02:23:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f19:6500:e1c1:8216:4c25:efe4? (p200300d82f196500e1c182164c25efe4.dip0.t-ipconnect.de. [2003:d8:2f19:6500:e1c1:8216:4c25:efe4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4cdde6415sm6767370f8f.60.2025.05.26.02.23.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 May 2025 02:23:00 -0700 (PDT)
Message-ID: <ccb81d9b-1c89-45e4-86b0-1d30a8e94930@redhat.com>
Date: Mon, 26 May 2025 11:22:59 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/10] KVM: Introduce RamDiscardListener for attribute
 changes during memory conversions
To: Chenyi Qiang <chenyi.qiang@intel.com>, Alexey Kardashevskiy
 <aik@amd.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
 <20250520102856.132417-10-chenyi.qiang@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250520102856.132417-10-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.05.25 12:28, Chenyi Qiang wrote:
> With the introduction of the RamBlockAttribute object to manage
> RAMBlocks with guest_memfd, it is more elegant to move KVM set attribute
> into a RamDiscardListener.
> 
> The KVM attribute change RamDiscardListener is registered/unregistered
> for each memory region section during kvm_region_add/del(). The listener
> handler performs attribute change upon receiving notifications from
> ram_block_attribute_state_change() calls. After this change, the
> operations in kvm_convert_memory() can be removed.
> 
> Note that, errors can be returned in
> ram_block_attribute_notify_to_discard() by KVM attribute changes,
> although it is currently unlikely to happen. With in-place conversion
> guest_memfd in the future, it would be more likely to encounter errors
> and require error handling. For now, simply return the result, and
> kvm_convert_memory() will cause QEMU to quit if any issue arises.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---

[...]

>   static void kvm_region_commit(MemoryListener *listener)
> @@ -3077,15 +3140,6 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
>           goto out_unref;
>       }
>   
> -    if (to_private) {
> -        ret = kvm_set_memory_attributes_private(start, size);
> -    } else {
> -        ret = kvm_set_memory_attributes_shared(start, size);
> -    }
> -    if (ret) {
> -        goto out_unref;
> -    }
> -

I wonder if it's best to leave that out for now. With in-place 
conversion it will all get a bit more tricky, because we'd need to call 
in different orders ...

e.g., do private -> shared before mapping to vfio, but to shared 
->private after unmapping from vfio.

That can be easier handled when doing the calls from KVM code directly.

-- 
Cheers,

David / dhildenb



Return-Path: <kvm+bounces-37831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 340DBA3069E
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 10:06:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E87163A4C61
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 09:06:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62F4C1F12FC;
	Tue, 11 Feb 2025 09:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FCNytzNL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035201E3DF8
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 09:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739264774; cv=none; b=fAVx3LNjAwTaQpV6TTkKoEzkDwyKpEKKWFicUkZLFAPQfnUc7AM1dSka9AJbnRwKRMX46+7lg7URcFqQXqIdJbtfIImpJvEWeUQq3BSyiT20tqL2QUywQ5+urjdgJwCw8rCYY7RAby9wTaGoE0KsJXzXy6BGIz+fKOyeRNF9+8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739264774; c=relaxed/simple;
	bh=yDIeTeSA5W0Cm2abZ4x6XIe6w2yeaTZLEk32jiF5/mo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OjS9X1Y3bFIRB/Eo7iURIrz792qh2YByVKQbveLrzOXHgUNW8ZVhAgu3Jw8dZpPGG66WF7BJ8p4bxLVStM+xencYLYCDPqHX0E9VMaOUAcHdZ2Fzjd12J4zi/l3amzmhxxGPQJ6q7y4W3cbZjC0XIDsQNjOIDXG9mybBvcUGh6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FCNytzNL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739264771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8YgKJ/gyFf/DhGZNEgQKtaAiD5gUVgqU2qFrIj9BRFM=;
	b=FCNytzNLYHKIGnuW3tkqWnWTbZf1hFU7dQkadDolw3YGlDba0YIetTmezKZWWkkssprtCl
	w5r+YCG2D1WmLGdxvhvZ37GT+sTo1zLXVEbzxeGiZT/X2w9OsBVlWMeNFQqvmGdVEicZ+q
	UEKX6NliJF16xGRTOLNOmt7N3prV3zQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-396-3cSJX0J3N4KVGw1Je75K2Q-1; Tue, 11 Feb 2025 04:06:10 -0500
X-MC-Unique: 3cSJX0J3N4KVGw1Je75K2Q-1
X-Mimecast-MFC-AGG-ID: 3cSJX0J3N4KVGw1Je75K2Q
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-38dc88ed9c0so1528212f8f.1
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 01:06:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739264769; x=1739869569;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8YgKJ/gyFf/DhGZNEgQKtaAiD5gUVgqU2qFrIj9BRFM=;
        b=At46WqakMhylf+oVRht0C4zR59MZeQrx8AxrxXu76yDntDSU/yacMNxPiCNzRTa/hD
         VQDxsLoFRag5d2QHOFjaMxGXzk1Lzdkx+ztLVPZzDUIVm4NIAi97MI5p/qOt0Oc2ZVuj
         ci0Byx5mLiVuFc1I+S4Nrb03j/YAuWXsvNGtHpFcuaWAV8F1vIHofBYY82y5XWMcIgeB
         mRh3oPzfP7YI7LpBLTsROBomF18aXsIUhBx/i9QiB25M+yuqzlOq00NSUc/hpg7MYV2b
         u2+duzA9sfTHdUlnGYKGhZS+p3Mq+78fLP10WkMipztabjNVJhDRGC+ve4C+uEbqZ0iG
         KC0w==
X-Gm-Message-State: AOJu0YzOBwnVz1DV4yqqZ0MLAmASTpwkK3dsl50XobDoTZ2AGMAyWHYM
	BIHlTVL3tLSWPRPD3d+912acdHPTG4FCwz4ts8vJDDOm86MEuNUbHFeUsmlMtIO4esJl5j2R0s+
	cMsmRrgQUH+38LkXlhLJj70/baghGU23+vZUxNAug1NQZM1EXmw==
X-Gm-Gg: ASbGncu8ThksBDYiNet90n2mdqLBY3DnJWO9d51uaGohf7BYejczRzmmTZuv6Fw0x4v
	O+JJ/xtJ/Cr1benD5oGTim3UKDxJUDAMlicwbX3poi30ACHG3fyXGzJAtYRTLR/uHLfBxlPivMK
	Q10ObVrRDxh1J3nsL0uhAw29O0+XgWdK37UjFPRAyCVBbxnL91WZcWkAEaYsAKQ2hFydZNmAzzB
	1VyLTZDMLxbMpQW9Q7nbqzCVObQb63O/Vbkh7A3CeOESNx0jrwBukixoCMLVArddi+RuMUjYusg
	1PqBiszd7xJlhCp3wEd1bWncpKXMTRd+qyW9rFk=
X-Received: by 2002:a5d:5f91:0:b0:38d:df05:4d9 with SMTP id ffacd0b85a97d-38de41bdfb5mr2324378f8f.43.1739264769154;
        Tue, 11 Feb 2025 01:06:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHcdWl9nKSULAYSil1vGNN0U5ZrLrbZ/EWJVc0ggtfwYSoFAFAf2Cs1oAf6I146TcRMTYngmA==
X-Received: by 2002:a5d:5f91:0:b0:38d:df05:4d9 with SMTP id ffacd0b85a97d-38de41bdfb5mr2324345f8f.43.1739264768821;
        Tue, 11 Feb 2025 01:06:08 -0800 (PST)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4390daf3c70sm204994695e9.26.2025.02.11.01.06.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2025 01:06:07 -0800 (PST)
Message-ID: <897102c0-7b5e-4495-9f21-573beb338925@redhat.com>
Date: Tue, 11 Feb 2025 10:06:06 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4] KVM: SEV: fix wrong pinning of pages
To: yangge1116@126.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, seanjc@google.com,
 21cnbao@gmail.com, baolin.wang@linux.alibaba.com, thomas.lendacky@amd.com,
 liuzixing@hygon.cn
References: <1739241423-14326-1-git-send-email-yangge1116@126.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <1739241423-14326-1-git-send-email-yangge1116@126.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.02.25 03:37, yangge1116@126.com wrote:
> From: Ge Yang <yangge1116@126.com>
> 
> In the sev_mem_enc_register_region() function, we need to call
> sev_pin_memory() to pin memory for the long term. However, when
> calling sev_pin_memory(), the FOLL_LONGTERM flag is not passed, causing
> the allocated pages not to be migrated out of MIGRATE_CMA/ZONE_MOVABLE,
> violating these mechanisms to avoid fragmentation with unmovable pages,
> for example making CMA allocations fail.
> 
> To address the aforementioned problem, we should add the FOLL_LONGTERM
> flag when calling sev_pin_memory() within the sev_mem_enc_register_region()
> function.
> 
> Signed-off-by: Ge Yang <yangge1116@126.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb



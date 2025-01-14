Return-Path: <kvm+bounces-35481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 09942A11571
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 00:32:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1AF57166722
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 23:32:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82ECF21505A;
	Tue, 14 Jan 2025 23:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VhoLeljJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD1920F077
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 23:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736897551; cv=none; b=q+u835CJic5zWMvvAdnvlLrpN940xXeTsneHhavZFJFjX90JAs2b9HpDhackqPVO7Y6rqokF9PqD6++QNYoy9kPVadFJG+H4iMigkzRA7KlAaEBS+Swxn1i+ksmZmJw+r3XohHQ7OBqz5B22jnhX7lk0yjBP/B8Ay8WdhVdOEp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736897551; c=relaxed/simple;
	bh=/T+OY4OmyRWpdVrFXyc5wLrHbxBlM9/azPHzMNW7WEA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VmNCPycCcyZ2rooVAthNjq5bHFY0E3nwH1UpeABKlMBJoQTSEDlCjzGgxUbQ4XzhIzh6EX+7l3+RApT5H+0UY9S5h8ltxDPQdA+x+AbRMQAarbW8D7GdzmIuvfPCCoOZ0vpWBbcljzcQ4OiQHupVPsT5wcM3FC3I7wB9NAhjbXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VhoLeljJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736897549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p1PJwXN5LH4521FXw4nXV0gL2WqhixVjm6mJykcWcXg=;
	b=VhoLeljJ1yIu7CFqC+ozP7dkBX0b3pf/B5RKCwiG+GZUOojOhPlTCDzfLZ4Vl9NNZoASgh
	bi9l52Q14nJa76xVlSz/+2Pr1ba+h5RT8gELThZjDn4VasDx806oEFWUQQ60nIIS08AaNb
	MB0eLCIPOCDCSuHo6jja7rQTaPFdBfw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-W4a5VjabPXyIMcAFrifmCQ-1; Tue, 14 Jan 2025 18:32:27 -0500
X-MC-Unique: W4a5VjabPXyIMcAFrifmCQ-1
X-Mimecast-MFC-AGG-ID: W4a5VjabPXyIMcAFrifmCQ
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4361b090d23so31796385e9.0
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 15:32:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736897546; x=1737502346;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p1PJwXN5LH4521FXw4nXV0gL2WqhixVjm6mJykcWcXg=;
        b=r8LHYocNyDleSmBCq/r2qX2LQjdBVJ+y79As5Wo7X93xCCHAMhImszrzX9y3d1NsSd
         EFzkWENqIc+YTooViQ4CoOcymw02L0Z8Z1OLJikAjeWXyQAYN1ZZxC0FG3UbgcXUaB3S
         qdaoQ5RT6XX6jebs4963ZGwaEzO7TK5MsWNfM4hs/BYG/FHDholSBnltLb9DUfZjgIOB
         iA3coTx5owiIILeP/CZI/aTHr3UfFt5SPn1uNhbhpwKo+NoODZ/0AEdIfBmXR62YBddM
         O4Cbf0f3UvXKInTn/lBtIXVqQ8hkbem8CAcEOZ1hrNd7LIzG4z2epIAS44twPlhKzm+P
         OFng==
X-Gm-Message-State: AOJu0YzHZqDIkTuhnUHyi3JIShEoDAn9rgZ5YS7z4xP9MQhLnyn0EWaW
	d9ob3IxTGA51mShLfITC6qToLK+Zz8bLLyMZSgf1jB3nYPzxKRT5uiCc07rVR3+jKPTDOgXYbrg
	hZalEmThp2OTDGFLgFncmadfbXVsXOceUjbn6f4uQWmsoxrnIMQ==
X-Gm-Gg: ASbGncvgFDr0Wt1HrFEGOS0GEjLlVdEwqpe70u8MVWYPdXgEOHNQSeuoya01bWi7e28
	k7RalLqg2dBkq2wKm0i2LIUJhlT0YPJEHndcLGGy+/+kgnsOC6xm6KKDwJLtdp5eq1IR0q8IFVL
	KAx27GOj8cwnsH38yVa4dUaTKiKktLgQIA7ittA5LIAUroDDiXRpgUITFJhJChbu63t5RKpUU5s
	qUu1lhsAm3PkTuX3QH/odf9TZLas0Ftk3L1LVe30G6kHmQVFf2hUjvYNbji
X-Received: by 2002:a05:600c:4e46:b0:436:488f:50a with SMTP id 5b1f17b1804b1-436e26be5aemr259222885e9.17.1736897546566;
        Tue, 14 Jan 2025 15:32:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IETLTgqo6f5HuhbUcxZ3ter4nMQl7JFM6YF4YP3njvboY5EBVvNE2lT3PWRG2fQ3g8vl7oCnQ==
X-Received: by 2002:a05:600c:4e46:b0:436:488f:50a with SMTP id 5b1f17b1804b1-436e26be5aemr259222805e9.17.1736897546253;
        Tue, 14 Jan 2025 15:32:26 -0800 (PST)
Received: from [192.168.10.3] ([176.206.124.70])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-437c16610a0sm19753555e9.1.2025.01.14.15.32.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 15:32:25 -0800 (PST)
Message-ID: <be581731-07e0-4d5c-bee6-1eb653b7b72d@redhat.com>
Date: Wed, 15 Jan 2025 00:32:24 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/13] x86/virt/tdx: Add SEAMCALL wrappers to add TD
 private pages
To: Yan Zhao <yan.y.zhao@intel.com>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Huang, Kai" <kai.huang@intel.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "Yamahata, Isaku" <isaku.yamahata@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
 <20250101074959.412696-9-pbonzini@redhat.com>
 <c11d9dce9eb334e34ba46e2f17ec3993e3935a31.camel@intel.com>
 <Z3tvHKMhLmXGAiPg@yzhao56-desk.sh.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Z3tvHKMhLmXGAiPg@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/25 06:50, Yan Zhao wrote:
> Yeah.
> So, do you think we need to have tdh_mem_page_aug() to support 4K level page
> only and ask for Dave's review again for huge page?

You're right that TDH.MEM.PAGE.AUG is basically the only case in which a 
struct folio is involved; on the other hand that also means that the 
arch/x86/virt part of large page support will be tiny and I don't think 
it will be a problem to review it again (for either Dave or myself).

> Do we need to add param "level" ?
> - if yes, "struct page" looks not fit.

Maybe, but I think adding folio knowledge now would be a bit too 
hypothetical.

> - if not, hardcode it as 0 in the wrapper and convert "pfn" to "struct page"?

I think it makes sense to add "int level" now everywhere, even if it is 
just to match the SEPT API and to have the same style for computing the 
SEAMCALL arguments.  I'd rather keep the arguments simple with just "gpa 
| level" (i.e. gpa/level instead of gfn/level) as the computation: 
that's because gpa is more obviously a u64.

I've pushed to kvm-coco-queue; if you have some time to double check 
what I did that's great, otherwise if I don't hear from you I'll post 
around noon European time the v3 of this series.

I have also asked Amazon, since they use KVM without struct page, 
whether it is a problem to have struct page pervasively in the API and 
they don't care.

Paolo



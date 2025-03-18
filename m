Return-Path: <kvm+bounces-41459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 20836A67FCC
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 23:27:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 20D9819C4ACB
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 22:27:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8D772063D7;
	Tue, 18 Mar 2025 22:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OvsxFMFQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8021F4164
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 22:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742336819; cv=none; b=aEpWKgs/FAIX3FUcpFcq78pc5N8c1uVovk88eZfsn2dajHBwl9cSzzE2AKgjnsIDiDOfablVVLNoK6Owc+OJBySuflQe0uXZTUKe7upTFmpB0QQRpWBPSMWMGaZ9GsHktF6yqU/iqQDdK78Z5RsXSg1Tzmwscf9rO2PXVf5F0eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742336819; c=relaxed/simple;
	bh=EPvTZvQhRHUGCEVFcynstiCefy/8+3K395i7ASRUf9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OWcmx0f+NrCoBdhbZ57EnrgZoS7LAbYpnBii+HDgttf9JkYuzrsVEdNrdVCLV5YUIE10dC6R6menhm7uUoGJXN+9xzkFb0eTwaB911PzaXQdZ1qSv5mUQ+I6Ul3zGfdZQPTRy2XU4hXx98l3XmUBGavGK1jMG1GXB8GeFi6GokA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OvsxFMFQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742336815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BJVFLhRfFbH1bQJMOV/BNGlUJZXnijES874Ix3jfTjA=;
	b=OvsxFMFQUGN9k9QdCxvAEI0dOzDKIftmRjD+YofzQoV3pCuA7cKJ4czWcSsHlvJjWZofs8
	dk3SF+3WPTjG0LudfLxA3E5l/F83buY44WA5rWCs9QbgvEleUpSwphm064zsdQp2gtU6ac
	z+s42PFd/o+MeZtnQwtDmNAMrEYmVVI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-542-b8AhIAwuNKe4eN6TArzSkA-1; Tue, 18 Mar 2025 18:26:54 -0400
X-MC-Unique: b8AhIAwuNKe4eN6TArzSkA-1
X-Mimecast-MFC-AGG-ID: b8AhIAwuNKe4eN6TArzSkA_1742336813
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-39143311936so2717968f8f.0
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 15:26:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742336813; x=1742941613;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BJVFLhRfFbH1bQJMOV/BNGlUJZXnijES874Ix3jfTjA=;
        b=CTkOnGiaYvm+R/OCovjPgUIvZ1W5V3Jp0mNlOY1k2z75t3p+czCtPe2hayANnTLoh6
         3A+mNURJ2Ni2CqSSPWm9jrsYLd12ytX/OgmcQxpy2mdogoDZEmUEkvUkh93gHooxiV+L
         34LjKV9uqS2kAaeWA7C/3pUqdbdg2ZRvxVTC2/suorFlSIWYLQ9o06EBG+Mtp61W5Zmo
         otjZq/Kcl97P9hVr4zL4Lg5oJQQI8ULM9Wxi+j5Ze6YK6KTlvHk4TvhNsNzaR9jeMGQP
         8RxkqdmtoJ7PHoWr9IuznEDYCHar8z+d6aYNFhgDRLT3HiAp5LWpbw1sxZd/o9Bi2Nmn
         PCCg==
X-Forwarded-Encrypted: i=1; AJvYcCWrzwCOWYxpkjP1ieXXgr7feT5pbb3/7yCunro495WD98VTTkBQau7UOcTOrE0FLewWG3w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yysy9R09K+ky8nlIyraIc+Cmm0VmFT/owSHvZj45tlnhQdWio5i
	L5rTjYd0jxxouqyjYmjVyKB6A2LGLkQJL/K9suPHeP3R5B3OY16TT3mos3tkIHzVhm6GTO4+Tje
	oVSDa8+6Q/4pkMljZO/rQcKE9lGxRrRauL0AJjtc+x/JcJeCZyF4KyyeUkTho
X-Gm-Gg: ASbGncte4VZxgwrZMSvwIuIJn5b35Nl5hHP1xtaSDf1zK9uFNwq12U4b+cg5+C5ZJR0
	CNkEfrrEbtzk5M7voxM5bVQ60Ye61iFvZDl457eV0DANa5V2VXkJ1fn9IXcZ48bfreWGG3Esjg/
	gUnRrhzdHs1hKi7Mbt3gpCsWqaUEkSsoldHWiw5aDAJdK4fd1VUCvWVJmVYQycBx1GOBgilCn+1
	DlwrgnvOUnAErAUg5qIbYq0I1M7gLsEKfZJ769V8PR4YXyKboQ82HlCGDa06/MM6/9PDRXoC4gA
	6MjcWU4CPgNy/IHTIKi4vbLECfXraQlx7fpPekP3nMaLAIOMY/R3TCdCqjB0kFfoshRnxBoyxp9
	T2KfRAWPxv9TjGx4qq/ij1A0Pe+pJHWi26QkKIkpDy8E=
X-Received: by 2002:a05:6000:1a8b:b0:391:6fd:bb65 with SMTP id ffacd0b85a97d-399739b4dbamr360372f8f.9.1742336812767;
        Tue, 18 Mar 2025 15:26:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE2566PaXJziHXhYt8vU2N7wSpU6jLkXagpjvkPNdNzkOu5eNB/pkYy6bSTupr7UZPs+56uXQ==
X-Received: by 2002:a05:6000:1a8b:b0:391:6fd:bb65 with SMTP id ffacd0b85a97d-399739b4dbamr360359f8f.9.1742336812416;
        Tue, 18 Mar 2025 15:26:52 -0700 (PDT)
Received: from ?IPV6:2003:cb:c72d:2500:94b5:4b7d:ad4a:fd0b? (p200300cbc72d250094b54b7dad4afd0b.dip0.t-ipconnect.de. [2003:cb:c72d:2500:94b5:4b7d:ad4a:fd0b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c8e43244sm19721471f8f.60.2025.03.18.15.26.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 15:26:52 -0700 (PDT)
Message-ID: <0a2e2784-7b5e-47b9-b7f3-59b0e471640d@redhat.com>
Date: Tue, 18 Mar 2025 23:26:51 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/5] KVM: s390: Add vsie_sigpif detection
To: Christoph Schlameuss <schlameuss@linux.ibm.com>, kvm@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Nico Boehr <nrb@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-s390@vger.kernel.org
References: <20250318-vsieie-v1-0-6461fcef3412@linux.ibm.com>
 <20250318-vsieie-v1-1-6461fcef3412@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250318-vsieie-v1-1-6461fcef3412@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18.03.25 19:59, Christoph Schlameuss wrote:
> Add sensing of the VSIE Interpretation Extension Facility as vsie_sigpif
> from SCLP. This facility is introduced with IBM Z gen17.
> 
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Hendrik Brueckner <brueckner@linux.ibm.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb



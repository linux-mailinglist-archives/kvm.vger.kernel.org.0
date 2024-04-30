Return-Path: <kvm+bounces-16260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2670B8B8013
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 20:49:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 439781C21EC3
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 18:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5E90194C77;
	Tue, 30 Apr 2024 18:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PJsbfjX+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B59190672
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 18:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714502979; cv=none; b=XxrzWU0p7oO8v3F0VNG55kOdWwol3m3gYJoQli8tZIf55esM2JBE025cg1R0ikk9bx9wKLfg9ih2SvfnDgs+vMrNSW6+5uAJImji3NRQBHW+A0sP/irPhuMktba/6eIgiH0qru1N6k4AYidejQt7l233kuUTd0wB4z/IaZoUvPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714502979; c=relaxed/simple;
	bh=EokB8aqsQ9XlXisWKz+gIXK6A5fWVoC7f0dsqWjTBac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MoBlsmDc/UDhBJ4x/IyqsWEni/HwJ7gz4xx69shkXK52t9+UgIMHpMorVHZIDU4mN1ZTRw3us6gMjkvBOYrb/PKg4gtY0SaODYwy0rlC6Q1wJ9lLDnMb4qkSGG/N1lcpSHonwNaH5QFe6CPiqyyWOPAWmpzk7QZbLnjXdCidHDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PJsbfjX+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714502976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Qfz69FNF3QRvVYgj0UwtUm//NyFH48AvJNB/+Nb6D8Y=;
	b=PJsbfjX+/K5iT3KwWdVKbrHYsEXr4a3/yeMkcwnT30Sg/eRzNJklofllXbmbdHMyG6y5kD
	K3nG5KeKTJCowbphfsPFAUFNE7RwwIbUHYQm+htHCZiFR91Gb5I6k5HWEvOp7iBR5i/aqK
	yled0ap4ze+/pfeQ4fv0QclSn2AhAmI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-lhRa5GrVNm6UlO5U7KDNKg-1; Tue, 30 Apr 2024 14:49:34 -0400
X-MC-Unique: lhRa5GrVNm6UlO5U7KDNKg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-41bfb8c1ecaso14120725e9.0
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 11:49:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714502973; x=1715107773;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qfz69FNF3QRvVYgj0UwtUm//NyFH48AvJNB/+Nb6D8Y=;
        b=jof60QdhIuEvC5seJ704CYhLUxHdNSxGcY3bk29I+MK1gP6ppo7Ln/Ij4CMV2a00Vf
         qnSpJqGsW8eaxMeLQ8VktAVFSG50V1xogMwd4kIMBC9MQg8BEWgeoAvngxMidT+YbjzG
         aXjXc94u5AzWGGd4M7qzK7wvgqt5mR5sWL8l6b59odaLxzM+yy9q1vhuIsMJHtTSe9wP
         It4QD+K3wwxiVxr9IvSvjSW67xix/nJ8PH3TTBXmOwgngI7YGDTyLH6eN/aVCwVlsl1C
         ahCE21paqE0y7U6fCoTLoANkFtuqN9wHL9Ze36T5SPY8Xou81ys0CMfo06MRr9pVJzNg
         2oEA==
X-Gm-Message-State: AOJu0YwmD2+U2IBvEXqk/PLH9S0dSDwzc62wE6kH38ZhrrUglEqoqECc
	wsohfaotFycCHPcJGvkBj5SGxoA/2H8BDC0MQGQLtd/FOjOcGMhO/48SeVvmuHqqZx9s/NQFCzM
	Jn333pwA0zQEHOD4bf6BVq5cbtxNMKVM2kBkbManGD7VKqk+CBw==
X-Received: by 2002:a05:600c:a46:b0:418:fd27:692 with SMTP id c6-20020a05600c0a4600b00418fd270692mr279732wmq.14.1714502973733;
        Tue, 30 Apr 2024 11:49:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFtv+iFHHId6nLFHEu3MtX/5V5u/gZtD6mgrFVt8qSZNtHT0ztHDzVrQD1olm74qMQBnGjjCA==
X-Received: by 2002:a05:600c:a46:b0:418:fd27:692 with SMTP id c6-20020a05600c0a4600b00418fd270692mr279715wmq.14.1714502973308;
        Tue, 30 Apr 2024 11:49:33 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:3d00:d57f:b4c9:850e:d0b8? (p200300cbc7073d00d57fb4c9850ed0b8.dip0.t-ipconnect.de. [2003:cb:c707:3d00:d57f:b4c9:850e:d0b8])
        by smtp.gmail.com with ESMTPSA id k6-20020a5d6286000000b0034c124b80f7sm14230030wru.61.2024.04.30.11.49.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Apr 2024 11:49:32 -0700 (PDT)
Message-ID: <f53a87ed-c3fe-4a60-8723-3eea25189553@redhat.com>
Date: Tue, 30 Apr 2024 20:49:31 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/10] s390: PG_arch_1+folio cleanups for uv+hugetlb
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Matthew Wilcox <willy@infradead.org>, Thomas Huth <thuth@redhat.com>
References: <20240412142120.220087-1-david@redhat.com>
Content-Language: en-US
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240412142120.220087-1-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12.04.24 16:21, David Hildenbrand wrote:
> This is v2 of [1] with changed subject:
>   "[PATCH v1 0/5] s390: page_mapcount(), page_has_private() and PG_arch_1"
> 
> Rebased on s390x/features which contains the page_mapcount() and
> page_has_private() cleanups, and some PG_arch_1 cleanups from Willy. To
> compensate, I added some more cleanups ;)
> 
> One "easy" fix upfront. Another issue I spotted is documented in [1].
> 
> Once this hits upstream, we can remove HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
> from core-mm and s390x, so only the folio variant will remain.

Ping.

-- 
Cheers,

David / dhildenb



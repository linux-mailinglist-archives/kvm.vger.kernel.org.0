Return-Path: <kvm+bounces-53981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FE7DB1B315
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 14:09:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDFF43BD267
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 12:09:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07A9526E16A;
	Tue,  5 Aug 2025 12:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fr8zsUlN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F164125394C
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 12:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754395761; cv=none; b=NU9gZ3Q8fKnLXyNnweleDWZkzdp1H5mkapO1z/CJb6wUxH7h78gQY+dYSLDCagqsbpi6eLTfCk/UUxvCpCc5L30RhjxdwjFrBbYXbt3Lw43ZsmVBcQe+3YUPNJXh4oFv6+VQE7mUtCM9nV199LsO0rSvFo76NNsZjgR9HPYdhmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754395761; c=relaxed/simple;
	bh=4YEkrQgKpa9tyVagW9cBfffSfEXxSwg1X6OxfJYO19g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O8RjZDISLh34qGA5BiSCktgBHG+FABtjCjkBBEVx3oE1/U/SpBm3pzFkEsGiPUwnSNr0oqoIHBGa7SwDB+6q4CTHEHzHCl7tzpbwaDgULJ2lOXNW3XIWY+Pln9L5/YzwAZwQ6YhSyOwzMA0TnCovTRaO1yTln+d6VutsO+zT+xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fr8zsUlN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754395758;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yHxtl1DwwIyTZIgGScRCJCvFqJGnoli7ahv7PabNDIs=;
	b=Fr8zsUlNBBC38RM1+RR229ZhYVjwnmERn1n6jqcok2g5oiAknmSFOvh5L8xjemleHk0iHL
	bKze3XAftlfmSnTOs9RHlt6hDwA8PBBmxTCspI5ryHhSjupLCO1Ze0LAdIPjIn/XjAAm+C
	OJlcHEkMlNq6NZ/mAcvN5HDxMcATNT4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-502-Lywm1TI6Pt6lTr4SuhfqdQ-1; Tue, 05 Aug 2025 08:09:14 -0400
X-MC-Unique: Lywm1TI6Pt6lTr4SuhfqdQ-1
X-Mimecast-MFC-AGG-ID: Lywm1TI6Pt6lTr4SuhfqdQ_1754395754
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-459de8f00cfso6534245e9.2
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 05:09:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754395753; x=1755000553;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yHxtl1DwwIyTZIgGScRCJCvFqJGnoli7ahv7PabNDIs=;
        b=P/qNzlhU3PHr/qJpiDfHUmIjg7JrTdMsdp3dNePeR1Ha1fumBC1o5HJp6m2F0JBJ/0
         yuq9t9h70yuV+ED1BgmecpiVXLINIerY6OSrNjb3crwKDOoCkhq6b0QCnbVE0dbIGMT0
         fhr0+Zwb3ZMiH1saSEBgWT0nLXt8+Vqi5pAfzZQnuellO1DqMt0qKbajYjmXkTdfL9ew
         xpUiZzvsPbtiyMIVPw8yDN6n4LWCEtT46Y6Xw/9zXdn7ObFuS5FXKo+rcFms5LD/JVAG
         OU/U618g1n7AXAHjtIukeDYL+NNM01z9xOGxJ8c/0EZ6OCViL5TpGNu21Mtn1Pok/Sa3
         Z7Cg==
X-Forwarded-Encrypted: i=1; AJvYcCUWoCRYvI9z/45l3UToy1a9Rioz/ZwYX0wfK9Imsuxz38mXEVACvjT1sZf3Ulp9ztrcpAY=@vger.kernel.org
X-Gm-Message-State: AOJu0YytrLHh7ak98SlzV/M4FSAE6faaDSJD/vN8ByvOBIYozFotw3qJ
	BJblEsYWmuucSt5w4KF5vQqVK1OQPYnfRGbRHm9/bm6R6ZUg69+uDoo2K90wGlMRp3dRkN5kVaV
	NwtiCani/q6aPSlO0yfHBvjVI7stRyyN60rVp03goZvE1XtKZAZt2dw==
X-Gm-Gg: ASbGncsDAWkoCgpQEXSMVjkmB3iXBqfNN4V/uS2RdS9RsHUCwdsUe/kzZyEIVIL6WX+
	8goJecwHCCgIif+0xxMsmgM75SQy/Gn/N0ZbileD6ZC2+64x659kNeE3xwwIUbTwW7kyRwLH+RI
	AJx802KfVu90nYclg+9K282ItX2nLZMXjP/mjLApOAyLo31+Gc9digTAnUY7GRwUZf3TzB4/UN4
	5l8nlNMfgtIoxrlWUD8xCpdlvb8rmp+Tne+yMe6Aq0AruvpEYgEpiA/NGCEaBkTYO+5rt1MIYv9
	j2wSXAToDjcMnxBrCo97X5SVp0JXb1uyQdCoaiP00I3H7/HRHcqEaBcT/m5FGeG9v3MCK5w99Vz
	b0bEfUv+z2oLSfQV7Gi11reDeswDjSPV9/U6HltY7SDVnXhTA+le7hEb+vKHg2NJvcqQ=
X-Received: by 2002:a05:600c:1394:b0:456:43c:dcdc with SMTP id 5b1f17b1804b1-458b6b551b3mr92294985e9.33.1754395753497;
        Tue, 05 Aug 2025 05:09:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFY4u/tbqYyR0GlQ3KYjriQcoM4+gDZW9pPzBsR4N1Fxy3JYB8s/h/fvR/GiL/Mh7ntOC+ng==
X-Received: by 2002:a05:600c:1394:b0:456:43c:dcdc with SMTP id 5b1f17b1804b1-458b6b551b3mr92294665e9.33.1754395753053;
        Tue, 05 Aug 2025 05:09:13 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2b:b200:607d:d3d2:3271:1be0? (p200300d82f2bb200607dd3d232711be0.dip0.t-ipconnect.de. [2003:d8:2f2b:b200:607d:d3d2:3271:1be0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b9eddsm18971490f8f.22.2025.08.05.05.09.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 05:09:12 -0700 (PDT)
Message-ID: <0bd8a969-e8e0-4eb6-97a2-300fc322f8a2@redhat.com>
Date: Tue, 5 Aug 2025 14:09:11 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] KVM: s390: Fix incorrect usage of
 mmu_notifier_register()
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org, frankja@linux.ibm.com,
 seiden@linux.ibm.com, nsg@linux.ibm.com, nrb@linux.ibm.com,
 schlameuss@linux.ibm.com, hca@linux.ibm.com, mhartmay@linux.ibm.com,
 borntraeger@de.ibm.com
References: <20250805111446.40937-1-imbrenda@linux.ibm.com>
 <20250805111446.40937-2-imbrenda@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250805111446.40937-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.08.25 13:14, Claudio Imbrenda wrote:
> If mmu_notifier_register() fails, for example because a signal was
> pending, the mmu_notifier will not be registered. But when the VM gets
> destroyed, it will get unregistered anyway and that will cause one
> extra mmdrop(), which will eventually cause the mm of the process to
> be freed too early, and cause a use-after free.
> 
> This bug happens rarely, and only when secure guests are involved.
> 
> The solution is to check the return value of mmu_notifier_register()
> and return it to the caller (ultimately it will be propagated all the
> way to userspace). In case of -EINTR, userspace will try again.
> 
> Fixes: ca2fd0609b5d ("KVM: s390: pv: add mmu_notifier")
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb



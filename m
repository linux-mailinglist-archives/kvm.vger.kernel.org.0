Return-Path: <kvm+bounces-34147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C8DA39F7BD2
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 13:52:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8463F7A0665
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 12:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6B91224AE3;
	Thu, 19 Dec 2024 12:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PWcgpOzO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4142C2746D
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 12:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734612706; cv=none; b=t4yYC6ca9GkLlTJZJbPi4hZxDRff6lqPP16Kz43lkx9yULsCv0SfLG0XSk+VNGu1NZHhCYMHaH35JJLxLqgv1LyfJuINqPF+knzJ4V5gh4UpFM3df6+HZ1vJmo6vlxLZQmey6gjdS/7HyKO5OaofN3dfoehbp6681KQFkSkpJDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734612706; c=relaxed/simple;
	bh=2FnKTgHs+nYr7nZ8AFFh32DXV0gUdeBWrY6eHEwRvaQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BmlGyfXRIDp27Jwl2ChFbE6hiFc5j87z2jKy6cWiKm/XeF6vGGEttykm5JnPqM+3yoniX6pKDQVG7uPWPSsQICKIF10NS46CXKnTxVVLDp9fgD0al5hMBsnK0F8sIk1MKFKkUO6PHsgLcAj1SrVBuElxlqYkswtyLi9TVGvAG/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PWcgpOzO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734612704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7c8saus9YLZhVfJ1KTMCJAG76jnz4bfOn7VY82l2UQo=;
	b=PWcgpOzODnA0Mls8EY5SkxTq+iKUxmTaG9q2Bfj6zKyQkwTXm1kLw4wBiVswoBPt+TyjCm
	nE5JE8syPkkL/FKj4ddwxGFEhiIolZBf2jJnm9Elj4xFeD9iNM8y3aQMFWIh1+HuiEWm/g
	5BoQc3xfGRGt8jvV956Swuuse8vaf3A=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-JMvrVlRhO6mFiAxhJZExwA-1; Thu, 19 Dec 2024 07:51:42 -0500
X-MC-Unique: JMvrVlRhO6mFiAxhJZExwA-1
X-Mimecast-MFC-AGG-ID: JMvrVlRhO6mFiAxhJZExwA
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43619b135bcso4526355e9.1
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 04:51:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734612702; x=1735217502;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7c8saus9YLZhVfJ1KTMCJAG76jnz4bfOn7VY82l2UQo=;
        b=oVRWot+76nfWZQg01QKWv51AShHyGKsvjghuucrbnnoBostAY7YNXfk5d9cM69OZ9E
         p7GYeTXP5ZpyyEvkRaI6CntNP3tj0HOr7A4Szqb4HC98PQdH9qsaAjShfjeWVIoDk3hg
         /TjrGnMD4V29+WlcrQC4TUDqdM89FVF3GCjcDqyCIOm5ER4LapSz+DUrwWMlxvplEW9N
         f2KeC5+pACeHYDFbMeI7mZ3GzzgCjMFKrZFvOTKouer1kld7K+f0jXIw19Lw0QvpkSrP
         D2VGN87i4PKkLEQzwOfwzJaTP9AJ6vITBXP8zE96iHjFJd4B/BHdzZlR82aPcgcKwv8U
         nw3w==
X-Forwarded-Encrypted: i=1; AJvYcCVIhGXMKQOfzAZjSIlvI8NV3gtdzP+qfmOT9MvnSzPDBj5wc4ZwbFEi87nZu62a3CT2tB8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxcc9xUfSDPzuuypq1dU+efGn9nrwylnr6mEgFDbJ8zDUMCEpmf
	+9vvA2iydoO3StwEYm+WP7St4amUUfvzullEEUlU0U8JFY5OALH0I6SnApRP0uyJV09aCWkcAMS
	qQ0oDaLnf3iBa205LfEAB9ukEEKzDzBzj+G8+rZyOvsLj6DotTA==
X-Gm-Gg: ASbGnctvSg/DZsEPgz246ztaC2t1XziLcWCw6n+EkOz0pLVD/diiKLKbzcqrlwsnMKx
	queS3gUCZW4rekGxW7ukUl/rMG3s5d2XfKQNPhfmR1NGos63Gav7tTeIDYy0ygxktHUdn3OCvMA
	ervL/02shH5vPrgi1R3AevHjobbX4pbFRvMzZh+IaXW18qHE5F1CcuMgCBhAcyMUHe5U/vrQwqN
	cS7w75wQ2XO29P5WWTGbnJKerG5kPYYHD/d5NTyWzbt4sOFjx6S3Zl1RJf9
X-Received: by 2002:a05:600c:1c95:b0:434:f917:2b11 with SMTP id 5b1f17b1804b1-4365c7d05a7mr26149665e9.21.1734612701681;
        Thu, 19 Dec 2024 04:51:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGi6kT1YUYVhMLCGFvM9zRpWd8/VGVfy+jl/VcBcc+w951wALdRk+vWkS9XaX3I8AkE4IXmYA==
X-Received: by 2002:a05:600c:1c95:b0:434:f917:2b11 with SMTP id 5b1f17b1804b1-4365c7d05a7mr26149385e9.21.1734612701311;
        Thu, 19 Dec 2024 04:51:41 -0800 (PST)
Received: from [192.168.10.27] ([151.81.118.45])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-436611ea40csm17411745e9.1.2024.12.19.04.51.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2024 04:51:40 -0800 (PST)
Message-ID: <6887b48c-b1ef-418b-90e7-fa95fedc71f2@redhat.com>
Date: Thu, 19 Dec 2024 13:51:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/16] KVM: selftests: "tree" wide overhauls
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 Andrew Jones <ajones@ventanamicro.com>,
 James Houghton <jthoughton@google.com>,
 Muhammad Usama Anjum <usama.anjum@collabora.com>
References: <20241128005547.4077116-1-seanjc@google.com>
 <173455833964.3185228.5614329030867008316.b4-ty@google.com>
 <Z2NIwmRDaZBc_V4o@google.com> <Z2N-UlxgYlGT_1Or@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Z2N-UlxgYlGT_1Or@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/19/24 03:00, Sean Christopherson wrote:
> On Wed, Dec 18, 2024, Sean Christopherson wrote:
>> On Wed, Dec 18, 2024, Sean Christopherson wrote:
>>> On Wed, 27 Nov 2024 16:55:31 -0800, Sean Christopherson wrote:
>>>> Two separate series (mmu_stress_test[1] and $ARCH[2]), posted as one to
>>>> avoid unpleasant conflicts, and because I hope to land both in kvm/next
>>>> shortly after 6.12-rc1 since they impact all of KVM selftests.
>>>>
>>>> mmu_stress_test
>>>> ---------------
>>>> Convert the max_guest_memory_test into a more generic mmu_stress_test.
>>>> The basic gist of the "conversion" is to have the test do mprotect() on
>>>> guest memory while vCPUs are accessing said memory, e.g. to verify KVM
>>>> and mmu_notifiers are working as intended.
>>>>
>>>> [...]
>>>
>>> As I am running out of time before I disappear for two weeks, applied to:
>>>
>>>     https://github.com/kvm-x86/linux.git selftests_arch
>>>
>>> Other KVM maintainers, that branch is officially immutable.  I also pushed a tag,
>>> kvm-selftests-arch-6.14, just in case I pull a stupid and manage to clobber the
>>> branch.  My apologies if this causes pain.  AFAICT, there aren't any queued or
>>> in-flight patches that git's rename magic can't automatically handle, so hopefully
>>> this ends up being pain-free.
>>>
>>> Paolo, here's a pull request if you want to pull this into kvm/next long before
>>> the 6.14 merge window.  Diff stats at the very bottom (hilariously long).
Pulled, thanks.

Paolo



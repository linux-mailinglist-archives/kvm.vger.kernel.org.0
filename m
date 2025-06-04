Return-Path: <kvm+bounces-48430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 99EA1ACE293
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 18:57:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DF0D1791CF
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 16:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2374D1F3D58;
	Wed,  4 Jun 2025 16:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CzmO4Qzj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD031F03DE
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 16:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749056171; cv=none; b=Cx0kAgJee/KZqUBPtQDlP0SJTX194qVi4Sfx3XWjFhPonijYfiu68rNfxU8EOvygcmb+Nma02d9wxKseN/EHVr4570g1ERwRMLf1eYKoJy9DQpIIHw0gJKFZ2LkpRqhFXSdFT+Q4TIve5F4NUEFAS6yEoYuN70CYwq3CuzwyKss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749056171; c=relaxed/simple;
	bh=guOI/IMUZQ9iLqAt5X6Xtn9qc6QdSHzu5FrWDlK72OE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q7kPjiJ/b0mpPqIe159ewy4E5hQfkXlYb9zFDbPHCf4cv330KBMAE0WbKSCRpS80DbbDEZLnVj+YVPl9IIaa3onBZta83OPVjThf1Eq9/LcfyMpD+R6KSO3GB1Jc+/lJz5Y39htPy/CbFftBeja6JELC1h3Q5F2DnD6gFEBGdJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CzmO4Qzj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749056168;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=I9PhEN/LIEN/gLsXY9mpqwVLXpzLhsWCN/lzXheaQis=;
	b=CzmO4Qzj3W8v7EgML5wEjBgqbbzPdPa2RHsxFwOCmdG6DY69akXgYneI6cnrnqbQoUb8bm
	LrWWp5xOB7aCGjLwyTIjlcw9U4sd8xox+tQEozws4eAus0XYxBOqLXPLc5dmatRkLB3Ank
	k1eATYhsnxXjs8etH5qToHnRWg+yAZw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-u86vRb7wNIiY6djAJw6nMQ-1; Wed, 04 Jun 2025 12:56:06 -0400
X-MC-Unique: u86vRb7wNIiY6djAJw6nMQ-1
X-Mimecast-MFC-AGG-ID: u86vRb7wNIiY6djAJw6nMQ_1749056165
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a4eeed54c2so20997f8f.3
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 09:56:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749056164; x=1749660964;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I9PhEN/LIEN/gLsXY9mpqwVLXpzLhsWCN/lzXheaQis=;
        b=DpkrvfirE9S0FeZyfyUmJM/ANEfJDxiDfUntIF56jvlnWiCtJ2gbP1klfaz7cP+UCD
         JfNlCDr1wdxN+7vv/l0/PVKDYX6LG8dqHn9sMGmU/oYVynu9lUNsuwhvKRQWXI6y/Gyn
         NRCdyy2C6VC5bthGdygb7rbpzywccAg1IbZUr6Shngd1X1u7po9yleUuzFqfOFeP3vFe
         JyN8vNz4/Uy8SaeVKL+uTOorO87EQPRc5/dH5I2UiAFZfrldUMAGJCZ7YQWbtuZkvSfd
         EmCH4hYxUbAuPn0B1JTc+/AdTZm7rxPf9CDZF2YdcoHy7jtakEw2/GXztzSnqde4Lbnh
         +4nQ==
X-Gm-Message-State: AOJu0YzS6o8kzXm9Q3XghfDfWi3rxfyWcANXiLmAUF33xxDymedNmLNt
	5pUM5uCdjwf/t7v4VwEffwT3mD8Ntl+PJEBmDh8WqRQnCEn1Y7u9QXmFQE9l0ycVbSPirfFmWae
	byPkqvHLVFf4PkYF21dF7OOUY9AAWL5kI0pvL3bus7/lB97YhjT9TB+q8dSY3Dw==
X-Gm-Gg: ASbGncuKBjWq3hHPUqJaUvuAHkwmMvFBhjMzzrghva9Epp00SslreuKRGRG7jAqgFRH
	b4EKSRgkz5CMXKQ4i/sBapPKqa5m836zcRAVXV07czJGb/ONO0r4fK+iajLIt7U6ZyjzEvkTarA
	ywHG1X46bJXcRzNtWkzksh3W8OULTzh0yIscOXorfQM1qE2KNx1lwIAd0gnfdvWJXIZ0wjuMbwR
	TRdd8m5Neq8peTGfl3NaKlTRfD4wGOcwR0qQYx/YlofNDtaOPjzE7pJfVY3Psse8G4T5ESLHtq3
	Hehu97U3WBwqDA==
X-Received: by 2002:a5d:64c7:0:b0:3a4:dc0a:5c03 with SMTP id ffacd0b85a97d-3a51d96a1ffmr3221281f8f.39.1749056164092;
        Wed, 04 Jun 2025 09:56:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGS1/rFeCnYX1T3YAOENXA746Vcb7+JQHLYtoc/dOzG7V2U1TM7oVk/frUr9KrMyDQeVAs/Lw==
X-Received: by 2002:a5d:64c7:0:b0:3a4:dc0a:5c03 with SMTP id ffacd0b85a97d-3a51d96a1ffmr3221265f8f.39.1749056163705;
        Wed, 04 Jun 2025 09:56:03 -0700 (PDT)
Received: from [192.168.10.81] ([151.49.64.79])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-451f82879d8sm1959195e9.1.2025.06.04.09.56.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jun 2025 09:56:02 -0700 (PDT)
Message-ID: <69a46b99-83af-4913-b5ec-e993d2edde35@redhat.com>
Date: Wed, 4 Jun 2025 18:56:02 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/15] KVM: x86: Add I/O APIC kconfig, delete irq_comm.c
To: Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250519232808.2745331-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20250519232808.2745331-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/20/25 01:27, Sean Christopherson wrote:
> This series is prep work for the big device posted IRQs overhaul[1], in which
> Paolo suggested getting rid of arch/x86/kvm/irq_comm.c[2].  As I started
> chipping away bits of irq_comm.c to make the final code movement to irq.c as
> small as possible, I realized that (a) a rather large amount of irq_comm.c was
> actually I/O APIC code and (b) this would be a perfect opportunity to further
> isolate the I/O APIC code.
> 
> So, a bit of hacking later and voila, CONFIG_KVM_IOAPIC.  Similar to KVM's SMM
> and Xen Kconfigs, this is something we would enable in production straightaway,
> if we could magically fast-forwarded our kernel, as fully disabling I/O APIC
> emulation puts a decent chunk of guest-visible surface entirely out of reach.
> 
> Side topic, Paolo's recollection that irq_comm.c was to hold common APIs between
> x86 and Itanium was spot on.  Though when I read Paolo's mail, I parsed "ia64"
> as x86-64.  I got quite a good laugh when I eventually realized that he really
> did mean ia64 :-)

I totally did!

Looks good, other than the small comments here and there that you 
received and my "preference" for keeping kvm_setup_default_irq_routing() 
a separate function.

Thanks,

Paolo



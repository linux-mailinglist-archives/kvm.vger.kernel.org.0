Return-Path: <kvm+bounces-53637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C6A8B14D4A
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 13:59:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B560C171DBC
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 11:59:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BC3128F930;
	Tue, 29 Jul 2025 11:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fvEEyjkB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6272B28F515
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 11:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753790344; cv=none; b=ZGKEZNR8+v9g2uzhOu7QSFvvHDjspgwweECzH6brWyI7/U1a/2npFxU1hW9mtWZq2gIVlD8ws3LP5cO5di/09SXIL/sDdTl0xf9jnmnuJRVYeiItnWJPOBwTygiPHhypE0afBIytLMCBtwn63Z1BflFkigZDSY0Z2iQ3AFLz8BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753790344; c=relaxed/simple;
	bh=myikF9ny5f3VGj5naXa8FNi8N5QSO1uhm5Kqy4VhKns=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gWXeJgUilns0k5/VCRAcMRAmNibhPgq7ClEIq5D8PvG8O+BOgTnXcXvdPpCC04bShR7yLGfSg5Vwrcy14TCz6LxJkvnwY/aDRujN+jcDK3PWFXUpEbRkKT02GcCeQV0bXl8DYj5W8mIXL7MWOOkMuQXHZatOVUHpwHWAjNl/B0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fvEEyjkB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753790341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Mt286fE3fr9exZwFOAwUHjGEk4EhTOfKtbO13ISjIXE=;
	b=fvEEyjkBND5+SSdW4ro5fnbxhT37CAgSidlTzJ8p6ScoArUsWb46HnVnSuT4Bxzu2n7ciD
	43wn8LF3zhQeN2FGLMjINq9KUifzb6LWEpDWvRP1tSxtH1aZMPAceKiPd1I/fSHqtgWmye
	BAxi15QTIktKneWR9/jCdbzlnL47pqM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-428-yoPCzgLjNbiTpTBrPSzn_A-1; Tue, 29 Jul 2025 07:58:59 -0400
X-MC-Unique: yoPCzgLjNbiTpTBrPSzn_A-1
X-Mimecast-MFC-AGG-ID: yoPCzgLjNbiTpTBrPSzn_A_1753790338
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b7886bfc16so1299498f8f.1
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 04:58:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753790338; x=1754395138;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mt286fE3fr9exZwFOAwUHjGEk4EhTOfKtbO13ISjIXE=;
        b=PCfOnI33ZlK19FR+QYtgaaJ/sZHPpXXlyG812b/8zrP0KsPUIl5WI8MfGfgKkxU0hD
         K0nov1DUjnqSurOXEtNAHSH8mjMOsCLab1HZn7KYf4Xny3OTMSlBeLXDIdFsssNjDcpt
         M0mGixpJ3NaL+KEn0cei5VjPU7lzI+BnlbJRCO7pFxPWq0mF94o38GvR+gmoPme1bXv+
         wIoaSJeNRhTFYL1AHZpECva83cUPrby74UU+zvb/DjUEbIv8QHQlG7ytacQjaWRh3tXN
         E0JNF65pCL92NJWLgNUKhyVQhFbXuS2Bl4i6hQohYoUhPTwv/Vn7WfWOdPsVTS9JSwsY
         WO4Q==
X-Forwarded-Encrypted: i=1; AJvYcCU8nVbablDe35lWwDiCLSqoEfRuEa1U1TZTdKyLHvA5v8Hp2HCQYYiC6hWU7WRtofpeisk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMMjgYz8FRriac4lY2Wr7GcZFWxSMzy3qcYf577IbDluBmF5RG
	SVCn2o05GvhQOwn8705xoNrkYlukuuuqRQ69XvJ+2x833QbhWg/XIjvPnQAyswSYEq9HZlJYpQa
	PL9/nyQBsFzgJ7qZ8L9dKRNHRdYB4hoLE2WKzszoKiExWUf734qpCSA==
X-Gm-Gg: ASbGncsUCV8y9XKh0OqqMtxpsLCjgWZvshmWh0ZDV1d1UHTxQXrqbxh48RBs7xSjoVk
	j753QmsUt8WYjMN/+zWwWtM5Q5+XQD1ifYJxnSTd6JHhgQu7V8Zgnfk9AzjxqR7Vj7bPwQvOoIu
	00cIXHNuJPAJFPp0HnIFf5B9GPACvgKx1eO6Hsxp2t51BJYHaMquTFYdi02CYDdO7/+gvNtWv5d
	Ilwzfw3MYINwpq1MDgnFeFtW44+rbBSHZCZnXZnzHnx4xFYwrm2gL54vuCKzoUysCfrH1PxAPs0
	3ig9taud55B5oq4bUMQdV/V4pzdG1JJuNHa5fUJB8+M4
X-Received: by 2002:a05:600c:1992:b0:455:fc16:9ed8 with SMTP id 5b1f17b1804b1-45876651bfamr150542705e9.30.1753790338311;
        Tue, 29 Jul 2025 04:58:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHi4+v6oNFjQhbcYthmDOzNaUqcEt6rvGHmIzYzlsi7OQ7zXry3yI7rWQcJKU17VzbPC5UuOg==
X-Received: by 2002:a05:600c:1992:b0:455:fc16:9ed8 with SMTP id 5b1f17b1804b1-45876651bfamr150542175e9.30.1753790337511;
        Tue, 29 Jul 2025 04:58:57 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.154.122])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-3b7908161e3sm2262031f8f.37.2025.07.29.04.58.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jul 2025 04:58:56 -0700 (PDT)
Message-ID: <a486e649-d2c0-471c-87f2-c7a01dff9ae4@redhat.com>
Date: Tue, 29 Jul 2025 13:58:54 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] KVM/riscv changes for 6.17
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@ventanamicro.com>,
 Anup Patel <apatel@ventanamicro.com>
Cc: Anup Patel <anup@brainfault.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>,
 Atish Patra <atish.patra@linux.dev>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)"
 <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>,
 linux-riscv <linux-riscv@lists.infradead.org>,
 linux-riscv <linux-riscv-bounces@lists.infradead.org>
References: <CAAhSdy12xtRRem-AybfymGHh+sj4qSDDG0XL6M6as=cD5Y2tkA@mail.gmail.com>
 <CABgObfYEgf9mTLWByDJeqDT+2PukVn3x2S0gu4TZQP6u5dCtoQ@mail.gmail.com>
 <CAAhSdy3Jr1-8TVcEhiCUrc-DHQSTPE1RjF--marQPtcV6FPjJA@mail.gmail.com>
 <CABgObfaDkfUa+=Dthqx_ZFy418KLFkqy2+tKLaGEZmbZ6SbhBA@mail.gmail.com>
 <CAK9=C2VamSz4ySKc6JKjrLv9ugcTOONAL4+NmKAexoUgw7kP6w@mail.gmail.com>
 <CABgObfZu2fPFaSy2EHzpD_MUwYYeYMfz6BfXmTw_h3ob1q2=yg@mail.gmail.com>
 <DBOIBORLK6YM.7SND5YPEJR60@ventanamicro.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <DBOIBORLK6YM.7SND5YPEJR60@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/29/25 13:37, Radim Krčmář wrote:
> Sorry, I didn't try too hard to convince others after noticing it, and
> planned to fix the most significant breakage in later rcs.

You shouldn't have to convince anyone, 
Documentation/virt/kvm/review-checklist.rst is pretty clear: new state 
must include support for save/restore, new features must default to off, 
and the feature should be testable.

The file was just updated (and now makes further remarks about testing), 
but the same things were basically in the older version.

So you need:

- a KVM_ENABLE_CAP to enable/disable FWFT

- an ioctl to get the list of FWFT features (kind of like 
KVM_GET_MSR_INDEX_LIST on x86?  It seems unlikely that you get more than 
50 or 60)

- an ioctl to enable/disable FWFT individual features

- the GET/SET_ONE_REG to migrate the state etc.

- selftests


> (If FWFT wasn't enabled by default, sane userspace just wouldn't expose
>   FWFT to the guest until a proper KVM configuration was added).

That means that the bare minimum for inclusion in KVM is the first three 
bullets above.  But at this point, leaving out the fourth is just 
sloppy; and tests are not really optional unless you have already posted 
a userspace implementation.

Thanks,

Paolo



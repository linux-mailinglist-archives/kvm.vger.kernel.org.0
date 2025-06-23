Return-Path: <kvm+bounces-50413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 54E1FAE4E22
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 22:28:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F3CC9189B32A
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 20:29:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B1DE2D543B;
	Mon, 23 Jun 2025 20:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="fY8i9KPF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CF21FCFEF
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 20:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750710518; cv=none; b=ObdGV+d1HzkMfbGwiE0vTYokth3KNDTuLZgCmzHNqnyGEGNsIvYOCPZxXgQdvSoVGUI8FAaMqd9198BE8c1pFsr/NKQe2PKaJAbUF4oP/iHF6RqpYKcNIOgjhpDxuTZkWQFz7c+/KwhMWa28O4GZ8hzItn//aIGsxzdmRNBUUVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750710518; c=relaxed/simple;
	bh=yvn5m/fc6jZqcP4SKANHRgL9UqFxUsYwY/MKu8XQkCo=;
	h=Message-ID:Date:MIME-Version:From:Subject:References:To:Cc:
	 In-Reply-To:Content-Type; b=gihdTOL33mnjdtABblstQfdfeLg/dyiVLof6OLV7qr4QRXRXjgL2RBLLdGPjh6X0LJUgqVuPk2nIKbOuP9J/V08Ezg58i+8gMQEQ4V6Y0SZtMmGsNKj+9ZlzedyD0+h3TbirRphD2UfSHdJ/6t4ljEnmbba90FkgCB0HMVyoo6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=fY8i9KPF; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-748fe69a7baso4290332b3a.3
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 13:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750710515; x=1751315315; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:cc:to:reply-to
         :content-language:references:subject:from:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=9lG2fYK+FG/7B4Hz41OrfpLpcja5dQtRjIqgFo6jHfc=;
        b=fY8i9KPFuq9OA8K2K+dIQ0ER2fzkhT+2AqTF1drqMinhVW26Jn/uCp0tbtccXF49Nr
         Qamc9DLx3f7LFtlUsHjbAFD0x2rEJcs/tjc0hqdVneQJfrkGv05cukRqTRuVXE7niaNc
         ExBaFng4RfFHefU+SfvrPkGVp4cRKaxI3uf7q2pkuy229ZOmnrGQtAZrjHJrg7A3sgu4
         30/Koe4nwCbAddgNlqClXh+A9JAXsfssMuQKhLeBOs1yNntOZCblDHZBBKVCEVc1gT0O
         Dj8A1x0lKeL7PLu0PjMZP1DgUiP5ZgG64q5v3M2VP1BSljed36mIJyBE0PLP7F5xqxXr
         0RJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750710515; x=1751315315;
        h=content-transfer-encoding:in-reply-to:autocrypt:cc:to:reply-to
         :content-language:references:subject:from:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9lG2fYK+FG/7B4Hz41OrfpLpcja5dQtRjIqgFo6jHfc=;
        b=GqcUrie1AoBQ2ee/pdM8YbQjf1GxuFFvNL82OtXelKP3gdOVGLJkTRjZNl0dq+lCie
         /PXyedsRTisVUbqe0LaVdsG8E6Q6b/3wG8MTQHB5pnx+3zBPvCFsoFBlCBQ80qu0Z0cW
         slQqQ24415y5EcG8kly5Uxb38CWi+g4NtOdy74PHI61YHGuaiCApQGgvdih8pxp+25ij
         w499+yjiB7r1BhzHaYG0HXqRW49W7vjyZxvfTkvYstfPgsALqMwIbcBCx/6XdAUu1V0M
         Ep1tY9XXcft8ZuFFYA01exBg7GakI9PbJbKY63KjNU0oqUA7k7BTTOOxxC/ewStLKx2+
         7ebQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZPBAmYJtI4zFFgqW5cmmm4nvcNrDKRKFwWs4wKXboB9yPqEFnoXgEkVFDCZ7wbhpkb68=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPdn48VEHDF8cVcHBwn0V29nFIfxXgFQH6mq/GbsGyGqW5DYNN
	9WYnnWjLF8gIlnibQi6aZD3UqXNJ08GJ8XDLty0A51B+oGYDGkwg8m8kYsn+GNQZVIg=
X-Gm-Gg: ASbGncv/pEWGy/bAllWGLPiq+1d5g8vktCwWdHKpx326cyHhrT4kpa4TPcN1Phck3lj
	Q3NmYqVWpRl9xTQisCTAgM6Bvrzuz3kFTTy/MNdDTYD95lpMEyqBdt8ihO/faErGraFrno6mdD0
	o+5OvbPF+y0eh3VHXTCy2urNGhwQcbCbDVaxZwKdPFX4TKETKbjVFEWvFGmmGA/UNlnowG1uJTM
	Fd+rw8fg4AjDwN4BCzAMjkAWFzIIlKTVb5LjIb4zl5zodXN9CfoGDG7meePlpznIzfcQelXTwnV
	M+9FD8ByOW4evFLc3dTJsLyaqkCBiUqQeKNld90+qZNAtToIgxfNgVdvPGMqb/mYjivqJBRs0Uq
	m3+4cWgWbSTsRH2GJ4Vv4BLa7l+idYkFzr8L+nFd2svT6Y60V+JJbPAq8Rlh4YGyl8xOyKJJxu2
	eb7BZNWOpt30XVrCOkqZ4=
X-Google-Smtp-Source: AGHT+IHbWOO4NSbrGwdEC76GQPstv/OQjR/CDJ1ZM3WMxgwIO/uDHwHLpHbyfzVTCuq8c71lwTTooQ==
X-Received: by 2002:a05:6a00:4f8c:b0:748:f406:b09 with SMTP id d2e1a72fcca58-7490d6d2ea7mr19547214b3a.23.1750710514925;
        Mon, 23 Jun 2025 13:28:34 -0700 (PDT)
Received: from ?IPV6:2003:fa:af22:cf00:2208:a86d:dff:5ae9? (p200300faaf22cf002208a86d0dff5ae9.dip0.t-ipconnect.de. [2003:fa:af22:cf00:2208:a86d:dff:5ae9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-749c882cdc4sm5608b3a.84.2025.06.23.13.28.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 13:28:34 -0700 (PDT)
Message-ID: <335d4b2c-1b37-4026-95d1-12c6875ac58e@grsecurity.net>
Date: Mon, 23 Jun 2025 22:28:32 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH 1/8] x86: Avoid top-most page for vmalloc on
 x86-64
References: <d6f116b2-1c42-4fde-831b-b23fa6791e74@grsecurity.net>
Content-Language: en-US, de-DE
Reply-To: Mathias Krause <minipli@grsecurity.net>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <d6f116b2-1c42-4fde-831b-b23fa6791e74@grsecurity.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

[resend with kvm@ on cc]

On 23.06.25 06:50, Chao Gao wrote:
> On Fri, Jun 20, 2025 at 05:39:05PM +0200, Mathias Krause wrote:
>> The x86-64 implementation of setup_mmu() doesn't initialize 'vfree_top'
>> and leaves it at its zero-value. This isn't wrong per se, however, it
>> leads to odd configurations when the first vmalloc/vmap page gets
>> allocated. It'll be the very last page in the virtual address space --
>> which is an interesting corner case -- but its boundary will probably
>> wrap. It does so for CET's shadow stack, at least, which loads the
>> shadow stack pointer with the base address of the mapped page plus its
>> size, i.e. 0xffffffff_fffff000 + 4096, which wraps to 0x0.
>>
>> The CPU seems to handle such configurations just fine. However, it feels
>> odd to set the shadow stack pointer to "NULL".
> 
> Not sure if adjusting this is necessary. As a unit test, exercising this corner
> case might be beneficial. But I don't have a strong opinion. So,

Yeah, I have ambivalent opinions about it too (testing the corner case).
However, the under-/overflowing aspect of it feels like a bug to me.

> Reviewed-by: Chao Gao <chao.gao@intel.com>
> 
>>
>> To avoid the wrapping, ignore the top most page by initializing
>> 'vfree_top' to just one page below.
> 
> Nit: this makes the comment in test_lam_sup() stale, specifically "KUT
> initializes vfree_top to 0 for X86_64". So, that comment needs an update.

Ahh, good catch! I'll fix that one in the next version.

Thanks,
Mathias


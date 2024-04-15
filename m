Return-Path: <kvm+bounces-14666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B81218A53FA
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 16:33:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA56A1C21E5D
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 14:33:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AED2745C9;
	Mon, 15 Apr 2024 14:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a8ZMU24Z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8E67F7E4
	for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 14:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191403; cv=none; b=I1XJf2V+2wu7WneQvsLyBQPsEBLWyaeCezBCh12JyoWP6PEYd3FU23OREOwI/z3vKg53DKWchuv8QBsSm8Xx/4GEPlkxh4Sbhky2cmI3Q1iIeH3poZtmtqwXB6evzaMWIWAN7Ok2BXdsoeYUnI+auWJ4L+0ZUiIug4pksfOfWC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191403; c=relaxed/simple;
	bh=LVIRBnNqo0tKNwJoUCocse+KKqUrMW79d7EzgroVfUY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JnKVQPiXQN8eae/BTjI0JpMphqAsLIwHDEZYgNNn0grFy3pKdFVDNLLk2ZNIuCu1TFqFcAJjJ+l+TD4IljmPKkfhidGkVxfnfBI5AxedAKxYWlbJnyp7kxkYWsMoshyvv14O3eadG2LQjc5D2vpC/pGug6nFHfjC5aYWIRu+PiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a8ZMU24Z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713191401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QtYxLkzgtIthEIjNpO3EbnuoUG9HOkNB0zBIkI46gFk=;
	b=a8ZMU24Zeb5/jeUfTBPHVxyIJMITC4b0/7AHYYd27uiD6sS4VIAR1UDoFcLVjO5yCj/kiT
	vjrjGFZSlkTuCgsk8RzwpEDRbZOIVuc3HF+CsvqKZEy578rBBoCnVFXXjJPJxOLMCXNs0T
	o87J/SJdmpLZLj7KH5IeD4VCMwPZAyU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-PLQNIdseO7y6hB0TuSzVRQ-1; Mon, 15 Apr 2024 10:29:58 -0400
X-MC-Unique: PLQNIdseO7y6hB0TuSzVRQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a51b00fc137so273545166b.0
        for <kvm@vger.kernel.org>; Mon, 15 Apr 2024 07:29:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713191397; x=1713796197;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QtYxLkzgtIthEIjNpO3EbnuoUG9HOkNB0zBIkI46gFk=;
        b=VvOiy9LSx+KovTYE4PSRUNFR5jgXg+VIyzullSPwZuVtqAZg3cb+8fTTkGJ9qw6Tjm
         dqtXo15C/tGx7GRBwVyDwETyTYvZSm0lFAVvLGQT6ooBuC4IzK++jpZKrW8dJ87hERYI
         TN3Rg0Wu1S2BSbQksQokcQIbGnxXOuZSHWPoXafeYbVaGMq88JLStdq1tfe+noIpoFOE
         c1+9+tAh67K4z7rWzcXVRcbCQmWjwBjzEooNScGOlyfkA+2SFQcgps8UH4a4EDNK3tWp
         uNJvyF8H11nsgP9vgGGwny+GSTpuzgwAXNm2MHPwqfr6RYcUgKOHPCEuvgliisEP8bKq
         MsYw==
X-Forwarded-Encrypted: i=1; AJvYcCWg3ktj2SdLt7LFlEKRDYxpqs18lGm9Wb/VcetKJqGHp8L75GskHXVQWItYFO3mlIx05pGkeiZ7Zgio16usK3vM1DJJ
X-Gm-Message-State: AOJu0Yzn8WWafZfGt8xGO5fIernPRkKvyQ8CuXhAEZAnocaezxNEYgRO
	AEarEwiI6yHKo3h0FcixF4ufALNCPn02/UfoQUCI7gbAea+umjCenm/swQ2MmhozSrMhUavUOH8
	53f+8g3PjZEcRNRzJnO7L12MzngvLB9BCQmSmifb4HYjBr4GTbA==
X-Received: by 2002:a17:907:9496:b0:a52:3316:bc29 with SMTP id dm22-20020a170907949600b00a523316bc29mr8899234ejc.3.1713191397382;
        Mon, 15 Apr 2024 07:29:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHRgipbpLi89y0FSxqIG6c7+yExPZWin1g59lxnJmDbNrm9ItVW6pSpnd1WCAkU6FQ1F7Tv4w==
X-Received: by 2002:a17:907:9496:b0:a52:3316:bc29 with SMTP id dm22-20020a170907949600b00a523316bc29mr8899216ejc.3.1713191397058;
        Mon, 15 Apr 2024 07:29:57 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-142.web.vodafone.de. [109.43.179.142])
        by smtp.gmail.com with ESMTPSA id do21-20020a170906c11500b00a46baba1a0asm5513665ejc.100.2024.04.15.07.29.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Apr 2024 07:29:56 -0700 (PDT)
Message-ID: <8790e8e7-d419-4b08-ab05-9c7d0b9d26e6@redhat.com>
Date: Mon, 15 Apr 2024 16:29:55 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v8 05/35] arch-run: Add a "continuous"
 migration option for tests
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240405083539.374995-1-npiggin@gmail.com>
 <20240405083539.374995-6-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240405083539.374995-6-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/04/2024 10.35, Nicholas Piggin wrote:
> The cooperative migration protocol is very good to control precise
> pre and post conditions for a migration event. However in some cases
> its intrusiveness to the test program, can mask problems and make
> analysis more difficult.
> 
> For example to stress test migration vs concurrent complicated
> memory access, including TLB refill, ram dirtying, etc., then the
> tight spin at getchar() and resumption of the workload after
> migration is unhelpful.
> 
> This adds a continuous migration mode that directs the harness to
> perform migrations continually. This is added to the migration
> selftests, which also sees cooperative migration iterations reduced
> to avoid increasing test time too much.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   common/selftest-migration.c | 16 +++++++++--
>   lib/migrate.c               | 18 ++++++++++++
>   lib/migrate.h               |  3 ++
>   scripts/arch-run.bash       | 55 ++++++++++++++++++++++++++++++++-----
>   4 files changed, 82 insertions(+), 10 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>



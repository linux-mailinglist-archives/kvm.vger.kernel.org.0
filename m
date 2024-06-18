Return-Path: <kvm+bounces-19886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96AE590DBCE
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 20:41:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CB30BB222FB
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 18:41:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AB7215F31D;
	Tue, 18 Jun 2024 18:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JGoddSL7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E468715ECF2
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 18:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718735988; cv=none; b=sf5WgV49tk+u5w6bCgNqHS2qFbZzHsqP5zZTudndjjcREIM9zYpVJcireMyYMRN1XECcJTynw+cwBnaJ4J4PV93S3tGAYCE6KYHi+ioj2JuWJoYcwW+RQoBVEKYR6AtiTAvb611IjRB1Ad53oXPiP74cJ1tuvX2pk95NqxF8ab0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718735988; c=relaxed/simple;
	bh=Rji/Cvh5opU1KfkOdI7S9v6Qac5Jws/tjEtj+YIKrsM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dCYIAU84UgVjFfA6HMjadE+IHdRQ+/eKD45D1EdgsjQ2KN5mGn05+Lk0RUP70vaSPB/0Xf+nzoyRBgA11eVo6Pd+D3YCoJTuOByJTvm8fBZcSo6ix5iemkVywlWoAm2xse6mNY6qXbR46SxHfL3kQ2RheJ0qTUCrcsbu/ziJXlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JGoddSL7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718735985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KeFj7FMj8vcEpASaDi0TP3uoKT7x+gqQ94gHCsvPSwY=;
	b=JGoddSL7gsgvwuVWBCOE8LXM5DfxWui/rKsTPEXQ1uUK/hk6HbdaA1SC6l/8ODJEPcDGuE
	tqsaWu2mVaRTCyCtB3beyjD657yK+4fjN7VGh9IPfOCSbnBi4vip+rhheV+MiR6oPOPi+A
	lAupL83CTsmlwIciudwvO3VgvwtWN68=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-490-CosrPDdfPiCP71enmiRCJQ-1; Tue, 18 Jun 2024 14:39:44 -0400
X-MC-Unique: CosrPDdfPiCP71enmiRCJQ-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6b2ae773ad7so71825636d6.3
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 11:39:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718735984; x=1719340784;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KeFj7FMj8vcEpASaDi0TP3uoKT7x+gqQ94gHCsvPSwY=;
        b=agadWQ28OiH9UiKCB/8M5bQRWIi/oZ4sEIDl2WVtzCP44rcuDzl62A5tcLtOD3YX4L
         DKt60qAlKxQ9D/iuXvNcBmRcJ+logIQrIsEs9slhoVv+Z+0Fs2wSMtLbLd+tW0oyDDuZ
         B2gVmC4/BrUxzq/wXLrPfsxdJKTQRaNJPO4p6sV9YJkH1yAezzqV6LySrF7oCaU8P92i
         nD5lwg5eSW1h9D+FerVuMwEbCvFvvZotsCsA5x/BmcNwZ7RPW8VY5ssMq87j5y/VZXSj
         Aq9IgFglwpZn4L9rxbPNmMAwMUY6lJxgRRe7TDgoe4UVHRhLxJowslF4QxtgAFhB0B95
         j2/w==
X-Forwarded-Encrypted: i=1; AJvYcCVAxXFTlSgDeZ6r/qGU1PBJkYhke0r7WNKez0oW5tQvYRBTUEHXlrR5BEizB2EZDkQ1bGCOPZuKL1ct6XSMkpfOQA6P
X-Gm-Message-State: AOJu0YyfksbfWly/MqKATtseArLYa5wjSs6CRvKDDR6ogZ+brj1b9ME/
	61UZj0V8/Vckf7VqVAVMx6GZJ3T5MPO/4EoLEjm/KaIxZfpoOeCNclycD//yFD5FEO/n/JwtTBH
	KhtVQ3C2LYUv0PDyPHPbQ7UMx+KTXOB9KH96oQmBXKxzQKIdOMg==
X-Received: by 2002:a0c:c984:0:b0:6b0:5c89:a86e with SMTP id 6a1803df08f44-6b501e3dddcmr6398376d6.28.1718735984060;
        Tue, 18 Jun 2024 11:39:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFSuIf4mge8tCBI7lR69nSs6E7dT6iTiDCdUQpb6hJlw9jBLlrMNBs3XDNtBhSqrrn0vqGljA==
X-Received: by 2002:a0c:c984:0:b0:6b0:5c89:a86e with SMTP id 6a1803df08f44-6b501e3dddcmr6398216d6.28.1718735983777;
        Tue, 18 Jun 2024 11:39:43 -0700 (PDT)
Received: from [192.168.0.4] (ip-109-43-178-117.web.vodafone.de. [109.43.178.117])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b2a5c466ccsm69413036d6.71.2024.06.18.11.39.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jun 2024 11:39:43 -0700 (PDT)
Message-ID: <5bfe90ca-96aa-405b-a4b9-86ec4a497366@redhat.com>
Date: Tue, 18 Jun 2024 20:39:40 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v10 08/15] powerpc: add pmu tests
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240612052322.218726-1-npiggin@gmail.com>
 <20240612052322.218726-9-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240612052322.218726-9-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/06/2024 07.23, Nicholas Piggin wrote:
> Add some initial PMU testing.
> 
> - PMC5/6 tests
> - PMAE / PMI test
> - BHRB basic tests
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
...
> diff --git a/powerpc/pmu.c b/powerpc/pmu.c
> new file mode 100644
> index 000000000..bdc45e167
> --- /dev/null
> +++ b/powerpc/pmu.c
> @@ -0,0 +1,562 @@
...
> +static void test_pmc5_with_ldat(void)
> +{
> +	unsigned long pmc5_1, pmc5_2;
> +	register unsigned long r4 asm("r4");
> +	register unsigned long r5 asm("r5");
> +	register unsigned long r6 asm("r6");
> +	uint64_t val;
> +
> +	reset_mmcr0();
> +	mtspr(SPR_PMC5, 0);
> +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) & ~(MMCR0_FC | MMCR0_FC56));
> +	asm volatile(".rep 20 ; nop ; .endr" ::: "memory");
> +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) | (MMCR0_FC | MMCR0_FC56));
> +	pmc5_1 = mfspr(SPR_PMC5);
> +
> +	val = 0xdeadbeef;
> +	r4 = 0;
> +	r5 = 0xdeadbeef;
> +	r6 = 100;
> +	reset_mmcr0();
> +	mtspr(SPR_PMC5, 0);
> +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) & ~(MMCR0_FC | MMCR0_FC56));
> +	asm volatile(".rep 10 ; nop ; .endr ; ldat %0,%3,0x10 ; .rep 10 ; nop ; .endr" : "=r"(r4), "+r"(r5), "+r"(r6) : "r"(&val) :"memory");

Looks like older versions of Clang do not like this instruction:

  /tmp/pmu-4fda98.s: Assembler messages:
  /tmp/pmu-4fda98.s:1685: Error: unrecognized opcode: `ldat'
  clang-13: error: assembler command failed with exit code 1 (use -v to see 
invocation)

Could you please work-around that issue?

Also, please break the very long line here. Thanks!

> +	mtspr(SPR_MMCR0, mfspr(SPR_MMCR0) | (MMCR0_FC | MMCR0_FC56));
> +	pmc5_2 = mfspr(SPR_PMC5);
> +	assert(r4 == 0xdeadbeef);
> +	assert(val == 0xdeadbeef);
> +
> +	/* TCG does not count instructions around syscalls correctly */
> +	report_kfail(host_is_tcg, pmc5_1 != pmc5_2 + 1,
> +		     "PMC5 counts instructions with ldat");
> +}

  Thomas



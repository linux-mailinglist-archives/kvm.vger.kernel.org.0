Return-Path: <kvm+bounces-43358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 572BCA8A5BA
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 19:36:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E61413BFAC9
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 17:35:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 658572206A7;
	Tue, 15 Apr 2025 17:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RwaYVd8I"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0869221CFEF
	for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 17:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744738319; cv=none; b=Aexlez4bC3mt6aMd8QWny7/qBCt9ltieZ0PK7Wm2GuW66he/66sSINNA5pCprCzAVB1znqgu1HzPTlNAEwlT/3OGQ76w2GzN28oLS5sALA9uBgcgbIpnBHAXEkrIh7e9TN7/+lbEEvmBjFnl1oYqNawazM4nggqXjgiZGu1pyN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744738319; c=relaxed/simple;
	bh=HzBN5hmj+DMXXsJd2xjl7biOFjXFYV5945zPxaDqALM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=oDhPSy89HKGNwmTqnqx+N7HkyTQGmCUYgR7L+MVGOTI1En4nw2RxFd8TU2oMGduAjygDouILHmin7ox86Lfx8mlDCUThC1PuUKMGypUfAxKDvIo99VBdg2N9CzvsmlQCexkSNzr/B4XCdxCqrOhC46vZ5hgJ9bR+ze5QqfeLf8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RwaYVd8I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744738317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/7mYhx2kRriJ8qhsg8G/2thr6sZGezFvHhrfnmNR+G0=;
	b=RwaYVd8IsZnDHf3BKJnwWogObXrDjMlLdUvxnV0bu92/F0j0Yln+S7fL4EwkIARfaSCfuQ
	B3Hw7AAZF9sQCwTHwBqsZnwH22tbkof67p4grfXgywn8Mo2/DvhsIscwOdsYXUdqPASicK
	u/8F7paPiaj98XO0ayer4CzXmtL4bRM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-482-nFdRMm9TPxSGeafkbZLoVg-1; Tue, 15 Apr 2025 13:31:55 -0400
X-MC-Unique: nFdRMm9TPxSGeafkbZLoVg-1
X-Mimecast-MFC-AGG-ID: nFdRMm9TPxSGeafkbZLoVg_1744738314
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43cf5196c25so36199775e9.0
        for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 10:31:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744738314; x=1745343114;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/7mYhx2kRriJ8qhsg8G/2thr6sZGezFvHhrfnmNR+G0=;
        b=cftJoTkc0YF1y/oAobzLdu99r7FZ3rNRKCUC5Axqgp17BoVN00K6+kA2ItgehrScE/
         eZIiCJaUOK4Ebi0DlsK7McYUfNl7JjNOaKjUszyKKKb4QEVWKjodw45yX3CkLICms3S9
         V5bBSct825v5gJtNz3VFHA8MFJNoBLRjJZmZ0c3V0hbpQF/CWciDwVzeQIZVxgdSo3AY
         l+lHdrffYVrwe2HDaCcUerXYY8kAI/pBOKA10+mMW41yShAR+RjkVfphkupUNOeL5Mjv
         cJalZzWwwZKIeEcNOH1A3cfE6Qz3LAZ97nfA5v8mNr8UOGGTL0LHp5A6jxmOsOLGsSpr
         GEpQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQsYPDNgU5jA+riNm1v9vIaBlF0PAgLe1sWLtdnNAJI5OfEDCOF2zf/CatxqONHmUIfvU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQU0RbYXFFa3vpsTz8eZMMt0fZ1/aQvdy5m2plotmQ2I+NZDak
	GV2gb3ldCmrC5FnAJAcSFtMwwxE5WQpy061JxOJlcasz1VtSvyZqn3wJbl7FX/rOnk9m/Vx6Ih4
	D32le1pNk//VaXTJN6FTY0kIk0XWuMo+UZ1kDWmox5BKcLe12Rg==
X-Gm-Gg: ASbGncvoxvlYODp34ygFyd+KHf/CTWAwLKSDRWouVNxhdhLCfO7EavhFspTM8ehA0ar
	+ObjDlchBsAiWaDV7jE8eH4yE3vCLJxMVchaxDzgdwyFzQGfIkdhl0wftjKIRPWKpF82Cdnzyzj
	MCfCoAWT2Bt/7p8umIXSCceJbRT15raBotQkQ6Lj5z8jHs0GKG8rC+ILlWF3dbB4D8dhliLoeB6
	LVHhPMh44JjNvnJGuhOaq3hnoqJUUrvJWTLCGeazCJlaHsNKfHtCMNfm7TlD/y11CYGHdVfFEze
	p9NG6XAzElDpvMsdYimZZgDnVwKMZjCqXtcQ/iz5nrRCvaozNzzaH3i0eQBg
X-Received: by 2002:a05:600c:348f:b0:439:86fb:7340 with SMTP id 5b1f17b1804b1-43f3a9b0264mr177173445e9.30.1744738314315;
        Tue, 15 Apr 2025 10:31:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHA/tx9grXm5jqEEDz9Bpub9UAtfBltUciF6sMqY25djhf7AkRnDKyrBy1HMtLSSHaxXK+rkA==
X-Received: by 2002:a05:600c:348f:b0:439:86fb:7340 with SMTP id 5b1f17b1804b1-43f3a9b0264mr177173135e9.30.1744738313974;
        Tue, 15 Apr 2025 10:31:53 -0700 (PDT)
Received: from rh (p200300f6af1bce00e6fe5f11c0a7f4a1.dip0.t-ipconnect.de. [2003:f6:af1b:ce00:e6fe:5f11:c0a7:f4a1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f233a2c53sm213921645e9.14.2025.04.15.10.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Apr 2025 10:31:53 -0700 (PDT)
Date: Tue, 15 Apr 2025 19:31:52 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>
cc: Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Zenghui Yu <yuzenghui@huawei.com>, 
    Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
    linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: arch_timer_edge_cases failures on ampere-one
In-Reply-To: <86h62wkp1c.wl-maz@kernel.org>
Message-ID: <2490752b-530d-df2c-7ec2-5feb8160c115@redhat.com>
References: <ac1de1d2-ef2b-d439-dc48-8615e121b07b@redhat.com> <86h62wkp1c.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Thu, 10 Apr 2025, Marc Zyngier wrote:
> On Thu, 10 Apr 2025 16:10:43 +0100,
> Sebastian Ott <sebott@redhat.com> wrote:
>>
>> Hey,
>>
>> I'm seeing consistent failures for the arch_timer_edge_cases
>> selftest one ampere-one(x):
>> ==== Test Assertion Failure ====
>>   arm64/arch_timer_edge_cases.c:170: timer_condition == istatus
>>   pid=6277 tid=6277 errno=4 - Interrupted system call
>>      1  0x0000000000403bcf: test_run at arch_timer_edge_cases.c:962
>>      2  0x0000000000401f1f: main at arch_timer_edge_cases.c:1083
>>      3  0x0000ffffa8b2625b: ?? ??:0
>>      4  0x0000ffffa8b2633b: ?? ??:0
>>      5  0x000000000040202f: _start at ??:?
>>   0x1 != 0x0 (timer_condition != istatus)
>>
>> The (first) test that's failing is from test_timers_in_the_past():
>>     /* Set a timer to counter=0 (in the past) */
>>     test_timer_cval(timer, 0, wm, true, DEF_CNT);
>>
>> If I understand this correctly then the timer condition is met, an
>> irq should be raised with the istatus bit from SYS_CNTV_CTL_EL0 set.
>>
>> What the guest gets for SYS_CNTV_CTL_EL0 is 1 (only the enable bit
>> set). KVM also reads 1 in timer_save_state() via
>> read_sysreg_el0(SYS_CNTV_CTL). Is this a HW/FW issue?
>
> My hunch is that this is related to AC03_CPU_14 in [1] (now archived
> locally for future reference...).

Thanks! Your hunch seems to point in the right direction. If the diff is
smaller than 2^63 this is working as expected. I'll try to figure out some
changes that let the test succeed on ampere while still doing meaningful
tests.

Sebastian



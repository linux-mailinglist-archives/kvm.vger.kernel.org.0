Return-Path: <kvm+bounces-26571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE3E09759A6
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 19:42:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A046C282CE7
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 17:42:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB8671B4C2E;
	Wed, 11 Sep 2024 17:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aJOeYiO3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F4458AC4
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 17:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726076531; cv=none; b=THUzh6EAMHoPucepVi43wDyG7FOcXYDmq9VU9hnUSTq8LFJJK84eK3mNamhxlorGsxnER3BL5YXzVi7+1Ke7dOI9Wrk5MhzrmWjrOebC1ltjzU8ZA2FcKx9ucGApHwVvhSHYA4iry5A8MlAtfuyN0qYAH/LH1jWoGdvLOPTkNyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726076531; c=relaxed/simple;
	bh=dn939sn++fwvDrb1mRwiAH6VwkMwvdG2HxDigWI+AlQ=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=OVm+8WYrBREwIC+kjMtnF0j9f1w+r1LN5s/ViiS0WEGm23SSkGJSMYeVEGEftDSX+vlq+qt3rhGzlyjDiKAZUzxLcLX1d5XwegN4ntHfUk0sOp3EJxyTnWWLuHBt4YGTU6186vXlvK9rlcFHXUe7uERr7M4TbN7/f4a+NzRbF5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aJOeYiO3; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6d470831e3aso3081187b3.3
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 10:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726076529; x=1726681329; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=706YIr0bgBd+SdWWT5lCJ2ip0tLuVrI+pXTkacc4ei0=;
        b=aJOeYiO3GcI0JykcTKTC3C/OML1+gF9uFFooNCGF9VRphwK6eTGjQz1b4QxQq0wXWS
         2d7Cup/I5gv0QJcTWXJljtB2ccYrrwlOYJyz6dh+bNgm36fj+/iBfp3oVIDMES2nLfxO
         87kmbSlG+Yb74xaHd/pUfSUvcgSJF/90K+U+Bvt6DJNSB4Ia9YmUuX7YKhZ8RoOLWX/3
         336+GDiNncXmTJyjMU1nNUrZbwDmgt3z4/PoIoIrEW+5XAp0DYgxbdUn5D3SqW6Hk3SF
         MPH0WsEQbD5TwbuTs/MCSbuxAYuDG4OBIIEbevLox7jw7pSSKfhOPg6/+85WbHYGn1a8
         hw9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726076529; x=1726681329;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=706YIr0bgBd+SdWWT5lCJ2ip0tLuVrI+pXTkacc4ei0=;
        b=YiN6egUsFqw4wrQxtAuKRkZaMk7X+GGNEc7BQ6UKkKZn7AbG7WNTPFNyVGZXLTfywh
         wy8AIGikPb3+I0Ickd0SuTbepUNkvwlLxS8Rl5KV2+YrXZE9TZPDsLsLmY8Mo3XkMAyI
         ckwr0Dn5wIEaqH08zdSRZlT2mwFWpjI3cnbS4ozRriMqe9pT+sxYHqRzbJzhFQd/mfx0
         L46RrY0qPivbQP3qcNaw7NCWHcnhXc1DdUIO+j57qKSa+nfgSkl7zpMdcByc52TxXFyl
         TZuShgA4oP3rSHlPZqRgbZWr/wz7y2Ng9VfN8SX3cj46Rp7GV5MPfKaBDwd62KOlq38Y
         2Q0w==
X-Gm-Message-State: AOJu0YxzKLFTNossdd1RLfoFi/7k6/54SpqjkTLa02ilwy67gYNN2md1
	7ZIBxK6Maxuw3okPkRxnERZ0U/1haLqbGxYsNJ8ClyUdfcyDK7F2jOepF7ypP2wq6loCHGir9TB
	y7Yg/j8dbOfBFaAXfQPUVrA==
X-Google-Smtp-Source: AGHT+IFvlmwQkSjQLxVucUW7uRZBOX25a6vFDWduRsiEd3MV5YuAAx1lfuAly70GDxykiYb30OJnJ7h7mzdG3bMQWg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:11b:3898:ac11:fa18])
 (user=coltonlewis job=sendgmr) by 2002:a05:690c:fd0:b0:6d6:bf07:d510 with
 SMTP id 00721157ae682-6dbb6b9d655mr6437b3.6.1726076528473; Wed, 11 Sep 2024
 10:42:08 -0700 (PDT)
Date: Wed, 11 Sep 2024 17:42:07 +0000
In-Reply-To: <ZtmOENs5qveMH920@J2N7QTR9R3> (message from Mark Rutland on Thu,
 5 Sep 2024 11:55:12 +0100)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsntv7z2cck0.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 5/5] perf: Correct perf sampling with guest VMs
From: Colton Lewis <coltonlewis@google.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: kvm@vger.kernel.org, oliver.upton@linux.dev, seanjc@google.com, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com, 
	adrian.hunter@intel.com, kan.liang@linux.intel.com, will@kernel.org, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, mpe@ellerman.id.au, 
	npiggin@gmail.com, christophe.leroy@csgroup.eu, naveen@kernel.org, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, tglx@linutronix.de, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Mark Rutland <mark.rutland@arm.com> writes:

> On Wed, Sep 04, 2024 at 08:41:33PM +0000, Colton Lewis wrote:
>> Previously any PMU overflow interrupt that fired while a VCPU was
>> loaded was recorded as a guest event whether it truly was or not. This
>> resulted in nonsense perf recordings that did not honor
>> perf_event_attr.exclude_guest and recorded guest IPs where it should
>> have recorded host IPs.

>> Reorganize that plumbing to record perf events correctly even when
>> VCPUs are loaded.

> It'd be good if we could make that last bit a little more explicit,
> e.g.

>    Rework the sampling logic to only record guest samples for events with
>    exclude_guest clear. This way any host-only events with exclude_guest
>    set will never see unexpected guest samples. The behaviour of events
>    with exclude_guest clear is unchanged.

> [...]

Done

>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index 4384f6c49930..e1a66c9c3773 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -6915,13 +6915,26 @@ void perf_unregister_guest_info_callbacks(struct  
>> perf_guest_info_callbacks *cbs)
>>   EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
>>   #endif

>> -unsigned long perf_misc_flags(unsigned long pt_regs *regs)
>> +static bool is_guest_event(struct perf_event *event)
>>   {
>> +	return !event->attr.exclude_guest && perf_guest_state();
>> +}

> Could we name this something like "should_sample_guest()"? Calling this
> "is_guest_event()" makes it should like it's checking a static property
> of the event (and not other conditions like perf_guest_state()).

> Otherwise this all looks reasonable to me, modulo Ingo's comments. I'll
> happily test a v2 once those have been addressed.

Done

> Mark.


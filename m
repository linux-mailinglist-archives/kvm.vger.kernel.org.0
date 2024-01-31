Return-Path: <kvm+bounces-7598-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 40A2584474F
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 19:38:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F10D5290BEB
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 18:38:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06D3F210E2;
	Wed, 31 Jan 2024 18:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3GSMaXoh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE64117C75
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 18:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706726294; cv=none; b=IjwrE2gqCUXseWnOZKcCtQaRG+JuuFJPUCspSTM9N8sywU+IS9YM0JFavL9UJA/WWEjqoWJTsw51UhDMP8LhATwQ4R4nb3NzHW3AO3DR2exzAtDboqJ9s52On7tkq+5vpLwJq8QnVsGlxBfJBmosCUbkm7vMDY/I7vFfGsjNHYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706726294; c=relaxed/simple;
	bh=UfjYc4q1VOylXIyltW4pByW+ntMGUUi2w22Mn2XGXdw=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=XrAQBAM/e+cOQVDgIl1agn0ZZ6YhwgWJbv9WxAm+RU6PT5XKVOfaEIPOAKw/v2RxuwX9rjcUnZ8C9G5/+I3w8Ulxq0jTXo5JcNsvck8jOlmPpfBC2mcss3rpGa/RfAeyMFL/9lS5rT7hpWMpL32H0TK+8rVABurfP6TlZ7EfW+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3GSMaXoh; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-7c000114536so5534439f.2
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 10:38:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706726292; x=1707331092; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=B+7qh5lgqKvRJ5XTxEYs6sYIXkTaK5rzWchXA2WiWMs=;
        b=3GSMaXohKe/sOzam4ctApjW8NDYxjXk4Hu/WRuY3k693uQdeeehFaRbc26X4eMbvsC
         L/lAkqgbe2dweTQ02A78sLyEQ1Mhz+BpBbDctwiWw8Emy4iYbdNnf0yvN/IEHVbIxKm2
         1WBl2+QkvepiqxpIGigbzawtV+05aIXbRWApWfn6V+c8KWegO/WrA0xTVqMFaDuss+TT
         SdEo+9VQJS/V1Mem5j9DDH2tAO9IYZK+4x1BFgA8nBCTOUboG5hTh0rFsx5X1k2CANIm
         SCx6x/hBI3o7TjTH1DEvG+KRuhWbcr0SuOFwsmvkestp0pCmxCMqC3dcf4NOLDsDvqGu
         kI6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706726292; x=1707331092;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B+7qh5lgqKvRJ5XTxEYs6sYIXkTaK5rzWchXA2WiWMs=;
        b=UVDnyiToxZAkpbHNwbh19poluIFfhkGgYxdlBTHm85L9JTCi4NCD0yVH2YCe6SG4UT
         HdQL2fSmqVQOUSn59OVUclc3RaLEVJamdGnlLZns2UasH40q1Xil3XSVZV7UhVg5wbZw
         ZlDkSOeATbLb3ay24a9O7cLnQYevlBvxwUbIkeqCHQxpoBHBx8Ag3LJFrFH7JXAf4+dW
         GJqSi1YJJLrv25EPAoIVicYX/xmqZSJawQV1tTp2WnttRrpIFiWxWvRwkdr52dYh24Y1
         mFQW7ZWRNri8rvd29oxz/timl9qXi27sx8gxQT12JKw2WuhV81lpsAicAi7FKp7/OAKP
         TxLQ==
X-Gm-Message-State: AOJu0Yw23UVoanu656+quHhUuQJY1EkW5YcUVuZU1rwbWDxVFQVJq/7u
	MVqXx/CHP24aWKUgQfyBbG92Dr3epvvjB4rhni31yehWVcAEZXAgZTW5Dt4N9QzEx37EGfC87Vp
	kuEK1zs3Q/izeb88KHooCRA==
X-Google-Smtp-Source: AGHT+IEWULPllFBaQ8dQeEAuZdnKaMWtTDPxrWTLe4io4YQ7kFWLbe1eQTSY5SCp/s+Zau2KSwPR0XFYd0AUCsyFhw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a5d:9c07:0:b0:7bf:ff87:209f with SMTP
 id 7-20020a5d9c07000000b007bfff87209fmr25977ioe.2.1706726292022; Wed, 31 Jan
 2024 10:38:12 -0800 (PST)
Date: Wed, 31 Jan 2024 18:38:10 +0000
In-Reply-To: <Zbgx8hZgWCmtzMjH@linux.dev> (message from Oliver Upton on Mon,
 29 Jan 2024 23:17:06 +0000)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <gsntcythl565.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH] KVM: arm64: Add capability for unconditional WFx passthrough
From: Colton Lewis <coltonlewis@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, maz@kernel.org, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

Oliver Upton <oliver.upton@linux.dev> writes:

> Hi Colton,

> On Mon, Jan 29, 2024 at 09:39:17PM +0000, Colton Lewis wrote:
>> Add KVM_CAP_ARM_WFX_PASSTHROUGH capability to always allow WFE/WFI
>> instructions to run without trapping. Current behavior is to only
>> allow this if the vcpu is the only task running. This commit keeps the
>> old behavior when the capability is not set.

>> This allows userspace to set deterministic behavior and increase
>> efficiency for platforms with direct interrupt injection support.

> Marc and I actually had an offlist conversation (shame on us!) about
> this very topic since there are users asking for the _opposite_ of this
> patch (unconditionally trap) [*].

> I had originally wanted something like this, but Marc made the very good
> point that (1) the behavior of WFx traps is in no way user-visible and
> (2) it is entirely an IMP DEF behavior. The architecture only requires
> the traps be effective if the instruction does not complete in finite
> time.

> We need to think of an interface that doesn't depend on
> implementation-specific behavior, such as a control based on runqueue
> depth.

Good to know. I'll be thinking about that.


> [*]  
> https://lore.kernel.org/kvmarm/a481ef04-ddd2-dfc1-41b1-d2ec45c6a3b5@huawei.com/

> --
> Thanks,
> Oliver


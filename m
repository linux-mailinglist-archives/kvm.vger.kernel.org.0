Return-Path: <kvm+bounces-14754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2CFF8A6767
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 11:49:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C459C1C214F8
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 09:48:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F01298613E;
	Tue, 16 Apr 2024 09:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e8vU0spu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FA067A1A
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 09:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713260933; cv=none; b=GcarCU3uJ3tLpCrtgVDB+mY3KgdgYErBHYNkyYPH/L21kapsVF9HwWnyCnthqUow0zEkhHts4VS5UwdRFI68yHgJfUeqYkT472a9YPoGK+CNcdFSYRHO29jvQ6SnL5cLSX0pUg2p6Dpb3unDxIgopNYZQ97U9pQL4yVz/VFY5Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713260933; c=relaxed/simple;
	bh=Zyuih9nDNsZgpP+fGKbSYakE6gN2lH+XqpuKl2Z6UI0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u/9ayTN8n3nzY2pFwlbyzniJhbdS6jo3X+EUARHINJe7pZsUxXoekUtzkOSDvP8EEh+KG/2iMqDCpiFtZxTdETmZZxyPrpdlyK7YU/1EGdaoQDu1eQT4lhsjM7i1gwuXtgL1QsTFUdC0zYZGarzA+iZM31enPPjtcMt1uOF+yZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e8vU0spu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713260930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OvpXejDiwGEjHoxD4ZEAks20tfVbuh1Cagfwa1De0tc=;
	b=e8vU0spuQ+JH4du4Pmfi8pdfqibuUgyA+5QAUX7IZ1WfoIARgidjPyvdCVxkynXEIMt7EY
	Ckw32ODvuha5GeGmg6tXs4Px32lpC2OILxCPz1IlQD3Vlbh3PSw3aB47oz1o+1cvFTS8Ng
	IoD2Omd+wCppUOuyTXlHEedBADNMV1I=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-97-8TfMq4XKNaGAuz3zzMhiAA-1; Tue, 16 Apr 2024 05:48:47 -0400
X-MC-Unique: 8TfMq4XKNaGAuz3zzMhiAA-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a52539e4970so156934766b.1
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 02:48:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713260926; x=1713865726;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OvpXejDiwGEjHoxD4ZEAks20tfVbuh1Cagfwa1De0tc=;
        b=OC7K7VAJeITaZPtHuwS23thKUFLgvTZ4hZPAEGw82BgUalMETSm4Qw8FnpAPmBV5/J
         j2giYKSg1RxUHyrU1XpobJXTRd2c88mhwdm3Fx7h+g7Y6ldL2QWiSxZMWipULcoe82Sm
         J9+hv1K2ak0E4p4TW0vE8YIN6RYG+UoUzEj8IM53x4OndcUI0Eti7smwAxUMGfcVKOmU
         ADhtrHIHgNybu1Gyn1ZGwuZ5sV9NwIFvRYzrKkh9vNnGpMa+uATWnGD4Wmhmy+suGsQ+
         fb4c4R9i+4dA50qiFYu/vFYi1D5BijmrnFJeCTtVCa4MENgZTQxA/gPh5E+nbZ/Oc2sE
         nzqA==
X-Forwarded-Encrypted: i=1; AJvYcCVGUg9GwuIlTfMi7KsacnKNCVijPgNK9Fu7S0yBmsZn8ddrDp3VdjoH+nuNeNwYT+86JaaWVHhp8A2QEjI18HOfL37M
X-Gm-Message-State: AOJu0Yx9kXRDfRw7DPFu0AP+IgMESlfl8osFXamK8etnaXiiPYGH41Hu
	l3cuW4hUcpZ5rbrGlG6vZy61FGIQuGIHwvTldWP51QEXe8Ko7YiBFQexexl6h0Q9hcjzxduyT/c
	MKj+rVkc5mxwy6TbvcU6KDpeAOy1I1vbEAg6hgduBA4ykJ3iNJ0ZDq5bjyw==
X-Received: by 2002:a17:907:84b:b0:a51:a288:5af9 with SMTP id ww11-20020a170907084b00b00a51a2885af9mr10143256ejb.51.1713260926010;
        Tue, 16 Apr 2024 02:48:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7QvP8QaDo1r0jamFnQGf2/DH9YWAVlyPrLI3iTs8Miw5OV0r/VmBNDqMfwu4UWZGLOxnIhw==
X-Received: by 2002:a17:907:84b:b0:a51:a288:5af9 with SMTP id ww11-20020a170907084b00b00a51a2885af9mr10143245ejb.51.1713260925691;
        Tue, 16 Apr 2024 02:48:45 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-43-179-50.web.vodafone.de. [109.43.179.50])
        by smtp.gmail.com with ESMTPSA id dt3-20020a170907728300b00a4e23400982sm6632846ejc.95.2024.04.16.02.48.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Apr 2024 02:48:45 -0700 (PDT)
Message-ID: <f56aa1bc-f295-46e8-bcca-2683ecf7d0d9@redhat.com>
Date: Tue, 16 Apr 2024 11:48:44 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v8 11/35] powerpc/sprs: Specify SPRs with
 data rather than code
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240405083539.374995-1-npiggin@gmail.com>
 <20240405083539.374995-12-npiggin@gmail.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240405083539.374995-12-npiggin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/04/2024 10.35, Nicholas Piggin wrote:
> A significant rework that builds an array of 'struct spr', where each
> element describes an SPR. This makes various metadata about the SPR
> like name and access type easier to carry and use.
> 
> Hypervisor privileged registers are described despite not being used
> at the moment for completeness, but also the code might one day be
> reused for a hypervisor-privileged test.
> 
> Acked-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>   lib/powerpc/asm/reg.h |   2 +
>   powerpc/sprs.c        | 647 +++++++++++++++++++++++++++++-------------
>   2 files changed, 457 insertions(+), 192 deletions(-)

I tried to merge this patch, but it seems to break running the tests on 
Ubuntu Focal with Clang 11 in the Travis-CI:

  https://app.travis-ci.com/github/huth/kvm-unit-tests/jobs/620577246

Could you please have a look?

  Thanks,
   Thomas



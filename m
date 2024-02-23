Return-Path: <kvm+bounces-9547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C7C248617D1
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 17:26:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7EA461F21C86
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 16:26:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4712984FB9;
	Fri, 23 Feb 2024 16:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BYPJ50fB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A1B84FB2
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 16:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708705564; cv=none; b=Q2aSfnkC1CtUY0Bia3y1bRsjLv5X9Cmb8r/fbkQ8pyMRmurE4OMj36YykBSukUuX5gyb/3UXWZuhR2Gp/doslwOJfuHy972zFTOcOx9QKB0WPEAmnsmwPTjCV1gcysdmuzlHZcob7ejP38ZZhwZR2HmSm7HIIeotQL9lb/AkOuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708705564; c=relaxed/simple;
	bh=87ijvGBUVdk2XeT/USaewCYk4ORdmGu/yjVUInEeHCg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CKtjrAj2nQU0V4GttVQoz+95/TNGVo9P9zT54QZ3rTOYwHLI4LEjMQ+YuFWaFtkWAtCuUv6rUErKj8yi1u9LQcKRfsEL093LcVyocdaYkzOs16yLyVHhVbHP+l4C2OOlhNlxz76DVZ3PxJUhbsGxNVyGTFGhxZ5hb72zSXDq7Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BYPJ50fB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708705561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=940/XEmJBSZDaRCjXuufne7H+L7fc/6jI5oiCpzkdYw=;
	b=BYPJ50fBTqk5yY6CNnnVPYYAIbd+dK9TQd3qXtiUN8VXP8SXa0S93mHEVNpYvpRj312502
	mHpCQjFcSQWdVSyNHC/wIVfPKpAJ0U5EUsvxsJo1elFNbzZ+ws4OZ7VuaWHwa8zRC3aTb+
	Q0QYNcsqYIHg9yytko+ISc57vhNDDMA=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-520-PUs0OVCnMkGHSzz_enKfdw-1; Fri, 23 Feb 2024 11:25:59 -0500
X-MC-Unique: PUs0OVCnMkGHSzz_enKfdw-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a41380f5ee5so20781866b.2
        for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 08:25:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708705558; x=1709310358;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=940/XEmJBSZDaRCjXuufne7H+L7fc/6jI5oiCpzkdYw=;
        b=VGfBbu68RrYHki0P8sbIQX6/lwXJEchIsAWkk201VoATz0x4wm+sj9+LKrZj1hgSZu
         /ObO8gxTJ+ZeXWfzAyfxCCmL40z+sxNhlIauadujAyLN0ujcFEg1l/71KJD7Rl7QFQ/d
         gjjESRROdWFtipMkMCTA39PGxDmfvbSbRVI6QJM7cfyzsHE03IOYqb1TJEPRSsmzKICH
         7HzBgEhLP8YHUedhseLU9eWhGZQDF1IeOtgbGUeeiaPRbrKXB9M01Isrv2YNBhA6KWpd
         NnFowNf3zzXhCBgGBOBFXv7mgCgSaw3kaHSwrOnnzhcHcudqB85uBn4AyalafGLLCdus
         IXQw==
X-Forwarded-Encrypted: i=1; AJvYcCXungeUQCU5aLPpX+IX9KYFIdoF5DkZzeYqtm5+GfYV7HwAFoER236TRQyQz6sjF4bCXrXVH1MhAShuwZW2rRRyNqXT
X-Gm-Message-State: AOJu0YxRBACzf1XTEiPZaQuCfne1PR378giSWhQfs3HUDimuiaF39pvm
	8/gbF8NuGZCeqZ6NQXvdWOMzcq6dJXtqBE34sDA+MPktXczUWcdCCLotDAeMjx0m0bWBn48UTSI
	j1SMLcNvGevsTBOZpKbr731ARetmOLciLCR6wqmyZcxo5d3BICQ==
X-Received: by 2002:a17:906:d923:b0:a41:30be:4a82 with SMTP id rn3-20020a170906d92300b00a4130be4a82mr166470ejb.61.1708705558644;
        Fri, 23 Feb 2024 08:25:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE4sbFmAlZnHaE/ojQ3u5/OWKq+fxOUwb1p/8RpYLJo/ppd2IOJQSq9yZuFbP5USJG0tPnnHg==
X-Received: by 2002:a17:906:d923:b0:a41:30be:4a82 with SMTP id rn3-20020a170906d92300b00a4130be4a82mr166460ejb.61.1708705558322;
        Fri, 23 Feb 2024 08:25:58 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id ld1-20020a170906f94100b00a3e82ec0d76sm5331965ejb.113.2024.02.23.08.25.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Feb 2024 08:25:57 -0800 (PST)
Message-ID: <335d6086-2269-46b5-9e45-8707529213cd@redhat.com>
Date: Fri, 23 Feb 2024 17:25:57 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/11] KVM: SEV: publish supported VMSA features
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com,
 aik@amd.com
References: <20240223104009.632194-1-pbonzini@redhat.com>
 <20240223104009.632194-5-pbonzini@redhat.com> <ZdjCpX4LMCCyYev9@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZdjCpX4LMCCyYev9@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/24 17:07, Sean Christopherson wrote:
> And unless dead code elimination isn't as effective as I think it is,
> we don't even need any stubs since sev_guest() and sev_es_guest()
> are __always_inline specifically so that useless code can be elided.
> Or if we want to avoid use of IS_ENABLED(), we could add four stubs,
> which is still well worth it.

This particular #ifdef was needed to avoid a compilation failure, but 
I'll check your patches and include them.

Paolo



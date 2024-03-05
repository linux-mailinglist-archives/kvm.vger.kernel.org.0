Return-Path: <kvm+bounces-10891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35A5D8719A4
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 10:32:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4DB4284C0A
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 09:32:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08F5053804;
	Tue,  5 Mar 2024 09:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OkH0stL6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0226B4F1F8;
	Tue,  5 Mar 2024 09:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709631135; cv=none; b=RhH7TlokH7DJJnviyF/6/NVpXTftSivQTWWhNMiI2ka/4CuA7jkKcR7qcrGIBRHF/M0HEfPrMuLBa1dQjkt8D/8ALlzh28qHHD2IRx3AFbAazqZdwrHAuJIYMs+8KfxgYIMXg3sD0sMMXhjGwPvynvxbkRBZNfnLqQ0HMOgyV7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709631135; c=relaxed/simple;
	bh=5EPSFVVnwFFNn+xZEadu+AOH/jq+6eTcU34T204mVSc=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=oZXZx4qugVMIZfaDIPlXDVg4y3CnYq9geJOrSF3grMByKtCNua9iaLeGkh1E6att++I7tyxDKi4HtYkCcYWyMN7JPPh79pX/xFWT6EHdBXqDyXHhqzpWWyiKpWP+6mkR60u6Sqz+ZitXFeK6wMmP3BDEA6rDRjaVaVME4JWDM0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OkH0stL6; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-33e27940554so2106427f8f.3;
        Tue, 05 Mar 2024 01:32:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709631131; x=1710235931; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AnpeB/fbih0dzCK3HxEZh9jhAURN9PnPgtNJe0vDNuo=;
        b=OkH0stL6X3/KY/5OSdMIcIUd4KtXj4uH0h7GKW2D4zUfnnUtkheOmNhCLwwdyJGacW
         hJI7LHeTU5NSFiM0skm/08G1WX+VJ57p8BQlrWGZmOnGMpk29Ap7fNwX67L9D/i6gdci
         TwpJbZ2cWFpg2dGWKs98tSzSwOZ7tnXlFKBNoPoCygBwXk6At5OZRWy1ErzMbOnSg8GD
         hFIG5hiL9+HFmdMOfsZxLYze8yGygDCEoGu8bnd+pS318ZpBiH5I1GofqHsnsFSYlvh/
         WhGrnHwasBi+ZOHLQKALUctCSj1vyTUi147XyFbPzoxoy+j2adUV+W0w4tarjkqRiqRO
         bimA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709631131; x=1710235931;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AnpeB/fbih0dzCK3HxEZh9jhAURN9PnPgtNJe0vDNuo=;
        b=QPQXm4YQ2rPF44DMjQaWoEpOYwp4+VOGwr3R9CQwU9olRfUk5R/3xT0iXk48j42WMf
         lhC+f0sw3pDcEgfLRhCefRzFO0h+WOlPYZmhvO3EyuyeqL4oiL6Tj+tKnH/vaVIdgfvs
         olVh4Q4WdIxBqsiY9NjOjmeol+OBJQ/IbcmbRWq1adUmyqVRdYKistNfBPDw1Istu+Ww
         3RS/wz7LcUK0MjTmoSfSXIb/NQRTRufMczJAywQK1uFhP0PaS6s99eDdaIOzKjcCju/A
         wvlfA568Nu/D1zJW6Pwd/DKmi8pGKr79sw50GX6kDkp+bPoy4ediJKgSzmd4bGhLjXVj
         HWag==
X-Forwarded-Encrypted: i=1; AJvYcCWkvcM7NPwT+v5pN6AXkI/eirz9B4LqpY4ROPvSTWY5z2cVefh61qt9efNMQMYDtWn0qkLBAJuQ7mbtNqwxtJOMYFUjjf/UHyw1iUQv
X-Gm-Message-State: AOJu0YyYnQf0RGCqwBfeBQNmvSl/ZsQEFCgJeDbQ3puQOfod0xYWd5QM
	8KoLv5qaC9xvkH1DXDCkolT122++pycdZuOI5gL+Mj6BmmqWNaii
X-Google-Smtp-Source: AGHT+IH/AzVB1tK9puOCaNVpjcvfadwjFJKNjC5dw3N79NtI1PRHEAm357UhgqbaFNmy7dz5w7308g==
X-Received: by 2002:a5d:6283:0:b0:33d:1153:f41a with SMTP id k3-20020a5d6283000000b0033d1153f41amr6804395wru.20.1709631131159;
        Tue, 05 Mar 2024 01:32:11 -0800 (PST)
Received: from [192.168.19.5] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id v13-20020adfd04d000000b0033d202abf01sm14402366wrh.28.2024.03.05.01.32.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 01:32:10 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <c46f27b8-3ff3-4da9-bfde-c1c24e77f2d9@xen.org>
Date: Tue, 5 Mar 2024 09:32:08 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH] KVM: Drop unused @may_block param from
 gfn_to_pfn_cache_invalidate_start()
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Like Xu <like.xu.linux@gmail.com>, David Woodhouse <dwmw2@infradead.org>
References: <20240305003742.245767-1-seanjc@google.com>
Organization: Xen Project
In-Reply-To: <20240305003742.245767-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/03/2024 00:37, Sean Christopherson wrote:
> Remove gfn_to_pfn_cache_invalidate_start()'s unused @may_block parameter,
> which was leftover from KVM's abandoned (for now) attempt to support guest
> usage of gfn_to_pfn caches.
> 
> Fixes: a4bff3df5147 ("KVM: pfncache: remove KVM_GUEST_USES_PFN usage")
> Reported-by: Like Xu <like.xu.linux@gmail.com>
> Cc: Paul Durrant <paul@xen.org>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   virt/kvm/kvm_main.c | 3 +--
>   virt/kvm/kvm_mm.h   | 6 ++----
>   virt/kvm/pfncache.c | 2 +-
>   3 files changed, 4 insertions(+), 7 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>



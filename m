Return-Path: <kvm+bounces-21595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 373A3930418
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 08:19:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D16B61F223D8
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 06:19:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 611161DFEA;
	Sat, 13 Jul 2024 06:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RhdLkJf9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A5A1B960
	for <kvm@vger.kernel.org>; Sat, 13 Jul 2024 06:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720851570; cv=none; b=h1WbmBVcRSmkDtr9jGFoPa+7sy9LS2IA+c+T2zB7hseaP49ePgWHG0BswWS6S5aFoY7a9ZccSfsRQTKaCG8qYQTwRHN/SC0bRBBHoE5MrCmzu6pMHLcbnDlc+0KRNzKrh7ySUG8HtB3OzWas7/WHHBywKbVElieH/ZriGKnghIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720851570; c=relaxed/simple;
	bh=Y26hEXReXMo/MnVVN/Ll6zUwaOyhmGXLyIaLdQsYad8=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=XarIsB+bgM7pFVlghQ18I3Mj+O2Ar3BEVdFg6QpA8rb5koNnWWBfMBtfAGoYb8fiAQoX0KWoXQnu76vNl98evhOOmECa8jh00w2CBVBnwUEehmzLmOC2edzTDTBqzGzUTXrBlnUoOhWtAL48vH0l+Wk0Iz8fCnxWlNA4fqefYWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RhdLkJf9; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a77cbb5e987so335220466b.3
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 23:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720851567; x=1721456367; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:reply-to
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9DNZHQPa9KuVHuHzUy7cPsN8mQMXJWpDkGpt2lO0my4=;
        b=RhdLkJf94WCp6OLtmaVMuCBVOjfZ3r9S7zr+ssPL31hxNPeSBoGWHgmcy0ci59jD9E
         IpDYNwzWrQy6RKFHwhLxR39pOjtUyGdJIwGVV50IJ4jqKjgVZVaZxRH1fnJtzr8ptgMn
         +TnjHgSepHGnRQ/11HJmH11eOGhHZIk15pK2TQ+NPqXavWrLFC9chG4EJapU4vWnPBc2
         YhkZ+TSefIGOcHYp194AG5cWu6GEoUSnzocPxbaSP9OEP08gk7+t0fHBLRZ0jUNFU8Sk
         AN00ZhYoItPiICgeN0Src8S2b7mkZ61M9AQqQCXZRYspTiQ2lsdNqQyJSyY93ApFoK46
         ZMyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720851567; x=1721456367;
        h=content-transfer-encoding:in-reply-to:organization:reply-to
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9DNZHQPa9KuVHuHzUy7cPsN8mQMXJWpDkGpt2lO0my4=;
        b=nQClKv77vOEd3WrcaD7OmI7V278a9V8Mi5lcVjPpQbyjm4burnhsFQYi4ZnEFoWUkb
         WsrsXFmdJiJmH1EQaW7GzJpmGjagCGR4NPUS+G9jqduYY1ZsoW7ddFdEyNn+N667uzch
         eE3aToA5XGVLIwFamoMfDB7L5dLgKkZVqnEuKe5CMPM+PgULbLO+aDtARRJO/Q6IK7ZT
         GkvITZJpfqFHWiME4zHYWUJ04Naplk8fuAXl31YkwsdCjt2PIAVoaCkOfLhUG4JREUKU
         9nDkb+hneOR8DLE73GMWcLBefweJWsF9TWHGYYeVi8AJ+0W0yGuCJm5gA5e/fFSZqb24
         sQOg==
X-Forwarded-Encrypted: i=1; AJvYcCVviOKRikqQLvSIiTqQp6y2vf7BNNI5uovkBLBWDHnI9ferfp5ouRv/93TExSuCKb1uLBgTSGhewVRcLUJ0rJTR/K9U
X-Gm-Message-State: AOJu0YzG+m3nGa9xzUSpfxNy1XomGlS5BoGgCdUwjDiYr39n9U2U7rPX
	jOVkiE0jXTNmONu9zZitEaQe64GdqbT7Cv+3ZiByuozcOre0F1wU
X-Google-Smtp-Source: AGHT+IH6kOb8zkHqZetjmaG/ocq/Ozgv7lNq4K4o4i+ZAjp3kbJQI845cUjqQ3i0jzzVOgF9d2B31g==
X-Received: by 2002:a17:906:22d9:b0:a77:c583:4f78 with SMTP id a640c23a62f3a-a780b705109mr657362566b.39.1720851567027;
        Fri, 12 Jul 2024 23:19:27 -0700 (PDT)
Received: from [172.16.6.209] (i68975BB6.versanet.de. [104.151.91.182])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a79bc5b7e79sm22200466b.88.2024.07.12.23.19.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 23:19:26 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <821eb43e-109d-4fe9-8e5c-daf840d02b33@xen.org>
Date: Sat, 13 Jul 2024 08:19:23 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] KVM: Add KVM_(UN)REGISTER_COALESCED_MMIO2 ioctls
To: Ilias Stamatis <ilstam@amazon.com>, kvm@vger.kernel.org,
 pbonzini@redhat.com
Cc: pdurrant@amazon.co.uk, dwmw@amazon.co.uk, Laurent.Vivier@bull.net,
 ghaskins@novell.com, avi@redhat.com, mst@redhat.com,
 levinsasha928@gmail.com, peng.hao2@zte.com.cn, nh-open-source@amazon.com
References: <20240710085259.2125131-1-ilstam@amazon.com>
 <20240710085259.2125131-5-ilstam@amazon.com>
Content-Language: en-US
Reply-To: paul@xen.org
Organization: Xen Project
In-Reply-To: <20240710085259.2125131-5-ilstam@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/07/2024 10:52, Ilias Stamatis wrote:
> Add 2 new ioctls, KVM_REGISTER_COALESCED_MMIO2 and
> KVM_UNREGISTER_COALESCED_MMIO2. These do the same thing as their v1
> equivalents except an fd returned by KVM_CREATE_COALESCED_MMIO_BUFFER
> needs to be passed as an argument to them.
> 
> The fd representing a ring buffer is associated with an MMIO region
> registered for coalescing and all writes to that region are accumulated
> there. This is in contrast to the v1 API where all regions have to share
> the same buffer. Nevertheless, userspace code can still use the same
> ring buffer for multiple zones if it wishes to do so.
> 
> Userspace can check for the availability of the new API by checking if
> the KVM_CAP_COALESCED_MMIO2 capability is supported.
> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
>   include/uapi/linux/kvm.h  | 16 ++++++++++++++++
>   virt/kvm/coalesced_mmio.c | 36 ++++++++++++++++++++++++++++++------
>   virt/kvm/coalesced_mmio.h |  7 ++++---
>   virt/kvm/kvm_main.c       | 36 +++++++++++++++++++++++++++++++++++-
>   4 files changed, 85 insertions(+), 10 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>



Return-Path: <kvm+bounces-19840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 788D490C346
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 07:55:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E21FAB231F6
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 05:55:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BDC022EF2;
	Tue, 18 Jun 2024 05:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FoazC+yg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404A01B285
	for <kvm@vger.kernel.org>; Tue, 18 Jun 2024 05:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718690138; cv=none; b=jgV76CepFbTscJpzay/3TZTwBEvSWyOeF+XyxIDw/U78TyLUMvzEptNXYU1b+8PrQwTMBIUzU+bR1mGeAKMZPK9Pn7B8G2CTlReoP2AZHcue38zyAjzTV8fEYmoIlrrpTFiQjF7jn/16aHCcu6HPvL9Cxa+vxfD8ZSzUAhU4Dl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718690138; c=relaxed/simple;
	bh=7RiwnKT2I1MFdE03Yi9OQNr5nfwBkB7Vzra8koLRLqc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n1iZvi+e6VKAA5cCH78gKqW67tARcEJfMVVUOWjbbGefsrul1q7h/b/s9NmBJfeu/vtNJmEP2eXx9GNYzfaIKyIgDSw9SUSehDKkCLuMAlbzd7tiNz+y6nRIvsp+4dIWP0TLTferm8Drfp9TTlzbfpsvocFWJcYTITigSC4GQvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FoazC+yg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718690135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hWu/voSZi4FQiwHW6WOBcFhupKmk2O/NDijOpbvubbo=;
	b=FoazC+ygplA9pUbJ0Y2rODGrh+n0sPWK8Wd8yvUaPUpLc79rgNEiN6XWuis2XlGudLQgTK
	qTaRAQmev89rXS0GIwtYI/M6el8ajzBtnQCDIyMbqDD5Et4iLiZ2cn8Zb8di3IzB5uaZPT
	Zjs8zGPK7B5QHF2uXLJFvOLPB5BxoWs=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-dzP2zr5oPuGq0QqDiuLNIQ-1; Tue, 18 Jun 2024 01:55:28 -0400
X-MC-Unique: dzP2zr5oPuGq0QqDiuLNIQ-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-2502a80477bso92100fac.1
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 22:55:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718690128; x=1719294928;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hWu/voSZi4FQiwHW6WOBcFhupKmk2O/NDijOpbvubbo=;
        b=n+6sAZhHyOeobJiLfY4uD20MDGbeOJbyu83xE79bQu0Hw+jKHWa3O/FsNkxAu/kjT6
         mvMY/Z4++WM8POV8FdTXd6AcYKer7Yn3RyPflZ+/V5dMlBU60W6IjVhxnUqBiBg09Fzy
         Ufi/oDtIv1AiYwKBnUU5dQRnHwGdXTsl5eAJ2+d/cRp4phFKOI3E5kokfNLoRWwjU74a
         +UR+GVQCQA5mMBMyCb6uIhbhIGBwOXf0EenAmHEJXdHhXVa00rP6PduuHNlP5QdZca6g
         +a6Y24TmdXVKvKjsIzpKFYFEU/HtK+B+tILNlRomB0TSerDxTog+c8B8A3piG+lhrDbG
         uT6A==
X-Forwarded-Encrypted: i=1; AJvYcCWCVfs/zkoRuArrnWVbaP0GZHYZ82V2Ah5+dErgYea2gZ7uZsCNW28SGaZTKkdB8svpmgwNUmJAYx0m/pqSppFuzwaP
X-Gm-Message-State: AOJu0Yx/79zIwJ0FaHOl0aaYazP5qtbIDFInh8bdpBT+tgRDvPpt5D89
	e/S7eqxCX1VKGd25IE5ng7jQISUkE1EAmFvIO13MfMmE6tpNwATnTgAHUOIJrvTvGEPFN3o6FdJ
	JygwJYm3+B4A9Y4y9q/kPkeBxAIY1PvMfb51/xNgfm0tIHfAZyA==
X-Received: by 2002:a05:6358:8a6:b0:19f:4cd0:aad1 with SMTP id e5c5f4694b2df-19fb4eb049cmr1247885155d.2.1718690128089;
        Mon, 17 Jun 2024 22:55:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGmf7CqoB5qG+f+SoSDNog9sHPlb0eZ/k8nda7B9rivFb2/iFdvUu6nxAvxJ5wxsEEdjtvYqg==
X-Received: by 2002:a05:6358:8a6:b0:19f:4cd0:aad1 with SMTP id e5c5f4694b2df-19fb4eb049cmr1247882755d.2.1718690127611;
        Mon, 17 Jun 2024 22:55:27 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6fedf592f0csm7512541a12.54.2024.06.17.22.55.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jun 2024 22:55:27 -0700 (PDT)
Message-ID: <8fd7e58d-1d87-430d-a974-47ee05bc72de@redhat.com>
Date: Tue, 18 Jun 2024 13:55:22 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/2] KVM: arm64: Making BT Field in ID_AA64PFR1_EL1
 writable
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, James Morse
 <james.morse@arm.com>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>
References: <20240617075131.1006173-1-shahuang@redhat.com>
 <ZnB1FPw3Eg8-61mL@linux.dev>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <ZnB1FPw3Eg8-61mL@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Oliver,

On 6/18/24 01:40, Oliver Upton wrote:
> On Mon, Jun 17, 2024 at 03:51:29AM -0400, Shaoqin Huang wrote:
>> In this patch series, we try to make more register fields writable like
>> ID_AA64PFR1_EL1.BT since this can benifit the migration between some of the
>> machines which have different BT values.
>>
>> Changelog:
>> ----------
>> RFCv1 -> v1:
>>    * Fix the compilation error.
>>    * Delete the machine specific information and make the description more
>>      generable.
> 
> Can you please address Marc's feedback?
> 
> If we only make things writable a field at a time it's going to take
> forever to catch up w/ the architecture.
> 
> https://lore.kernel.org/kvmarm/86zfrpjkt6.wl-maz@kernel.org/

Ok. I will update the patch series again with tackling the full register.

Thanks,
Shaoqin

> 

-- 
Shaoqin



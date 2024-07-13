Return-Path: <kvm+bounces-21596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDFFF930419
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 08:20:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B61C1C22225
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 06:20:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 410471DFEA;
	Sat, 13 Jul 2024 06:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iKz36vE0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB971B960
	for <kvm@vger.kernel.org>; Sat, 13 Jul 2024 06:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720851606; cv=none; b=UiWqfwt8pJWHHvlgnuUd0WBKhpjJ6c+NwZ60hpRqBtXcOIH/e4A21hQohRej+FKhl0/rtCAWtnGMpLclRFpAu2794Xm054/9hdtDuGAW3dtIZ55wyIq6jhrfPPJo5tmHnaA5yfdIBnnB9sSEECcSDEJysnvvSYhCdz9emS3UA98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720851606; c=relaxed/simple;
	bh=okrl4WgmUPIOJBtqpb5AbjaOtQyQNQE2oG8Fhm5BE+A=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=qnenBzceiH9ORmcByPlhkPZXT0h39BdtDEU0QHmjsF6h9G+XToHCkdAKRFAthQLC9nQdMulmgB9my0NBduW1HJUwF2GauB9fcLTsPTW6Ouj2AgpN1DBGUCCfeYvURbIN77XUJAU/iM10K02X8s6UZH4rzeD+zwxY4aLR+0TcEMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iKz36vE0; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-52e9c6b5a62so2875885e87.0
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 23:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720851603; x=1721456403; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:reply-to
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3lV1qdhSigsYBVlEbZ3lJ64qYaWNwuyswUrONuumPRs=;
        b=iKz36vE0ibPHtuukdB4FGq3DAes/eH+XKzq0H9wlB20fGabfDu54NLhu/Q6ppt0iGU
         TRSXDnTeGPxmy/X8ozlR0Y3u4j4+gs0pBMoEhC+FdMyreWXzF340Z/y3A3uKCYvkahnK
         dYb/kQ9BNp6XArwXimGUt0OKtXwKMBH89AMUvhr9Ql0Ea0jC1Ko0zI0THHoWogXpRK/V
         XP/7LaNUiQnCRPMa8rEtWRdySdbOQ0tiCqMpSmol5B0Z1wDWMPV/b+tN/HsDegsvq2Vq
         1/V458oaD9pDgtf8KTYrYuZTtuw8AFG4DEBVwIR49cZ8Fn2tP8/iIxv/LWVAAXc35D/L
         aTpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720851603; x=1721456403;
        h=content-transfer-encoding:in-reply-to:organization:reply-to
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3lV1qdhSigsYBVlEbZ3lJ64qYaWNwuyswUrONuumPRs=;
        b=NCDTROnWOTATtQrlPNaJqibH4XWJwStV1Mz0e7mMxM1NIvc68J24UFduadTm7WKiop
         qkQPIP/SFgQaXuCbT1ajYt0XI7qf9ti/N4+o81QR51NtlGbyt7SvYCnxo8ht5kZoKGy9
         /AahJlOrZRdmGJ6CL72ZIs97eTYsEZDbTB8MDlhC4HeIWhw1Or3j5zyWMOjAYEXu//sn
         G2aABsSjT8suXqhelv7Y+QyDeULU+bxeelJ49KKcUEok2jxSZNzEumWK7EV1ypCCupfw
         +0eFaDdWdu3UcgeFwGO7l7pEHZNj3krOKi3HkOT1bkjuu16gNh5FipDA6RpI81fqWLqW
         qweA==
X-Forwarded-Encrypted: i=1; AJvYcCWYpPHX95XJJNmNcsqyKq22PQwK79r/qFUZPn+Zlo4zAaQREQCUuey/kHDTpnL18CqQq6B2swX911CHNueCfVGxjUb8
X-Gm-Message-State: AOJu0YypdTwV8y0JTomnJGg4R0xudJC6HuaSmIs4mL0h4zoA1vyM6j8E
	uk/eawA9zmwgoGJB6f7qwv2rihWzWivs7AAm9pDyg5WftjpLwQ5k
X-Google-Smtp-Source: AGHT+IEly0aDCMpmPVzaCRyArD7sIAxwXLI0PFeeWTZ46AhbJP6Fr/Zc09NQKjaFA6Z5HTjVxoQelA==
X-Received: by 2002:a05:6512:2254:b0:52b:8ef7:bf1f with SMTP id 2adb3069b0e04-52eb999a67cmr10047694e87.17.1720851602609;
        Fri, 12 Jul 2024 23:20:02 -0700 (PDT)
Received: from [172.16.6.209] (i68975BB6.versanet.de. [104.151.91.182])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a79bc5a3554sm22530866b.26.2024.07.12.23.20.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 23:20:02 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <a6f481d1-5618-42a3-938b-44668fa000ee@xen.org>
Date: Sat, 13 Jul 2024 08:19:59 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] KVM: Documentation: Document v2 of coalesced MMIO API
To: Ilias Stamatis <ilstam@amazon.com>, kvm@vger.kernel.org,
 pbonzini@redhat.com
Cc: pdurrant@amazon.co.uk, dwmw@amazon.co.uk, Laurent.Vivier@bull.net,
 ghaskins@novell.com, avi@redhat.com, mst@redhat.com,
 levinsasha928@gmail.com, peng.hao2@zte.com.cn, nh-open-source@amazon.com
References: <20240710085259.2125131-1-ilstam@amazon.com>
 <20240710085259.2125131-6-ilstam@amazon.com>
Content-Language: en-US
Reply-To: paul@xen.org
Organization: Xen Project
In-Reply-To: <20240710085259.2125131-6-ilstam@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/07/2024 10:52, Ilias Stamatis wrote:
> Document the KVM_CREATE_COALESCED_MMIO_BUFFER and
> KVM_REGISTER_COALESCED_MMIO2 ioctls.
> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
>   Documentation/virt/kvm/api.rst | 91 ++++++++++++++++++++++++++++++++++
>   1 file changed, 91 insertions(+)
> 

Reviewed-by: Paul Durrant <paul@xen.org>



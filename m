Return-Path: <kvm+bounces-40415-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 164A0A571CF
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 20:31:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 407D9173537
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 19:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A07B5256C9F;
	Fri,  7 Mar 2025 19:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LjUk1QmY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53289255237
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 19:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741375827; cv=none; b=VvylAcN3bg0gDqxSVo6bjEuqC/6woUneK8xupSmEI9KdLjCNPWkbS1hfv3iY6tYF8+D+2S9yXV3wC39xedwBuq+G8qay8AmJ/8wcnpI/a6z/UNjgDikVqN0ky2XW/ZhkOOPjpWcx1KMOSgF7PHeU4P0b3M8HIHH/gVh4F8Cfy/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741375827; c=relaxed/simple;
	bh=/F87dXjHLNZxLUUgpQX4rpHe+jK/SKYhQPYDC9GjLCA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hkDmvh4RkxAGdvhzoedIH2oWBFQ1Gu+u8DauruHZtdsGgtQpILvl/pr+SMhKqGB/dJhsn7WtbqJ4bIlfhkBW6peB1PeWYPoId9RLUVGDjzOeeambWmNNW0jllhvRf/rgFc0+K41jqW9jyBJJCC6fpNEtl5DCihkAaBhdzNQfrVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LjUk1QmY; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22185cddbffso64180665ad.1
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 11:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741375825; x=1741980625; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xElhw45GbX7eLdoo8Przx/SbLWCDujOnVVlvjv4plD0=;
        b=LjUk1QmYVtGD3u8Z5PhAw9pdmV7rJSjk3SgppSDVgbP/lwnxx8GG+jFgi10WZUrwmW
         uEEIST0DMxvXX8TUXDGuXdy25j8m3Fspy1GDPLzEQ/nPyjq8L8ReyWNgZLW6EDN2Hkd+
         qKNEOrZYiwtoyZYHhmpurlJhsyvWXmTJxfF9VI2LfHRURlA6S/ei37mNMAnlQo1Q5kxH
         q46+LlbTrw6LK3WSZ92yM+dd38FStm8Uja5JKLmBERaVFC9cxMOTOjUMGUMvgf0/1w6A
         rLv5o9eQvx6++PeytIXzmMGieG9x3jYdFua5uoFjQzEFlRfVcerEL73+EjknLr2PiGhA
         xmFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741375825; x=1741980625;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xElhw45GbX7eLdoo8Przx/SbLWCDujOnVVlvjv4plD0=;
        b=cGLq61aSsgXg6hCxSf2DnqaVMN6b8CvO+YbQaoFtybhgeRhifuyGn+XYmt1HbMjP46
         ixjumvjHOhMb+/98VWOZq0Y6qNYdJgqGaOE4UP9PJYTwRnJkXJPOvQ1Agu5oL3LYTFv7
         YoTCUSwQ9zXBXGvVQSRc48iL+DM7hkvRicgyJByAWDK8KX1MFfx5Kpendnd/7vTJmdSF
         B2HPxyrBf8tFyThvioLn5Kll4I4HoXgZAMun1phuLKB1/z1n69D4//g0iAyqhWEYHBGw
         EX03JqE7cTVV8aBoWIuetF1V4uN0DR1/KJsOVV3yDO4lyFac+0ylTRND9QlmgoLXg0wC
         t/hw==
X-Forwarded-Encrypted: i=1; AJvYcCWfy7nkPGVVkAhKxu34OD+c5vzkikG1leUOovaNXghutJZC6eKYhkXONCtVOHCfjQHderA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+BZAg2liH1tWdYEysqUQamweNffh8G4dei9sJ9SSLt/us5KwC
	NVb/ZUpnBu9bNCFjNVG0AWLyPiq57gZyJnZpglAX0zJDzqJs5MtQgYgmaEjoAx0=
X-Gm-Gg: ASbGncsJgTwNd20UHzBY+54gDT9d6gsD1kVbgAcZdn+aOCnJU1htCRDeuvxnI3kFkl6
	B5DEAARXFdx1xqA+6gIibz6tDwcS4ojQ4UEg1FM0soAXj+M9ZEf/yLBUNBEXCoz4YRPzqHF9iYH
	6p5/H6krFV9Qx8S0dW7Yr4rmzcrHKfFI84GLzp6TswRxJaDUaCkpTPa2/KRAP/d3oZ4l0PmusrQ
	08reWhdsnos437PLuH7HiPdQSP83D0DZazbDDKPh0ZfWOjADCkTlyipcEdg+WuEAGQINeA7Im7l
	omOYcZld5e0xoLpQFgluI+5k6y/9yvutgPmdBl3WFVM/kirhpRWWcJgPuqdi3f6tGltFTMO0JQf
	hhH8bz1ZS
X-Google-Smtp-Source: AGHT+IH34cHMri0ap2LTf0vgAy+xvbYhggfz1OEiGDcEZd4JnhR3v+7RXnGvt+W2M1TrCUezF6DPJw==
X-Received: by 2002:a05:6a00:6004:b0:732:706c:c4ff with SMTP id d2e1a72fcca58-736bc0a2082mr1060797b3a.7.1741375825618;
        Fri, 07 Mar 2025 11:30:25 -0800 (PST)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7369853880dsm3642855b3a.180.2025.03.07.11.30.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Mar 2025 11:30:25 -0800 (PST)
Message-ID: <cf4d692e-d6d8-4ed1-bf06-58b9c8a3c1ed@linaro.org>
Date: Fri, 7 Mar 2025 11:30:23 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/7] hw/hyperv/hyperv-proto: move SYNDBG definition
 from target/i386
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: philmd@linaro.org, "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 manos.pitsidianakis@linaro.org
References: <20250307191003.248950-1-pierrick.bouvier@linaro.org>
 <20250307191003.248950-5-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250307191003.248950-5-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/7/25 11:10, Pierrick Bouvier wrote:
> Allows them to be available for common compilation units.
> 
> Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/hw/hyperv/hyperv-proto.h | 12 ++++++++++++
>   target/i386/kvm/hyperv-proto.h   | 12 ------------
>   2 files changed, 12 insertions(+), 12 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~


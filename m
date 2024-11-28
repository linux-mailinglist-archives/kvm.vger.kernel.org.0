Return-Path: <kvm+bounces-32761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77CCD9DBB7B
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 17:46:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F04C916369F
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 16:46:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2CAC1C07C2;
	Thu, 28 Nov 2024 16:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ykJcfLtV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CAA19923C
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 16:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732812406; cv=none; b=sGGyQ4S51Ht41GjuheeiW+ZFQaIjhaofnMSvsvl3gG1s16g9mmaDptslEW9jX/aUcvr5lv00Mu0d4p/q+WzHJESWjE3Ynf26ire7mFnCJ69k+w7tO8Z3J/2pxqsrJ0zUIFa5GuWzElIjyXZ6l8GxwuzMP8hD067du6wBPJUDWAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732812406; c=relaxed/simple;
	bh=RXkW1eXCZoRuNy2mf+5XWhlYINLnNYmK3mLKXZvfaBA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dRfVg5lf33c5VyTmfhM+BW6L0j3agXgpLFt9oIPF9X+WKeVD2h4bnkuIDL99uHlgIfUm584gwUFW8npxMWAlXSjeN8qMAYYk+YVrBBHCKC2jhjTLkz7GHrviSIlHpMZOcVcTAw79IhsZ3uAF5SgFYV0rGmwbcL8vyfhx8J6ZcA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ykJcfLtV; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-382588b7a5cso736872f8f.3
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 08:46:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732812402; x=1733417202; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EwOKRV1c0unBwmZqya/i1H+QUXgqDtyYNKtve5ADmRI=;
        b=ykJcfLtVgjtzkQyxT68hRAg+ow5mkl3+7kiKo7iV+sV2KpbOQBVLkKyowihkku6wWu
         4dxIRdfRJiq0ufS7pGYNO72K2mtw3Fl6Lu2BhuFhLBb8Vp2Z8hp4zpG63ZOY5JWdup2N
         6bGIDTjtVlXNQKJvSSpBvkb6cgZ5Vyu16W6TVPrM2GmL8RaRF6SebjOZrGRKTe35GmX9
         ZWS7/cZaqqw+Nmw7tE5EAeS6lfXwz9VdgmOquLnU3RsbJuRxqIlczDQdMU/ahVwSTvMH
         RQQzyHwevtykBPYjTVz1OcpyhGabE/FyeP/nTNJtLXY0jNJ7UzZuRFdidDrxzHkTu6w/
         Ashw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732812402; x=1733417202;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EwOKRV1c0unBwmZqya/i1H+QUXgqDtyYNKtve5ADmRI=;
        b=trf6VMqrCqQ9CDR6rpb1mKvvXTUs3OlcCzvxMCvb8ZHcGzBrRw7W7fbguUaYg28lcU
         J78NcV82Vd4KKEzjWwlv8ePDiimEObDW/kz7iZ/ujVycVnPwBXFw5t2gv/bBqLm6Al4l
         03FYSR5/f/S4MJ1wcr9imuoCo7ZSUfsgPDsB+Vg1iKVq0KFU5grg5FVoKJZTUniebe2z
         Lr07Rq60Vpvd9zyjU4wdb7QMB35pbAaovZWaV/+D4BNc4C1Y29suF8EzOfpq4/+UrIh5
         ZQlcGed0dH9g2z42RsG6hlcJXPdB6T62dnYcn2/MltR3MSF8bWpS3nP82YoMDTKq13OV
         lnGg==
X-Forwarded-Encrypted: i=1; AJvYcCUwYX+xjmEHHG5O5/YSq+0Dv658HE2LSgDVa3tpXHRM9cYffHmNfnsGILBHfm9SGRIbtUM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSn4GHQj7VwIybUwmdbb3T4/CWpKAnyjflXMCvKyff42XPq3VW
	UjlQjOWFswIfLZCGYNK3Qw+XdrF0HqUzPuKXgkLb0hrmUweXoAUshaXd1+T8ZMo=
X-Gm-Gg: ASbGncsvOhU3eIUzy9+O2+SqOKQdkk/qH+dgnadXW++kSJZOyOC7XcxqIVCnoWGOqO/
	ZqKosfEUJxQxB/RwKfVaZvJCqXALqenkNlxc2FNdW4sMwujFlFaUWTS69JD6wQNidjEGTJs1xDB
	9mp2810+PiG2Y7t2TYulc7dje3pxt8g3LSQuT6lrgFC0yNszU8afVIQ7bW/cjk4cgptG3MiMCgv
	X89bgMNVUInmrMjLaeLxLoFJckMlFb33WxgUBmEN54FGAgvizF7OLGP0dvOCPyFoLATH6QRkseF
	pNwmAulNguA5ItP3iYso
X-Google-Smtp-Source: AGHT+IHQzULr5uvxakNF1ITghpVAkvYqmnyNnA2TLjE8aWFEUy8+tmGTkTj7tFxUquqyIBQi9rd5TQ==
X-Received: by 2002:a5d:6d08:0:b0:382:4b40:becc with SMTP id ffacd0b85a97d-385c6eb7f82mr6333988f8f.3.1732812402514;
        Thu, 28 Nov 2024 08:46:42 -0800 (PST)
Received: from [192.168.1.74] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-385ccd2e940sm2041864f8f.15.2024.11.28.08.46.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Nov 2024 08:46:41 -0800 (PST)
Message-ID: <e9404dd2-56d2-4c6d-81f2-76060c4b4067@linaro.org>
Date: Thu, 28 Nov 2024 17:46:41 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] i386/kvm: Fix kvm_enable_x2apic link error in non-KVM
 builds
To: Phil Dennis-Jordan <lists@philjordan.eu>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: "Shukla, Santosh" <santosh.shukla@amd.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, mtosatti@redhat.com, suravee.suthikulpanit@amd.com
References: <20241113144923.41225-1-phil@philjordan.eu>
 <b772f6e7-e506-4f87-98d1-5cbe59402b2b@redhat.com>
 <ed2246ca-3ede-918c-d18d-f47cf8758d8c@amd.com>
 <CABgObfYhQDmjh4MJOaqeAv0=cFUR=iaoLeSoGYh9iMnjDKM2aA@mail.gmail.com>
 <CAGCz3vtTgo6YdgBxO+5b-W04m3k1WhdiaqH1_ojgj_ywjZmV7A@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <CAGCz3vtTgo6YdgBxO+5b-W04m3k1WhdiaqH1_ojgj_ywjZmV7A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28/11/24 17:38, Phil Dennis-Jordan wrote:
> Paolo, could we please apply either Sairaj and Santosh's fix at
> https://patchew.org/QEMU/20241114114509.15350-1-sarunkod@amd.com/ 
> <https://patchew.org/QEMU/20241114114509.15350-1-sarunkod@amd.com/>
> or mine to fix this link error? As neither patch has so far been merged, 
> 9.2.0-rc2 still fails to build on macOS, at least on my local systems. 
> I'm not sure why CI builds aren't jumping up and down about this, but 
> neither the Xcode 15.2 nor 16.1 toolchains are happy on macOS 14.7/arm64.

Just curious, is your build configured with --enable-hvf --enable-tcg?




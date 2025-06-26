Return-Path: <kvm+bounces-50807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 35306AE96FD
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 09:41:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6576E179161
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 07:41:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD249243946;
	Thu, 26 Jun 2025 07:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="KQK1Ap9a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A8723BCEE
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 07:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750923656; cv=none; b=qExaKXeOxMqsMIp8+diQ14+7Op5/3C5+PeovRDRzAyAh/FlwVoYegea13q6zYy1CAkb/fdyVcMXzfK4AHexVbUSx7Sw2Vtf2L+Qmv/axc3VtfT0XoRDLt1+xSlv6OetbwbIOvuekMmAVYnslkWQhumNqa7TrYaxjLAiOx/RPWRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750923656; c=relaxed/simple;
	bh=JBElSZFFS+TgZq2EE7QPWtr+DJP4QLhhEpMEba0lDBg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XZhxyUU0orv0h6RIpXJIVgS6dvkWcQ5TSgcEnM3mABSXUEOIfPnDpSONRNcueroTl/F00WLn+g2OP3S5hNIP3wL2hXeOH2ATbb4JVR4XIuwZi46I3V/HoO8OGXAUFvcQkU5Y4AvZe4CPq0g8r3FsIA5wP3cVqOnjlGuf4hJ/sDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=KQK1Ap9a; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3a50956e5d3so507782f8f.1
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 00:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1750923653; x=1751528453; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=JBElSZFFS+TgZq2EE7QPWtr+DJP4QLhhEpMEba0lDBg=;
        b=KQK1Ap9ajyTAfQvyqkaoVV5jrKLKaPXE1/7Pfi+kJsLFMZiziGZSCgoDh+CUpiLoE1
         kHpUrdBL8AXKRBKE3u6T4cBU9J8RAnh4Ost1MG56CU22nyg6+wwuAymOHJH9/y+p/IAp
         FacJrVPEj+9fDuUdpS9I2KGUczME6RcD9JbQkWbudSjei1IbjOSZ0i956D5CzwtvqeVT
         504hHX+d9jcQgg9mmaSnD37I7Ve90DwVcIlKu/XwwdXGXuZf2kfCXiP6dUbe24ZDpSrB
         1aYXvmYJl0DJLj+EpmTQjirJ2e7M0reRA+4oQbjhJ+lGHoJmNEAZw5N0MzTDjEEhRa4o
         D74w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750923653; x=1751528453;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JBElSZFFS+TgZq2EE7QPWtr+DJP4QLhhEpMEba0lDBg=;
        b=PrBadnceV22mLNHhRgAcXzrxwewwDlbduV7vwh1jsPG5kk6nK/Hw9hYDCCSne3/zGc
         DGQmbwG+DHzIjx1IwYp6gdA8/LhYEunmnyuL+xjQmXv0EyawhaUkfFixA/Yo8ik5vmPG
         +qSVmW4R8qIg4I3oZrW0f0RP+KF8BagH/2U/7+XhG0R8sxlv5RkD6cNJXZALkMoJ8Zv7
         LRIWyelz6mhcQwRGm+J6sTnQnjJ3GJudpDGRjunGoZ0oL3PT6thj8NOOKrNufRaABACx
         ScuAKG5WfAnoPR2vjE+iRrLh+gWJDcpTOfk1UrN/nt4WQ8yQXQECZtAiAuilRLNltJea
         GpbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBC2Tu7sAdd+S1vYX860BxfX4jDrjNWBK0cIVHL2CSc2t37Oxh/He9r9LPNO6ubb/t/lw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx23JUBXX7PN3K5JQbcdHegfcvv3oI84IFNRzlbQGv/XGLBWS7D
	QpIatmMEd9efduJPyuV9M2Jdso8ek+N2KHJgM8T11j2cnJejJFQyPSIRFOLfF5kF/lY=
X-Gm-Gg: ASbGncs0RqBKyGO92nVxeb5e1lBjRi5akVbqaYJDNeh1XkSRgVYt2nEScqLRNtARsND
	JFUOI5lsu4ta6GA9PZ4rmw3RSpPIrluE7RDjRys7o+SVQuP5xf63vI71AxtJSPfjiLl2BDiQHxY
	UWG6cYzxVeah8ubOHyzfmztMn/SejJYs9XW/W+KTZKHsWwSkcnzorly9tpl0LoZhyWWTmyYw+8/
	NVnzk2QF/w3n7vDh/9HF3Xv9vqmcdEmIpnvzBclXCmB16xXWU6S9kFEcMVLIFiJAQ/6jS/v1MK8
	NBHbBNd6kVYp18FlOhWnJy1ZFzYXqQDTWRubI6RnVq7jyWeq0imnwOMFfQDVQpOKx+trpK7HqSF
	Iny8h1QhdKbzkecILKCrKduFABeEY3ok6msOHdQ==
X-Google-Smtp-Source: AGHT+IEeYBdQbEUKPFxwdB/1N4Qy+osWIPj7BOey3vbChl9yUWirYssw9JxIFJ3CQIGcWecWDAN08g==
X-Received: by 2002:a05:6000:22c8:b0:3a4:e4ee:4c7b with SMTP id ffacd0b85a97d-3a6ed5dbb24mr4859748f8f.15.1750923652724;
        Thu, 26 Jun 2025 00:40:52 -0700 (PDT)
Received: from [192.168.24.113] (pd9ed7163.dip0.t-ipconnect.de. [217.237.113.99])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e80f2b8fsm6646712f8f.59.2025.06.26.00.40.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jun 2025 00:40:52 -0700 (PDT)
Message-ID: <9bc8e86a-8fdc-4d3d-9435-e6508c4c1791@grsecurity.net>
Date: Thu, 26 Jun 2025 09:40:51 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v1 0/8] Improve CET tests
To: Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, seanjc@google.com
References: <20250513072250.568180-1-chao.gao@intel.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <20250513072250.568180-1-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 13.05.25 09:22, Chao Gao wrote:
> [...]

I just send a v2 merging this series with mine[1] as:

https://lore.kernel.org/kvm/20250626073459.12990-1-minipli@grsecurity.net/

Thanks,
Mathias

[1]
https://lore.kernel.org/kvm/20250620153912.214600-1-minipli@grsecurity.net/


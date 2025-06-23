Return-Path: <kvm+bounces-50309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77016AE3F8B
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:19:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C9F9178927
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:14:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E7CA254876;
	Mon, 23 Jun 2025 12:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="m+3oR+8q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871C52472A8
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750680341; cv=none; b=B+tTdroO0EtpmtvJ1g2kjj4ygetpIf3tPaLBADrPtYUnqu2waYxHDqMgTm/gNMPxlw9Ms+67o1UkwaEsBC/IU4Fjan40agIQJKy6VIru3FqvZgrf3UT2n5WuWDKVz2iTInZiodnV9vXcDAzl1y2GYw54DjoLtGdlTBUrk2gl0/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750680341; c=relaxed/simple;
	bh=GNPxrNarvw+iC5YxyWLe5oYMRHmj+LvJPwHfYQaeFFw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=UF8R8o2GT8AkcNDVrwFGldkMbbFMR3lZ4KTfYzmUrnSCA/vj39QkXKmqz1V3lrmB7Z6yjsl7gOLGlVcTEA6b7l5XE7hApiVvhxcoPW0Ig93X8Qr6xVUs/4RLG3wsbyJ+y1ZpJmLDg6GsP3ZxKoGuXmhb0EWEBbjUlTXXZ2VOjTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=m+3oR+8q; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3a4f72cba73so3333188f8f.1
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750680337; x=1751285137; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LhVmC7Ptr86082iSVP3tCUv3mxHNuSnJ7XLqXn+lKmI=;
        b=m+3oR+8qeaLpfRt9l8TVsy/wdE+ju/bHRxKghxJr7N5iBOAIRx9tWchwvvkkm1MTVn
         f6pp6p/HxIIjCn206G5j4m+Kz0V/oeznEN9LK10bEQEkjLc1jlrO6FxuFrhdaNN9KaXg
         v+sqrmxjxxGyKqwXgXgDFpqZQiLLQCv6xsahcjdGvRC4Hj2EhMctJs6kGcqS43WMzlSc
         NXX5BA+ZV/T9WPcsn0C0EKqZ54AgV08XpP2y7pbEY411C0Ti/OmPphPmc0Sc2emY0BxC
         xRj5x18zUhJK0A5AYwNjC5ICoTplBh0PhLrzzxgHEUT6W0YucLJJ0UaA/oUKFaLqPS53
         aMwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750680337; x=1751285137;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LhVmC7Ptr86082iSVP3tCUv3mxHNuSnJ7XLqXn+lKmI=;
        b=E4RCrHwFEVF9cmgNC4oZ0gunWZjK9yphRy8tAqWnFiNJ6ATJpSvyBinHOW8IfMFku+
         VxdxcjLpTEGHbjr0j4WVkq4yiff8S9NuuR+xUC2rp9gcQAXM7SL/lSCXCY6kKGXIBas6
         AlnB5roRVcKjxUO/xmeWOq3Z/swDnWQfOGNsTrPCpMIdf19vDtUuDtmQcG6O8yY1MmnK
         44gvqd0AMXZB2zLwy1KAjiqHHfcl5pFVRrPQ5ed+L4CpcmqOjap+Tvb/DXBQba72MAKs
         sd7UmMOycOwMqa/HfCDo15d3uYkpI6nOlabj7TgUWWhd0S/feNMoYj7s9h50EwLgaxob
         d1qQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRHLLkMiKRV6oFIQjkug7kPDJv00cSjvLv0FZsrgyTZWxzp3/cgkmAg2u2HX8aTeumW8c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpiP5ScYwNVuivRUjxtlrOtM7o1F5BYiP1oLCXpix4cdwR/8VC
	YAMQlRZLqu80lsM32xk+eu7DsfiR5enmoBkZm8oXowg0dHOn2GD42LbjWZxMfZQP9vQ=
X-Gm-Gg: ASbGnctNO/aLcavdbT6DtlP80J49BepE+JC2NqgGr4dGiGMuJgqHPzMruthOU5mK64P
	nGolP6RsWirCvIZJXF9gXx/KNFT8ch6u6xZ+x4shI6gyLm/yfJF5cQkVNGTr7Y3GjAbp5B1iBDC
	a8aqTdt+QSciCrEbubb/BsllnaJDJLVgItXJWS98rPlDSXI2gxBYw6vsA88A/sQtodAo3AdUU+i
	vyVO3obHV/PpAvPtZ0zV9NHfydofTU56wfqUlsuXN+zdr3eNYn4FR1VB7AVUvUoAAKEdzoFKncA
	H627X+Efu7+MxrlHli/3q3IJWipYEumkYN2RPFHRaARekI5vkeKLB3OMHD36lQprGMJhVIPqB5v
	fmMwhkXvn8curErILy93VgjlAQ6Yw/g==
X-Google-Smtp-Source: AGHT+IFqbtwF21H6pWk34kjB74g+vaQ792b2mQtfrzzfV/L7m1oPbaWH1vPXMofzQKaBoxU+8UO20g==
X-Received: by 2002:a5d:5f93:0:b0:3a4:e238:6496 with SMTP id ffacd0b85a97d-3a6d27e17c2mr9044838f8f.18.1750680336753;
        Mon, 23 Jun 2025 05:05:36 -0700 (PDT)
Received: from [192.168.69.167] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4535e97a908sm142235035e9.4.2025.06.23.05.05.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 05:05:36 -0700 (PDT)
Message-ID: <424c91ee-f5cb-40a1-b1bd-3f0648ae83f5@linaro.org>
Date: Mon, 23 Jun 2025 14:05:35 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 23/26] tests/functional: Restrict nexted Aarch64 Xen
 test to TCG
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org,
 "open list:X86 Xen CPUs" <xen-devel@lists.xenproject.org>,
 David Woodhouse <dwmw2@infradead.org>
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Radoslaw Biernacki <rad@semihalf.com>, Alexander Graf <agraf@csgraf.de>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Bernhard Beschow <shentey@gmail.com>,
 Cleber Rosa <crosa@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, kvm@vger.kernel.org,
 qemu-arm@nongnu.org, Eric Auger <eric.auger@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, John Snow <jsnow@redhat.com>
References: <20250620130709.31073-1-philmd@linaro.org>
 <20250620130709.31073-24-philmd@linaro.org>
 <497fc7b1-dfd2-49ad-938c-47fca1153590@redhat.com>
 <be71c7cc-a5ba-4ba5-b697-60814b712eea@linaro.org>
Content-Language: en-US
In-Reply-To: <be71c7cc-a5ba-4ba5-b697-60814b712eea@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 23/6/25 13:59, Philippe Mathieu-Daudé wrote:
> On 23/6/25 10:11, Thomas Huth wrote:
>> On 20/06/2025 15.07, Philippe Mathieu-Daudé wrote:
>>> On macOS this test fails:
>>>
>>>    qemu-system-aarch64: mach-virt: HVF does not support providing 
>>> Virtualization extensions to the guest CPU
>>>
>>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>>> ---
>>>   tests/functional/test_aarch64_xen.py | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/tests/functional/test_aarch64_xen.py b/tests/functional/ 
>>> test_aarch64_xen.py
>>> index 339904221b0..261d796540d 100755
>>> --- a/tests/functional/test_aarch64_xen.py
>>> +++ b/tests/functional/test_aarch64_xen.py
>>> @@ -33,6 +33,7 @@ def launch_xen(self, xen_path):
>>>           """
>>>           Launch Xen with a dom0 guest kernel
>>>           """
>>> +        self.require_accelerator("tcg") # virtualization=on
>>
>> What about kvm (or xen) as accelerator? Would that work?
> 
> IIUC this tests boots a nested Xen guest running at Aarch64 EL2,
> and at this point we can only run EL2/EL3 on TCG. HVF and KVM
> can not for now (we are working on it).

I'll update the description with:

   Currently QEMU only support accelerating EL0 and EL1, so features
   requiring EL2 (like virtualization) or EL3 must be emulated with TCG.

> I don't know if Xen can accelerate EL2, it would need support for
> such hardware (like the Apple Silicon M4). Cc'ing Xen folks to
> figure it out.



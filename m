Return-Path: <kvm+bounces-51261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A179AF0C0E
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 08:56:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B504D4A747F
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 06:56:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB33F224244;
	Wed,  2 Jul 2025 06:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="B6NMesQ4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BFC1D7E41
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 06:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751439362; cv=none; b=IonVggLohwgJ8hgg07nFO7Fz1I9kFuzQwUuHcvu6cQnG3Io1DOcn6dldEkO+Tzu7L5MZZUcR8nmJ7i9089LM9/gcH63knJd4R+ZjUPmNIV3UR0unz2m0ehbY2x/ZweSXQTAJLF6axiLVndmbofmVoSakU+jxrAOknH1GdbUkNyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751439362; c=relaxed/simple;
	bh=mntT1NeObFda1Yf4IGmudWOobC2HCGgfbsiFYCuLm80=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jPRKpvp/iVWQ5f839/HgJ35aDWZth7Z+mNGSFHSMzI9xJbCJRVth2Zc67rW9DkI6sopxhQGD8Q4HijwiSRroF6vOvJDWIUjGClONf1xdiDwkalFFolRLrYXH047Q96z7hExFWOE3yU+pfjH0zU6kFyxaupZ4hXNEfGLWx0Kon48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=B6NMesQ4; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-453647147c6so68781525e9.2
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 23:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751439359; x=1752044159; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pgu7VqDBRCkgwsJtMNJzkITzgF5YINgQ+CFLRGvMbOM=;
        b=B6NMesQ4ZCVxb+EJnHpJDo6xq0tnr7kk1nTgVsUR1o1dDbFq/LLdHA3r91x0PXOgLJ
         dHFqD6gv/wN97EPGM4cn1RpXAIogogsDB+XRHyJ/M1xrFmyVb9CE71S4BCnWPH8+Ctx8
         KKeC2iHwwflIGvdRc4P/96+ByKdazim9taSVDTUb7MP71ZXWC7yAogdDSreHfX6DerKu
         n7SN5n7Hhj6+O9r8YtNiITm+XJ5zw0BEYJbDZZdsJIhGZVpYa1JPfxpWLSvfioPeC/t8
         WK3kqht42EaTcGwAjlk7ONSv4IXlMehQwFRkXo+dajaUn6yZBo8tKrOFwfhOCTH4nCSm
         bNmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751439359; x=1752044159;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pgu7VqDBRCkgwsJtMNJzkITzgF5YINgQ+CFLRGvMbOM=;
        b=C25nRsYoy2AQ2T0r2DKPRwEBX2GAxhKyA5bX+eLNzOnYTKPTot+w8p1xETVzQfw7B/
         wecmkq6SFXNSJidixhJmoJn204hw+JH3dcm9Q45f2ySwfvaV2TYayL98hTMhQg/BVqtv
         nJcUMos+AVbez0E4s6kjqdblYiX6LIoQEzI5cMJakw+SiY8cNDWL0x+rtP5VM5DHLs0/
         n7T+dZlYk3crrG5W1ylkARzeaoXzpBZbizFAA9Rwbh0a+EBRBu/Dzq1Gc7rtbeTiMFhw
         MbWdxuVpZckoBkXWdyrKISZfNbawzQ0hlTaAr/J/3Wh84iouyponVPX5XVEfBsjXUJjq
         vMeA==
X-Forwarded-Encrypted: i=1; AJvYcCXdgxZTTKgEPYvxUYbKozhRrjKnxSN38WLVHoEKMvBPynyCGEJgeVOaeX269HCy/KvwZVc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwK2uIJq0VxzIvgLCQRrDf1q7swcULKCZxXHqS0B5QQKY3aLH7A
	/RyY7T/UDcwSHuMCBAASANu3uiksdpaZxnFNVEJse+RyMuLkYimUZmi7//JX/zswTaraxUx9fAk
	SYjQY
X-Gm-Gg: ASbGncsuzdubu7fRTX4UxRcZIJHsj/McQqmk/28dZWwhIDMpvxIn4s7WFq0K9LkI5qC
	5CFgdxd9er4Uc5A/fhbEpqcU2f7v4k4TePMf0NGhu0vVRb1ic/o/ixqslRQBRbZZhe4v3A5tWKQ
	mdT7g59EqCIRcx9KYVisVJK3hWML7nD1HwPkrzZPy6w68YuIG9ApPTAXHTKZDPwf1byUDgnKLfB
	FQYIcyQCqLWeW2wi6BLpcxiXQKNYkC6W0+uhfxL8w4tlJovUYWGKXf+SAO+tTXmsD5X6O9gQq/e
	ijEXP8zZ/c2JbZRvk4E2AjSmTDJQmYarlqE3SVZggvurjOZHVOaL1Z5pqN3DtZC0WcgU6Y7SW48
	ENBawQAFxewCb2+baycEDvGTyq1Z3sA==
X-Google-Smtp-Source: AGHT+IGtneCTq5/X1I2atVKDD+cfUWATiSPDzKx6KyMF+bybGxmJ4h86Dg7ULvaeEPLiJq6dMXcJIA==
X-Received: by 2002:a05:600c:8b22:b0:453:8bc7:5cbb with SMTP id 5b1f17b1804b1-454a3726347mr14856515e9.25.1751439359173;
        Tue, 01 Jul 2025 23:55:59 -0700 (PDT)
Received: from [192.168.69.166] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a88c7e7814sm14978548f8f.8.2025.07.01.23.55.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jul 2025 23:55:58 -0700 (PDT)
Message-ID: <83d7c55b-fa17-413d-8896-171d9538693d@linaro.org>
Date: Wed, 2 Jul 2025 08:55:49 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] accel/kvm: Adjust the note about the minimum required
 kernel version
To: Zhao Liu <zhao1.liu@intel.com>, Thomas Huth <thuth@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, qemu-stable@nongnu.org, qemu-trivial@nongnu.org
References: <20250702060319.13091-1-thuth@redhat.com>
 <aGTU2enBBQj7lu3E@intel.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <aGTU2enBBQj7lu3E@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/7/25 08:42, Zhao Liu wrote:
> On Wed, Jul 02, 2025 at 08:03:19AM +0200, Thomas Huth wrote:
>> Date: Wed,  2 Jul 2025 08:03:19 +0200
>> From: Thomas Huth <thuth@redhat.com>
>> Subject: [PATCH] accel/kvm: Adjust the note about the minimum required
>>   kernel version
>>
>> From: Thomas Huth <thuth@redhat.com>
>>
>> Since commit 126e7f78036 ("kvm: require KVM_CAP_IOEVENTFD and
>> KVM_CAP_IOEVENTFD_ANY_LENGTH") we require at least kernel 4.4 to
>> be able to use KVM. Adjust the upgrade_note accordingly.
>> While we're at it, remove the text about kvm-kmod and the
>> SourceForge URL since this is not actively maintained anymore.
>>
>> Fixes: 126e7f78036 ("kvm: require KVM_CAP_IOEVENTFD and KVM_CAP_IOEVENTFD_ANY_LENGTH")
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>   accel/kvm/kvm-all.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> I just mentioned the kernel version in another patch thread. I found
> x86 doc said it requires v4.5 or newer ("OS requirements" section in
> docs/system/target-i386.rst).
> 
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index d095d1b98f8..e3302b087f4 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -2571,8 +2571,7 @@ static int kvm_init(MachineState *ms)
>>   {
>>       MachineClass *mc = MACHINE_GET_CLASS(ms);
>>       static const char upgrade_note[] =
>> -        "Please upgrade to at least kernel 2.6.29 or recent kvm-kmod\n"
>> -        "(see http://sourceforge.net/projects/kvm).\n";
>> +        "Please upgrade to at least kernel 4.4.\n";

Using 4.4 or 4.5:

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

>>       const struct {
>>           const char *name;
>>           int num;
>> -- 
>> 2.50.0
>>
>>
> 



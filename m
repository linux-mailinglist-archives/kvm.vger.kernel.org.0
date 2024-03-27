Return-Path: <kvm+bounces-12782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C677788DA57
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 10:34:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 678621F28399
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 09:34:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0A0728DD5;
	Wed, 27 Mar 2024 09:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dGc9MmD4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB86125C9
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 09:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711532039; cv=none; b=BK/TTUCw6nUmp+QWZItw8JHLRP/VNNW56GYqbc6nEx/qY6eCPveDW/Gpsq4DabXDPU5oqguDyBxPbqrUpfvE24vDlF1VSwEXiG7I6eqkEnAtNqKZBwvLdNTeCm4icPGJ5B9AIsDAiuNoDFWkLI5UlI0i8SvaGUDKvJHmFIpC+To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711532039; c=relaxed/simple;
	bh=oW1ZsrkrZ41IQroh7Deabzx+stE1ZYa5g4CkQISqf2k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iVneFjlOM2ajbQNnFFyZygqidDkt/QY19JkTCMCD7WFu+cvXqTZgHTsCoQeDbWqUy+yxFWgfGpl9T8xmkvSmDSGagtm7Uoi74+wxJQIrBkwD89KxlTf3UlbLtZA9ZpHVqDgMoNYp2m4/jqV6t9BfNE0dghu1LjcgVRFeCJGCQ6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dGc9MmD4; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-341730bfc46so4649886f8f.3
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 02:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711532036; x=1712136836; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NJwhS6jGKEn/GCXsDKej/3MhG1neBdHS5aceARZ7xSk=;
        b=dGc9MmD4zOiQDC7R/kvtAe+7dTtL1xYAVal/2snwSi1CwsZPzdl01sR4jE5ykyehsc
         +/WnkpCEASQj5gdT5nipLoxJ5TBqJurnNeHDzzaJ1Pm1+bz2fJVnT3ayd8xvaf+9NgTN
         Bo00AaKBAeyGUSwq+80flw9wkQxAh1Zmn62vLn4qoQUafIAjVLFGNnHUkN99DfLQq8Lg
         f8RAyqC0RJSGdf4kBv+I7b4Qko9PwF/R59q+//W6wWvTGBMzHyITbUyE/CW8zKqeMUMR
         ZaNVC1/PJ8VKAmFRBxehLtN1qmnR9ZsbRaV55JKrHH9FTBzMxEqbKkliEjsODUrHFz/U
         91/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711532036; x=1712136836;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NJwhS6jGKEn/GCXsDKej/3MhG1neBdHS5aceARZ7xSk=;
        b=utbfW0yqPmSx7iMvsg2s9U45C5iCpMtbzWPYXxnjLdAWRXzIwP1LBoJ5JmbNIiTrbK
         06ae6k7LDAUz8ltC8Wkc5zwLSbWJpRMF5IcLC1iwPdUt09+S2BRzZyJsX/cpkdVMbTTF
         YB/Jtktj7x++yvGPGwNjA2beG6sT923pypPMaOD/ZM/tZy8va9bU6hncL2MEs6e1x2vA
         KkGfKrSRY5LaV2E7U2psUaOZ417EFlNZpYdrDgJNkqeAkVxGgFfAs72ChtSLvLRg8rpz
         6eNCp5HvrnNZOuHlvOaPeIz5lGbl5rAE0ucGW+qoovkwDc9K9clKNGnr3KPsI3GInQEO
         W+3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVLZfk4FbB8FHmbz1axqrvS+X/smwjM9hVV84J8scGalE4aWPd6/hrOi9WkCIe6GkF4dq9zVaDfIdohPixAeVPTGh7T
X-Gm-Message-State: AOJu0Yy5b5HvPgzv7tZRT8q+FiGSwireNDDfTVtNBfelBBOilKibBHV9
	5s/d1frqUkVt+rMR4yb5K86t0VD/MCt8QdrXK9nw9jUEbImjrkkDMISRrJSCXMg=
X-Google-Smtp-Source: AGHT+IEhqTZFkGrqwJ9Zl2njJHNGYCGSU3YWNDiNyGdhK9icUq5XRuYsRKy5ohDmFcimsxaVgQzScQ==
X-Received: by 2002:a05:6000:1808:b0:33e:c6c7:287e with SMTP id m8-20020a056000180800b0033ec6c7287emr3615873wrh.69.1711532035771;
        Wed, 27 Mar 2024 02:33:55 -0700 (PDT)
Received: from [192.168.69.100] ([176.187.205.175])
        by smtp.gmail.com with ESMTPSA id bs24-20020a056000071800b00341de001396sm1834750wrb.110.2024.03.27.02.33.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Mar 2024 02:33:55 -0700 (PDT)
Message-ID: <18039e1c-123c-45a9-bf84-17dac55d46a0@linaro.org>
Date: Wed, 27 Mar 2024 10:33:53 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.1 17/18] target/i386: Remove
 X86CPU::kvm_no_smi_migration field
To: Thomas Huth <thuth@redhat.com>, qemu-devel@nongnu.org
Cc: Igor Mammedov <imammedo@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, kvm@vger.kernel.org,
 Marcelo Tosatti <mtosatti@redhat.com>, devel@lists.libvirt.org,
 David Hildenbrand <david@redhat.com>, Ani Sinha <anisinha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>
References: <20240305134221.30924-1-philmd@linaro.org>
 <20240305134221.30924-18-philmd@linaro.org>
 <c66d3c14-962d-439d-bc33-6d52d0f776be@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <c66d3c14-962d-439d-bc33-6d52d0f776be@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/3/24 19:30, Thomas Huth wrote:
> On 05/03/2024 14.42, Philippe Mathieu-Daudé wrote:
>> X86CPU::kvm_no_smi_migration was only used by the
>> pc-i440fx-2.3 machine, which got removed. Remove it
>> and simplify kvm_put_vcpu_events().
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   target/i386/cpu.h     | 3 ---
>>   target/i386/cpu.c     | 2 --
>>   target/i386/kvm/kvm.c | 6 ------
>>   3 files changed, 11 deletions(-)


>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>> index 42970ab046..571cbbf1fc 100644
>> --- a/target/i386/kvm/kvm.c
>> +++ b/target/i386/kvm/kvm.c
>> @@ -4344,12 +4344,6 @@ static int kvm_put_vcpu_events(X86CPU *cpu, int 
>> level)
>>               events.smi.pending = 0;
>>               events.smi.latched_init = 0;
>>           }
>> -        /* Stop SMI delivery on old machine types to avoid a reboot
>> -         * on an inward migration of an old VM.
>> -         */
>> -        if (!cpu->kvm_no_smi_migration) {
>> -            events.flags |= KVM_VCPUEVENT_VALID_SMM;
>> -        }
> 
> Shouldn't it be the other way round, i.e. that the flag is now always set?

Oops you are right, good catch!

> 
> pc_compat_2_3[] had:
> 
>      { TYPE_X86_CPU, "kvm-no-smi-migration", "on" },
> 
> ... so I think kvm_no_smi_migration was set to true for the old machines?
> 
>   Thomas
> 



Return-Path: <kvm+bounces-34065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BA34E9F6AD7
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 17:16:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A161818976D6
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 16:16:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F4FA1B423D;
	Wed, 18 Dec 2024 16:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RJnYUrqU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617174690
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 16:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734538592; cv=none; b=VS0pLm84qBr3rBggRFsnFQgfM+FMoxT48wyFKnY0PFxtudoSfIANk1lAnL2ckOOJwngwpu4TTfqPvDXC7sVed9iS6VCqif7N1q8BERDRMRW50DvCdPQbFSdlgE7A80egb2ulYfudtrSAatAe5iIztVYD+hRxS5PlT+P05oQqYRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734538592; c=relaxed/simple;
	bh=8rYrXyYgQXw8tOo1dAScQZ+VsC6Rhj8S+6SbPdWdtdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DeuWjuHiti7InkPnv9DUduGBwtlM242HmPq/NJMOvTpHXF+94difQroS+Z/dVtd36p8kki1tQbplW+4gkdB0vgvwl3esElcTlNV7D3jareHhiJkqowxSdREaHmWFmbWU8rQHV3PcmeKCX1MP6cJare6rKcp/hKgXHyWbfgeUtoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RJnYUrqU; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-434e3953b65so47353665e9.1
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 08:16:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734538588; x=1735143388; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LgKPhFrfn+FSpszjwReu0WlKGkAYalZZQp3pOzgu1Nw=;
        b=RJnYUrqUiiqw80+DDjSqo+6BOw5G3geMRupQNF1cjNcQyFPpPb+M7P8HEBJWpd0mhC
         QBrk5ACBeRqZW3sfHmgJF0WPNcuKTRQjqgw3LQHwGQ0EQCxxjO8a34kfZtZgog1yBacv
         PQ1qeYNfPo8tWxkZiUNIp8bxYmuGnN1pnSbWyiiHc5vFayu0sWShRVCwMz/yvMrqkbX/
         XQIoOO7C+BHb0irwreHNLXuCmP7An0bNl10w3ozWxkkkqHcpRRx0TK7bNv6PdRVWpgNP
         oXRJjjg6rT6VsfdHxtAAuzIC3UyaYxoFMk1FlccV3kggau/fAz1PiNOuyQXSUseiDPXn
         mcaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734538588; x=1735143388;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LgKPhFrfn+FSpszjwReu0WlKGkAYalZZQp3pOzgu1Nw=;
        b=NSGV7RHEJKSOKw/9m6zZNXB0Kkwkm0Snky/lpaG0rNshYesAKc7J96gaaE/yOflF97
         8R5Z8UMloRZx6TZyTPreJ0a0AEt8enkO0cbUfEOgDx4MuxApWkpx8X89vr2RrEO7UkgT
         tGGYVoUZhnv2EmjuhDe86Sqec1eEi2C8DgFWAQdSR8Y/OY2mUnsWcCfpICzuc59ovXj/
         k6OOMuJF+t4MNg8gSVt7mQVVupiHhnuvQAa0kF1CX2xespAL2gJpVxhgQhfCLMhrObFa
         y+1Wean4neWyWmeiBheNEs9U0PNY89vb3gqmt2rFfzBitVJ0ZfKOo6fbEy35YCdF1KNK
         OXVw==
X-Forwarded-Encrypted: i=1; AJvYcCUReGoT4KzMtwtlnmCJIMcthJJD9yQMRmD4uJ+n1NmWHusRxpdjLHLtFGjfrtQ1bk8/Lv4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw21+dM0tTX2YcIJCA7qTeOXv7W4fUytpGowT0yuqZrMsc/pM70
	EQ3/+9G+ad25WQF9UwWCwGDgvuwYCfnyZh46feXRVailxMyYPttuFNukShiF0oE=
X-Gm-Gg: ASbGncso664Er9Iwu1xPcNHwBmQnrDNLYpEz6/0HwEzS2v+CL9PZc40BDYM/e8YQMx4
	osazDrmrGHSEmJZqADWHRYwiR55WmE/Kpy6nAPqHMY11WHn/l5egh8pn3rq/Bzp5pXJ6SVq7SwC
	bWr243atm2H2/VLXH7Z2oQmMesGBzWwGXrFRCUmXPSlAgI6CmcsEIpoH7dpIjjY7auD/3FDEJke
	tjvnh2aAOFDqZwsx3HwpnnVmk+GqlCXc3vqYCn026gR33gPYoah0dqjlr7IrTmMLTt5LWME
X-Google-Smtp-Source: AGHT+IG3+PUCAO/8ELd7L3fpgTuG/KKzGhdHfkztmZ1kLBBJfKykC4ur7GBo+SwGLH+hKx0U79ssRA==
X-Received: by 2002:a05:600c:474d:b0:434:f131:1e6d with SMTP id 5b1f17b1804b1-4365535fd93mr40310565e9.10.1734538588312;
        Wed, 18 Dec 2024 08:16:28 -0800 (PST)
Received: from [192.168.1.117] ([78.196.4.158])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656b01b73sm25160225e9.14.2024.12.18.08.16.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Dec 2024 08:16:27 -0800 (PST)
Message-ID: <4a746daa-74be-4abd-9583-47fcbab4dc35@linaro.org>
Date: Wed, 18 Dec 2024 17:16:26 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] system: Move 'exec/confidential-guest-support.h' to
 system/
To: Zhao Liu <zhao1.liu@intel.com>
Cc: qemu-devel@nongnu.org, Eric Farman <farman@linux.ibm.com>,
 kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
 David Hildenbrand <david@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Thomas Huth <thuth@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 qemu-ppc@nongnu.org, qemu-s390x@nongnu.org,
 Yanan Wang <wangyanan55@huawei.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Eduardo Habkost <eduardo@habkost.net>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Halil Pasic <pasic@linux.ibm.com>
References: <20241218155913.72288-1-philmd@linaro.org>
 <20241218155913.72288-2-philmd@linaro.org> <Z2L4seQo7Z7LPpTh@intel.com>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <Z2L4seQo7Z7LPpTh@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 18/12/24 17:30, Zhao Liu wrote:
> On Wed, Dec 18, 2024 at 04:59:12PM +0100, Philippe Mathieu-Daudé wrote:
>> Date: Wed, 18 Dec 2024 16:59:12 +0100
>> From: Philippe Mathieu-Daudé <philmd@linaro.org>
>> Subject: [PATCH 1/2] system: Move 'exec/confidential-guest-support.h' to
>>   system/
>> X-Mailer: git-send-email 2.45.2
>>
>> "exec/confidential-guest-support.h" is specific to system
>> emulation, so move it under the system/ namespace.
>> Mechanical change doing:
>>
>>    $ sed -i \
>>      -e 's,exec/confidential-guest-support.h,sysemu/confidential-guest-support.h,' \
>>          $(git grep -l exec/confidential-guest-support.h)
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   include/{exec => system}/confidential-guest-support.h | 6 +++---
>>   target/i386/confidential-guest.h                      | 2 +-
>>   target/i386/sev.h                                     | 2 +-
>>   backends/confidential-guest-support.c                 | 2 +-
>>   hw/core/machine.c                                     | 2 +-
>>   hw/ppc/pef.c                                          | 2 +-
>>   hw/ppc/spapr.c                                        | 2 +-
>>   hw/s390x/s390-virtio-ccw.c                            | 2 +-
>>   system/vl.c                                           | 2 +-
>>   target/s390x/kvm/pv.c                                 | 2 +-
>>   10 files changed, 12 insertions(+), 12 deletions(-)
>>   rename include/{exec => system}/confidential-guest-support.h (96%)
>>
> 
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> 
> (MAINTAINERS is missed to change? :-))

Yeah there is no entry for CGS in MAINTAINERS :(



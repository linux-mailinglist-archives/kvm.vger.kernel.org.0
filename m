Return-Path: <kvm+bounces-26546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F493975729
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 17:32:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF583B271D9
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:32:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 700001AAE08;
	Wed, 11 Sep 2024 15:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VsJe1jLW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D731E498
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 15:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726068736; cv=none; b=H4z6opmfpZDHxuUtt0CQTEpVB6qBkPi8lJ2DxSbH8YiYGV7jOAQ5BHyE60KbnILidH6KeVNFymafDYdip/23u6D493PvTWQci4HoO9E6D4dMx3TZiX/5UVAFWbxlRG3KUEh/TGMovURTcZZBL6rHI5qxaoFanrX+u6We8+bpxpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726068736; c=relaxed/simple;
	bh=UxqKZLv+m/Y4M78J/LFZfjnkxIeirs2vGc/4fCYig8U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d3ozITzQKI/QQCl94q5FG4StnnBSoEV/iAJrP8w8POcxXP+SIVHtlLxJQUbw/njVlv0mfwYAtaN1EQPAGZRAylLsOvNRhW6S4jIvA61tGW9+jrZ/cHh8E7jnv/OlxiimKAPp1nSibE1E5o1ZJRwos2wTMiIL7fIvyRRCp2gc0hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VsJe1jLW; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-7ae3d7222d4so1721780a12.3
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 08:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726068734; x=1726673534; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y9xV2TZChxQ5XF8GRBSAuhQm9XxO95EtIVwV6Hqv3wQ=;
        b=VsJe1jLWgMKC/5HNxzVp5mHQKkNsi6kDdr9G/KCPp78IvD6ICDXts6fZHFNov/8P4V
         nrcGir0vaqudkVDnxfTi8f4z+H2EqhxoGwVw2Im9I4XjFR8Mb6iQrvXC9JS2ZGBtlDR9
         iyIVnxouIhv3je8yCmguo1V401tZAmnhJ1fLOsVAWhzc7C3t40Uy7uhk+RTXf/3MCSSc
         1rWpXr6z5MjaO96pPyqYYpp7meVumB8Zfor8OOw9IwJnm3ovhzOPWRtnNZv60628PZ+u
         jK0talZh27taHpZ4nY7blanHwBnAEhSGIi6Sau6qE+JNzu2lF2qCBXpdnEyE3Fa9IaQb
         SPrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726068734; x=1726673534;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y9xV2TZChxQ5XF8GRBSAuhQm9XxO95EtIVwV6Hqv3wQ=;
        b=QqvmS6lMiEAfQER6xfX2yvjORP5XfDD3kVmw7XpBivY/WsWAg12vkQqXVFVRV0oYjX
         AnxaH2+FkBb7pVb2wqwG2Wucg+mq/XWhaMTs5vlmMNuF04gIIqGVXK/wIkV6wcJ+xYly
         4aypFBKd3NBf8B4pFFbRs8X4BG1mvmCatlN3uh25zOYnaouzkSigRcMaDvRKoJQIyg0D
         8enPDdkGLU3FiTJxwKpOUWGYp0qJF4etR9e0z3nqivz/1Tst/ZcvP1R8Mktfoj2rOlap
         611bIyd7XmE/vTs/UKTmgyCd5u9OcKZcKcNvtFGE3EBm41hW27XZjWAjMt0zautt9j2U
         soKQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/nARthzc/6c3gHRSmzZbEHQUuS293RN9iTkK75K6cTTGoSnfDR/L91VzvJQuEYb18o+I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyP2bY9Bsc+iod6hDuWspkARuc+m9BzgDux+k2baaU+kDE5cVjW
	uh2wvtKKpqbp+iRzifNahxW6nx3dLi+ITHc/7m7gHl293c14Yg7dTABr1qnuYAc=
X-Google-Smtp-Source: AGHT+IHsW5uOP/RaOllDCB0TLXsQjlnlosQgvXVaTG84PqVow4h1ijgneVn5RfrzY4pP4UlM86UxFQ==
X-Received: by 2002:a05:6a21:2d84:b0:1cf:2ad4:3083 with SMTP id adf61e73a8af0-1cf62ce253cmr6250911637.23.1726068734436;
        Wed, 11 Sep 2024 08:32:14 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00::9633? ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71908fc8205sm3131563b3a.21.2024.09.11.08.32.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2024 08:32:13 -0700 (PDT)
Message-ID: <45c6a39b-9c16-4580-ad6b-99973b5e6b0f@linaro.org>
Date: Wed, 11 Sep 2024 08:32:08 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 20/39] hw/ppc: replace assert(false) with
 g_assert_not_reached()
Content-Language: en-US
To: BALATON Zoltan <balaton@eik.bme.hu>
Cc: qemu-devel@nongnu.org, Zhao Liu <zhao1.liu@intel.com>,
 "Richard W.M. Jones" <rjones@redhat.com>, Joel Stanley <joel@jms.id.au>,
 Kevin Wolf <kwolf@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 qemu-arm@nongnu.org, Corey Minyard <minyard@acm.org>,
 Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 Keith Busch <kbusch@kernel.org>, WANG Xuerui <git@xen0n.name>,
 Hyman Huang <yong.huang@smartx.com>,
 Stefan Berger <stefanb@linux.vnet.ibm.com>,
 Michael Rolnik <mrolnik@gmail.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Markus Armbruster <armbru@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, qemu-riscv@nongnu.org,
 Ani Sinha <anisinha@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Jesper Devantier <foss@defmacro.it>, Laurent Vivier <laurent@vivier.eu>,
 Peter Maydell <peter.maydell@linaro.org>, Igor Mammedov
 <imammedo@redhat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>, Fam Zheng
 <fam@euphon.net>, qemu-s390x@nongnu.org, Hanna Reitz <hreitz@redhat.com>,
 Nicholas Piggin <npiggin@gmail.com>, Eduardo Habkost <eduardo@habkost.net>,
 Laurent Vivier <lvivier@redhat.com>, Rob Herring <robh@kernel.org>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, qemu-block@nongnu.org,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>, qemu-ppc@nongnu.org,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Fabiano Rosas <farosas@suse.de>,
 Helge Deller <deller@gmx.de>, Dmitry Fleytman <dmitry.fleytman@gmail.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 David Gibson <david@gibson.dropbear.id.au>,
 Aurelien Jarno <aurelien@aurel32.net>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Yanan Wang <wangyanan55@huawei.com>, Peter Xu <peterx@redhat.com>,
 Bin Meng <bmeng.cn@gmail.com>, Weiwei Li <liwei1518@gmail.com>,
 Klaus Jensen <its@irrelevant.dk>,
 Jean-Christophe Dubois <jcd@tribudubois.net>,
 Jason Wang <jasowang@redhat.com>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
 <20240910221606.1817478-21-pierrick.bouvier@linaro.org>
 <232858c7-6270-f763-adfc-b6c8259bf021@eik.bme.hu>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <232858c7-6270-f763-adfc-b6c8259bf021@eik.bme.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/24 07:10, BALATON Zoltan wrote:
> 
> 
> On Tue, 10 Sep 2024, Pierrick Bouvier wrote:
> 
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>> hw/ppc/spapr_events.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/hw/ppc/spapr_events.c b/hw/ppc/spapr_events.c
>> index cb0eeee5874..38ac1cb7866 100644
>> --- a/hw/ppc/spapr_events.c
>> +++ b/hw/ppc/spapr_events.c
>> @@ -645,7 +645,7 @@ static void spapr_hotplug_req_event(uint8_t hp_id, uint8_t hp_action,
>>          /* we shouldn't be signaling hotplug events for resources
>>           * that don't support them
>>           */
>> -        g_assert(false);
>> +        g_assert_not_reached();
>>          return;
>>      }
> 
> If break does not make sense after g_assert_not_reached() and removed then
> return is the same here.
> 
> It may make the series shorter and easier to check that none of these are
> missed if this is done in the same patch where the assert is changed
> instead of separate patches. It's unlikely that the assert change and
> removal of the following break or return would need to be reverted
> separately so it's a simple enough change to put in one patch in my
> opinion but I don't mink if it's kept separate either.
> 
> Regards,
> BALATON Zoltan

Mostly done this way because it's easy for creating many commits.


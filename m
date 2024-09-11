Return-Path: <kvm+bounces-26565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 12B1F9758D6
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 18:56:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B1CA81F23F2F
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 16:56:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B18A91B150F;
	Wed, 11 Sep 2024 16:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BFYiWUnK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6119B19755E
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 16:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726073762; cv=none; b=IQHu3UnyNvDyHxmiztAW8H52UrJJPUYpBK+kceFo0Y8sSjbwb2qeaQ86EhVTg8N7tOoRieHdb+EB2rwH3+Re+tooYfrZXsD/bXGnLDN2rLbw+Ltx6ey35w48gSpyrUdgpqmgTarg/dIGycoFW1cqePJOFhyUi/mHd39irSA0rMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726073762; c=relaxed/simple;
	bh=wRUN5lt/2DdnaayClQuhcb3gGe9Omu+nUiJ2bzZ65as=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UZ7RzcxqmIGVtjUeD2jxOlqZMsxzxdznyk1ub3aTVYMjSj1kwKRm7yfHauUY6QXQqGxMJ5rI92t6hkNXQ0Cp8i3FO4DMkpE/MkM9UW1LQx6HAlcHK3o1Xxf1+Zrg3gvTDbKQRiNa8wap7fKVCSjY4WmAtm/zRDJSo4pQZxvuSb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BFYiWUnK; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-27045e54272so3287fac.0
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 09:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726073760; x=1726678560; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jT2yfHOKQil4uehZcIK/2WmRn/qwChXA7I64h0o8Rrg=;
        b=BFYiWUnKHhHHBS1M/f70GeHLs23Cv64a9eyUDgWFQrltQM/BnUdgkQrMKtgUZ8lgTi
         3sP6u72yLJAdsgCIZC/Ih2MMsdEMeEEVf2fd9zB4VfU4OueBdcMmfgeLxIAnKl0cIW5g
         xtv8x1TBq0kjC9to7LTAiT8T5oR0/3wU6wktaQn1ReNBrPwc+e4c7nzmlCaXfvfRDhAa
         tkou597VsaXqDGHgJE8I0m6zWR5odvR3Lazi2N9hExgEl9VVk3HfC/581xvjf83C9QJ4
         nB+9HyxDPpj7Vpt8F0fcDHPZLSgBVatvy2a5qGf7dnyQirB6unozBKRcF0xHcD0RpAir
         3D5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726073760; x=1726678560;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jT2yfHOKQil4uehZcIK/2WmRn/qwChXA7I64h0o8Rrg=;
        b=IYgREoBML+YNg8HMVnwZFDSR7P82QT+ejF5TRIPL1jCkMokaYWIFOyq45/0DEzjWuh
         rrWxptqnGA7Tld4UN3DKH8ZQW1k9X+aQMduXex+w+dMe8pQc4eFjnq94mL323+SXqnP1
         5BoQmvmHjvz2KMZmZWVl8KEbeh7WQLEvLuJCR4ntIpyjr+UgS/MujdcI18DxPvBBoHUL
         twN8UFnwQfcSZdHv9jO7SFSfuYb7OLej1sAv/KBim2u1lXaOcnoSoLANK4xXvIoELXLI
         2tOLZsBcdFT7C1MMavBqZLTgdcbKjIjHrLU4Jz7m3V9rw/LK8DNHj7YFsG7f5m4gPGN0
         rUhA==
X-Forwarded-Encrypted: i=1; AJvYcCWJ64Gmk8B9jiMEvNxAJmrqSkgAVblktTsZsWMlvKKJw/Mj3LKV0joLbUP3ijtNe/c2U8M=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFIMvc5JdI5A7jGUYTezfouigimHkn5q1I+IaByQCbBdBJev2J
	CH7hqZqktQmYrhfVSXOd+BeiDLSRvuAuV3oRekbOb+CGjnn8sL5pbAPG+nezhfg=
X-Google-Smtp-Source: AGHT+IHm6lZ+zYd6OLElv1nSKeE8E+EcYdnIUsM2//Be/MFCqecYcYkqJpKvjCJcxFiRHPU1Pk0c9g==
X-Received: by 2002:a05:6870:df48:b0:27b:b2e0:6a5 with SMTP id 586e51a60fabf-27bb2e00bd5mr7219953fac.3.1726073760261;
        Wed, 11 Sep 2024 09:56:00 -0700 (PDT)
Received: from [192.168.0.4] (174-21-81-121.tukw.qwest.net. [174.21.81.121])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fbb5414sm210156a12.23.2024.09.11.09.55.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2024 09:55:59 -0700 (PDT)
Message-ID: <e9bac0e4-ee34-4634-a6a2-73854a45d7d6@linaro.org>
Date: Wed, 11 Sep 2024 09:55:57 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/39] docs/spin: replace assert(0) with
 g_assert_not_reached()
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 "Richard W.M. Jones" <rjones@redhat.com>,
 "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Eric Blake <eblake@redhat.com>, qemu-devel@nongnu.org,
 Zhao Liu <zhao1.liu@intel.com>, Joel Stanley <joel@jms.id.au>,
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
 Fam Zheng <fam@euphon.net>, qemu-s390x@nongnu.org,
 Hanna Reitz <hreitz@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
 Eduardo Habkost <eduardo@habkost.net>, Laurent Vivier <lvivier@redhat.com>,
 Rob Herring <robh@kernel.org>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, qemu-block@nongnu.org, qemu-ppc@nongnu.org,
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
 <20240910221606.1817478-2-pierrick.bouvier@linaro.org>
 <zkyoryho5alnyirnl7ulvh5y6tkty6koccgeygmve42uml7glu@37rkdodtlx4f>
 <bwo43ms2wi6vbeqhlc7qjwmw5jyt2btxvpph3lqn7tfol4srjf@77yusngzs6wh>
 <10d6d67a-32f6-40fc-aba9-c62a74d9d98d@maciej.szmigiero.name>
 <20240911125126.GS1450@redhat.com>
 <6818337d-ba58-4051-8105-05f679f71b88@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <6818337d-ba58-4051-8105-05f679f71b88@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/24 08:25, Pierrick Bouvier wrote:
> On 9/11/24 05:51, Richard W.M. Jones wrote:
>> Although it's unlikely to be used on any compiler that can also
>> compile qemu, there is a third implementation of g_assert_not_reached
>> that does nothing, see:
>>
>> https://gitlab.gnome.org/GNOME/glib/-/blob/927683ebd94eb66c0d7868b77863f57ce9c5bc76/ 
>> glib/gtestutils.h#L269
>>
>> Rich.
>>
> 
> Interesting.
> At least gcc, clang and msvc are covered, this should be ok for most of the builds.

All of that is inside #ifdef G_DISABLE_ASSERT, which we will never set.


r~


Return-Path: <kvm+bounces-26604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CEA5975DF9
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 02:28:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 715C31C22725
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 00:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED16A46BF;
	Thu, 12 Sep 2024 00:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vrfMQaF6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEA163CB
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726100912; cv=none; b=QgJDYjHma+Y9+mz6W7l/dmWMZw6SE/qkFT/N35nCOJ5WMIzZwBjQg3yk9ksTIEUiWga3j6/aGtIw8xlfVym1TNF3ytLG409oMuqx3bdL8drz1OJGzA/Gw2ysVnFyya4xd6j/1LNII2Q+Im3CSfx51KHqlc/xhFfyU4ffwbNn9xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726100912; c=relaxed/simple;
	bh=J2JpUYErlL4g4HomSmRzvF37GGprKRc+5g9//gbviXY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kc5U3gYB7LB2WNalm5EgDg14dPL+ka4sKXxoDCNDgpxTUCpL+aOaCHWTBF5EtCf2e/CMkQTViD+ggzXwSiUTmxhYnN1wAPbZwpdg6HkVRamQEGnH6lG5Z0q/I/gW6Z6xN5MGGynSTIvLkBOXYCcKuAtaeAIxEjZCHJG60esDrGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vrfMQaF6; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-7d50e865b7aso391366a12.0
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 17:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726100910; x=1726705710; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c9o7/Cb/II9t2dUk/lFV7V5FBEJVmX+kPV3LL4olG50=;
        b=vrfMQaF67e4bAWbnHyNrnxKsUAEat24vIed00FFpI2Rhn2vKxa0j7/ybvFBMPPvx+P
         U+ssgscMjvymzsVmpfXOe8rux9sjyKe3PCDRr44ULO2V6KLWTmAkeHpY8PwvHTYutS5N
         3w7uMzoMH4cE+LV88l3q6gyNk9R5+fyhUg8pjvKEy7X7DCKyVKJy3KvSSlqNAO53LVn7
         ayuYCm4Hkr0gFsMw3XIOjDHD5mTXQiTaK87TjLxXTj52X6uyZPB+XCp6ptMqdsMgUCSw
         oIKt+x5zzj+51UrjkKCm/rM01R+ICpijXl7fCUJTvT5WF5hqKHUDCiLgO8N7jAhpZWUN
         XgAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726100910; x=1726705710;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c9o7/Cb/II9t2dUk/lFV7V5FBEJVmX+kPV3LL4olG50=;
        b=rX+FN0AlfZrhodc5N3SNXhfjjj3ZoPBLzH9t23J8Mhn+nfMyijfHQ5Vj6wIdTSdZsC
         kFcyc1lk2AqddaMxkTHT5n9z+Ew1J0xdCT+5fW9kWvPpssUtKjV7IBGomQE6rLQlTGIX
         964nboNXzsKMJCjtPdMsZzrJj5J6PNT3qr0QaMQTtlUana/VOPetwN0T+Bzse1grFc7R
         djm8OlByWSftWOcfJ6rwSwuadSge6QatFfZRCNrf6MPZ3gCXZ1PUO7nrzoybQlRSCj8M
         UlvHMC2QRcQB6ZaVxIawnam5X4cE2P3YYvE3BtawPkjQkHIpQZOYmTNlCOlxYIBr3ux1
         aTMA==
X-Forwarded-Encrypted: i=1; AJvYcCWgFbKcKxoCRTjOFqDFMZCwQ4wTn0c0E+q9xe1lcjPBk7dPYsr1GJl7xVjFvjO7MRQ+zo0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpMyGmrQy9Se/PKvYqsESMZvH/SGgFYCwxGBrtuCFD1UAc7EEo
	mKNXrxcwnprlNeex9+ozWAZewIlFx7g15MYPTNtJRSppd8GvruwOLyuPdflQ8nk=
X-Google-Smtp-Source: AGHT+IG/+agFR+owCifK6LN7nBFHTLHqk0umycTEk4Q5c9uh7VrVH7bVyDXkjOez5N5fvomBj8Vk0w==
X-Received: by 2002:a05:6a21:4581:b0:1cf:4458:8b27 with SMTP id adf61e73a8af0-1cf764afde6mr1438134637.46.1726100909723;
        Wed, 11 Sep 2024 17:28:29 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00::9633? ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-719090c37efsm3523445b3a.187.2024.09.11.17.28.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2024 17:28:29 -0700 (PDT)
Message-ID: <7328179f-dbc8-46da-8b87-1077a706acc7@linaro.org>
Date: Wed, 11 Sep 2024 17:28:26 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/39] docs/spin: replace assert(0) with
 g_assert_not_reached()
Content-Language: en-US
To: Thomas Huth <thuth@redhat.com>, "Richard W.M. Jones" <rjones@redhat.com>,
 "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Eric Blake <eblake@redhat.com>, qemu-devel@nongnu.org,
 Zhao Liu <zhao1.liu@intel.com>, Joel Stanley <joel@jms.id.au>,
 Kevin Wolf <kwolf@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 qemu-arm@nongnu.org, Corey Minyard <minyard@acm.org>,
 Eric Farman <farman@linux.ibm.com>, Keith Busch <kbusch@kernel.org>,
 WANG Xuerui <git@xen0n.name>, Hyman Huang <yong.huang@smartx.com>,
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
 qemu-ppc@nongnu.org, Daniel Henrique Barboza <danielhb413@gmail.com>,
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
 <c62bed1a-a13d-49eb-aec2-54bfe78dd1e5@redhat.com>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <c62bed1a-a13d-49eb-aec2-54bfe78dd1e5@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/24 09:13, Thomas Huth wrote:
> On 11/09/2024 14.51, Richard W.M. Jones wrote:
>> On Wed, Sep 11, 2024 at 02:46:18PM +0200, Maciej S. Szmigiero wrote:
>>> On 11.09.2024 14:37, Eric Blake wrote:
>>>> On Wed, Sep 11, 2024 at 07:33:59AM GMT, Eric Blake wrote:
>>>>> On Tue, Sep 10, 2024 at 03:15:28PM GMT, Pierrick Bouvier wrote:
>>>>>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>>>>> ---
>>>>>
>>>>> A general suggestion for the entire series: please use a commit
>>>>> message that explains why this is a good idea.  Even something as
>>>>> boiler-plate as "refer to commit XXX for rationale" that can be
>>>>> copy-pasted into all the other commits is better than nothing,
>>>>> although a self-contained message is best.  Maybe:
>>>>>
>>>>> This patch is part of a series that moves towards a consistent use of
>>>>> g_assert_not_reached() rather than an ad hoc mix of different
>>>>> assertion mechanisms.
>>>>
>>>> Or summarize your cover letter:
>>>>
>>>> Use of assert(false) can trip spurious control flow warnings from some
>>>> versions of gcc:
>>>> https://lore.kernel.org/qemu-devel/54bb02a6-1b12-460a-97f6-3f478ef766c6@linaro.org/
>>>> Solve that by unifying the code base on g_assert_not_reached()
>>>> instead.
>>>>
>>>
>>> If using g_assert_not_reached() instead of assert(false) silences
>>> the warning about missing return value in such impossible to reach
>>> locations should we also be deleting the now-unnecessary "return"
>>> statements after g_assert_not_reached()?
>>
>> Although it's unlikely to be used on any compiler that can also
>> compile qemu, there is a third implementation of g_assert_not_reached
>> that does nothing, see:
>>
>> https://gitlab.gnome.org/GNOME/glib/-/blob/927683ebd94eb66c0d7868b77863f57ce9c5bc76/glib/gtestutils.h#L269
> 
> That's only in the #ifdef G_DISABLE_ASSERT case ... and we forbid that in
> QEMU, see osdep.h:
> 
> #ifdef G_DISABLE_ASSERT
> #error building with G_DISABLE_ASSERT is not supported
> #endif
> 
> So in QEMU, g_assert_not_reached() should always abort.
> 
>    Thomas
> 

Yes indeed.

For further information:

g_assert_not_reached() expand to g_assertion_message_expr(), [1]
which is a function marked noreturn [2][3], so indeed, it always abort.

[1] 
https://gitlab.gnome.org/GNOME/glib/-/blob/927683ebd94eb66c0d7868b77863f57ce9c5bc76/glib/gtestutils.h#L274
[2] 
https://gitlab.gnome.org/GNOME/glib/-/blob/927683ebd94eb66c0d7868b77863f57ce9c5bc76/glib/gtestutils.h#L592
[3] https://docs.gtk.org/glib/macros.html#compiler


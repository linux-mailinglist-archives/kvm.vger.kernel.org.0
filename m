Return-Path: <kvm+bounces-26543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0A899756EA
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 17:23:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E05E8281C2A
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDBFF1AC43E;
	Wed, 11 Sep 2024 15:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WkCu7XoC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8899B1AC42D
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 15:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726068214; cv=none; b=u/hYp6sv/kWNlVxTpXInK0bFDRl/lWhTHafrcCBe8RGWmQ9C1/eN060RCt2Op6SnsG0pGOqGUgpjm9qRrIIWmr3I+2MjCPxdYvy6ijBKqqYokXIypyJCt1t8cD4RHzdNZNKZCJ+mRbWD82SM5C5rn3dI9Eni99/cxk4NSth/SGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726068214; c=relaxed/simple;
	bh=544eiZ6X/OVmhKjmjLXx31n2LiE2w5qDhV1wtd5gXp4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u2l9ImiOp8rbykGX1yWn3iIhI6xASie89MPWYSHYomnONkRjFRyEcqIRFl3dFwsgdLkE/78h+W1dXvWesOaZWTDwXO0I5Mijeg1BNmwWle4B6bFzaNqTp4oot8aLALsLyrpP7Eu0VKV9aKXWgiApwdZtXc3MACnvKD2GYjIigoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WkCu7XoC; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-7b0c9bbddb4so4771275a12.3
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 08:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726068211; x=1726673011; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OuvMeDUVp0mbaD2Ccta77meu7WyU6zTm7qPRf/MNjOo=;
        b=WkCu7XoC2NKofffyDtQrUbqvWh3OtDTT3xohyMkR8u1bvojfBIhOPOMj1G0rg3+Um3
         vIiQIkANic4wBMyGeEK1n47QEWBpNv6ASdlGqdGcsRXMxH6GOhINLM8chlv50CfRZJkm
         YPvubjuPnH+41acdjoQdajCL0rpORoqXV7iDfkWBRWUwtCmRp4X8HDaZN8NwoLEaiRVn
         7Uqnu/rUGpZIfRqn1EKp/QJ30mSLCFzr9afjj9DNB8a0GfZOMtNjuzfADYAy+H4PF7Hn
         IOhn1s7ax+cLH50jOVY3gDuZwi/W1l604sGh4H381QFuT6cJU1YeQGmjN36jrOvrJHgO
         3mqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726068211; x=1726673011;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OuvMeDUVp0mbaD2Ccta77meu7WyU6zTm7qPRf/MNjOo=;
        b=XcNMXSPd8rzgBuySjiJbsSNNf110igEqdXODWOgSR027MEgyfrVJUQQzgJheKpFn4r
         P/YSSKNIiP8u7N+It9sp/+gRg/uBN9AXZ3gI5NmQYGj+NtaBDtS6ZK1U/i1Rhmz1nQPm
         93S0z1O47VZFxrWCj1EwiKvgH1sM8y7n4LWQo475P3ulGUSFaruIGQGdl2Lt5ksGC25/
         utN7Vszpx5OMiTCQcTCmUpeza48dGrEdAVTdEB9oMDFiAqZ8D1LNWoEQxEgrmLIa6mZL
         JjhzR4p51ydXNi+PIqNCrTF5TPIakYnu+Oif/eg1tO7fJS0FmSIY0PwuTTqXTlrJohWW
         J4VA==
X-Forwarded-Encrypted: i=1; AJvYcCWzlVAJs0AKzID6CgX8ABgnIXN0JQYHhMER7Jul8ABLy2T4/+L6P4qF4HUgaaPue9fwIEE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJol4wwjd5tHCKdq9ilfLDbm1bQLZxiQEenN7lt+6KAakLuk3S
	fLF4UvQcSZn7U9KrGKwj7cMZuwvFgw/lI/1ND9KfXLxKGz957Kn0DhSPPS39Zu8=
X-Google-Smtp-Source: AGHT+IFVEaQbbNIN6u4ycMxcdISjFC11x2LnDF31jXta/zBjlVjuD+C9lapW5FnwVoc/RuMXV2R+aQ==
X-Received: by 2002:a05:6a20:d809:b0:1c6:fb07:381e with SMTP id adf61e73a8af0-1cf5e1aba0fmr5779831637.44.1726068210675;
        Wed, 11 Sep 2024 08:23:30 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00::9633? ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71908fe4e7esm3102009b3a.80.2024.09.11.08.23.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2024 08:23:30 -0700 (PDT)
Message-ID: <510bda9d-031a-4235-aee3-119c5f8865ea@linaro.org>
Date: Wed, 11 Sep 2024 08:23:23 -0700
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
To: Eric Blake <eblake@redhat.com>
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
 <20240910221606.1817478-2-pierrick.bouvier@linaro.org>
 <zkyoryho5alnyirnl7ulvh5y6tkty6koccgeygmve42uml7glu@37rkdodtlx4f>
 <bwo43ms2wi6vbeqhlc7qjwmw5jyt2btxvpph3lqn7tfol4srjf@77yusngzs6wh>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <bwo43ms2wi6vbeqhlc7qjwmw5jyt2btxvpph3lqn7tfol4srjf@77yusngzs6wh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/24 05:37, Eric Blake wrote:
> On Wed, Sep 11, 2024 at 07:33:59AM GMT, Eric Blake wrote:
>> On Tue, Sep 10, 2024 at 03:15:28PM GMT, Pierrick Bouvier wrote:
>>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>> ---
>>
>> A general suggestion for the entire series: please use a commit
>> message that explains why this is a good idea.  Even something as
>> boiler-plate as "refer to commit XXX for rationale" that can be
>> copy-pasted into all the other commits is better than nothing,
>> although a self-contained message is best.  Maybe:
>>
>> This patch is part of a series that moves towards a consistent use of
>> g_assert_not_reached() rather than an ad hoc mix of different
>> assertion mechanisms.
> 
> Or summarize your cover letter:
> 
> Use of assert(false) can trip spurious control flow warnings from some
> versions of gcc:
> https://lore.kernel.org/qemu-devel/54bb02a6-1b12-460a-97f6-3f478ef766c6@linaro.org/
> Solve that by unifying the code base on g_assert_not_reached()
> instead.
> 

I'll add this to messages. Thanks.


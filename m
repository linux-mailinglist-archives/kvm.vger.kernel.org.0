Return-Path: <kvm+bounces-26706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 476D597686F
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 13:59:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C915E1F2277A
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 11:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D1B71A0BE0;
	Thu, 12 Sep 2024 11:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fbGxoDNp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C47D1E51D
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 11:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726142362; cv=none; b=VOU21kMZcvaYJoNTznd0oZ+EI4aZ4ZUQoPnl4ks+oisbTzMOPsGz5UOPK683JzzssShTYeFegwxcLbKsgqbGeN4ekMqhno4C5WXW4a08up4zkVb8+mGKeHbs5ZfbIeZaA2wmood0bhFmKzBmfnT47A7XwInPu/hpATmvOHfFhTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726142362; c=relaxed/simple;
	bh=5abTwEKft9jU7cjXsgMqdTTVoTn4hWiWunILFWL3JpQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vl1b7MYVNlJL7jw9OBVwU4zOG164Q/vgg692tWvP+c/8jwnrAOcN1TmHv0IxWvJT5Hu5sp3LSv+AtM4qqb0pRoSLG3J36oecSszZjUF6fIf6Ai/gxqvkQJdOb3M75TX846m125D5fM5NeYYCMK/PeaxPVpSUu/v5ptGiShip3N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fbGxoDNp; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-42cbbb1727eso7148565e9.2
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 04:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726142359; x=1726747159; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S9hH4zorKUC2orkfwALmr2q6s1FZ/UxiA+b+T0QKDfM=;
        b=fbGxoDNp03GY4itUV8T8juwbsP8/V/0SUx2NenCJmbR/isc/KC6DHvF5YeT3mRCeVy
         YcNWWvhXBSsZGsnt9KGKpFi126DcCY/SEDGkBBVafYNyn1/29yJYtSgRlzVPO51j1Xvo
         cuzPG2xUGRX3/eOiY0hcoi3Kkl++Lafs5CepDgUTeCYBbcDY0bvfCOY0F6WQk/wh+It4
         fxnNWRxA7tHrmuc7kW2OlAyGabQ4JIO2RXNQiBsQY6tpN+cMvbMjOWf/K1snpkOAD0bG
         djziYM7P7GkV/vzwe8jBivszMqcHJ0F8JfM196KlmbNiU6vwSA2C8MWbThPlsocOfiwT
         J9rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726142359; x=1726747159;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S9hH4zorKUC2orkfwALmr2q6s1FZ/UxiA+b+T0QKDfM=;
        b=MmGMeA3e4drmfA4TMg/KdVrVaeNd0XDdC4q0wGrhEL8UgDkmjUt4EzDIQxCvbmmKIw
         /osOp9SymxCp6z5ZOvvL+4cvQUe+bi6lJEdnPkRa3obIvyO0SV6/CqxMlzEhY2I3Xwfe
         THtGxF+M75Q/ykgux5VkqZX0q0ihLi33wAhb7sNVGPOyqgGa7InnbFgkD+CWGKxhXThn
         3cB95xKsxusoipxzdzy7FFgL1c0iGja6w75vQdEYbNOk69QGYswomVy7EDTvjrJr7cWU
         qZ+v4h9w8In53tEClqzWya8qtZZbZ5huD5eqrALIkx8OG/NoDv6OE2bwgsmDuNxdVQvx
         piNg==
X-Forwarded-Encrypted: i=1; AJvYcCX5i4ZfZQRRyy/sLCON74B9NdpmEgxgj5Sfb45qfZ+PnMaqTtCgh9sazh/0yX9XUDfvJ40=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0+jrX20Twlp3mcvu7ps6bK3s1C1WVyueFISDIiX0elXGH3xIT
	pFfe5yANybIWXWbfwiY/l03UChLd+p4v4phfLKrfABqn39SKdEazdNZpryRSYj8=
X-Google-Smtp-Source: AGHT+IHdMYpvkErKC3W9i3z+Ft8XhpOoUilHTYrpJoqTJq/qhlwtnn61XatlsIjXjk2IjSojx5FOxQ==
X-Received: by 2002:a05:600c:1c28:b0:42c:ba1f:5452 with SMTP id 5b1f17b1804b1-42cdb57c022mr22778035e9.25.1726142358622;
        Thu, 12 Sep 2024 04:59:18 -0700 (PDT)
Received: from [192.168.1.102] ([176.176.161.148])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42caeb44887sm171920365e9.23.2024.09.12.04.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Sep 2024 04:59:18 -0700 (PDT)
Message-ID: <a0608783-d6d8-4ccc-a431-5fc1e96e0021@linaro.org>
Date: Thu, 12 Sep 2024 13:59:12 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/48] include/hw/s390x: replace assert(false) with
 g_assert_not_reached()
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Jason Wang <jasowang@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Laurent Vivier <lvivier@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
 Klaus Jensen <its@irrelevant.dk>, WANG Xuerui <git@xen0n.name>,
 Halil Pasic <pasic@linux.ibm.com>, Rob Herring <robh@kernel.org>,
 Michael Rolnik <mrolnik@gmail.com>, Zhao Liu <zhao1.liu@intel.com>,
 Peter Maydell <peter.maydell@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 Fabiano Rosas <farosas@suse.de>, Corey Minyard <minyard@acm.org>,
 Keith Busch <kbusch@kernel.org>, Thomas Huth <thuth@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, Kevin Wolf <kwolf@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jesper Devantier <foss@defmacro.it>,
 Hyman Huang <yong.huang@smartx.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 qemu-s390x@nongnu.org, Laurent Vivier <laurent@vivier.eu>,
 qemu-riscv@nongnu.org, "Richard W.M. Jones" <rjones@redhat.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Aurelien Jarno <aurelien@aurel32.net>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, kvm@vger.kernel.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Hanna Reitz <hreitz@redhat.com>, Ani Sinha <anisinha@redhat.com>,
 qemu-ppc@nongnu.org, =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?=
 <marcandre.lureau@redhat.com>, Alistair Francis <alistair.francis@wdc.com>,
 Bin Meng <bmeng.cn@gmail.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Helge Deller <deller@gmx.de>, Peter Xu <peterx@redhat.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Dmitry Fleytman <dmitry.fleytman@gmail.com>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 Yanan Wang <wangyanan55@huawei.com>, qemu-arm@nongnu.org,
 Igor Mammedov <imammedo@redhat.com>,
 Jean-Christophe Dubois <jcd@tribudubois.net>,
 Eric Farman <farman@linux.ibm.com>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>, qemu-block@nongnu.org,
 Stefan Berger <stefanb@linux.vnet.ibm.com>, Joel Stanley <joel@jms.id.au>,
 Eduardo Habkost <eduardo@habkost.net>,
 David Gibson <david@gibson.dropbear.id.au>, Fam Zheng <fam@euphon.net>,
 Weiwei Li <liwei1518@gmail.com>, Markus Armbruster <armbru@redhat.com>
References: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
 <20240912073921.453203-15-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240912073921.453203-15-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/9/24 09:38, Pierrick Bouvier wrote:
> This patch is part of a series that moves towards a consistent use of
> g_assert_not_reached() rather than an ad hoc mix of different
> assertion mechanisms.
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/hw/s390x/cpu-topology.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

We usually don't precise "include/" in patch subject:
we treat include/FOO as part of FOO area.


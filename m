Return-Path: <kvm+bounces-26462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71B53974A35
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 08:13:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3311A284892
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 06:13:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9A56136982;
	Wed, 11 Sep 2024 06:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LEATmzNk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6E37E0E8
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 06:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726035196; cv=none; b=rJdl5CSvl7DtQH70QkKvSOT9pIykJIM3bI7jvLXXJjSQKrd0N+GmW3qhqsSc4LpF1tBf4ySQTnlkbhVtpPSQHJaAnmUa8uC/xsC2CEJweRhh7kanh9WD0OC7tJAyZYi1r0uziZDL2b4y/dL/Kvp7b1T39twU5F2QAY2jZND1c3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726035196; c=relaxed/simple;
	bh=xHubOMzh8Nts/Rs5aeegoIBxNfLz0WD3cAYq1alISz8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lt8aVgypy7e3WpS82+bkIOnDshg1NUecYbZjOg8kYlNJLzC5T1/G8NEWabslc6lXtdVWHSvtoDYx8/q7WwTklgVQsxPYqBB6v7DZ1Q+7A81fb8ipSO3SmigYWzHdS1JbAT51tQuMQx+yUb6Y5EdV7IwF+zGTHL9hmi/AH4BY2NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LEATmzNk; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2f74e613a10so11683871fa.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 23:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726035193; x=1726639993; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J7LpRf93BAnXiOmKt/ZSNjq40Q0BcySlR1uVQMFuyR0=;
        b=LEATmzNk2yJD8CNMCHagm+8G1EKq5UfrAXvXXIbonyCa7N04FhZsOxg7yKekDqNCV5
         ibd3wtkrnMWbeKo24IxkWL2tcXqAgdhF8NDB+2cFAGbANlOORduLxnoxg+x9Q8FpVAI2
         TIJfQ8MzwRXMOWJgVwWVn+zMSUyCgBvbfHIIXpxkby4wx2Qd5498RYs2IST01YRM8/Zo
         s0XrW7bzAFhjI4fs7IGD+lDTMKngD5/BWPXB63htSxGWWhPZBTy3PnA1bc4dfX9TkcUz
         35gce9mbiuOpN64uAzZ8a+SZbBVntewokDjcFer16zhuxK8SUZ2Wnm4Kw46BEW9ARtr/
         Udag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726035193; x=1726639993;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J7LpRf93BAnXiOmKt/ZSNjq40Q0BcySlR1uVQMFuyR0=;
        b=hBEergDF4pg7kf36eldFNMcCbj8LoluZW2a3b7r7sA7CztUP0ehkaHNs+SPI8r0LaN
         /1M+9PsWaF0oEYOs9fXc7KEEDhCZU2giWHdI4xyrIDwoYDe2Q7B+73t+krqY+0fAWxZr
         rrKo+swPqRB2+Jll9Fk4JIhcPRLgHznP3jbQyRfBBROK8oiA80dtUZemAG1MQHD0t0kN
         JCOo4c6aAOJXFPBhK5hRxjHd7qTohLMj+UronfPgWCaH6GHCJ3cl6iNmK1SFdUXrAKSj
         1CqmIWywrC9BOqzhklTxNxxHfP7ygoUP5z7Ij+UG8xazp577z4kTgyZx8ukzIT/ZuAX3
         ER4A==
X-Forwarded-Encrypted: i=1; AJvYcCVU/eCVuOc+iQb2/5YTfZ1ZZ8T0c+wx60YukkkcacBCIGaQ4lS0zTa9EyKwAOpAl+ekFcE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwR1JT5mxnmLvMRIu6WpvtVHkYHmkofS97Js7qzBa+hCs9/tRYZ
	1VcCY160s8vwSrPMIFw4GXJjyRkwWm2rYOf0CpDqK1r5S7Qc0MSjXoYFpFXpNcM=
X-Google-Smtp-Source: AGHT+IGgGKQ0AEU6HNcJt5DsM3mDmTwInbpRDGWNVq2w7Th+CmIVLvrwWJibFdq1qjuzb4izFD22Gw==
X-Received: by 2002:a05:6512:1048:b0:533:4620:ebec with SMTP id 2adb3069b0e04-536587a6885mr16134873e87.3.1726035193184;
        Tue, 10 Sep 2024 23:13:13 -0700 (PDT)
Received: from [192.168.69.100] ([176.187.196.107])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25979e90sm573426166b.72.2024.09.10.23.13.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 23:13:12 -0700 (PDT)
Message-ID: <6efcf085-2118-4d70-b31c-56536179c615@linaro.org>
Date: Wed, 11 Sep 2024 08:13:04 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 28/39] hw/misc: remove break after g_assert_not_reached()
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>, "Richard W.M. Jones" <rjones@redhat.com>,
 Joel Stanley <joel@jms.id.au>, Kevin Wolf <kwolf@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Corey Minyard <minyard@acm.org>, Eric Farman <farman@linux.ibm.com>,
 Thomas Huth <thuth@redhat.com>, Keith Busch <kbusch@kernel.org>,
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
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>, qemu-ppc@nongnu.org,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
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
 <20240910221606.1817478-29-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240910221606.1817478-29-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/9/24 00:15, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   hw/misc/imx6_ccm.c | 1 -
>   hw/misc/mac_via.c  | 2 --
>   2 files changed, 3 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>



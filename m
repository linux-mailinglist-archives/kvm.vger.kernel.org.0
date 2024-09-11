Return-Path: <kvm+bounces-26464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 456F0974A37
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 08:13:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3BD31F24F23
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 06:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E1197DA6A;
	Wed, 11 Sep 2024 06:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d803YQ21"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1201D76C61
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 06:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726035220; cv=none; b=cgc2fg5bvFYgQiznx0rW/9rAjMLtXg+Ktj5FaRsiiEDvM0i9ZCU7BNLWoxBei0J0hRU4c2QuU2XtQk3oZ23X1a3dU2ATOz74U1oZ5V5wiEE4yONBygNlNGcCizwEZCIhevBlaH/M7diR7mpWtkoas8G9kC5H2YOI+rrA6yg2wP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726035220; c=relaxed/simple;
	bh=Boj/Gu+3Fq8YhTZmHNTHa9WRxy5THPtpSqQ5B7YTtrs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r71PJ2zZoiIGhWw3uDkrycIv8oOInhPuyiL4Lbt4M31fMqf3lmTRdXKlacdaO8s7lO+wXxrh7PfObsn6bzdJ3p+xZVCAOecSxtesG8dqYLFJx82jRwZIr0YPLWKPRJltr7scRULRDCcJ48fLFEl+0zxVc/2fwtTxfiYeI7Qe7cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=d803YQ21; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a8d24f98215so566560366b.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 23:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726035217; x=1726640017; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=poAudXl/SIIw/XPRvz0lT3oV27sGXK44B6oZsCmnODk=;
        b=d803YQ21MldQsRFEO/MC+qlzzj95bvs2gKCQvd/oHe9XrjMTjrxCb6veqH7Nw1rsy4
         EF+2zJQr7hXxbGjidJe2wAH7Fgyuew0r/mumPJb1seH/be0128FF89aTjMO5VVM5CB1d
         WT0qdYptk1X/9UDaKaWHVcHoeM+jyATFkBs3Vfy3mo7OetZuIuix/9qfmQKUw8yj2AaR
         hAP68yVClaXalvcZdqEfaAlo+cD77yS8tbAYNPiSWyC3Ngmk1ky77Lh8rwy39Rq2ZjDe
         PeEY6O0u6cGNgnzKe7K00h7IyKEjPJJxzwCEIX/7ZhjCF/6uqlBOELkmb9qjP5jgY4QF
         6ndg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726035217; x=1726640017;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=poAudXl/SIIw/XPRvz0lT3oV27sGXK44B6oZsCmnODk=;
        b=q8/YmovGwBaN6arBU+lKdeTITU6vtxLgEmGqQpsPhICAjmt6HledYfjRylK4JWxaLT
         z+Z8byCoD0si5VP/ld1Kn9LcMr7XBoMxPV79mT5yClr/WPtxTWzlRI2+mdmtyMJxvUrC
         v/0E0GK+ai0d4F3GlK2uFPzdW7rFn8xa33iP3S7RvB2PV52hwrAeAOcWRAqATS47BwCl
         sETFWYMy/EGx4F/3cST/GNw/5L3ehctf86gSbmlyslYgRaoaUhoDQqwCmVcVYetPYKX6
         H31Tu/VZIgQUeShPVO0n7HLDnsWCK9kBnZLlozR4ag3zcMjz1QzO2yfjESvKX7S7tqcu
         7y2w==
X-Forwarded-Encrypted: i=1; AJvYcCXRrQn+426ucYy76nkF0g8PVFCJmhCbB7vIZWX5MxU/5Vs1bTq2JQxSSPr4q+4aUfmSS44=@vger.kernel.org
X-Gm-Message-State: AOJu0YyG/1uZoztK3gDN6F+uUi/zfHEtf2II4VzRyAHK31uclkcE50c8
	NQ/15keI6LGnl0vDqwEbMi3DbB6UZtfbI0/Z2pKDkKp5SuHRY/uqgEQT9PJTB44=
X-Google-Smtp-Source: AGHT+IGxSIV12l24qw5tuVF8BHzeUm7qf/id1NqLdpbzEe6nCFQXxSFQeScbp7YFg/szcxgjwvBm3A==
X-Received: by 2002:a17:907:60cb:b0:a86:799d:f8d1 with SMTP id a640c23a62f3a-a8ffad97d26mr288054766b.47.1726035217121;
        Tue, 10 Sep 2024 23:13:37 -0700 (PDT)
Received: from [192.168.69.100] ([176.187.196.107])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25ced1e0sm570162366b.164.2024.09.10.23.13.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 23:13:36 -0700 (PDT)
Message-ID: <2993dcdf-b8b8-48f3-b322-a121989559a7@linaro.org>
Date: Wed, 11 Sep 2024 08:13:28 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 36/39] ui: remove break after g_assert_not_reached()
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
 <20240910221606.1817478-37-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20240910221606.1817478-37-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/9/24 00:16, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   ui/qemu-pixman.c | 1 -
>   1 file changed, 1 deletion(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


